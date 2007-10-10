Return-Path: <linux-kernel-owner+w=401wt.eu-S1754667AbXJJKkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667AbXJJKkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbXJJKki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:40:38 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:46171 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752228AbXJJKkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:40:37 -0400
Date: Wed, 10 Oct 2007 19:40:13 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [GIT PULL] sh updates for 2.6.24-rc1
Message-ID: <20071010104013.GA28026@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Adrian McMenamin (4):
      fb: pvr2fb: Shared IRQ for dreamcast pvr2.
      sh: Add maple bus support for the SEGA Dreamcast.
      video: pvr2fb: Add TV (RGB) support to Dreamcast PVR driver.
      sh: Fix SH-4 DMAC CHCR masking.

Aoi Shinkai (1):
      sh: rts7751r2d cf_ide rework

Kristoffer Ericson (9):
      sh: Fix OFFCHIP_IRQ_BASE compile error.
      sh: update hp6xx defconfig.
      sh: hp6xx: APM build fix and new battery values.
      backlight: Fix up hp680_bl build.
      sh: hd64461: Trivial build fixes for SH7709.
      sh: dma: Fix up build for SH7709 support.
      sh: hp6xx: Update CF IRQ for INTC changes.
      sh: hp6xx: Enable touchscreen and powerbutton IRQs.
      sh: hp6xx: Enable pata_platform in defconfig.

Magnus Damm (37):
      sh: intc - add support for SH7705
      sh: intc - add support for SH7710
      sh: intc - add support for SH7706, SH7707, SH7708, SH7709
      sh: intc - add missing vectors for SH7707
      sh: intc - avoid SH7710 specific vector on SH7712
      sh: intc - add support for SH7785
      sh: intc - add support for SH7760
      sh: simplify se7780 IRQ code
      sh: intc - fix IRQ4 and IRQ5 typo on sh3
      sh: intc - add support for x3
      sh: intc - remove redundant irq code for sh03, snapgear and titan
      sh: intc - remove redundant irq code for shmin
      sh: intc - add single bitmap register support
      sh: intc - convert voyagergx code
      sh: remove intc2 code
      sh: x3 - fix setup_bootmem_node() compile error with shx3_defconfig
      sh: intc - add a clear register to struct intc_prio_reg
      sh: intc - rework core code
      sh: intc - convert board specific r2d code
      sh: replace sh specific CONFIG_VOYAGERGX with CONFIG_MFD_SM501
      sh: x3 - add ipi vectors
      sh: intc - mark data structures as __initdata
      sh: intc - primary priority masking fixes
      sh: fix irqs for the second serial port on sh7206
      sh: intc - add support for sh7619
      sh: intc - add support for sh7206
      sh: defconfigs for R2D-PLUS and for R2D-1
      sh: remove CONFIG_CPU_HAS_INTC_IRQ
      sh: intc - irl mode update for sh7780 and sh7785
      sh: minor fixes
      sh: intc - rework higlander irq code for r7780mp and r7785rp
      sh: remove sh7780 interrupt controller hack from pci code
      sh: add writesb(), readsb(), writesw() and readsw() to io.h
      sh: intc - initial SMP support.
      sh: Hook up the SH-X3 SMP intc register groups.
      sh: fix r2d board detection
      sh: allow building for both r2d boards in same binary.

Markus Brunner (4):
      sh: Add gpio.h stubs for PFC definitions.
      sh: Add SH7720 CPU support.
      sh: Magic Panel R2 board support.
      sh: Magic Panel MTD mapping update.

