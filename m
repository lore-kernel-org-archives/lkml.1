Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYAOTV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYAOTV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 14:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYAOTVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 14:21:50 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:46030 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYAOTVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 14:21:49 -0500
Date: Tue, 15 Jan 2008 19:21:45 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org
Subject: What's in linux-mips.git for Linux 2.6.25?
Message-ID: <20080115192145.GA22506@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The highlights:

 - Support for Qemu platform removed due it being obsolete.
 - Support for SGI Indigo 2 R10000 aka IP28
 - Support for Routerboard RB532 and AR7 not merged yet, not sure if it'll
   make it into 2.6.25.

  Ralf 

Alejandro Martinez Ruiz (1):
      [MIPS] Converting most array size calculations to use ARRAY_SIZE().

Andrew Sharp (1):
      [MIPS] Put cast inside macro instead of all the callers

Atsushi Nemoto (2):
      [MIPS] cleanup tx39/tx49 setup code
      [MIPS] TXx9 watchdog support for rbhma3100,rbhma4200,rbhma4500

Christoph Hellwig (1):
      [MIPS] CFE: Make code remotely resemble Linux code.

Daniel Walker (1):
      [MIPS] Lasat: Convert pvc_sem semaphore to mutex

Florian Fainelli (2):
      [MIPS] MTX-1: Add GPIO system button
      [MIPS] Cobalt 64-bits kernels can be safely unmarked experimental

Franck Bui-Huu (4):
      [MIPS] tlbex.c: Cleanup __init usages.
      [MIPS] tlbex.c: cleanup include files
      [MIPS] tlbex.c: use __cacheline_aligned instead of __tlb_handler_align
      [MIPS] tlbex.c: cleanup debug code

Lucas Woods (1):
      [MIPS] Remove duplicate includes.

Maciej W. Rozycki (2):
      [MIPS] R4000/R4400 errata workarounds
      [MIPS] R4000/R4400 daddiu erratum workaround

Manuel Lauss (1):
      [MIPS] Alchemy: Au1210/Au1250 CPU support

Ralf Baechle (17):
      [MIPS] Delete unused CONFIG_DMA_IP32.
      [MIPS] Delete unused CONFIG_64BIT_CONTEXT
      [MIPS] tlbex: Cleanup handling of R2 hazards in TLB handlers.
      [MIPS] Use pte_present instead of open coded test for _PAGE_PRESENT.
      [MIPS] Remove useless S-cache flushes.
      [MIPS] MT: Scheduler support for SMT
      [MIPS] Cleanup pcspeaker platform device registration.
      [MIPS] SMP: Call platform methods via ops structure.
      [MIPS] Remove CONFIG_SIBYTE_PT{1120,1125,SWARM}
      [MIPS] BCM1480: Use constants instead of magic numbers in PCI code.
      [MIPS] Fulong: don't reinitialize pci_probe_only to it's default value.
      [MIPS] Eleminate local symbols from the symbol table.
      [MIPS] Extend performance counter event field.
      [MIPS] fixmap: delete unused __set_fixmap, set_fixmap and set_fixmap_nocache
      [MIPS] Altas, Malta: Switch boot file format to raw.
      [MIPS] Delete CONFIG_MSP_FPGA
      [MIPS] Qemu: Remove platform.

Robert P. J. Day (1):
      [MIPS]  Delete now-unreferenced i2c-yosemite.h header file.

Roel Kluin (1):
      [MIPS] ARC: Use strchr instead of strstr.

Thomas Bogendoerfer (6):
      [MIPS] Use real cache invalidate
      [MIPS] IP22/IP28: fix extracting board/chip rev
      [MIPS] IP28: added cache barrier to assembly routines
      [MIPS] Use correct dma flushing in dma_cache_sync()
      [MIPS] IP28 support
      [MIPS] RM: Collected changes

Vitaly Wool (1):
      [MIPS] pnx8xxx: clocksource cleanups

