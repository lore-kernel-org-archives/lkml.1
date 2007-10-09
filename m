Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbXJINZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbXJINZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbXJINZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:25:35 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:35951 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbXJINZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:25:32 -0400
Date: Tue, 9 Oct 2007 14:25:28 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: What's in linux-mips.git for Linux 2.6.24?
Message-ID: <20071009132528.GA28924@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The biggest actual changes are the support for tickless kernels on MIPS
and the rewrite for many of the timer devices previously used as
clocksources and clockevents.  Various cleanups, including some moving
of code and support for 32-bit Broadcom BCM47XX processors, the return
of support for LASAT which isn't quite as unused as previously thought ...
The number of patch lines and files is inflated by two large whitespace
cleanup patches.

  Ralf 

Ahmed S. Darwish (1):
      [MIPS] Replace deprecated SA_* IRQ flags with modern IRQF_ variants.

Atsushi Nemoto (2):
      [MIPS] tx4927: Cleanup unused macros and non-standard IO accessors.
      [MIPS] Kill redundant EXTRA_AFLAGS

Aurelien Jarno (6):
      [MIPS] Add support for BCM47XX CPUs.
      [MIPS] Move CFE code into arch/mips/fw/cfe
      [MIPS] Move ARC code into arch/mips/fw/arc
      [MIPS] Add CFE support to BCM47XX
      [MIPS] Add gpio support to the BCM47XX platform
      [MIPS] GPIO LED driver for the WGT634U machine

Brian Murphy (1):
      [MIPS] Add back support for LASAT platforms

Florian Fainelli (1):
      [MIPS] MTX1: Add defconfig file

Franck Bui-Huu (5):
      [MIPS] Remove '-mno-explicit-relocs' option when CONFIG_BUILD_ELF64
      [MIPS] Automatically set CONFIG_BUILD_ELF64
      [MIPS] Rename CONFIG_BUILD_ELF64 into KBUILD_64BIT_SYM32
      [MIPS] Don't abort the build process if '-msym32' isn't supported
      [MIPS] Add BUG_ON assertion for attempt to run kernel on the wrong CPU type.

Kevin D. Kissell (1):
      [MIPS] IRQ Affinity Support for SMTC on Malta Platform

Maciej W. Rozycki (3):
      [MIPS] R3000 setup for kernel_thread()
      [MIPS] dec/time.c: Remove no longer needed inclusion of <asm/div64.h>.
      [MIPS] pg-r4k.c: Dump the generated code

Paolo 'Blaisorblade' Giarrusso (1):
      [MIPS] Alchemy: Fix USB initialization.

Ralf Baechle (35):
      [MIPS] SMTC: Microoptimize atomic_postincrement for non-weak consistency.
      [MIPS] PCI: Always enable CONFIG_PCI_DOMAINS
      [MIPS] floppy: Rewrite fd_cacheflush() to use dma_cache_sync().
      [MIPS] Kill useless volatile keyword
      [MIPS] Sibyte: cleanup static inline forward declarations.
      [MIPS] Alchemy: remove useless prototypes.
      [MIPS] Sibyte: Replace SB1 cachecode with standard R4000 class cache code.
      [MIPS] Remove IP27 specific structures from struct cpuinfo_mips
      [MIPS] Split up war.h
      [MIPS] ARC: Convert mach_table[] to ISO C initializers.
      [MIPS] ARC: Get rid of mips_machgroup
      [MIPS] Use generic NTP code for all MIPS platforms
      [MIPS] Deforest the function pointer jungle in the time code.
      [MIPS] Switch from to_tm to rtc_time_to_tm
      [MIPS] Consolidate all variants of MIPS cp0 timer interrupt handlers.
      [MIPS] Implement clockevents for R4000-style cp0 count/compare interrupt
      [MIPS] Dyntick support for SMTC:
      [MIPS] Jazz clockevent driver
      [MIPS] IP27: Add clocksource drivers
      [MIPS] i8253 PIT clocksource and clockevent drivers
      [MIPS] Clockevent driver for BCM1250
      [MIPS] Clockevent driver for BCM1480
      [MIPS] Avoid indexed cacheops.
      [MIPS] Optimize __alloc_zeroed_user_highpage implementation.
      [MIPS] tlbex: Size optimize code by declaring a few functions inline.
      [MIPS] Allow hardwiring of the CPU type to a single type for optimization.
      [MIPS] Fix "no space between function name and open parenthesis" warnings.
      [MIPS] checkfiles: Fix "need space after that ','" errors.
      [MIPS] Optimize get_unaligned / put_unaligned implementations.
      [MIPS] Convert list of CPU types from #define to enum.
      [MIPS] Make facility to convert CPU types to strings generally available.
      [MIPS] SMP: Implement smp_call_function_mask().
      [MIPS] Kill num_online_cpus() loops.
      [MIPS] SMP: Kill useless casts.
      [MIPS] SMP: Use ISO C struct initializer for local structs.

Sam Ravnborg (1):
      [MIPS] Introduce a consistent style for vmlinux.lds.

Thiemo Seufer (1):
      [MIPS] Define known MIPS ISA overrides for Sibyte and Excite boards.

Thomas Bogendoerfer (1):
      [MIPS] JAZZ fixes

