-module(sudoku_solver).
-export([solve/1]).

% Define the 3x3 blocks' positions for validation
block_indices() ->
    [
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]],
        [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    ].

% Solve the Sudoku Puzzle
solve(Board) ->
    case solve_puzzle(Board) of
        {ok, SolvedBoard} -> SolvedBoard;
        error -> error
    end.

% Backtracking Sudoku Solver
solve_puzzle(Board) ->
    case find_empty(Board) of
        {ok, {Row, Col}} -> try_values(Board, Row, Col);
        error -> Board % No empty cells, return solved board
    end.

% Try values for the empty cell
try_values(Board, Row, Col) ->
    lists:foldl(
        fun(Value, Acc) ->
            case is_valid(Board, Row, Col, Value) of
                true ->
                    NewBoard = set_cell(Board, Row, Col, Value),
                    case solve_puzzle(NewBoard) of
                        {ok, SolvedBoard} -> {ok, SolvedBoard};
                        error -> Acc % Backtrack
                    end;
                false -> Acc
            end
        end,
        error,
        [1, 2, 3, 4, 5, 6, 7, 8, 9]
    ).

% Check if a value can be placed in a cell
is_valid(Board, Row, Col, Value) ->
    not (is_in_row(Board, Row, Value) orelse
         is_in_col(Board, Col, Value) orelse
         is_in_block(Board, Row, Col, Value)).

% Check if a value is in the row
is_in_row(Board, Row, Value) ->
    lists:member(Value, lists:nth(Row, Board)).

% Check if a value is in the column
is_in_col(Board, Col, Value) ->
    lists:member(Value, lists:map(fun(Row) -> lists:nth(Col, Row) end, Board)).

% Check if a value is in the 3x3 block
is_in_block(Board, Row, Col, Value) ->
    BlockRow = (Row - 1) div 3 + 1,
    BlockCol = (Col - 1) div 3 + 1,
    BlockIndices = block_indices(),
    lists:member({BlockRow, BlockCol}, BlockIndices).

% Find the first empty cell (denoted by 0)
find_empty(Board) ->
    find_empty(Board, 1, 1).

find_empty([], _, _) -> error;
find_empty([Row | Rest], RowNum, ColNum) ->
    find_empty_in_row(Row, RowNum, ColNum, Rest).

find_empty_in_row([], _, _, Rest) -> find_empty(Rest, 1, 1);
find_empty_in_row([0 | _], RowNum, ColNum, _) -> {ok, {RowNum, ColNum}};
find_empty_in_row([_ | Rest], RowNum, ColNum, RestRows) ->
    find_empty_in_row(Rest, RowNum, ColNum + 1, RestRows).

% Set the value in a cell
set_cell(Board, Row, Col, Value) ->
    set_cell(Board, Row, Col, Value, 1).

set_cell([], _, _, _, _) -> [];
set_cell([Row | Rest], RowNum, Col, Value, RowNum) ->
    set_cell_in_row(Row, Col, Value, 1) ++ Rest;
set_cell([Row | Rest], RowNum, Col, Value, CurrentRow) when CurrentRow < RowNum ->
    [Row | set_cell(Rest, RowNum, Col, Value, CurrentRow + 1)].

set_cell_in_row([], _, _, _) -> [];
set_cell_in_row([_ | Rest], 1, Value, _) -> [Value | Rest];
set_cell_in_row([Head | Rest], Col, Value, CurrentCol) when CurrentCol < Col ->
    [Head | set_cell_in_row(Rest, Col, Value, CurrentCol + 1)].