Yoichi Yuasa (7):
      [MIPS] remove unused mips_machtype
      [MIPS] clean up au1xxx_irqmap.c include files
      [MIPS] time: remove unused mips_timer_state()
      [MIPS] move vr41xx_calculate_clock_frequency() to plat_time_init()
      [MIPS] remove unneeded button check for reset
      [MIPS] add cpu_wait() to machine_halt()
      [MIPS] move the eXcite local config to excitedirectory

 arch/mips/Kconfig                                  |  181 ++++---
 arch/mips/Makefile                                 |   40 +-
 arch/mips/au1000/common/au1xxx_irqmap.c            |   21 -
 arch/mips/au1000/common/dbdma.c                    |    2 
 arch/mips/au1000/db1x00/init.c                     |   11 
 arch/mips/au1000/mtx-1/init.c                      |    2 
 arch/mips/au1000/mtx-1/platform.c                  |   27 +
 arch/mips/au1000/pb1000/init.c                     |    2 
 arch/mips/au1000/pb1100/init.c                     |    2 
 arch/mips/au1000/pb1200/init.c                     |    2 
 arch/mips/au1000/pb1500/init.c                     |    2 
 arch/mips/au1000/pb1550/init.c                     |    2 
 arch/mips/au1000/xxs1500/init.c                    |    2 
 arch/mips/basler/excite/Kconfig                    |    9 
 arch/mips/basler/excite/excite_prom.c              |    2 
 arch/mips/cobalt/reset.c                           |   24 -
 arch/mips/configs/atlas_defconfig                  |    2 
 arch/mips/configs/bigsur_defconfig                 |    2 
 arch/mips/configs/capcella_defconfig               |    2 
 arch/mips/configs/cobalt_defconfig                 |    2 
 arch/mips/configs/db1000_defconfig                 |    2 
 arch/mips/configs/db1100_defconfig                 |    2 
 arch/mips/configs/db1200_defconfig                 |    2 
 arch/mips/configs/db1500_defconfig                 |    2 
 arch/mips/configs/db1550_defconfig                 |    2 
 arch/mips/configs/decstation_defconfig             |    2 
 arch/mips/configs/e55_defconfig                    |    2 
 arch/mips/configs/emma2rh_defconfig                |    2 
 arch/mips/configs/excite_defconfig                 |    2 
 arch/mips/configs/fulong_defconfig                 |    2 
 arch/mips/configs/ip22_defconfig                   |    2 
 arch/mips/configs/ip27_defconfig                   |    2 
 arch/mips/configs/ip32_defconfig                   |    2 
 arch/mips/configs/jazz_defconfig                   |    2 
 arch/mips/configs/jmr3927_defconfig                |   17 +
 arch/mips/configs/lasat_defconfig                  |    2 
 arch/mips/configs/malta_defconfig                  |    2 
 arch/mips/configs/mipssim_defconfig                |    2 
 arch/mips/configs/mpc30x_defconfig                 |    2 
 arch/mips/configs/msp71xx_defconfig                |    2 
 arch/mips/configs/mtx1_defconfig                   |    3 
 arch/mips/configs/pb1100_defconfig                 |    2 
 arch/mips/configs/pb1500_defconfig                 |    2 
 arch/mips/configs/pb1550_defconfig                 |    2 
 arch/mips/configs/pnx8550-jbs_defconfig            |    2 
 arch/mips/configs/pnx8550-stb810_defconfig         |    2 
 arch/mips/configs/qemu_defconfig                   |    2 
 arch/mips/configs/rbhma4200_defconfig              |   17 +
 arch/mips/configs/rbhma4500_defconfig              |   17 +
 arch/mips/configs/rm200_defconfig                  |    2 
 arch/mips/configs/sb1250-swarm_defconfig           |    2 
 arch/mips/configs/sead_defconfig                   |    2 
 arch/mips/configs/tb0219_defconfig                 |    2 
 arch/mips/configs/tb0226_defconfig                 |    2 
 arch/mips/configs/tb0287_defconfig                 |    2 
 arch/mips/configs/workpad_defconfig                |    2 
 arch/mips/configs/wrppmc_defconfig                 |    2 
 arch/mips/configs/yosemite_defconfig               |    2 
 arch/mips/dec/time.c                               |    1 
 arch/mips/defconfig                                |    2 
 arch/mips/fw/arc/cmdline.c                         |    2 
 arch/mips/fw/arc/init.c                            |    8 
 arch/mips/fw/cfe/cfe_api.c                         |  184 ++-----
 arch/mips/fw/cfe/cfe_api_int.h                     |  186 ++++---
 arch/mips/fw/lib/Makefile                          |    5 
 arch/mips/fw/lib/call_o32.S                        |   97 ++++
 arch/mips/fw/sni/Makefile                          |    5 
 arch/mips/fw/sni/sniprom.c                         |  152 ++++++
 arch/mips/gt64120/wrppmc/setup.c                   |    2 
 arch/mips/jazz/setup.c                             |    7 
 arch/mips/jmr3927/rbhma3100/init.c                 |    4 
 arch/mips/jmr3927/rbhma3100/setup.c                |   60 ++
 arch/mips/kernel/cpu-bugs64.c                      |   47 +-
 arch/mips/kernel/cpu-probe.c                       |    9 
 arch/mips/kernel/genex.S                           |    8 
 arch/mips/kernel/kspd.c                            |    3 
 arch/mips/kernel/mips-mt.c                         |    1 
 arch/mips/kernel/pcspeaker.c                       |   28 -
 arch/mips/kernel/proc.c                            |    1 
 arch/mips/kernel/rtlx.c                            |    1 
 arch/mips/kernel/setup.c                           |    7 
 arch/mips/kernel/smp-mt.c                          |  193 ++++----
 arch/mips/kernel/smp.c                             |   53 ++
 arch/mips/kernel/smtc-proc.c                       |    1 
 arch/mips/kernel/smtc.c                            |    1 
 arch/mips/kernel/time.c                            |    2 
 arch/mips/kernel/vpe.c                             |    1 
 arch/mips/lasat/picvue.c                           |    2 
 arch/mips/lasat/picvue.h                           |    3 
 arch/mips/lasat/picvue_proc.c                      |   18 -
 arch/mips/lemote/lm2e/pci.c                        |    3 
 arch/mips/lemote/lm2e/prom.c                       |    2 
 arch/mips/lib/csum_partial.S                       |  275 ++++++-----
 arch/mips/lib/memcpy-inatomic.S                    |  141 +++---
 arch/mips/lib/memcpy.S                             |  250 ++++++----
 arch/mips/lib/memset.S                             |   44 +-
 arch/mips/lib/strlen_user.S                        |    6 
 arch/mips/lib/strncpy_user.S                       |   15 -
 arch/mips/lib/strnlen_user.S                       |    7 
 arch/mips/lib/uncached.c                           |   12 
 arch/mips/mips-boards/generic/init.c               |    8 
 arch/mips/mips-boards/malta/malta_smtc.c           |   66 ++-
 arch/mips/mipssim/Makefile                         |    2 
 arch/mips/mipssim/sim_setup.c                      |   16 +
 arch/mips/mipssim/sim_smtc.c                       |   92 ++--
 arch/mips/mm/c-r4k.c                               |   17 -
 arch/mips/mm/dma-default.c                         |    2 
 arch/mips/mm/pg-r4k.c                              |   66 +--
 arch/mips/mm/tlbex.c                               |  252 +++++-----
 arch/mips/oprofile/op_model_mipsxx.c               |    2 
 arch/mips/pci/pci-bcm1480.c                        |    4 
 arch/mips/pci/pci-bcm1480ht.c                      |    4 
 arch/mips/philips/pnx8550/common/setup.c           |    2 
 arch/mips/philips/pnx8550/common/time.c            |   35 -
 arch/mips/philips/pnx8550/jbs/init.c               |    3 
 arch/mips/philips/pnx8550/stb810/prom_init.c       |    2 
 arch/mips/pmc-sierra/yosemite/i2c-yosemite.h       |   96 ----
 arch/mips/pmc-sierra/yosemite/prom.c               |    7 
 arch/mips/pmc-sierra/yosemite/smp.c                |  149 +++---
 arch/mips/qemu/Makefile                            |   10 
 arch/mips/qemu/q-console.c                         |   26 -
 arch/mips/qemu/q-firmware.c                        |   24 -
 arch/mips/qemu/q-irq.c                             |   37 -
 arch/mips/qemu/q-mem.c                             |    5 
 arch/mips/qemu/q-reset.c                           |   33 -
 arch/mips/qemu/q-setup.c                           |   22 -
 arch/mips/qemu/q-smp.c                             |   55 --
 arch/mips/sgi-ip22/Makefile                        |    8 
 arch/mips/sgi-ip22/ip22-mc.c                       |    4 
 arch/mips/sgi-ip22/ip28-berr.c                     |  503 ++++++++++++++++++++
 arch/mips/sgi-ip27/ip27-init.c                     |    1 
 arch/mips/sgi-ip27/ip27-klnuma.c                   |    1 
 arch/mips/sgi-ip27/ip27-smp.c                      |  109 +++-
 arch/mips/sibyte/bcm1480/smp.c                     |  101 ++++
 arch/mips/sibyte/cfe/Makefile                      |    1 
 arch/mips/sibyte/cfe/setup.c                       |   14 -
 arch/mips/sibyte/cfe/smp.c                         |  110 ----
 arch/mips/sibyte/sb1250/smp.c                      |  100 ++++
 arch/mips/sni/Makefile                             |    2 
 arch/mips/sni/a20r.c                               |   13 -
 arch/mips/sni/eisa.c                               |   52 ++
 arch/mips/sni/irq.c                                |    4 
 arch/mips/sni/pcit.c                               |    7 
 arch/mips/sni/rm200.c                              |  326 ++++++++++++-
 arch/mips/sni/setup.c                              |  143 ++++++
 arch/mips/sni/sniprom.c                            |  251 ----------
 arch/mips/sni/time.c                               |    1 
 arch/mips/tx4927/common/Makefile                   |    2 
 arch/mips/tx4927/common/tx4927_setup.c             |  186 -------
 .../toshiba_rbtx4927/toshiba_rbtx4927_setup.c      |   96 +++-
 arch/mips/tx4938/common/Makefile                   |    2 
 arch/mips/tx4938/common/setup.c                    |   45 --
 arch/mips/tx4938/toshiba_rbtx4938/prom.c           |    1 
 arch/mips/tx4938/toshiba_rbtx4938/setup.c          |   31 +
 arch/mips/vr41xx/common/init.c                     |    4 
 arch/mips/vr41xx/nec-cmbvr4133/setup.c             |    4 
 include/asm-mips/addrspace.h                       |    2 
 include/asm-mips/asm.h                             |    8 
 include/asm-mips/bootinfo.h                        |  105 ----
 include/asm-mips/bugs.h                            |   25 +
 include/asm-mips/cpu-info.h                        |    5 
 include/asm-mips/cpu.h                             |    4 
 include/asm-mips/delay.h                           |   23 +
 include/asm-mips/dma.h                             |    7 
 include/asm-mips/fixmap.h                          |   10 
 include/asm-mips/fw/cfe/cfe_api.h                  |   87 ---
 include/asm-mips/fw/cfe/cfe_error.h                |   19 -
 include/asm-mips/mach-cobalt/cobalt.h              |   15 -
 include/asm-mips/mach-ip28/cpu-feature-overrides.h |   50 ++
 include/asm-mips/mach-ip28/ds1286.h                |    4 
 include/asm-mips/mach-ip28/spaces.h                |   22 +
 include/asm-mips/mach-ip28/war.h                   |    8 
 include/asm-mips/mach-qemu/cpu-feature-overrides.h |   32 -
 include/asm-mips/mipsprom.h                        |    2 
 include/asm-mips/pmc-sierra/msp71xx/msp_regs.h     |    4 
 include/asm-mips/r4kcache.h                        |    7 
 include/asm-mips/sgi/ioc.h                         |    4 
 include/asm-mips/sibyte/board.h                    |    6 
 include/asm-mips/sibyte/sb1250.h                   |    2 
 include/asm-mips/sibyte/swarm.h                    |   18 -
 include/asm-mips/smp-ops.h                         |   56 ++
 include/asm-mips/smp.h                             |   64 ---
 include/asm-mips/sni.h                             |  159 ++++--
 include/asm-mips/stackframe.h                      |    9 
 include/asm-mips/time.h                            |    9 
 include/asm-mips/topology.h                        |   16 +
 include/asm-mips/tx4927/tx4927_pci.h               |    1 
 include/asm-mips/uaccess.h                         |   13 -
 include/asm-mips/war.h                             |   62 ++
 189 files changed, 3530 insertions(+), 2797 deletions(-)
 create mode 100644 arch/mips/basler/excite/Kconfig
 create mode 100644 arch/mips/fw/lib/Makefile
 create mode 100644 arch/mips/fw/lib/call_o32.S
 create mode 100644 arch/mips/fw/sni/Makefile
 create mode 100644 arch/mips/fw/sni/sniprom.c
 delete mode 100644 arch/mips/kernel/pcspeaker.c
 rename arch/mips/mipssim/{sim_smp.c => sim_smtc.c} (64%)
 delete mode 100644 arch/mips/pmc-sierra/yosemite/i2c-yosemite.h
 delete mode 100644 arch/mips/qemu/Makefile
 delete mode 100644 arch/mips/qemu/q-console.c
 delete mode 100644 arch/mips/qemu/q-firmware.c
 delete mode 100644 arch/mips/qemu/q-irq.c
 delete mode 100644 arch/mips/qemu/q-mem.c
 delete mode 100644 arch/mips/qemu/q-reset.c
 delete mode 100644 arch/mips/qemu/q-setup.c
 delete mode 100644 arch/mips/qemu/q-smp.c
 create mode 100644 arch/mips/sgi-ip22/ip28-berr.c
 delete mode 100644 arch/mips/sibyte/cfe/smp.c
 create mode 100644 arch/mips/sni/eisa.c
 delete mode 100644 arch/mips/sni/sniprom.c
 delete mode 100644 arch/mips/tx4927/common/tx4927_setup.c
 delete mode 100644 arch/mips/tx4938/common/setup.c
 create mode 100644 include/asm-mips/mach-ip28/cpu-feature-overrides.h
 create mode 100644 include/asm-mips/mach-ip28/ds1286.h
 create mode 100644 include/asm-mips/mach-ip28/spaces.h
 rename include/asm-mips/{mach-qemu/war.h => mach-ip28/war.h} (82%)
 delete mode 100644 include/asm-mips/mach-qemu/cpu-feature-overrides.h
 create mode 100644 include/asm-mips/smp-ops.h
