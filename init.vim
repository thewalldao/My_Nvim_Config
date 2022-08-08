" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" General Plugin
" Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sbdchd/neoformat'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'airblade/vim-gitgutter'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'vimwiki/vimwiki'
Plug 'lilydjwg/colorizer'
Plug 'mhinz/vim-startify'
Plug 'kevinhwang91/rnvimr'
" Plug 'ap/vim-buftabline'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'luochen1990/rainbow'

" Color Schemes , Icon
Plug 'joshdick/onedark.vim'
Plug 'mhartington/oceanic-next'
Plug 'ryanoasis/vim-devicons'
Plug 'icymind/neosolarized'
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as' : 'dracula' }

Plug 'weirongxu/coc-explorer', {'do': 'yarn install --frozen-lockfile'}
" Initialize plugin system
call plug#end()

"-------------------------------------------------------------
" General Setting
"-------------------------------------------------------------
" neovide setting
let g:neovide_cursor_animation_length = 0
" let g:neovide_cursor_vfx_mode = ""

" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.

let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window the right the current one
    wincmd j
    resize 10
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window below the current one
    wincmd j   
    resize 10
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif

  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")

  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

" With this maps you can now toggle the terminal
nnoremap <F8> :call MonkeyTerminalToggle()<cr>
tnoremap <F8> <C-\><C-n>:call MonkeyTerminalToggle()<cr>

" This an example on how specify command with different types of files.
    augroup go
        autocmd!
        autocmd BufRead,BufNewFile *.go set filetype=go
        autocmd FileType go nnoremap <F5> :call MonkeyTerminalExec('go run ' . expand('%'))<cr>
    augroup END

set guifont=Noto\ Sans\ Mono:h10
filetype plugin indent on
tnoremap <Esc> <C-\><C-n>:q!<CR> " close term
nmap <Leader>kt :set keymap=vietnamese-telex<CR>
nmap <Leader>kd :set keymap=<CR>
" nnoremap <silent> <expr> <F3> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
nmap <F2> :GitGutterToggle<CR>
nmap <F3> :RnvimrToggle<CR>
nmap <F4> :Startify<CR>
nmap <F5> :CocCommand explorer --width 35<CR>
nmap <F6> :TagbarToggle<CR>
nmap <F7> :UndotreeToggle<cr>
nmap <C-p> :FZF<CR>
nmap <space>e :CocCommand explorer<CR>
" autocmd Filetype python nnoremap <buffer> <F9> :w<CR>:vert term python "%"<CR>
" autocmd Filetype c,cpp nnoremap <buffer> <F9> :w<CR> :vert term make<CR>
" autocmd Filetype c,cpp nnoremap <buffer> <F10> :w<CR> :vert term ./%<<CR>
autocmd Filetype python nmap <buffer> <F9> :w<CR> :12sp <CR> :term python "%"<CR>
autocmd Filetype c,cpp nmap <buffer> <F9> :w<CR> :12sp <CR> :term make<CR>
autocmd Filetype c,cpp nmap <buffer> <F10> :w<CR> :12sp <CR> :term "./%<"<CR>
autocmd Filetype java nmap <buffer> <F9> :w<CR> :12sp <CR> :term javac "%"<CR>
autocmd Filetype java nmap <buffer> <F10> :w<CR> :12sp <CR> :term java -enableassertions "%<"<CR>
autocmd Filetype rust nmap <buffer> <F9> :w<CR> :12sp <CR> :term cargo run <CR>
autocmd Filetype pascal nmap <buffer> <F9> :w<CR> :12sp <CR> :term fpc "%"<CR>
autocmd Filetype pascal nmap <buffer> <F10> :w<CR> :12sp <CR> :term "./%<"<CR>
autocmd Filetype typescript nmap <buffer> <F9> :w<CR> :12sp <CR> :term tsc "%"<CR>
autocmd Filetype typescript nmap <buffer> <F10> :w<CR> :12sp <CR> :term node "./%<"<CR>
autocmd Filetype javascript nmap <buffer> <F9> :w<CR> :12sp <CR> :term node "./%<"<CR>
nmap gb :ls<CR>:b<Space>
nmap <CR> :nohlsearch<cr>
" navigate window easier
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>
nmap <C-H> <C-W><C-H>

