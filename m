Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbZLHEAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbZLHEAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 23:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934433AbZLHEAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 23:00:20 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51388 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933601AbZLHEAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 23:00:18 -0500
Date: Tue, 8 Dec 2009 12:59:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.33-rc1
Message-ID: <20091208035907.GA4105@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Alexey Dobriyan (1):
      sh: convert /proc/cpu/aligmnent, /proc/cpu/kernel_alignment to seq_file

Giuseppe CAVALLARO (1):
      sh: add sleazy FPU optimization

Guennadi Liakhovetski (2):
      SH: add support for the RJ54N1CB0C camera for the kfr2r09 platform
      serial: sh-sci: Fix too early port disabling.

Kuninori Morimoto (6):
      sh: mach-ecevec24: Add SDHI support
      sh: mach-ecovec24: Add USB1 gadget support
      sh: sh7724: Add SPU2 support
      sh: mach-ecovec24: modify address map
      sh: mach-ecovec24: LCDC drive ability become high
      sh: mach-ecovec24: Remove un-defined settings for VPU

Magnus Damm (38):
      mfd: Add SuperH Mobile SDHI platform driver
      mmc: Add SuperH to the tmio-mmc Kconfig
      sh: SDHI platform data to the Migo-R board
      sh: SDHI platform data to the AP325RXA board
      sh: SDHI platform data to the SE7724 board
      sh: SDHI platform data to the kfr2r09 board
      sh: fix kexec by removing check for old kexec-tools
      sh: add hwblk_id to sh_eth on ecovec24
      sh: mac address through private data for sh_eth on ecovec24
      sh: mac address through private data for sh_eth on ms7724se
      sh: add SDHI1 support to ms7724se
      sh: Add notifiers chains for cpu/board code
      sh: Add sh7724 notifier for R-standby save/restore
      sh: Allow boards to register memory pre/post sleep code
      sh: Add kfr2r09 specific memory pre/post sleep code
      sh: Add ms7724se specific memory pre/post sleep code
      sh: Add migor specific memory pre/post sleep code
      sh: Move ap325rxa board code into separate directory
      sh: Add ap325rxa specific memory pre/post sleep code
      sh: Add Ecovec24 specific memory pre/post sleep code
      sh: Rework SuperH Mobile sleep mode code
      sh: Keep track of allowed sleep modes
      sh: Add MMU and Cache handling sleep mode code
      sh: Use RSMEM for sleep code on sh7724
      sh: Add R-standby sleep mode support
      sh: Add KFR2R09 specific memory pre/post R-standby code
      sh: Add SDHI1 support to the AP325RXA board
      sh: Remove unused WP signal for SDHI0 and KFR2R09
      sh: Add RWDT save/restore code for sh7724 R-standby
      mfd: Add power control platform data to SDHI driver
      sh: Add SDHI power control support to Ecovec
      sh: Add CPG save/restore code for sh7724 R-standby
      sh: Move KEYSC header file
      sh: Break out SuperH PFC code
      sh: Improve kfr2r09 serial port setup code
      sh: fix sh7724 VEU3F resource size
      sh: allow runtime pm without suspend/resume callbacks
      sh: include empty zero page in romImage

Matt Fleming (16):
      sh: Allocate PMB entry slot earlier
      sh: Obliterate the P1 area macros
      sh: Prepare for dynamic PMB support
      sh: CONFIG_PMB doesn't mean the MMU is in 32bit mode
      sh: Make most PMB functions static
      sh: Get rid of the kmem cache code
      sh: Remap physical memory into P1 and P2 in pmb_init()
      sh: Fix the offset from P1SEG/P2SEG where we map RAM
      sh: Fold fixed-PMB support into dynamic PMB support
      sh: Teach the DWARF unwinder about modules
      sh: Fix memory leak in dwarf_unwind_stack()
      sh: Remove any reference to recursive functions from comments
      sh: tracing: Use the DWARF unwinder for CALLER_ADDRx
      sh: Annotate irq functions with "notrace"
      sh: Do not apply virt_to_phys() to a physical address
      sh: Drop associative writes for SH-4 cache flushes.