Thomas Gleixner (2):
      [MIPS] cleanup struct irqaction initializers
      clockevents: fix bogus next_event reset for oneshot broadcast devices

Yoichi Yuasa (16):
      [MIPS] vr41xx: add cpu_wait
      [MIPS] VR41xx: Add default restart routine.
      [MIPS] VR41xx: replace infinite loop with hibernate
      [MIPS] IP27: remove duplicate extern dump_tlb_all() prototype
      [MIPS] remove unused include/asm-mips/ip32/machine.h
      [MIPS] fix ABI check in include/asm-mips/arv/hinv.h
      [MIPS] i8295 cleanups.
      [MIPS] GT64120: Remove unused definitions
      [MIPS] Add GT641xx IRQ routines.
      [MIPS] Cobalt: Add Cobalt Raq LED platform register and power off trigger
      [MIPS] Cobalt: Add Qube series front LED support to platform register
      [MIPS] Cobalt: Add LED support to cobalt_defconfig
      [MIPS] Cobalt: Move PCI definitions to arch/mips/pci/fixup-cobalt.c.
      [MIPS] Cobalt: Move UART base definition to arch/mips/cobalt/console.c
      [MIPS] Cobalt: Move reset port definition to arch/mips/cobalt/reset.c
      [MIPS] Cobalt: Remove cobalt_machine_power_off()

 arch/mips/Kconfig                                  |   98 
 arch/mips/Makefile                                 |   48 
 arch/mips/au1000/common/dbdma.c                    |    6 
 arch/mips/au1000/common/dbg_io.c                   |    2 
 arch/mips/au1000/common/irq.c                      |   15 
 arch/mips/au1000/common/power.c                    |    2 
 arch/mips/au1000/common/reset.c                    |    2 
 arch/mips/au1000/common/setup.c                    |    2 
 arch/mips/au1000/common/time.c                     |   46 
 arch/mips/au1000/db1x00/board_setup.c              |    2 
 arch/mips/au1000/db1x00/init.c                     |    8 
 arch/mips/au1000/mtx-1/board_setup.c               |    2 
 arch/mips/au1000/mtx-1/init.c                      |    1 
 arch/mips/au1000/pb1000/board_setup.c              |    8 
 arch/mips/au1000/pb1000/init.c                     |    1 
 arch/mips/au1000/pb1100/board_setup.c              |    6 
 arch/mips/au1000/pb1100/init.c                     |    1 
 arch/mips/au1000/pb1200/board_setup.c              |    8 
 arch/mips/au1000/pb1200/init.c                     |    1 
 arch/mips/au1000/pb1200/irqmap.c                   |    2 
 arch/mips/au1000/pb1500/board_setup.c              |    8 
 arch/mips/au1000/pb1500/init.c                     |    1 
 arch/mips/au1000/pb1550/board_setup.c              |    2 
 arch/mips/au1000/pb1550/init.c                     |    1 
 arch/mips/au1000/xxs1500/board_setup.c             |    2 
 arch/mips/au1000/xxs1500/init.c                    |    1 
 arch/mips/basler/excite/excite_prom.c              |    1 
 arch/mips/basler/excite/excite_setup.c             |   17 
 arch/mips/bcm47xx/Makefile                         |    6 
 arch/mips/bcm47xx/gpio.c                           |   79 
 arch/mips/bcm47xx/irq.c                            |   55 
 arch/mips/bcm47xx/prom.c                           |  158 +
 arch/mips/bcm47xx/serial.c                         |   52 
 arch/mips/bcm47xx/setup.c                          |  123 +
 arch/mips/bcm47xx/time.c                           |   55 
 arch/mips/bcm47xx/wgt634u.c                        |   64 
 arch/mips/boot/addinitrd.c                         |   60 
 arch/mips/boot/elf2ecoff.c                         |    2 
 arch/mips/cobalt/Makefile                          |    2 
 arch/mips/cobalt/console.c                         |    9 
 arch/mips/cobalt/irq.c                             |  116 -
 arch/mips/cobalt/led.c                             |   62 
 arch/mips/cobalt/reset.c                           |   39 
 arch/mips/cobalt/rtc.c                             |    5 
 arch/mips/cobalt/serial.c                          |    7 
 arch/mips/cobalt/setup.c                           |   20 
 arch/mips/configs/bigsur_defconfig                 |    1 
 arch/mips/configs/cobalt_defconfig                 |   23 
 arch/mips/configs/lasat_defconfig                  |  828 ++++
 arch/mips/configs/mtx1_defconfig                   | 3115 +++++++++++++++
 arch/mips/configs/sb1250-swarm_defconfig           |    1 
 arch/mips/dec/ecc-berr.c                           |    2 
 arch/mips/dec/kn02xa-berr.c                        |    2 
 arch/mips/dec/prom/identify.c                      |    3 
 arch/mips/dec/prom/init.c                          |    8 
 arch/mips/dec/setup.c                              |    4 
 arch/mips/dec/time.c                               |   13 
 arch/mips/emma2rh/common/prom.c                    |    2 
 arch/mips/emma2rh/markeins/setup.c                 |    4 
 arch/mips/fw/arc/Makefile                          |    0 
 arch/mips/fw/arc/arc_con.c                         |    0 
 arch/mips/fw/arc/cmdline.c                         |    0 
 arch/mips/fw/arc/env.c                             |    2 
 arch/mips/fw/arc/file.c                            |    2 
 arch/mips/fw/arc/identify.c                        |   82 
 arch/mips/fw/arc/init.c                            |    0 
 arch/mips/fw/arc/memory.c                          |    6 
 arch/mips/fw/arc/misc.c                            |    2 
 arch/mips/fw/arc/promlib.c                         |    0 
 arch/mips/fw/arc/salone.c                          |    0 
 arch/mips/fw/arc/time.c                            |    2 
 arch/mips/fw/arc/tree.c                            |    2 
 arch/mips/fw/cfe/Makefile                          |    5 
 arch/mips/fw/cfe/cfe_api.c                         |    2 
 arch/mips/fw/cfe/cfe_api_int.h                     |    0 
 arch/mips/gt64120/wrppmc/setup.c                   |    5 
 arch/mips/gt64120/wrppmc/time.c                    |    2 
 arch/mips/jazz/Makefile                            |    2 
 arch/mips/jazz/irq.c                               |  142 -
 arch/mips/jazz/jazz-platform.c                     |   60 
 arch/mips/jazz/jazzdma.c                           |   47 
 arch/mips/jazz/reset.c                             |    4 
 arch/mips/jazz/setup.c                             |  134 +
 arch/mips/jmr3927/rbhma3100/init.c                 |    1 
 arch/mips/jmr3927/rbhma3100/irq.c                  |    8 
 arch/mips/jmr3927/rbhma3100/setup.c                |    4 
 arch/mips/kernel/Makefile                          |    2 
 arch/mips/kernel/binfmt_elfo32.c                   |    2 
 arch/mips/kernel/cpu-bugs64.c                      |    2 
 arch/mips/kernel/cpu-probe.c                       |  129 +
 arch/mips/kernel/gdb-stub.c                        |   26 
 arch/mips/kernel/i8253.c                           |  213 +
 arch/mips/kernel/i8259.c                           |   37 
 arch/mips/kernel/irixelf.c                         |   40 
 arch/mips/kernel/irixinv.c                         |   42 
 arch/mips/kernel/irixioctl.c                       |    2 
 arch/mips/kernel/irixsig.c                         |    8 
 arch/mips/kernel/irq-gt641xx.c                     |  131 +
 arch/mips/kernel/irq-msc01.c                       |    4 
 arch/mips/kernel/irq.c                             |    4 
 arch/mips/kernel/kspd.c                            |   12 
 arch/mips/kernel/linux32.c                         |   24 
 arch/mips/kernel/mips-mt.c                         |    2 
 arch/mips/kernel/proc.c                            |   73 
 arch/mips/kernel/process.c                         |   11 
 arch/mips/kernel/ptrace.c                          |   50 
 arch/mips/kernel/ptrace32.c                        |   16 
 arch/mips/kernel/setup.c                           |    2 
 arch/mips/kernel/signal.c                          |    4 
 arch/mips/kernel/signal32.c                        |   44 
 arch/mips/kernel/signal_n32.c                      |    4 
 arch/mips/kernel/smp-mt.c                          |    2 
 arch/mips/kernel/smp.c                             |  104 
 arch/mips/kernel/smtc.c                            |  146 -
 arch/mips/kernel/syscall.c                         |   60 
 arch/mips/kernel/sysirix.c                         |   22 
 arch/mips/kernel/time.c                            |  416 +-
 arch/mips/kernel/traps.c                           |   45 
 arch/mips/kernel/unaligned.c                       |    2 
 arch/mips/kernel/vmlinux.lds.S                     |  339 +-
 arch/mips/kernel/vpe.c                             |    2 
 arch/mips/lasat/Kconfig                            |   15 
 arch/mips/lasat/Makefile                           |   16 
 arch/mips/lasat/at93c.c                            |  149 +
 arch/mips/lasat/at93c.h                            |   18 
 arch/mips/lasat/ds1603.c                           |  183 +
 arch/mips/lasat/ds1603.h                           |   31 
 arch/mips/lasat/image/Makefile                     |   54 
 arch/mips/lasat/image/head.S                       |   31 
 arch/mips/lasat/image/romscript.normal             |   23 
 arch/mips/lasat/interrupt.c                        |  130 +
 arch/mips/lasat/lasat_board.c                      |  280 +
 arch/mips/lasat/lasat_models.h                     |   67 
 arch/mips/lasat/picvue.c                           |  244 +
 arch/mips/lasat/picvue.h                           |   48 
 arch/mips/lasat/picvue_proc.c                      |  191 +
 arch/mips/lasat/prom.c                             |  126 +
 arch/mips/lasat/prom.h                             |    7 
 arch/mips/lasat/reset.c                            |   61 
 arch/mips/lasat/serial.c                           |   94 
 arch/mips/lasat/setup.c                            |  154 +
 arch/mips/lasat/sysctl.c                           |  456 ++
 arch/mips/lasat/sysctl.h                           |   24 
 arch/mips/lemote/lm2e/Makefile                     |    1 
 arch/mips/lemote/lm2e/prom.c                       |    1 
 arch/mips/lemote/lm2e/setup.c                      |    7 
 arch/mips/lib/ucmpdi2.c                            |    2 
 arch/mips/math-emu/cp1emu.c                        |   32 
 arch/mips/math-emu/dp_mul.c                        |    2 
 arch/mips/math-emu/ieee754.c                       |   12 
 arch/mips/math-emu/ieee754dp.h                     |   12 
 arch/mips/math-emu/ieee754int.h                    |   30 
 arch/mips/math-emu/ieee754sp.h                     |   12 
 arch/mips/mips-boards/atlas/atlas_gdb.c            |    2 
 arch/mips/mips-boards/atlas/atlas_int.c            |   22 
 arch/mips/mips-boards/atlas/atlas_setup.c          |    7 
 arch/mips/mips-boards/generic/init.c               |   12 
 arch/mips/mips-boards/generic/memory.c             |    4 
 arch/mips/mips-boards/generic/pci.c                |    2 
 arch/mips/mips-boards/generic/time.c               |  147 -
 arch/mips/mips-boards/malta/malta_int.c            |   36 
 arch/mips/mips-boards/malta/malta_setup.c          |   16 
 arch/mips/mips-boards/malta/malta_smtc.c           |   50 
 arch/mips/mips-boards/sead/sead_int.c              |    2 
 arch/mips/mips-boards/sead/sead_setup.c            |    5 
 arch/mips/mipssim/sim_int.c                        |    2 
 arch/mips/mipssim/sim_mem.c                        |    4 
 arch/mips/mipssim/sim_setup.c                      |    2 
 arch/mips/mipssim/sim_time.c                       |   76 
 arch/mips/mm/Makefile                              |    2 
 arch/mips/mm/c-r3k.c                               |   12 
 arch/mips/mm/c-r4k.c                               |  116 -
 arch/mips/mm/c-sb1.c                               |  535 ---
 arch/mips/mm/c-tx39.c                              |    6 
 arch/mips/mm/cache.c                               |    9 
 arch/mips/mm/cerr-sb1.c                            |   24 
 arch/mips/mm/dma-default.c                         |    4 
 arch/mips/mm/pg-r4k.c                              |   22 
 arch/mips/mm/pg-sb1.c                              |   12 
 arch/mips/mm/pgtable.c                             |    8 
 arch/mips/mm/sc-mips.c                             |    2 
 arch/mips/mm/tlb-r4k.c                             |    2 
 arch/mips/mm/tlb-r8k.c                             |    2 
 arch/mips/mm/tlbex.c                               |  114 -
 arch/mips/oprofile/common.c                        |    2 
 arch/mips/oprofile/op_model_mipsxx.c               |    6 
 arch/mips/oprofile/op_model_rm9000.c               |    2 
 arch/mips/pci/Makefile                             |    2 
 arch/mips/pci/fixup-atlas.c                        |    6 
 arch/mips/pci/fixup-cobalt.c                       |   40 
 arch/mips/pci/ops-au1000.c                         |    2 
 arch/mips/pci/ops-nile4.c                          |  147 +
 arch/mips/pci/ops-pmcmsp.c                         |    2 
 arch/mips/pci/ops-sni.c                            |   22 
 arch/mips/pci/pci-bcm1480.c                        |    6 
 arch/mips/pci/pci-bcm1480ht.c                      |    4 
 arch/mips/pci/pci-lasat.c                          |   91 
 arch/mips/pci/pci-sb1250.c                         |    4 
 arch/mips/pci/pci-vr41xx.c                         |    2 
 arch/mips/philips/pnx8550/common/proc.c            |   36 
 arch/mips/philips/pnx8550/common/setup.c           |    3 
 arch/mips/philips/pnx8550/common/time.c            |    7 
 arch/mips/philips/pnx8550/jbs/init.c               |    1 
 arch/mips/philips/pnx8550/stb810/prom_init.c       |    1 
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c        |    2 
 arch/mips/pmc-sierra/msp71xx/msp_serial.c          |    8 
 arch/mips/pmc-sierra/msp71xx/msp_setup.c           |   18 
 arch/mips/pmc-sierra/msp71xx/msp_time.c            |    3 
 arch/mips/pmc-sierra/msp71xx/msp_usb.c             |    8 
 arch/mips/pmc-sierra/yosemite/ht.c                 |    2 
 arch/mips/pmc-sierra/yosemite/prom.c               |    1 
 arch/mips/pmc-sierra/yosemite/setup.c              |   26 
 arch/mips/qemu/q-firmware.c                        |    2 
 arch/mips/qemu/q-irq.c                             |    4 
 arch/mips/qemu/q-setup.c                           |   10 
 arch/mips/sgi-ip22/ip22-eisa.c                     |    2 
 arch/mips/sgi-ip22/ip22-int.c                      |    7 
 arch/mips/sgi-ip22/ip22-setup.c                    |    2 
 arch/mips/sgi-ip22/ip22-time.c                     |   35 
 arch/mips/sgi-ip27/ip27-berr.c                     |    2 
 arch/mips/sgi-ip27/ip27-init.c                     |    6 
 arch/mips/sgi-ip27/ip27-smp.c                      |    4 
 arch/mips/sgi-ip27/ip27-timer.c                    |   38 
 arch/mips/sgi-ip32/crime.c                         |    6 
 arch/mips/sgi-ip32/ip32-irq.c                      |   44 
 arch/mips/sgi-ip32/ip32-memory.c                   |    4 
 arch/mips/sgi-ip32/ip32-setup.c                    |   12 
 arch/mips/sibyte/Kconfig                           |   13 
 arch/mips/sibyte/bcm1480/irq.c                     |   21 
 arch/mips/sibyte/bcm1480/setup.c                   |   78 
 arch/mips/sibyte/bcm1480/time.c                    |  118 -
 arch/mips/sibyte/cfe/Makefile                      |    2 
 arch/mips/sibyte/cfe/console.c                     |    6 
 arch/mips/sibyte/cfe/setup.c                       |    7 
 arch/mips/sibyte/cfe/smp.c                         |    4 
 arch/mips/sibyte/common/Makefile                   |    1 
 arch/mips/sibyte/common/sb_tbprof.c                |    4 
 arch/mips/sibyte/sb1250/irq.c                      |   58 
 arch/mips/sibyte/sb1250/prom.c                     |    3 
 arch/mips/sibyte/sb1250/setup.c                    |   74 
 arch/mips/sibyte/sb1250/time.c                     |  198 +
 arch/mips/sibyte/swarm/dbg_io.c                    |    4 
 arch/mips/sibyte/swarm/rtc_m41t81.c                |    3 
 arch/mips/sibyte/swarm/rtc_xicor1241.c             |    3 
 arch/mips/sibyte/swarm/setup.c                     |   56 
 arch/mips/sni/a20r.c                               |    6 
 arch/mips/sni/pcimt.c                              |    5 
 arch/mips/sni/pcit.c                               |   27 
 arch/mips/sni/reset.c                              |    2 
 arch/mips/sni/rm200.c                              |   11 
 arch/mips/sni/setup.c                              |    8 
 arch/mips/sni/sniprom.c                            |    8 
 arch/mips/sni/time.c                               |   27 
 arch/mips/tx4927/common/tx4927_dbgio.c             |    1 
 arch/mips/tx4927/common/tx4927_prom.c              |   12 
 arch/mips/tx4927/common/tx4927_setup.c             |   20 
 .../tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c |   33 
 .../toshiba_rbtx4927/toshiba_rbtx4927_prom.c       |    2 
 .../toshiba_rbtx4927/toshiba_rbtx4927_setup.c      |   36 
 arch/mips/tx4938/common/setup.c                    |    9 
 arch/mips/tx4938/toshiba_rbtx4938/prom.c           |    1 
 arch/mips/tx4938/toshiba_rbtx4938/setup.c          |    7 
 arch/mips/vr41xx/common/bcu.c                      |    8 
 arch/mips/vr41xx/common/cmu.c                      |   16 
 arch/mips/vr41xx/common/giu.c                      |    2 
 arch/mips/vr41xx/common/icu.c                      |   76 
 arch/mips/vr41xx/common/init.c                     |    8 
 arch/mips/vr41xx/common/pmu.c                      |   40 
 arch/mips/vr41xx/common/rtc.c                      |    2 
 arch/mips/vr41xx/common/siu.c                      |    2 
 arch/mips/vr41xx/nec-cmbvr4133/init.c              |    6 
 arch/mips/vr41xx/nec-cmbvr4133/m1535plus.c         |    6 
 arch/mips/vr41xx/nec-cmbvr4133/setup.c             |    1 
 drivers/net/jazzsonic.c                            |    6 
 drivers/video/logo/logo.c                          |   10 
 include/asm-mips/addrspace.h                       |    6 
 include/asm-mips/asm.h                             |   66 
 include/asm-mips/asmmacro.h                        |   12 
 include/asm-mips/atomic.h                          |   28 
 include/asm-mips/bitops.h                          |   12 
 include/asm-mips/bootinfo.h                        |   41 
 include/asm-mips/byteorder.h                       |    4 
 include/asm-mips/cmpxchg.h                         |    4 
 include/asm-mips/cpu-features.h                    |    8 
 include/asm-mips/cpu-info.h                        |   21 
 include/asm-mips/cpu.h                             |  160 -
 include/asm-mips/delay.h                           |    2 
 include/asm-mips/elf.h                             |    2 
 include/asm-mips/fixmap.h                          |    4 
 include/asm-mips/floppy.h                          |    6 
 include/asm-mips/futex.h                           |    2 
 include/asm-mips/fw/arc/hinv.h                     |    5 
 include/asm-mips/fw/arc/types.h                    |    0 
 include/asm-mips/fw/cfe/cfe_api.h                  |   24 
 include/asm-mips/fw/cfe/cfe_error.h                |    0 
 include/asm-mips/hazards.h                         |    2 
 include/asm-mips/hw_irq.h                          |    7 
 include/asm-mips/i8253.h                           |   30 
 include/asm-mips/i8259.h                           |    5 
 include/asm-mips/inventory.h                       |    4 
 include/asm-mips/io.h                              |   18 
 include/asm-mips/ioctl.h                           |   16 
 include/asm-mips/ioctls.h                          |   12 
 include/asm-mips/ip32/machine.h                    |   20 
 include/asm-mips/irq.h                             |   67 
 include/asm-mips/irq_gt641xx.h                     |   60 
 include/asm-mips/irqflags.h                        |   10 
 include/asm-mips/jazz.h                            |   40 
 include/asm-mips/jazzdma.h                         |    1 
 include/asm-mips/jmr3927/tx3927.h                  |   32 
 include/asm-mips/lasat/ds1603.h                    |   18 
 include/asm-mips/lasat/eeprom.h                    |   17 
 include/asm-mips/lasat/head.h                      |   22 
 include/asm-mips/lasat/lasat.h                     |  256 +
 include/asm-mips/lasat/lasatint.h                  |   12 
 include/asm-mips/lasat/picvue.h                    |   15 
 include/asm-mips/lasat/serial.h                    |   13 
 include/asm-mips/linkage.h                         |    2 
 include/asm-mips/local.h                           |   20 
 include/asm-mips/mach-au1x00/au1000.h              |  622 +--
 include/asm-mips/mach-au1x00/au1xxx_dbdma.h        |   14 
 include/asm-mips/mach-au1x00/au1xxx_ide.h          |    2 
 include/asm-mips/mach-au1x00/war.h                 |   25 
 include/asm-mips/mach-bcm47xx/bcm47xx.h            |   25 
 include/asm-mips/mach-bcm47xx/gpio.h               |   59 
 include/asm-mips/mach-bcm47xx/war.h                |   25 
 include/asm-mips/mach-cobalt/cobalt.h              |   61 
 .../asm-mips/mach-cobalt/cpu-feature-overrides.h   |    1 
 include/asm-mips/mach-cobalt/irq.h                 |   58 
 include/asm-mips/mach-cobalt/war.h                 |   25 
 include/asm-mips/mach-dec/war.h                    |   25 
 include/asm-mips/mach-emma2rh/war.h                |   25 
 .../asm-mips/mach-excite/cpu-feature-overrides.h   |    5 
 include/asm-mips/mach-excite/war.h                 |   25 
 include/asm-mips/mach-generic/mangle-port.h        |   32 
 include/asm-mips/mach-ip22/war.h                   |   29 
 include/asm-mips/mach-ip27/irq.h                   |    2 
 include/asm-mips/mach-ip27/mangle-port.h           |   16 
 include/asm-mips/mach-ip27/topology.h              |   20 
 include/asm-mips/mach-ip27/war.h                   |   25 
 include/asm-mips/mach-ip32/kmalloc.h               |    2 
 include/asm-mips/mach-ip32/mangle-port.h           |   16 
 include/asm-mips/mach-ip32/war.h                   |   25 
 include/asm-mips/mach-jazz/mc146818rtc.h           |   10 
 include/asm-mips/mach-jazz/war.h                   |   25 
 include/asm-mips/mach-jmr3927/mangle-port.h        |   16 
 include/asm-mips/mach-jmr3927/war.h                |   25 
 include/asm-mips/mach-lasat/mach-gt64120.h         |   27 
 include/asm-mips/mach-lasat/war.h                  |   25 
 include/asm-mips/mach-lemote/war.h                 |   25 
 include/asm-mips/mach-mips/mach-gt64120.h          |    9 
 include/asm-mips/mach-mips/war.h                   |   25 
 include/asm-mips/mach-mipssim/war.h                |   25 
 include/asm-mips/mach-pb1x00/pb1000.h              |   56 
 include/asm-mips/mach-pb1x00/pb1100.h              |   60 
 include/asm-mips/mach-pnx8550/kernel-entry-init.h  |   26 
 include/asm-mips/mach-pnx8550/uart.h               |    2 
 include/asm-mips/mach-pnx8550/war.h                |   25 
 include/asm-mips/mach-qemu/war.h                   |   25 
 include/asm-mips/mach-rm/war.h                     |   29 
 .../asm-mips/mach-sibyte/cpu-feature-overrides.h   |    7 
 include/asm-mips/mach-sibyte/war.h                 |   37 
 include/asm-mips/mach-tx49xx/war.h                 |   25 
 include/asm-mips/mach-vr41xx/war.h                 |   25 
 include/asm-mips/mach-wrppmc/mach-gt64120.h        |    1 
 include/asm-mips/mach-wrppmc/war.h                 |   25 
 include/asm-mips/mach-yosemite/war.h               |   25 
 include/asm-mips/mc146818-time.h                   |    4 
 include/asm-mips/mips-boards/bonito64.h            |   20 
 include/asm-mips/mips-boards/malta.h               |    2 
 include/asm-mips/mipsmtregs.h                      |   60 
 include/asm-mips/mipsregs.h                        |    4 
 include/asm-mips/mmu_context.h                     |    8 
 include/asm-mips/nile4.h                           |  310 +
 include/asm-mips/paccess.h                         |    8 
 include/asm-mips/page.h                            |    2 
 include/asm-mips/parport.h                         |    6 
 include/asm-mips/pci.h                             |    4 
 include/asm-mips/pci/bridge.h                      |    2 
 include/asm-mips/pgalloc.h                         |    6 
 include/asm-mips/pgtable-32.h                      |    2 
 include/asm-mips/pgtable-64.h                      |    6 
 include/asm-mips/pgtable.h                         |    4 
 include/asm-mips/prctl.h                           |    2 
 include/asm-mips/qemu.h                            |    2 
 include/asm-mips/r4kcache.h                        |    6 
 include/asm-mips/semaphore.h                       |    8 
 include/asm-mips/sgiarcs.h                         |   36 
 include/asm-mips/sibyte/bcm1480_int.h              |   22 
 include/asm-mips/sibyte/bcm1480_l2c.h              |  102 
 include/asm-mips/sibyte/bcm1480_mc.h               |  644 ++-
 include/asm-mips/sibyte/bcm1480_regs.h             |   18 
 include/asm-mips/sibyte/bcm1480_scd.h              |  102 
 include/asm-mips/sibyte/board.h                    |    4 
 include/asm-mips/sibyte/sb1250_defs.h              |   14 
 include/asm-mips/sibyte/sb1250_dma.h               |  246 +
 include/asm-mips/sibyte/sb1250_genbus.h            |  322 +-
 include/asm-mips/sibyte/sb1250_int.h               |   22 
 include/asm-mips/sibyte/sb1250_l2c.h               |   64 
 include/asm-mips/sibyte/sb1250_ldt.h               |  194 -
 include/asm-mips/sibyte/sb1250_mac.h               |  284 +
 include/asm-mips/sibyte/sb1250_mc.h                |  306 +
 include/asm-mips/sibyte/sb1250_regs.h              |   32 
 include/asm-mips/sibyte/sb1250_scd.h               |  306 +
 include/asm-mips/sibyte/sb1250_smbus.h             |   62 
 include/asm-mips/sibyte/sb1250_syncser.h           |   16 
 include/asm-mips/sibyte/sb1250_uart.h              |   70 
 include/asm-mips/siginfo.h                         |    4 
 include/asm-mips/sim.h                             |    4 
 include/asm-mips/smp.h                             |    9 
 include/asm-mips/smtc_ipi.h                        |    1 
 include/asm-mips/sn/addrs.h                        |   50 
 include/asm-mips/sn/arch.h                         |    4 
 include/asm-mips/sn/io.h                           |    2 
 include/asm-mips/sn/klconfig.h                     |    6 
 include/asm-mips/sn/kldir.h                        |    2 
 include/asm-mips/sn/sn0/addrs.h                    |    8 
 include/asm-mips/sni.h                             |   18 
 include/asm-mips/stackframe.h                      |   20 
 include/asm-mips/system.h                          |   10 
 include/asm-mips/time.h                            |   41 
 include/asm-mips/timex.h                           |    2 
 include/asm-mips/tlbflush.h                        |    4 
 include/asm-mips/tx4927/toshiba_rbtx4927.h         |    8 
 include/asm-mips/tx4927/tx4927.h                   |  439 --
 include/asm-mips/tx4927/tx4927_mips.h              | 4177 --------------------
 include/asm-mips/tx4938/rbtx4938.h                 |    2 
 include/asm-mips/tx4938/tx4938.h                   |   44 
 include/asm-mips/tx4938/tx4938_mips.h              |    8 
 include/asm-mips/uaccess.h                         |   58 
 include/asm-mips/unaligned.h                       |   27 
 include/asm-mips/vga.h                             |    4 
 include/asm-mips/war.h                             |  127 -
 include/asm-mips/xtalk/xtalk.h                     |    2 
 kernel/time/tick-broadcast.c                       |    2 
 435 files changed, 14274 insertions(+), 10196 deletions(-)
 create mode 100644 arch/mips/bcm47xx/Makefile
 create mode 100644 arch/mips/bcm47xx/gpio.c
 create mode 100644 arch/mips/bcm47xx/irq.c
 create mode 100644 arch/mips/bcm47xx/prom.c
 create mode 100644 arch/mips/bcm47xx/serial.c
 create mode 100644 arch/mips/bcm47xx/setup.c
 create mode 100644 arch/mips/bcm47xx/time.c
 create mode 100644 arch/mips/bcm47xx/wgt634u.c
 create mode 100644 arch/mips/cobalt/led.c
 create mode 100644 arch/mips/configs/lasat_defconfig
 create mode 100644 arch/mips/configs/mtx1_defconfig
 rename arch/mips/{arc/Makefile => fw/arc/Makefile} (100%)
 rename arch/mips/{arc/arc_con.c => fw/arc/arc_con.c} (100%)
 rename arch/mips/{arc/cmdline.c => fw/arc/cmdline.c} (100%)
 rename arch/mips/{arc/env.c => fw/arc/env.c} (95%)
 rename arch/mips/{arc/file.c => fw/arc/file.c} (98%)
 rename arch/mips/{arc/identify.c => fw/arc/identify.c} (65%)
 rename arch/mips/{arc/init.c => fw/arc/init.c} (100%)
 rename arch/mips/{arc/memory.c => fw/arc/memory.c} (94%)
 rename arch/mips/{arc/misc.c => fw/arc/misc.c} (98%)
 rename arch/mips/{arc/promlib.c => fw/arc/promlib.c} (100%)
 rename arch/mips/{arc/salone.c => fw/arc/salone.c} (100%)
 rename arch/mips/{arc/time.c => fw/arc/time.c} (94%)
 rename arch/mips/{arc/tree.c => fw/arc/tree.c} (99%)
 create mode 100644 arch/mips/fw/cfe/Makefile
 rename arch/mips/{sibyte/cfe/cfe_api.c => fw/cfe/cfe_api.c} (100%)
 rename arch/mips/{sibyte/cfe/cfe_api_int.h => fw/cfe/cfe_api_int.h} (100%)
 delete mode 100644 arch/mips/jazz/jazz-platform.c
 create mode 100644 arch/mips/kernel/i8253.c
 create mode 100644 arch/mips/kernel/irq-gt641xx.c
 create mode 100644 arch/mips/lasat/Kconfig
 create mode 100644 arch/mips/lasat/Makefile
 create mode 100644 arch/mips/lasat/at93c.c
 create mode 100644 arch/mips/lasat/at93c.h
 create mode 100644 arch/mips/lasat/ds1603.c
 create mode 100644 arch/mips/lasat/ds1603.h
 create mode 100644 arch/mips/lasat/image/Makefile
 create mode 100644 arch/mips/lasat/image/head.S
 create mode 100644 arch/mips/lasat/image/romscript.normal
 create mode 100644 arch/mips/lasat/interrupt.c
 create mode 100644 arch/mips/lasat/lasat_board.c
 create mode 100644 arch/mips/lasat/lasat_models.h
 create mode 100644 arch/mips/lasat/picvue.c
 create mode 100644 arch/mips/lasat/picvue.h
 create mode 100644 arch/mips/lasat/picvue_proc.c
 create mode 100644 arch/mips/lasat/prom.c
 create mode 100644 arch/mips/lasat/prom.h
 create mode 100644 arch/mips/lasat/reset.c
 create mode 100644 arch/mips/lasat/serial.c
 create mode 100644 arch/mips/lasat/setup.c
 create mode 100644 arch/mips/lasat/sysctl.c
 create mode 100644 arch/mips/lasat/sysctl.h
 delete mode 100644 arch/mips/mm/c-sb1.c
 create mode 100644 arch/mips/pci/ops-nile4.c
 create mode 100644 arch/mips/pci/pci-lasat.c
 rename include/asm-mips/{arc/hinv.h => fw/arc/hinv.h} (97%)
 rename include/asm-mips/{arc/types.h => fw/arc/types.h} (100%)
 rename arch/mips/sibyte/cfe/cfe_api.h => include/asm-mips/fw/cfe/cfe_api.h (90%)
 rename arch/mips/sibyte/cfe/cfe_error.h => include/asm-mips/fw/cfe/cfe_error.h (100%)
 create mode 100644 include/asm-mips/i8253.h
 delete mode 100644 include/asm-mips/ip32/machine.h
 create mode 100644 include/asm-mips/irq_gt641xx.h
 create mode 100644 include/asm-mips/lasat/ds1603.h
 create mode 100644 include/asm-mips/lasat/eeprom.h
 create mode 100644 include/asm-mips/lasat/head.h
 create mode 100644 include/asm-mips/lasat/lasat.h
 create mode 100644 include/asm-mips/lasat/lasatint.h
 create mode 100644 include/asm-mips/lasat/picvue.h
 create mode 100644 include/asm-mips/lasat/serial.h
 create mode 100644 include/asm-mips/mach-au1x00/war.h
 create mode 100644 include/asm-mips/mach-bcm47xx/bcm47xx.h
 create mode 100644 include/asm-mips/mach-bcm47xx/gpio.h
 create mode 100644 include/asm-mips/mach-bcm47xx/war.h
 create mode 100644 include/asm-mips/mach-cobalt/irq.h
 create mode 100644 include/asm-mips/mach-cobalt/war.h
 create mode 100644 include/asm-mips/mach-dec/war.h
 create mode 100644 include/asm-mips/mach-emma2rh/war.h
 create mode 100644 include/asm-mips/mach-excite/war.h
 create mode 100644 include/asm-mips/mach-ip22/war.h
 create mode 100644 include/asm-mips/mach-ip27/war.h
 create mode 100644 include/asm-mips/mach-ip32/war.h
 create mode 100644 include/asm-mips/mach-jazz/war.h
 create mode 100644 include/asm-mips/mach-jmr3927/war.h
 create mode 100644 include/asm-mips/mach-lasat/mach-gt64120.h
 create mode 100644 include/asm-mips/mach-lasat/war.h
 create mode 100644 include/asm-mips/mach-lemote/war.h
 create mode 100644 include/asm-mips/mach-mips/war.h
 create mode 100644 include/asm-mips/mach-mipssim/war.h
 create mode 100644 include/asm-mips/mach-pnx8550/war.h
 create mode 100644 include/asm-mips/mach-qemu/war.h
 create mode 100644 include/asm-mips/mach-rm/war.h
 create mode 100644 include/asm-mips/mach-sibyte/war.h
 create mode 100644 include/asm-mips/mach-tx49xx/war.h
 create mode 100644 include/asm-mips/mach-vr41xx/war.h
 create mode 100644 include/asm-mips/mach-wrppmc/war.h
 create mode 100644 include/asm-mips/mach-yosemite/war.h
 create mode 100644 include/asm-mips/nile4.h
 delete mode 100644 include/asm-mips/tx4927/tx4927_mips.h
