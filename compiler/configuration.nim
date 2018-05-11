#
#
#           The Nim Compiler
#        (c) Copyright 2018 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.
#

## This module contains the rather excessive configuration object that
## needs to be passed around to everything so that the compiler becomes
## more useful as a library.

import tables

const
  explanationsBaseUrl* = "https://nim-lang.org/docs/manual"

type
  TMsgKind* = enum
    errUnknown, errInternal, errIllFormedAstX, errCannotOpenFile, errGenerated,
    errUser,
    warnCannotOpenFile,
    warnOctalEscape, warnXIsNeverRead, warnXmightNotBeenInit,
    warnDeprecated, warnConfigDeprecated,
    warnSmallLshouldNotBeUsed, warnUnknownMagic, warnRedefinitionOfLabel,
    warnUnknownSubstitutionX, warnLanguageXNotSupported,
    warnFieldXNotSupported, warnCommentXIgnored,
    warnTypelessParam,
    warnUseBase, warnWriteToForeignHeap, warnUnsafeCode,
    warnEachIdentIsTuple, warnShadowIdent,
    warnProveInit, warnProveField, warnProveIndex, warnGcUnsafe, warnGcUnsafe2,
    warnUninit, warnGcMem, warnDestructor, warnLockLevel, warnResultShadowed,
    warnInconsistentSpacing, warnUser,
    hintSuccess, hintSuccessX,
    hintLineTooLong, hintXDeclaredButNotUsed, hintConvToBaseNotNeeded,
    hintConvFromXtoItselfNotNeeded, hintExprAlwaysX, hintQuitCalled,
    hintProcessing, hintCodeBegin, hintCodeEnd, hintConf, hintPath,
    hintConditionAlwaysTrue, hintName, hintPattern,
    hintExecuting, hintLinking, hintDependency,
    hintSource, hintPerformance, hintStackTrace, hintGCStats,
    hintUser, hintUserRaw

const
  MsgKindToStr*: array[TMsgKind, string] = [
    errUnknown: "unknown error",
    errInternal: "internal error: $1",
    errIllFormedAstX: "illformed AST: $1",
    errCannotOpenFile: "cannot open '$1'",
    errGenerated: "$1",
    errUser: "$1",
    warnCannotOpenFile: "cannot open '$1'",
    warnOctalEscape: "octal escape sequences do not exist; leading zero is ignored",
    warnXIsNeverRead: "'$1' is never read",
    warnXmightNotBeenInit: "'$1' might not have been initialized",
    warnDeprecated: "$1 is deprecated",
    warnConfigDeprecated: "config file '$1' is deprecated",
    warnSmallLshouldNotBeUsed: "'l' should not be used as an identifier; may look like '1' (one)",
    warnUnknownMagic: "unknown magic '$1' might crash the compiler",
    warnRedefinitionOfLabel: "redefinition of label '$1'",
    warnUnknownSubstitutionX: "unknown substitution '$1'",
    warnLanguageXNotSupported: "language '$1' not supported",
    warnFieldXNotSupported: "field '$1' not supported",
    warnCommentXIgnored: "comment '$1' ignored",
    warnTypelessParam: "'$1' has no type. Typeless parameters are deprecated; only allowed for 'template'",
    warnUseBase: "use {.base.} for base methods; baseless methods are deprecated",
    warnWriteToForeignHeap: "write to foreign heap",
    warnUnsafeCode: "unsafe code: '$1'",
    warnEachIdentIsTuple: "each identifier is a tuple",
    warnShadowIdent: "shadowed identifier: '$1'",
    warnProveInit: "Cannot prove that '$1' is initialized. This will become a compile time error in the future.",
    warnProveField: "cannot prove that field '$1' is accessible",
    warnProveIndex: "cannot prove index '$1' is valid",
    warnGcUnsafe: "not GC-safe: '$1'",
    warnGcUnsafe2: "$1",
    warnUninit: "'$1' might not have been initialized",
    warnGcMem: "'$1' uses GC'ed memory",
    warnDestructor: "usage of a type with a destructor in a non destructible context. This will become a compile time error in the future.",
    warnLockLevel: "$1",
    warnResultShadowed: "Special variable 'result' is shadowed.",
    warnInconsistentSpacing: "Number of spaces around '$#' is not consistent",
    warnUser: "$1",
    hintSuccess: "operation successful",
    hintSuccessX: "operation successful ($# lines compiled; $# sec total; $#; $#)",
    hintLineTooLong: "line too long",
    hintXDeclaredButNotUsed: "'$1' is declared but not used",
    hintConvToBaseNotNeeded: "conversion to base object is not needed",
    hintConvFromXtoItselfNotNeeded: "conversion from $1 to itself is pointless",
    hintExprAlwaysX: "expression evaluates always to '$1'",
    hintQuitCalled: "quit() called",
    hintProcessing: "$1",
    hintCodeBegin: "generated code listing:",
    hintCodeEnd: "end of listing",
    hintConf: "used config file '$1'",
    hintPath: "added path: '$1'",
    hintConditionAlwaysTrue: "condition is always true: '$1'",
    hintName: "name should be: '$1'",
    hintPattern: "$1",
    hintExecuting: "$1",
    hintLinking: "",
    hintDependency: "$1",
    hintSource: "$1",
    hintPerformance: "$1",
    hintStackTrace: "$1",
    hintGCStats: "$1",
    hintUser: "$1",
    hintUserRaw: "$1"]