Paul Mundt (66):
      sh: sh4_flush_cache_mm() optimizations.
      sh: Kill off broken PHYSADDR() usage in sh4_flush_dcache_page().
      sh: Kill off segment-based d-cache flushing on SH-4.
      sh: Rework sh4_flush_cache_page() for coherent kmap mapping.
      sh: Fix up redundant cache flushing for PAGE_SIZE > 4k.
      sh: Factor in cpu id for selection of cache colour fixmap.
      sh: Shut up CONFIG_32BIT=n compiler warnings.
      sh: Reinstate ILSEL -> IRL intc mappings for SH-X3 proto CPU.
      cdrom: gdrom: Kill off PHYSADDR use.
      sh: maple: PHYSADDR() -> virt_to_phys() conversion.
      sh: Generalize CALLER_ADDRx support.
      sh: Tidy up the dwarf module helpers.
      sh: Don't profile return_address().
      sh: ftrace: Make code modification NMI safe.
      sh: Provide CALLER_ADDRx definitions even when ftrace is disabled.
      sh: Only invalidate the I-cache range for secondary CPUs stack_start.
      sh: TS_RESTORE_SIGMASK conversion.
      sh: Count NMIs in irq_cpustat_t.
      sh: Force boot CPU in to light sleep mode for SH-X3 SMP.
      sh: Idle loop chainsawing for SMP-based light sleep.
      sh: Make check_pgt_cache() more aggressive while idling.
      sh: Fix up IRQ re-enabling for the need_resched() case.
      sh: Support SCHED_MC for SH-X3 multi-cores.
      sh: Kill off legacy UBC wakeup cruft.
      sh: Convert to asm-generic/irqflags.h.
      sh: Disable SCIF2 on the SH-X3 proto CPU.
      sh: Fix up smp_mb__xxx() memory barriers for SH-4A SMP.
      sh: Fix up uninitialized variable warning in dwarf unwinder.
      sh: Fix up cacheflush routine symbol exports.
      sh: Convert to asm-generic/dma-mapping-common.h
      sh: Add dma-mapping support for dma_alloc/free_coherent() overrides.
      sh: Revamp PCI DMA coherence Kconfig bits.
      sh: Kill off superfluous arch/sh/drivers/pci/Kconfig.
      sh: Fix up dma_is_consistent().
      sh64: cache flush symbol exports.
      sh: intc: Make ack_regs generally available.
      sh: Clean up more superfluous symbol exports.
      sh: Bump up dma_ops initialization far earlier in the boot process.
      sh: enable PERF_USE_VMALLOC across the board.
      sh: perf events: Add preliminary support for SH-4A counters.
      sh: perf events: Kill off left over debugging cruft.
      sh: intc: dynamic IRQ support.
      sh: intc: Handle legacy IRQ reservation in vector map.
      sh: mach-se: Convert SE7722 FPGA to dynamic IRQ allocation.
      video: sh_mobile_lcdcfb: Don't attempt to map zero-length scatterlists.
      sh: perf events: Fix up uninitialized variable warning.
      sh: Default-enable SPU clock for SH7724.
      sh: perf events: Preliminary callchain support.
      sh: perf events: Add support for SH7750-style counters.
      sh: oprofile: Kill off bitrotted SH7750 driver.
      sh: oprofile: Fix up count size mismatch for common impl.
      sh: perf events: Document SH-4A raw event codes.
      sh: Enable PMB support for all SH-4A CPUs.
      sh: Fix up the CONFIG_PERF_EVENTS=n build for SH-4.
      sh: Use the generic I/O port base for slowdown.
      sh64: Fix up the CONFIG_GENERIC_BUG=n build.
      sh64: Fix up reworked cache op build.
      sh: dma: Kill off bogus dma_sysclass symbol export.
      sh: Apply the sleazy FPU changes for SH-2A FPU as well.
      sh: Fix up the FPU emulation build.
      serial: sh-sci: Depend on HAVE_CLK unconditionally.
      sh: pfc: Convert from ctrl_xxx() to __raw_xxx() I/O routines.
      sh: pfc: pr_info() -> pr_debug() cleanups.
      sh: Add default uImage rule for se7724, ap325rxa, and migor.
      sh: Partial revert of copy/clear_user_highpage() optimizations.
      sh: Make associative cache writes fatal on all SH-4A parts.

