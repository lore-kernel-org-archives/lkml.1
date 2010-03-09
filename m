Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab0CIOYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 09:24:45 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:41797 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab0CIOYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 09:24:43 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Tue,  9 Mar 2010 09:28:00 -0500
Message-Id: <1268144880-10895-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268144712-10500-1-git-send-email-vapier@gentoo.org>
References: <1268144712-10500-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 57d54889cd00db2752994b389ba714138652e60c:
  Linus Torvalds (1):
        Linux 2.6.34-rc1

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Barry Song (17):
      Blackfin: bf537-stamp: ad1938: switch to GPIO CS
      Blackfin: fix MPU page permission masks overflow when dealing with async memory
      Blackfin: replace harcoded define with proper THREAD_SIZE macro
      Blackfin: fix the section name of init_thread_union
      Blackfin: fix initial stack pointer setup
      Blackfin: initial XIP support
      Blackfin: bf533-{ezkit,stamp}: add sound platform devices
      Blackfin: bf537-stamp: declare parallel flash as ROM with XIP kernel
      Blackfin: fill out the signal si_addr when sending a SIGBUS/SIGSEGV
      Blackfin: bf548-ezkit: add ASoC CPU DAI resources
      Blackfin: bf537-stamp/bf527-ezkit: move ASoC SPORT resources to boards file
      Blackfin: respect the L1 kconfig optimization in the MPU code
      Blackfin: implement ndelay()
      Blackfin: add dma_disable_irq_nosync() API for irq handlers
      Blackfin: rename AD1938 to AD193X in board files
      Blackfin: bf537-stamp: add example AD715{0,2}/AD774{5,6,7} IIO resources
      Blackfin: rename AD1836 to AD183X in board files

Christoph Hellwig (1):
      Blackfin: use generic ptrace_resume code

Cliff Cai (2):
      Blackfin: bf527-ezkit/bf537-stamp: add example SSM2602 I2C resources
      Blackfin: bf537-stamp: add example ADAU1361 resources

Frans Pop (1):
      Blackfin: remove trailing space in messages

Graf Yang (12):
      Blackfin: SMP: enable HAVE_LEGACY_PER_CPU_AREA
      Blackfin: drop cpu_callin_map on SMP systems
      Blackfin: SMP: add PM/CPU hotplug support
      Blackfin: fix up mm locking in address dumping
      Blackfin: implement nmi_watchdog for SMP on BF561
      Blackfin: split watchdog definitions into a dedicated header file
      Blackfin: add support for cpufreq on SMP systems
      Blackfin: rewrite resync_core_{i,d}cache() SMP logic to avoid per_cpu data
      Blackfin: bf537-stamp: add example AD2S90 resources
      Blackfin: bf537-stamp: add example AD2S120x resources
      Blackfin: bf537-stamp: add example AD2S1210 IIO resources
      Blackfin: scale calibration when cpu freq changes

Harald Krapfenbauer (1):
      Blackfin: tcm-bf518: new board port

Jie Zhang (1):
      Blackfin: fix relocation errors with large initramfs images

Joachim Eastwood (2):
      Blackfin: GPIO: implement to_irq handler
      Blackfin: mark gpio lib functions static

Michael Hennerich (13):
      Blackfin: bf527-ezkit: add support for V2.1 boards
      Blackfin: extend bfin-lq035q1-fb resources to include PPI mode
      Blackfin: pull in asm/bfin_can.h for interrupt masks
      Blackfin: gpio: use shorter name
      Blackfin: update AD7879 resources to match the new gpiolib driver support
      Blackfin: BF51x: fix L1 Instruction SRAM size
      Blackfin: add optimized version of Hamming Weight functions
      Blackfin: increase NR_IRQS beyond NR on-chip IRQs
      Blackfin: bf537-stamp: add example ADS7846 touchscreen resources
      Blackfin: add support for the on-chip MAC status interrupts
      Blackfin: bf537-stamp: add example ADP8860 backlight/led resources
      Blackfin: don't support keypad wakeup from hibernate
      Blackfin: bf537-stamp: add example ADXL346 orientation resources