const
  WarningsToStr* = ["CannotOpenFile", "OctalEscape",
    "XIsNeverRead", "XmightNotBeenInit",
    "Deprecated", "ConfigDeprecated",
    "SmallLshouldNotBeUsed", "UnknownMagic",
    "RedefinitionOfLabel", "UnknownSubstitutionX",
    "LanguageXNotSupported", "FieldXNotSupported",
    "CommentXIgnored",
    "TypelessParam", "UseBase", "WriteToForeignHeap",
    "UnsafeCode", "EachIdentIsTuple", "ShadowIdent",
    "ProveInit", "ProveField", "ProveIndex", "GcUnsafe", "GcUnsafe2", "Uninit",
    "GcMem", "Destructor", "LockLevel", "ResultShadowed",
    "Spacing", "User"]

  HintsToStr* = ["Success", "SuccessX", "LineTooLong",
    "XDeclaredButNotUsed", "ConvToBaseNotNeeded", "ConvFromXtoItselfNotNeeded",
    "ExprAlwaysX", "QuitCalled", "Processing", "CodeBegin", "CodeEnd", "Conf",
    "Path", "CondTrue", "Name", "Pattern", "Exec", "Link", "Dependency",
    "Source", "Performance", "StackTrace", "GCStats",
    "User", "UserRaw"]

const
  fatalMin* = errUnknown
  fatalMax* = errInternal
  errMin* = errUnknown
  errMax* = errUser
  warnMin* = warnCannotOpenFile
  warnMax* = pred(hintSuccess)
  hintMin* = hintSuccess
  hintMax* = high(TMsgKind)

static:
  doAssert HintsToStr.len == ord(hintMax) - ord(hintMin) + 1
  doAssert WarningsToStr.len == ord(warnMax) - ord(warnMin) + 1

type
  TNoteKind* = range[warnMin..hintMax] # "notes" are warnings or hints
  TNoteKinds* = set[TNoteKind]

const
  NotesVerbosity*: array[0..3, TNoteKinds] = [
    {low(TNoteKind)..high(TNoteKind)} - {warnShadowIdent, warnUninit,
                                         warnProveField, warnProveIndex,
                                         warnGcUnsafe,
                                         hintSuccessX, hintPath, hintConf,
                                         hintProcessing, hintPattern,
                                         hintDependency,
                                         hintExecuting, hintLinking,
                                         hintCodeBegin, hintCodeEnd,
                                         hintSource, hintStackTrace,
                                         hintGCStats},
    {low(TNoteKind)..high(TNoteKind)} - {warnShadowIdent, warnUninit,
                                         warnProveField, warnProveIndex,
                                         warnGcUnsafe,
                                         hintPath,
                                         hintDependency,
                                         hintCodeBegin, hintCodeEnd,
                                         hintSource, hintStackTrace,
                                         hintGCStats},
    {low(TNoteKind)..high(TNoteKind)} - {hintStackTrace, warnUninit},
    {low(TNoteKind)..high(TNoteKind)}]

