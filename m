Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935409Ab0BZHSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 02:18:36 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:40078 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935359Ab0BZHSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 02:18:33 -0500
Date: Fri, 26 Feb 2010 16:18:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.34-rc1
Message-ID: <20100226071801.GA18939@linux-sh.org>
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

Chris Smith (1):
      sh: kmemleak support.

Giuseppe CAVALLARO (1):
      sh: fixed cmpxchg gRB version

Guennadi Liakhovetski (5):
      sh: support SIU sourcing from external clock on sh7722
      sh: add high impedance mode management for SIUA pins on sh7722
      sh: prepare the DMA driver for slave functionality
      sh: fix Transfer Size calculation in both DMA drivers
      sh: implement DMA_SLAVE capability in SH dmaengine driver

Kuninori Morimoto (4):
      sh: sh7724: Update FSI/SPU2 clock
      sh: mach-ecovec24: Add sh_sir support
      sh: ms7724: Add sh_sir support
      sh: ms7724: modify scan_timing for KEYSC

Magnus Damm (24):
      sh: update PFC to allow any enum in MARK lists
      mtd: trivial sh_flctl changes
      mtd: sh_flctl SHBUSSEL and SEL_16BIT support
      serial: sh-sci: remove SCIF code in sci_rxd_in()
      sh: extend INTC with struct intc_hw_desc
      sh: extend INTC with force_enable
      sh: sh7722/Migo-R SDHI vector merge
      sh: sh7723/AP325 SDHI vector merge
      sh: sh7724/Ecovec24/KFR2R09/MS7724SE SDHI vector merge
      sh: fix INTC to use set_irq_chained_handler() for redirects
      sh: break out enable/reparent div4 clocks on sh7723
      sh: extend INTC with force_disable
      sh: fix sh7724 SDHI support using INTC force_disable
      sh: fix sh7722 SDHI support using INTC force_disable
      sh: fix sh7723 SDHI support using INTC force_disable
      sh: clock-cpg div4 set_rate() shift fix
      sh: introduce struct clk_div4_table
      sh: add sh7724 kick callback to clk_div4_table
      sh: always enable sh7724 vpu_clk and set to 166MHz on Ecovec
      sh: SH-Mobile R-standby register save/restore
      sh: ms7724se r-standby support
      sh: ecovec r-standby support
      sh: ecovec build fix for CONFIG_I2C=n
      sh: remove dead LED code for migo-r and ms7724se

Matt Fleming (18):
      sh: Abstract the number of page table levels
      sh: Definitions for 3-level page table layout
      sh: Remove unused functions
      sh: Correct the PTRS_PER_PMD and PMD_SHIFT values
      sh: Optimise flush_dcache_page() on SH4
      sh: Move page table allocation out of line
      sh: Don't perform an icbi on a P2 address
      sh: PVR detection for 2nd cut SH7786.
      sh: Fix CONFIG_PMB=n build.
      sh: New extended page flag to wire/unwire TLB entries
      sh: Acquire some more page flags for SH-5.
      sh: Generalise the pte handling code for the fixmap path
      sh: Add fixed ioremap support
      sh: Use ioremap_fixmed to map the SM501 DRAM config register
      sh: Use ioremap_fixed() to implement SH-5 ioremap()
      sh: Setup early PMB mappings.
      sh: Optimise FDE/CIE lookup by using red-black trees
      sh: Turn on speculative return for SH7785 and SH7786

Nobuhiro Iwamatsu (1):
      sh: Fix zImage boot using fixed PMB.