Mike Frysinger (24):
      Blackfin: bfin_sport: unify & standardize SPORT masks
      Blackfin: wire up the various memory related syscalls
      Blackfin: merge common CAN defines into one headers
      Blackfin: drop duplicate HOTPLUG Kconfig option
      Blackfin: drop unused SL811 platform resources from bf527/pnav boards
      Blackfin: bf537-stamp: change CONFIG_USB_SL811_BFIN_IRQ to IRQ_PF4
      Blackfin: isram: add unlikely to sanity checks
      Blackfin: unify MMR helpers
      Blackfin: kgdb: mark all local funcs/structs static
      Blackfin: bf537-stamp: move ADF7021 MAC storage into platform resources
      Blackfin: implement ftrace mcount test
      Blackfin: support new ftrace frame pointer semantics
      Blackfin: fix whitespace damage in thread_info.h
      Blackfin: move KGDB selection to the way other arches do it
      Blackfin: simplify SYSCFG code a bit and ignore attempts to change it
      Blackfin: simplify PTRACE_{PEEK,POKE}USR in preperation for regset support
      Blackfin: initial regset support
      Blackfin: initial tracehook support
      Blackfin: fix single stepping over system calls
      Blackfin: check for bad syscalls after tracing it
      Blackfin: add support for restart_syscall()
      Blackfin: asm/page.h: pull in asm-generic headers
      Blackfin: eat spurious space in asm/dpmc.h
      Blackfin: stop cleaning include/asm/asm-offsets.h

Robin Getz (1):
      Blackfin: fix anomaly 283 handling with exact hardware error

Roel Kluin (1):
      Blackfin: fix decoding of opcodes 41-47 in decode_instruction()

Sonic Zhang (13):
      Blackfin: move on-chip UART resources to boards files
      Blackfin: move SPORT UART resources to boards files
      Blackfin: allow boards to register early devices
      Blackfin: add UART/SPORT early platform resources
      Blackfin: MPU: handle caches for reserved memory
      Blackfin: dma-mapping: fix thinko in constant optimization
      Blackfin: bf537-stamp: unify duplicated ADP5588 headers
      Blackfin: update defconfigs
      Blackfin: SMP: add support for IRQ affinity
      Blackfin: bf537-stamp: add example AD5398 power regulator resources
      Blackfin: bf537-stamp: add example ADP122/ADP150 power regulator resources
      Blackfin: bf537-stamp: add example AD7414 temp sensor resources
      Blackfin: bf537-stamp: add example AD7416 IIO resources

Valentin Yakovenkov (1):
      Blackfin: bf561-acvilon: save the smsc911x mac address

