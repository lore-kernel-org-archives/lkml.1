Return-Path: <linux-kernel-owner+w=401wt.eu-S935556AbYBHRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556AbYBHRRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 12:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934512AbYBHQ7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 11:59:42 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:60219 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934486AbYBHQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 11:59:36 -0500
Date: Fri, 8 Feb 2008 17:59:12 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: mikael.starvik@axis.com, jesper.nilsson@axis.com
Subject: [GIT PULL] CRIS architecture
Message-ID: <20080208165912.GC11007@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a4ffc0a0b240a29cbe489f6db9dae112a49ef1c1:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../agk/linux-2.6-dm

are available in the git repository at:

  git://www.jni.nu/cris.git cris


This contains changes for the CRIS v10 and v32 architectures,
(CPUs ETRAX-100LX, ETRAX FS and ARTPEC-3), which brings them up
to the same state as the Axis internal tree.

Two changes reach outside the CRIS specific directories,
one which changes the names of LED defines in the CRIS v10 ethernet driver,
and one which adds my information to the MAINTAINERS entry for the CRIS port.
All others are restricted to the include/asm-cris and arch/cris directories.


Missing are serial, ethernet and some other drivers for CRIS v32,
which will be submitted through the subsystem maintainers.

Thanks,

/^Jesper Nilsson

---