Paul Mundt (131):
      sh: hw-breakpoints: Add preliminary support for SH-4A UBC.
      sh: Fix up hw-breakpoints build for API changes.
      sh: hw-breakpoint support requires perf events.
      sh: Don't NOTIFY_STOP for non-UBC breakpoint traps.
      sh: kgdb: Rework breakpoint handling on top of notifier chain.
      sh: Convert ptrace to hw_breakpoint API.
      sh: Drop down to a single quicklist.
      sh: Fix up breakpoint trap handler patching on SH-2A.
      sh: Abstracted SH-4A UBC support on hw-breakpoint core.
      sh: Kill off dead UBC headers.
      sh: Reclaim TIF_DEBUG.
      sh: Fix up nommu build for out-of-line pgtable changes.
      sh: select HAVE_HW_BREAKPOINT for all SUPERH32 CPUs.
      sh: consolidate atomic_cmpxchg()/atomic_add_unless() definitions.
      sh: mach-se: Convert SE7343 FPGA to dynamic IRQ allocation.
      sh: default to sparseirq.
      sh: Tidy up the sh bios VBR handling.
      sh64: Fix up early serial fixmap.
      sh: Kill off more unused sh_bios callbacks.
      sh: Consolidate the sh_bios earlyprintk code.
      sh: Split out the unaligned counters and user bits.
      sh: sh_bios detection.
      sh: Move start_thread() out of line.
      sh: Always provide thread_info allocators.
      sh: Use SLAB_PANIC for thread_info slab cache.
      sh: Move over to dynamically allocated FPU context.
      sh: Add support for LZO-compressed kernels.
      sh: Add a vmlinux.bin target.
      sh: fixed PMB mode refactoring.
      sh: Fix up L2 cache comment typo.
      sh: Make all PxSEGADDR() calls fatal for non-legacy configs.
      sh: default to extended TLB support.
      sh: Rename split-level pgtable headers.
      sh: Preliminary SDK7786 board support.
      sh: heartbeat: Support access size specification via resource flags.
      sh: mach-sdk7786: heartbeat support.
      sh: heartbeat: Update boards for access size hinting.
      sh: Guard against early IPIs in flush_cache_all().
      sh: Fix up the secondary CPU entry point for 32bit mode.
      sh: mach-sdk7786: mode pins support.
      sh: Generalize SH7786 PCIe support.
      sh: Tidy up non-translatable checks in iounmap path.
      sh: Need IRQs enabled for init_fpu().
      sh: Handle early ioremaps through fixed mappings.
      sh: Fixup the IOREMAP_FIXED=n build.
      sh: Merge _32/_64 ioremap implementations.
      sh: Make iounmap_fixed() return success/failure for iounmap() path.
      sh: Handle unmapping of fixed slots transparently in iounmap().
      sh: Flag __ioremap_caller() __init_refok.
      sh: Prevent 64-bit pgprot clobbering across ioremap implementations.
      sh: Kill off duplicate address alignment in ioremap_fixed().
      sh: Convert p3_ioremap() users to ioremap_prot().
      sh: Limit ioremap_prot() to 32bit pgprot parts.
      sh: Provide a dummy _PAGE_WIRED flag for non-X2TLB parts.
      sh: Split out MMUCR.URB based entry wiring in to shared helper.
      sh: Kill off now bogus fixmap/page wiring documentation.
      sh64: Fix up the build for the thread_xstate changes.
      sh64: Fix up PC casting in unaligned fixup notifier with 32bit ABI.
      sh64: Use the shared FPU state restorer.
      sh64: Fixup build breakage from breakpoint handler rename.
      sh: SH7786 clock framework rewrite.
      sh: mach-sdk7786: Detect/configure/propagate EXTAL.
      sh: urquell: Handle EXTAL configuration here, too.
      sh: Fix up sdk7780 and urquell builds.
      sh: Shut up noisy IOREMAP_FIXED=n build.
      sh: Handle SH-4 FPU variants with broken CVR values.
      sh: mach-sdk7786: FPGA updates.
      sh: mach-sdk7786: Split out FPGA IRQ controller setup.
      sh: Make 29/32-bit mode check helper generally available.
      sh: machine_ops based reboot support.
      sh: mach-sdk7786: reset controller reboot support.
      sh: Correct iounmap fixmap teardown.
      sh: mach-sdk7786: Probe system FPGA area mapping.
      sh: pretty print virtual memory map on boot.
      sh: initial PMB mapping iteration by helper macro.
      sh: Rework P2 to only include kernel text.
      sh: Track the uncached mapping size.
      sh: Kill off the special uncached section and fixmap.
      sh: Conserve fixmap slots when IOREMAP_FIXED=n.
      sh: Mass ctrl_in/outX to __raw_read/writeX conversion.
      sh: flag ctrl_in/outX as __deprecated.
      sh: Optimize runtime disabling of trapped I/O.
      sh: mach-titan: Kill off unused PIO port mangling.
      sh: Quiet noisy coherent DMA unmapping on R2D.
      sh: Fix up read-only variable assignment in pcibios_align_resource().
      sh: Fix up the ioremap_fixed() build for nommu.
      sh: Kill off superfluous sh_bios references from compressed loader.
      sh: Kill off deprecated fixed PCI memory window accessors.
      sh: Reworked SH7780 PCI initialization.
      sh: Bail out early on PCI resource conflicts.
      sh: support PCI domains.
      sh: Kill off broken type 1 PCI config access checks.
      sh: mach-se: Fix up irq_desc reference.
      sh: Fix up asm/hw_breakpoint.h header check.
      sh: Fix up large system memory handling for SH7780 PCI.
      sh: Enable PCI66 support for SH7780 host controller.
      sh: Handle PCI controller resource conflicts.
      sh: Hook up ERR/PERR/SERR detection for SH7780 PCI host controllers.
      sh: Improved multi-resource handling for SH7780 PCI.
      sh: Provide create_irq_nr() for dynamic IRQ creation by number.
      sh: mach-se: Convert SH7724 solution engine FPGA to sparseirq.
      sh: hd6446x: Convert to sparseirq.
      sh: mach-dreamcast: Convert to sparseirq.
      sh: enable sparseirq for highlander and r2d.
      sh: Disable generic IRQ probing.
      sh: Fix up early PCI PERR/SERR IRQ handling.
      sh: Fix an off-by-1 in SH7780 PCIC memory resource mapping.
      sh: Fix up hp6xx build.
      sh: Fix up SH7786 PCI resource definitions.
      sh: Fix up multi-resource mapping for SH7786 PCIe.
      sh: update sdk7786 defconfig.
      sh: Isolate uncached mapping support.
      sh64: fix up memory offset calculation.
      sh: Fix up legacy PMB mode offset calculation.
      sh: Prevent fixed slot PMB remapping from clobbering boot entries.
      sh: Merge the legacy PMB mapping and entry synchronization code.
      sh: Kill off some superfluous legacy PMB special casing.
      sh: Setup boot CPU VBR early to enable early page faults.
      sh: Use dummy_irq_chip for INTC redirect vectors.
      sh: Fix up more 64-bit pgprot truncation on SH-X2 TLB.
      sh: PMB tidying.
      sh: uncached mapping helpers.
      sh: Build PMB entry links for existing contiguous multi-page mappings.
      sh: Fix up dynamically created write-through PMB mappings.
      sh: PMB locking overhaul.
      sh: Provide uncached I/O helpers.
      sh: Use uncached I/O helpers in PMB setup.
      sh: Merge legacy and dynamic PMB modes.
      sh: allow alignment fault mode to be configured at kernel boot.
      sh: wire up SET/GET_UNALIGN_CTL.
      clocksource: Fix up a registration/IRQ race in the sh drivers.

