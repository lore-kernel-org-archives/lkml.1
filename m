Return-Path: <linux-kernel-owner+w=401wt.eu-S1760697AbZLORgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbZLORgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760671AbZLORgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:36:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49308 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZLORgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:36:52 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Tue, 15 Dec 2009 12:36:50 -0500
Message-Id: <1260898610-25713-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 3ea6b3d0e6d0ffd91c0f8cadeb69b7133c038b32:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-udf-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Alexey Dobriyan (1):
      Blackfin: convert kgdbtest to proc_fops

Barry Song (10):
      Blackfin: add some bounds checking to peripheral_request
      Blackfin: bf537-stamp: need io.h for writeb() funcs
      Blackfin: support smaller uncached DMA chunks for memory constrained systems
      Blackfin: drop 4KB reserve at end of memory
      Blackfin: MPU: support XIP in async flash memory
      Blackfin: workaround anomaly 05000310
      Blackfin: dma-mapping.h: flesh out missing DMA mapping functions
      Blackfin: convert to asm-generic pci headers
      Blackfin: bf537-stamp: add CAN resources
      Blackfin: add support for TIF_NOTIFY_RESUME

Bernd Schmidt (1):
      Blackfin: improve async bank access checking (for cross-banks & XIP)

Cliff Cai (2):
      Blackfin: bf537-stamp: add adau1371 i2c address
      Blackfin: bf537-stamp: add adau1761 i2c address

David Daney (1):
      Blackfin: Convert BUG() to use unreachable()

Graf Yang (1):
      Blackfin: add C define of trace_buffer_init()

Michael Hennerich (13):
      Blackfin: clean up bf537-lq035 board resources
      Blackfin: convert DMA code to a proper bitmap
      Blackfin: cpufreq: use a constant latency
      Blackfin: bf538: add support for extended GPIO banks
      Blackfin: update bfin_rotary defines
      Blackfin: punt cache lock documentation
      Blackfin: fix typo in isp1760 platform name
      Blackfin: bf537-stamp/bf548-ezkit: update ADXL34x resources
      Blackfin: bf537-stamp: add ADXL346 orientation sensing support
      Blackfin: bf537-stamp: update ADP5520 resources
      Blackfin: bf537-stamp: add ADP8870 resources
      Blackfin: bf537-stamp: add AD5258 i2c address
      Blackfin: bf537-stamp: add ADF702x network driver resources

Mike Frysinger (47):
      Blackfin: convert to generic checksum code
      Blackfin: update defconfigs
      Blackfin: calculate on-chip lengths at link time rather than run time
      Blackfin: clean up isp1362 board resources
      Blackfin: BF51x/BF52x: fill out bfin_clear_PPI_STATUS()
      Blackfin: pull in firmware Kconfig
      Blackfin: push down asm/ includes and out of bfin-global.h
      Blackfin: convert DMA mutex to an atomic and drop redundant code
      Blackfin: coreb: switched to unlocked_ioctl
      Blackfin: rename BF542 host dma defines
      Blackfin: fix some BF547 header copy & paste typos
      Blackfin: unify BF547/8/9 headers
      Blackfin: scrub unused RTC masks
      Blackfin: scrub unused watchdog mmr masks
      Blackfin: BF51x: dump non-existent SPI/NFC MMRs
      Blackfin: punt OTP MMRs
      Blackfin: punt unused MXVR masks
      Blackfin: BF54x: punt useless "masks" for count/address MMRs
      Blackfin: H8606/ip0x: drop redundant SPI ctl_reg settings
      Blackfin: pull in asm/dpmc.h for power defines
      Blackfin: unify duplicated power masks
      Blackfin: unify DMA masks
      Blackfin: add an example showing how to use the gptimers API
      Blackfin: don't give CPU its own line in traps output
      Blackfin: add an uncompressed vmImage target
      Blackfin: comment the FDPIC PTRACE defines
      Blackfin: force BFD target when linking modules
      Blackfin: gptimers: use unsigned timer/group ids
      Blackfin: punt dead/unused flash mem_init settings
      bfin-otp: add BF51x to the supported arch list
      Blackfin: reject NULL callback in set_dma_callback()
      Blackfin: finish_atomic_sections: optimize the RTS step
      Blackfin: push BF5Xx configs down into mach-specific Kconfigs
      Blackfin: drop ptrace() write support for fixed code/bootrom
      Blackfin: io.h: fix random busted whitespace
      Blackfin: BF537: push down error masks to avoid namespace pollution
      Blackfin: BF52x: unify def/cdef headers
      Blackfin: BF51x: unify def/cdef headers
      Blackfin: bf537-stamp: kill AD714x board-specific Kconfigs
      Blackfin: drop unused ax88180 resources
      Blackfin: ip0x: pull in asm/portmux.h for P_xxx defines
      Blackfin: convert cyc2ns() to clocksource_cyc2ns()
      Blackfin: kgdb_test: clean up code a bit
      Blackfin: MPU: add missing __init markings
      Blackfin: NOMPU: skip DMA ICPLB hole when it is redundant
      Blackfin: drop duplicate sched_clock
      Blackfin: define __NR_recvmmsg