#[
errStringLiteralExpected: "string literal expected",
errIntLiteralExpected: "integer literal expected",
errIdentifierExpected: "identifier expected, but found '$1'",
errNewlineExpected: "newline expected, but found '$1'",
errInvalidModuleName: "invalid module name: '$1'",
errRecursiveDependencyX: "recursive dependency: '$1'",
errOnOrOffExpected: "'on' or 'off' expected",
errNoneSpeedOrSizeExpected: "'none', 'speed' or 'size' expected",
errInvalidPragma: "invalid pragma",
errUnknownPragma: "unknown pragma: '$1'",
errAtPopWithoutPush: "'pop' without a 'push' pragma",
errEmptyAsm: "empty asm statement",
errInvalidIndentation: "invalid indentation",
errExceptionAlreadyHandled: "exception already handled",
errYieldNotAllowedHere: "'yield' only allowed in an iterator",
errYieldNotAllowedInTryStmt: "'yield' cannot be used within 'try' in a non-inlined iterator",
errInvalidNumberOfYieldExpr: "invalid number of 'yield' expressions",
errCannotReturnExpr: "current routine cannot return an expression",
errNoReturnWithReturnTypeNotAllowed: "routines with NoReturn pragma are not allowed to have return type",
errAttemptToRedefine: ,
errStmtInvalidAfterReturn: "statement not allowed after 'return', 'break', 'raise', 'continue' or proc call with noreturn pragma",
errStmtExpected: "statement expected",
errInvalidLabel: "'$1' is no label",
errInvalidCmdLineOption: "invalid command line option: '$1'",
errCmdLineArgExpected: "argument for command line option expected: '$1'",
errCmdLineNoArgExpected: "invalid argument for command line option: '$1'",
errInvalidVarSubstitution: "invalid variable substitution in '$1'",
errUnknownVar: "unknown variable: '$1'",
errUnknownCcompiler: "unknown C compiler: '$1'",
errOnOrOffExpectedButXFound: "'on' or 'off' expected, but '$1' found",
errOnOffOrListExpectedButXFound: "'on', 'off' or 'list' expected, but '$1' found",
errGenOutExpectedButXFound: "'c', 'c++' or 'yaml' expected, but '$1' found",
errArgsNeedRunOption: "arguments can only be given if the '--run' option is selected",
errInvalidMultipleAsgn: "multiple assignment is not allowed",
errColonOrEqualsExpected: "':' or '=' expected, but found '$1'",
errUndeclaredField: "undeclared field: '$1'",
errUndeclaredRoutine: "attempting to call undeclared routine: '$1'",
errUseQualifier: "ambiguous identifier: '$1' -- use a qualifier",
errTypeExpected: "type expected",
errSystemNeeds: "system module needs '$1'",
errExecutionOfProgramFailed: "execution of an external program failed: '$1'",
errNotOverloadable: "overloaded '$1' leads to ambiguous calls",
errInvalidArgForX: "invalid argument for '$1'",
errStmtHasNoEffect: "statement has no effect",
errXExpectsTypeOrValue: "'$1' expects a type or value",
errXExpectsArrayType: "'$1' expects an array type",
errIteratorCannotBeInstantiated: "'$1' cannot be instantiated because its body has not been compiled yet",
errExprXAmbiguous: "expression '$1' ambiguous in this context",
errConstantDivisionByZero: ,
errOrdinalTypeExpected: "ordinal type expected",
errOrdinalOrFloatTypeExpected: "ordinal or float type expected",
errOverOrUnderflow: ,
errCannotEvalXBecauseIncompletelyDefined: ,
errChrExpectsRange0_255: "'chr' expects an int in the range 0..255",
errDynlibRequiresExportc: "'dynlib' requires 'exportc'",
errUndeclaredFieldX: "undeclared field: '$1'",
errNilAccess: "attempt to access a nil address",
errIndexOutOfBounds: "index out of bounds",
errIndexTypesDoNotMatch: "index types do not match",
errBracketsInvalidForType: "'[]' operator invalid for this type",
errValueOutOfSetBounds: "value out of set bounds",
errFieldInitTwice: "field initialized twice: '$1'",
errFieldNotInit: "field '$1' not initialized",
errExprXCannotBeCalled: "expression '$1' cannot be called",
errExprHasNoType: "expression has no type",
errExprXHasNoType: "expression '$1' has no type (or is ambiguous)",
errCastNotInSafeMode: "'cast' not allowed in safe mode",
errExprCannotBeCastToX: "expression cannot be cast to $1",
errCommaOrParRiExpected: "',' or ')' expected",
errCurlyLeOrParLeExpected: "'{' or '(' expected",
errSectionExpected: "section ('type', 'proc', etc.) expected",
errRangeExpected: "range expected",
errMagicOnlyInSystem: "'magic' only allowed in system module",
errPowerOfTwoExpected: "power of two expected",
errStringMayNotBeEmpty: "string literal may not be empty",
errCallConvExpected: "calling convention expected",
errProcOnlyOneCallConv: "a proc can only have one calling convention",
errSymbolMustBeImported: "symbol must be imported if 'lib' pragma is used",
errExprMustBeBool: "expression must be of type 'bool'",
errConstExprExpected: "constant expression expected",
errDuplicateCaseLabel: "duplicate case label",
errRangeIsEmpty: "range is empty",
errSelectorMustBeOfCertainTypes: "selector must be of an ordinal type, float or string",
errSelectorMustBeOrdinal: "selector must be of an ordinal type",
errOrdXMustNotBeNegative: "ord($1) must not be negative",
errLenXinvalid: "len($1) must be less than 32768",
errWrongNumberOfVariables: "wrong number of variables",
errExprCannotBeRaised: "only a 'ref object' can be raised",
errBreakOnlyInLoop: "'break' only allowed in loop construct",
errTypeXhasUnknownSize: "type '$1' has unknown size",
errConstNeedsConstExpr: "a constant can only be initialized with a constant expression",
errConstNeedsValue: "a constant needs a value",
errResultCannotBeOpenArray: "the result type cannot be on open array",
errSizeTooBig: "computing the type's size produced an overflow",
errSetTooBig: "set is too large",
errBaseTypeMustBeOrdinal: "base type of a set must be an ordinal",
errInheritanceOnlyWithNonFinalObjects: "inheritance only works with non-final objects",
errInheritanceOnlyWithEnums: "inheritance only works with an enum",
errIllegalRecursionInTypeX:,
errCannotInstantiateX: "cannot instantiate: '$1'",
errExprHasNoAddress: "expression has no address",
errXStackEscape: "address of '$1' may not escape its stack frame",
errVarForOutParamNeededX: "for a 'var' type a variable needs to be passed; but '$1' is immutable",
errPureTypeMismatch: "type mismatch",
errTypeMismatch: "type mismatch: got <",
errButExpected: "but expected one of: ",
errButExpectedX: "but expected '$1'",
errAmbiguousCallXYZ: "ambiguous call; both $1 and $2 match for: $3",
errWrongNumberOfArguments: "wrong number of arguments",
errWrongNumberOfArgumentsInCall: "wrong number of arguments in call to '$1'",
errMissingGenericParamsForTemplate: "'$1' has unspecified generic parameters",
errXCannotBePassedToProcVar: "'$1' cannot be passed to a procvar",
errPragmaOnlyInHeaderOfProcX: "pragmas are only allowed in the header of a proc; redefinition of $1",
errImplOfXNotAllowed: "implementation of '$1' is not allowed",
errImplOfXexpected: ,
errNoSymbolToBorrowFromFound: "no symbol to borrow from found",
errDiscardValueX: "value of type '$1' has to be discarded",
errInvalidDiscard: "statement returns no value that can be discarded",
errIllegalConvFromXtoY: ,
errCannotBindXTwice: "cannot bind parameter '$1' twice",
errInvalidOrderInArrayConstructor: "invalid order in array constructor",
errInvalidOrderInEnumX: "invalid order in enum '$1'",
errEnumXHasHoles: "enum '$1' has holes",
errExceptExpected: "'except' or 'finally' expected",
errInvalidTry: "after catch all 'except' or 'finally' no section may follow",
errOptionExpected: "option expected, but found '$1'",
errXisNoLabel: "'$1' is not a label",
errNotAllCasesCovered: "not all cases are covered",
errUnknownSubstitionVar: "unknown substitution variable: '$1'",
errComplexStmtRequiresInd: "complex statement requires indentation",
errXisNotCallable: "'$1' is not callable",
errNoPragmasAllowedForX: "no pragmas allowed for $1",
errNoGenericParamsAllowedForX: "no generic parameters allowed for $1",
errInvalidParamKindX: "invalid param kind: '$1'",
errDefaultArgumentInvalid: "default argument invalid",
errNamedParamHasToBeIdent: "named parameter has to be an identifier",
errNoReturnTypeForX: "no return type allowed for $1",
errConvNeedsOneArg: "a type conversion needs exactly one argument",
errInvalidPragmaX: ,
errXNotAllowedHere: "$1 not allowed here",
errInvalidControlFlowX: "invalid control flow: $1",
errXisNoType: "invalid type: '$1'",
errCircumNeedsPointer: "'[]' needs a pointer or reference type",
errInvalidExpression: "invalid expression",
errInvalidExpressionX: "invalid expression: '$1'",
errEnumHasNoValueX: "enum has no value '$1'",
errNamedExprExpected: "named expression expected",
errNamedExprNotAllowed: "named expression not allowed here",
errXExpectsOneTypeParam: "'$1' expects one type parameter",
errArrayExpectsTwoTypeParams: "array expects two type parameters",
errInvalidVisibilityX: "invalid visibility: '$1'",
errInitHereNotAllowed: "initialization not allowed here",
errXCannotBeAssignedTo: "'$1' cannot be assigned to",
errIteratorNotAllowed: "iterators can only be defined at the module's top level",
errXNeedsReturnType: "$1 needs a return type",
errNoReturnTypeDeclared: "no return type declared",
errNoCommand: "no command given",
errInvalidCommandX: "invalid command: '$1'",
errXOnlyAtModuleScope: "'$1' is only allowed at top level",
errXNeedsParamObjectType: "'$1' needs a parameter that has an object type",
errTemplateInstantiationTooNested: "template instantiation too nested, try --evalTemplateLimit:N",
errMacroInstantiationTooNested: "macro instantiation too nested, try --evalMacroLimit:N",
errInstantiationFrom: "template/generic instantiation from here",
errInvalidIndexValueForTuple: "invalid index value for tuple subscript",
errCommandExpectsFilename: "command expects a filename argument",
errMainModuleMustBeSpecified: "please, specify a main module in the project configuration file",
errXExpected: "'$1' expected",
errTIsNotAConcreteType: "'$1' is not a concrete type.",
errCastToANonConcreteType: "cannot cast to a non concrete type: '$1'",
errInvalidSectionStart: "invalid section start",
errGridTableNotImplemented: "grid table is not implemented",
errGeneralParseError: "general parse error",
errNewSectionExpected: "new section expected",
errWhitespaceExpected: "whitespace expected, got '$1'",
errXisNoValidIndexFile: "'$1' is no valid index file",
errCannotRenderX: "cannot render reStructuredText element '$1'",
errVarVarTypeNotAllowed: ,
errInstantiateXExplicitly: "instantiate '$1' explicitly",
errOnlyACallOpCanBeDelegator: "only a call operator can be a delegator",
errUsingNoSymbol: "'$1' is not a variable, constant or a proc name",
errMacroBodyDependsOnGenericTypes: "the macro body cannot be compiled, " &
                                   "because the parameter '$1' has a generic type",
