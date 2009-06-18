Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZFRKLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZFRKLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZFRKLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:11:11 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34598 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbZFRKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:11:09 -0400
Date: Thu, 18 Jun 2009 19:10:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.31-rc1, part 2.
Message-ID: <20090618101017.GA30285@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Christoph Hellwig (1):
      sh: remove stray markers.

Guennadi Liakhovetski (3):
      soc-camera: unify i2c camera device platform data
      SH: convert ap325rxa to soc-camera as platform-device
      SH: convert migor to soc-camera as platform-device

Huang Weiyi (1):
      sh: pci: remove duplicated #include's

Magnus Damm (4):
      sh: smsc911x support for the rsk7203 board
      sh: unbreak WARN_ON()
      sh: use kzalloc() for cpg clocks
      sh: turn off irqs when disabling CMT/TMU timers

Matt Fleming (4):
      sh: Update my email address
      sh: Fix dynamic ftrace's NOP action.
      sh: Make the atomic functions safe for irqsoff tracing
      sh: Fix declaration of __kernel_sigreturn and __kernel_rt_sigreturn

Nobuhiro Iwamatsu (3):
      sh: Add support mtd mapping for highlander
      sh: Update r7780mp defconfig
      sh: Revised clock function in highlander

Paul Mundt (31):
      sh: Wire up sys_perf_counter_open.
      sh: intc: alloc_bootmem() -> kzalloc() conversion.
      sh: Bump the earlytimer bits back to time_init().
      sh: Use generic sched_clock().
      sh: Bump the earlytimer probe devices up.
      clocksource: Drop unused irqaction.mask from SH drivers.
      sh: Convert to asm-generic/current.h.
      sh: Convert to asm-generic/dma.h.
      sh: Convert to asm-generic/posix_types.h.
      sh: Convert to asm-generic/termbits.h and termios.h.
      sh: Convert ipc/shm bits to their asm-generic versions.
      sh: Tidy up duplication in irq/swab/timex.h.
      sh: Conver to asm-generic/mmu_context.h.
      sh: Convert to asm-generic/module.h.
      sh: Convert to asm-generic/unaligned.h.
      sh: Convert to asm-generic/scatterlist.h.
      sh: Convert to asm-generic/types.h.
      sh: Convert to asm-generic/signal.h.
      sh: Switch to asm-generic versions for identical headers.
      sh: Derive COMMAND_LINE_SIZE from asm-generic/setup.h.
      sh: Convert sh64 to use the generic checksum code.
      serial: sh-sci: Move over to dev_pm_ops.
      sh: urquell: Add system FPGA mode pin support.
      sh: Set EARLY_SCIF_CONSOLE_PORT sanely for SH7786.
      sh: pci: Allow register_pci_controller() to handle overlapping regions.
      sh: pci: SH7786 PCI ops.
      sh: Use generic atomic64_t implementation.
      sh: Generic HAVE_PERF_COUNTER support.
      sh: pci: Initial PCI-Express support for SH7786 Urquell board.
      sh: defconfig updates.
      sh: Enable soc-camera in ap325rxa/migor/se7724 defconfigs.

Rusty Russell (4):
      cpumask: remove the now-obsoleted pcibus_to_cpumask(): sh
      cpumask: arch_send_call_function_ipi_mask: sh
      cpumask: use mm_cpumask() wrapper: sh
      cpumask: Use accessors for cpu_*_mask: sh

