INCLUDE Irvine32.inc
INCLUDE macros.inc



;------------------------------------------
           ;Variables:
;------------------------------------------





.data
endl db 0ah, 0
;-------FOR MENU-------------------------------------------------------------------------

test1  db "                                ____                         ____  _                 _   ",0ah,0
test2  db "                               / ___| _ __   __ _  ___ ___  / ___|| |__   ___   ___ | |_ ___ _ __ ",0ah,0
test3  db "                               \___ \| '_ \ / _` |/ __/ _ \ \___ \| '_ \ / _ \ / _ \| __/ _ \ '__|",0ah,0
test4  db "                                ___) | |_) | (_| | (_|  __/  ___) | | | | (_) | (_) | ||  __/ |   ",0ah,0
test5  db "                               |____/| .__/ \__,_|\___\___| |____/|_| |_|\___/ \___/ \__\___|_|   ",0ah,0
test6  db "                                     |_|                                                          ",0ah,0

seq21  db "                                  _   _                                  _   ____     _      ", 0ah,0
seq22  db "                                 /_\ | |_  _ __  __ _ _ _   __ _ _ _  __| | |_  /__ _(_)_ _  ", 0ah,0
seq23  db "                                / _ \| ' \| '  \/ _` | '_| / _` | ' \/ _` |  / // _` | | ' \ ", 0ah,0
seq24  db "                               /_/ \_\_||_|_|_|_\__,_|_|   \__,_|_||_\__,_| /___\__,_|_|_||_|", 0ah,0


seq31  db "                                                           /\", 0ah,0                          
seq32  db "                                                          |  |                               ",0ah,0
seq33  db "                                                          |  |                               ",0ah,0
seq34  db "                                                         .'  '.                              ",0ah,0
seq35  db "                                                         |    |                              ",0ah,0
seq36  db "                                                         |    |                              ",0ah,0
seq37  db "                                                         | /\ |                              ",0ah,0
seq38  db "                                                       .' |__| '.                             ",0ah,0
seq39  db "                                                       |  |  |  |                            ",0ah,0
seq310  db "                                                     .'  |  |  '.                           ",0ah,0
seq311  db "                                                /\   |   \__/   |   /\                      ",0ah,0
seq312  db "                                               |  |  |   |  |   |  |  |                     ",0ah,0
seq313  db "                                           /|  |  |,-\   |  |   /-,|  |  |\                 ",0ah,0
seq314  db "                                           ||  |,-'   |  |  |  |   '-,|  ||                 ",0ah,0
seq315  db "                                           ||-'       |  |  |  |       '-||                 ",0ah,0
seq316  db "                                |\     _,-'           |  |  |  |           '-,_     /|      ",0ah,0
seq317  db "                                ||  ,-'   _           |  |  |  |               '-,  ||      ",0ah,0
seq318  db "                                ||-'    =(*)=         |  |  |  |                  '-||      ",0ah,0
seq319 db "|                                ||                    |  \  /  |                    ||      ",0ah,0
seq320  db "                                |\________....--------\   ||   /--------....________/|      ",0ah,0
seq321  db "                                                      /|  ||  |\                            ",0ah,0
seq322  db "                                                     / |  ||  | \                           ",0ah,0
seq323  db "                                                    /  |  \/  |  \                          ",0ah,0
seq324  db "                                                   /   |      |   \                         ",0ah,0
seq325  db "                                                 //   .|      |.   \\                       ",0ah,0
seq326  db "                                               .' |_./ |      | \._| '.                     ",0ah,0
seq327  db "                                              /     _.-|||  |||-._     \                    ",0ah,0
seq328  db "                                              \__.-'   \||/\||/   '-.__/                    ",0ah,0
           