errDestructorNotGenericEnough: "Destructor signature is too specific. " &
                               "A destructor must be associated will all instantiations of a generic type",
errInlineIteratorsAsProcParams: "inline iterators can be used as parameters only for " &
                                "templates, macros and other inline iterators",
errXExpectsTwoArguments: "'$1' expects two arguments",
errXExpectsObjectTypes: "'$1' expects object types",
errXcanNeverBeOfThisSubtype: "'$1' can never be of this subtype",
errTooManyIterations: "interpretation requires too many iterations; " &
  "if you are sure this is not a bug in your code edit " &
  "compiler/vmdef.MaxLoopIterations and rebuild the compiler",
errCannotInterpretNodeX: "cannot evaluate '$1'",
errFieldXNotFound: "field '$1' cannot be found",
errInvalidConversionFromTypeX: "invalid conversion from type '$1'",
errAssertionFailed: "assertion failed",
errCannotGenerateCodeForX: "cannot generate code for '$1'",
errXRequiresOneArgument: "$1 requires one parameter",
errUnhandledExceptionX: "unhandled exception: $1",
errCyclicTree: "macro returned a cyclic abstract syntax tree",
errXisNoMacroOrTemplate: "'$1' is no macro or template",
errXhasSideEffects: "'$1' can have side effects",
errIteratorExpected: "iterator within for loop context expected",
errLetNeedsInit: "'let' symbol requires an initialization",
errThreadvarCannotInit: "a thread var cannot be initialized explicitly; this would only run for the main thread",
errWrongSymbolX: "usage of '$1' is a user-defined error",
errIllegalCaptureX: "illegal capture '$1'",
errXCannotBeClosure: "'$1' cannot have 'closure' calling convention",
errXMustBeCompileTime: "'$1' can only be used in compile-time context",
errCannotInferTypeOfTheLiteral: "cannot infer the type of the $1",
errCannotInferReturnType: "cannot infer the return type of the proc",
errCannotInferStaticParam: "cannot infer the value of the static param `$1`",
errGenericLambdaNotAllowed: "A nested proc can have generic parameters only when " &
                            "it is used as an operand to another routine and the types " &
                            "of the generic paramers can be inferred from the expected signature.",
errProcHasNoConcreteType: "'$1' doesn't have a concrete type, due to unspecified generic parameters.",
errInOutFlagNotExtern: "The `$1` modifier can be used only with imported types",
]#
