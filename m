Return-Path: <linux-kernel-owner+w=401wt.eu-S1757327AbYAXV6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327AbYAXV6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbYAXV6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:58:09 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46113 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYAXV6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:58:06 -0500
Date: Thu, 24 Jan 2008 22:58:13 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kbuild: Preparing for merge window
Message-ID: <20080124215813.GA4204@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is the list of patches queued up for the merge window at the moment.
I have during the last week done several modpost changes to make section ismatch
warnings more reliable and I am happy with the modified modpost code now.

The warnings generated will if CONFIG_DEBUG_SECTION_MISMATCH=y be verbose
so it better guides the developer how to fix the warning.

Other patches of interest:

- We now have separate sections for all init/exit annotations
- We have restarted getting kconfig globalized, pending is widechar support
- Support for modules.order to tell in what order to load modules
- lots of small fixes/enhancements

The diffstat say that we touch a lot of files.
This is due to the following changes (mainly):
- consolidation touching all .lds.S files
- removal ofstale comment about make dep
- removal of obsolete __attribute_used__
- removal of TOPDIR

Patches will follow for review.

	Sam

Adrian Bunk (4):
      Remove references to "make dep"
      kconfig: remove "enable"
      remove __attribute_used__
      asm-generic/vmlix.lds.h: simplify __mem{init,exit}* dependencies

Andi Kleen (3):
      kbuild: declare the modpost error functions as printf like
      kbuild: fix format string warnings in modpost
      kbuild: fix a buffer overflow in modpost

Andreas Mohr (1):
      kbuild: eradicate bashisms in scripts/patch-kernel

Andres Salomon (1):
      kconfig: use getopt() in conf.c for handling command line arguments

Aron Griffis (1):
      kbuild: support mercurial in setlocalversion

Daniel De Graaf (1):
      kbuild: support ARCH=x86 in buildtar

EGRY Gabor (10):
      kconfig: update-po-config info
      kconfig: whitespace removing
      kconfig: missing macros in gconfig
      kconfig: gettext support for gconfig
      kconfig: macro fix in menu.c
      kconfig: gettext support for xconfig
      kconfig: gettext support for menuconfig
      kconfig: gettext support for lxdialog
      kconfig: gettext support for config
      kconfig: gconfig: symbol fix

Geert Uytterhoeven (1):
      kbuild: Add missing srctree prefix for includecheck and versioncheck

Jan Beulich (2):
      kbuild: scripts/mkmakefile: dynamic determination of output directory
      kconfig: tristate choices with mixed tristate and boolean values

Jan Engelhardt (1):
      kconfig: allow overriding symbols

Johannes Berg (7):
      kernel-doc: fix xml output mode
      kernel-doc: init kernel version
      kernel-doc: single DOC: selection
      kernel-doc: process functions, not DOC:
      kernel-doc: use no-doc option
      kernel-doc: new P directive for DOC: sections
      convert drivers/base/power/Makefile to ccflags

Ladislav Michl (3):
      kconfig: make kconfig MinGW friendly
      kconfig: fix whitespace and sort includes in conf.c
      kconfig: use C89 random functions in conf.c

Mike Frysinger (1):
      kbuild: fixup genksyms usage/getopt

Randy Dunlap (3):
      kbuild: add 'includecheck' help text
      kconfig: add hints/tips/tricks to Documentation/kbuild/kconfig-language.txt
      kbuild: minor scripts/decodecode update

Robert P. J. Day (2):
      Kbuild: Clarify the rpm-related make packaging targets
      A few corrections to include/linux/Kbuild

Roman Zippel (3):
      kconfig: explicitly introduce expression list
      kconfig: environment symbol support
      kconfig: use environment option

Sam Ravnborg (22):
      kbuild: document versioncheck in make help
      kconfig: if ncurses-devel is missing then say so
      kbuild: fix buglet in gcc-version.sh
      kbuild: ignore *.order files
      kbuild: fix installing external modules
      kconfig: rename E_OR & friends to avoid name clash
      kconfig: delete unused FILE_ and SYMBOL_ flags
      kbuild: clean up modpost.c
      kbuild: fix so modpost can now check any .o file
      kbuild: try harder to find symbol names in modpost
      kbuild: code refactoring in modpost
      kbuild: introduce blacklisting in modpost
      kbuild: check section names consistently in modpost
      all archs: consolidate init and exit sections in vmlinux.lds.h
      compiler.h: introduce __section()
      Use separate sections for __dev/__cpu/__mem code/data
      kbuild: introduce new option to enhance section mismatch analysis
      kbuild: link vmlinux.o before kallsyms passes
      kbuild: use simpler section mismatch warnings in modpost
      kbuild: introduce a few helpers in modpost
      kbuild: simplified warning report in modpost
      kbuild: add verbose option to Section mismatch reporting in modpost