syntax enable
autocmd BufEnter * silent! lcd %:p:h " set auto cd to dir of current file
set clipboard=unnamedplus " coppy vim to outside "need install xclip"
set clipboard=unnamed
set clipboard+=unnamedplus " coppy vim to outside "need install xclip"
set noswapfile
set encoding=UTF-8
set termguicolors
set splitbelow
set splitright
set hlsearch
set incsearch
set t_Co=256
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes
let g:airline_theme= 'dracula'
let g:neosolarized_termcolors=256
let g:neosolarized_contrast = "normal"
let g:neosolarized_visibility = "normal"
let g:neosolarized_vertSplitBgTrans = 1
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 0
let g:neosolarized_termBoldAsBright = 1
let g:onedark_termcolors=256
let g:onedark_hide_endofbuffer=1
let g:onedark_terminal_italics=1
let g:gruvbox_termcolors=255
let g:gruvbox_italic=1
let g:gruvbox_contrast_light='medium'
let g:gruvbox_sign_column='bg0'
let g:dracula_italic = 1
colorscheme dracula
set background=dark " use dark mode

" set background=light " uncomment to use light mode
" True color
set number "relativenumber
set mouse=a
" set foldmethod=syntax
autocmd FileType c,cpp set noet sw=4
autocmd FileType python set et sw=4
autocmd FileType java set et sw=4
" " show existing tab with 4 spaces width
" set tabstop=4
" " when indenting with '>', use 4 spaces width
" set shiftwidth=4
" " On pressing tab, insert 4 spaces
" set expandtab
" highlight ColorColumn ctermbg=0 guibg=onedark
nmap <silent> <leader>c :execute "set colorcolumn="
                  \ . (&colorcolumn == "" ? "80" : "")<CR>

" easymotion
map <Leader> <Plug>(easymotion-prefix)

" vim buffer
" set hidden

" rainbow parentheses
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle

" neoformat
let g:neoformat_run_all_formatters = 1

" Startify
let g:startify_bookmarks = [
	\ '$HOME/.config/nvim/init.vim',
	\ '~/Mega/PROGRAM_BOOK/Learn_Java/Absolute_Java/Test.java',
        \ '~/Mega/PROGRAM_BOOK/Py_ICS/test.py',
	\ '~/Mega/PROGRAM_BOOK/C_language/test.c'
	\ ]
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']       },
          \ { 'type': 'files',     'header': ['   MRU']             },
          \ { 'type': 'dir',       'header': ['   MRU '. getcwd()]  },
          \ { 'type': 'sessions',  'header': ['   Sessions']        },
          \ { 'type': 'commands',  'header': ['   Commands']        },
          \ ]
let g:startify_files_number = 5


" gitguter
let g:gitgutter_max_signs = 500  " default value
nmap ]`h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)
nmap ghp <Plug>(GitGutterPreviewHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)

" fzf

let g:fzf_tags_command = 'ctags -R'
" Border color
" let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" rnvimr
let g:rnvimr_layout = { 'relative': 'editor',
	    \ 'width': float2nr(round(0.8 * &columns)),
	    \ 'height': float2nr(round(0.8 * &lines)),
	    \ 'col': float2nr(round(0.1 * &columns)),
	    \ 'row': float2nr(round(0.1 * &lines)),
	    \ 'style': 'minimal' }


" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
" let g:airline#extensions#tabline#show_close_button = 1
" let g:airline#extensions#tabline#close_symbol = '×'
" let g:airline#extensions#tabline#fnamemod = ':t'
" let g:airline_detect_modified=1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '>'
nnoremap <C-PageUp> :bnext<CR>
nnoremap <C-PageDown> :bprev<CR>
nnoremap <C-Home> :bfirst<CR>
nnoremap <C-End> :blast<CR>

" fzf
let g:fzf_tags_command = 'ctags -R'
" Border color
" let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

" rnvimr
let g:rnvimr_layout = { 'relative': 'editor',
	    \ 'width': float2nr(round(0.8 * &columns)),
	    \ 'height': float2nr(round(0.8 * &lines)),
	    \ 'col': float2nr(round(0.1 * &columns)),
	    \ 'row': float2nr(round(0.1 * &lines)),
	    \ 'style': 'minimal' }

" coc.vim
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>"python.jediEnabled": false

" Autoinstall coc extension  
let g:coc_global_extensions = [
\ 'coc-pyright',
\ 'coc-rls',
\ 'coc-java',
\ 'coc-cmake',
\ 'coc-marketplace',
\ 'coc-rust-analyzer',
\ 'coc-explorer',
\ 'coc-tsserver',
\ 'coc-eslint',
\ 'coc-json',
\ 'coc-css',
\ ]
