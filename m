Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbXJBLFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbXJBLFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 07:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbXJBLEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 07:04:44 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:57673 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbXJBLEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 07:04:41 -0400
Date: Tue, 2 Oct 2007 12:04:38 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: What's in linux-mips.git for 2.6.24?
Message-ID: <20071002110438.GA21065@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The by far biggest item is support for tickless kernels on MIPS and the
rewrite for many of the timer devices previously used as clocksources
and clockevents.  Various cleanups, including some moving of code and
support for 32-bit Broadcom BCM47XX processors, the return of support
for LASAT which isn't quite as unused as previously thought ...

  Ralf

http://www.linux-mips.org/git?p=linux-queue.git;a=shortlog;h=queue

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

Franck Bui-Huu (4):
      [MIPS] Remove '-mno-explicit-relocs' option when CONFIG_BUILD_ELF64
      [MIPS] Automatically set CONFIG_BUILD_ELF64
      [MIPS] Rename CONFIG_BUILD_ELF64 into KBUILD_64BIT_SYM32
      [MIPS] Don't abort the build process if '-msym32' isn't supported

Kevin D. Kissell (1):
      [MIPS] IRQ Affinity Support for SMTC on Malta Platform

Maciej W. Rozycki (2):
      [MIPS] R3000 setup for kernel_thread()
      [MIPS] dec/time.c: Remove a leftover inclusion

Ralf Baechle (25):
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
      [MIPS] Optimize branch prediction in cmpxchg_local

Sam Ravnborg (1):
      [MIPS] Introduce a consistent style for vmlinux.lds.

Thiemo Seufer (1):
      [MIPS] Define known MIPS ISA overrides for Sibyte and Excite boards.

Thomas Bogendoerfer (1):
      [MIPS] JAZZ fixes

Thomas Gleixner (1):
      [MIPS] cleanup struct irqaction initializers