Roel Kluin (1):
      sh: Make sure indexes are positive

Stuart Menefy (3):
      sh: Optimised memset for SH4
      sh: Improve performance of SH4 versions of copy/clear_user_highpage
      sh: Minor optimisations to FPU handling

Uwe Kleine-König (2):
      rtc: don't use __exit_p to wrap ds1302_rtc_remove
      serial: sh-sci: don't use __devexit_p to wrap sci_remove

Valentin R Sitsikov (1):
      sh: fix watchdog timer for sh7780/sh7785

 arch/sh/Kconfig                                    |   29 +-
 arch/sh/Makefile                                   |    4 +
 arch/sh/boards/Makefile                            |    1 -
 arch/sh/boards/mach-ap325rxa/Makefile              |    2 +
 arch/sh/boards/mach-ap325rxa/sdram.S               |   69 +++
 .../{board-ap325rxa.c => mach-ap325rxa/setup.c}    |   97 +++-
 arch/sh/boards/mach-ecovec24/Makefile              |    2 +-
 arch/sh/boards/mach-ecovec24/sdram.S               |   52 ++
 arch/sh/boards/mach-ecovec24/setup.c               |  197 ++++++---
 arch/sh/boards/mach-highlander/setup.c             |    2 +-
 arch/sh/boards/mach-kfr2r09/Makefile               |    2 +-
 arch/sh/boards/mach-kfr2r09/sdram.S                |   80 ++++
 arch/sh/boards/mach-kfr2r09/setup.c                |  238 +++++++++-
 arch/sh/boards/mach-migor/Makefile                 |    2 +-
 arch/sh/boards/mach-migor/sdram.S                  |   69 +++
 arch/sh/boards/mach-migor/setup.c                  |   65 ++-
 arch/sh/boards/mach-r2d/irq.c                      |    2 +-
 arch/sh/boards/mach-se/7722/irq.c                  |   32 +-
 arch/sh/boards/mach-se/7722/setup.c                |   17 +-
 arch/sh/boards/mach-se/7724/Makefile               |    2 +-
 arch/sh/boards/mach-se/7724/sdram.S                |   52 ++
 arch/sh/boards/mach-se/7724/setup.c                |   96 ++++-
 arch/sh/boot/compressed/misc.c                     |    2 +-
 arch/sh/boot/romimage/Makefile                     |   12 +-
 arch/sh/boot/romimage/head.S                       |   38 ++
 arch/sh/drivers/dma/dma-sysfs.c                    |    2 -
 arch/sh/drivers/pci/Kconfig                        |   19 -
 arch/sh/include/asm/addrspace.h                    |    9 +-
 arch/sh/include/asm/atomic.h                       |    9 +-
 arch/sh/include/asm/bitops.h                       |    4 +-
 arch/sh/include/asm/bugs.h                         |    4 +
 arch/sh/include/asm/dma-mapping.h                  |  233 +++-------
 arch/sh/include/asm/dwarf.h                        |   28 ++
 arch/sh/include/asm/fixmap.h                       |   12 +-
 arch/sh/include/asm/fpu.h                          |   26 +-
 arch/sh/include/asm/ftrace.h                       |   17 +
 arch/sh/include/asm/gpio.h                         |   82 +----
 arch/sh/include/asm/hardirq.h                      |   13 +-
 arch/sh/include/asm/io.h                           |   16 +-
 arch/sh/include/asm/irqflags.h                     |   31 +--
 arch/sh/include/asm/irqflags_32.h                  |   99 ----
 arch/sh/include/asm/irqflags_64.h                  |   85 ----
 arch/sh/include/asm/mmu.h                          |   13 +-
 arch/sh/include/asm/pci.h                          |   30 +-
 arch/sh/include/asm/perf_event.h                   |   31 ++-
 arch/sh/include/asm/pgtable.h                      |   26 +-
 arch/sh/include/asm/pgtable_32.h                   |    2 +-
 arch/sh/include/asm/processor_32.h                 |    3 +-
 arch/sh/include/asm/scatterlist.h                  |    2 +-
 arch/sh/include/asm/suspend.h                      |   65 +++
 arch/sh/include/asm/system.h                       |    4 -
 arch/sh/include/asm/system_32.h                    |   29 ++
 arch/sh/include/asm/system_64.h                    |   26 +
 arch/sh/include/asm/thread_info.h                  |   30 +-
 arch/sh/include/asm/topology.h                     |    8 +
 arch/sh/include/asm/ubc.h                          |   11 -
 arch/sh/include/asm/watchdog.h                     |   59 +++-
 arch/sh/include/cpu-sh4/cpu/watchdog.h             |   13 +
 .../mach-ecovec24/mach/partner-jet-setup.txt       |    3 +-
 arch/sh/include/mach-se/mach/se7722.h              |   11 +-
 arch/sh/kernel/Makefile                            |   10 +-
 arch/sh/kernel/asm-offsets.c                       |   23 +
 arch/sh/kernel/cpu/Makefile                        |    1 -
 arch/sh/kernel/cpu/init.c                          |   28 +-
 arch/sh/kernel/cpu/sh2a/fpu.c                      |   27 +-
 arch/sh/kernel/cpu/sh3/entry.S                     |   33 --
 arch/sh/kernel/cpu/sh4/Makefile                    |    8 +-
 arch/sh/kernel/cpu/sh4/fpu.c                       |   28 +-
 arch/sh/kernel/cpu/sh4/perf_event.c                |  253 ++++++++++
 arch/sh/kernel/cpu/sh4a/Makefile                   |    1 +
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c             |    2 +-
 arch/sh/kernel/cpu/sh4a/perf_event.c               |  269 +++++++++++
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c             |  264 ++++++++++-
 arch/sh/kernel/cpu/sh4a/setup-shx3.c               |   45 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c                 |   37 +-
 arch/sh/kernel/cpu/sh5/entry.S                     |    2 +-
 arch/sh/kernel/cpu/shmobile/cpuidle.c              |   42 +-
 arch/sh/kernel/cpu/shmobile/pm.c                   |  117 ++++-
 arch/sh/kernel/cpu/shmobile/pm_runtime.c           |   17 +-
 arch/sh/kernel/cpu/shmobile/sleep.S                |  344 ++++++++------
 arch/sh/kernel/cpu/ubc.S                           |   59 ---
 arch/sh/kernel/dma-nommu.c                         |   82 ++++
 arch/sh/kernel/dwarf.c                             |  222 +++++++--
 arch/sh/kernel/entry-common.S                      |    2 +-
 arch/sh/kernel/ftrace.c                            |  146 ++++++-
 arch/sh/kernel/head_32.S                           |    2 +-
 arch/sh/kernel/idle.c                              |   78 +++-
 arch/sh/kernel/io_generic.c                        |    4 +-
 arch/sh/kernel/irq.c                               |   14 +
 arch/sh/kernel/irq_32.c                            |   57 +++
 arch/sh/kernel/irq_64.c                            |   51 ++
 arch/sh/kernel/machine_kexec.c                     |    6 -
 arch/sh/kernel/machvec.c                           |    4 +
 arch/sh/kernel/module.c                            |    9 +-
 arch/sh/kernel/perf_callchain.c                    |   98 ++++
 arch/sh/kernel/perf_event.c                        |  312 ++++++++++++
 arch/sh/kernel/process_32.c                        |   42 ++-
 arch/sh/kernel/process_64.c                        |    2 +
 arch/sh/kernel/return_address.c                    |   54 +++
 arch/sh/kernel/setup.c                             |    4 +
 arch/sh/kernel/sh_ksyms_32.c                       |   67 +---
 arch/sh/kernel/sh_ksyms_64.c                       |   10 -
 arch/sh/kernel/signal_32.c                         |   24 +-
 arch/sh/kernel/signal_64.c                         |   13 +-
 arch/sh/kernel/smp.c                               |    4 +-
 arch/sh/kernel/topology.c                          |   26 +
 arch/sh/kernel/traps.c                             |    8 +-
 arch/sh/kernel/traps_32.c                          |   82 ++--
 arch/sh/lib/Makefile                               |    7 +-
 arch/sh/lib/memset-sh4.S                           |  107 +++++
 arch/sh/math-emu/math.c                            |    6 +-
 arch/sh/mm/Kconfig                                 |   19 +-
 arch/sh/mm/Makefile                                |    3 +-
 arch/sh/mm/cache-sh4.c                             |  501 +++-----------------
 arch/sh/mm/cache-sh5.c                             |    2 +-
 arch/sh/mm/cache-sh7705.c                          |    2 +-
 arch/sh/mm/cache.c                                 |   18 +-
 arch/sh/mm/consistent.c                            |   28 +-
 arch/sh/mm/init.c                                  |   19 +
 arch/sh/mm/kmap.c                                  |    4 +-
 arch/sh/mm/numa.c                                  |    2 +-
 arch/sh/mm/pmb-fixed.c                             |   45 --
 arch/sh/mm/pmb.c                                   |  268 ++++++------
 arch/sh/oprofile/Makefile                          |    4 -
 arch/sh/oprofile/common.c                          |   38 +--
 arch/sh/oprofile/op_impl.h                         |    2 +-
 arch/sh/oprofile/op_model_sh7750.c                 |  255 ----------
 drivers/cdrom/gdrom.c                              |   10 +-
 drivers/input/keyboard/sh_keysc.c                  |    2 +-
 drivers/mfd/Kconfig                                |    8 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/sh_mobile_sdhi.c                       |  156 ++++++
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/rtc/rtc-ds1302.c                           |    2 +-
 drivers/serial/Kconfig                             |    2 +-
 drivers/serial/sh-sci.c                            |   59 +---
 drivers/serial/sh-sci.h                            |    2 +-
 drivers/sh/Makefile                                |    1 +
 drivers/sh/intc.c                                  |  123 +++++-
 drivers/sh/maple/maple.c                           |    4 +-
 arch/sh/kernel/gpio.c => drivers/sh/pfc.c          |   43 +-
 drivers/video/sh_mobile_lcdcfb.c                   |   32 +-
 .../include/asm => include/linux/input}/sh_keysc.h |    6 +-
 include/linux/mfd/sh_mobile_sdhi.h                 |    8 +
 include/linux/sh_intc.h                            |    7 +-
 include/linux/sh_pfc.h                             |   96 ++++
 146 files changed, 4741 insertions(+), 2405 deletions(-)
 create mode 100644 arch/sh/boards/mach-ap325rxa/Makefile
 create mode 100644 arch/sh/boards/mach-ap325rxa/sdram.S
 rename arch/sh/boards/{board-ap325rxa.c => mach-ap325rxa/setup.c} (87%)
 create mode 100644 arch/sh/boards/mach-ecovec24/sdram.S
 create mode 100644 arch/sh/boards/mach-kfr2r09/sdram.S
 create mode 100644 arch/sh/boards/mach-migor/sdram.S
 create mode 100644 arch/sh/boards/mach-se/7724/sdram.S
 delete mode 100644 arch/sh/drivers/pci/Kconfig
 delete mode 100644 arch/sh/include/asm/irqflags_32.h
 delete mode 100644 arch/sh/include/asm/irqflags_64.h
 create mode 100644 arch/sh/kernel/cpu/sh4/perf_event.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/perf_event.c
 delete mode 100644 arch/sh/kernel/cpu/ubc.S
 create mode 100644 arch/sh/kernel/dma-nommu.c
 create mode 100644 arch/sh/kernel/irq_32.c
 create mode 100644 arch/sh/kernel/irq_64.c
 create mode 100644 arch/sh/kernel/perf_callchain.c
 create mode 100644 arch/sh/kernel/perf_event.c
 create mode 100644 arch/sh/kernel/return_address.c
 create mode 100644 arch/sh/lib/memset-sh4.S
 delete mode 100644 arch/sh/mm/pmb-fixed.c
 delete mode 100644 arch/sh/oprofile/op_model_sh7750.c
 create mode 100644 drivers/mfd/sh_mobile_sdhi.c
 rename arch/sh/kernel/gpio.c => drivers/sh/pfc.c (94%)
 rename {arch/sh/include/asm => include/linux/input}/sh_keysc.h (75%)
 create mode 100644 include/linux/mfd/sh_mobile_sdhi.h
 create mode 100644 include/linux/sh_pfc.h