Yoshihiro Shimoda (5):
      sh: sh7785lcr: add platform data for r8a66597-hcd
      sh: highlander: add platform data for r8a66597-hcd
      sh: x3proto: add platform data for r8a66597-hcd
      sh: add platform data for r8a66597-hcd in setup-sh7366
      sh: add platform data for r8a66597-hcd in setup-sh7723

 arch/sh/Kconfig                               |    6 +
 arch/sh/Kconfig.debug                         |    1 +
 arch/sh/boards/Kconfig                        |    1 +
 arch/sh/boards/board-ap325rxa.c               |   52 ++-
 arch/sh/boards/board-sh7785lcr.c              |   14 +-
 arch/sh/boards/board-urquell.c                |    7 +
 arch/sh/boards/mach-highlander/setup.c        |   64 +++-
 arch/sh/boards/mach-migor/setup.c             |   79 +++--
 arch/sh/boards/mach-rsk/devices-rsk7203.c     |    8 +-
 arch/sh/boards/mach-se/7780/irq.c             |    1 -
 arch/sh/boards/mach-x3proto/setup.c           |   12 +-
 arch/sh/configs/ap325rxa_defconfig            |   70 ++--
 arch/sh/configs/cayman_defconfig              |  165 +++-----
 arch/sh/configs/dreamcast_defconfig           |   78 ++--
 arch/sh/configs/edosk7705_defconfig           |   62 +--
 arch/sh/configs/edosk7760_defconfig           |   79 ++--
 arch/sh/configs/espt_defconfig                |   78 ++--
 arch/sh/configs/hp6xx_defconfig               |   70 ++--
 arch/sh/configs/landisk_defconfig             |  136 ++----
 arch/sh/configs/lboxre2_defconfig             |   83 ++--
 arch/sh/configs/magicpanelr2_defconfig        |   75 ++--
 arch/sh/configs/microdev_defconfig            |   76 ++--
 arch/sh/configs/migor_defconfig               |   78 ++--
 arch/sh/configs/polaris_defconfig             |   67 ++--
 arch/sh/configs/r7780mp_defconfig             |  183 ++++++--
 arch/sh/configs/r7785rp_defconfig             |   89 ++--
 arch/sh/configs/rsk7201_defconfig             |   77 ++--
 arch/sh/configs/rsk7203_defconfig             |  141 ++++--
 arch/sh/configs/rts7751r2d1_defconfig         |  106 +++---
 arch/sh/configs/rts7751r2dplus_defconfig      |  107 +++---
 arch/sh/configs/sdk7780_defconfig             |   88 ++--
 arch/sh/configs/se7206_defconfig              |   93 +++--
 arch/sh/configs/se7343_defconfig              |  219 ++++------
 arch/sh/configs/se7619_defconfig              |   70 ++--
 arch/sh/configs/se7705_defconfig              |   74 ++--
 arch/sh/configs/se7712_defconfig              |   78 ++--
 arch/sh/configs/se7721_defconfig              |   87 ++--
 arch/sh/configs/se7722_defconfig              |   80 ++--
 arch/sh/configs/se7724_defconfig              |   71 ++--
 arch/sh/configs/se7750_defconfig              |   80 ++--
 arch/sh/configs/se7751_defconfig              |   75 ++--
 arch/sh/configs/se7780_defconfig              |   90 ++---
 arch/sh/configs/sh03_defconfig                |   90 ++---
 arch/sh/configs/sh7710voipgw_defconfig        |   75 ++--
 arch/sh/configs/sh7724_generic_defconfig      |   72 ++--
 arch/sh/configs/sh7763rdp_defconfig           |   84 ++--
 arch/sh/configs/sh7770_generic_defconfig      |   66 ++--
 arch/sh/configs/sh7785lcr_32bit_defconfig     |   85 ++--
 arch/sh/configs/sh7785lcr_defconfig           |   85 ++--
 arch/sh/configs/shmin_defconfig               |   74 ++--
 arch/sh/configs/shx3_defconfig                |  125 ++++--
 arch/sh/configs/snapgear_defconfig            |   76 ++--
 arch/sh/configs/systemh_defconfig             |   66 +--
 arch/sh/configs/titan_defconfig               |   91 ++--
 arch/sh/configs/ul2_defconfig                 |   79 ++--
 arch/sh/configs/urquell_defconfig             |  584 +++++++++++++++++++++----
 arch/sh/drivers/pci/Makefile                  |    2 +
 arch/sh/drivers/pci/ops-dreamcast.c           |    1 -
 arch/sh/drivers/pci/ops-sh7786.c              |  134 ++++++
 arch/sh/drivers/pci/pci.c                     |   14 +-
 arch/sh/drivers/pci/pcie-sh7786.c             |  355 +++++++++++++++
 arch/sh/drivers/pci/pcie-sh7786.h             |  589 +++++++++++++++++++++++++
 arch/sh/include/asm/atomic-irq.h              |   24 +-
 arch/sh/include/asm/atomic.h                  |    2 +
 arch/sh/include/asm/checksum.h                |    2 +-
 arch/sh/include/asm/checksum_64.h             |   78 ----
 arch/sh/include/asm/current.h                 |   21 +-
 arch/sh/include/asm/dma.h                     |   10 +-
 arch/sh/include/asm/ipcbuf.h                  |   30 +--
 arch/sh/include/asm/irq.h                     |    2 +-
 arch/sh/include/asm/mman.h                    |   18 +-
 arch/sh/include/asm/mmu_context.h             |   22 +-
 arch/sh/include/asm/module.h                  |   12 +-
 arch/sh/include/asm/msgbuf.h                  |   32 +--
 arch/sh/include/asm/param.h                   |   23 +-
 arch/sh/include/asm/parport.h                 |   17 +-
 arch/sh/include/asm/perf_counter.h            |    7 +
 arch/sh/include/asm/posix_types_32.h          |  119 +-----
 arch/sh/include/asm/posix_types_64.h          |  127 +-----
 arch/sh/include/asm/scatterlist.h             |   24 +-
 arch/sh/include/asm/sembuf.h                  |   26 +-
 arch/sh/include/asm/serial.h                  |   20 +-
 arch/sh/include/asm/setup.h                   |    2 +-
 arch/sh/include/asm/shmbuf.h                  |   43 +--
 arch/sh/include/asm/signal.h                  |  147 +------
 arch/sh/include/asm/smp.h                     |    3 +-
 arch/sh/include/asm/socket.h                  |   61 +---
 arch/sh/include/asm/swab.h                    |    3 +-
 arch/sh/include/asm/termbits.h                |  199 +---------
 arch/sh/include/asm/termios.h                 |   91 +----
 arch/sh/include/asm/timex.h                   |    7 +-
 arch/sh/include/asm/topology.h                |    3 -
 arch/sh/include/asm/types.h                   |   16 +-
 arch/sh/include/asm/ucontext.h                |   13 +-
 arch/sh/include/asm/unaligned.h               |   14 +-
 arch/sh/include/asm/unistd_32.h               |    3 +-
 arch/sh/include/asm/unistd_64.h               |    3 +-
 arch/sh/include/mach-common/mach/highlander.h |    3 +
 arch/sh/kernel/cpu/clock-cpg.c                |   16 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7366.c        |   10 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c        |    9 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c            |    5 +-
 arch/sh/kernel/ftrace.c                       |   60 ++--
 arch/sh/kernel/process_32.c                   |    2 -
 arch/sh/kernel/process_64.c                   |    7 +-
 arch/sh/kernel/sh_ksyms_64.c                  |    7 -
 arch/sh/kernel/signal_32.c                    |    4 +-
 arch/sh/kernel/smp.c                          |   10 +-
 arch/sh/kernel/sys_sh.c                       |    2 -
 arch/sh/kernel/syscalls_32.S                  |    1 +
 arch/sh/kernel/syscalls_64.S                  |    1 +
 arch/sh/kernel/time.c                         |   27 +-
 arch/sh/kernel/traps.c                        |    1 +
 arch/sh/lib64/Makefile                        |    2 +-
 arch/sh/lib64/c-checksum.c                    |  214 ---------
 arch/sh/mm/fault_32.c                         |    4 -
 drivers/clocksource/sh_cmt.c                  |    4 +-
 drivers/clocksource/sh_mtu2.c                 |    1 -
 drivers/clocksource/sh_tmu.c                  |    4 +-
 drivers/media/video/ov772x.c                  |    6 +-
 drivers/media/video/tw9910.c                  |    6 +-
 drivers/serial/sh-sci.c                       |   18 +-
 drivers/sh/intc.c                             |   13 +-
 123 files changed, 3835 insertions(+), 3743 deletions(-)
 create mode 100644 arch/sh/drivers/pci/ops-sh7786.c
 create mode 100644 arch/sh/drivers/pci/pcie-sh7786.c
 create mode 100644 arch/sh/drivers/pci/pcie-sh7786.h
 delete mode 100644 arch/sh/include/asm/checksum_64.h
 create mode 100644 arch/sh/include/asm/perf_counter.h
 delete mode 100644 arch/sh/lib64/c-checksum.c