Paul Mundt (66):
      sh: Support explicit L1 cache disabling.
      sh: Fix cache disabling build failures on nommu.
      sh: Initial multiple-node support for SH-X3.
      rtc: rtc-sh: Support 4-digit year on SH7705/SH7710/SH7712.
      sh: intc: Fix sense regs oops for IRL IRQs.
      sh: Plug in SH-X3 SCIF0 for sercon earlyprintk.
      sh: Initial support for SH-X3 prototype board.
      sh: x3proto: ILSEL IRQ support.
      sh: x3proto: Hook up ethernet and USB platform devices.
      sh: x3proto: Trivial ILSEL build fix.
      sh: Bump up NODES_SHIFT for SH-X3.
      serial: sh-sci: Shut up compiler warning for SH-X3 SCIF.
      sh: Wire up CSM node for SH-X3.
      serial: sh-sci: Tidy cpufreq printk.
      sh: Kill off duplicate symbol exports on SMP.
      sh: heartbeat driver update.
      sh: More license string silliness.
      sh: Kill off volatile silliness in sq_flush_range().
      sh: Overhaul spinlocks and rwlocks for SH-4A SMP.
      sh: Fix up heartbeat build and resource size.
      sh: Fix up se7751 build.
      sh: nommu fault handler needs signal.h.
      serial: sh-sci: kgdb console build fixes.
      sh: INTC stubs for SH7343 and SH7770 builds.
      sh: dma: Fix CONFIG_SYSFS=n build.
      sh: Don't enable FPU for SH4AL-DSP.
      sh: se7206: Make the I/O port routines less stupid.
      sh: se7206: heartbeat needs 32-bit writes.
      sh: hp6xx: Trivial build fixes for INTC changes.
      sh: r7780rp: irq-r7780rp needs linux/io.h.
      sh: se7206: Handle non-SuperIO I/O ports.
      sh: se7206: update defconfig.
      sh: Wire up URAM node on SH7785.
      sh: Fix up extended mode TLB for SH-X2+ cores.
      sh: rts7751r2d: Fix up trivial build failure.
      sh: Enable maple by default for the Dreamcast.
      sh: Make cpufreq driver less noisy on SMP.
      sh: Kill off special boot_cpu_data.
      sh: Avoid smp_processor_id() in cache desc paths.
      sh: Add SMP tlbflush variants.
      sh: Bring SMP support back from the dead.
      sh: Plug plat_smp_setup() in to generic setup path.
      sh: Initial SH-X3 SMP support.
      sh: Fix alias calculation for non-aliasing cases.
      sh: nommu: Kill off dummy page fault ops for SH-3/4.
      sh: Calculate cache aliases on L2 caches.
      sh: Revert incorrect license string changes.
      sh: Define _ebss for uClinux MTD map driver.
      sh: Disable L2 reporting for present URAM only parts.
      sh: Disable 4kB pages on extended mode TLB.
      sh: processor.h needs smp.h
      sh: Kill off duplicate NODES_SHIFT.
      sh: Fix plat_irq_setup_pins() for SH7785.
      sh: Bump MAX_ACTIVE_REGIONS for SH7785.
      sh: Support extended mode TLB on SH-X3.
      sh: Use boot_cpu_data for CPU probe.
      sh: Fix URAM start address on SH7785.
      sh: Tidy up gUSA preempt handling.
      sh: Follow gUSA preempt changes in __switch_to().
      sh: Conditionalize gUSA support.
      sh: early_printk tidying.
      sh: kgdb section mismatches and tidying.
      sh: Make kgdb i-cache flushing less inept.
      sh: Rip out left-over nommu cond syscall cruft.
      sh: Fix up some section alignments in linker script.
      sh: Discard .exit.text/.exit.data at runtime.

Stuart Menefy (2):
      sh: clkfwk: Support multi-level clock propagation.
      sh: __copy_user() optimizations for small copies.