Yi Li (6):
      Blackfin: flush caches on SMP when one core calls another via IPI
      Blackfin: SMP: make core timers per-cpu clock events for HRT
      Blackfin: simplify SMP handling in SRAM code
      Blackfin: try to simplify interrupt ifdef ugliness
      Blackfin: add support for irqflags tracing
      Blackfin: add CALLER_ADDR ftrace macros

 arch/blackfin/Kconfig                           |   81 +-
 arch/blackfin/Kconfig.debug                     |   12 +-
 arch/blackfin/Makefile                          |    7 +-
 arch/blackfin/boot/Makefile                     |   23 +-
 arch/blackfin/configs/BF518F-EZBRD_defconfig    |  270 +++--
 arch/blackfin/configs/BF526-EZBRD_defconfig     |  336 +++--
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig  | 1811 +++++++++++++++++++++++
 arch/blackfin/configs/BF527-EZKIT_defconfig     |  344 +++--
 arch/blackfin/configs/BF533-EZKIT_defconfig     |  250 ++--
 arch/blackfin/configs/BF533-STAMP_defconfig     |  295 +++--
 arch/blackfin/configs/BF537-STAMP_defconfig     |  332 +++--
 arch/blackfin/configs/BF538-EZKIT_defconfig     |  291 +++--
 arch/blackfin/configs/BF548-EZKIT_defconfig     |  108 +-
 arch/blackfin/configs/BF561-ACVILON_defconfig   |   15 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig     |   82 +-
 arch/blackfin/configs/H8606_defconfig           |    7 -
 arch/blackfin/configs/PNAV-10_defconfig         |  295 +++--
 arch/blackfin/configs/TCM-BF518_defconfig       | 1375 +++++++++++++++++
 arch/blackfin/include/asm/bfin-lq035q1.h        |   12 +
 arch/blackfin/include/asm/bfin_can.h            |  725 +++++++++
 arch/blackfin/include/asm/bfin_sport.h          |  227 ++--
 arch/blackfin/include/asm/bfin_watchdog.h       |   30 +
 arch/blackfin/include/asm/bitops.h              |   74 +-
 arch/blackfin/include/asm/context.S             |   22 +
 arch/blackfin/include/asm/cpu.h                 |    2 -
 arch/blackfin/include/asm/def_LPBlackfin.h      |   58 +-
 arch/blackfin/include/asm/delay.h               |   16 +-
 arch/blackfin/include/asm/dma-mapping.h         |   15 +-
 arch/blackfin/include/asm/dma.h                 |    4 +
 arch/blackfin/include/asm/dpmc.h                |    4 +-
 arch/blackfin/include/asm/elf.h                 |    8 +-
 arch/blackfin/include/asm/ftrace.h              |   53 +
 arch/blackfin/include/asm/gpio.h                |   17 +-
 arch/blackfin/include/asm/irq.h                 |    7 +
 arch/blackfin/include/asm/mmu_context.h         |   14 +-
 arch/blackfin/include/asm/nmi.h                 |   12 +
 arch/blackfin/include/asm/page.h                |    3 +
 arch/blackfin/include/asm/ptrace.h              |   25 +
 arch/blackfin/include/asm/sections.h            |    3 +
 arch/blackfin/include/asm/smp.h                 |   15 +
 arch/blackfin/include/asm/syscall.h             |   96 ++
 arch/blackfin/include/asm/thread_info.h         |   25 +-
 arch/blackfin/include/asm/time.h                |   13 +-
 arch/blackfin/kernel/Makefile                   |    1 +
 arch/blackfin/kernel/bfin_dma_5xx.c             |   10 +-
 arch/blackfin/kernel/bfin_gpio.c                |   20 +-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c        |    9 +
 arch/blackfin/kernel/cplb-mpu/cplbmgr.c         |   54 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c      |    9 +
 arch/blackfin/kernel/dma-mapping.c              |    2 +-
 arch/blackfin/kernel/entry.S                    |    8 +-
 arch/blackfin/kernel/ftrace-entry.S             |   23 +-
 arch/blackfin/kernel/ftrace.c                   |    6 +-
 arch/blackfin/kernel/init_task.c                |    2 +-
 arch/blackfin/kernel/kgdb.c                     |   10 +-
 arch/blackfin/kernel/nmi.c                      |  299 ++++
 arch/blackfin/kernel/process.c                  |    7 -
 arch/blackfin/kernel/ptrace.c                   |  360 ++---
 arch/blackfin/kernel/setup.c                    |   34 +-
 arch/blackfin/kernel/signal.c                   |   24 +-
 arch/blackfin/kernel/time-ts.c                  |  205 ++--
 arch/blackfin/kernel/traps.c                    |   32 +-
 arch/blackfin/kernel/vmlinux.lds.S              |   70 +-
 arch/blackfin/mach-bf518/boards/Kconfig         |    5 +
 arch/blackfin/mach-bf518/boards/Makefile        |    1 +
 arch/blackfin/mach-bf518/boards/ezbrd.c         |  178 +++-
 arch/blackfin/mach-bf518/boards/tcm-bf518.c     |  753 ++++++++++
 arch/blackfin/mach-bf518/include/mach/irq.h     |   12 +-
 arch/blackfin/mach-bf518/include/mach/mem_map.h |    2 +-
 arch/blackfin/mach-bf527/boards/Kconfig         |    5 +
 arch/blackfin/mach-bf527/boards/Makefile        |    1 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c      |  245 +++-
 arch/blackfin/mach-bf527/boards/ezbrd.c         |  199 +++-
 arch/blackfin/mach-bf527/boards/ezkit.c         |  431 +++++--
 arch/blackfin/mach-bf527/include/mach/irq.h     |   12 +-
 arch/blackfin/mach-bf533/boards/H8606.c         |   66 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c    |  134 ++-
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |  138 ++-
 arch/blackfin/mach-bf533/boards/ezkit.c         |  102 ++-
 arch/blackfin/mach-bf533/boards/ip0x.c          |   63 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |  174 ++-
 arch/blackfin/mach-bf533/include/mach/irq.h     |    3 +-
 arch/blackfin/mach-bf537/boards/cm_bf537e.c     |  116 ++-
 arch/blackfin/mach-bf537/boards/cm_bf537u.c     |  187 +++-
 arch/blackfin/mach-bf537/boards/minotaur.c      |  183 +++-
 arch/blackfin/mach-bf537/boards/pnav10.c        |  169 ++-
 arch/blackfin/mach-bf537/boards/stamp.c         |  684 ++++++++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c     |  187 +++-
 arch/blackfin/mach-bf537/include/mach/irq.h     |   12 +-
 arch/blackfin/mach-bf538/boards/ezkit.c         |  346 ++++-
 arch/blackfin/mach-bf538/include/mach/irq.h     |    3 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c      |  399 +++++-
 arch/blackfin/mach-bf548/boards/ezkit.c         |  443 ++++++-
 arch/blackfin/mach-bf548/include/mach/irq.h     |    3 +-
 arch/blackfin/mach-bf561/Makefile               |    1 +
 arch/blackfin/mach-bf561/boards/acvilon.c       |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |   66 +-
 arch/blackfin/mach-bf561/boards/ezkit.c         |   70 +-
 arch/blackfin/mach-bf561/boards/tepla.c         |   68 +
 arch/blackfin/mach-bf561/hotplug.c              |   32 +
 arch/blackfin/mach-bf561/include/mach/irq.h     |    3 +-
 arch/blackfin/mach-bf561/include/mach/smp.h     |    2 +
 arch/blackfin/mach-bf561/secondary.S            |   50 +-
 arch/blackfin/mach-bf561/smp.c                  |   44 +-
 arch/blackfin/mach-common/cpufreq.c             |  168 ++-
 arch/blackfin/mach-common/entry.S               |   81 +-
 arch/blackfin/mach-common/head.S                |   16 +-
 arch/blackfin/mach-common/interrupt.S           |   35 +-
 arch/blackfin/mach-common/ints-priority.c       |  208 +++-
 arch/blackfin/mach-common/smp.c                 |   87 +-
 arch/blackfin/mm/isram-driver.c                 |    6 +-
 arch/blackfin/mm/sram-alloc.c                   |   27 +-
 112 files changed, 12548 insertions(+), 2273 deletions(-)
 create mode 100644 arch/blackfin/configs/BF527-EZKIT-V2_defconfig
 create mode 100644 arch/blackfin/configs/TCM-BF518_defconfig
 create mode 100644 arch/blackfin/include/asm/bfin_can.h
 create mode 100644 arch/blackfin/include/asm/bfin_watchdog.h
 create mode 100644 arch/blackfin/include/asm/nmi.h
 create mode 100644 arch/blackfin/include/asm/syscall.h
 create mode 100644 arch/blackfin/kernel/nmi.c
 create mode 100644 arch/blackfin/mach-bf518/boards/tcm-bf518.c
 create mode 100644 arch/blackfin/mach-bf561/hotplug.c