Philippe Gerum (4):
      Blackfin/ipipe: prepare status bitops for SMP support
      Blackfin/ipipe: fix forward ref to barrier()
      Blackfin/ipipe: introduce support for CONFIG_MPU
      Blackfin/ipipe: update version stamp

Robin Getz (2):
      Blackfin: announce current cpu rev when booting
      Blackfin: don't walk VMAs when oopsing

Sonic Zhang (1):
      Blackfin: kgdb: punt dead code

Valentin Yakovenkov (1):
      Blackfin: add support for the Acvilon BF561 board

Yi Li (4):
      Blackfin: fix gptimer0 clock source compile warning
      Blackfin: unify sched_clock() handling between clock sources
      Blackfin: use common code for cycle->nanosecond conversion
      Blackfin: SMP: don't start up core b until its state has been completely onlined

 Documentation/blackfin/00-INDEX                    |    3 -
 Documentation/blackfin/Makefile                    |    6 +
 Documentation/blackfin/cache-lock.txt              |   48 -
 Documentation/blackfin/cachefeatures.txt           |   10 -
 Documentation/blackfin/gptimers-example.c          |   83 +
 arch/blackfin/Kconfig                              |   41 +-
 arch/blackfin/Makefile                             |    4 +-
 arch/blackfin/boot/Makefile                        |    6 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig       |   14 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig        |    2 +
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    2 +
 arch/blackfin/configs/BF533-EZKIT_defconfig        |    2 +
 arch/blackfin/configs/BF533-STAMP_defconfig        |    2 +
 arch/blackfin/configs/BF537-STAMP_defconfig        |    7 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig        |    2 +
 arch/blackfin/configs/BF548-EZKIT_defconfig        |  332 ++-
 arch/blackfin/configs/BF561-ACVILON_defconfig      | 1643 +++++++++++++
 arch/blackfin/configs/BF561-EZKIT_defconfig        |  214 +-
 arch/blackfin/configs/BlackStamp_defconfig         |    2 +
 arch/blackfin/configs/CM-BF527_defconfig           |  390 ++-
 arch/blackfin/configs/CM-BF533_defconfig           |  631 +++---
 arch/blackfin/configs/CM-BF537E_defconfig          |  334 +++-
 arch/blackfin/configs/CM-BF537U_defconfig          |  620 +++--
 arch/blackfin/configs/CM-BF548_defconfig           |  793 ++++---
 arch/blackfin/configs/CM-BF561_defconfig           |  558 ++++--
 arch/blackfin/configs/H8606_defconfig              |    2 +
 arch/blackfin/configs/IP0X_defconfig               |    2 +
 arch/blackfin/configs/PNAV-10_defconfig            |    2 +
 arch/blackfin/configs/SRV1_defconfig               |    4 +-
 arch/blackfin/configs/TCM-BF537_defconfig          |  577 ++++-
 arch/blackfin/include/asm/bfin-global.h            |   10 +-
 arch/blackfin/include/asm/bug.h                    |    2 +-
 arch/blackfin/include/asm/cacheflush.h             |    1 +
 arch/blackfin/include/asm/checksum.h               |   70 +-
 arch/blackfin/include/asm/clocks.h                 |    2 +
 arch/blackfin/include/asm/dma-mapping.h            |  121 +-
 arch/blackfin/include/asm/dma.h                    |   93 +-
 arch/blackfin/include/asm/dpmc.h                   |  107 +-
 arch/blackfin/include/asm/gpio.h                   |    5 +
 arch/blackfin/include/asm/gptimers.h               |   32 +-
 arch/blackfin/include/asm/io.h                     |   95 +-
 arch/blackfin/include/asm/ipipe.h                  |   14 +-
 arch/blackfin/include/asm/ipipe_base.h             |   26 +-
 arch/blackfin/include/asm/irqflags.h               |   13 +-
 arch/blackfin/include/asm/kgdb.h                   |    3 -
 arch/blackfin/include/asm/mem_init.h               |  153 --
 arch/blackfin/include/asm/mmu_context.h            |   33 +-
 arch/blackfin/include/asm/pci.h                    |  130 +-
 arch/blackfin/include/asm/ptrace.h                 |    6 +-
 arch/blackfin/include/asm/sections.h               |   16 +-
 arch/blackfin/include/asm/thread_info.h            |    2 +
 arch/blackfin/include/asm/trace.h                  |    2 +
 arch/blackfin/include/asm/uaccess.h                |    4 +-
 arch/blackfin/include/asm/unistd.h                 |    3 +-
 arch/blackfin/kernel/bfin_dma_5xx.c                |   52 +-
 arch/blackfin/kernel/bfin_gpio.c                   |   99 +
 arch/blackfin/kernel/cplb-mpu/cplbinit.c           |    2 +-
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c            |   13 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |   31 +-
 arch/blackfin/kernel/dma-mapping.c                 |   68 +-
 arch/blackfin/kernel/gptimers.c                    |   32 +-
 arch/blackfin/kernel/ipipe.c                       |   67 +
 arch/blackfin/kernel/kgdb.c                        |   17 -
 arch/blackfin/kernel/kgdb_test.c                   |   67 +-
 arch/blackfin/kernel/process.c                     |   95 +-
 arch/blackfin/kernel/ptrace.c                      |   13 -
 arch/blackfin/kernel/setup.c                       |   46 +-
 arch/blackfin/kernel/signal.c                      |   18 +
 arch/blackfin/kernel/time-ts.c                     |   47 +-
 arch/blackfin/kernel/time.c                        |    8 -
 arch/blackfin/kernel/traps.c                       |   45 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |   28 +-
 arch/blackfin/lib/Makefile                         |    2 +-
 arch/blackfin/lib/checksum.c                       |  125 -
 arch/blackfin/mach-bf518/Kconfig                   |    4 +
 arch/blackfin/mach-bf518/include/mach/blackfin.h   |    6 -
 arch/blackfin/mach-bf518/include/mach/cdefBF514.h  |   13 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF516.h  |   80 +-
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h  |  247 +--
 .../mach-bf518/include/mach/cdefBF51x_base.h       |   75 +-
 arch/blackfin/mach-bf518/include/mach/defBF514.h   |   45 +-
 arch/blackfin/mach-bf518/include/mach/defBF516.h   |  213 +--
 arch/blackfin/mach-bf518/include/mach/defBF518.h   |  592 +-----
 .../mach-bf518/include/mach/defBF51x_base.h        |  186 --
 arch/blackfin/mach-bf527/Kconfig                   |    4 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   48 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |   62 +-
 arch/blackfin/mach-bf527/include/mach/blackfin.h   |    6 -
 arch/blackfin/mach-bf527/include/mach/cdefBF525.h  |   11 +-
 arch/blackfin/mach-bf527/include/mach/cdefBF527.h  |  424 +----
 .../mach-bf527/include/mach/cdefBF52x_base.h       |   23 +-
 arch/blackfin/mach-bf527/include/mach/defBF525.h   |   11 +-
 arch/blackfin/mach-bf527/include/mach/defBF527.h   |  679 +------
 .../mach-bf527/include/mach/defBF52x_base.h        |  186 --
 arch/blackfin/mach-bf533/boards/H8606.c            |    8 -
 arch/blackfin/mach-bf533/boards/ip0x.c             |   15 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |    6 -
 arch/blackfin/mach-bf533/include/mach/defBF532.h   |  115 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |   46 -
 arch/blackfin/mach-bf537/boards/stamp.c            |  386 ++-
 arch/blackfin/mach-bf537/include/mach/bf537.h      |   10 -
 arch/blackfin/mach-bf537/include/mach/blackfin.h   |    6 -
 arch/blackfin/mach-bf537/include/mach/defBF534.h   |   95 -
 arch/blackfin/mach-bf538/Makefile                  |    1 +
 arch/blackfin/mach-bf538/boards/ezkit.c            |   42 +
 arch/blackfin/mach-bf538/ext-gpio.c                |  123 +
 arch/blackfin/mach-bf538/include/mach/blackfin.h   |    6 -
 arch/blackfin/mach-bf538/include/mach/defBF539.h   | 1261 +----------
 arch/blackfin/mach-bf538/include/mach/gpio.h       |    7 +-
 arch/blackfin/mach-bf538/include/mach/portmux.h    |    2 +-
 arch/blackfin/mach-bf548/Kconfig                   |   24 +
 arch/blackfin/mach-bf548/boards/ezkit.c            |   59 +-
 arch/blackfin/mach-bf548/include/mach/bf548.h      |   12 -
 arch/blackfin/mach-bf548/include/mach/blackfin.h   |    6 -
 arch/blackfin/mach-bf548/include/mach/cdefBF547.h  |   12 +-
 arch/blackfin/mach-bf548/include/mach/cdefBF548.h  |  788 +------
 arch/blackfin/mach-bf548/include/mach/cdefBF549.h  | 1533 +------------
 .../mach-bf548/include/mach/cdefBF54x_base.h       |   22 -
 arch/blackfin/mach-bf548/include/mach/defBF544.h   |    4 +-
 arch/blackfin/mach-bf548/include/mach/defBF547.h   |   10 +-
 arch/blackfin/mach-bf548/include/mach/defBF548.h   | 1203 +----------
 arch/blackfin/mach-bf548/include/mach/defBF549.h   | 2526 +-------------------
 .../mach-bf548/include/mach/defBF54x_base.h        |  289 ---
 arch/blackfin/mach-bf561/boards/Kconfig            |    7 +
 arch/blackfin/mach-bf561/boards/Makefile           |    1 +
 arch/blackfin/mach-bf561/boards/acvilon.c          |  551 +++++
 arch/blackfin/mach-bf561/boards/ezkit.c            |   28 +-
 arch/blackfin/mach-bf561/coreb.c                   |    8 +-
 arch/blackfin/mach-bf561/include/mach/defBF561.h   |  101 -
 arch/blackfin/mach-bf561/smp.c                     |   17 +-
 arch/blackfin/mach-common/clocks-init.c            |    1 +
 arch/blackfin/mach-common/cpufreq.c                |    5 +-
 arch/blackfin/mach-common/dpmc_modes.S             |   30 +
 arch/blackfin/mach-common/entry.S                  |    4 +-
 arch/blackfin/mach-common/ints-priority.c          |   15 +-
 arch/blackfin/mach-common/smp.c                    |   16 +-
 drivers/char/Kconfig                               |    2 +-
 137 files changed, 6847 insertions(+), 13625 deletions(-)
 create mode 100644 Documentation/blackfin/Makefile
 delete mode 100644 Documentation/blackfin/cache-lock.txt
 create mode 100644 Documentation/blackfin/gptimers-example.c
 create mode 100644 arch/blackfin/configs/BF561-ACVILON_defconfig
 delete mode 100644 arch/blackfin/lib/checksum.c
 create mode 100644 arch/blackfin/mach-bf538/ext-gpio.c
 create mode 100644 arch/blackfin/mach-bf561/boards/acvilon.c