Thomas Gleixner (1):
      sh: cleanup struct irqaction initializers.

 arch/sh/Kconfig                              |   53 -
 arch/sh/Kconfig.debug                        |    6 
 arch/sh/Makefile                             |    4 
 arch/sh/boards/hp6xx/hp6xx_apm.c             |    9 
 arch/sh/boards/hp6xx/setup.c                 |   35 
 arch/sh/boards/magicpanelr2/Kconfig          |   13 
 arch/sh/boards/magicpanelr2/Makefile         |    5 
 arch/sh/boards/magicpanelr2/setup.c          |  394 +++++++
 arch/sh/boards/mpc1211/setup.c               |    2 
 arch/sh/boards/renesas/r7780rp/Makefile      |    5 
 arch/sh/boards/renesas/r7780rp/irq-r7780mp.c |   61 +
 arch/sh/boards/renesas/r7780rp/irq-r7780rp.c |    6 
 arch/sh/boards/renesas/r7780rp/irq-r7785rp.c |   46 
 arch/sh/boards/renesas/r7780rp/setup.c       |   70 +
 arch/sh/boards/renesas/rts7751r2d/Kconfig    |   19 
 arch/sh/boards/renesas/rts7751r2d/irq.c      |  179 ++-
 arch/sh/boards/renesas/rts7751r2d/setup.c    |   95 +
 arch/sh/boards/renesas/x3proto/Makefile      |    1 
 arch/sh/boards/renesas/x3proto/ilsel.c       |  151 +++
 arch/sh/boards/renesas/x3proto/setup.c       |  136 ++
 arch/sh/boards/se/7206/io.c                  |   31 
 arch/sh/boards/se/7206/setup.c               |   19 
 arch/sh/boards/se/7343/irq.c                 |    7 
 arch/sh/boards/se/7343/setup.c               |    2 
 arch/sh/boards/se/770x/setup.c               |   10 
 arch/sh/boards/se/7722/setup.c               |    9 
 arch/sh/boards/se/7751/setup.c               |   11 
 arch/sh/boards/se/7780/irq.c                 |   28 
 arch/sh/boards/se/7780/setup.c               |    7 
 arch/sh/boards/sh03/setup.c                  |   28 
 arch/sh/boards/shmin/setup.c                 |   26 
 arch/sh/boards/snapgear/setup.c              |   30 
 arch/sh/boards/titan/setup.c                 |   30 
 arch/sh/cchips/Kconfig                       |   13 
 arch/sh/cchips/hd6446x/hd64461.c             |   13 
 arch/sh/cchips/hd6446x/hd64465/setup.c       |    7 
 arch/sh/cchips/voyagergx/irq.c               |  188 +--
 arch/sh/configs/dreamcast_defconfig          |  155 ---
 arch/sh/configs/hp6xx_defconfig              |  559 +++++------
 arch/sh/configs/magicpanelr2_defconfig       |  925 ++++++++++++++++++
 arch/sh/configs/rts7751r2d1_defconfig        | 1167 +++++++++++++++++++++++
 arch/sh/configs/rts7751r2d_defconfig         | 1353 ---------------------------
 arch/sh/configs/rts7751r2dplus_defconfig     | 1167 +++++++++++++++++++++++
 arch/sh/configs/se7206_defconfig             |  223 +---
 arch/sh/configs/shx3_defconfig               |  456 ++++-----
 arch/sh/drivers/dma/Kconfig                  |    1 
 arch/sh/drivers/dma/dma-sh.c                 |   13 
 arch/sh/drivers/heartbeat.c                  |   70 +
 arch/sh/drivers/pci/ops-rts7751r2d.c         |    8 
 arch/sh/drivers/pci/pci-sh7780.c             |   13 
 arch/sh/kernel/cpu/clock.c                   |    2 
 arch/sh/kernel/cpu/init.c                    |   27 
 arch/sh/kernel/cpu/irq/Makefile              |    4 
 arch/sh/kernel/cpu/irq/intc.c                |  562 +++++++----
 arch/sh/kernel/cpu/irq/intc2.c               |   86 -
 arch/sh/kernel/cpu/sh2/probe.c               |   19 
 arch/sh/kernel/cpu/sh2/setup-sh7619.c        |   93 +
 arch/sh/kernel/cpu/sh2a/probe.c              |   18 
 arch/sh/kernel/cpu/sh2a/setup-sh7206.c       |  217 +++-
 arch/sh/kernel/cpu/sh3/Makefile              |   10 
 arch/sh/kernel/cpu/sh3/probe.c               |   48 
 arch/sh/kernel/cpu/sh3/setup-sh7705.c        |  172 ++-
 arch/sh/kernel/cpu/sh3/setup-sh7708.c        |   43 
 arch/sh/kernel/cpu/sh3/setup-sh7709.c        |  145 --
 arch/sh/kernel/cpu/sh3/setup-sh770x.c        |  224 ++++
 arch/sh/kernel/cpu/sh3/setup-sh7710.c        |  200 ++-
 arch/sh/kernel/cpu/sh3/setup-sh7720.c        |  210 ++++
 arch/sh/kernel/cpu/sh4/probe.c               |  178 +--
 arch/sh/kernel/cpu/sh4/setup-sh7750.c        |   54 -
 arch/sh/kernel/cpu/sh4/setup-sh7760.c        |  253 ++---
 arch/sh/kernel/cpu/sh4/sq.c                  |    4 
 arch/sh/kernel/cpu/sh4a/Makefile             |    6 
 arch/sh/kernel/cpu/sh4a/setup-sh7343.c       |    4 
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c       |   38 
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c       |    4 
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c       |   91 +
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c       |  304 +++++-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c         |  234 ++++
 arch/sh/kernel/cpu/sh4a/smp-shx3.c           |  120 ++
 arch/sh/kernel/cpufreq.c                     |    3 
 arch/sh/kernel/early_printk.c                |   49 
 arch/sh/kernel/entry-common.S                |    2 
 arch/sh/kernel/head.S                        |   18 
 arch/sh/kernel/kgdb_stub.c                   |   53 -
 arch/sh/kernel/process.c                     |    8 
 arch/sh/kernel/setup.c                       |   15 
 arch/sh/kernel/sh_ksyms.c                    |   18 
 arch/sh/kernel/signal.c                      |   10 
 arch/sh/kernel/smp.c                         |  307 ++++--
 arch/sh/kernel/syscalls.S                    |   18 
 arch/sh/kernel/timers/timer-tmu.c            |    3 
 arch/sh/kernel/traps.c                       |    5 
 arch/sh/kernel/vmlinux.lds.S                 |   10 
 arch/sh/mm/Kconfig                           |   67 -
 arch/sh/mm/Makefile                          |   23 
 arch/sh/mm/cache-sh4.c                       |   81 -
 arch/sh/mm/copy_page.S                       |  169 ++-
 arch/sh/mm/fault-nommu.c                     |   64 -
 arch/sh/mm/pmb.c                             |    2 
 arch/sh/mm/tlb-sh4.c                         |   55 -
 drivers/rtc/rtc-sh.c                         |   51 -
 drivers/serial/sh-sci.c                      |   39 
 drivers/serial/sh-sci.h                      |   34 
 drivers/sh/Makefile                          |    4 
 drivers/sh/maple/Makefile                    |    3 
 drivers/sh/maple/maple.c                     |  735 ++++++++++++++
 drivers/video/backlight/hp680_bl.c           |    4 
 drivers/video/pvr2fb.c                       |    4 
 include/asm-sh/cacheflush.h                  |   33 
 include/asm-sh/cpu-sh3/cache.h               |    4 
 include/asm-sh/cpu-sh3/dma.h                 |   13 
 include/asm-sh/cpu-sh3/gpio.h                |   66 +
 include/asm-sh/cpu-sh3/mmu_context.h         |    9 
 include/asm-sh/cpu-sh3/timer.h               |    9 
 include/asm-sh/cpu-sh3/ubc.h                 |    3 
 include/asm-sh/cpu-sh4/dma.h                 |    2 
 include/asm-sh/cpu-sh4/mmu_context.h         |   14 
 include/asm-sh/dma.h                         |    5 
 include/asm-sh/dreamcast/maple.h             |   37 
 include/asm-sh/gpio.h                        |   19 
 include/asm-sh/hd64461.h                     |    1 
 include/asm-sh/heartbeat.h                   |   17 
 include/asm-sh/hw_irq.h                      |   53 -
 include/asm-sh/ilsel.h                       |   45 
 include/asm-sh/io.h                          |   26 
 include/asm-sh/kgdb.h                        |   24 
 include/asm-sh/magicpanelr2.h                |   67 +
 include/asm-sh/page.h                        |   10 
 include/asm-sh/pgtable.h                     |  115 +-
 include/asm-sh/processor.h                   |   11 
 include/asm-sh/r7780rp.h                     |   33 
 include/asm-sh/rtc.h                         |    6 
 include/asm-sh/rts7751r2d.h                  |   65 -
 include/asm-sh/sections.h                    |    1 
 include/asm-sh/sh03/io.h                     |    9 
 include/asm-sh/smp.h                         |   34 
 include/asm-sh/snapgear.h                    |   12 
 include/asm-sh/spinlock.h                    |  181 ++-
 include/asm-sh/spinlock_types.h              |   11 
 include/asm-sh/system.h                      |    1 
 include/asm-sh/voyagergx.h                   |   39 
 include/asm-sh64/gpio.h                      |    8 
 include/linux/maple.h                        |   80 +
 143 files changed, 9783 insertions(+), 4363 deletions(-)