Yoichi Yuasa (12):
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

 arch/mips/Kconfig                                  |   98 
 arch/mips/Makefile                                 |   48 
 arch/mips/au1000/common/irq.c                      |   15 
 arch/mips/au1000/common/setup.c                    |    2 
 arch/mips/au1000/common/time.c                     |   44 
 arch/mips/au1000/db1x00/init.c                     |    2 
 arch/mips/au1000/mtx-1/init.c                      |    1 
 arch/mips/au1000/pb1000/init.c                     |    1 
 arch/mips/au1000/pb1100/init.c                     |    1 
 arch/mips/au1000/pb1200/init.c                     |    1 
 arch/mips/au1000/pb1500/init.c                     |    1 
 arch/mips/au1000/pb1550/init.c                     |    1 
 arch/mips/au1000/xxs1500/init.c                    |    1 
 arch/mips/basler/excite/excite_prom.c              |    1 
 arch/mips/basler/excite/excite_setup.c             |    5 
 arch/mips/bcm47xx/Makefile                         |    6 
 arch/mips/bcm47xx/gpio.c                           |   79 
 arch/mips/bcm47xx/irq.c                            |   55 
 arch/mips/bcm47xx/prom.c                           |  158 +
 arch/mips/bcm47xx/serial.c                         |   52 
 arch/mips/bcm47xx/setup.c                          |  123 +
 arch/mips/bcm47xx/time.c                           |   55 
 arch/mips/bcm47xx/wgt634u.c                        |   64 
 arch/mips/cobalt/Makefile                          |    2 
 arch/mips/cobalt/irq.c                             |  116 -
 arch/mips/cobalt/led.c                             |   62 
 arch/mips/cobalt/reset.c                           |   22 
 arch/mips/cobalt/rtc.c                             |    5 
 arch/mips/cobalt/serial.c                          |    7 
 arch/mips/cobalt/setup.c                           |   17 
 arch/mips/configs/bigsur_defconfig                 |    1 
 arch/mips/configs/cobalt_defconfig                 |   23 
 arch/mips/configs/lasat_defconfig                  |  828 ++++
 arch/mips/configs/mtx1_defconfig                   | 3115 +++++++++++++++
 arch/mips/configs/sb1250-swarm_defconfig           |    1 
 arch/mips/dec/prom/identify.c                      |    3 
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
 arch/mips/fw/arc/memory.c                          |    0 
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
 arch/mips/jazz/setup.c                             |  128 +
 arch/mips/jmr3927/rbhma3100/init.c                 |    1 
 arch/mips/jmr3927/rbhma3100/irq.c                  |    8 
 arch/mips/jmr3927/rbhma3100/setup.c                |    4 
 arch/mips/kernel/Makefile                          |    2 
 arch/mips/kernel/cpu-probe.c                       |   28 
 arch/mips/kernel/i8253.c                           |  213 +
 arch/mips/kernel/i8259.c                           |   21 
 arch/mips/kernel/irq-gt641xx.c                     |  131 +
 arch/mips/kernel/proc.c                            |    2 
 arch/mips/kernel/process.c                         |    7 
 arch/mips/kernel/setup.c                           |    2 
 arch/mips/kernel/smp.c                             |    2 
 arch/mips/kernel/smtc.c                            |  132 -
 arch/mips/kernel/time.c                            |  414 +-
 arch/mips/kernel/traps.c                           |   10 
 arch/mips/kernel/vmlinux.lds.S                     |  339 +-
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
 arch/mips/mips-boards/atlas/atlas_setup.c          |    5 
 arch/mips/mips-boards/generic/time.c               |  141 -
 arch/mips/mips-boards/malta/malta_setup.c          |    4 
 arch/mips/mips-boards/malta/malta_smtc.c           |   50 
 arch/mips/mips-boards/sead/sead_setup.c            |    3 
 arch/mips/mipssim/sim_setup.c                      |    2 
 arch/mips/mipssim/sim_time.c                       |   74 
 arch/mips/mm/Makefile                              |    2 
 arch/mips/mm/c-r4k.c                               |   96 
 arch/mips/mm/c-sb1.c                               |  535 ---
 arch/mips/mm/cache.c                               |    9 
 arch/mips/mm/pg-sb1.c                              |    8 
 arch/mips/mm/tlbex.c                               |    2 
 arch/mips/pci/Makefile                             |    2 
 arch/mips/pci/fixup-cobalt.c                       |   23 
 arch/mips/pci/ops-nile4.c                          |  147 +
 arch/mips/pci/ops-pmcmsp.c                         |    2 
 arch/mips/pci/pci-lasat.c                          |   91 
 arch/mips/philips/pnx8550/common/setup.c           |    3 
 arch/mips/philips/pnx8550/common/time.c            |    7 
 arch/mips/philips/pnx8550/jbs/init.c               |    1 
 arch/mips/philips/pnx8550/stb810/prom_init.c       |    1 
 arch/mips/pmc-sierra/msp71xx/msp_hwbutton.c        |    2 
 arch/mips/pmc-sierra/msp71xx/msp_setup.c           |   18 
 arch/mips/pmc-sierra/msp71xx/msp_time.c            |    3 
 arch/mips/pmc-sierra/yosemite/prom.c               |    1 
 arch/mips/pmc-sierra/yosemite/setup.c              |   26 
 arch/mips/qemu/q-irq.c                             |    4 
 arch/mips/qemu/q-setup.c                           |   10 
 arch/mips/sgi-ip22/ip22-int.c                      |    5 
 arch/mips/sgi-ip22/ip22-setup.c                    |    2 
 arch/mips/sgi-ip22/ip22-time.c                     |   35 
 arch/mips/sgi-ip27/ip27-berr.c                     |    2 
 arch/mips/sgi-ip27/ip27-init.c                     |    6 
 arch/mips/sgi-ip27/ip27-smp.c                      |    2 
 arch/mips/sgi-ip27/ip27-timer.c                    |   38 
 arch/mips/sgi-ip32/ip32-irq.c                      |   18 
 arch/mips/sgi-ip32/ip32-setup.c                    |   12 
 arch/mips/sibyte/Kconfig                           |   13 
 arch/mips/sibyte/bcm1480/irq.c                     |   13 
 arch/mips/sibyte/bcm1480/setup.c                   |   78 
 arch/mips/sibyte/bcm1480/time.c                    |  118 -
 arch/mips/sibyte/cfe/Makefile                      |    2 
 arch/mips/sibyte/cfe/console.c                     |    4 
 arch/mips/sibyte/cfe/setup.c                       |    5 
 arch/mips/sibyte/cfe/smp.c                         |    4 
 arch/mips/sibyte/common/Makefile                   |    1 
 arch/mips/sibyte/sb1250/irq.c                      |   50 
 arch/mips/sibyte/sb1250/prom.c                     |    1 
 arch/mips/sibyte/sb1250/setup.c                    |   74 
 arch/mips/sibyte/sb1250/time.c                     |  198 +
 arch/mips/sibyte/swarm/rtc_m41t81.c                |    3 
 arch/mips/sibyte/swarm/rtc_xicor1241.c             |    3 
 arch/mips/sibyte/swarm/setup.c                     |   56 
 arch/mips/sni/pcimt.c                              |    1 
 arch/mips/sni/pcit.c                               |    1 
 arch/mips/sni/rm200.c                              |    1 
 arch/mips/sni/setup.c                              |    2 
 arch/mips/sni/time.c                               |   11 
 arch/mips/tx4927/common/tx4927_dbgio.c             |    1 
 arch/mips/tx4927/common/tx4927_prom.c              |   12 
 arch/mips/tx4927/common/tx4927_setup.c             |   20 
 .../tx4927/toshiba_rbtx4927/toshiba_rbtx4927_irq.c |   31 
 .../toshiba_rbtx4927/toshiba_rbtx4927_prom.c       |    2 
 .../toshiba_rbtx4927/toshiba_rbtx4927_setup.c      |   32 
 arch/mips/tx4938/common/setup.c                    |    9 
 arch/mips/tx4938/toshiba_rbtx4938/prom.c           |    1 
 arch/mips/tx4938/toshiba_rbtx4938/setup.c          |    3 
 arch/mips/vr41xx/common/init.c                     |    8 
 arch/mips/vr41xx/common/pmu.c                      |   36 
 arch/mips/vr41xx/nec-cmbvr4133/setup.c             |    1 
 drivers/video/logo/logo.c                          |   10 
 include/asm-mips/bootinfo.h                        |   41 
 include/asm-mips/cpu-features.h                    |    3 
 include/asm-mips/cpu-info.h                        |   18 
 include/asm-mips/cpu.h                             |   47 
 include/asm-mips/floppy.h                          |    4 
 include/asm-mips/fw/arc/hinv.h                     |    5 
 include/asm-mips/fw/arc/types.h                    |    0 
 include/asm-mips/fw/cfe/cfe_api.h                  |    0 
 include/asm-mips/fw/cfe/cfe_error.h                |    0 
 include/asm-mips/hw_irq.h                          |    7 
 include/asm-mips/i8253.h                           |   30 
 include/asm-mips/i8259.h                           |    5 
 include/asm-mips/ip32/machine.h                    |   20 
 include/asm-mips/irq.h                             |   67 
 include/asm-mips/irq_gt641xx.h                     |   60 
 include/asm-mips/jazz.h                            |   40 
 include/asm-mips/jazzdma.h                         |    1 
 include/asm-mips/lasat/ds1603.h                    |   18 
 include/asm-mips/lasat/eeprom.h                    |   17 
 include/asm-mips/lasat/head.h                      |   22 
 include/asm-mips/lasat/lasat.h                     |  256 +
 include/asm-mips/lasat/lasatint.h                  |   12 
 include/asm-mips/lasat/picvue.h                    |   15 
 include/asm-mips/lasat/serial.h                    |   13 
 include/asm-mips/linkage.h                         |    2 
 include/asm-mips/mach-au1x00/war.h                 |   25 
 include/asm-mips/mach-bcm47xx/bcm47xx.h            |   25 
 include/asm-mips/mach-bcm47xx/gpio.h               |   59 
 include/asm-mips/mach-bcm47xx/war.h                |   25 
 include/asm-mips/mach-cobalt/cobalt.h              |   26 
 .../asm-mips/mach-cobalt/cpu-feature-overrides.h   |    1 
 include/asm-mips/mach-cobalt/irq.h                 |   58 
 include/asm-mips/mach-cobalt/war.h                 |   25 
 include/asm-mips/mach-dec/war.h                    |   25 
 include/asm-mips/mach-emma2rh/war.h                |   25 
 .../asm-mips/mach-excite/cpu-feature-overrides.h   |    5 
 include/asm-mips/mach-excite/war.h                 |   25 
 include/asm-mips/mach-ip22/war.h                   |   29 
 include/asm-mips/mach-ip27/irq.h                   |    2 
 include/asm-mips/mach-ip27/topology.h              |   20 
 include/asm-mips/mach-ip27/war.h                   |   25 
 include/asm-mips/mach-ip32/war.h                   |   25 
 include/asm-mips/mach-jazz/mc146818rtc.h           |   10 
 include/asm-mips/mach-jazz/war.h                   |   25 
 include/asm-mips/mach-jmr3927/war.h                |   25 
 include/asm-mips/mach-lasat/mach-gt64120.h         |   27 
 include/asm-mips/mach-lasat/war.h                  |   25 
 include/asm-mips/mach-lemote/war.h                 |   25 
 include/asm-mips/mach-mips/mach-gt64120.h          |    9 
 include/asm-mips/mach-mips/war.h                   |   25 
 include/asm-mips/mach-mipssim/war.h                |   25 
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
 include/asm-mips/nile4.h                           |  310 +
 include/asm-mips/pci.h                             |    4 
 include/asm-mips/pgtable-64.h                      |    2 
 include/asm-mips/qemu.h                            |    2 
 include/asm-mips/sgiarcs.h                         |    2 
 include/asm-mips/smtc_ipi.h                        |    1 
 include/asm-mips/sn/arch.h                         |    4 
 include/asm-mips/sn/klconfig.h                     |    4 
 include/asm-mips/stackframe.h                      |   12 
 include/asm-mips/system.h                          |   16 
 include/asm-mips/time.h                            |   41 
 include/asm-mips/tx4927/toshiba_rbtx4927.h         |    8 
 include/asm-mips/tx4927/tx4927.h                   |  439 --
 include/asm-mips/tx4927/tx4927_mips.h              | 4177 --------------------
 include/asm-mips/war.h                             |  127 -
 252 files changed, 11104 insertions(+), 7049 deletions(-)
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
 rename arch/mips/{arc/memory.c => fw/arc/memory.c} (100%)
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
 rename arch/mips/sibyte/cfe/cfe_api.h => include/asm-mips/fw/cfe/cfe_api.h (100%)
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