Jesper Nilsson (158):
      CRIS: Rearrange Kconfigs for v10 and v32 to allow compilation without warnings.
      CRIS v32: Add new driver files for Artpec-3.
      CRIS v32: Add new driver files for Etrax-FS
      CRIS v32: Add new machine dependent files for Etrax-FS and Artpec-3.
      CRIS v32: Add hardware dependent include files and defconfigs for ETRAX FS and ARTPEC-3 chips.
      CRIS v32: Add L2 cache initialization code.
      CRIS v32: Add SECOND_WORD_SYNC, used in sync_serial.
      CRIS v32: Update synchronous serial driver.
      CRIS: Merge axisflashmap.h with Axis internal changes.
      CRIS v32: Update asm-cris/arch-v32/irq.h for ETRAX FS and ARTPEC-3
      CRIS: Remove unnecessary CVS log from cris/mm/init.c
      CRIS v32: Add prototypes for cache flushing
      CRIS v32: Add headers for EtraxFS and Artpec-3 chips.
      CRIS: Minor fixes to mm/fault.c
      CRIS: Minor generic kernel/traps.c changes.
      CRIS v32: Whitespace and formatting changes for kernel/ptrace.c
      CRIS: Remove define ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY
      CRIS v32: Update entry.S to working order.
      CRIS v32: Fixup kernel Makefile.
      CRIS v32: New version of I2C driver.
      CRIS v32: Update and improve axisflashmap
      CRIS: Update main Kbuild makefile.
      CRIS v10: Update boot Kbuild makefile.
      CRIS v10: Update boot/compressed Kbuild makefile.
      CRIS v10: Update rescue Kbuild makefile.
      CRIS v10: Update rescue head.s
      CRIS v10: Update and improve axisflashmap.c
      CRIS v32: Update traps.c
      CRIS v32: Update boot Kbuild makefile.
      CRIS v32: Update boot compressed Kbuild makefile.
      CRIS v32: Update boot rescue Kbuild makefile.
      CRIS v32: Remove common gpio and nandflash, add mach-fs and mach-a3 as subdirs.
      CRIS v32: Update compressed head.S
      CRIS v32: Update boot/compressed/misc.c
      CRIS v32: Update boot/rescue/head.S code.
      CRIS v32: Update debugport.
      CRIS v32: Include path fix for timex.h
      CRIS v32: Update and improve fasttimer.c
      CRIS v32: Update kernel/head.S
      CRIS v32: Update and simplify kernel/irq.c.
      CRIS v32: Minor updates to kernel/process.c
      CRIS v32: Update and improve kernel/traps.c
      CRIS v32: Minor fixes for io.h
      CRIS v10: New default config.
      CRIS v32: Update and improve kernel/time.c
      CRIS: Add architecture dependent bug.h for CRIS v10 and CRIS v32
      CRIS v10: Update boot/compressed/Makefile to use ccflags-y and ldflags-y
      CRIS v10: Change boot/rescue/Makefile to use ccflags-y, asflags-y and ldflags-y.
      CRIS v10: Correct and cleanup boot/rescue/kimagerescue.S
      CRIS v10: Correct and cleanup boot/rescue/testrescue.S
      CRIS v10: Cleanup drivers/eeprom.c to avoid import conflicts.
      CRIS v10: Fix bugs in i2c_init and i2c_readreg
      CRIS v10: Update driver for pcf8563
      CRIS v10: Cleanup rtc.h
      CRIS v10: Update and fix bug in kernel/debugport.
      CRIS v10: Remove CVS tag from boot/compressed/misc.c
      CRIS v10: Break long lines in boot/rescue/head.S
      CRIS v10: Remove CVS id tag from kernel/dma.c
      CRIS v10: Cleanup kernel/entry.S CVS log and id.
      CRIS v10: Cleanup kernel/fasttimer.c
      CRIS v10: Cleanup kernel/irq.c
      CRIS v10: Remove CVS log and id from kernel/kgdb.c
      CRIS v10: Remove CVS id from kernel/process.c
      CRIS: Remove NO_IOMEM config, we have IO memory.
      CRIS: Move common Kconfig variable ETRAX_RTC to arch independet Kconfig.
      CRIS v10: Reformat drivers/makefile using tabs.
      CRIS v10: Remove useless CVS id from kernel/shadows.c
      CRIS v10: Remove useless CVS id and log from lib/dram_init.S
      CRIS v10: Remove useless CVS id tag from lib/old_checksum.c
      CRIS v10: Fix bug where error returns didn't restore irqs in mm/fault.c
      CRIS v10: Don't call get_mmu_context when switching between tasks with shared memory descriptors
      CRIS v10: Add synchronous serial port driver for CRIS v10.
      CRIS v10: Setup serial port 2 to avoid accidental TXD pulse on startup.
      CRIS v10: Update kernel/io_interface_mux.c
      CRIS v10: Clear TIF_SYSCALL_TRACE flag in ptrace_disable in kernel/ptrace.c
      CRIS v10: Remove duplicated folding of carry from lib/checksumcopy.S, it is not needed.
      CRIS v10: Remove duplicated folding of carry from lib/checksum.S, it is not needed.
      CRIS: Update cpu_possible_map and raw_smp_processor_id in smp.h header.
      CRIS: Correct comment in io.h to describe reality of I/O space.
      CRIS: Correct pfn_pte to make it possible to ioremap uncached addresses.
      CRIS: Include arch dependent bug.h.
      CRIS: Allow arch dependent delay to override common version.
      CRIS: Fix bugs in return value of atomic_inc_return and atomic_dec_return.
      CRIS v32: Remove useless CVS id tag from boot/compressed/README
      CRIS v10: Change name of low voltage read and set macros.
      CRIS v32: Replace build flags in boot/compressed/Makefile
      CRIS v32: Replace build flags in boot/rescue/Makefile
      CRIS v32: Rewrite of stream co-processor driver for ETRAX FS and ARTPEC-3
      CRIS v32: Change include path for hwregs in drivers/iop_fw_load.c
      CRIS v32: Change name of LED macros in drivers/mach-a3/gpio.c to avoid collision.
      CRIS v32: ETRAX FS Change name of LED macros in drivers/mach-fs/gpio.c to avoid collision.
      CRIS v32: Remove drivers/nandflash.h, now exists as machine specific file.
      CRIS v32: Update driver for RTC chip pcf8563.
      CRIS v32: Remove drivers/gpio.c, now exists as machine specific file.
      CRIS v32: Remove config ifdef around init function for drivers/sync_serial.c
      CRIS v32: Update kernel/crisksyms.c
      CRIS v32: Change debug and formatting in kernel/fasttimer.c
      CRIS v32: Change names of config variable and register field for data available.
      CRIS: Add support for ETRAX FS and ARTPEC-3 to etraxgpio.h
      CRIS v10: Update drivers/gpio.c, fix locking and general improvements.
      CRIS v32: Update boot/rescue/rescue.ld
      CRIS v32: Update signal handling in kernel/signal.c
      CRIS v32: Update kernel/smp.c for CRIS v32.
      CRIS v32: Move vcs_hook to machine specific directory.
      CRIS v32: Update vcs_hook.c for ETRAX FS.
      CRIS v32: Add precise delay loops for ETRAX FS and ARTPEC-3.
      CRIS v32: Add lib/delay to build.
      CRIS v32: Update lib/checksum.S and lib/checksumcopy.S
      CRIS v32: Move hw_settings.S to machine specific directories for ETRAX FS and ARTPEC-3
      CRIS v32: Change lib/spinlock.S to use byte operations instead of dwords.
      CRIS v32: Change name of simulator config to CONFIG_ETRAX_VCS_SIM in mm/init.c
      CRIS v32: Fix bug in internal memory allocator mm/intmem.c
      CRIS v32: Add workaround for MMU hardware bug for ETRAX FS in mm/mmu.S
      CRIS v32: Avoid work when switching between tasks with shared memory descriptors in mm/tlb.c
      CRIS v32: Fix startup oops and replace hardcoded pagesize in vmlinux.lds.S
      CRIS: Remove CONFIG_NO_IOMEM from default configs.
      CRIS: Add configuration possibility for using kmalloc for modules.
      CRIS: Remove useless CVS id and log from kernel/process.c
      CRIS: Remove useless CVS log from kernel/ptrace.c
      CRIS: Remove CONFIG_NO_IOMEM from ARTPEC-3 default config.
      CRIS: Remove include of linux/init.h, not needed anymore.
      CRIS: Register cpus in kernel/setup.c
      CRIS: Add sched_clock to kernel/time.c
      CRIS: Add missing headers to include/asm-cris Kbuild files.
      CRIS: Rename LED macros to CRIS_LED to avoid name clash in io.h
      CRIS: Break long comment line in include/asm-cris/arch-v10/page.h
      CRIS v32: Add missing header to include/asm-cris/arch-v32/Kbuild
      CRIS v32: Adjust arch-v32/atomic.h for new spinlock/rwlock infrastructure
      CRIS v32: Add defines for udelay and ndelay in arch-v32/delay.h
      CRIS v32: Remove useless CVS id tag from arch-v32/hwregs/Makefile
      CRIS v32: Rename variable used in macro for arch-v32/hwregs/dma.h
      CRIS v32: Add support for ETRAX FS and ARTPEC-3 for arch-v32/hwregs/eth_defs.h
      CRIS v32: Remove juliette.h, it is not supported for CRIS v32.
      CRIS v32: Change name for simulator config in asm-cris/arch-v32/page.h
      CRIS v32: Add prototype for crisv32_pinmux_dealloc_fixed in asm-cris/arch-v32/pinmux.h
      CRIS v32: Change name for simulator config in asm-cris/arch-v32/processor.h
      CRIS v32: Completely rework spinlocks for ETRAX FS and ARTPEC-3
      CRIS v32: Remove SMP stub from asm-cris/arch-v32/system.h
      CRIS v32: Let compiler know that memory is clobbered after a break op.
      CRIS v32: Move register map header to machine dependent directory.
      CRIS v32: Correct offset for TASK_pid in asm-cris/arch-v32/offset.h
      CRIS v32: arch-v32/hwregs/intr_vect_defs.h moved to machine dependent directory.
      CRIS v32: Minor changes to avoid errors in asm-cris/arch-v32/hwregs/reg_rdwr.h
      CRIS v32: Remove kernel/arbiter.c, it now exists in machine dependent directory.
      CRIS v32: Initialize GIO even if we're rambooting in kernel/head.S
      CRIS v32: Fix minor formatting issue in mach-a3/io.c
      CRIS: Drop regs parameter from call to profile_tick in kernel/time.c
      CRIS: Move ETRAX_AXISFLASHMAP to common Kconfig file.
      CRIS: Make io_pwm_set_period members unsigned in etraxgpio.h
      CRIS v10: drivers/net/cris/eth_v10.c rename LED defines to CRIS_LED to avoid name clash.
      CRIS v10: Cleanup of drivers/gpio.c
      CRIS v32: Clean up nandflash.c for ARTPEC-3 and ETRAX FS.
      CRIS v32: Correct spelling of bandwidth in function name.
      MAINTAINERS: Add my information for the CRIS port.
      CRIS: Add new timerfd syscall entries.
      CRIS v32: Rewrite ARTPEC-3 gpio driver to avoid volatiles and general cleanup.
      CRIS v32: Change drivers/i2c.c locking.
      CRIS v32: Remove hwregs/timer_defs.h, it is now architecture specific.

 MAINTAINERS                                        |    2 +
 arch/cris/Kconfig                                  |  538 +++++++-
 arch/cris/Makefile                                 |  139 +-
 arch/cris/arch-v10/Kconfig                         |   67 +-
 arch/cris/arch-v10/boot/Makefile                   |   24 +-
 arch/cris/arch-v10/boot/compressed/Makefile        |   48 +-
 arch/cris/arch-v10/boot/compressed/misc.c          |    6 +-
 arch/cris/arch-v10/boot/rescue/Makefile            |   56 +-
 arch/cris/arch-v10/boot/rescue/head.S              |  129 +-
 arch/cris/arch-v10/boot/rescue/kimagerescue.S      |   58 +-
 arch/cris/arch-v10/boot/rescue/testrescue.S        |   12 +-
 arch/cris/arch-v10/drivers/Kconfig                 |  181 ---
 arch/cris/arch-v10/drivers/Makefile                |   12 +-
 arch/cris/arch-v10/drivers/axisflashmap.c          |  181 +--
 arch/cris/arch-v10/drivers/ds1302.c                |    4 +-
 arch/cris/arch-v10/drivers/eeprom.c                |   75 +-
 arch/cris/arch-v10/drivers/gpio.c                  |  634 ++++------
 arch/cris/arch-v10/drivers/i2c.c                   |   81 +--
 arch/cris/arch-v10/drivers/pcf8563.c               |  393 +++---
 arch/cris/arch-v10/drivers/sync_serial.c           | 1441 ++++++++++++++++++++
 arch/cris/arch-v10/kernel/debugport.c              |  134 +--
 arch/cris/arch-v10/kernel/dma.c                    |    3 +-
 arch/cris/arch-v10/kernel/entry.S                  |  249 +----
 arch/cris/arch-v10/kernel/fasttimer.c              |   35 +-
 arch/cris/arch-v10/kernel/head.S                   |  221 +---
 arch/cris/arch-v10/kernel/io_interface_mux.c       |  515 ++++++--
 arch/cris/arch-v10/kernel/irq.c                    |    7 +-
 arch/cris/arch-v10/kernel/kgdb.c                   |   58 -
 arch/cris/arch-v10/kernel/process.c                |    3 +-
 arch/cris/arch-v10/kernel/ptrace.c                 |    1 +
 arch/cris/arch-v10/kernel/shadows.c                |    3 +-
 arch/cris/arch-v10/kernel/traps.c                  |  198 ++--
 arch/cris/arch-v10/lib/checksum.S                  |    8 +-
 arch/cris/arch-v10/lib/checksumcopy.S              |    8 +-
 arch/cris/arch-v10/lib/dram_init.S                 |   58 +-
 arch/cris/arch-v10/lib/old_checksum.c              |    3 +-
 arch/cris/arch-v10/mm/fault.c                      |   13 +-
 arch/cris/arch-v10/mm/tlb.c                        |   58 +-
 arch/cris/arch-v32/Kconfig                         |  127 +-
 arch/cris/arch-v32/boot/Makefile                   |   23 +-
 arch/cris/arch-v32/boot/compressed/Makefile        |   45 +-
 arch/cris/arch-v32/boot/compressed/README          |    1 -
 arch/cris/arch-v32/boot/compressed/head.S          |  137 +--
 arch/cris/arch-v32/boot/compressed/misc.c          |   72 +-
 arch/cris/arch-v32/boot/rescue/Makefile            |   41 +-
 arch/cris/arch-v32/boot/rescue/head.S              |   42 +-
 arch/cris/arch-v32/boot/rescue/rescue.ld           |   37 +-
 arch/cris/arch-v32/drivers/Kconfig                 |  711 +++++++----
 arch/cris/arch-v32/drivers/Makefile                |    5 +-
 arch/cris/arch-v32/drivers/axisflashmap.c          |  488 +++++--
 arch/cris/arch-v32/drivers/cryptocop.c             |  104 +-
 arch/cris/arch-v32/drivers/i2c.c                   |  206 +++-
 arch/cris/arch-v32/drivers/i2c.h                   |    2 +
 arch/cris/arch-v32/drivers/iop_fw_load.c           |   16 +-
 arch/cris/arch-v32/drivers/mach-a3/Makefile        |    6 +
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |  984 +++++++++++++
 arch/cris/arch-v32/drivers/mach-a3/nandflash.c     |  180 +++
 arch/cris/arch-v32/drivers/mach-fs/Makefile        |    6 +
 arch/cris/arch-v32/drivers/{ => mach-fs}/gpio.c    |  612 ++++++---
 .../arch-v32/drivers/{ => mach-fs}/nandflash.c     |  122 +-
 arch/cris/arch-v32/drivers/pcf8563.c               |  296 +++--
 arch/cris/arch-v32/drivers/sync_serial.c           |  938 ++++++++-----
 arch/cris/arch-v32/kernel/Makefile                 |    5 +-
 arch/cris/arch-v32/kernel/arbiter.c                |  296 ----
 arch/cris/arch-v32/kernel/crisksyms.c              |    7 +-
 arch/cris/arch-v32/kernel/debugport.c              |  342 +----
 arch/cris/arch-v32/kernel/entry.S                  |   83 +-
 arch/cris/arch-v32/kernel/fasttimer.c              |  535 +++-----
 arch/cris/arch-v32/kernel/head.S                   |  204 ++--
 arch/cris/arch-v32/kernel/io.c                     |  153 ---
 arch/cris/arch-v32/kernel/irq.c                    |  274 +++--
 arch/cris/arch-v32/kernel/kgdb.c                   |   12 +-
 arch/cris/arch-v32/kernel/process.c                |   14 +-
 arch/cris/arch-v32/kernel/ptrace.c                 |   10 +-
 arch/cris/arch-v32/kernel/signal.c                 |  144 +--
 arch/cris/arch-v32/kernel/smp.c                    |   31 +-
 arch/cris/arch-v32/kernel/time.c                   |  237 ++--
 arch/cris/arch-v32/kernel/traps.c                  |  192 ++--
 arch/cris/arch-v32/kernel/vcs_hook.c               |   96 --
 arch/cris/arch-v32/lib/Makefile                    |    3 +-
 arch/cris/arch-v32/lib/checksum.S                  |   72 +-
 arch/cris/arch-v32/lib/checksumcopy.S              |   69 +-
 arch/cris/arch-v32/lib/delay.c                     |   28 +
 arch/cris/arch-v32/lib/spinlock.S                  |   10 +-
 arch/cris/arch-v32/mach-a3/Kconfig                 |  110 ++
 arch/cris/arch-v32/mach-a3/Makefile                |   11 +
 arch/cris/arch-v32/mach-a3/arbiter.c               |  634 +++++++++
 arch/cris/arch-v32/mach-a3/cpufreq.c               |  153 +++
 arch/cris/arch-v32/mach-a3/dma.c                   |  185 +++
 arch/cris/arch-v32/mach-a3/dram_init.S             |  104 ++
 arch/cris/arch-v32/mach-a3/hw_settings.S           |   51 +
 arch/cris/arch-v32/mach-a3/io.c                    |  149 ++
 arch/cris/arch-v32/mach-a3/pinmux.c                |  386 ++++++
 arch/cris/arch-v32/mach-a3/vcs_hook.c              |  103 ++
 arch/cris/arch-v32/mach-a3/vcs_hook.h              |   58 +
 arch/cris/arch-v32/mach-fs/Kconfig                 |  216 +++
 arch/cris/arch-v32/mach-fs/Makefile                |   11 +
 arch/cris/arch-v32/mach-fs/arbiter.c               |  404 ++++++
 arch/cris/arch-v32/mach-fs/cpufreq.c               |  146 ++
 arch/cris/arch-v32/{kernel => mach-fs}/dma.c       |   46 +-
 arch/cris/arch-v32/{lib => mach-fs}/dram_init.S    |   23 +-
 arch/cris/arch-v32/{lib => mach-fs}/hw_settings.S  |   12 +-
 arch/cris/arch-v32/mach-fs/io.c                    |  191 +++
 arch/cris/arch-v32/mach-fs/pinmux.c                |  309 +++++
 arch/cris/arch-v32/mach-fs/vcs_hook.c              |  100 ++
 arch/cris/arch-v32/{kernel => mach-fs}/vcs_hook.h  |    8 +-
 arch/cris/arch-v32/mm/Makefile                     |    3 +-
 arch/cris/arch-v32/mm/init.c                       |    8 +-
 arch/cris/arch-v32/mm/intmem.c                     |   48 +-
 arch/cris/arch-v32/mm/l2cache.c                    |   29 +
 arch/cris/arch-v32/mm/mmu.S                        |   93 ++-
 arch/cris/arch-v32/mm/tlb.c                        |   56 +-
 arch/cris/arch-v32/vmlinux.lds.S                   |   74 +-
 arch/cris/artpec_3_defconfig                       |  582 ++++++++
 arch/cris/defconfig                                |  795 ++++-------
 arch/cris/etraxfs_defconfig                        |  585 ++++++++
 arch/cris/kernel/module.c                          |   14 +-
 arch/cris/kernel/process.c                         |  103 +--
 arch/cris/kernel/ptrace.c                          |   58 +-
 arch/cris/kernel/semaphore.c                       |    1 -
 arch/cris/kernel/setup.c                           |   29 +-
 arch/cris/kernel/time.c                            |   13 +-
 arch/cris/kernel/traps.c                           |  226 ++--
 arch/cris/mm/fault.c                               |  169 +--
 arch/cris/mm/init.c                                |  111 --
 drivers/net/cris/eth_v10.c                         |  225 +---
 include/asm-cris/Kbuild                            |    8 +-
 include/asm-cris/arch-v10/Kbuild                   |    3 +
 include/asm-cris/arch-v10/bug.h                    |   66 +
 include/asm-cris/arch-v10/io.h                     |  100 +-
 include/asm-cris/arch-v10/page.h                   |    4 +-
 include/asm-cris/arch-v32/Kbuild                   |    1 +
 include/asm-cris/arch-v32/atomic.h                 |   10 +-
 include/asm-cris/arch-v32/bug.h                    |   33 +
 include/asm-cris/arch-v32/cache.h                  |   11 +
 include/asm-cris/arch-v32/delay.h                  |   10 +
 include/asm-cris/arch-v32/hwregs/Makefile          |    1 -
 include/asm-cris/arch-v32/hwregs/dma.h             |   13 +-
 include/asm-cris/arch-v32/hwregs/eth_defs.h        |  202 ++--
 include/asm-cris/arch-v32/hwregs/reg_rdwr.h        |   10 +-
 include/asm-cris/arch-v32/io.h                     |   95 +-
 include/asm-cris/arch-v32/irq.h                    |   15 +-
 include/asm-cris/arch-v32/juliette.h               |  326 -----
 include/asm-cris/arch-v32/mach-a3/arbiter.h        |   34 +
 include/asm-cris/arch-v32/mach-a3/dma.h            |   31 +
 .../arch-v32/mach-a3/hwregs/asm/clkgen_defs_asm.h  |  164 +++
 .../arch-v32/mach-a3/hwregs/asm/ddr2_defs_asm.h    |  266 ++++
 .../arch-v32/mach-a3/hwregs/asm/gio_defs_asm.h     |  849 ++++++++++++
 .../arch-v32/mach-a3/hwregs/asm/pinmux_defs_asm.h  |  572 ++++++++
 .../arch-v32/mach-a3/hwregs/asm/pio_defs_asm.h     |  337 +++++
 .../arch-v32/mach-a3/hwregs/asm/reg_map_asm.h      |   99 ++
 .../arch-v32/mach-a3/hwregs/asm/timer_defs_asm.h   |  228 +++
 .../asm-cris/arch-v32/mach-a3/hwregs/clkgen_defs.h |  159 +++
 .../asm-cris/arch-v32/mach-a3/hwregs/ddr2_defs.h   |  281 ++++
 .../asm-cris/arch-v32/mach-a3/hwregs/gio_defs.h    |  837 ++++++++++++
 .../asm-cris/arch-v32/mach-a3/hwregs/intr_vect.h   |   46 +
 .../arch-v32/mach-a3/hwregs/intr_vect_defs.h       |  341 +++++
 .../mach-a3/hwregs/iop/asm/iop_reg_space_asm.h     |   31 +
 .../mach-a3/hwregs/iop/asm/iop_sap_in_defs_asm.h   |  109 ++
 .../mach-a3/hwregs/iop/asm/iop_sap_out_defs_asm.h  |  276 ++++
 .../mach-a3/hwregs/iop/asm/iop_sw_cfg_defs_asm.h   |  739 ++++++++++
 .../mach-a3/hwregs/iop/asm/iop_sw_cpu_defs_asm.h   |  950 +++++++++++++
 .../mach-a3/hwregs/iop/asm/iop_sw_mpu_defs_asm.h   | 1086 +++++++++++++++
 .../mach-a3/hwregs/iop/asm/iop_sw_spu_defs_asm.h   |  523 +++++++
 .../mach-a3/hwregs/iop/asm/iop_version_defs_asm.h  |   61 +
 .../arch-v32/mach-a3/hwregs/iop/iop_reg_space.h    |   31 +
 .../arch-v32/mach-a3/hwregs/iop/iop_sap_in_defs.h  |  141 ++
 .../arch-v32/mach-a3/hwregs/iop/iop_sap_out_defs.h |  231 ++++
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_cfg_defs.h  |  725 ++++++++++
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_cpu_defs.h  |  522 +++++++
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_mpu_defs.h  |  648 +++++++++
 .../arch-v32/mach-a3/hwregs/iop/iop_sw_spu_defs.h  |  441 ++++++
 .../arch-v32/mach-a3/hwregs/iop/iop_version_defs.h |   96 ++
 .../arch-v32/mach-a3/hwregs/l2cache_defs.h         |  142 ++
 .../arch-v32/mach-a3/hwregs/marb_bar_defs.h        |  482 +++++++
 .../arch-v32/mach-a3/hwregs/marb_foo_defs.h        |  626 +++++++++
 .../asm-cris/arch-v32/mach-a3/hwregs/pinmux_defs.h |  312 +++++
 .../asm-cris/arch-v32/mach-a3/hwregs/pio_defs.h    |  371 +++++
 include/asm-cris/arch-v32/mach-a3/hwregs/reg_map.h |  103 ++
 .../asm-cris/arch-v32/mach-a3/hwregs/strmux_defs.h |  120 ++
 .../arch-v32/{ => mach-a3}/hwregs/timer_defs.h     |   11 +-
 include/asm-cris/arch-v32/mach-a3/memmap.h         |   10 +
 include/asm-cris/arch-v32/mach-a3/pinmux.h         |   45 +
 include/asm-cris/arch-v32/mach-a3/startup.inc      |   60 +
 include/asm-cris/arch-v32/mach-fs/arbiter.h        |   28 +
 .../mach-fs/hwregs/asm/bif_core_defs_asm.h         |  319 +++++
 .../arch-v32/mach-fs/hwregs/asm/config_defs_asm.h  |  131 ++
 .../arch-v32/mach-fs/hwregs/asm/gio_defs_asm.h     |  276 ++++
 .../arch-v32/mach-fs/hwregs/asm/pinmux_defs_asm.h  |  632 +++++++++
 .../arch-v32/mach-fs/hwregs/asm/reg_map_asm.h      |   96 ++
 .../arch-v32/mach-fs/hwregs/asm/timer_defs_asm.h   |  229 ++++
 .../arch-v32/mach-fs/hwregs/bif_core_defs.h        |  284 ++++
 .../arch-v32/mach-fs/hwregs/bif_dma_defs.h         |  473 +++++++
 .../arch-v32/mach-fs/hwregs/bif_slave_defs.h       |  249 ++++
 .../asm-cris/arch-v32/mach-fs/hwregs/config_defs.h |  142 ++
 .../asm-cris/arch-v32/mach-fs/hwregs/gio_defs.h    |  295 ++++
 .../asm-cris/arch-v32/mach-fs/hwregs/intr_vect.h   |   41 +
 .../arch-v32/{ => mach-fs}/hwregs/intr_vect_defs.h |   13 +-
 .../arch-v32/mach-fs/hwregs/marb_bp_defs.h         |  205 +++
 .../asm-cris/arch-v32/mach-fs/hwregs/marb_defs.h   |  475 +++++++
 .../asm-cris/arch-v32/mach-fs/hwregs/pinmux_defs.h |  357 +++++
 .../arch-v32/{ => mach-fs}/hwregs/reg_map.h        |   11 +-
 .../asm-cris/arch-v32/mach-fs/hwregs/strmux_defs.h |  127 ++
 .../arch-v32/{ => mach-fs}/hwregs/timer_defs.h     |    6 +-
 include/asm-cris/arch-v32/mach-fs/pinmux.h         |   38 +
 include/asm-cris/arch-v32/mach-fs/startup.inc      |   77 ++
 include/asm-cris/arch-v32/offset.h                 |    2 +-
 include/asm-cris/arch-v32/page.h                   |    4 +-
 include/asm-cris/arch-v32/pinmux.h                 |    1 +
 include/asm-cris/arch-v32/processor.h              |    2 +-
 include/asm-cris/arch-v32/spinlock.h               |  172 +--
 include/asm-cris/arch-v32/system.h                 |    9 -
 include/asm-cris/arch-v32/timex.h                  |    8 +-
 include/asm-cris/arch-v32/unistd.h                 |   21 +-
 include/asm-cris/atomic.h                          |    4 +-
 include/asm-cris/axisflashmap.h                    |   39 +-
 include/asm-cris/bug.h                             |    2 +-
 include/asm-cris/delay.h                           |    3 +
 include/asm-cris/dma-mapping.h                     |   11 -
 include/asm-cris/etraxgpio.h                       |  112 ++-
 include/asm-cris/io.h                              |    4 +-
 include/asm-cris/pgtable.h                         |    2 +-
 include/asm-cris/rtc.h                             |   41 +-
 include/asm-cris/smp.h                             |    4 +-
 include/asm-cris/sync_serial.h                     |    1 +
 include/asm-cris/unistd.h                          |    4 +-
 226 files changed, 31579 insertions(+), 7721 deletions(-)
 create mode 100644 arch/cris/arch-v10/drivers/sync_serial.c
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/Makefile
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/gpio.c
 create mode 100644 arch/cris/arch-v32/drivers/mach-a3/nandflash.c
 create mode 100644 arch/cris/arch-v32/drivers/mach-fs/Makefile
 rename arch/cris/arch-v32/drivers/{ => mach-fs}/gpio.c (52%)
 rename arch/cris/arch-v32/drivers/{ => mach-fs}/nandflash.c (51%)
 delete mode 100644 arch/cris/arch-v32/kernel/arbiter.c
 delete mode 100644 arch/cris/arch-v32/kernel/io.c
 delete mode 100644 arch/cris/arch-v32/kernel/vcs_hook.c
 create mode 100644 arch/cris/arch-v32/lib/delay.c
 create mode 100644 arch/cris/arch-v32/mach-a3/Kconfig
 create mode 100644 arch/cris/arch-v32/mach-a3/Makefile
 create mode 100644 arch/cris/arch-v32/mach-a3/arbiter.c
 create mode 100644 arch/cris/arch-v32/mach-a3/cpufreq.c
 create mode 100644 arch/cris/arch-v32/mach-a3/dma.c
 create mode 100644 arch/cris/arch-v32/mach-a3/dram_init.S
 create mode 100644 arch/cris/arch-v32/mach-a3/hw_settings.S
 create mode 100644 arch/cris/arch-v32/mach-a3/io.c
 create mode 100644 arch/cris/arch-v32/mach-a3/pinmux.c
 create mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.c
 create mode 100644 arch/cris/arch-v32/mach-a3/vcs_hook.h
 create mode 100644 arch/cris/arch-v32/mach-fs/Kconfig
 create mode 100644 arch/cris/arch-v32/mach-fs/Makefile
 create mode 100644 arch/cris/arch-v32/mach-fs/arbiter.c
 create mode 100644 arch/cris/arch-v32/mach-fs/cpufreq.c
 rename arch/cris/arch-v32/{kernel => mach-fs}/dma.c (83%)
 rename arch/cris/arch-v32/{lib => mach-fs}/dram_init.S (84%)
 rename arch/cris/arch-v32/{lib => mach-fs}/hw_settings.S (87%)
 create mode 100644 arch/cris/arch-v32/mach-fs/io.c
 create mode 100644 arch/cris/arch-v32/mach-fs/pinmux.c
 create mode 100644 arch/cris/arch-v32/mach-fs/vcs_hook.c
 rename arch/cris/arch-v32/{kernel => mach-fs}/vcs_hook.h (80%)
 create mode 100644 arch/cris/arch-v32/mm/l2cache.c
 create mode 100644 arch/cris/artpec_3_defconfig
 create mode 100644 arch/cris/etraxfs_defconfig
 create mode 100644 include/asm-cris/arch-v10/bug.h
 create mode 100644 include/asm-cris/arch-v32/bug.h
 delete mode 100644 include/asm-cris/arch-v32/juliette.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/arbiter.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/dma.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/clkgen_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/ddr2_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/gio_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/pinmux_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/pio_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/reg_map_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/asm/timer_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/clkgen_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/ddr2_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/gio_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/intr_vect.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/intr_vect_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_reg_space_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sap_in_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sap_out_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_cfg_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_cpu_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_mpu_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_sw_spu_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/asm/iop_version_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_reg_space.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sap_in_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sap_out_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_cfg_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_cpu_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_mpu_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_sw_spu_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/iop/iop_version_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/l2cache_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/marb_bar_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/marb_foo_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/pinmux_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/pio_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/reg_map.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/hwregs/strmux_defs.h
 copy include/asm-cris/arch-v32/{ => mach-a3}/hwregs/timer_defs.h (95%)
 create mode 100644 include/asm-cris/arch-v32/mach-a3/memmap.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/pinmux.h
 create mode 100644 include/asm-cris/arch-v32/mach-a3/startup.inc
 create mode 100644 include/asm-cris/arch-v32/mach-fs/arbiter.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/bif_core_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/config_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/gio_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/pinmux_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/reg_map_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/asm/timer_defs_asm.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_core_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_dma_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/bif_slave_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/config_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/gio_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/intr_vect.h
 rename include/asm-cris/arch-v32/{ => mach-fs}/hwregs/intr_vect_defs.h (96%)
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/marb_bp_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/marb_defs.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/pinmux_defs.h
 rename include/asm-cris/arch-v32/{ => mach-fs}/hwregs/reg_map.h (97%)
 create mode 100644 include/asm-cris/arch-v32/mach-fs/hwregs/strmux_defs.h
 rename include/asm-cris/arch-v32/{ => mach-fs}/hwregs/timer_defs.h (99%)
 create mode 100644 include/asm-cris/arch-v32/mach-fs/pinmux.h
 create mode 100644 include/asm-cris/arch-v32/mach-fs/startup.inc