;----------------------------------------------------------------------------------------
    level1 db 50
    level2 db 25
    level3 db 15

    screenHeight BYTE 25
    screenWidth  BYTE 80
    enemyDirection BYTE 2   ; 0 = left-down, 1 = down, 2 = right-down
    enemyDirection2 BYTE 0  ; Direction for second enemy
    enemyDirection3 BYTE 1  ; Direction for third enemy
    dirChangeCounterEnemy1 BYTE 0      ; Counter for enemy direction change frames
    dirChangeCounterEnemy2 BYTE 0      ; Counter for second enemy direction change frames
    dirChangeCounterEnemy3 BYTE 0      ; Counter for third enemy direction change frames

    firstEnemyMoveCounter BYTE 0
    secondEnemyMoveCounter BYTE 0    ;Counter for second enemy movement frames
    thirdEnemyMoveCounter db 0

    ;bounds for the game area
    leftboundary  db 1
    rightboundary db 79
    upperboundary db 5
    lowerboundary db 28

    strScore BYTE "Score: ", 0
    score    BYTE 0

    ; Player state
    playerX     BYTE 40
    playerY     BYTE 24
    playerChar  BYTE '^'

    ; Enemy state
    enemyX      BYTE 30
    enemyY      BYTE 1
    enemyChar   BYTE 'V', 0
    enemySecondX db 50
    enemySecondY db 1
    enemyThirdX db 80
    enemyThirdY db 1


    ; Bullet state
    bulletX       BYTE ?
    bulletY       BYTE ?
    bulletActive  BYTE 0
    bulletChar    BYTE '|', 0

    firstBulletFirstTimeBool db 1 ; to handle bullet moving up (saving player's coord for the first time)

    secondBulletX db 0
    secondBulletY db 0
    secondBulletActive db 0 ; 0 means no second bullet active

    secondBulletFirstTimeBool db 1    ;to handle moving second bullet (saving player's coord for the first time)

    ;vars for third bullet:

    thirdBulletX db 0
    thirdBulletY db 0
    thirdBulletActive db 0 ; 0 means no third bullet active

    ThirdBulletFirstTimeBool db 1    ;to handle moving third bullet (saving player's coord for the first time)
    
    
    inputChar BYTE ?


    debugHelpBool db 0 ; 0 means updateBothBullet function is not called for the first time, 1 means it is called for the first time



    ;variables for levels 1, 2, 3:

    levelState db 1 ; 1 means level-1, 2 means level-2, 3 means level-3

    enemiesKilled db 0 ; to keep track of how many enemies are killed to advance to the next level

    enemyCount db 1 ; 1 in level-1, 2 in level-2, 3 in level-3


;------------------------------------------
           ;main game loop:
;------------------------------------------




.code

main PROC
    call clrscr
    call menu
    call clrscr
   call DrawPlayer
    call DrawEnemy
    call Randomize

gameLoop:
    
    ;checking for loose (if enemy touches the player:)

    mov al, playerX
    mov bl, enemyX
    cmp al, bl
    jne checkEnemy2Collision
    mov al, playerY
    mov bl, enemyY
    cmp al, bl
    jne checkEnemy2Collision

    ; Player has been hit by enemy-1
    jmp gameLost

    checkEnemy2Collision:

    cmp levelState, 2
    jl proceeed

    ;else levelState is 2 or 3, so check if enemy-2 touches player:

    mov al, playerX
    mov bl, enemySecondX
    cmp al, bl
    jne checkEnemy3Collision
    mov al, playerY
    mov bl, enemySecondY
    cmp al, bl
    jne checkEnemy3Collision

    ; Player has been hit by enemy-2

    jmp gameLost

    checkEnemy3Collision:

    cmp levelState, 3
    jl proceeed
    ;else levelState is 3, so check if enemy-3 touches player:

    mov al, playerX
    mov bl, enemyThirdX
    cmp al, bl
    jne proceeed
    mov al, playerY
    mov bl, enemyThirdY
    cmp al, bl
    jne proceeed
    ; Player has been hit by enemy-3
    jmp gameLost


    proceeed:

    ;setting rate of enemy movement based on level:
    cmp levelState, 1
    jg checkLevel2or3

    ;else levelState is 1, so set enemy move rate to 1 move per 10 frames
    mov al, 10
    jmp drawingEnemies

    checkLevel2or3:

    cmp levelState, 2

    jg setlevel3rate

    ;else levelState is 2, so set enemy move rate to 1 move per 7 frames:
    mov al, 7
    jmp drawingEnemies

    setlevel3rate:
    mov al, 4           ; set enemy move rate to 1 move per 4 frames in level-3

    drawingEnemies:

    ; move enemy every 10 frames
    inc firstEnemyMoveCounter
    cmp firstEnemyMoveCounter, al    ;al stores the number of frames after which enemy should update position (based on level-number)
    jne drawingSecondEnemy
    mov firstEnemyMoveCounter, 0
    call UpdateEnemyPosition
    call DrawEnemy


    ;drawing second enemy if levelState is 2 or 3:

    drawingSecondEnemy:

    cmp levelState, 2
    jl skipSecondandThirdEnemy

    ; move enemy every 7 frames 
    inc secondEnemyMoveCounter
    cmp secondEnemyMoveCounter, al    ;al stores the number of frames after which enemy should update position (based on level-number)
    jne drawingThirdEnemy
    mov secondEnemyMoveCounter, 0
    call UpdateEnemy2Position
    call DrawEnemy2

    drawingThirdEnemy:

    cmp levelState, 3
    jl skipSecondandThirdEnemy

    jg wonTheGame

    ;else it means levelState = 3:

    ; move enemy every 4 frames
    inc thirdEnemyMoveCounter
    cmp thirdEnemyMoveCounter, al    ;al stores the number of frames after which enemy should update position (based on level-number)
    jne checkBulletCollisionWithEnemies
    mov thirdEnemyMoveCounter, 0
    call UpdateEnemy3Position
    call DrawEnemy3

    skipSecondandThirdEnemy:


    
checkBulletCollisionWithEnemies:
   
    ; Checking if Bullet-1 hits enemy-1
    cmp bulletActive, 1
    jne checkCollisionWithSecondBullet     ;bullet-1 is not active...simple...
    movzx ax, bulletX
    movzx bx, enemyX
    cmp ax, bx
    jne checkCollisionBullet1withSecondEnemy
    movzx ax, bulletY
    movzx bx, enemyY
    cmp ax, bx
    jne checkCollisionBullet1withSecondEnemy

    ; Bullet-1 has hit the enemy-1
    inc enemiesKilled
    inc score
    mov bulletActive, 0
    mov firstBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy
    call DrawEnemy

    jmp checkCollisionWithSecondBullet     ;if bullet-1 has hit an enemy then it vanishes... proceed to checking other bullets

    ;check if bullet1 hits second enemy if levelState is 2 or 3:

    checkCollisionBullet1withSecondEnemy:

    cmp levelState, 2
    jl checkCollisionWithSecondBullet

    ;else levelState is 2 or 3, so check if bullet-1 hits second enemy:
    movzx ax, bulletX
    movzx bx, enemySecondX
    cmp ax, bx
    jne checkCollisionBullet1withThirdEnemy
    movzx ax, bulletY
    movzx bx, enemySecondY
    cmp ax, bx
    jne checkCollisionBullet1withThirdEnemy

    ; Bullet-1 has hit the second enemy:

    inc enemiesKilled
    inc score
    mov bulletActive, 0
    mov firstBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy2
    call DrawEnemy2

    jmp checkCollisionWithSecondBullet     ;if bullet-1 has hit an enemy then it vanishes... proceed to checking other bullets

    checkCollisionBullet1withThirdEnemy: ; Check if bullet-1 hits third enemy if levelState is 3

    cmp levelState, 3
    jl checkCollisionWithSecondBullet

    ;else levelState is 3, so check if bullet-1 hits third enemy:
    movzx ax, bulletX
    movzx bx, enemyThirdX
    cmp ax, bx
    jne checkCollisionWithSecondBullet
    movzx ax, bulletY
    movzx bx, enemyThirdY
    cmp ax, bx
    jne checkCollisionWithSecondBullet

    ; Bullet-1 has hit the third enemy:
    inc enemiesKilled
    inc score
    mov bulletActive, 0
    call updateBullet
    mov firstBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy3
    call DrawEnemy3



    checkCollisionWithSecondBullet:     ; Checking if second bullet hits enemy-1, enemy-2 or enemy-3:


    cmp secondBulletActive, 1
    jne checkCollisionWithThirdBullet
    movzx ax, secondBulletX
    movzx bx, enemyX
    cmp ax, bx
    jne checkCollisionBullet2withSecondEnemy
    movzx ax, secondBulletY
    movzx bx, enemyY
    cmp ax, bx
    jne checkCollisionBullet2withSecondEnemy

    ; Second bullet has hit the enemy-1
    inc enemiesKilled
    inc score
    mov secondBulletActive, 0
    call updateSecondBullet
    mov secondBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy
    call DrawEnemy

    jmp checkCollisionWithThirdBullet     ;if bullet-2 has hit an enemy then it vanishes... proceed to checking other bullets


    ;check if second bullet hits second enemy if levelState is 2 or 3:
    checkCollisionBullet2withSecondEnemy:

    cmp levelState, 2
    jl checkCollisionWithThirdBullet

    ;else levelState is 2 or 3, so check if second bullet hits second enemy:
    movzx ax, secondBulletX
    movzx bx, enemySecondX
    cmp ax, bx
    jne checkCollisionBullet2withThirdEnemy

    movzx ax, secondBulletY
    movzx bx, enemySecondY
    cmp ax, bx
    jne checkCollisionBullet2withThirdEnemy

    ; Second bullet has hit the second enemy:

    inc enemiesKilled
    inc score
    mov secondBulletActive, 0
    call updateSecondBullet
    mov secondBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy2
    call DrawEnemy2

    jmp checkCollisionWithThirdBullet     ;if bullet-2 has hit an enemy then it vanishes... proceed to checking other bullets

    ; Check if second bullet hits third enemy if levelState is 3
    checkCollisionBullet2withThirdEnemy: 

    cmp levelState, 3
    jl checkCollisionWithThirdBullet

    ;else levelState is 3, so check if second bullet hits third enemy:

    movzx ax, secondBulletX
    movzx bx, enemyThirdX
    cmp ax, bx
    jne checkCollisionWithThirdBullet

    movzx ax, secondBulletY
    movzx bx, enemyThirdY
    cmp ax, bx
    jne checkCollisionWithThirdBullet

    ; Second bullet has hit the third enemy:

    inc enemiesKilled
    inc score
    mov secondBulletActive, 0
    call updateSecondBullet
    mov secondBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy3
    call DrawEnemy3



    checkCollisionWithThirdBullet:     ; Check if third bullet hits enemy

    cmp thirdBulletActive, 1
    jne LevelStateCheck
    movzx ax, thirdBulletX
    movzx bx, enemyX
    cmp ax, bx
    jne LevelStateCheck
    movzx ax, thirdBulletY
    movzx bx, enemyY
    cmp ax, bx
    jne LevelStateCheck

    ; Third bullet has hit the enemy:
    inc enemiesKilled
    inc score
    mov thirdBulletActive, 0
    call updateThirdBullet
    mov ThirdBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy
    call DrawEnemy

    jmp LevelStateCheck     ;if bullet-3 has hit an enemy then it vanishes... proceed further..

    ;check if bullet-3 hits enemy-2 if levelStae is 2 or 3
    checkCollisionBullet3withSecondEnemy:

    cmp levelState, 2
    jl LevelStateCheck

    ;else levelState is 2 or 3, so check if third bullet hits second enemy:
    movzx ax, thirdBulletX
    movzx bx, enemySecondX
    cmp ax, bx
    jne checkCollisionBullet3withThirdEnemy
    
    movzx ax, thirdBulletY
    movzx bx, enemySecondY
    cmp ax, bx  
    jne checkCollisionBullet3withThirdEnemy

    ; Third bullet has hit the second enemy:
    inc enemiesKilled
    inc score
    mov thirdBulletActive, 0
    call updateThirdBullet
    mov ThirdBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy2
    call DrawEnemy2

    jmp LevelStateCheck     ;if bullet-3 has hit an enemy then it vanishes... proceed further..

    ;check if third bullet hits third enemy:
    checkCollisionBullet3withThirdEnemy: ; Check if third bullet hits third enemy if levelState is 3

    cmp levelState, 3
    jl LevelStateCheck

    ;else levelState is 3, so check if third bullet hits third enemy:

    movzx ax, thirdBulletX
    movzx bx, enemyThirdX
    cmp ax, bx
    jne LevelStateCheck
    movzx ax, thirdBulletY
    movzx bx, enemyThirdY
    cmp ax, bx
    jne LevelStateCheck

    ; Third bullet has hit the third enemy:
    inc enemiesKilled
    inc score
    mov thirdBulletActive, 0
    mov ThirdBulletFirstTimeBool, 1 ; Reset the flag
    call UpdateEnemy3
    call DrawEnemy3




    LevelStateCheck: ; Check if player has killed enough enemies to advance to the next level

    ;checking for number of enemies killed to advance to the next level if needed:

    mov al, 5
    cmp enemiesKilled, al
    jl proceedAhead          ;keeping level-1

    mov al, 10
    cmp enemiesKilled, al
    jge  checkWin         ;if enemiesKilled >= 10, move to level-3

    ;else it means enemiesKilled is between 5 and 10, so move to level-2:
    mov levelState, 2        ;else move to level-2
    inc enemyCount           ;increase enemy count to 2 for level-2
    jmp proceedAhead

    checkWin:    ;check if player has won the game by killing 15 enemies

    mov al, 15
    cmp enemiesKilled, al
    jl moveToLevel3 ;if enemiesKilled < 15, move to level-3

    ;else player has won the game:
    jmp wonTheGame

    moveToLevel3:

    mov levelState, 3        ;move to level-3
    inc enemyCount           ;increase enemy count to 3 for level-3



proceedAhead:

    ; Draw score:

    mov eax, white + (black * 16)
    call SetTextColor
    mov dl, 0
    mov dh, 0
    call Gotoxy
    mov edx, OFFSET strScore
    call WriteString
    mov al, score
    call WriteInt


    ;drawing bullets based on their active states:

    cmp bulletActive, 1
    jne skipBullet1
    call UpdateBullet
    call DrawBullet
    skipBullet1:

    cmp secondBulletActive, 1
    jne skipSecondBullet
    call UpdateSecondBullet
    call DrawSecondBullet
    skipSecondBullet:

    cmp thirdBulletActive, 1
    jne skipBulletMove
    call updateThirdBullet
    call drawThirdBullet


skipBulletMove:

    call ReadKey          ; Read keyboard input
    mov inputChar, al     ; Store ASCII part

    ; Exit if Escape_Key is pressed
    cmp inputChar, VK_ESCAPE
    je exitGame

    ; Spacebar to shoot
    cmp inputChar, ' '
    je shoot

    ; Arrow key handling using scan code (in AH)
    cmp ah, 4Bh           ; Left arrow
    je moveLeft

    cmp ah, 4Dh           ; Right arrow
    je moveRight

    cmp ah, 48h           ; Up arrow
    je moveup

    cmp ah, 50h           ; Down arrow
    je moveDown

    movzx eax, level1       ;this is the level of difficulty. it has to be set according to the level
    call delay           ; Delay to control game speed
    jmp gameLoop
moveLeft:
    call UpdatePlayer
    push eax    ;save eax for DrawPlayer
    mov al, playerX
    cmp al, leftboundary
    je lbound
    nlbound:
    dec playerX
    lbound:
    call DrawPlayer
    pop eax     ;restore eax
    jmp gameLoop

moveRight:
    call UpdatePlayer
    push eax    ;save eax for DrawPlayer
    mov al, playerX
    cmp al, rightboundary
    je rbound
    nrbound:
    inc playerX
    rbound:
    call DrawPlayer
    pop eax     ;restore eax
    jmp gameLoop

moveup:
    call UpdatePlayer
    push eax
    mov al, playerY
    cmp al, upperboundary
    je ubound
    nubound:
    dec playerY
    ubound:
    call DrawPlayer
    pop eax
    jmp gameLoop

moveDown:
    call UpdatePlayer
    push eax
    mov al, playerY
    cmp al, lowerboundary
    je dbound
    ndbound:
    inc playerY
    dbound:
    call DrawPlayer
    pop eax
    jmp gameLoop

shoot:

    cmp bulletActive, 1
    je checkSecondBullet

    ;else make bullet-1 active...
    mov bulletActive, 1
    jmp skipper

    checkSecondBullet:

    cmp secondBulletActive, 1
    je activateThirdBullet

    ;else make second bullet active...
    mov secondBulletActive, 1
    jmp skipper

    activateThirdBullet:

    mov thirdBulletActive, 1



    skipper:

    call drawPlayer

    jmp gameloop

gameLost:

    call clrscr
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    mwrite "You have been hit by an enemy! Game Over!"
    call crlf
    call crlf
    mwrite "Press any key to exit the game."
    jmp exitProg

wonTheGame:
    call clrscr
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    mwrite "Congratulations! You have won the game by killing 15 enemies!"
    call crlf
    call crlf
    mwrite "Press any key to exit the game."
    jmp exitProg

exitGame:
    call clrscr
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    mwrite "Thanks For Playing Spaceshooter, press any key to close the window."
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf
    call crlf


    exitProg:
    exit




main ENDP






;------------------------------------------
           ;Drawing bullet functions:
;------------------------------------------


UpdateBullet PROC

    cmp inputChar, ' '  ;only save player's coordinates if space is pressed
    jne skipSavingPlayerCoord

    cmp firstBulletFirstTimeBool, 1
    jne skipSavingPlayerCoord
    mov al, playerX
    mov bulletX, al
    mov al, playerY
    mov bulletY, al
    dec bulletY       ; Move bullet up by one position so it is above the player

    mov firstBulletFirstTimeBool, 0

    skipSavingPlayerCoord:

    cmp bulletActive, 0
    je skipUpdateBullet

    ; Check if bullet is off-screen
    cmp bulletY, 0
    jne skip
    mov bulletActive, 0    ; bullet has passed the screen
    mov firstBulletFirstTimeBool, 1 ; Reset the flag
    skip:

    mov dl, bulletX
    mov dh, bulletY
    call Gotoxy
    mov al, ' '
    dec bulletY
    call WriteChar

    skipUpdateBullet:
    ret
UpdateBullet ENDP

; Draw bullet
DrawBullet PROC

    cmp bulletActive, 0
    je skipDrawBullet
    ; Check if bullet is off-screen
    cmp bulletY, 0
    jle skipDrawBullet

    ; Draw the bullet:

   mov eax, yellow + (black * 16)
    call SetTextColor

    mov dl, bulletX
    mov dh, bulletY
    call Gotoxy
    mov al, bulletChar
    call WriteChar

    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor

    skipDrawBullet:
    ret
DrawBullet ENDP

UpdateSecondBullet PROC

    cmp inputChar, ' '  ;only save player's coordinates if space is pressed
    jne skipSavingPlayerCoord

    cmp secondBulletFirstTimeBool, 1
    jne skipSavingPlayerCoord
    mov al, playerX
    mov secondBulletX, al
    mov al, playerY
    mov secondBulletY, al

    mov secondBulletFirstTimeBool, 0

    skipSavingPlayerCoord:

    cmp secondBulletActive, 0
    je skipUpdateBullet

    ; Check if bullet is off-screen
    cmp secondBulletY, 0
    jne skip
    mov secondBulletActive, 0    ; bullet has passed the screen
    mov secondBulletFirstTimeBool, 1 ; Reset the flag
    skip:

    mov dl, secondBulletX
    mov dh, secondBulletY
    call Gotoxy
    mov al, ' '
    dec secondBulletY
    call WriteChar

    skipUpdateBullet:
    ret
UpdateSecondBullet ENDP

DrawSecondBullet PROC

    cmp secondBulletActive, 0
    je skipDrawBullet
    ; Check if bullet is off-screen
    cmp secondBulletY, 0
    jle skipDrawBullet

    ; Draw the bullet:

   mov eax, yellow + (black * 16)
    call SetTextColor

    mov dl, secondBulletX
    mov dh, secondBulletY
    call Gotoxy
    mov al, bulletChar
    call WriteChar

    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor

    skipDrawBullet:
    ret
DrawSecondBullet ENDP

updateThirdBullet PROC

    cmp inputChar, ' '  ;only save player's coordinates if space is pressed
    jne skipSavingPlayerCoord

    cmp ThirdBulletFirstTimeBool, 1
    jne skipSavingPlayerCoord
    mov al, playerX
    mov thirdBulletX, al
    mov al, playerY
    mov thirdBulletY, al

    mov ThirdBulletFirstTimeBool, 0

    skipSavingPlayerCoord:

    cmp thirdBulletActive, 0
    je skipUpdateBullet

    ; Check if bullet is off-screen
    cmp thirdBulletY, 0
    jne skip
    mov thirdBulletActive, 0    ; bullet has passed the screen
    mov thirdBulletFirstTimeBool, 1 ; Reset the flag
    skip:

    mov dl, thirdBulletX
    mov dh, thirdBulletY
    call Gotoxy
    mov al, ' '
    dec thirdBulletY
    call WriteChar

    skipUpdateBullet:
    ret
updateThirdBullet ENDP

drawThirdBullet PROC

    cmp thirdBulletActive, 0
    je skipDrawBullet

    ; Draw the bullet:

   mov eax, yellow + (black * 16)
    call SetTextColor

    mov dl, thirdBulletX
    mov dh, thirdBulletY
    call Gotoxy
    mov al, bulletChar
    call WriteChar

    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor

    skipDrawBullet:
    ret
drawThirdBullet ENDP



;------------------------------------------
           ;Render Functions:
;------------------------------------------








endlp proc uses edx 
    mov edx, offset endl
    call writestring
    ret
endlp endp


animationseq3 PROC uses esi edx eax ecx
    ; Add vertical padding
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp

    ; Display airplane ASCII line by line
    mov edx, offset seq31
    call WriteString

    mov edx, offset seq32
    call WriteString

    mov edx, offset seq33
    call WriteString

    mov edx, offset seq34
    call WriteString

    mov edx, offset seq35
    call WriteString

    mov edx, offset seq36
    call WriteString

    mov edx, offset seq37
    call WriteString

    mov edx, offset seq38
    call WriteString

    mov edx, offset seq39
    call WriteString

    mov edx, offset seq310
    call WriteString

    mov edx, offset seq311
    call WriteString

    mov edx, offset seq312
    call WriteString

    mov edx, offset seq313
    call WriteString

    mov edx, offset seq314
    call WriteString

    mov edx, offset seq315
    call WriteString

    mov edx, offset seq316
    call WriteString

    mov edx, offset seq317
    call WriteString

    mov edx, offset seq318
    call WriteString

    mov edx, offset seq319
    call WriteString

    mov edx, offset seq320
    call WriteString

    mov edx, offset seq321
    call WriteString

    mov edx, offset seq322
    call WriteString

    mov edx, offset seq323
    call WriteString

    mov edx, offset seq324
    call WriteString

    mov edx, offset seq325
    call WriteString

    mov edx, offset seq326
    call WriteString

    mov edx, offset seq327
    call WriteString

    mov edx, offset seq328
    call WriteString

    ; Wait a moment to let the player see the airplane
    mov eax, 1500        ; 1.5 second delay
    call delay

    ret
animationseq3 ENDP



animationseq2 proc uses esi edx eax ecx 
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    
    mov edx, offset seq21 
    call writestring
    mov edx, offset seq22 
    call writestring
    mov edx, offset seq23 
    call writestring
    mov edx, offset seq24  
    call writestring
   
    mov eax, 1000
    call delay
    ret
animationseq2 endp




animationseq1 proc  uses esi edx eax ecx 
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
    call endlp
   
    mov edx, offset test1
    call writestring
    
    mov edx, offset test2
    call writestring
    
    mov edx, offset test3
    call writestring
    
    mov edx, offset test4
    call writestring
    
    mov edx, offset test5
    call writestring
    
    mov edx, offset test6
    call writestring
    mov eax, 1000
    call delay
    
    ret
animationseq1 endp

menu proc 
    call animationseq1
    mov eax, 500
    call delay 
    
    call clrscr 

    mov eax, 500
    call delay 
    call animationseq2

    mov eax, 500
    call delay 
    call animationseq3


    ret
menu endp







;------------------------------------------
           ;player movement:
;------------------------------------------







; Draw player
DrawPlayer PROC
    mov dl, playerX
    mov dh, playerY
    call Gotoxy
    mov al, playerChar
    call WriteChar
    ret
DrawPlayer ENDP

; Erase old player
UpdatePlayer PROC
    mov dl, playerX
    mov dh, playerY
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
UpdatePlayer ENDP







;------------------------------------------
           ;enemy movement:
;------------------------------------------


; Draw enemy-1
DrawEnemy PROC uses edx 
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, enemyX
    mov dh, enemyY
    call Gotoxy
    mov edx, OFFSET enemyChar
    call WriteString
    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawEnemy ENDP

; Draw enemy-2
DrawEnemy2 PROC uses edx 
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, enemySecondX
    mov dh, enemySecondY
    call Gotoxy
    mov edx, OFFSET enemyChar
    call WriteString
    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawEnemy2 ENDP

; Draw enemy-3
DrawEnemy3 PROC uses edx 
    mov eax, red + (black * 16)
    call SetTextColor
    mov dl, enemyThirdX
    mov dh, enemyThirdY
    call Gotoxy
    mov edx, OFFSET enemyChar
    call WriteString
    ;resetting color
    mov eax, white + (black * 16)
    call SetTextColor
    ret
DrawEnemy3 ENDP

; Clear old enemy and reset position
UpdateEnemy PROC
    call UpdateEnemyClear
    movzx eax, screenWidth    
    sub eax, 2
    call RandomRange
    add al, 1
    mov enemyX, al
    mov enemyY, 1
    ret
UpdateEnemy ENDP

; Clear old enemy and reset position for enemy-2:
UpdateEnemy2 PROC
    call UpdateEnemy2Clear
    movzx eax, screenWidth    
    sub eax, 2
    call RandomRange
    add al, 1
    mov enemySecondX, al
    mov enemySecondY, 1
    ret
UpdateEnemy2 ENDP

; Clear old enemy and reset position for enemy-2:
UpdateEnemy3 PROC
    call UpdateEnemy3Clear
    movzx eax, screenWidth    
    sub eax, 2
    call RandomRange
    add al, 1
    mov enemyThirdX, al
    mov enemyThirdY, 1
    ret
UpdateEnemy3 ENDP

UpdateEnemyClear PROC
    mov dl, enemyX
    mov dh, enemyY
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
UpdateEnemyClear ENDP

UpdateEnemy2Clear PROC
    mov dl, enemySecondX
    mov dh, enemySecondY
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
UpdateEnemy2Clear ENDP

UpdateEnemy3Clear PROC
    mov dl, enemyThirdX
    mov dh, enemyThirdY
    call Gotoxy
    mov al, ' '
    call WriteChar
    ret
UpdateEnemy3Clear ENDP

UpdateEnemyPosition PROC uses eax ebx
    call UpdateEnemyClear

    ; --- Change direction randomly every few moves ---
    inc dirChangeCounterEnemy1
    cmp dirChangeCounterEnemy1, 3     ; every 3 frames
    jne skipDirectionChange

    mov dirChangeCounterEnemy1, 0
    mov eax, 3
    call RandomRange            ; returns 0, 1, or 2
    mov enemyDirection, al

skipDirectionChange:

    ; --- Move based on current direction ---
    cmp enemyDirection, 0      ; left-down
    jne notLeft
    dec enemyX
    mov bl, leftboundary
    cmp enemyX, bl
    jg okayX
    mov bl, leftboundary
    mov enemyX, bl
okayX:
    jmp moveDown

notLeft:
    cmp enemyDirection, 2      ; right-down
    jne moveDown
    inc enemyX
    mov bl, rightboundary
    cmp enemyX, bl
    jl moveDown
    mov bl, rightboundary
    mov enemyX, bl

moveDown:
    inc enemyY
    mov al, lowerboundary
    cmp enemyY, al
    jle enemyOkay

    ; Reset if it reaches bottom
    call UpdateEnemy
    call DrawEnemy

enemyOkay:
    ret
UpdateEnemyPosition ENDP



UpdateEnemy2Position PROC uses eax ebx
    call UpdateEnemy2Clear

    ; --- Change direction randomly every few moves ---
    inc dirChangeCounterEnemy2
    cmp dirChangeCounterEnemy2, 3     ; every 3 frames
    jne skipDirectionChange

    mov dirChangeCounterEnemy2, 0
    mov eax, 3
    call RandomRange            ; returns 0, 1, or 2
    mov enemyDirection2, al

skipDirectionChange:

    ; --- Move based on current direction ---
    cmp enemyDirection2, 0      ; left-down
    jne notLeft
    dec enemySecondX
    mov bl, leftboundary
    cmp enemySecondX, bl
    jg okayX
    mov bl, leftboundary
    mov enemySecondX, bl
okayX:
    jmp moveDown

notLeft:
    cmp enemyDirection2, 2      ; right-down
    jne moveDown
    inc enemySecondX
    mov bl, rightboundary
    cmp enemySecondX, bl
    jl moveDown
    mov bl, rightboundary
    mov enemySecondX, bl

moveDown:
    inc enemySecondY
    mov al, lowerboundary
    cmp enemySecondY, al
    jle enemyOkay

    ; Reset if it reaches bottom
    call UpdateEnemy2
    call DrawEnemy2

enemyOkay:
    ret
UpdateEnemy2Position ENDP


UpdateEnemy3Position PROC uses eax ebx
    call UpdateEnemy3Clear

    ; --- Change direction randomly every few moves ---
    inc dirChangeCounterEnemy3
    cmp dirChangeCounterEnemy3, 3     ; every 3 frames
    jne skipDirectionChange

    mov dirChangeCounterEnemy3, 0
    mov eax, 3
    call RandomRange            ; returns 0, 1, or 2 into al
    mov enemyDirection3, al

skipDirectionChange:

    ; --- Move based on current direction ---
    cmp enemyDirection3, 0      ; left-down
    jne notLeft
    dec enemyThirdX
    mov bl, leftboundary
    cmp enemyThirdX, bl
    jg okayX
    mov bl, leftboundary
    mov enemyThirdX, bl
okayX:
    jmp moveDown

notLeft:
    cmp enemyDirection3, 2      ; right-down
    jne moveDown
    inc enemyThirdX
    mov bl, rightboundary
    cmp enemyThirdX, bl
    jl moveDown
    mov bl, rightboundary
    mov enemyThirdX, bl

moveDown:
    inc enemyThirdY
    mov al, lowerboundary
    cmp enemyThirdY, al
    jle enemyOkay

    ; Reset if it reaches bottom
    call UpdateEnemy3
    call DrawEnemy3

enemyOkay:
    ret
UpdateEnemy3Position ENDP

END main
