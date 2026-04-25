## Сборка PDF магистерской диссертации через Docker (mingc/latex).
##
## Цели:
##   make           — собрать main.pdf (xelatex + biber + xelatex × 2)
##   make quick     — быстрая сборка без библиографии
##   make clean     — удалить промежуточные файлы
##   make distclean — удалить и PDF, и промежуточные файлы

DOCKER_IMG ?= mingc/latex
DOCKER_RUN  = docker run --rm -i \
              -v $(PWD):/data \
              -v $(PWD)/fonts:/root/.fonts \
              $(DOCKER_IMG)

XELATEX = $(DOCKER_RUN) xelatex -interaction=nonstopmode -shell-escape main.tex
BIBER   = $(DOCKER_RUN) biber main

AUX_FILES := *.aux *.bbl *.bcf *.blg *.fdb_latexmk *.fls *.lof *.log *.lot \
             *.out *.run.xml *.synctex.gz *.toc *.xdv \
             chapters/*.aux Settings/*.aux

.PHONY: all quick clean distclean

all: main.pdf

main.pdf: main.tex chapters/*.tex Settings/*.tex refs.bib
	$(XELATEX)
	$(BIBER) || true
	$(XELATEX)
	$(XELATEX)

quick:
	$(XELATEX)

clean:
	rm -f $(AUX_FILES)

distclean: clean
	rm -f main.pdf