Phil Edworthy (2):
      video: sh_mobile_lcdcfb: Add wait for vsync.
      video: sh_mobile_lcdcfb: Fix panning.

 arch/sh/Kconfig                                 |   32 +-
 arch/sh/Kconfig.cpu                             |    3 +-
 arch/sh/Makefile                                |   10 +-
 arch/sh/boards/Kconfig                          |    8 +
 arch/sh/boards/Makefile                         |    1 +
 arch/sh/boards/board-magicpanelr2.c             |   74 +-
 arch/sh/boards/board-polaris.c                  |   37 +-
 arch/sh/boards/board-sh7785lcr.c                |   32 +-
 arch/sh/boards/board-shmin.c                    |    4 +-
 arch/sh/boards/board-titan.c                    |   24 +
 arch/sh/boards/board-urquell.c                  |   46 +-
 arch/sh/boards/mach-ap325rxa/setup.c            |   20 +-
 arch/sh/boards/mach-cayman/irq.c                |   16 +-
 arch/sh/boards/mach-dreamcast/irq.c             |   27 +
 arch/sh/boards/mach-dreamcast/rtc.c             |   20 +-
 arch/sh/boards/mach-dreamcast/setup.c           |   18 +-
 arch/sh/boards/mach-ecovec24/sdram.S            |   59 +
 arch/sh/boards/mach-ecovec24/setup.c            |   87 +-
 arch/sh/boards/mach-highlander/irq-r7780mp.c    |    2 +-
 arch/sh/boards/mach-highlander/irq-r7780rp.c    |    2 +-
 arch/sh/boards/mach-highlander/irq-r7785rp.c    |   16 +-
 arch/sh/boards/mach-highlander/psw.c            |    4 +-
 arch/sh/boards/mach-highlander/setup.c          |   14 +-
 arch/sh/boards/mach-hp6xx/hp6xx_apm.c           |    2 +-
 arch/sh/boards/mach-hp6xx/pm.c                  |   38 +-
 arch/sh/boards/mach-hp6xx/setup.c               |   12 +-
 arch/sh/boards/mach-kfr2r09/setup.c             |   16 +-
 arch/sh/boards/mach-landisk/gio.c               |   12 +-
 arch/sh/boards/mach-landisk/irq.c               |    6 +-
 arch/sh/boards/mach-landisk/psw.c               |    4 +-
 arch/sh/boards/mach-landisk/setup.c             |    6 +-
 arch/sh/boards/mach-lboxre2/setup.c             |    4 +-
 arch/sh/boards/mach-microdev/io.c               |    4 +-
 arch/sh/boards/mach-microdev/irq.c              |   10 +-
 arch/sh/boards/mach-migor/setup.c               |   22 +-
 arch/sh/boards/mach-r2d/irq.c                   |    4 +-
 arch/sh/boards/mach-r2d/setup.c                 |    8 +-
 arch/sh/boards/mach-rsk/devices-rsk7203.c       |    2 +-
 arch/sh/boards/mach-sdk7780/irq.c               |    4 +-
 arch/sh/boards/mach-sdk7780/setup.c             |   29 +-
 arch/sh/boards/mach-sdk7786/Makefile            |    1 +
 arch/sh/boards/mach-sdk7786/fpga.c              |   72 +
 arch/sh/boards/mach-sdk7786/irq.c               |   48 +
 arch/sh/boards/mach-sdk7786/setup.c             |  189 +++
 arch/sh/boards/mach-se/7206/io.c                |    2 +-
 arch/sh/boards/mach-se/7206/irq.c               |   43 +-
 arch/sh/boards/mach-se/7206/setup.c             |   15 +-
 arch/sh/boards/mach-se/7343/irq.c               |   45 +-
 arch/sh/boards/mach-se/7343/setup.c             |   43 +-
 arch/sh/boards/mach-se/770x/irq.c               |   14 +-
 arch/sh/boards/mach-se/770x/setup.c             |   15 +-
 arch/sh/boards/mach-se/7721/irq.c               |    2 +-
 arch/sh/boards/mach-se/7721/setup.c             |   23 +-
 arch/sh/boards/mach-se/7722/irq.c               |   10 +-
 arch/sh/boards/mach-se/7722/setup.c             |   55 +-
 arch/sh/boards/mach-se/7724/irq.c               |   62 +-
 arch/sh/boards/mach-se/7724/sdram.S             |   79 +
 arch/sh/boards/mach-se/7724/setup.c             |  114 +-
 arch/sh/boards/mach-se/7780/irq.c               |   18 +-
 arch/sh/boards/mach-se/7780/setup.c             |   47 +-
 arch/sh/boards/mach-sh03/rtc.c                  |   50 +-
 arch/sh/boards/mach-sh03/setup.c                |    2 +-
 arch/sh/boards/mach-sh7763rdp/irq.c             |   10 +-
 arch/sh/boards/mach-sh7763rdp/setup.c           |   40 +-
 arch/sh/boards/mach-snapgear/setup.c            |    2 +-
 arch/sh/boards/mach-systemh/irq.c               |   12 +-
 arch/sh/boards/mach-titan/Makefile              |    5 -
 arch/sh/boards/mach-titan/io.c                  |  108 --
 arch/sh/boards/mach-titan/setup.c               |   44 -
 arch/sh/boards/mach-x3proto/ilsel.c             |    8 +-
 arch/sh/boards/mach-x3proto/setup.c             |    2 +-
 arch/sh/boot/Makefile                           |   30 +-
 arch/sh/boot/compressed/Makefile                |    7 +-
 arch/sh/boot/compressed/misc.c                  |   23 +-
 arch/sh/cchips/hd6446x/hd64461.c                |   36 +-
 arch/sh/configs/sdk7786_defconfig               | 1754 +++++++++++++++++++++++
 arch/sh/drivers/dma/dma-pvr2.c                  |   10 +-
 arch/sh/drivers/dma/dma-sh.c                    |   31 +-
 arch/sh/drivers/dma/dmabrg.c                    |   22 +-
 arch/sh/drivers/heartbeat.c                     |   22 +-
 arch/sh/drivers/pci/Makefile                    |    5 +-
 arch/sh/drivers/pci/common.c                    |  162 +++
 arch/sh/drivers/pci/fixups-dreamcast.c          |    2 +-
 arch/sh/drivers/pci/fixups-r7780rp.c            |   12 -
 arch/sh/drivers/pci/fixups-rts7751r2d.c         |    4 +-
 arch/sh/drivers/pci/fixups-sdk7780.c            |   19 -
 arch/sh/drivers/pci/fixups-se7751.c             |    6 +-
 arch/sh/drivers/pci/ops-sh4.c                   |   30 +-
 arch/sh/drivers/pci/pci-dreamcast.c             |   32 +-
 arch/sh/drivers/pci/pci-sh4.h                   |   18 +-
 arch/sh/drivers/pci/pci-sh5.c                   |   19 +-
 arch/sh/drivers/pci/pci-sh5.h                   |   12 +-
 arch/sh/drivers/pci/pci-sh7751.c                |   52 +-
 arch/sh/drivers/pci/pci-sh7780.c                |  408 +++++-
 arch/sh/drivers/pci/pci-sh7780.h                |   64 +-
 arch/sh/drivers/pci/pci.c                       |  167 ++-
 arch/sh/drivers/pci/pcie-sh7786.c               |  205 ++-
 arch/sh/drivers/pci/pcie-sh7786.h               |   74 +-
 arch/sh/drivers/superhyway/ops-sh4-202.c        |    8 +-
 arch/sh/include/asm/Kbuild                      |    4 +-
 arch/sh/include/asm/addrspace.h                 |   18 +-
 arch/sh/include/asm/alignment.h                 |   21 +
 arch/sh/include/asm/atomic-grb.h                |   46 -
 arch/sh/include/asm/atomic-llsc.h               |   27 -
 arch/sh/include/asm/atomic.h                    |   73 +-
 arch/sh/include/asm/clock.h                     |   11 +-
 arch/sh/include/asm/cmpxchg-grb.h               |    7 +-
 arch/sh/include/asm/dma-mapping.h               |    2 -
 arch/sh/include/asm/dma-sh.h                    |   55 +-
 arch/sh/include/asm/dwarf.h                     |   19 +-
 arch/sh/include/asm/fixmap.h                    |   15 +-
 arch/sh/include/asm/fpu.h                       |   35 +-
 arch/sh/include/asm/hw_breakpoint.h             |   67 +
 arch/sh/include/asm/io.h                        |  169 ++-
 arch/sh/include/asm/kdebug.h                    |    2 +
 arch/sh/include/asm/mmu.h                       |   49 +-
 arch/sh/include/asm/mmu_context.h               |    6 +-
 arch/sh/include/asm/mmu_context_32.h            |    4 +-
 arch/sh/include/asm/module.h                    |   17 +-
 arch/sh/include/asm/page.h                      |   19 +-
 arch/sh/include/asm/pci.h                       |   59 +-
 arch/sh/include/asm/pgalloc.h                   |   32 +-
 arch/sh/include/asm/pgtable-2level.h            |   23 +
 arch/sh/include/asm/pgtable-3level.h            |   56 +
 arch/sh/include/asm/pgtable.h                   |   26 +-
 arch/sh/include/asm/pgtable_32.h                |    4 +
 arch/sh/include/asm/pgtable_64.h                |   26 +-
 arch/sh/include/asm/processor.h                 |   21 +
 arch/sh/include/asm/processor_32.h              |   35 +-
 arch/sh/include/asm/processor_64.h              |   23 +-
 arch/sh/include/asm/ptrace.h                    |   20 +-
 arch/sh/include/asm/reboot.h                    |   21 +
 arch/sh/include/asm/setup.h                     |    1 -
 arch/sh/include/asm/sh_bios.h                   |   15 +-
 arch/sh/include/asm/suspend.h                   |    1 +
 arch/sh/include/asm/system.h                    |    9 +-
 arch/sh/include/asm/system_32.h                 |   15 +-
 arch/sh/include/asm/system_64.h                 |   10 +-
 arch/sh/include/asm/thread_info.h               |   10 +-
 arch/sh/include/asm/tlb.h                       |   17 +
 arch/sh/include/asm/ubc.h                       |   64 -
 arch/sh/include/asm/uncached.h                  |   18 +
 arch/sh/include/asm/vmlinux.lds.h               |    8 +
 arch/sh/include/asm/watchdog.h                  |   18 +-
 arch/sh/include/cpu-sh2/cpu/ubc.h               |   32 -
 arch/sh/include/cpu-sh2/cpu/watchdog.h          |    4 +-
 arch/sh/include/cpu-sh3/cpu/dac.h               |   12 +-
 arch/sh/include/cpu-sh3/cpu/dma.h               |   20 +-
 arch/sh/include/cpu-sh3/cpu/ubc.h               |   42 -
 arch/sh/include/cpu-sh4/cpu/addrspace.h         |    9 +
 arch/sh/include/cpu-sh4/cpu/dma-sh4a.h          |  108 +-
 arch/sh/include/cpu-sh4/cpu/dma.h               |   35 +-
 arch/sh/include/cpu-sh4/cpu/mmu_context.h       |    4 +
 arch/sh/include/cpu-sh4/cpu/sq.h                |    3 +-
 arch/sh/include/cpu-sh4/cpu/ubc.h               |   64 -
 arch/sh/include/mach-common/mach/magicpanelr2.h |   12 +-
 arch/sh/include/mach-dreamcast/mach/sysasic.h   |    5 +
 arch/sh/include/mach-sdk7786/mach/fpga.h        |  114 ++
 arch/sh/include/mach-sdk7786/mach/irq.h         |    7 +
 arch/sh/include/mach-se/mach/se7343.h           |   52 +-
 arch/sh/kernel/Makefile                         |    8 +-
 arch/sh/kernel/cpu/Makefile                     |    2 +
 arch/sh/kernel/cpu/adc.c                        |   12 +-
 arch/sh/kernel/cpu/clock-cpg.c                  |  104 ++-
 arch/sh/kernel/cpu/fpu.c                        |   84 ++
 arch/sh/kernel/cpu/init.c                       |  125 +-
 arch/sh/kernel/cpu/irq/intc-sh5.c               |   14 +-
 arch/sh/kernel/cpu/sh2/clock-sh7619.c           |    6 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7201.c          |    8 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7203.c          |    6 +-
 arch/sh/kernel/cpu/sh2a/clock-sh7206.c          |    8 +-
 arch/sh/kernel/cpu/sh2a/fpu.c                   |  111 +--
 arch/sh/kernel/cpu/sh3/clock-sh3.c              |    8 +-
 arch/sh/kernel/cpu/sh3/clock-sh7705.c           |    8 +-
 arch/sh/kernel/cpu/sh3/clock-sh7706.c           |    8 +-
 arch/sh/kernel/cpu/sh3/clock-sh7709.c           |    8 +-
 arch/sh/kernel/cpu/sh3/clock-sh7710.c           |    8 +-
 arch/sh/kernel/cpu/sh3/clock-sh7712.c           |    6 +-
 arch/sh/kernel/cpu/sh3/ex.S                     |    2 +-
 arch/sh/kernel/cpu/sh3/probe.c                  |   28 +-
 arch/sh/kernel/cpu/sh3/setup-sh3.c              |    2 +-
 arch/sh/kernel/cpu/sh4/clock-sh4-202.c          |   10 +-
 arch/sh/kernel/cpu/sh4/clock-sh4.c              |    8 +-
 arch/sh/kernel/cpu/sh4/fpu.c                    |  159 +--
 arch/sh/kernel/cpu/sh4/probe.c                  |   14 +-
 arch/sh/kernel/cpu/sh4/setup-sh4-202.c          |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7750.c           |    2 +-
 arch/sh/kernel/cpu/sh4/setup-sh7760.c           |    2 +-
 arch/sh/kernel/cpu/sh4/sq.c                     |   23 +-
 arch/sh/kernel/cpu/sh4a/Makefile                |    9 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c          |    6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7366.c          |    6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7722.c          |   29 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7723.c          |   30 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7724.c          |   19 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7757.c          |    8 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7763.c          |    8 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c          |    8 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c          |   10 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7785.c          |    6 +-
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c          |  184 ++--
 arch/sh/kernel/cpu/sh4a/clock-shx3.c            |   10 +-
 arch/sh/kernel/cpu/sh4a/pinmux-sh7722.c         |   21 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c          |   20 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7723.c          |   39 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c          |   39 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7757.c          |   26 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7763.c          |   20 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7770.c          |   24 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c          |   24 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c          |   26 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c          |   24 +-
 arch/sh/kernel/cpu/sh4a/smp-shx3.c              |    5 +-
 arch/sh/kernel/cpu/sh4a/ubc.c                   |  133 ++
 arch/sh/kernel/cpu/sh5/clock-sh5.c              |    8 +-
 arch/sh/kernel/cpu/sh5/entry.S                  |    6 +-
 arch/sh/kernel/cpu/sh5/fpu.c                    |   65 +-
 arch/sh/kernel/cpu/shmobile/pm.c                |    3 +-
 arch/sh/kernel/cpu/shmobile/sleep.S             |  121 ++-
 arch/sh/kernel/debugtraps.S                     |    1 -
 arch/sh/kernel/dwarf.c                          |  174 ++-
 arch/sh/kernel/early_printk.c                   |   85 --
 arch/sh/kernel/head_32.S                        |  221 +++-
 arch/sh/kernel/head_64.S                        |    2 -
 arch/sh/kernel/hw_breakpoint.c                  |  463 ++++++
 arch/sh/kernel/idle.c                           |   14 +-
 arch/sh/kernel/io_trapped.c                     |   18 +-
 arch/sh/kernel/kgdb.c                           |   46 +-
 arch/sh/kernel/machine_kexec.c                  |   16 +-
 arch/sh/kernel/process.c                        |  100 ++
 arch/sh/kernel/process_32.c                     |  164 +--
 arch/sh/kernel/process_64.c                     |   27 +-
 arch/sh/kernel/ptrace_32.c                      |   82 +-
 arch/sh/kernel/ptrace_64.c                      |   16 +-
 arch/sh/kernel/reboot.c                         |   98 ++
 arch/sh/kernel/setup.c                          |   12 +-
 arch/sh/kernel/sh_bios.c                        |  129 ++-
 arch/sh/kernel/signal_32.c                      |   10 +-
 arch/sh/kernel/signal_64.c                      |    4 +-
 arch/sh/kernel/smp.c                            |    9 -
 arch/sh/kernel/traps.c                          |    4 +-
 arch/sh/kernel/traps_32.c                       |  181 +---
 arch/sh/kernel/traps_64.c                       |   28 +-
 arch/sh/kernel/vmlinux.lds.S                    |   42 +-
 arch/sh/math-emu/math.c                         |   12 +-
 arch/sh/mm/Kconfig                              |   48 +-
 arch/sh/mm/Makefile                             |   12 +-
 arch/sh/mm/alignment.c                          |  189 +++
 arch/sh/mm/cache-debugfs.c                      |    7 +-
 arch/sh/mm/cache-sh2.c                          |   12 +-
 arch/sh/mm/cache-sh2a.c                         |   20 +-
 arch/sh/mm/cache-sh3.c                          |    6 +-
 arch/sh/mm/cache-sh4.c                          |   27 +-
 arch/sh/mm/cache-sh7705.c                       |   12 +-
 arch/sh/mm/cache.c                              |   13 +-
 arch/sh/mm/fault_32.c                           |    3 +
 arch/sh/mm/init.c                               |  166 ++-
 arch/sh/mm/{ioremap_32.c => ioremap.c}          |   63 +-
 arch/sh/mm/ioremap_64.c                         |  326 -----
 arch/sh/mm/ioremap_fixed.c                      |  128 ++
 arch/sh/mm/nommu.c                              |    4 +
 arch/sh/mm/pgtable.c                            |   56 +
 arch/sh/mm/pmb.c                                |  586 ++++++--
 arch/sh/mm/tlb-pteaex.c                         |    3 +-
 arch/sh/mm/tlb-sh3.c                            |    6 +-
 arch/sh/mm/tlb-sh4.c                            |   13 +-
 arch/sh/mm/tlb-sh5.c                            |   39 +
 arch/sh/mm/tlb-urb.c                            |   81 ++
 arch/sh/mm/tlbflush_32.c                        |    4 +-
 arch/sh/mm/tlbflush_64.c                        |    2 +-
 arch/sh/mm/uncached.c                           |   34 +
 arch/sh/tools/mach-types                        |    1 +
 drivers/clocksource/sh_cmt.c                    |   32 +-
 drivers/clocksource/sh_mtu2.c                   |    6 +-
 drivers/clocksource/sh_tmu.c                    |    6 +-
 drivers/dma/shdma.c                             |  411 ++++--
 drivers/dma/shdma.h                             |    7 +-
 drivers/mtd/nand/Kconfig                        |    4 +-
 drivers/mtd/nand/sh_flctl.c                     |   69 +-
 drivers/serial/sh-sci.h                         |  220 +---
 drivers/sh/intc.c                               |  266 +++-
 drivers/sh/pfc.c                                |   37 +-
 drivers/video/pvr2fb.c                          |    2 +-
 drivers/video/sh_mobile_lcdcfb.c                |   88 +-
 include/linux/mtd/sh_flctl.h                    |    3 +
 include/linux/sh_intc.h                         |   33 +-
 include/video/sh_mobile_lcdc.h                  |    2 +
 lib/Kconfig.debug                               |    2 +-
 mm/Kconfig                                      |    2 +-
 289 files changed, 9155 insertions(+), 4451 deletions(-)
 create mode 100644 arch/sh/boards/board-titan.c
 create mode 100644 arch/sh/boards/mach-sdk7786/Makefile
 create mode 100644 arch/sh/boards/mach-sdk7786/fpga.c
 create mode 100644 arch/sh/boards/mach-sdk7786/irq.c
 create mode 100644 arch/sh/boards/mach-sdk7786/setup.c
 delete mode 100644 arch/sh/boards/mach-titan/Makefile
 delete mode 100644 arch/sh/boards/mach-titan/io.c
 delete mode 100644 arch/sh/boards/mach-titan/setup.c
 create mode 100644 arch/sh/configs/sdk7786_defconfig
 create mode 100644 arch/sh/drivers/pci/common.c
 create mode 100644 arch/sh/include/asm/alignment.h
 create mode 100644 arch/sh/include/asm/hw_breakpoint.h
 create mode 100644 arch/sh/include/asm/pgtable-2level.h
 create mode 100644 arch/sh/include/asm/pgtable-3level.h
 create mode 100644 arch/sh/include/asm/reboot.h
 delete mode 100644 arch/sh/include/asm/ubc.h
 create mode 100644 arch/sh/include/asm/uncached.h
 delete mode 100644 arch/sh/include/cpu-sh2/cpu/ubc.h
 delete mode 100644 arch/sh/include/cpu-sh3/cpu/ubc.h
 delete mode 100644 arch/sh/include/cpu-sh4/cpu/ubc.h
 create mode 100644 arch/sh/include/mach-sdk7786/mach/fpga.h
 create mode 100644 arch/sh/include/mach-sdk7786/mach/irq.h
 create mode 100644 arch/sh/kernel/cpu/fpu.c
 create mode 100644 arch/sh/kernel/cpu/sh4a/ubc.c
 delete mode 100644 arch/sh/kernel/early_printk.c
 create mode 100644 arch/sh/kernel/hw_breakpoint.c
 create mode 100644 arch/sh/kernel/process.c
 create mode 100644 arch/sh/kernel/reboot.c
 create mode 100644 arch/sh/mm/alignment.c
 rename arch/sh/mm/{ioremap_32.c => ioremap.c} (78%)
 delete mode 100644 arch/sh/mm/ioremap_64.c
 create mode 100644 arch/sh/mm/ioremap_fixed.c
 create mode 100644 arch/sh/mm/pgtable.c
 create mode 100644 arch/sh/mm/tlb-urb.c
 create mode 100644 arch/sh/mm/uncached.c