Tejun Heo (1):
      kbuild: implement modules.order

Theodore Ts'o (3):
      kbuild: change CONFIG_LOCALVERSION_AUTO to use a git-describe-ish format
      kbuild: fix scripts/setlocalversion to avoid erroneous -dirty tag
      kbuild: fix false positive -dirty tag caused by make-kpkg

Uwe Kleine-König (1):
      kbuild: ignore cache modifiers for generating the tags files

Valdis Kletnieks (1):
      kbuild: document 'make prepare' in 'make help'

Vegard Nossum (1):
      aic7(3*x): fix firmware build

WANG Cong (4):
      CRIS: Remove 'TOPDIR' from Makefiles
      INFINIBAND: Remove 'TOPDIR' from Makefiles
      FRV: Drop 'TOPDIR' from Makefiles
      FS: Remove dead code

 .gitignore                                  |    1 +
 Documentation/kbuild/kconfig-language.txt   |   75 ++-
 Makefile                                    |   28 +-
 arch/alpha/kernel/vmlinux.lds.S             |    8 +-
 arch/alpha/lib/dec_and_lock.c               |    3 +-
 arch/arm/kernel/vmlinux.lds.S               |   10 +-
 arch/arm/mach-imx/Makefile                  |    3 -
 arch/arm/mach-netx/Makefile                 |    3 -
 arch/avr32/kernel/vmlinux.lds.S             |    8 +-
 arch/blackfin/kernel/vmlinux.lds.S          |    8 +-
 arch/cris/arch-v10/vmlinux.lds.S            |    8 +-
 arch/cris/arch-v32/boot/compressed/Makefile |    2 +-
 arch/cris/arch-v32/vmlinux.lds.S            |    8 +-
 arch/frv/boot/Makefile                      |    8 +-
 arch/frv/kernel/gdb-stub.c                  |    2 +-
 arch/frv/kernel/vmlinux.lds.S               |   14 +-
 arch/h8300/kernel/vmlinux.lds.S             |    8 +-
 arch/ia64/kernel/vmlinux.lds.S              |    8 +-
 arch/m32r/kernel/vmlinux.lds.S              |   12 +-
 arch/m68k/kernel/vmlinux-std.lds            |    8 +-
 arch/m68k/kernel/vmlinux-sun3.lds           |    8 +-
 arch/m68knommu/kernel/vmlinux.lds.S         |    8 +-
 arch/mips/kernel/vmlinux.lds.S              |    8 +-
 arch/mips/tx4927/common/Makefile            |    4 -
 arch/mips/tx4938/common/Makefile            |    4 -
 arch/mips/tx4938/toshiba_rbtx4938/Makefile  |    4 -
 arch/parisc/kernel/vmlinux.lds.S            |    8 +-
 arch/powerpc/boot/Makefile                  |    2 +-
 arch/powerpc/kernel/sysfs.c                 |    2 +-
 arch/powerpc/kernel/vmlinux.lds.S           |   10 +-
 arch/powerpc/oprofile/op_model_power4.c     |    6 +-
 arch/ppc/kernel/vmlinux.lds.S               |    8 +-
 arch/s390/kernel/vmlinux.lds.S              |    8 +-
 arch/sh/kernel/vmlinux.lds.S                |    8 +-
 arch/sh64/kernel/Makefile                   |    4 -
 arch/sh64/kernel/vmlinux.lds.S              |    8 +-
 arch/sh64/lib/Makefile                      |    4 -
 arch/sh64/mach-cayman/Makefile              |    4 -
 arch/sh64/mm/Makefile                       |    4 -
 arch/sparc/kernel/vmlinux.lds.S             |    8 +-
 arch/sparc64/kernel/unaligned.c             |    2 +-
 arch/sparc64/kernel/vmlinux.lds.S           |    8 +-
 arch/um/include/init.h                      |   26 +-
 arch/um/kernel/dyn.lds.S                    |    4 +-
 arch/um/kernel/uml.lds.S                    |    4 +-
 arch/v850/kernel/vmlinux.lds.S              |   10 +-
 arch/x86/kernel/vmlinux_32.lds.S            |   14 +-
 arch/x86/kernel/vmlinux_64.lds.S            |   19 +-
 arch/xtensa/kernel/vmlinux.lds.S            |    9 +-
 arch/xtensa/mm/Makefile                     |    4 -
 arch/xtensa/platform-iss/Makefile           |    5 -
 drivers/base/power/Makefile                 |    8 +-
 drivers/infiniband/hw/cxgb3/Makefile        |    3 +-
 drivers/rapidio/rio.h                       |    4 +-
 drivers/scsi/aic7xxx/Makefile               |   45 +-
 fs/compat_ioctl.c                           |    2 +-
 fs/smbfs/Makefile                           |   20 -
 include/asm-avr32/setup.h                   |    2 +-
 include/asm-generic/vmlinux.lds.h           |   86 ++-
 include/asm-ia64/gcc_intrin.h               |    2 +-
 include/asm-sh/machvec.h                    |    2 +-
 include/asm-sh/thread_info.h                |    2 +-
 include/asm-x86/thread_info_32.h            |    2 +-
 include/linux/Kbuild                        |    8 +-
 include/linux/compiler-gcc3.h               |    2 -
 include/linux/compiler-gcc4.h               |    1 -
 include/linux/compiler.h                    |    9 +-
 include/linux/elfnote.h                     |    2 +-
 include/linux/init.h                        |  102 ++--
 include/linux/module.h                      |    4 +-
 include/linux/moduleparam.h                 |    4 +-
 include/linux/pci.h                         |    2 +-
 init/Kconfig                                |    8 +
 lib/Kconfig.debug                           |   32 +
 scripts/Makefile.build                      |   26 +-
 scripts/Makefile.lib                        |    6 +
 scripts/Makefile.modinst                    |    2 +-
 scripts/Makefile.modpost                    |    1 +
 scripts/basic/docproc.c                     |   44 +-
 scripts/decodecode                          |   17 +-
 scripts/gcc-version.sh                      |    5 +-
 scripts/genksyms/genksyms.c                 |   10 +-
 scripts/kconfig/Makefile                    |   39 +-
 scripts/kconfig/POTFILES.in                 |    7 +
 scripts/kconfig/conf.c                      |   69 +-
 scripts/kconfig/confdata.c                  |   24 +-
 scripts/kconfig/expr.c                      |   32 +-
 scripts/kconfig/expr.h                      |   16 +-
 scripts/kconfig/gconf.c                     |   16 +-
 scripts/kconfig/lex.zconf.c_shipped         |    5 +
 scripts/kconfig/lkc.h                       |    5 +
 scripts/kconfig/lxdialog/check-lxdialog.sh  |   16 +-
 scripts/kconfig/lxdialog/checklist.c        |    4 +-
 scripts/kconfig/lxdialog/dialog.h           |   11 +-
 scripts/kconfig/lxdialog/inputbox.c         |    4 +-
 scripts/kconfig/lxdialog/menubox.c          |    6 +-
 scripts/kconfig/lxdialog/textbox.c          |    2 +-
 scripts/kconfig/lxdialog/util.c             |   32 +-
 scripts/kconfig/lxdialog/yesno.c            |    4 +-
 scripts/kconfig/mconf.c                     |  112 +--
 scripts/kconfig/menu.c                      |   49 +-
 scripts/kconfig/qconf.cc                    |  109 ++--
 scripts/kconfig/symbol.c                    |   79 ++-
 scripts/kconfig/util.c                      |   23 +-
 scripts/kconfig/zconf.gperf                 |    2 +-
 scripts/kconfig/zconf.hash.c_shipped        |   19 +-
 scripts/kconfig/zconf.l                     |    5 +
 scripts/kernel-doc                          |   85 ++-
 scripts/mkmakefile                          |   10 +-
 scripts/mod/modpost.c                       | 1178 +++++++++++++++-----------
 scripts/mod/modpost.h                       |    2 +
 scripts/package/Makefile                    |    5 +-
 scripts/package/buildtar                    |    4 +-
 scripts/patch-kernel                        |   22 +-
 scripts/setlocalversion                     |   29 +-
 115 files changed, 1753 insertions(+), 1185 deletions(-)
