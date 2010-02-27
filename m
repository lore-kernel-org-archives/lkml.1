Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab0B0D5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 22:57:12 -0500
Received: from gate.crashing.org ([63.228.1.57]:37826 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab0B0D5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 22:57:11 -0500
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 14:56:54 +1100
Message-ID: <1267243014.23523.1837.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's your batch of powerpc stuff for 2.6.34. As you can see, it's
reasonably small this time around. There's a pile of scalability
improvements from Anton, a batch of raw_spinlock conversion from Thomas,
and a few more bits and pieces.

Cheers,
Ben.

The following changes since commit 6ebdc661b608671e9ca572af8bb42d58108cc008:
  Linus Torvalds (1):
        Merge branch 'next-devicetree' of git://git.secretlab.ca/git/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Amit Shah (1):
      hvc_console: Remove __devinit annotation from hvc_alloc

Anatolij Gustschin (10):
      powerpc/mpc5121: avoid using arch_initcall for clock init
      powerpc/mpc5121: Add machine restart support
      rtc: Add MPC5121 Real time clock driver
      powerpc/mpc5121: create and register NFC device
      powerpc/mpc5121: update mpc5121ads DTS
      powerpc/mpc5121: Add default config for MPC5121
      serial: mpc52xx_uart: re-enable mpc5121 PSC UART support
      powerpc: doc/dts-bindings: document mpc5121 psc uart dts-bindings
      powerpc/mpc5121: enable support for more PSC UARTs
      powerpc/mpc5121: correct DIU compatible property

Anton Blanchard (25):
      powerpc: Replace per_cpu(, smp_processor_id()) with __get_cpu_var()
      powerpc: Mark some variables in the page fault path __read_mostly
      powerpc: Increase NR_IRQS Kconfig maximum to 32768
      powerpc/pseries: Quieten cede latency printk
      powerpc: Reduce differences between pseries and ppc64 defconfigs
      powerpc: Add last sysfs file and dump of ftrace buffer to oops printout
      powerpc: Convert mmu context allocator from idr to ida
      powerpc: Reformat SD_NODE_INIT to match x86
      powerpc: Make powerpc_firmware_features __read_mostly
      powerpc: Clear MSR_RI during RTAS calls
      powerpc: Only print clockevent settings once
      powerpc: Reduce footprint of irq_stat
      powerpc: Reduce footprint of xics_ipi_struct
      powerpc: Rework /proc/interrupts
      powerpc: Remove whitespace in irq chip name fields
      powerpc: Add timer, performance monitor and machine check counts to /proc/interrupts
      powerpc: Convert global "BAD" interrupt to per cpu spurious
      powerpc: Use lwarx hint in spinlocks
      powerpc: Use lwarx/ldarx hint in bit locks
      powerpc: Convert open coded native hashtable bit lock
      powerpc: Rename LWSYNC_ON_SMP to PPC_RELEASE_BARRIER, ISYNC_ON_SMP to PPC_ACQUIRE_BARRIER
      powerpc: Fix lwsync patching code on 64bit
      powerpc: Use lwsync for acquire barrier if CPU supports it
      powerpc: Pair loads and stores in copy_4k_page
      powerpc: Improve 64bit copy_tofrom_user

Anton Vorontsov (1):
      powerpc/85xx: Add NOR, LEDs and PIB support for MPC8568E-MDS boards

Benjamin Herrenschmidt (6):
      powerpc/pseries: Pass more accurate number of supported cores to firmware
      Merge commit 'origin/master' into next
      Merge commit 'jwb/next' into next
      Merge commit 'gcl/next' into next
      Merge commit 'origin/master' into next
      powerpc: Fix lwsync feature fixup vs. modules on 64-bit

Breno Leitao (1):
      powerpc/eeh: Fix a bug when pci structure is null

Corey Minyard (1):
      powerpc: Add coherent_dma_mask to mv64x60 devices

Dave Kleikamp (4):
      powerpc/booke: Introduce new CONFIG options for advanced debug registers
      powerpc: Extended ptrace interface
      powerpc/booke: Add definitions for advanced debug registers
      powerpc/booke: Add support for advanced debug registers

Ernst Schwab (1):
      powerpc/of: added documentation for spi chipselects

Frans Pop (1):
      powerpc: Remove trailing space in messages

Jean Delvare (2):
      macintosh/therm_adt746x: Fix sysfs attributes lifetime
      macintosh/hwmon/ams: Fix device removal sequence

Joe Perches (2):
      powerpc/viodasd: Remove VIOD_KERN_<level> macros for printks
      arch/powerpc: Fix continuation line formats

Malcolm Crossley (3):
      powerpc/86xx: Fix GE SBC310 XMC site support
      powerpc/86xx: Add MSI section to GE SBC610 DTS
      powerpc/86xx: Add MSI section to GE PPC9A DTS

Martyn Welch (5):
      powerpc/86xx: Add MSI section to GE SBC310 DTS
      powerpc/86xx: Basic flash support for GE SBC610
      powerpc/86xx: Switch on highmem support on GE SBC610
      powerpc/86xx: Enable VME driver on the GE PPC9A
      powerpc/86xx: Enable VME driver on the GE SBC610

Michael Ellerman (1):
      lmb: Add lmb_free()

Peter Tyser (1):
      powerpc/85xx: Fix SMP when "cpu-release-addr" is in lowmem

Robert P. J. Day (1):
      powerpc: Simplify param.h by including <asm-generic/param.h>

Rusty Russell (1):
      hvc_console: Make the ops pointer const.

Sebastian Andrzej Siewior (1):
      powerpc/fsl-booke: replace a hardcoded constant

Stefan Roese (6):
      powerpc/44x: Fix L2-cache support for 460GT
      powerpc/44x: Add MTD support (NOR FLASH) to Katmai dts
      powerpc/44x: Update Arches dts
      powerpc/44x: Update Glacier dts
      powerpc/44x: Add MTD support to katmai defconfig
      powerpc/40x: Add support for PPC40x boards with > 512MB SDRAM

Thadeu Lima de Souza Cascardo (1):
      powerpc: Fix typo s/leve/level/ in TLB code

Thomas Gleixner (15):
      powerpc: Convert context_lock to raw_spinlock
      powerpc: Convert nv_lock to raw_spinlock
      powerpc: Convert beatic_irq_mask_lock to raw_spinlock
      powerpc: Convert native_tlbie_lock to raw_spinlock
      powerpc: Convert ipic_lock to raw_spinlock
      powerpc: Convert confirm_error_lock to raw_spinlock
      powerpc: Convert beat_htab_lock to raw_spinlock
      powerpc: Convert i8259_lock to raw_spinlock
      powerpc: Convert feature_lock to raw_spinlock
      powerpc: Convert big_irq_lock to raw_spinlock
      powerpc: Convert pmac_pic_lock to raw_spinlock
      powerpc: Convert mpic locks to raw_spinlock
      powerpc: Convert tlbivax_lock to raw_spinlock
      powerpc: Convert die.lock to raw_spinlock
      powerpc: Convert pmc_owner_lock to raw_spinlock

Will Schmidt (1):
      powerpc/pseries: Hypervisor call tracepoints hcall_stats touchup

jschopp@austin.ibm.com (1):
      powerpc: Add static fields to ibm,client-architecture call

 .../powerpc/dts-bindings/fsl/mpc5121-psc.txt       |   70 +
 Documentation/powerpc/dts-bindings/fsl/spi.txt     |    7 +
 Documentation/powerpc/ptrace.txt                   |  134 ++
 arch/powerpc/Kconfig                               |   29 +-
 arch/powerpc/boot/dts/arches.dts                   |   12 +
 arch/powerpc/boot/dts/gef_ppc9a.dts                |   16 +
 arch/powerpc/boot/dts/gef_sbc310.dts               |   19 +-
 arch/powerpc/boot/dts/gef_sbc610.dts               |   66 +-
 arch/powerpc/boot/dts/glacier.dts                  |   76 +-
 arch/powerpc/boot/dts/katmai.dts                   |   71 +-
 arch/powerpc/boot/dts/mpc5121ads.dts               |   55 +-
 arch/powerpc/boot/dts/mpc8568mds.dts               |   65 +-
 arch/powerpc/configs/44x/katmai_defconfig          |   94 +-
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      |   47 +-
 arch/powerpc/configs/86xx/gef_sbc610_defconfig     |   65 +-
 arch/powerpc/configs/mpc512x_defconfig             | 1694 ++++++++++++++++++++
 arch/powerpc/configs/ppc64_defconfig               |   75 +-
 arch/powerpc/configs/pseries_defconfig             |   63 +-
 arch/powerpc/include/asm/asm-compat.h              |    5 +-
 arch/powerpc/include/asm/atomic.h                  |   48 +-
 arch/powerpc/include/asm/bitops.h                  |   56 +-
 arch/powerpc/include/asm/cputable.h                |    4 +-
 arch/powerpc/include/asm/cputime.h                 |    7 +-
 arch/powerpc/include/asm/feature-fixups.h          |    2 +-
 arch/powerpc/include/asm/futex.h                   |    6 +-
 arch/powerpc/include/asm/hardirq.h                 |   30 +-
 arch/powerpc/include/asm/local.h                   |   12 +-
 arch/powerpc/include/asm/mpc5121.h                 |   24 +
 arch/powerpc/include/asm/mpc52xx_psc.h             |    4 +
 arch/powerpc/include/asm/mpic.h                    |    2 +-
 arch/powerpc/include/asm/mutex.h                   |    6 +-
 arch/powerpc/include/asm/param.h                   |   23 +-
 arch/powerpc/include/asm/pmac_feature.h            |    2 +-
 arch/powerpc/include/asm/ppc-opcode.h              |   18 +
 arch/powerpc/include/asm/ppc-pci.h                 |    5 +
 arch/powerpc/include/asm/processor.h               |   36 +-
 arch/powerpc/include/asm/ptrace.h                  |   77 +
 arch/powerpc/include/asm/reg_booke.h               |   96 ++-
 arch/powerpc/include/asm/spinlock.h                |   32 +-
 arch/powerpc/include/asm/synch.h                   |   12 +-
 arch/powerpc/include/asm/system.h                  |   21 +-
 arch/powerpc/include/asm/topology.h                |   48 +-
 arch/powerpc/kernel/entry_64.S                     |    3 +-
 arch/powerpc/kernel/firmware.c                     |    2 +-
 arch/powerpc/kernel/head_fsl_booke.S               |    4 +-
 arch/powerpc/kernel/irq.c                          |  140 ++-
 arch/powerpc/kernel/kgdb.c                         |    2 +-
 arch/powerpc/kernel/kprobes.c                      |    4 +-
 arch/powerpc/kernel/lparcfg.c                      |   10 +-
 arch/powerpc/kernel/nvram_64.c                     |    6 +-
 arch/powerpc/kernel/pci_of_scan.c                  |    2 +-
 arch/powerpc/kernel/pmc.c                          |   10 +-
 arch/powerpc/kernel/process.c                      |  116 ++-
 arch/powerpc/kernel/prom_init.c                    |   81 +-
 arch/powerpc/kernel/ptrace.c                       |  516 ++++++-
 arch/powerpc/kernel/signal.c                       |    6 +-
 arch/powerpc/kernel/signal_32.c                    |   16 +-
 arch/powerpc/kernel/time.c                         |   10 +-
 arch/powerpc/kernel/traps.c                        |  128 ++-
 arch/powerpc/lib/copypage_64.S                     |   28 +-
 arch/powerpc/lib/copyuser_64.S                     |   80 +-
 arch/powerpc/lib/feature-fixups.c                  |    3 +-
 arch/powerpc/mm/40x_mmu.c                          |    4 +-
 arch/powerpc/mm/hash_native_64.c                   |   19 +-
 arch/powerpc/mm/mmu_context_hash64.c               |   10 +-
 arch/powerpc/mm/mmu_context_nohash.c               |   14 +-
 arch/powerpc/mm/tlb_low_64e.S                      |    2 +-
 arch/powerpc/mm/tlb_nohash.c                       |    6 +-
 arch/powerpc/platforms/512x/clock.c                |    6 +-
 arch/powerpc/platforms/512x/mpc5121_ads.c          |    3 +-
 arch/powerpc/platforms/512x/mpc5121_ads_cpld.c     |    2 +-
 arch/powerpc/platforms/512x/mpc5121_generic.c      |    3 +-
 arch/powerpc/platforms/512x/mpc512x.h              |    3 +
 arch/powerpc/platforms/512x/mpc512x_shared.c       |   43 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    3 +
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |    2 +-
 arch/powerpc/platforms/85xx/stx_gp3.c              |    2 +-
 arch/powerpc/platforms/cell/beat_htab.c            |   24 +-
 arch/powerpc/platforms/cell/beat_interrupt.c       |   20 +-
 arch/powerpc/platforms/cell/interrupt.c            |    4 +-
 arch/powerpc/platforms/cell/spider-pic.c           |    2 +-
 arch/powerpc/platforms/iseries/irq.c               |    2 +-
 arch/powerpc/platforms/iseries/proc.c              |    2 +-
 arch/powerpc/platforms/iseries/setup.c             |    2 +-
 arch/powerpc/platforms/powermac/bootx_init.c       |    4 +-
 arch/powerpc/platforms/powermac/feature.c          |    6 +-
 arch/powerpc/platforms/powermac/nvram.c            |   14 +-
 arch/powerpc/platforms/powermac/pfunc_base.c       |   24 +-
 arch/powerpc/platforms/powermac/pic.c              |   40 +-
 arch/powerpc/platforms/pseries/eeh.c               |   18 +-
 arch/powerpc/platforms/pseries/eeh_driver.c        |   10 +-
 arch/powerpc/platforms/pseries/eeh_event.c         |    2 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   22 +-
 arch/powerpc/platforms/pseries/hvCall_inst.c       |    4 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    2 +-
 arch/powerpc/platforms/pseries/phyp_dump.c         |    6 +-
 arch/powerpc/platforms/pseries/smp.c               |    4 +-
 arch/powerpc/platforms/pseries/xics.c              |   32 +-
 arch/powerpc/sysdev/cpm1.c                         |    2 +-
 arch/powerpc/sysdev/cpm2_pic.c                     |    2 +-
 arch/powerpc/sysdev/fsl_msi.c                      |    2 +-
 arch/powerpc/sysdev/i8259.c                        |   24 +-
 arch/powerpc/sysdev/ipic.c                         |   22 +-
 arch/powerpc/sysdev/mpc8xx_pic.c                   |    2 +-
 arch/powerpc/sysdev/mpic.c                         |   40 +-
 arch/powerpc/sysdev/mpic_pasemi_msi.c              |    2 +-
 arch/powerpc/sysdev/mv64x60_dev.c                  |    3 +
 arch/powerpc/sysdev/ppc4xx_soc.c                   |    3 +-
 arch/powerpc/sysdev/qe_lib/qe_ic.c                 |    4 +-
 arch/powerpc/sysdev/qe_lib/qe_io.c                 |    8 +-
 arch/powerpc/sysdev/uic.c                          |    2 +-
 arch/powerpc/xmon/xmon.c                           |    2 +-
 drivers/block/viodasd.c                            |   86 +-
 drivers/char/hvc_console.c                         |    6 +-
 drivers/char/hvc_console.h                         |    4 +-
 drivers/hwmon/ams/ams-core.c                       |   11 +-
 drivers/hwmon/ams/ams-i2c.c                        |    2 +
 drivers/hwmon/ams/ams-pmu.c                        |    2 +
 drivers/hwmon/ams/ams.h                            |    1 +
 drivers/macintosh/therm_adt746x.c                  |   36 +-
 drivers/ps3/ps3av.c                                |    2 +-
 drivers/rtc/Kconfig                                |   10 +
 drivers/rtc/Makefile                               |    1 +
 drivers/rtc/rtc-mpc5121.c                          |  387 +++++
 drivers/serial/mpc52xx_uart.c                      |  251 +++-
 drivers/video/fsl-diu-fb.c                         |    5 +
 include/linux/lmb.h                                |    1 +
 lib/lmb.c                                          |   13 +-
 128 files changed, 4900 insertions(+), 803 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/mpc5121-psc.txt
 create mode 100644 Documentation/powerpc/ptrace.txt
 create mode 100644 arch/powerpc/configs/mpc512x_defconfig
 create mode 100644 arch/powerpc/include/asm/mpc5121.h
 create mode 100644 drivers/rtc/rtc-mpc5121.c


