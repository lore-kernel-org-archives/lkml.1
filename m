Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbYHNNWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbYHNNWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYHNNWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:22:32 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33842 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbYHNNWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=VwKqkUq6FHf9z7JllQjvYXkzlwtL69g+u6VMQcCbOHpR65jIWpH2q9uLJKf074bBjg
         5+wsj8sqazamkWDneVPCLM2yn8K0CVJ14XMzmqBa6UwzSL1IqfciLyJigDVtrzporeeC
         wveWS3aZmzWODkTZJ0WXB89SY/n/u/n6yU3Yw=
Message-ID: <386072610808140622t48b0ebcm466729b6e9e1abde@mail.gmail.com>
Date: Thu, 14 Aug 2008 21:22:21 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch updates for 2.6.27-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: ba2551f4ff0640d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Due to some usb bug fixing task, I missed 2.6.27-rc2 cycle.
This pull request looks like a little bigger but it is reasonable for
the early 2.6.27 development cycle.
Most new code are related to 2 new board support. Also we fixed some
critical bugs.

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                              |   69 +-
 arch/blackfin/configs/BlackStamp_defconfig         | 1195 ++++++++++++++++++++
 arch/blackfin/configs/TCM-BF537_defconfig          |  693 ++++++++++++
 arch/blackfin/kernel/cplb-mpu/cacheinit.c          |    4 +-
 arch/blackfin/kernel/cplb-nompu/cacheinit.c        |    4 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    6 +-
 arch/blackfin/kernel/setup.c                       |   33 +-
 arch/blackfin/kernel/traps.c                       |   90 +-
 arch/blackfin/kernel/vmlinux.lds.S                 |   11 +-
 arch/blackfin/lib/ins.S                            |  109 ++
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   60 +-
 arch/blackfin/mach-bf527/boards/ezkit.c            |   60 +-
 arch/blackfin/mach-bf527/head.S                    |  289 -----
 arch/blackfin/mach-bf527/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf533/boards/H8606.c            |    7 +-
 arch/blackfin/mach-bf533/boards/Kconfig            |    6 +
 arch/blackfin/mach-bf533/boards/Makefile           |    1 +
 arch/blackfin/mach-bf533/boards/blackstamp.c       |  401 +++++++
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   52 +-
 arch/blackfin/mach-bf533/boards/ezkit.c            |   52 +-
 arch/blackfin/mach-bf533/boards/stamp.c            |   58 +-
 arch/blackfin/mach-bf533/head.S                    |  290 -----
 arch/blackfin/mach-bf533/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf537/boards/Kconfig            |    6 +
 arch/blackfin/mach-bf537/boards/Makefile           |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   62 +-
 arch/blackfin/mach-bf537/boards/generic_board.c    |   51 +-
 arch/blackfin/mach-bf537/boards/minotaur.c         |    6 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |    6 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |   18 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |  590 ++++++++++
 arch/blackfin/mach-bf537/head.S                    |  321 ------
 arch/blackfin/mach-bf537/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |    8 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |   14 +-
 arch/blackfin/mach-bf548/head.S                    |  259 -----
 arch/blackfin/mach-bf548/ints-priority.c           |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |    8 +-
 arch/blackfin/mach-bf561/boards/ezkit.c            |   52 +-
 arch/blackfin/mach-bf561/head.S                    |  275 +-----
 arch/blackfin/mach-bf561/ints-priority.c           |    2 +-
 arch/blackfin/mach-common/Makefile                 |    5 +-
 arch/blackfin/mach-common/arch_checks.c            |    9 +
 arch/blackfin/mach-common/cache.S                  |  115 --
 arch/blackfin/mach-common/cacheinit.S              |   77 --
 arch/blackfin/mach-common/dpmc_modes.S             |   56 -
 arch/blackfin/mach-common/entry.S                  |   34 +-
 arch/blackfin/mach-common/head.S                   |  207 ++++
 arch/blackfin/mach-common/ints-priority.c          |   68 +-
 arch/blackfin/mach-common/lock.S                   |   45 +-
 arch/blackfin/mach-common/pm.c                     |   35 +-
 arch/blackfin/mm/blackfin_sram.c                   |   12 +-
 include/asm-blackfin/Kbuild                        |    2 +-
 include/asm-blackfin/bfin-global.h                 |   38 +-
 include/asm-blackfin/dpmc.h                        |    1 -
 include/asm-blackfin/fixed_code.h                  |   24 +
 include/asm-blackfin/mach-bf527/mem_map.h          |    5 +
 include/asm-blackfin/mach-bf533/mem_init.h         |    2 +-
 include/asm-blackfin/mach-bf533/mem_map.h          |    5 +
 include/asm-blackfin/mach-bf537/mem_map.h          |    5 +
 include/asm-blackfin/mach-common/cdef_LPBlackfin.h |    8 -
 include/asm-blackfin/unistd.h                      |    8 +-
 62 files changed, 3665 insertions(+), 2273 deletions(-)
 create mode 100644 arch/blackfin/configs/BlackStamp_defconfig
 create mode 100644 arch/blackfin/configs/TCM-BF537_defconfig
 create mode 100644 arch/blackfin/mach-bf533/boards/blackstamp.c
 create mode 100644 arch/blackfin/mach-bf537/boards/tcm_bf537.c
 delete mode 100644 arch/blackfin/mach-common/cacheinit.S
 create mode 100644 arch/blackfin/mach-common/head.S

Benjamin Matthews (1):
      Blackfin arch: add support for the BlackStamp board

Bryan Wu (1):
      Blackfin arch: hook up some missing new system calls

Jie Zhang (1):
      Blackfin arch: Fix bug - This change eliminates impact on
application debugging

Michael Hennerich (3):
      Blackfin arch: Functional power management support
      Blackfin arch: Fix Bug - System with EMAC driver enabled - Core not idling
      Blackfin arch: workaround SIC_IWR1 reset bug, by keeping MDMA0/1
always enabled in SIC_IWR1.

Mike Frysinger (22):
      Blackfin arch: remove useless mtd defines in uClinux
      Blackfin arch: add board resources for parallel flash on cm-bf537
      Blackfin arch: add support for board tcm-bf537
      Blackfin arch: remove pata resources from generic board
      Blackfin arch: use symbolic IRQ_PF define rather than hardcoded
      Blackfin arch: remove support for Anomaly 05000125 as it doesnt
exist on any supported processor/silicon
      Blackfin arch: unify the duplicated _real_start functions
      Blackfin arch: make sure the BSS and kernel load address are 4
byte aligned
      Blackfin arch: move async memory programming into common
setup_arch() as the banks dont really need to be setup fully as early
as head.S
      Blackfin arch: add asm/thread_info.h for THREAD_SIZE define
      Blackfin arch: unify the duplicated portions of __start and
split mach-specific pieces into _mach_early_start where they will be
easier to trim over time
      Blackfin arch: convert L2 defines to be the same as the L1 defines
      Blackfin arch: delete unused cache functions
      Blackfin arch: cleanup cache lock code
      Blackfin arch: delete dead prototypes
      Blackfin arch: mark some functions as __init as they are only
called from __init functions
      Blackfin arch: move fixed code defines into fixed_code.h as very
few things actually need to know these details
      Blackfin arch: shuffle related prototypes together -- no
functional changes
      Blackfin arch: use %pF when printing out the double fault
address so we get symbol names
      Blackfin arch: clear EMAC_SYSTAT during IRQ init rather than
early head.S as we dont need it setup that early
      Blackfin arch: do not muck with the UART during boot -- let the
serial driver worry about it
      Blackfin arch: fix missing digit in SCLK range checking

Robin Getz (4):
      Blackfin arch: be consistant with parition names, and ensure the
bus is identified
      Blackfin arch: Fix bug - when expanding the trace buffer, it
does not print out the decoded instruction.
      Blackfin arch: Print out doublefault addresses, so debug can occur
      Blackfin arch: Allow ins functions to have a low latency version

Sonic Zhang (1):
      Blackfin arch: Fix bugs - Make kgdb code apparent to app debugging.

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 5a097c4..f64d259 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -249,7 +249,7 @@ config MEM_MT48LC8M32B2B5_7

 config MEM_MT48LC32M16A2TG_75
 	bool
-	depends on (BFIN527_EZKIT || BFIN532_IP0X)
+	depends on (BFIN527_EZKIT || BFIN532_IP0X || BLACKSTAMP)
 	default y

 source "arch/blackfin/mach-bf527/Kconfig"
@@ -292,7 +292,7 @@ config CLKIN_HZ
 	int "Frequency of the crystal on the board in Hz"
 	default "11059200" if BFIN533_STAMP
 	default "27000000" if BFIN533_EZKIT
-	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT || H8606_HVSISTEMAS)
+	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT ||
H8606_HVSISTEMAS || BLACKSTAMP)
 	default "30000000" if BFIN561_EZKIT
 	default "24576000" if PNAV10
 	default "10000000" if BFIN532_IP0X
@@ -332,7 +332,7 @@ config VCO_MULT
 	default "22" if BFIN533_BLUETECHNIX_CM
 	default "20" if (BFIN537_BLUETECHNIX_CM || BFIN527_BLUETECHNIX_CM ||
BFIN561_BLUETECHNIX_CM)
 	default "20" if BFIN561_EZKIT
-	default "16" if H8606_HVSISTEMAS
+	default "16" if (H8606_HVSISTEMAS || BLACKSTAMP)
 	help
 	  This controls the frequency of the on-chip PLL. This can be
between 1 and 64.
 	  PLL Frequency = (Crystal Frequency) * (this setting)
@@ -622,6 +622,33 @@ config CPLB_SWITCH_TAB_L1
 	  If enabled, the CPLB Switch Tables are linked
 	  into L1 data memory. (less latency)

+comment "Speed Optimizations"
+config BFIN_INS_LOWOVERHEAD
+	bool "ins[bwl] low overhead, higher interrupt latency"
+	default y
+	help
+	  Reads on the Blackfin are speculative. In Blackfin terms, this means
+	  they can be interrupted at any time (even after they have been issued
+	  on to the external bus), and re-issued after the interrupt occurs.
+	  For memory - this is not a big deal, since memory does not change if
+	  it sees a read.
+
+	  If a FIFO is sitting on the end of the read, it will see two reads,
+	  when the core only sees one since the FIFO receives both the read
+	  which is cancelled (and not delivered to the core) and the one which
+	  is re-issued (which is delivered to the core).
+
+	  To solve this, interrupts are turned off before reads occur to
+	  I/O space. This option controls which the overhead/latency of
+	  controlling interrupts during this time
+	   "n" turns interrupts off every read
+		(higher overhead, but lower interrupt latency)
+	   "y" turns interrupts off every loop
+		(low overhead, but longer interrupt latency)
+
+	  default behavior is to leave this set to on (type "Y"). If you are
experiencing
+	  interrupt latency issues, it is safe and OK to turn this off.
+
 endmenu


@@ -933,13 +960,6 @@ endchoice
 comment "Possible Suspend Mem / Hibernate Wake-Up Sources"
 	depends on PM

-config PM_BFIN_WAKE_RTC
-	bool "Allow Wake-Up from RESET and on-chip RTC"
-	depends on PM
-	default n
-	help
-	  Enable RTC Wake-Up (Voltage Regulator Power-Up)
-
 config PM_BFIN_WAKE_PH6
 	bool "Allow Wake-Up from on-chip PHY or PH6 GP"
 	depends on PM && (BF52x || BF534 || BF536 || BF537)
@@ -947,41 +967,12 @@ config PM_BFIN_WAKE_PH6
 	help
 	  Enable PHY and PH6 GP Wake-Up (Voltage Regulator Power-Up)

-config PM_BFIN_WAKE_CAN
-	bool "Allow Wake-Up from on-chip CAN0/1"
-	depends on PM && (BF54x || BF534 || BF536 || BF537)
-	default n
-	help
-	  Enable CAN0/1 Wake-Up (Voltage Regulator Power-Up)
-
 config PM_BFIN_WAKE_GP
 	bool "Allow Wake-Up from GPIOs"
 	depends on PM && BF54x
 	default n
 	help
 	  Enable General-Purpose Wake-Up (Voltage Regulator Power-Up)
-
-config PM_BFIN_WAKE_USB
-	bool "Allow Wake-Up from on-chip USB"
-	depends on PM && (BF54x || BF52x)
-	default n
-	help
-	  Enable USB Wake-Up (Voltage Regulator Power-Up)
-
-config PM_BFIN_WAKE_KEYPAD
-	bool "Allow Wake-Up from on-chip Keypad"
-	depends on PM && BF54x
-	default n
-	help
-	  Enable Keypad Wake-Up (Voltage Regulator Power-Up)
-
-config PM_BFIN_WAKE_ROTARY
-	bool "Allow Wake-Up from on-chip Rotary"
-	depends on PM && BF54x
-	default n
-	help
-	  Enable Rotary Wake-Up (Voltage Regulator Power-Up)
-
 endmenu

 menu "CPU Frequency scaling"
diff --git a/arch/blackfin/configs/BlackStamp_defconfig
b/arch/blackfin/configs/BlackStamp_defconfig
new file mode 100644
index 0000000..2921f99
--- /dev/null
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -0,0 +1,1195 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.26.2
+#
+# CONFIG_MMU is not set
+# CONFIG_FPU is not set
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_FORCE_MAX_ZONEORDER=14
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+# CONFIG_GROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_SYSCTL_SYSCALL_CHECK=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_COMPAT_BRK=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_HAVE_KPROBES is not set
+# CONFIG_HAVE_KRETPROBES is not set
+# CONFIG_HAVE_DMA_ATTRS is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+# CONFIG_MODULE_FORCE_LOAD is not set
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+CONFIG_DEFAULT_AS=y
+# CONFIG_DEFAULT_DEADLINE is not set
+# CONFIG_DEFAULT_CFQ is not set
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="anticipatory"
+CONFIG_CLASSIC_RCU=y
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
+
+#
+# Blackfin Processor Options
+#
+
+#
+# Processor and Board Settings
+#
+# CONFIG_BF522 is not set
+# CONFIG_BF523 is not set
+# CONFIG_BF524 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF526 is not set
+# CONFIG_BF527 is not set
+# CONFIG_BF531 is not set
+CONFIG_BF532=y
+# CONFIG_BF533 is not set
+# CONFIG_BF534 is not set
+# CONFIG_BF536 is not set
+# CONFIG_BF537 is not set
+# CONFIG_BF542 is not set
+# CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
+# CONFIG_BF548 is not set
+# CONFIG_BF549 is not set
+# CONFIG_BF561 is not set
+# CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
+# CONFIG_BF_REV_0_2 is not set
+# CONFIG_BF_REV_0_3 is not set
+# CONFIG_BF_REV_0_4 is not set
+CONFIG_BF_REV_0_5=y
+# CONFIG_BF_REV_ANY is not set
+# CONFIG_BF_REV_NONE is not set
+CONFIG_BF53x=y
+CONFIG_MEM_MT48LC32M16A2TG_75=y
+# CONFIG_BFIN533_EZKIT is not set
+# CONFIG_BFIN533_STAMP is not set
+# CONFIG_BFIN533_BLUETECHNIX_CM is not set
+# CONFIG_H8606_HVSISTEMAS is not set
+# CONFIG_BFIN532_IP0X is not set
+CONFIG_BLACKSTAMP=y
+# CONFIG_GENERIC_BF533_BOARD is not set
+
+#
+# BF533/2/1 Specific Configuration
+#
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_UART_ERROR=7
+CONFIG_SPORT0_ERROR=7
+CONFIG_SPI_ERROR=7
+CONFIG_SPORT1_ERROR=7
+CONFIG_PPI_ERROR=7
+CONFIG_DMA_ERROR=7
+CONFIG_PLLWAKE_ERROR=7
+CONFIG_RTC_ERROR=8
+CONFIG_DMA0_PPI=8
+CONFIG_DMA1_SPORT0RX=9
+CONFIG_DMA2_SPORT0TX=9
+CONFIG_DMA3_SPORT1RX=9
+CONFIG_DMA4_SPORT1TX=9
+CONFIG_DMA5_SPI=10
+CONFIG_DMA6_UARTRX=10
+CONFIG_DMA7_UARTTX=10
+CONFIG_TIMER0=11
+CONFIG_TIMER1=11
+CONFIG_TIMER2=11
+CONFIG_PFA=12
+CONFIG_PFB=12
+CONFIG_MEMDMA0=13
+CONFIG_MEMDMA1=13
+CONFIG_WDTIMER=13
+
+#
+# Board customizations
+#
+# CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000
+
+#
+# Clock/PLL Setup
+#
+CONFIG_CLKIN_HZ=25000000
+# CONFIG_BFIN_KERNEL_CLOCK is not set
+# CONFIG_PLL_BYPASS is not set
+# CONFIG_CLKIN_HALF is not set
+CONFIG_VCO_MULT=16
+CONFIG_CCLK_DIV_1=y
+# CONFIG_CCLK_DIV_2 is not set
+# CONFIG_CCLK_DIV_4 is not set
+# CONFIG_CCLK_DIV_8 is not set
+CONFIG_SCLK_DIV=3
+CONFIG_MAX_MEM_SIZE=64
+CONFIG_MAX_VCO_HZ=400000000
+CONFIG_MIN_VCO_HZ=50000000
+CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MIN_SCLK_HZ=27000000
+
+#
+# Kernel Timer/Scheduler
+#
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+# CONFIG_SCHED_HRTICK is not set
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+
+#
+# Memory Setup
+#
+
+#
+# Misc
+#
+CONFIG_BFIN_SCRATCH_REG_RETN=y
+# CONFIG_BFIN_SCRATCH_REG_RETE is not set
+# CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
+
+#
+# Blackfin Kernel Optimizations
+#
+
+#
+# Memory Optimizations
+#
+CONFIG_I_ENTRY_L1=y
+CONFIG_EXCPT_IRQ_SYSC_L1=y
+CONFIG_DO_IRQ_L1=y
+CONFIG_CORE_TIMER_IRQ_L1=y
+CONFIG_IDLE_L1=y
+CONFIG_SCHEDULE_L1=y
+CONFIG_ARITHMETIC_OPS_L1=y
+CONFIG_ACCESS_OK_L1=y
+CONFIG_MEMSET_L1=y
+CONFIG_MEMCPY_L1=y
+CONFIG_SYS_BFIN_SPINLOCK_L1=y
+# CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
+# CONFIG_SYSCALL_TAB_L1 is not set
+# CONFIG_CPLB_SWITCH_TAB_L1 is not set
+# CONFIG_RAMKERNEL is not set
+CONFIG_ROMKERNEL=y
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_VIRT_TO_BUS=y
+CONFIG_BFIN_GPTIMERS=y
+CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
+# CONFIG_DMA_UNCACHED_2M is not set
+CONFIG_DMA_UNCACHED_1M=y
+# CONFIG_DMA_UNCACHED_NONE is not set
+
+#
+# Cache Support
+#
+CONFIG_BFIN_ICACHE=y
+CONFIG_BFIN_DCACHE=y
+# CONFIG_BFIN_DCACHE_BANKA is not set
+# CONFIG_BFIN_ICACHE_LOCK is not set
+# CONFIG_BFIN_WB is not set
+CONFIG_BFIN_WT=y
+# CONFIG_MPU is not set
+
+#
+# Asynchonous Memory Configuration
+#
+
+#
+# EBIU_AMGCTL Global Control
+#
+CONFIG_C_AMCKEN=y
+CONFIG_C_CDPRIO=y
+# CONFIG_C_AMBEN is not set
+# CONFIG_C_AMBEN_B0 is not set
+# CONFIG_C_AMBEN_B0_B1 is not set
+# CONFIG_C_AMBEN_B0_B1_B2 is not set
+CONFIG_C_AMBEN_ALL=y
+
+#
+# EBIU_AMBCTL Control
+#
+CONFIG_BANK_0=0x7BB0
+CONFIG_BANK_1=0x7BB0
+CONFIG_BANK_2=0x7BB0
+CONFIG_BANK_3=0xAAC2
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+# CONFIG_PCCARD is not set
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF_FDPIC=y
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+CONFIG_BINFMT_SHARED_FLAT=y
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+CONFIG_PM=y
+# CONFIG_PM_DEBUG is not set
+CONFIG_PM_SLEEP=y
+CONFIG_SUSPEND=y
+CONFIG_SUSPEND_FREEZER=y
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+CONFIG_PM_BFIN_SLEEP_DEEPER=y
+# CONFIG_PM_BFIN_SLEEP is not set
+# CONFIG_PM_WAKEUP_BY_GPIO is not set
+
+#
+# Possible Suspend Mem / Hibernate Wake-Up Sources
+#
+
+#
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+
+#
+# Networking
+#
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_PACKET=y
+# CONFIG_PACKET_MMAP is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+# CONFIG_IP_PNP_DHCP is not set
+# CONFIG_IP_PNP_BOOTP is not set
+# CONFIG_IP_PNP_RARP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+CONFIG_SYN_COOKIES=y
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
+CONFIG_INET_DIAG=y
+CONFIG_INET_TCP_DIAG=y
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_NETLABEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_VLAN_8021Q is not set
+# CONFIG_DECNET is not set
+# CONFIG_LLC2 is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_SCHED is not set
+
+#
+# Network testing
+#
+# CONFIG_NET_PKTGEN is not set
+# CONFIG_HAMRADIO is not set
+# CONFIG_CAN is not set
+# CONFIG_IRDA is not set
+# CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_FW_LOADER is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+CONFIG_MTD_CMDLINE_PARTS=y
+# CONFIG_MTD_AR7_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+CONFIG_MTD_CFI=m
+# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_GEN_PROBE=m
+# CONFIG_MTD_CFI_ADV_OPTIONS is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=m
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=m
+CONFIG_MTD_RAM=y
+CONFIG_MTD_ROM=m
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_GPIO_ADDR is not set
+# CONFIG_MTD_UCLINUX is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_DATAFLASH is not set
+CONFIG_MTD_M25P80=y
+# CONFIG_M25PXX_USE_FAST_READ is not set
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=y
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+CONFIG_BLK_DEV_NBD=y
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
+CONFIG_HAVE_IDE=y
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+# CONFIG_PHYLIB is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+CONFIG_SMC91X=y
+# CONFIG_SMSC911X is not set
+# CONFIG_DM9000 is not set
+# CONFIG_ENC28J60 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_IWLWIFI_LEDS is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_ISDN is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+CONFIG_INPUT_EVDEV=m
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_AD9960 is not set
+# CONFIG_SPI_ADC_BF533 is not set
+# CONFIG_BF5xx_PPIFCD is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
+CONFIG_BF5xx_PPI=y
+CONFIG_BFIN_SPORT=y
+# CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_TWI_LCD is not set
+CONFIG_SIMPLE_GPIO=m
+# CONFIG_VT is not set
+CONFIG_DEVKMEM=y
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_BFIN=y
+CONFIG_SERIAL_BFIN_CONSOLE=y
+CONFIG_SERIAL_BFIN_DMA=y
+# CONFIG_SERIAL_BFIN_PIO is not set
+CONFIG_SERIAL_BFIN_UART0=y
+# CONFIG_BFIN_UART0_CTSRTS is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_BFIN_SPORT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+
+#
+# CAN, the car bus and industrial fieldbus
+#
+# CONFIG_CAN4LINUX is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+CONFIG_I2C=m
+CONFIG_I2C_BOARDINFO=y
+CONFIG_I2C_CHARDEV=m
+CONFIG_I2C_ALGOBIT=m
+
+#
+# I2C Hardware Bus support
+#
+CONFIG_I2C_GPIO=m
+# CONFIG_I2C_OCORES is not set
+# CONFIG_I2C_PARPORT_LIGHT is not set
+# CONFIG_I2C_SIMTEC is not set
+# CONFIG_I2C_TAOS_EVM is not set
+# CONFIG_I2C_STUB is not set
+# CONFIG_I2C_PCA_PLATFORM is not set
+
+#
+# Miscellaneous I2C Chip support
+#
+# CONFIG_DS1682 is not set
+# CONFIG_SENSORS_AD5252 is not set
+# CONFIG_SENSORS_EEPROM is not set
+# CONFIG_SENSORS_PCF8574 is not set
+# CONFIG_PCF8575 is not set
+# CONFIG_SENSORS_PCF8591 is not set
+# CONFIG_SENSORS_MAX6875 is not set
+# CONFIG_SENSORS_TSL2550 is not set
+# CONFIG_I2C_DEBUG_CORE is not set
+# CONFIG_I2C_DEBUG_ALGO is not set
+# CONFIG_I2C_DEBUG_BUS is not set
+# CONFIG_I2C_DEBUG_CHIP is not set
+CONFIG_SPI=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+CONFIG_SPI_AT25=y
+CONFIG_SPI_SPIDEV=m
+# CONFIG_SPI_TLE62X0 is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ADT7473 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_DME1737 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_ADS7828 is not set
+# CONFIG_SENSORS_THMC50 is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83L786NG is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
+# CONFIG_THERMAL is not set
+# CONFIG_THERMAL_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+# CONFIG_HTC_PASIC3 is not set
+
+#
+# Multimedia devices
+#
+
+#
+# Multimedia core support
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DVB_CORE is not set
+# CONFIG_VIDEO_MEDIA is not set
+
+#
+# Multimedia drivers
+#
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+CONFIG_HID_SUPPORT=y
+CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
+# CONFIG_HIDRAW is not set
+# CONFIG_USB_SUPPORT is not set
+CONFIG_MMC=y
+# CONFIG_MMC_DEBUG is not set
+# CONFIG_MMC_UNSAFE_RESUME is not set
+
+#
+# MMC/SD Card Drivers
+#
+CONFIG_MMC_BLOCK=y
+CONFIG_MMC_BLOCK_BOUNCE=y
+# CONFIG_SDIO_UART is not set
+# CONFIG_MMC_TEST is not set
+
+#
+# MMC/SD Host Controller Drivers
+#
+CONFIG_MMC_SPI=y
+# CONFIG_SPI_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+# CONFIG_RTC_DEBUG is not set
+
+#
+# RTC interfaces
+#
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
+
+#
+# I2C RTC drivers
+#
+# CONFIG_RTC_DRV_DS1307 is not set
+# CONFIG_RTC_DRV_DS1374 is not set
+# CONFIG_RTC_DRV_DS1672 is not set
+# CONFIG_RTC_DRV_MAX6900 is not set
+# CONFIG_RTC_DRV_RS5C372 is not set
+# CONFIG_RTC_DRV_ISL1208 is not set
+# CONFIG_RTC_DRV_X1205 is not set
+# CONFIG_RTC_DRV_PCF8563 is not set
+# CONFIG_RTC_DRV_PCF8583 is not set
+# CONFIG_RTC_DRV_M41T80 is not set
+# CONFIG_RTC_DRV_S35390A is not set
+# CONFIG_RTC_DRV_FM3130 is not set
+
+#
+# SPI RTC drivers
+#
+# CONFIG_RTC_DRV_MAX6902 is not set
+# CONFIG_RTC_DRV_R9701 is not set
+# CONFIG_RTC_DRV_RS5C348 is not set
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_BFIN=y
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+# CONFIG_EXT2_FS is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_DNOTIFY is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+CONFIG_FAT_FS=y
+CONFIG_MSDOS_FS=y
+CONFIG_VFAT_FS=y
+CONFIG_FAT_DEFAULT_CODEPAGE=437
+CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+CONFIG_YAFFS_FS=m
+CONFIG_YAFFS_YAFFS1=y
+# CONFIG_YAFFS_9BYTE_TAGS is not set
+# CONFIG_YAFFS_DOES_ECC is not set
+CONFIG_YAFFS_YAFFS2=y
+CONFIG_YAFFS_AUTO_YAFFS2=y
+# CONFIG_YAFFS_DISABLE_LAZY_LOAD is not set
+# CONFIG_YAFFS_DISABLE_WIDE_TNODES is not set
+# CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED is not set
+CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
+CONFIG_JFFS2_FS=y
+CONFIG_JFFS2_FS_DEBUG=0
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
+# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
+CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+CONFIG_NFS_V4=y
+# CONFIG_NFSD is not set
+# CONFIG_ROOT_NFS is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+CONFIG_SUNRPC_GSS=y
+# CONFIG_SUNRPC_BIND34 is not set
+CONFIG_RPCSEC_GSS_KRB5=y
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+CONFIG_SMB_FS=y
+# CONFIG_SMB_NLS_DEFAULT is not set
+CONFIG_CIFS=y
+# CONFIG_CIFS_STATS is not set
+# CONFIG_CIFS_WEAK_PW_HASH is not set
+# CONFIG_CIFS_XATTR is not set
+# CONFIG_CIFS_DEBUG2 is not set
+# CONFIG_CIFS_EXPERIMENTAL is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="iso8859-1"
+CONFIG_NLS_CODEPAGE_437=y
+# CONFIG_NLS_CODEPAGE_737 is not set
+# CONFIG_NLS_CODEPAGE_775 is not set
+# CONFIG_NLS_CODEPAGE_850 is not set
+# CONFIG_NLS_CODEPAGE_852 is not set
+# CONFIG_NLS_CODEPAGE_855 is not set
+# CONFIG_NLS_CODEPAGE_857 is not set
+# CONFIG_NLS_CODEPAGE_860 is not set
+# CONFIG_NLS_CODEPAGE_861 is not set
+# CONFIG_NLS_CODEPAGE_862 is not set
+# CONFIG_NLS_CODEPAGE_863 is not set
+# CONFIG_NLS_CODEPAGE_864 is not set
+# CONFIG_NLS_CODEPAGE_865 is not set
+# CONFIG_NLS_CODEPAGE_866 is not set
+# CONFIG_NLS_CODEPAGE_869 is not set
+# CONFIG_NLS_CODEPAGE_936 is not set
+# CONFIG_NLS_CODEPAGE_950 is not set
+# CONFIG_NLS_CODEPAGE_932 is not set
+# CONFIG_NLS_CODEPAGE_949 is not set
+# CONFIG_NLS_CODEPAGE_874 is not set
+# CONFIG_NLS_ISO8859_8 is not set
+# CONFIG_NLS_CODEPAGE_1250 is not set
+# CONFIG_NLS_CODEPAGE_1251 is not set
+CONFIG_NLS_ASCII=y
+# CONFIG_NLS_ISO8859_1 is not set
+# CONFIG_NLS_ISO8859_2 is not set
+# CONFIG_NLS_ISO8859_3 is not set
+# CONFIG_NLS_ISO8859_4 is not set
+# CONFIG_NLS_ISO8859_5 is not set
+# CONFIG_NLS_ISO8859_6 is not set
+# CONFIG_NLS_ISO8859_7 is not set
+# CONFIG_NLS_ISO8859_9 is not set
+# CONFIG_NLS_ISO8859_13 is not set
+# CONFIG_NLS_ISO8859_14 is not set
+# CONFIG_NLS_ISO8859_15 is not set
+# CONFIG_NLS_KOI8_R is not set
+# CONFIG_NLS_KOI8_U is not set
+CONFIG_NLS_UTF8=y
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
+CONFIG_DEBUG_BFIN_HWTRACE_ON=y
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_TWO is not set
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION=0
+# CONFIG_DEBUG_BFIN_HWTRACE_EXPAND is not set
+# CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
+CONFIG_EARLY_PRINTK=y
+CONFIG_CPLB_INFO=y
+CONFIG_ACCESS_CHECK=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+CONFIG_SECURITY=y
+# CONFIG_SECURITY_NETWORK is not set
+# CONFIG_SECURITY_CAPABILITIES is not set
+CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_MANAGER=y
+# CONFIG_CRYPTO_GF128MUL is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_CRYPTD is not set
+# CONFIG_CRYPTO_AUTHENC is not set
+# CONFIG_CRYPTO_TEST is not set
+
+#
+# Authenticated Encryption with Associated Data
+#
+# CONFIG_CRYPTO_CCM is not set
+# CONFIG_CRYPTO_GCM is not set
+# CONFIG_CRYPTO_SEQIV is not set
+
+#
+# Block modes
+#
+CONFIG_CRYPTO_CBC=y
+# CONFIG_CRYPTO_CTR is not set
+# CONFIG_CRYPTO_CTS is not set
+# CONFIG_CRYPTO_ECB is not set
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_PCBC is not set
+# CONFIG_CRYPTO_XTS is not set
+
+#
+# Hash modes
+#
+# CONFIG_CRYPTO_HMAC is not set
+# CONFIG_CRYPTO_XCBC is not set
+
+#
+# Digest
+#
+# CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_MD4 is not set
+CONFIG_CRYPTO_MD5=y
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_SHA1 is not set
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
+# CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_WP512 is not set
+
+#
+# Ciphers
+#
+# CONFIG_CRYPTO_AES is not set
+# CONFIG_CRYPTO_ANUBIS is not set
+# CONFIG_CRYPTO_ARC4 is not set
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
+CONFIG_CRYPTO_DES=y
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_KHAZAD is not set
+# CONFIG_CRYPTO_SALSA20 is not set
+# CONFIG_CRYPTO_SEED is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_TEA is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+
+#
+# Compression
+#
+# CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_LZO is not set
+CONFIG_CRYPTO_HW=y
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_GENERIC_FIND_FIRST_BIT is not set
+CONFIG_CRC_CCITT=m
+# CONFIG_CRC16 is not set
+CONFIG_CRC_ITU_T=y
+CONFIG_CRC32=y
+CONFIG_CRC7=y
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/blackfin/configs/TCM-BF537_defconfig
b/arch/blackfin/configs/TCM-BF537_defconfig
new file mode 100644
index 0000000..c482ee1
--- /dev/null
+++ b/arch/blackfin/configs/TCM-BF537_defconfig
@@ -0,0 +1,693 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24.7
+# Thu Jul 31 00:53:15 2008
+#
+# CONFIG_MMU is not set
+# CONFIG_FPU is not set
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
+CONFIG_SEMAPHORE_SLEEPERS=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_FORCE_MAX_ZONEORDER=14
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+CONFIG_IKCONFIG=y
+CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
+# CONFIG_RELAY is not set
+# CONFIG_BLK_DEV_INITRD is not set
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_EMBEDDED=y
+# CONFIG_UID16 is not set
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+# CONFIG_HOTPLUG is not set
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_TINY_SHMEM=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_KMOD=y
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+# CONFIG_DEFAULT_CFQ is not set
+CONFIG_DEFAULT_NOOP=y
+CONFIG_DEFAULT_IOSCHED="noop"
+CONFIG_PREEMPT_NONE=y
+# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT is not set
+
+#
+# Blackfin Processor Options
+#
+
+#
+# Processor and Board Settings
+#
+# CONFIG_BF522 is not set
+# CONFIG_BF523 is not set
+# CONFIG_BF524 is not set
+# CONFIG_BF525 is not set
+# CONFIG_BF526 is not set
+# CONFIG_BF527 is not set
+# CONFIG_BF531 is not set
+# CONFIG_BF532 is not set
+# CONFIG_BF533 is not set
+# CONFIG_BF534 is not set
+# CONFIG_BF536 is not set
+CONFIG_BF537=y
+# CONFIG_BF542 is not set
+# CONFIG_BF544 is not set
+# CONFIG_BF547 is not set
+# CONFIG_BF548 is not set
+# CONFIG_BF549 is not set
+# CONFIG_BF561 is not set
+# CONFIG_BF_REV_0_0 is not set
+# CONFIG_BF_REV_0_1 is not set
+CONFIG_BF_REV_0_2=y
+# CONFIG_BF_REV_0_3 is not set
+# CONFIG_BF_REV_0_4 is not set
+# CONFIG_BF_REV_0_5 is not set
+# CONFIG_BF_REV_ANY is not set
+# CONFIG_BF_REV_NONE is not set
+CONFIG_BF53x=y
+CONFIG_IRQ_PLL_WAKEUP=7
+CONFIG_IRQ_RTC=8
+CONFIG_IRQ_PPI=8
+CONFIG_IRQ_SPORT0_RX=9
+CONFIG_IRQ_SPORT0_TX=9
+CONFIG_IRQ_SPORT1_RX=9
+CONFIG_IRQ_SPORT1_TX=9
+CONFIG_IRQ_TWI=10
+CONFIG_IRQ_SPI=10
+CONFIG_IRQ_UART0_RX=10
+CONFIG_IRQ_UART0_TX=10
+CONFIG_IRQ_UART1_RX=10
+CONFIG_IRQ_UART1_TX=10
+CONFIG_IRQ_MAC_RX=11
+CONFIG_IRQ_MAC_TX=11
+CONFIG_IRQ_TMR0=12
+CONFIG_IRQ_TMR1=12
+CONFIG_IRQ_TMR2=12
+CONFIG_IRQ_TMR3=12
+CONFIG_IRQ_TMR4=12
+CONFIG_IRQ_TMR5=12
+CONFIG_IRQ_TMR6=12
+CONFIG_IRQ_TMR7=12
+CONFIG_IRQ_PORTG_INTB=12
+CONFIG_IRQ_MEM_DMA0=13
+CONFIG_IRQ_MEM_DMA1=13
+CONFIG_IRQ_WATCH=13
+# CONFIG_BFIN537_STAMP is not set
+# CONFIG_BFIN537_BLUETECHNIX_CM is not set
+CONFIG_BFIN537_BLUETECHNIX_TCM=y
+# CONFIG_PNAV10 is not set
+# CONFIG_CAMSIG_MINOTAUR is not set
+# CONFIG_GENERIC_BF537_BOARD is not set
+
+#
+# BF537 Specific Configuration
+#
+
+#
+# Interrupt Priority Assignment
+#
+
+#
+# Priority
+#
+CONFIG_IRQ_DMA_ERROR=7
+CONFIG_IRQ_ERROR=7
+CONFIG_IRQ_CAN_RX=11
+CONFIG_IRQ_CAN_TX=11
+CONFIG_IRQ_PROG_INTA=12
+
+#
+# Board customizations
+#
+# CONFIG_CMDLINE_BOOL is not set
+CONFIG_BOOT_LOAD=0x1000
+
+#
+# Clock/PLL Setup
+#
+CONFIG_CLKIN_HZ=25000000
+# CONFIG_BFIN_KERNEL_CLOCK is not set
+CONFIG_MAX_MEM_SIZE=32
+CONFIG_MAX_VCO_HZ=600000000
+CONFIG_MIN_VCO_HZ=50000000
+CONFIG_MAX_SCLK_HZ=133333333
+CONFIG_MIN_SCLK_HZ=27000000
+
+#
+# Kernel Timer/Scheduler
+#
+# CONFIG_HZ_100 is not set
+CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
+# CONFIG_HZ_1000 is not set
+CONFIG_HZ=250
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+# CONFIG_CYCLES_CLOCKSOURCE is not set
+# CONFIG_TICK_ONESHOT is not set
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+
+#
+# Misc
+#
+CONFIG_BFIN_SCRATCH_REG_RETN=y
+# CONFIG_BFIN_SCRATCH_REG_RETE is not set
+# CONFIG_BFIN_SCRATCH_REG_CYCLES is not set
+
+#
+# Blackfin Kernel Optimizations
+#
+
+#
+# Memory Optimizations
+#
+CONFIG_I_ENTRY_L1=y
+CONFIG_EXCPT_IRQ_SYSC_L1=y
+CONFIG_DO_IRQ_L1=y
+CONFIG_CORE_TIMER_IRQ_L1=y
+CONFIG_IDLE_L1=y
+CONFIG_SCHEDULE_L1=y
+CONFIG_ARITHMETIC_OPS_L1=y
+CONFIG_ACCESS_OK_L1=y
+CONFIG_MEMSET_L1=y
+CONFIG_MEMCPY_L1=y
+CONFIG_SYS_BFIN_SPINLOCK_L1=y
+CONFIG_IP_CHECKSUM_L1=y
+CONFIG_CACHELINE_ALIGNED_L1=y
+CONFIG_SYSCALL_TAB_L1=y
+CONFIG_CPLB_SWITCH_TAB_L1=y
+CONFIG_RAMKERNEL=y
+# CONFIG_ROMKERNEL is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+# CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_VIRT_TO_BUS=y
+# CONFIG_BFIN_GPTIMERS is not set
+CONFIG_BFIN_DMA_5XX=y
+# CONFIG_DMA_UNCACHED_4M is not set
+# CONFIG_DMA_UNCACHED_2M is not set
+CONFIG_DMA_UNCACHED_1M=y
+# CONFIG_DMA_UNCACHED_NONE is not set
+
+#
+# Cache Support
+#
+CONFIG_BFIN_ICACHE=y
+CONFIG_BFIN_DCACHE=y
+# CONFIG_BFIN_DCACHE_BANKA is not set
+# CONFIG_BFIN_ICACHE_LOCK is not set
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
+# CONFIG_MPU is not set
+
+#
+# Asynchonous Memory Configuration
+#
+
+#
+# EBIU_AMGCTL Global Control
+#
+CONFIG_C_AMCKEN=y
+CONFIG_C_CDPRIO=y
+# CONFIG_C_AMBEN is not set
+# CONFIG_C_AMBEN_B0 is not set
+# CONFIG_C_AMBEN_B0_B1 is not set
+# CONFIG_C_AMBEN_B0_B1_B2 is not set
+CONFIG_C_AMBEN_ALL=y
+
+#
+# EBIU_AMBCTL Control
+#
+CONFIG_BANK_0=0x7BB0
+CONFIG_BANK_1=0x7BB0
+CONFIG_BANK_2=0x7BB0
+CONFIG_BANK_3=0xFFC2
+
+#
+# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
+#
+# CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF_FDPIC=y
+CONFIG_BINFMT_FLAT=y
+CONFIG_BINFMT_ZFLAT=y
+CONFIG_BINFMT_SHARED_FLAT=y
+# CONFIG_BINFMT_MISC is not set
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
+# CONFIG_PM_WAKEUP_BY_GPIO is not set
+
+#
+# CPU Frequency scaling
+#
+# CONFIG_CPU_FREQ is not set
+
+#
+# Networking
+#
+# CONFIG_NET is not set
+
+#
+# Device Drivers
+#
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+# CONFIG_MTD_CMDLINE_PARTS is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+# CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
+
+#
+# RAM/ROM/Flash chip drivers
+#
+# CONFIG_MTD_CFI is not set
+# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_MAP_BANK_WIDTH_1=y
+CONFIG_MTD_MAP_BANK_WIDTH_2=y
+CONFIG_MTD_MAP_BANK_WIDTH_4=y
+# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
+# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
+CONFIG_MTD_CFI_I1=y
+CONFIG_MTD_CFI_I2=y
+# CONFIG_MTD_CFI_I4 is not set
+# CONFIG_MTD_CFI_I8 is not set
+CONFIG_MTD_RAM=y
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_GPIO_ADDR is not set
+CONFIG_MTD_UCLINUX=y
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+# CONFIG_MTD_MTDRAM is not set
+# CONFIG_MTD_BLOCK2MTD is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOC2001PLUS is not set
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
+# CONFIG_IDE is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+# CONFIG_SCSI is not set
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
+# CONFIG_MD is not set
+# CONFIG_PHONE is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+# CONFIG_SERIO is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_AD9960 is not set
+# CONFIG_SPI_ADC_BF533 is not set
+# CONFIG_BF5xx_PPIFCD is not set
+# CONFIG_BFIN_SIMPLE_TIMER is not set
+# CONFIG_BF5xx_PPI is not set
+CONFIG_BFIN_SPORT=y
+# CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_SIMPLE_GPIO is not set
+# CONFIG_VT is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_BFIN=y
+CONFIG_SERIAL_BFIN_CONSOLE=y
+CONFIG_SERIAL_BFIN_DMA=y
+# CONFIG_SERIAL_BFIN_PIO is not set
+CONFIG_SERIAL_BFIN_UART0=y
+# CONFIG_BFIN_UART0_CTSRTS is not set
+CONFIG_SERIAL_BFIN_UART1=y
+# CONFIG_BFIN_UART1_CTSRTS is not set
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_BFIN_SPORT is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_LEGACY_PTYS is not set
+
+#
+# CAN, the car bus and industrial fieldbus
+#
+# CONFIG_CAN4LINUX is not set
+# CONFIG_IPMI_HANDLER is not set
+# CONFIG_HW_RANDOM is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
+# CONFIG_TCG_TPM is not set
+# CONFIG_I2C is not set
+
+#
+# SPI support
+#
+CONFIG_SPI=y
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_AT25 is not set
+# CONFIG_SPI_SPIDEV is not set
+# CONFIG_SPI_TLE62X0 is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
+
+#
+# Sonics Silicon Backplane
+#
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+# CONFIG_DAB is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
+# CONFIG_FB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Userspace I/O
+#
+# CONFIG_UIO is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+# CONFIG_EXT2_FS_POSIX_ACL is not set
+# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+# CONFIG_FS_POSIX_ACL is not set
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_DNOTIFY is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+
+#
+# CD-ROM/DVD Filesystems
+#
+# CONFIG_ISO9660_FS is not set
+# CONFIG_UDF_FS is not set
+
+#
+# DOS/FAT/NT Filesystems
+#
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_NTFS_FS is not set
+
+#
+# Pseudo filesystems
+#
+CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+# CONFIG_TMPFS is not set
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+
+#
+# Miscellaneous filesystems
+#
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_YAFFS_FS is not set
+# CONFIG_JFFS2_FS is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+# CONFIG_INSTRUMENTATION is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_SAMPLES is not set
+CONFIG_DEBUG_MMRS=y
+CONFIG_DEBUG_HUNT_FOR_ZERO=y
+CONFIG_DEBUG_BFIN_HWTRACE_ON=y
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_OFF=y
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_ONE is not set
+# CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION_TWO is not set
+CONFIG_DEBUG_BFIN_HWTRACE_COMPRESSION=0
+# CONFIG_DEBUG_BFIN_HWTRACE_EXPAND is not set
+# CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
+# CONFIG_EARLY_PRINTK is not set
+CONFIG_CPLB_INFO=y
+CONFIG_ACCESS_CHECK=y
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+CONFIG_SECURITY=y
+# CONFIG_SECURITY_NETWORK is not set
+CONFIG_SECURITY_CAPABILITIES=y
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+# CONFIG_CRC32 is not set
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arch/blackfin/kernel/cplb-mpu/cacheinit.c
b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
index 9eecfa4..a8b712a 100644
--- a/arch/blackfin/kernel/cplb-mpu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cacheinit.c
@@ -25,7 +25,7 @@
 #include <asm/cplbinit.h>

 #if defined(CONFIG_BFIN_ICACHE)
-void bfin_icache_init(void)
+void __init bfin_icache_init(void)
 {
 	unsigned long ctrl;
 	int i;
@@ -43,7 +43,7 @@ void bfin_icache_init(void)
 #endif

 #if defined(CONFIG_BFIN_DCACHE)
-void bfin_dcache_init(void)
+void __init bfin_dcache_init(void)
 {
 	unsigned long ctrl;
 	int i;
diff --git a/arch/blackfin/kernel/cplb-nompu/cacheinit.c
b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
index 8a18399..bd08315 100644
--- a/arch/blackfin/kernel/cplb-nompu/cacheinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cacheinit.c
@@ -25,7 +25,7 @@
 #include <asm/cplbinit.h>

 #if defined(CONFIG_BFIN_ICACHE)
-void bfin_icache_init(void)
+void __init bfin_icache_init(void)
 {
 	unsigned long *table = icplb_table;
 	unsigned long ctrl;
@@ -47,7 +47,7 @@ void bfin_icache_init(void)
 #endif

 #if defined(CONFIG_BFIN_DCACHE)
-void bfin_dcache_init(void)
+void __init bfin_dcache_init(void)
 {
 	unsigned long *table = dcplb_table;
 	unsigned long ctrl;
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 224e7cc..728f708 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -164,17 +164,13 @@ static struct cplb_desc cplb_data[] = {
 		.name = "Asynchronous Memory Banks",
 	},
 	{
-#ifdef L2_START
 		.start = L2_START,
 		.end = L2_START + L2_LENGTH,
 		.psize = SIZE_1M,
 		.attr = SWITCH_T | I_CPLB | D_CPLB,
 		.i_conf = L2_MEMORY,
 		.d_conf = L2_MEMORY,
-		.valid = 1,
-#else
-		.valid = 0,
-#endif
+		.valid = (L2_LENGTH > 0),
 		.name = "L2 Memory",
 	},
 	{
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 23e637e..7a82d10 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -52,6 +52,7 @@ EXPORT_SYMBOL(mtd_size);
 #endif

 char __initdata command_line[COMMAND_LINE_SIZE];
+unsigned int __initdata *__retx;

 /* boot memmap, for parsing "memmap=" */
 #define BFIN_MEMMAP_MAX		128 /* number of entries in bfin_memmap */
@@ -131,14 +132,14 @@ void __init bf53x_relocate_l1_mem(void)
 	dma_memcpy(_sdata_b_l1, _l1_lma_start + l1_code_length +
 			l1_data_a_length, l1_data_b_length);

-#ifdef L2_LENGTH
-	l2_length = _ebss_l2 - _stext_l2;
-	if (l2_length > L2_LENGTH)
-		panic("L2 SRAM Overflow\n");
+	if (L2_LENGTH != 0) {
+		l2_length = _ebss_l2 - _stext_l2;
+		if (l2_length > L2_LENGTH)
+			panic("L2 SRAM Overflow\n");

-	/* Copy _stext_l2 to _edata_l2 to L2 SRAM */
-	dma_memcpy(_stext_l2, _l2_lma_start, l2_length);
-#endif
+		/* Copy _stext_l2 to _edata_l2 to L2 SRAM */
+		dma_memcpy(_stext_l2, _l2_lma_start, l2_length);
+	}
 }

 /* add_memory_region to memmap */
@@ -738,6 +739,16 @@ void __init setup_arch(char **cmdline_p)

 	memory_setup();

+	/* Initialize Async memory banks */
+	bfin_write_EBIU_AMBCTL0(AMBCTL0VAL);
+	bfin_write_EBIU_AMBCTL1(AMBCTL1VAL);
+	bfin_write_EBIU_AMGCTL(AMGCTLVAL);
+#ifdef CONFIG_EBIU_MBSCTLVAL
+	bfin_write_EBIU_MBSCTL(CONFIG_EBIU_MBSCTLVAL);
+	bfin_write_EBIU_MODE(CONFIG_EBIU_MODEVAL);
+	bfin_write_EBIU_FCTL(CONFIG_EBIU_FCTLVAL);
+#endif
+
 	cclk = get_cclk();
 	sclk = get_sclk();

@@ -775,7 +786,11 @@ void __init setup_arch(char **cmdline_p)
 	bfin_write_SWRST(DOUBLE_FAULT);

 	if (_bfin_swrst & RESET_DOUBLE)
-		printk(KERN_INFO "Recovering from Double Fault event\n");
+		/*
+		 * don't decode the address, since you don't know if this
+		 * kernel's symbol map is the same as the crashing kernel
+		 */
+		printk(KERN_INFO "Recovering from Double Fault event at %pF\n", __retx);
 	else if (_bfin_swrst & RESET_WDOG)
 		printk(KERN_INFO "Recovering from Watchdog event\n");
 	else if (_bfin_swrst & RESET_SOFTWARE)
@@ -1049,7 +1064,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		   dsup_banks, BFIN_DSUBBANKS, BFIN_DWAYS,
 		   BFIN_DLINES);
 #ifdef CONFIG_BFIN_ICACHE_LOCK
-	switch (read_iloc()) {
+	switch ((bfin_read_IMEM_CONTROL() >> 3) & WAYALL_L) {
 	case WAY0_L:
 		seq_printf(m, "Way0 Locked-Down\n");
 		break;
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index ad922ab..9a9d508 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -567,7 +567,7 @@ bool get_instruction(unsigned short *val, unsigned
short *address)
 	 * we don't read something in the async space that can hang forever
 	 */
 	if ((addr >= FIXED_CODE_START && (addr + 2) <= physical_mem_end) ||
-#ifdef L2_START
+#if L2_LENGTH != 0
 	    (addr >= L2_START && (addr + 2) <= (L2_START + L2_LENGTH)) ||
 #endif
 	    (addr >= BOOT_ROM_START && (addr + 2) <= (BOOT_ROM_START +
BOOT_ROM_LENGTH)) ||
@@ -601,12 +601,55 @@ bool get_instruction(unsigned short *val,
unsigned short *address)
 	return false;
 }

+/*
+ * decode the instruction if we are printing out the trace, as it
+ * makes things easier to follow, without running it through objdump
+ * These are the normal instructions which cause change of flow, which
+ * would be at the source of the trace buffer
+ */
+void decode_instruction(unsigned short *address)
+{
+	unsigned short opcode;
+
+	if (get_instruction(&opcode, address)) {
+		if (opcode == 0x0010)
+			printk("RTS");
+		else if (opcode == 0x0011)
+			printk("RTI");
+		else if (opcode == 0x0012)
+			printk("RTX");
+		else if (opcode >= 0x0050 && opcode <= 0x0057)
+			printk("JUMP (P%i)", opcode & 7);
+		else if (opcode >= 0x0060 && opcode <= 0x0067)
+			printk("CALL (P%i)", opcode & 7);
+		else if (opcode >= 0x0070 && opcode <= 0x0077)
+			printk("CALL (PC+P%i)", opcode & 7);
+		else if (opcode >= 0x0080 && opcode <= 0x0087)
+			printk("JUMP (PC+P%i)", opcode & 7);
+		else if ((opcode >= 0x1000 && opcode <= 0x13FF) || (opcode >=
0x1800 && opcode <= 0x1BFF))
+			printk("IF !CC JUMP");
+		else if ((opcode >= 0x1400 && opcode <= 0x17ff) || (opcode >=
0x1c00 && opcode <= 0x1fff))
+			printk("IF CC JUMP");
+		else if (opcode >= 0x2000 && opcode <= 0x2fff)
+			printk("JUMP.S");
+		else if (opcode >= 0xe080 && opcode <= 0xe0ff)
+			printk("LSETUP");
+		else if (opcode >= 0xe200 && opcode <= 0xe2ff)
+			printk("JUMP.L");
+		else if (opcode >= 0xe300 && opcode <= 0xe3ff)
+			printk("CALL pcrel");
+		else
+			printk("0x%04x", opcode);
+	}
+
+}
+
 void dump_bfin_trace_buffer(void)
 {
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
 	int tflags, i = 0;
 	char buf[150];
-	unsigned short val = 0, *addr;
+	unsigned short *addr;
 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
 	int j, index;
 #endif
@@ -615,6 +658,10 @@ void dump_bfin_trace_buffer(void)

 	printk(KERN_NOTICE "Hardware Trace:\n");

+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
+	printk(KERN_NOTICE "WARNING: Expanded trace turned on - can not
trace exceptions\n");
+#endif
+
 	if (likely(bfin_read_TBUFSTAT() & TBUFCNT)) {
 		for (; bfin_read_TBUFSTAT() & TBUFCNT; i++) {
 			decode_address(buf, (unsigned long)bfin_read_TBUF());
@@ -622,45 +669,14 @@ void dump_bfin_trace_buffer(void)
 			addr = (unsigned short *)bfin_read_TBUF();
 			decode_address(buf, (unsigned long)addr);
 			printk(KERN_NOTICE "     Source : %s ", buf);
-			if (get_instruction(&val, addr)) {
-				if (val == 0x0010)
-					printk("RTS");
-				else if (val == 0x0011)
-					printk("RTI");
-				else if (val == 0x0012)
-					printk("RTX");
-				else if (val >= 0x0050 && val <= 0x0057)
-					printk("JUMP (P%i)", val & 7);
-				else if (val >= 0x0060 && val <= 0x0067)
-					printk("CALL (P%i)", val & 7);
-				else if (val >= 0x0070 && val <= 0x0077)
-					printk("CALL (PC+P%i)", val & 7);
-				else if (val >= 0x0080 && val <= 0x0087)
-					printk("JUMP (PC+P%i)", val & 7);
-				else if ((val >= 0x1000 && val <= 0x13FF) ||
-				    (val >= 0x1800 && val <= 0x1BFF))
-					printk("IF !CC JUMP");
-				else if ((val >= 0x1400 && val <= 0x17ff) ||
-				    (val >= 0x1c00 && val <= 0x1fff))
-					printk("IF CC JUMP");
-				else if (val >= 0x2000 && val <= 0x2fff)
-					printk("JUMP.S");
-				else if (val >= 0xe080 && val <= 0xe0ff)
-					printk("LSETUP");
-				else if (val >= 0xe200 && val <= 0xe2ff)
-					printk("JUMP.L");
-				else if (val >= 0xe300 && val <= 0xe3ff)
-					printk("CALL pcrel");
-				else
-					printk("0x%04x", val);
-			}
+			decode_instruction(addr);
 			printk("\n");
 		}
 	}

 #ifdef CONFIG_DEBUG_BFIN_HWTRACE_EXPAND
 	if (trace_buff_offset)
-		index = trace_buff_offset/4 - 1;
+		index = trace_buff_offset / 4;
 	else
 		index = EXPAND_LEN;

@@ -672,7 +688,9 @@ void dump_bfin_trace_buffer(void)
 		if (index < 0 )
 			index = EXPAND_LEN;
 		decode_address(buf, software_trace_buff[index]);
-		printk(KERN_NOTICE "     Source : %s\n", buf);
+		printk(KERN_NOTICE "     Source : %s ", buf);
+		decode_instruction((unsigned short *)software_trace_buff[index]);
+		printk("\n");
 		index -= 1;
 		if (index < 0)
 			index = EXPAND_LEN;
diff --git a/arch/blackfin/kernel/vmlinux.lds.S
b/arch/blackfin/kernel/vmlinux.lds.S
index 0896e38..7d12c66 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -83,6 +83,7 @@ SECTIONS
 #if !L1_DATA_B_LENGTH
 		*(.l1.bss.B)
 #endif
+		. = ALIGN(4);
 		___bss_stop = .;
 	}

@@ -101,7 +102,7 @@ SECTIONS
 #if !L1_DATA_B_LENGTH
 		*(.l1.data.B)
 #endif
-#ifndef L2_LENGTH
+#if !L2_LENGTH
 		. = ALIGN(32);
 		*(.data_l2.cacheline_aligned)
 		*(.l2.data)
@@ -211,20 +212,19 @@ SECTIONS
 		__ebss_b_l1 = .;
 	}

-#ifdef L2_LENGTH
 	__l2_lma_start = .;

 	.text_data_l2 L2_START : AT(LOADADDR(.data_b_l1) + SIZEOF(.data_b_l1))
 	{
 		. = ALIGN(4);
 		__stext_l2 = .;
-		*(.l1.text)
+		*(.l2.text)
 		. = ALIGN(4);
 		__etext_l2 = .;

 		. = ALIGN(4);
 		__sdata_l2 = .;
-		*(.l1.data)
+		*(.l2.data)
 		__edata_l2 = .;

 		. = ALIGN(32);
@@ -232,11 +232,10 @@ SECTIONS

 		. = ALIGN(4);
 		__sbss_l2 = .;
-		*(.l1.bss)
+		*(.l2.bss)
 		. = ALIGN(4);
 		__ebss_l2 = .;
 	}
-#endif

 	/* Force trailing alignment of our init section so that when we
 	 * free our init memory, we don't leave behind a partial page.
diff --git a/arch/blackfin/lib/ins.S b/arch/blackfin/lib/ins.S
index eba2343..d60554d 100644
--- a/arch/blackfin/lib/ins.S
+++ b/arch/blackfin/lib/ins.S
@@ -33,7 +33,28 @@

 .align 2

+/*
+ * Reads on the Blackfin are speculative. In Blackfin terms, this means they
+ * can be interrupted at any time (even after they have been issued on to the
+ * external bus), and re-issued after the interrupt occurs.
+ *
+ * If a FIFO is sitting on the end of the read, it will see two reads,
+ * when the core only sees one. The FIFO receives the read which is cancelled,
+ * and not delivered to the core.
+ *
+ * To solve this, interrupts are turned off before reads occur to I/O space.
+ * There are 3 versions of all these functions
+ *  - turns interrupts off every read (higher overhead, but lower latency)
+ *  - turns interrupts off every loop (low overhead, but longer latency)
+ *  - DMA version, which do not suffer from this issue. DMA versions have
+ *      different name (prefixed by dma_ ), and are located in
+ *      ../kernel/bfin_dma_5xx.c
+ * Using the dma related functions are recommended for transfering large
+ * buffers in/out of FIFOs.
+ */
+
 ENTRY(_insl)
+#ifdef CONFIG_BFIN_INS_LOWOVERHEAD
 	P0 = R0;	/* P0 = port */
 	cli R3;
 	P1 = R1;	/* P1 = address */
@@ -46,9 +67,26 @@ ENTRY(_insl)
 .Llong_loop_e: 	NOP;
 	sti R3;
 	RTS;
+#else
+	P0 = R0;	/* P0 = port */
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Llong_loop_s, .Llong_loop_e) LC0 = P2;
+.Llong_loop_s:
+	CLI R3;
+	NOP; NOP; NOP;
+	R0 = [P0];
+	[P1++] = R0;
+.Llong_loop_e:
+	STI R3;
+
+	RTS;
+#endif
 ENDPROC(_insl)

 ENTRY(_insw)
+#ifdef CONFIG_BFIN_INS_LOWOVERHEAD
 	P0 = R0;	/* P0 = port */
 	cli R3;
 	P1 = R1;	/* P1 = address */
@@ -61,9 +99,26 @@ ENTRY(_insw)
 .Lword_loop_e: 	NOP;
 	sti R3;
 	RTS;
+#else
+	P0 = R0;	/* P0 = port */
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Lword_loop_s, .Lword_loop_e) LC0 = P2;
+.Lword_loop_s:
+	CLI R3;
+	NOP; NOP; NOP;
+	R0 = W[P0];
+	W[P1++] = R0;
+.Lword_loop_e:
+	STI R3;
+	RTS;
+
+#endif
 ENDPROC(_insw)

 ENTRY(_insw_8)
+#ifdef CONFIG_BFIN_INS_LOWOVERHEAD
 	P0 = R0;	/* P0 = port */
 	cli R3;
 	P1 = R1;	/* P1 = address */
@@ -78,9 +133,29 @@ ENTRY(_insw_8)
 .Lword8_loop_e: NOP;
 	sti R3;
 	RTS;
+#else
+	P0 = R0;	/* P0 = port */
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Lword8_loop_s, .Lword8_loop_e) LC0 = P2;
+.Lword8_loop_s:
+	CLI R3;
+	NOP; NOP; NOP;
+	R0 = W[P0];
+	B[P1++] = R0;
+	R0 = R0 >> 8;
+	B[P1++] = R0;
+	NOP;
+.Lword8_loop_e:
+	STI R3;
+
+	RTS;
+#endif
 ENDPROC(_insw_8)

 ENTRY(_insb)
+#ifdef CONFIG_BFIN_INS_LOWOVERHEAD
 	P0 = R0;	/* P0 = port */
 	cli R3;
 	P1 = R1;	/* P1 = address */
@@ -93,9 +168,26 @@ ENTRY(_insb)
 .Lbyte_loop_e:  NOP;
 	sti R3;
 	RTS;
+#else
+	P0 = R0;        /* P0 = port */
+	P1 = R1;        /* P1 = address */
+	P2 = R2;        /* P2 = count */
+	SSYNC;
+	LSETUP( .Lbyte_loop_s, .Lbyte_loop_e) LC0 = P2;
+.Lbyte_loop_s:
+	CLI R3;
+	NOP; NOP; NOP;
+	R0 = B[P0];
+	B[P1++] = R0;
+.Lbyte_loop_e:
+	STI R3;
+
+	RTS;
+#endif
 ENDPROC(_insb)

 ENTRY(_insl_16)
+#ifdef CONFIG_BFIN_INS_LOWOVERHEAD
 	P0 = R0;	/* P0 = port */
 	cli R3;
 	P1 = R1;	/* P1 = address */
@@ -110,4 +202,21 @@ ENTRY(_insl_16)
 .Llong16_loop_e:  NOP;
 	sti R3;
 	RTS;
+#else
+	P0 = R0;	/* P0 = port */
+	P1 = R1;	/* P1 = address */
+	P2 = R2;	/* P2 = count */
+	SSYNC;
+	LSETUP( .Llong16_loop_s, .Llong16_loop_e) LC0 = P2;
+.Llong16_loop_s:
+	CLI R3;
+	NOP; NOP; NOP;
+	R0 = [P0];
+	W[P1++] = R0;
+	R0 = R0 >> 16;
+	W[P1++] = R0;
+.Llong16_loop_e:
+	STI R3;
+	RTS;
+#endif
 ENDPROC(_insl_16)
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c
b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 0b26ae2..d22bc77 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -39,7 +39,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/pata_platform.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
@@ -160,15 +159,15 @@ static struct platform_device musb_device = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition ezkit_partitions[] = {
 	{
-		.name       = "Bootloader",
+		.name       = "bootloader(nor)",
 		.size       = 0x40000,
 		.offset     = 0,
 	}, {
-		.name       = "Kernel",
+		.name       = "linux kernel(nor)",
 		.size       = 0x1C0000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "RootFS",
+		.name       = "file system(nor)",
 		.size       = MTDPART_SIZ_FULL,
 		.offset     = MTDPART_OFS_APPEND,
 	}
@@ -200,12 +199,12 @@ static struct platform_device ezkit_flash_device = {
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
-		.name = "Linux Kernel",
+		.name = "linux kernel(nand)",
 		.offset = 0,
 		.size = 4 * SIZE_1M,
 	},
 	{
-		.name = "File System",
+		.name = "file system(nand)",
 		.offset = MTDPART_OFS_APPEND,
 		.size = MTDPART_SIZ_FULL,
 	},
@@ -438,12 +437,12 @@ static struct platform_device net2272_bfin_device = {
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "linux kernel",
+		.name = "linux kernel(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -799,43 +798,6 @@ static struct platform_device bfin_sport1_uart_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -961,10 +923,6 @@ static struct platform_device *stamp_devices[]
__initdata = {
 	&bfin_sport1_uart_device,
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
@@ -987,10 +945,6 @@ static int __init stamp_init(void)

 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c
b/arch/blackfin/mach-bf527/boards/ezkit.c
index 689b69c..762f754 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -38,7 +38,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/i2c.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
@@ -177,15 +176,15 @@ static struct platform_device bf52x_t350mcqb_device = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition ezkit_partitions[] = {
 	{
-		.name       = "Bootloader",
+		.name       = "bootloader(nor)",
 		.size       = 0x40000,
 		.offset     = 0,
 	}, {
-		.name       = "Kernel",
+		.name       = "linux kernel(nor)",
 		.size       = 0x1C0000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "RootFS",
+		.name       = "file system(nor)",
 		.size       = MTDPART_SIZ_FULL,
 		.offset     = MTDPART_OFS_APPEND,
 	}
@@ -217,12 +216,12 @@ static struct platform_device ezkit_flash_device = {
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
-		.name = "Linux Kernel",
+		.name = "linux kernel(nand)",
 		.offset = 0,
 		.size = 4 * SIZE_1M,
 	},
 	{
-		.name = "File System",
+		.name = "file system(nand)",
 		.offset = MTDPART_OFS_APPEND,
 		.size = MTDPART_SIZ_FULL,
 	},
@@ -460,12 +459,12 @@ static struct platform_device net2272_bfin_device = {
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "linux kernel",
+		.name = "linux kernel(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -825,43 +824,6 @@ static struct platform_device bfin_sport1_uart_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -996,10 +958,6 @@ static struct platform_device *stamp_devices[]
__initdata = {
 	&bfin_sport1_uart_device,
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
@@ -1022,10 +980,6 @@ static int __init stamp_init(void)

 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf527/head.S b/arch/blackfin/mach-bf527/head.S
index fe05cc1..c3334cc 100644
--- a/arch/blackfin/mach-bf527/head.S
+++ b/arch/blackfin/mach-bf527/head.S
@@ -30,293 +30,11 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/blackfin.h>
-#include <asm/trace.h>
-
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif

-.extern ___bss_stop
-.extern ___bss_start
-.extern _bf53x_relocate_l1_mem
-
-#define INITIAL_STACK	0xFFB01000
-
-__INIT
-
-ENTRY(__start)
-	/* R0: argument of command line string, passed from uboot, save it */
-	R7 = R0;
-	/* Enable Cycle Counter and Nesting Of Interrupts */
-#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
-	R0 = SYSCFG_SNEN;
-#else
-	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
-#endif
-	SYSCFG = R0;
-	R0 = 0;
-
-	/* Clear Out All the data and pointer Registers */
-	R1 = R0;
-	R2 = R0;
-	R3 = R0;
-	R4 = R0;
-	R5 = R0;
-	R6 = R0;
-
-	P0 = R0;
-	P1 = R0;
-	P2 = R0;
-	P3 = R0;
-	P4 = R0;
-	P5 = R0;
-
-	LC0 = r0;
-	LC1 = r0;
-	L0 = r0;
-	L1 = r0;
-	L2 = r0;
-	L3 = r0;
-
-	/* Clear Out All the DAG Registers */
-	B0 = r0;
-	B1 = r0;
-	B2 = r0;
-	B3 = r0;
-
-	I0 = r0;
-	I1 = r0;
-	I2 = r0;
-	I3 = r0;
-
-	M0 = r0;
-	M1 = r0;
-	M2 = r0;
-	M3 = r0;
-
-	trace_buffer_init(p0,r0);
-	P0 = R1;
-	R0 = R1;
-
-	/* Turn off the icache */
-	p0.l = LO(IMEM_CONTROL);
-	p0.h = HI(IMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENICPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Turn off the dcache */
-	p0.l = LO(DMEM_CONTROL);
-	p0.h = HI(DMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENDCPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-
-#if defined(CONFIG_BF527)
-	p0.h = hi(EMAC_SYSTAT);
-	p0.l = lo(EMAC_SYSTAT);
-	R0.h = 0xFFFF; /* Clear EMAC Interrupt Status bits */
-	R0.l = 0xFFFF;
-	[P0] = R0;
-	SSYNC;
-#endif
-
-	/* Initialise UART - when booting from u-boot, the UART is not disabled
-	 * so if we dont initalize here, our serial console gets hosed */
-	p0.h = hi(UART1_LCR);
-	p0.l = lo(UART1_LCR);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable DLL writes */
-	ssync;
-
-	p0.h = hi(UART1_DLL);
-	p0.l = lo(UART1_DLL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(UART1_DLH);
-	p0.l = lo(UART1_DLH);
-	r0 = 0x00(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(UART1_GCTL);
-	p0.l = lo(UART1_GCTL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable UART clock */
-	ssync;
-
-	/* Initialize stack pointer */
-	sp.l = lo(INITIAL_STACK);
-	sp.h = hi(INITIAL_STACK);
-	fp = sp;
-	usp = sp;
-
-#ifdef CONFIG_EARLY_PRINTK
-	SP += -12;
-	call _init_early_exception_vectors;
-	SP += 12;
-#endif
-
-	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
-	call _bf53x_relocate_l1_mem;
-#ifdef CONFIG_BFIN_KERNEL_CLOCK
-	call _start_dma_code;
-#endif
-
-	/* Code for initializing Async memory banks */
-
-	p2.h = hi(EBIU_AMBCTL1);
-	p2.l = lo(EBIU_AMBCTL1);
-	r0.h = hi(AMBCTL1VAL);
-	r0.l = lo(AMBCTL1VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMBCTL0);
-	p2.l = lo(EBIU_AMBCTL0);
-	r0.h = hi(AMBCTL0VAL);
-	r0.l = lo(AMBCTL0VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMGCTL);
-	p2.l = lo(EBIU_AMGCTL);
-	r0 = AMGCTLVAL;
-	w[p2] = r0;
-	ssync;
-
-	/* This section keeps the processor in supervisor mode
-	 * during kernel boot.  Switches to user mode at end of boot.
-	 * See page 3-9 of Hardware Reference manual for documentation.
-	 */
-
-	/* EVT15 = _real_start */
-
-	p0.l = lo(EVT15);
-	p0.h = hi(EVT15);
-	p1.l = _real_start;
-	p1.h = _real_start;
-	[p0] = p1;
-	csync;
-
-	p0.l = lo(IMASK);
-	p0.h = hi(IMASK);
-	p1.l = IMASK_IVG15;
-	p1.h = 0x0;
-	[p0] = p1;
-	csync;
-
-	raise 15;
-	p0.l = .LWAIT_HERE;
-	p0.h = .LWAIT_HERE;
-	reti = p0;
-#if ANOMALY_05000281
-	nop; nop; nop;
-#endif
-	rti;
-
-.LWAIT_HERE:
-	jump .LWAIT_HERE;
-ENDPROC(__start)
-
-ENTRY(_real_start)
-	[ -- sp ] = reti;
-	p0.l = lo(WDOG_CTL);
-	p0.h = hi(WDOG_CTL);
-	r0 = 0xAD6(z);
-	w[p0] = r0;	/* watchdog off for now */
-	ssync;
-
-	/* Code update for BSS size == 0
-	 * Zero out the bss region.
-	 */
-
-	p1.l = ___bss_start;
-	p1.h = ___bss_start;
-	p2.l = ___bss_stop;
-	p2.h = ___bss_stop;
-	r0 = 0;
-	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
-.L_clear_bss:
-	B[p1++] = r0;
-
-	/* In case there is a NULL pointer reference
-	 * Zero out region before stext
-	 */
-
-	p1.l = 0x0;
-	p1.h = 0x0;
-	r0.l = __stext;
-	r0.h = __stext;
-	r0 = r0 >> 1;
-	p2 = r0;
-	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
-.L_clear_zero:
-	W[p1++] = r0;
-
-	/* pass the uboot arguments to the global value command line */
-	R0 = R7;
-	call _cmdline_init;
-
-	p1.l = __rambase;
-	p1.h = __rambase;
-	r0.l = __sdata;
-	r0.h = __sdata;
-	[p1] = r0;
-
-	p1.l = __ramstart;
-	p1.h = __ramstart;
-	p3.l = ___bss_stop;
-	p3.h = ___bss_stop;
-
-	r1 = p3;
-	[p1] = r1;
-
-	/*
-	 * load the current thread pointer and stack
-	 */
-	r1.l = _init_thread_union;
-	r1.h = _init_thread_union;
-
-	r2.l = 0x2000;
-	r2.h = 0x0000;
-	r1 = r1 + r2;
-	sp = r1;
-	usp = sp;
-	fp = sp;
-	jump.l _start_kernel;
-ENDPROC(_real_start)
-
-__FINIT
-
 .section .l1.text
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
@@ -420,13 +138,6 @@ ENTRY(_start_dma_code)
 	[P2] = R1;
 	SSYNC;

-	p0.h = hi(SIC_IWR0);
-	p0.l = lo(SIC_IWR0);
-	r0.l = lo(IWR_ENABLE_ALL);
-	r0.h = hi(IWR_ENABLE_ALL);
-	[p0] = r0;
-	SSYNC;
-
 	RTS;
 ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
diff --git a/arch/blackfin/mach-bf527/ints-priority.c
b/arch/blackfin/mach-bf527/ints-priority.c
index 1fa3897..8a23674 100644
--- a/arch/blackfin/mach-bf527/ints-priority.c
+++ b/arch/blackfin/mach-bf527/ints-priority.c
@@ -31,7 +31,7 @@
 #include <linux/irq.h>
 #include <asm/blackfin.h>

-void program_IAR(void)
+void __init program_IAR(void)
 {
 	/* Program the IAR0 Register with the configured priority */
 	bfin_write_SIC_IAR0(((CONFIG_IRQ_PLL_WAKEUP - 7) << IRQ_PLL_WAKEUP_POS) |
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c
b/arch/blackfin/mach-bf533/boards/H8606.c
index 4103a97..c66a68f 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -38,7 +38,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/irq.h>

 #include <asm/dma.h>
@@ -141,16 +140,16 @@ static struct platform_device net2272_bfin_device = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00060000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0x100000,
 		.offset = 0x60000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x6a0000,
 		.offset = 0x00160000,
 	}
diff --git a/arch/blackfin/mach-bf533/boards/Kconfig
b/arch/blackfin/mach-bf533/boards/Kconfig
index 8400592..308c98d 100644
--- a/arch/blackfin/mach-bf533/boards/Kconfig
+++ b/arch/blackfin/mach-bf533/boards/Kconfig
@@ -14,6 +14,12 @@ config BFIN533_STAMP
 	help
 	  BF533-STAMP board support.

+config BLACKSTAMP
+	bool "BlackStamp"
+	help
+	  Support for the BlackStamp board.  Hardware info available at
+	  http://blackfin.uclinux.org/gf/project/blackstamp/
+
 config BFIN533_BLUETECHNIX_CM
 	bool "Bluetechnix CM-BF533"
 	depends on (BF533)
diff --git a/arch/blackfin/mach-bf533/boards/Makefile
b/arch/blackfin/mach-bf533/boards/Makefile
index b7a1a1d..9afbe72 100644
--- a/arch/blackfin/mach-bf533/boards/Makefile
+++ b/arch/blackfin/mach-bf533/boards/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_BFIN533_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN532_IP0X)             += ip0x.o
 obj-$(CONFIG_BFIN533_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN533_BLUETECHNIX_CM)   += cm_bf533.o
+obj-$(CONFIG_BLACKSTAMP)               += blackstamp.o
 obj-$(CONFIG_H8606_HVSISTEMAS)         += H8606.o
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c
b/arch/blackfin/mach-bf533/boards/blackstamp.c
new file mode 100644
index 0000000..d064ded
--- /dev/null
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -0,0 +1,401 @@
+/*
+ * File:         arch/blackfin/mach-bf533/blackstamp.c
+ * Based on:     arch/blackfin/mach-bf533/stamp.c
+ * Author:       Benjamin Matthews <bmat@lle.rochester.edu>
+ *               Aidan Williams <aidan@nicta.com.au>
+ *
+ * Created:      2008
+ * Description:  Board Info File for the BlackStamp
+ *
+ * Copyright 2005 National ICT Australia (NICTA)
+ * Copyright 2004-2008 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * More info about the BlackStamp at:
+ * 	http://blackfin.uclinux.org/gf/project/blackstamp/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#include <linux/irq.h>
+#include <linux/i2c.h>
+#include <asm/dma.h>
+#include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
+#include <asm/dpmc.h>
+
+/*
+ * Name the Board for the /proc/cpuinfo
+ */
+const char bfin_board_name[] = "BlackStamp";
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+static struct platform_device rtc_device = {
+	.name = "rtc-bfin",
+	.id   = -1,
+};
+#endif
+
+/*
+ *  Driver needs to know address, irq and flag pin.
+ */
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+static struct resource smc91x_resources[] = {
+	{
+		.name = "smc91x-regs",
+		.start = 0x20300300,
+		.end = 0x20300300 + 16,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF3,
+		.end = IRQ_PF3,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader(spi)",
+		.size = 0x00040000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel(spi)",
+		.size = 0x180000,
+		.offset = MTDPART_OFS_APPEND,
+	}, {
+		.name = "file system(spi)",
+		.size = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p64",
+};
+
+/* SPI flash chip (m25p64) */
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
+static struct bfin5xx_spi_chip spidev_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 8,
+};
+#endif
+
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 2, /* Framework chip select. */
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 0,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_SPIDEV) || defined(CONFIG_SPI_SPIDEV_MODULE)
+	{
+		.modalias = "spidev",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 7,
+		.controller_data = &spidev_chip_info,
+	},
+#endif
+};
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = CH_SPI,
+		.end   = CH_SPI,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bfin_spi0_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
+};
+
+static struct platform_device bfin_spi0_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_spi0_info, /* Passed to driver */
+	},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+static struct resource bfin_uart_resources[] = {
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bfin_uart_device = {
+	.name = "bfin-uart",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(bfin_uart_resources),
+	.resource = bfin_uart_resources,
+};
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+static struct resource bfin_sir_resources[] = {
+#ifdef CONFIG_BFIN_SIR0
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+};
+
+static struct platform_device bfin_sir_device = {
+	.name = "bfin_sir",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_sir_resources),
+	.resource = bfin_sir_resources,
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+static struct platform_device bfin_sport0_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 0,
+};
+
+static struct platform_device bfin_sport1_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 1,
+};
+#endif
+
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+static struct gpio_keys_button bfin_gpio_keys_table[] = {
+	{BTN_0, GPIO_PF4, 0, "gpio-keys: BTN0"},
+	{BTN_1, GPIO_PF5, 0, "gpio-keys: BTN1"},
+	{BTN_2, GPIO_PF6, 0, "gpio-keys: BTN2"},
+}; /* Mapped to the first three PF Test Points */
+
+static struct gpio_keys_platform_data bfin_gpio_keys_data = {
+	.buttons        = bfin_gpio_keys_table,
+	.nbuttons       = ARRAY_SIZE(bfin_gpio_keys_table),
+};
+
+static struct platform_device bfin_device_gpiokeys = {
+	.name      = "gpio-keys",
+	.dev = {
+		.platform_data = &bfin_gpio_keys_data,
+	},
+};
+#endif
+
+static struct resource bfin_gpios_resources = {
+	.start = 0,
+	.end   = MAX_BLACKFIN_GPIOS - 1,
+	.flags = IORESOURCE_IRQ,
+};
+
+static struct platform_device bfin_gpios_device = {
+	.name = "simple-gpio",
+	.id = -1,
+	.num_resources = 1,
+	.resource = &bfin_gpios_resources,
+};
+
+#if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
+#include <linux/i2c-gpio.h>
+
+static struct i2c_gpio_platform_data i2c_gpio_data = {
+	.sda_pin		= 8,
+	.scl_pin		= 9,
+	.sda_is_open_drain	= 0,
+	.scl_is_open_drain	= 0,
+	.udelay			= 40,
+}; /* This hasn't actually been used these pins
+    * are (currently) free pins on the expansion connector */
+
+static struct platform_device i2c_gpio_device = {
+	.name		= "i2c-gpio",
+	.id		= 0,
+	.dev		= {
+		.platform_data	= &i2c_gpio_data,
+	},
+};
+#endif
+
+#ifdef CONFIG_I2C_BOARDINFO
+static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
+};
+#endif
+
+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 600000000),
+	VRPAIR(VLEV_125, 600000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
+static struct platform_device *stamp_devices[] __initdata = {
+
+	&bfin_dpmc,
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+	&rtc_device,
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	&smc91x_device,
+#endif
+
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bfin_spi0_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+	&bfin_uart_device,
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+	&bfin_sir_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+	&bfin_sport0_uart_device,
+	&bfin_sport1_uart_device,
+#endif
+
+#if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
+	&bfin_device_gpiokeys,
+#endif
+
+#if defined(CONFIG_I2C_GPIO) || defined(CONFIG_I2C_GPIO_MODULE)
+	&i2c_gpio_device,
+#endif
+
+	&bfin_gpios_device,
+};
+
+static int __init blackstamp_init(void)
+{
+	int ret;
+
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+
+#ifdef CONFIG_I2C_BOARDINFO
+	i2c_register_board_info(0, bfin_i2c_board_info,
+				ARRAY_SIZE(bfin_i2c_board_info));
+#endif
+
+	ret = platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+	if (ret < 0)
+		return ret;
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	/* setup BF533_STAMP CPLD to route AMS3 to Ethernet MAC */
+	bfin_write_FIO_DIR(bfin_read_FIO_DIR() | PF0);
+	bfin_write_FIO_FLAG_S(PF0);
+	SSYNC();
+#endif
+
+	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+	return 0;
+}
+
+arch_initcall(blackstamp_init);
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c
b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index ed2b0b8..575843f 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -36,7 +36,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
@@ -53,16 +52,16 @@ const char bfin_board_name[] = "Bluetechnix CM BF533";
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = 0x20000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x700000,
 		.offset = 0x00100000,
 	}
@@ -307,43 +306,6 @@ static struct platform_device isp1362_hcd_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	38
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 2,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x2030C000,
-		.end = 0x2030C01F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2030D018,
-		.end = 0x2030D01B,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 static const unsigned int cclk_vlev_datasheet[] =
 {
 	VRPAIR(VLEV_085, 250000000),
@@ -403,10 +365,6 @@ static struct platform_device *cm_bf533_devices[]
__initdata = {
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bfin_spi0_device,
 #endif
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
 };

 static int __init cm_bf533_init(void)
@@ -416,10 +374,6 @@ static int __init cm_bf533_init(void)
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c
b/arch/blackfin/mach-bf533/boards/ezkit.c
index 079389c..cc2e7ee 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -37,7 +37,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
@@ -90,16 +89,16 @@ static struct platform_device smc91x_device = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = MTDPART_OFS_APPEND,
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -255,43 +254,6 @@ static struct platform_device bfin_sir_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -404,10 +366,6 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 	&bfin_sir_device,
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
@@ -424,10 +382,6 @@ static int __init ezkit_init(void)
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf533/boards/stamp.c
b/arch/blackfin/mach-bf533/boards/stamp.c
index 13ae495..050ffca 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -38,7 +38,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/i2c.h>
 #include <asm/dma.h>
@@ -114,15 +113,15 @@ static struct platform_device net2272_bfin_device = {
 #if defined(CONFIG_MTD_BFIN_ASYNC) || defined(CONFIG_MTD_BFIN_ASYNC_MODULE)
 static struct mtd_partition stamp_partitions[] = {
 	{
-		.name   = "Bootloader",
+		.name   = "bootloader(nor)",
 		.size   = 0x40000,
 		.offset = 0,
 	}, {
-		.name   = "Kernel",
+		.name   = "linux kernel(nor)",
 		.size   = 0xE0000,
 		.offset = MTDPART_OFS_APPEND,
 	}, {
-		.name   = "RootFS",
+		.name   = "file system(nor)",
 		.size   = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -164,16 +163,16 @@ static struct platform_device stamp_flash_device = {
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = MTDPART_OFS_APPEND,
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
@@ -404,43 +403,6 @@ static struct platform_device bfin_sport1_uart_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -583,10 +545,6 @@ static struct platform_device *stamp_devices[]
__initdata = {
 	&bfin_sport1_uart_device,
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
@@ -625,10 +583,6 @@ static int __init stamp_init(void)
 #endif

 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index c671e85..d59db86 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -30,294 +30,11 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/blackfin.h>
-#include <asm/trace.h>
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif

-.extern ___bss_stop
-.extern ___bss_start
-.extern _bf53x_relocate_l1_mem
-
-#define INITIAL_STACK	0xFFB01000
-
-__INIT
-
-ENTRY(__start)
-	/* R0: argument of command line string, passed from uboot, save it */
-	R7 = R0;
-	/* Enable Cycle Counter and Nesting Of Interrupts */
-#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
-	R0 = SYSCFG_SNEN;
-#else
-	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
-#endif
-	SYSCFG = R0;
-	R0 = 0;
-
-	/* Clear Out All the data and pointer Registers */
-	R1 = R0;
-	R2 = R0;
-	R3 = R0;
-	R4 = R0;
-	R5 = R0;
-	R6 = R0;
-
-	P0 = R0;
-	P1 = R0;
-	P2 = R0;
-	P3 = R0;
-	P4 = R0;
-	P5 = R0;
-
-	LC0 = r0;
-	LC1 = r0;
-	L0 = r0;
-	L1 = r0;
-	L2 = r0;
-	L3 = r0;
-
-	/* Clear Out All the DAG Registers */
-	B0 = r0;
-	B1 = r0;
-	B2 = r0;
-	B3 = r0;
-
-	I0 = r0;
-	I1 = r0;
-	I2 = r0;
-	I3 = r0;
-
-	M0 = r0;
-	M1 = r0;
-	M2 = r0;
-	M3 = r0;
-
-	trace_buffer_init(p0,r0);
-	P0 = R1;
-	R0 = R1;
-
-	p0.h = hi(FIO_MASKA_C);
-	p0.l = lo(FIO_MASKA_C);
-	r0 = 0xFFFF(Z);
-	w[p0] = r0.L;	/* Disable all interrupts */
-	ssync;
-
-	p0.h = hi(FIO_MASKB_C);
-	p0.l = lo(FIO_MASKB_C);
-	r0 = 0xFFFF(Z);
-	w[p0] = r0.L;	/* Disable all interrupts */
-	ssync;
-
-	/* Turn off the icache */
-	p0.l = LO(IMEM_CONTROL);
-	p0.h = HI(IMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENICPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Turn off the dcache */
-	p0.l = LO(DMEM_CONTROL);
-	p0.h = HI(DMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENDCPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Initialise UART - when booting from u-boot, the UART is not disabled
-	 * so if we dont initalize here, our serial console gets hosed */
-	p0.h = hi(BFIN_UART_LCR);
-	p0.l = lo(BFIN_UART_LCR);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable DLL writes */
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLL);
-	p0.l = lo(BFIN_UART_DLL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLH);
-	p0.l = lo(BFIN_UART_DLH);
-	r0 = 0x00(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_GCTL);
-	p0.l = lo(BFIN_UART_GCTL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable UART clock */
-	ssync;
-
-	/* Initialize stack pointer */
-	sp.l = lo(INITIAL_STACK);
-	sp.h = hi(INITIAL_STACK);
-	fp = sp;
-	usp = sp;
-
-#ifdef CONFIG_EARLY_PRINTK
-	SP += -12;
-	call _init_early_exception_vectors;
-	SP += 12;
-#endif
-
-	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
-	call _bf53x_relocate_l1_mem;
-#ifdef CONFIG_BFIN_KERNEL_CLOCK
-	call _start_dma_code;
-#endif
-
-	/* Code for initializing Async memory banks */
-
-	p2.h = hi(EBIU_AMBCTL1);
-	p2.l = lo(EBIU_AMBCTL1);
-	r0.h = hi(AMBCTL1VAL);
-	r0.l = lo(AMBCTL1VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMBCTL0);
-	p2.l = lo(EBIU_AMBCTL0);
-	r0.h = hi(AMBCTL0VAL);
-	r0.l = lo(AMBCTL0VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMGCTL);
-	p2.l = lo(EBIU_AMGCTL);
-	r0 = AMGCTLVAL;
-	w[p2] = r0;
-	ssync;
-
-	/* This section keeps the processor in supervisor mode
-	 * during kernel boot.  Switches to user mode at end of boot.
-	 * See page 3-9 of Hardware Reference manual for documentation.
-	 */
-
-	/* EVT15 = _real_start */
-
-	p0.l = lo(EVT15);
-	p0.h = hi(EVT15);
-	p1.l = _real_start;
-	p1.h = _real_start;
-	[p0] = p1;
-	csync;
-
-	p0.l = lo(IMASK);
-	p0.h = hi(IMASK);
-	p1.l = IMASK_IVG15;
-	p1.h = 0x0;
-	[p0] = p1;
-	csync;
-
-	raise 15;
-	p0.l = .LWAIT_HERE;
-	p0.h = .LWAIT_HERE;
-	reti = p0;
-#if ANOMALY_05000281
-	nop; nop; nop;
-#endif
-	rti;
-
-.LWAIT_HERE:
-	jump .LWAIT_HERE;
-ENDPROC(__start)
-
-ENTRY(_real_start)
-	[ -- sp ] = reti;
-	p0.l = lo(WDOG_CTL);
-	p0.h = hi(WDOG_CTL);
-	r0 = 0xAD6(z);
-	w[p0] = r0;	/* watchdog off for now */
-	ssync;
-
-	/* Code update for BSS size == 0
-	 * Zero out the bss region.
-	 */
-
-	p1.l = ___bss_start;
-	p1.h = ___bss_start;
-	p2.l = ___bss_stop;
-	p2.h = ___bss_stop;
-	r0 = 0;
-	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
-.L_clear_bss:
-	B[p1++] = r0;
-
-	/* In case there is a NULL pointer reference
-	 * Zero out region before stext
-	 */
-
-	p1.l = 0x0;
-	p1.h = 0x0;
-	r0.l = __stext;
-	r0.h = __stext;
-	r0 = r0 >> 1;
-	p2 = r0;
-	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
-.L_clear_zero:
-	W[p1++] = r0;
-
-	/* pass the uboot arguments to the global value command line */
-	R0 = R7;
-	call _cmdline_init;
-
-	p1.l = __rambase;
-	p1.h = __rambase;
-	r0.l = __sdata;
-	r0.h = __sdata;
-	[p1] = r0;
-
-	p1.l = __ramstart;
-	p1.h = __ramstart;
-	p3.l = ___bss_stop;
-	p3.h = ___bss_stop;
-
-	r1 = p3;
-	[p1] = r1;
-
-	/*
-	 * load the current thread pointer and stack
-	 */
-	r1.l = _init_thread_union;
-	r1.h = _init_thread_union;
-
-	r2.l = 0x2000;
-	r2.h = 0x0000;
-	r1 = r1 + r2;
-	sp = r1;
-	usp = sp;
-	fp = sp;
-	jump.l _start_kernel;
-ENDPROC(_real_start)
-
-__FINIT
-
 .section .l1.text
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
@@ -412,13 +129,6 @@ ENTRY(_start_dma_code)
 	[P2] = R1;
 	SSYNC;

-	p0.h = hi(SIC_IWR);
-	p0.l = lo(SIC_IWR);
-	r0.l = lo(IWR_ENABLE_ALL);
-	r0.h = hi(IWR_ENABLE_ALL);
-	[p0] = r0;
-	SSYNC;
-
 	RTS;
 ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
diff --git a/arch/blackfin/mach-bf533/ints-priority.c
b/arch/blackfin/mach-bf533/ints-priority.c
index 7d79e0f..f51994b 100644
--- a/arch/blackfin/mach-bf533/ints-priority.c
+++ b/arch/blackfin/mach-bf533/ints-priority.c
@@ -31,7 +31,7 @@
 #include <linux/irq.h>
 #include <asm/blackfin.h>

-void program_IAR(void)
+void __init program_IAR(void)
 {
 	/* Program the IAR0 Register with the configured priority */
 	bfin_write_SIC_IAR0(((CONFIG_PLLWAKE_ERROR - 7) << PLLWAKE_ERROR_POS) |
diff --git a/arch/blackfin/mach-bf537/boards/Kconfig
b/arch/blackfin/mach-bf537/boards/Kconfig
index 7e789db..42a57b0 100644
--- a/arch/blackfin/mach-bf537/boards/Kconfig
+++ b/arch/blackfin/mach-bf537/boards/Kconfig
@@ -15,6 +15,12 @@ config BFIN537_BLUETECHNIX_CM
 	help
 	  CM-BF537 support for EVAL- and DEV-Board.

+config BFIN537_BLUETECHNIX_TCM
+	bool "Bluetechnix TCM-BF537"
+	depends on (BF537)
+	help
+	  TCM-BF537 support for EVAL- and DEV-Board.
+
 config PNAV10
 	bool "PNAV board"
 	depends on (BF537)
diff --git a/arch/blackfin/mach-bf537/boards/Makefile
b/arch/blackfin/mach-bf537/boards/Makefile
index c94f7a5..7168cc1 100644
--- a/arch/blackfin/mach-bf537/boards/Makefile
+++ b/arch/blackfin/mach-bf537/boards/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_GENERIC_BF537_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN537_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)   += cm_bf537.o
+obj-$(CONFIG_BFIN537_BLUETECHNIX_TCM)  += tcm_bf537.o
 obj-$(CONFIG_PNAV10)                   += pnav10.o
 obj-$(CONFIG_CAMSIG_MINOTAUR)          += minotaur.o
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c
b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 73f2142..dde1472 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -33,6 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
@@ -56,16 +57,16 @@ const char bfin_board_name[] = "Bluetechnix CM BF537";
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = 0x20000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x700000,
 		.offset = 0x00100000,
 	}
@@ -307,6 +308,55 @@ static struct platform_device net2272_bfin_device = {
 };
 #endif

+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+static struct mtd_partition cm_partitions[] = {
+	{
+		.name   = "bootloader(nor)",
+		.size   = 0x40000,
+		.offset = 0,
+	}, {
+		.name   = "linux kernel(nor)",
+		.size   = 0xE0000,
+		.offset = MTDPART_OFS_APPEND,
+	}, {
+		.name   = "file system(nor)",
+		.size   = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data cm_flash_data = {
+	.width    = 2,
+	.parts    = cm_partitions,
+	.nr_parts = ARRAY_SIZE(cm_partitions),
+};
+
+static unsigned cm_flash_gpios[] = { GPIO_PF4 };
+
+static struct resource cm_flash_resource[] = {
+	{
+		.name  = "cfi_probe",
+		.start = 0x20000000,
+		.end   = 0x201fffff,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = (unsigned long)cm_flash_gpios,
+		.end   = ARRAY_SIZE(cm_flash_gpios),
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device cm_flash_device = {
+	.name          = "gpio-addr-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &cm_flash_data,
+	},
+	.num_resources = ARRAY_SIZE(cm_flash_resource),
+	.resource      = cm_flash_resource,
+};
+#endif
+
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
 	{
@@ -395,7 +445,7 @@ static struct platform_device bfin_mac_device = {
 #endif

 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	64
+#define PATA_INT	IRQ_PF14

 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 2,
@@ -510,6 +560,10 @@ static struct platform_device *cm_bf537_devices[]
__initdata = {
 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
 	&bfin_pata_device,
 #endif
+
+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+	&cm_flash_device,
+#endif
 };

 static int __init cm_bf537_init(void)
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c
b/arch/blackfin/mach-bf537/boards/generic_board.c
index 01b63e2..78a13d5 100644
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ b/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -38,7 +38,6 @@
 #if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
 #include <linux/usb/isp1362.h>
 #endif
-#include <linux/ata_platform.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/usb/sl811.h>
@@ -307,16 +306,16 @@ static struct platform_device net2272_bfin_device = {
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = 0x20000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x700000,
 		.offset = 0x00100000,
 	}
@@ -619,43 +618,6 @@ static struct platform_device bfin_sport1_uart_device = {
 };
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 static struct platform_device *stamp_devices[] __initdata = {
 #if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
 	&bfin_pcmcia_cf_device,
@@ -717,10 +679,6 @@ static struct platform_device *stamp_devices[]
__initdata = {
 	&bfin_sport0_uart_device,
 	&bfin_sport1_uart_device,
 #endif
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
 };

 static int __init stamp_init(void)
@@ -732,9 +690,6 @@ static int __init stamp_init(void)
 				ARRAY_SIZE(bfin_spi_board_info));
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c
b/arch/blackfin/mach-bf537/boards/minotaur.c
index 18ddf7a..48c4cd2 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -100,16 +100,16 @@ static struct platform_device net2272_bfin_device = {

 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name       = "uboot",
+		.name       = "bootloader(spi)",
 		.size       = PSIZE_UBOOT,
 		.offset     = 0x000000,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name       = "initramfs",
+		.name       = "initramfs(spi)",
 		.size       = PSIZE_INITRAMFS,
 		.offset     = PSIZE_UBOOT
 	}, {
-		.name       = "opt",
+		.name       = "opt(spi)",
 		.size       = FLASH_SIZE - (PSIZE_UBOOT + PSIZE_INITRAMFS),
 		.offset     = PSIZE_UBOOT + PSIZE_INITRAMFS,
 	}
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c
b/arch/blackfin/mach-bf537/boards/pnav10.c
index 51c3bab..f9174c1 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -231,16 +231,16 @@ static struct platform_device net2272_bfin_device = {
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = 0x20000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x700000,
 		.offset = 0x00100000,
 	}
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
b/arch/blackfin/mach-bf537/boards/stamp.c
index 6dbc76f..e93964f 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -364,11 +364,11 @@ const char *part_probes[] = { "cmdlinepart",
"RedBoot", NULL };

 static struct mtd_partition bfin_plat_nand_partitions[] = {
 	{
-		.name   = "linux kernel",
+		.name   = "linux kernel(nand)",
 		.size   = 0x400000,
 		.offset = 0,
 	}, {
-		.name   = "file system",
+		.name   = "file system(nand)",
 		.size   = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	},
@@ -439,19 +439,19 @@ static void bfin_plat_nand_init(void) {}
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition stamp_partitions[] = {
 	{
-		.name       = "Bootloader",
+		.name       = "bootloader(nor)",
 		.size       = 0x40000,
 		.offset     = 0,
 	}, {
-		.name       = "Kernel",
+		.name       = "linux kernel(nor)",
 		.size       = 0xE0000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "RootFS",
+		.name       = "file system(nor)",
 		.size       = 0x400000 - 0x40000 - 0xE0000 - 0x10000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "MAC Address",
+		.name       = "MAC Address(nor)",
 		.size       = MTDPART_SIZ_FULL,
 		.offset     = 0x3F0000,
 		.mask_flags = MTD_WRITEABLE,
@@ -485,16 +485,16 @@ static struct platform_device stamp_flash_device = {
 	|| defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = MTDPART_OFS_APPEND,
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
new file mode 100644
index 0000000..d5ff705
--- /dev/null
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -0,0 +1,590 @@
+/*
+ * File:         arch/blackfin/mach-bf537/boards/tcm_bf537.c
+ * Based on:     arch/blackfin/mach-bf533/boards/cm_bf537.c
+ * Author:       Aidan Williams <aidan@nicta.com.au>
+ *
+ * Created:      2005
+ * Description:  Board description file
+ *
+ * Modified:
+ *               Copyright 2005 National ICT Australia (NICTA)
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/device.h>
+#include <linux/etherdevice.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/physmap.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/flash.h>
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+#include <linux/usb/isp1362.h>
+#endif
+#include <linux/ata_platform.h>
+#include <linux/irq.h>
+#include <asm/dma.h>
+#include <asm/bfin5xx_spi.h>
+#include <asm/portmux.h>
+#include <asm/dpmc.h>
+
+/*
+ * Name the Board for the /proc/cpuinfo
+ */
+const char bfin_board_name[] = "Bluetechnix TCM BF537";
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+/* all SPI peripherals info goes here */
+
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+static struct mtd_partition bfin_spi_flash_partitions[] = {
+	{
+		.name = "bootloader(spi)",
+		.size = 0x00020000,
+		.offset = 0,
+		.mask_flags = MTD_CAP_ROM
+	}, {
+		.name = "linux kernel(spi)",
+		.size = 0xe0000,
+		.offset = 0x20000
+	}, {
+		.name = "file system(spi)",
+		.size = 0x700000,
+		.offset = 0x00100000,
+	}
+};
+
+static struct flash_platform_data bfin_spi_flash_data = {
+	.name = "m25p80",
+	.parts = bfin_spi_flash_partitions,
+	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
+	.type = "m25p64",
+};
+
+/* SPI flash chip (m25p64) */
+static struct bfin5xx_spi_chip spi_flash_chip_info = {
+	.enable_dma = 0,         /* use dma transfer with this chip*/
+	.bits_per_word = 8,
+};
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+/* SPI ADC chip */
+static struct bfin5xx_spi_chip spi_adc_chip_info = {
+	.enable_dma = 1,         /* use dma transfer with this chip*/
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) ||
defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
+	.enable_dma = 0,
+	.bits_per_word = 16,
+};
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+	.enable_dma = 1,
+	.bits_per_word = 8,
+};
+#endif
+
+static struct spi_board_info bfin_spi_board_info[] __initdata = {
+#if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
+	{
+		/* the modalias must be the same as spi device driver name */
+		.modalias = "m25p80", /* Name of spi_driver for this device */
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
+		.platform_data = &bfin_spi_flash_data,
+		.controller_data = &spi_flash_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+
+#if defined(CONFIG_SPI_ADC_BF533) || defined(CONFIG_SPI_ADC_BF533_MODULE)
+	{
+		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
+		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0, /* Framework bus number */
+		.chip_select = 1, /* Framework chip select. */
+		.platform_data = NULL, /* No spi_driver specific config */
+		.controller_data = &spi_adc_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_SND_BLACKFIN_AD1836) ||
defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
+	{
+		.modalias = "ad1836-spi",
+		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
+		.controller_data = &ad1836_spi_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
+	{
+		.modalias = "ad9960-spi",
+		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 1,
+		.controller_data = &ad9960_spi_chip_info,
+	},
+#endif
+
+#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+	{
+		.modalias = "spi_mmc_dummy",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = 7,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+	{
+		.modalias = "spi_mmc",
+		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.bus_num = 0,
+		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
+		.platform_data = NULL,
+		.controller_data = &spi_mmc_chip_info,
+		.mode = SPI_MODE_3,
+	},
+#endif
+};
+
+/* SPI (0) */
+static struct resource bfin_spi0_resource[] = {
+	[0] = {
+		.start = SPI0_REGBASE,
+		.end   = SPI0_REGBASE + 0xFF,
+		.flags = IORESOURCE_MEM,
+		},
+	[1] = {
+		.start = CH_SPI,
+		.end   = CH_SPI,
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+/* SPI controller data */
+static struct bfin5xx_spi_master bfin_spi0_info = {
+	.num_chipselect = 8,
+	.enable_dma = 1,  /* master has the ability to do dma transfer */
+	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
+};
+
+static struct platform_device bfin_spi0_device = {
+	.name = "bfin-spi",
+	.id = 0, /* Bus number */
+	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
+	.resource = bfin_spi0_resource,
+	.dev = {
+		.platform_data = &bfin_spi0_info, /* Passed to driver */
+	},
+};
+#endif  /* spi master and devices */
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+static struct platform_device rtc_device = {
+	.name = "rtc-bfin",
+	.id   = -1,
+};
+#endif
+
+#if defined(CONFIG_FB_HITACHI_TX09) || defined(CONFIG_FB_HITACHI_TX09_MODULE)
+static struct platform_device hitachi_fb_device = {
+	.name = "hitachi-tx09",
+};
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+static struct resource smc91x_resources[] = {
+	{
+		.start = 0x20200300,
+		.end = 0x20200300 + 16,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PF14,
+		.end = IRQ_PF14,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+		},
+};
+
+static struct platform_device smc91x_device = {
+	.name = "smc91x",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(smc91x_resources),
+	.resource = smc91x_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+static struct resource isp1362_hcd_resources[] = {
+	{
+		.start = 0x20308000,
+		.end = 0x20308000,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0x20308004,
+		.end = 0x20308004,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PG15,
+		.end = IRQ_PG15,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct isp1362_platform_data isp1362_priv = {
+	.sel15Kres = 1,
+	.clknotstop = 0,
+	.oc_enable = 0,
+	.int_act_high = 0,
+	.int_edge_triggered = 0,
+	.remote_wakeup_connected = 0,
+	.no_power_switching = 1,
+	.power_switching_mode = 0,
+};
+
+static struct platform_device isp1362_hcd_device = {
+	.name = "isp1362-hcd",
+	.id = 0,
+	.dev = {
+		.platform_data = &isp1362_priv,
+	},
+	.num_resources = ARRAY_SIZE(isp1362_hcd_resources),
+	.resource = isp1362_hcd_resources,
+};
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+static struct resource net2272_bfin_resources[] = {
+	{
+		.start = 0x20200000,
+		.end = 0x20200000 + 0x100,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = IRQ_PH14,
+		.end = IRQ_PH14,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
+	},
+};
+
+static struct platform_device net2272_bfin_device = {
+	.name = "net2272",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
+	.resource = net2272_bfin_resources,
+};
+#endif
+
+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+static struct mtd_partition cm_partitions[] = {
+	{
+		.name   = "bootloader(nor)",
+		.size   = 0x40000,
+		.offset = 0,
+	}, {
+		.name   = "linux kernel(nor)",
+		.size   = 0xE0000,
+		.offset = MTDPART_OFS_APPEND,
+	}, {
+		.name   = "file system(nor)",
+		.size   = MTDPART_SIZ_FULL,
+		.offset = MTDPART_OFS_APPEND,
+	}
+};
+
+static struct physmap_flash_data cm_flash_data = {
+	.width    = 2,
+	.parts    = cm_partitions,
+	.nr_parts = ARRAY_SIZE(cm_partitions),
+};
+
+static unsigned cm_flash_gpios[] = { GPIO_PF4, GPIO_PF5 };
+
+static struct resource cm_flash_resource[] = {
+	{
+		.name  = "cfi_probe",
+		.start = 0x20000000,
+		.end   = 0x201fffff,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = (unsigned long)cm_flash_gpios,
+		.end   = ARRAY_SIZE(cm_flash_gpios),
+		.flags = IORESOURCE_IRQ,
+	}
+};
+
+static struct platform_device cm_flash_device = {
+	.name          = "gpio-addr-flash",
+	.id            = 0,
+	.dev = {
+		.platform_data = &cm_flash_data,
+	},
+	.num_resources = ARRAY_SIZE(cm_flash_resource),
+	.resource      = cm_flash_resource,
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+static struct resource bfin_uart_resources[] = {
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	}, {
+		.start = 0xFFC02000,
+		.end = 0xFFC020FF,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct platform_device bfin_uart_device = {
+	.name = "bfin-uart",
+	.id = 1,
+	.num_resources = ARRAY_SIZE(bfin_uart_resources),
+	.resource = bfin_uart_resources,
+};
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+static struct resource bfin_sir_resources[] = {
+#ifdef CONFIG_BFIN_SIR0
+	{
+		.start = 0xFFC00400,
+		.end = 0xFFC004FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+#ifdef CONFIG_BFIN_SIR1
+	{
+		.start = 0xFFC02000,
+		.end = 0xFFC020FF,
+		.flags = IORESOURCE_MEM,
+	},
+#endif
+};
+
+static struct platform_device bfin_sir_device = {
+	.name = "bfin_sir",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_sir_resources),
+	.resource = bfin_sir_resources,
+};
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+static struct resource bfin_twi0_resource[] = {
+	[0] = {
+		.start = TWI0_REGBASE,
+		.end   = TWI0_REGBASE,
+		.flags = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start = IRQ_TWI,
+		.end   = IRQ_TWI,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device i2c_bfin_twi_device = {
+	.name = "i2c-bfin-twi",
+	.id = 0,
+	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
+	.resource = bfin_twi0_resource,
+};
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+static struct platform_device bfin_sport0_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 0,
+};
+
+static struct platform_device bfin_sport1_uart_device = {
+	.name = "bfin-sport-uart",
+	.id = 1,
+};
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+static struct platform_device bfin_mac_device = {
+	.name = "bfin_mac",
+};
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+#define PATA_INT	IRQ_PF14
+
+static struct pata_platform_info bfin_pata_platform_data = {
+	.ioport_shift = 2,
+	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
+};
+
+static struct resource bfin_pata_resources[] = {
+	{
+		.start = 0x2030C000,
+		.end = 0x2030C01F,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = 0x2030D018,
+		.end = 0x2030D01B,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = PATA_INT,
+		.end = PATA_INT,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device bfin_pata_device = {
+	.name = "pata_platform",
+	.id = -1,
+	.num_resources = ARRAY_SIZE(bfin_pata_resources),
+	.resource = bfin_pata_resources,
+	.dev = {
+		.platform_data = &bfin_pata_platform_data,
+	}
+};
+#endif
+
+static const unsigned int cclk_vlev_datasheet[] =
+{
+	VRPAIR(VLEV_085, 250000000),
+	VRPAIR(VLEV_090, 376000000),
+	VRPAIR(VLEV_095, 426000000),
+	VRPAIR(VLEV_100, 426000000),
+	VRPAIR(VLEV_105, 476000000),
+	VRPAIR(VLEV_110, 476000000),
+	VRPAIR(VLEV_115, 476000000),
+	VRPAIR(VLEV_120, 500000000),
+	VRPAIR(VLEV_125, 533000000),
+	VRPAIR(VLEV_130, 600000000),
+};
+
+static struct bfin_dpmc_platform_data bfin_dmpc_vreg_data = {
+	.tuple_tab = cclk_vlev_datasheet,
+	.tabsize = ARRAY_SIZE(cclk_vlev_datasheet),
+	.vr_settling_time = 25 /* us */,
+};
+
+static struct platform_device bfin_dpmc = {
+	.name = "bfin dpmc",
+	.dev = {
+		.platform_data = &bfin_dmpc_vreg_data,
+	},
+};
+
+static struct platform_device *cm_bf537_devices[] __initdata = {
+
+	&bfin_dpmc,
+
+#if defined(CONFIG_FB_HITACHI_TX09) || defined(CONFIG_FB_HITACHI_TX09_MODULE)
+	&hitachi_fb_device,
+#endif
+
+#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
+	&rtc_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
+	&bfin_uart_device,
+#endif
+
+#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
+	&bfin_sir_device,
+#endif
+
+#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
+	&i2c_bfin_twi_device,
+#endif
+
+#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
+	&bfin_sport0_uart_device,
+	&bfin_sport1_uart_device,
+#endif
+
+#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
+	&isp1362_hcd_device,
+#endif
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	&smc91x_device,
+#endif
+
+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
+	&bfin_mac_device,
+#endif
+
+#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
+	&net2272_bfin_device,
+#endif
+
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	&bfin_spi0_device,
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	&bfin_pata_device,
+#endif
+
+#if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
+	&cm_flash_device,
+#endif
+};
+
+static int __init cm_bf537_init(void)
+{
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+	platform_add_devices(cm_bf537_devices, ARRAY_SIZE(cm_bf537_devices));
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+#endif
+
+#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
+	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
+#endif
+	return 0;
+}
+
+arch_initcall(cm_bf537_init);
+
+void bfin_get_ether_addr(char *addr)
+{
+	random_ether_addr(addr);
+	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n",
__FILE__, __func__);
+}
+EXPORT_SYMBOL(bfin_get_ether_addr);
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index 6b019ea..64e0287 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -30,325 +30,11 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/blackfin.h>
-#include <asm/trace.h>
-
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif

-.extern ___bss_stop
-.extern ___bss_start
-.extern _bf53x_relocate_l1_mem
-
-#define INITIAL_STACK	0xFFB01000
-
-__INIT
-
-ENTRY(__start)
-	/* R0: argument of command line string, passed from uboot, save it */
-	R7 = R0;
-	/* Enable Cycle Counter and Nesting Of Interrupts */
-#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
-	R0 = SYSCFG_SNEN;
-#else
-	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
-#endif
-	SYSCFG = R0;
-	R0 = 0;
-
-	/* Clear Out All the data and pointer Registers */
-	R1 = R0;
-	R2 = R0;
-	R3 = R0;
-	R4 = R0;
-	R5 = R0;
-	R6 = R0;
-
-	P0 = R0;
-	P1 = R0;
-	P2 = R0;
-	P3 = R0;
-	P4 = R0;
-	P5 = R0;
-
-	LC0 = r0;
-	LC1 = r0;
-	L0 = r0;
-	L1 = r0;
-	L2 = r0;
-	L3 = r0;
-
-	/* Clear Out All the DAG Registers */
-	B0 = r0;
-	B1 = r0;
-	B2 = r0;
-	B3 = r0;
-
-	I0 = r0;
-	I1 = r0;
-	I2 = r0;
-	I3 = r0;
-
-	M0 = r0;
-	M1 = r0;
-	M2 = r0;
-	M3 = r0;
-
-	trace_buffer_init(p0,r0);
-	P0 = R1;
-	R0 = R1;
-
-	/* Turn off the icache */
-	p0.l = LO(IMEM_CONTROL);
-	p0.h = HI(IMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENICPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Turn off the dcache */
-	p0.l = LO(DMEM_CONTROL);
-	p0.h = HI(DMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENDCPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Initialise General-Purpose I/O Modules on BF537 */
-	/* Rev 0.0 Anomaly 05000212 - PORTx_FER,
-	 * PORT_MUX Registers Do Not accept "writes" correctly:
-	 */
-	p0.h = hi(BFIN_PORT_MUX);
-	p0.l = lo(BFIN_PORT_MUX);
-#if ANOMALY_05000212
-	R0.L = W[P0]; /* Read */
-	SSYNC;
-#endif
-	R0 = (PGDE_UART | PFTE_UART)(Z);
-#if ANOMALY_05000212
-	W[P0] = R0.L; /* Write */
-	SSYNC;
-#endif
-	W[P0] = R0.L; /* Enable both UARTS */
-	SSYNC;
-
-	p0.h = hi(PORTF_FER);
-	p0.l = lo(PORTF_FER);
-#if ANOMALY_05000212
-	R0.L = W[P0]; /* Read */
-	SSYNC;
-#endif
-	R0 = 0x000F(Z);
-#if ANOMALY_05000212
-	W[P0] = R0.L; /* Write */
-	SSYNC;
-#endif
-	/* Enable peripheral function of PORTF for UART0 and UART1 */
-	W[P0] = R0.L;
-	SSYNC;
-
-#if !defined(CONFIG_BF534)
-	p0.h = hi(EMAC_SYSTAT);
-	p0.l = lo(EMAC_SYSTAT);
-	R0.h = 0xFFFF; /* Clear EMAC Interrupt Status bits */
-	R0.l = 0xFFFF;
-	[P0] = R0;
-	SSYNC;
-#endif
-
-	/* Initialise UART - when booting from u-boot, the UART is not disabled
-	 * so if we dont initalize here, our serial console gets hosed */
-	p0.h = hi(BFIN_UART_LCR);
-	p0.l = lo(BFIN_UART_LCR);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable DLL writes */
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLL);
-	p0.l = lo(BFIN_UART_DLL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLH);
-	p0.l = lo(BFIN_UART_DLH);
-	r0 = 0x00(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_GCTL);
-	p0.l = lo(BFIN_UART_GCTL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable UART clock */
-	ssync;
-
-	/* Initialize stack pointer */
-	sp.l = lo(INITIAL_STACK);
-	sp.h = hi(INITIAL_STACK);
-	fp = sp;
-	usp = sp;
-
-#ifdef CONFIG_EARLY_PRINTK
-	SP += -12;
-	call _init_early_exception_vectors;
-	SP += 12;
-#endif
-
-	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
-	call _bf53x_relocate_l1_mem;
-#ifdef CONFIG_BFIN_KERNEL_CLOCK
-	call _start_dma_code;
-#endif
-
-	/* Code for initializing Async memory banks */
-
-	p2.h = hi(EBIU_AMBCTL1);
-	p2.l = lo(EBIU_AMBCTL1);
-	r0.h = hi(AMBCTL1VAL);
-	r0.l = lo(AMBCTL1VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMBCTL0);
-	p2.l = lo(EBIU_AMBCTL0);
-	r0.h = hi(AMBCTL0VAL);
-	r0.l = lo(AMBCTL0VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMGCTL);
-	p2.l = lo(EBIU_AMGCTL);
-	r0 = AMGCTLVAL;
-	w[p2] = r0;
-	ssync;
-
-	/* This section keeps the processor in supervisor mode
-	 * during kernel boot.  Switches to user mode at end of boot.
-	 * See page 3-9 of Hardware Reference manual for documentation.
-	 */
-
-	/* EVT15 = _real_start */
-
-	p0.l = lo(EVT15);
-	p0.h = hi(EVT15);
-	p1.l = _real_start;
-	p1.h = _real_start;
-	[p0] = p1;
-	csync;
-
-	p0.l = lo(IMASK);
-	p0.h = hi(IMASK);
-	p1.l = IMASK_IVG15;
-	p1.h = 0x0;
-	[p0] = p1;
-	csync;
-
-	raise 15;
-	p0.l = .LWAIT_HERE;
-	p0.h = .LWAIT_HERE;
-	reti = p0;
-#if ANOMALY_05000281
-	nop; nop; nop;
-#endif
-	rti;
-
-.LWAIT_HERE:
-	jump .LWAIT_HERE;
-ENDPROC(__start)
-
-ENTRY(_real_start)
-	[ -- sp ] = reti;
-	p0.l = lo(WDOG_CTL);
-	p0.h = hi(WDOG_CTL);
-	r0 = 0xAD6(z);
-	w[p0] = r0;	/* watchdog off for now */
-	ssync;
-
-	/* Code update for BSS size == 0
-	 * Zero out the bss region.
-	 */
-
-	p1.l = ___bss_start;
-	p1.h = ___bss_start;
-	p2.l = ___bss_stop;
-	p2.h = ___bss_stop;
-	r0 = 0;
-	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
-.L_clear_bss:
-	B[p1++] = r0;
-
-	/* In case there is a NULL pointer reference
-	 * Zero out region before stext
-	 */
-
-	p1.l = 0x0;
-	p1.h = 0x0;
-	r0.l = __stext;
-	r0.h = __stext;
-	r0 = r0 >> 1;
-	p2 = r0;
-	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
-.L_clear_zero:
-	W[p1++] = r0;
-
-	/* pass the uboot arguments to the global value command line */
-	R0 = R7;
-	call _cmdline_init;
-
-	p1.l = __rambase;
-	p1.h = __rambase;
-	r0.l = __sdata;
-	r0.h = __sdata;
-	[p1] = r0;
-
-	p1.l = __ramstart;
-	p1.h = __ramstart;
-	p3.l = ___bss_stop;
-	p3.h = ___bss_stop;
-
-	r1 = p3;
-	[p1] = r1;
-
-	/*
-	 * load the current thread pointer and stack
-	 */
-	r1.l = _init_thread_union;
-	r1.h = _init_thread_union;
-
-	r2.l = 0x2000;
-	r2.h = 0x0000;
-	r1 = r1 + r2;
-	sp = r1;
-	usp = sp;
-	fp = sp;
-	jump.l _start_kernel;
-ENDPROC(_real_start)
-
-__FINIT
-
 .section .l1.text
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
@@ -452,13 +138,6 @@ ENTRY(_start_dma_code)
 	[P2] = R1;
 	SSYNC;

-	p0.h = hi(SIC_IWR);
-	p0.l = lo(SIC_IWR);
-	r0.l = lo(IWR_ENABLE_ALL);
-	r0.h = hi(IWR_ENABLE_ALL);
-	[p0] = r0;
-	SSYNC;
-
 	RTS;
 ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
diff --git a/arch/blackfin/mach-bf537/ints-priority.c
b/arch/blackfin/mach-bf537/ints-priority.c
index a8b915f..b1300b3 100644
--- a/arch/blackfin/mach-bf537/ints-priority.c
+++ b/arch/blackfin/mach-bf537/ints-priority.c
@@ -31,7 +31,7 @@
 #include <linux/irq.h>
 #include <asm/blackfin.h>

-void program_IAR(void)
+void __init program_IAR(void)
 {
 	/* Program the IAR0 Register with the configured priority */
 	bfin_write_SIC_IAR0(((CONFIG_IRQ_PLL_WAKEUP - 7) << IRQ_PLL_WAKEUP_POS) |
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c
b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index 4f4ae87..58abbed 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -319,12 +319,12 @@ static struct platform_device bfin_atapi_device = {
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
-		.name = "Linux Kernel",
+		.name = "linux kernel(nand)",
 		.offset = 0,
 		.size = 4 * SIZE_1M,
 	},
 	{
-		.name = "File System",
+		.name = "file system(nand)",
 		.offset = 4 * SIZE_1M,
 		.size = (256 - 4) * SIZE_1M,
 	},
@@ -377,12 +377,12 @@ static struct platform_device bf54x_sdh_device = {
 /* SPI flash chip (m25p16) */
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "linux kernel",
+		.name = "linux kernel(spi)",
 		.size = 0x1c0000,
 		.offset = 0x40000
 	}
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c
b/arch/blackfin/mach-bf548/boards/ezkit.c
index 166fa22..0d6333a 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -365,12 +365,12 @@ static struct platform_device bfin_atapi_device = {
 #if defined(CONFIG_MTD_NAND_BF5XX) || defined(CONFIG_MTD_NAND_BF5XX_MODULE)
 static struct mtd_partition partition_info[] = {
 	{
-		.name = "Linux Kernel",
+		.name = "linux kernel(nand)",
 		.offset = 0,
 		.size = 4 * SIZE_1M,
 	},
 	{
-		.name = "File System",
+		.name = "file system(nand)",
 		.offset = MTDPART_OFS_APPEND,
 		.size = MTDPART_SIZ_FULL,
 	},
@@ -419,15 +419,15 @@ static struct platform_device bf54x_sdh_device = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition ezkit_partitions[] = {
 	{
-		.name       = "Bootloader",
+		.name       = "bootloader(nor)",
 		.size       = 0x40000,
 		.offset     = 0,
 	}, {
-		.name       = "Kernel",
+		.name       = "linux kernel(nor)",
 		.size       = 0x1C0000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "RootFS",
+		.name       = "file system(nor)",
 		.size       = MTDPART_SIZ_FULL,
 		.offset     = MTDPART_OFS_APPEND,
 	}
@@ -461,12 +461,12 @@ static struct platform_device ezkit_flash_device = {
 /* SPI flash chip (m25p16) */
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00040000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "linux kernel",
+		.name = "linux kernel(spi)",
 		.size = MTDPART_SIZ_FULL,
 		.offset = MTDPART_OFS_APPEND,
 	}
diff --git a/arch/blackfin/mach-bf548/head.S b/arch/blackfin/mach-bf548/head.S
index 06b9178..e3000f7 100644
--- a/arch/blackfin/mach-bf548/head.S
+++ b/arch/blackfin/mach-bf548/head.S
@@ -30,263 +30,11 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/blackfin.h>
-#include <asm/trace.h>
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif

-.extern ___bss_stop
-.extern ___bss_start
-.extern _bf53x_relocate_l1_mem
-
-#define INITIAL_STACK   0xFFB01000
-
-__INIT
-
-ENTRY(__start)
-	/* R0: argument of command line string, passed from uboot, save it */
-	R7 = R0;
-	/* Enable Cycle Counter and Nesting Of Interrupts */
-#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
-	R0 = SYSCFG_SNEN;
-#else
-	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
-#endif
-	SYSCFG = R0;
-	R0 = 0;
-
-	/* Clear Out All the data and pointer  Registers*/
-	R1 = R0;
-	R2 = R0;
-	R3 = R0;
-	R4 = R0;
-	R5 = R0;
-	R6 = R0;
-
-	P0 = R0;
-	P1 = R0;
-	P2 = R0;
-	P3 = R0;
-	P4 = R0;
-	P5 = R0;
-
-	LC0 = r0;
-	LC1 = r0;
-	L0 = r0;
-	L1 = r0;
-	L2 = r0;
-	L3 = r0;
-
-	/* Clear Out All the DAG Registers*/
-	B0 = r0;
-	B1 = r0;
-	B2 = r0;
-	B3 = r0;
-
-	I0 = r0;
-	I1 = r0;
-	I2 = r0;
-	I3 = r0;
-
-	M0 = r0;
-	M1 = r0;
-	M2 = r0;
-	M3 = r0;
-
-	trace_buffer_init(p0,r0);
-	P0 = R1;
-	R0 = R1;
-
-	/* Turn off the icache */
-	p0.l = LO(IMEM_CONTROL);
-	p0.h = HI(IMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENICPLB;
-	R0 = R0 & R1;
-	[p0] = R0;
-	SSYNC;
-
-	/* Turn off the dcache */
-	p0.l = LO(DMEM_CONTROL);
-	p0.h = HI(DMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENDCPLB;
-	R0 = R0 & R1;
-	[p0] = R0;
-	SSYNC;
-
-	/* Initialize stack pointer */
-	SP.L = LO(INITIAL_STACK);
-	SP.H = HI(INITIAL_STACK);
-	FP = SP;
-	USP = SP;
-
-#ifdef CONFIG_EARLY_PRINTK
-	SP += -12;
-	call _init_early_exception_vectors;
-	SP += 12;
-#endif
-
-	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
-	call _bf53x_relocate_l1_mem;
-#ifdef CONFIG_BFIN_KERNEL_CLOCK
-	call _start_dma_code;
-#endif
-	/* Code for initializing Async memory banks */
-
-	p2.h = hi(EBIU_AMBCTL1);
-	p2.l = lo(EBIU_AMBCTL1);
-	r0.h = hi(AMBCTL1VAL);
-	r0.l = lo(AMBCTL1VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMBCTL0);
-	p2.l = lo(EBIU_AMBCTL0);
-	r0.h = hi(AMBCTL0VAL);
-	r0.l = lo(AMBCTL0VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMGCTL);
-	p2.l = lo(EBIU_AMGCTL);
-	r0 = AMGCTLVAL;
-	w[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_MBSCTL);
-	p2.l = lo(EBIU_MBSCTL);
-	r0.h = hi(CONFIG_EBIU_MBSCTLVAL);
-	r0.l = lo(CONFIG_EBIU_MBSCTLVAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_MODE);
-	p2.l = lo(EBIU_MODE);
-	r0.h = hi(CONFIG_EBIU_MODEVAL);
-	r0.l = lo(CONFIG_EBIU_MODEVAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_FCTL);
-	p2.l = lo(EBIU_FCTL);
-	r0.h = hi(CONFIG_EBIU_FCTLVAL);
-	r0.l = lo(CONFIG_EBIU_FCTLVAL);
-	[p2] = r0;
-	ssync;
-
-	/* This section keeps the processor in supervisor mode
-	 * during kernel boot.  Switches to user mode at end of boot.
-	 * See page 3-9 of Hardware Reference manual for documentation.
-	 */
-
-	/* EVT15 = _real_start */
-
-	p0.l = lo(EVT15);
-	p0.h = hi(EVT15);
-	p1.l = _real_start;
-	p1.h = _real_start;
-	[p0] = p1;
-	csync;
-
-	p0.l = lo(IMASK);
-	p0.h = hi(IMASK);
-	p1.l = IMASK_IVG15;
-	p1.h = 0x0;
-	[p0] = p1;
-	csync;
-
-	raise 15;
-	p0.l = .LWAIT_HERE;
-	p0.h = .LWAIT_HERE;
-	reti = p0;
-#if ANOMALY_05000281
-	nop;
-	nop;
-	nop;
-#endif
-	rti;
-
-.LWAIT_HERE:
-	jump .LWAIT_HERE;
-ENDPROC(__start)
-
-ENTRY(_real_start)
-	[ -- sp ] = reti;
-	p0.l = lo(WDOG_CTL);
-	p0.h = hi(WDOG_CTL);
-	r0 = 0xAD6(z);
-	w[p0] = r0;	/* watchdog off for now */
-	ssync;
-
-	/* Code update for BSS size == 0
-	 * Zero out the bss region.
-	 */
-
-	p1.l = ___bss_start;
-	p1.h = ___bss_start;
-	p2.l = ___bss_stop;
-	p2.h = ___bss_stop;
-	r0 = 0;
-	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss ) lc0 = p2;
-.L_clear_bss:
-	B[p1++] = r0;
-
-	/* In case there is a NULL pointer reference
-	 * Zero out region before stext
-	 */
-
-	p1.l = 0x0;
-	p1.h = 0x0;
-	r0.l = __stext;
-	r0.h = __stext;
-	r0 = r0 >> 1;
-	p2 = r0;
-	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero ) lc0 = p2;
-.L_clear_zero:
-	W[p1++] = r0;
-
-	/* pass the uboot arguments to the global value command line */
-	R0 = R7;
-	call _cmdline_init;
-
-	p1.l = __rambase;
-	p1.h = __rambase;
-	r0.l = __sdata;
-	r0.h = __sdata;
-	[p1] = r0;
-
-	p1.l = __ramstart;
-	p1.h = __ramstart;
-	p3.l = ___bss_stop;
-	p3.h = ___bss_stop;
-
-	r1 = p3;
-	[p1] = r1;
-
-
-	/*
-	 *  load the current thread pointer and stack
-	 */
-	r1.l = _init_thread_union;
-	r1.h = _init_thread_union;
-
-	r2.l = 0x2000;
-	r2.h = 0x0000;
-	r1 = r1 + r2;
-	sp = r1;
-	usp = sp;
-	fp = sp;
-	call _start_kernel;
-.L_exit:
-	jump.s	.L_exit;
-ENDPROC(_real_start)
-
-__FINIT
-
 .section .l1.text
 #ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
@@ -443,13 +191,6 @@ ENTRY(_start_dma_code)
 	SSYNC;
 #endif

-	p0.h = hi(SIC_IWR0);
-	p0.l = lo(SIC_IWR0);
-	r0.l = lo(IWR_ENABLE_ALL);
-	r0.h = hi(IWR_ENABLE_ALL);
-	[p0] = r0;
-	SSYNC;
-
 	RTS;
 ENDPROC(_start_dma_code)
 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
diff --git a/arch/blackfin/mach-bf548/ints-priority.c
b/arch/blackfin/mach-bf548/ints-priority.c
index 2665653..9dd0fa3 100644
--- a/arch/blackfin/mach-bf548/ints-priority.c
+++ b/arch/blackfin/mach-bf548/ints-priority.c
@@ -31,7 +31,7 @@
 #include <linux/irq.h>
 #include <asm/blackfin.h>

-void program_IAR(void)
+void __init program_IAR(void)
 {
 	/* Program the IAR0 Register with the configured priority */
 	bfin_write_SIC_IAR0(((CONFIG_IRQ_PLL_WAKEUP - 7) << IRQ_PLL_WAKEUP_POS) |
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c
b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 466ef59..8f40990 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -54,16 +54,16 @@ const char bfin_board_name[] = "Bluetechnix CM BF561";
 #if defined(CONFIG_MTD_M25P80) || defined(CONFIG_MTD_M25P80_MODULE)
 static struct mtd_partition bfin_spi_flash_partitions[] = {
 	{
-		.name = "bootloader",
+		.name = "bootloader(spi)",
 		.size = 0x00020000,
 		.offset = 0,
 		.mask_flags = MTD_CAP_ROM
 	}, {
-		.name = "kernel",
+		.name = "linux kernel(spi)",
 		.size = 0xe0000,
 		.offset = 0x20000
 	}, {
-		.name = "file system",
+		.name = "file system(spi)",
 		.size = 0x700000,
 		.offset = 0x00100000,
 	}
@@ -306,7 +306,7 @@ static struct platform_device bfin_sir_device = {
 #endif

 #if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	119
+#define PATA_INT	IRQ_PF46

 static struct pata_platform_info bfin_pata_platform_data = {
 	.ioport_shift = 2,
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c
b/arch/blackfin/mach-bf561/boards/ezkit.c
index bc6fede..50b4cdc 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -35,7 +35,6 @@
 #include <linux/spi/spi.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/ata_platform.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
@@ -243,15 +242,15 @@ static struct platform_device bfin_sir_device = {
 #if defined(CONFIG_MTD_PHYSMAP) || defined(CONFIG_MTD_PHYSMAP_MODULE)
 static struct mtd_partition ezkit_partitions[] = {
 	{
-		.name       = "Bootloader",
+		.name       = "bootloader(nor)",
 		.size       = 0x40000,
 		.offset     = 0,
 	}, {
-		.name       = "Kernel",
+		.name       = "linux kernel(nor)",
 		.size       = 0x1C0000,
 		.offset     = MTDPART_OFS_APPEND,
 	}, {
-		.name       = "RootFS",
+		.name       = "file system(nor)",
 		.size       = MTDPART_SIZ_FULL,
 		.offset     = MTDPART_OFS_APPEND,
 	}
@@ -350,43 +349,6 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 #endif
 };

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-#define PATA_INT	55
-
-static struct pata_platform_info bfin_pata_platform_data = {
-	.ioport_shift = 1,
-	.irq_type = IRQF_TRIGGER_HIGH | IRQF_DISABLED,
-};
-
-static struct resource bfin_pata_resources[] = {
-	{
-		.start = 0x20314020,
-		.end = 0x2031403F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = 0x2031401C,
-		.end = 0x2031401F,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = PATA_INT,
-		.end = PATA_INT,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pata_device = {
-	.name = "pata_platform",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pata_resources),
-	.resource = bfin_pata_resources,
-	.dev = {
-		.platform_data = &bfin_pata_platform_data,
-	}
-};
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 #include <linux/input.h>
 #include <linux/gpio_keys.h>
@@ -499,10 +461,6 @@ static struct platform_device *ezkit_devices[]
__initdata = {
 	&bfin_sir_device,
 #endif

-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	&bfin_pata_device,
-#endif
-
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
 	&bfin_device_gpiokeys,
 #endif
@@ -538,10 +496,6 @@ static int __init ezkit_init(void)
 #endif

 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
-
-#if defined(CONFIG_PATA_PLATFORM) || defined(CONFIG_PATA_PLATFORM_MODULE)
-	irq_desc[PATA_INT].status |= IRQ_NOAUTOEN;
-#endif
 	return 0;
 }

diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index cf1a2df..c7a81e3 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -30,284 +30,13 @@
 #include <linux/linkage.h>
 #include <linux/init.h>
 #include <asm/blackfin.h>
-#include <asm/trace.h>
-
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 #include <asm/mach-common/clocks.h>
 #include <asm/mach/mem_init.h>
 #endif

-.extern ___bss_stop
-.extern ___bss_start
-.extern _bf53x_relocate_l1_mem
-
-#define INITIAL_STACK	0xFFB01000
-
-__INIT
-
-ENTRY(__start)
-	/* R0: argument of command line string, passed from uboot, save it */
-	R7 = R0;
-	/* Enable Cycle Counter and Nesting Of Interrupts */
-#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
-	R0 = SYSCFG_SNEN;
-#else
-	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
-#endif
-	SYSCFG = R0;
-	R0 = 0;
-
-	/* Clear Out All the data and pointer Registers */
-	R1 = R0;
-	R2 = R0;
-	R3 = R0;
-	R4 = R0;
-	R5 = R0;
-	R6 = R0;
-
-	P0 = R0;
-	P1 = R0;
-	P2 = R0;
-	P3 = R0;
-	P4 = R0;
-	P5 = R0;
-
-	LC0 = r0;
-	LC1 = r0;
-	L0 = r0;
-	L1 = r0;
-	L2 = r0;
-	L3 = r0;
-
-	/* Clear Out All the DAG Registers */
-	B0 = r0;
-	B1 = r0;
-	B2 = r0;
-	B3 = r0;
-
-	I0 = r0;
-	I1 = r0;
-	I2 = r0;
-	I3 = r0;
-
-	M0 = r0;
-	M1 = r0;
-	M2 = r0;
-	M3 = r0;
-
-	trace_buffer_init(p0,r0);
-	P0 = R1;
-	R0 = R1;
-
-	/* Turn off the icache */
-	p0.l = LO(IMEM_CONTROL);
-	p0.h = HI(IMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENICPLB;
-	R0 = R0 & R1;
-
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Turn off the dcache */
-	p0.l = LO(DMEM_CONTROL);
-	p0.h = HI(DMEM_CONTROL);
-	R1 = [p0];
-	R0 = ~ENDCPLB;
-	R0 = R0 & R1;
-
-	/* Anomaly 05000125 */
-#if ANOMALY_05000125
-	CLI R2;
-	SSYNC;
-#endif
-	[p0] = R0;
-	SSYNC;
-#if ANOMALY_05000125
-	STI R2;
-#endif
-
-	/* Initialise UART - when booting from u-boot, the UART is not disabled
-	 * so if we dont initalize here, our serial console gets hosed */
-	p0.h = hi(BFIN_UART_LCR);
-	p0.l = lo(BFIN_UART_LCR);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable DLL writes */
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLL);
-	p0.l = lo(BFIN_UART_DLL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_DLH);
-	p0.l = lo(BFIN_UART_DLH);
-	r0 = 0x00(Z);
-	w[p0] = r0.L;
-	ssync;
-
-	p0.h = hi(BFIN_UART_GCTL);
-	p0.l = lo(BFIN_UART_GCTL);
-	r0 = 0x0(Z);
-	w[p0] = r0.L;	/* To enable UART clock */
-	ssync;
-
-	/* Initialize stack pointer */
-	sp.l = lo(INITIAL_STACK);
-	sp.h = hi(INITIAL_STACK);
-	fp = sp;
-	usp = sp;
-
-#ifdef CONFIG_EARLY_PRINTK
-	SP += -12;
-	call _init_early_exception_vectors;
-	SP += 12;
-#endif
-
-	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
-	call _bf53x_relocate_l1_mem;
-#if CONFIG_BFIN_KERNEL_CLOCK
-	call _start_dma_code;
-#endif
-
-	/* Code for initializing Async memory banks */
-
-	p2.h = hi(EBIU_AMBCTL1);
-	p2.l = lo(EBIU_AMBCTL1);
-	r0.h = hi(AMBCTL1VAL);
-	r0.l = lo(AMBCTL1VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMBCTL0);
-	p2.l = lo(EBIU_AMBCTL0);
-	r0.h = hi(AMBCTL0VAL);
-	r0.l = lo(AMBCTL0VAL);
-	[p2] = r0;
-	ssync;
-
-	p2.h = hi(EBIU_AMGCTL);
-	p2.l = lo(EBIU_AMGCTL);
-	r0 = AMGCTLVAL;
-	w[p2] = r0;
-	ssync;
-
-	/* This section keeps the processor in supervisor mode
-	 * during kernel boot.  Switches to user mode at end of boot.
-	 * See page 3-9 of Hardware Reference manual for documentation.
-	 */
-
-	/* EVT15 = _real_start */
-
-	p0.l = lo(EVT15);
-	p0.h = hi(EVT15);
-	p1.l = _real_start;
-	p1.h = _real_start;
-	[p0] = p1;
-	csync;
-
-	p0.l = lo(IMASK);
-	p0.h = hi(IMASK);
-	p1.l = IMASK_IVG15;
-	p1.h = 0x0;
-	[p0] = p1;
-	csync;
-
-	raise 15;
-	p0.l = .LWAIT_HERE;
-	p0.h = .LWAIT_HERE;
-	reti = p0;
-#if ANOMALY_05000281
-	nop; nop; nop;
-#endif
-	rti;
-
-.LWAIT_HERE:
-	jump .LWAIT_HERE;
-ENDPROC(__start)
-
-ENTRY(_real_start)
-	[ -- sp ] = reti;
-	p0.l = lo(WDOGA_CTL);
-	p0.h = hi(WDOGA_CTL);
-	r0 = 0xAD6(z);
-	w[p0] = r0;	/* watchdog off for now */
-	ssync;
-
-	/* Code update for BSS size == 0
-	 * Zero out the bss region.
-	 */
-
-	p1.l = ___bss_start;
-	p1.h = ___bss_start;
-	p2.l = ___bss_stop;
-	p2.h = ___bss_stop;
-	r0 = 0;
-	p2 -= p1;
-	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
-.L_clear_bss:
-	B[p1++] = r0;
-
-	/* In case there is a NULL pointer reference
-	 * Zero out region before stext
-	 */
-
-	p1.l = 0x0;
-	p1.h = 0x0;
-	r0.l = __stext;
-	r0.h = __stext;
-	r0 = r0 >> 1;
-	p2 = r0;
-	r0 = 0;
-	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
-.L_clear_zero:
-	W[p1++] = r0;
-
-	/* pass the uboot arguments to the global value command line */
-	R0 = R7;
-	call _cmdline_init;
-
-	p1.l = __rambase;
-	p1.h = __rambase;
-	r0.l = __sdata;
-	r0.h = __sdata;
-	[p1] = r0;
-
-	p1.l = __ramstart;
-	p1.h = __ramstart;
-	p3.l = ___bss_stop;
-	p3.h = ___bss_stop;
-
-	r1 = p3;
-	[p1] = r1;
-
-	/*
-	 * load the current thread pointer and stack
-	 */
-	r1.l = _init_thread_union;
-	r1.h = _init_thread_union;
-
-	r2.l = 0x2000;
-	r2.h = 0x0000;
-	r1 = r1 + r2;
-	sp = r1;
-	usp = sp;
-	fp = sp;
-	jump.l _start_kernel;
-ENDPROC(_real_start)
-
-__FINIT
-
 .section .l1.text
-#if CONFIG_BFIN_KERNEL_CLOCK
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
 ENTRY(_start_dma_code)
 	p0.h = hi(SICA_IWR0);
 	p0.l = lo(SICA_IWR0);
diff --git a/arch/blackfin/mach-bf561/ints-priority.c
b/arch/blackfin/mach-bf561/ints-priority.c
index 09b541b..9d2f233 100644
--- a/arch/blackfin/mach-bf561/ints-priority.c
+++ b/arch/blackfin/mach-bf561/ints-priority.c
@@ -31,7 +31,7 @@
 #include <linux/irq.h>
 #include <asm/blackfin.h>

-void program_IAR(void)
+void __init program_IAR(void)
 {
 	/* Program the IAR0 Register with the configured priority */
 	bfin_write_SICA_IAR0(((CONFIG_IRQ_PLL_WAKEUP - 7) << IRQ_PLL_WAKEUP_POS) |
diff --git a/arch/blackfin/mach-common/Makefile
b/arch/blackfin/mach-common/Makefile
index 422bfee..e6ed57c 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -3,9 +3,10 @@
 #

 obj-y := \
-	cache.o cacheinit.o entry.o \
-	interrupt.o lock.o irqpanic.o arch_checks.o ints-priority.o
+	cache.o entry.o head.o \
+	interrupt.o irqpanic.o arch_checks.o ints-priority.o

+obj-$(CONFIG_BFIN_ICACHE_LOCK) += lock.o
 obj-$(CONFIG_PM)          += pm.o dpmc_modes.o
 obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
 obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
diff --git a/arch/blackfin/mach-common/arch_checks.c
b/arch/blackfin/mach-common/arch_checks.c
index f9160d8..5986758 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -27,6 +27,7 @@
  * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */

+#include <asm/fixed_code.h>
 #include <asm/mach/anomaly.h>
 #include <asm/mach-common/clocks.h>

@@ -53,3 +54,11 @@
 # endif

 #endif /* CONFIG_BFIN_KERNEL_CLOCK */
+
+#if CONFIG_BOOT_LOAD < FIXED_CODE_END
+# error "The kernel load address must be after the fixed code section"
+#endif
+
+#if (CONFIG_BOOT_LOAD & 0x3)
+# error "The kernel load address must be 4 byte aligned"
+#endif
diff --git a/arch/blackfin/mach-common/cache.S
b/arch/blackfin/mach-common/cache.S
index 0521b15..85f8c79 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -34,81 +34,6 @@
 #include <asm/cache.h>

 .text
-.align 2
-ENTRY(_cache_invalidate)
-
-	/*
-	 * Icache or DcacheA or DcacheB Invalidation
-	 * or any combination thereof
-	 * R0 has bits
-	 * CPLB_ENABLE_ICACHE_P,CPLB_ENABLE_DCACHE_P,CPLB_ENABLE_DCACHE2_P
-	 * set as required
-	 */
-	[--SP] = R7;
-
-	R7 = R0;
-	CC = BITTST(R7,CPLB_ENABLE_ICACHE_P);
-	IF !CC JUMP .Lno_icache;
-	[--SP] = RETS;
-	CALL _icache_invalidate;
-	RETS = [SP++];
-.Lno_icache:
-	CC = BITTST(R7,CPLB_ENABLE_DCACHE_P);
-	IF !CC JUMP .Lno_dcache_a;
-	R0 = 0;         /* specifies bank A */
-	[--SP] = RETS;
-	CALL _dcache_invalidate;
-	RETS = [SP++];
-.Lno_dcache_a:
-	CC = BITTST(R7,CPLB_ENABLE_DCACHE2_P);
-	IF !CC JUMP .Lno_dcache_b;
-	R0 = 0;
-	BITSET(R0, 23);		/* specifies bank B */
-	[--SP] = RETS;
-	CALL  _dcache_invalidate;
-	RETS = [SP++];
-.Lno_dcache_b:
-	R7 = [SP++];
-	RTS;
-ENDPROC(_cache_invalidate)
-
-/* Invalidate the Entire Instruction cache by
- * disabling IMC bit
- */
-ENTRY(_icache_invalidate)
-ENTRY(_invalidate_entire_icache)
-	[--SP] = ( R7:5);
-
-	P0.L = LO(IMEM_CONTROL);
-	P0.H = HI(IMEM_CONTROL);
-	R7 = [P0];
-
-	/* Clear the IMC bit , All valid bits in the instruction
-	 * cache are set to the invalid state
-	 */
-	BITCLR(R7,IMC_P);
-	CLI R6;
-	SSYNC;		/* SSYNC required before invalidating cache. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	/* Configures the instruction cache agian */
-	R6 = (IMC | ENICPLB);
-	R7 = R7 | R6;
-
-	CLI R6;
-	SSYNC;		/* SSYNC required before writing to IMEM_CONTROL. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	( R7:5) = [SP++];
-	RTS;
-ENDPROC(_invalidate_entire_icache)
-ENDPROC(_icache_invalidate)

 /*
  * blackfin_cache_flush_range(start, end)
@@ -190,46 +115,6 @@ ENTRY(_blackfin_dcache_invalidate_range)
 	RTS;
 ENDPROC(_blackfin_dcache_invalidate_range)

-/* Invalidate the Entire Data cache by
- * clearing DMC[1:0] bits
- */
-ENTRY(_invalidate_entire_dcache)
-ENTRY(_dcache_invalidate)
-	[--SP] = ( R7:6);
-
-	P0.L = LO(DMEM_CONTROL);
-	P0.H = HI(DMEM_CONTROL);
-	R7 = [P0];
-
-	/* Clear the DMC[1:0] bits, All valid bits in the data
-	 * cache are set to the invalid state
-	 */
-	BITCLR(R7,DMC0_P);
-	BITCLR(R7,DMC1_P);
-	CLI R6;
-	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	/* Configures the data cache again */
-
-	R6 = DMEM_CNTR;
-	R7 = R7 | R6;
-
-	CLI R6;
-	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
-	.align 8;
-	[P0] = R7;
-	SSYNC;
-	STI R6;
-
-	( R7:6) = [SP++];
-	RTS;
-ENDPROC(_dcache_invalidate)
-ENDPROC(_invalidate_entire_dcache)
-
 ENTRY(_blackfin_dcache_flush_range)
 	R2 = -L1_CACHE_BYTES;
 	R2 = R0 & R2;
diff --git a/arch/blackfin/mach-common/cacheinit.S
b/arch/blackfin/mach-common/cacheinit.S
deleted file mode 100644
index 22fada0..0000000
--- a/arch/blackfin/mach-common/cacheinit.S
+++ /dev/null
@@ -1,77 +0,0 @@
-/*
- * File:         arch/blackfin/mach-common/cacheinit.S
- * Based on:
- * Author:       LG Soft India
- *
- * Created:      ?
- * Description:  cache initialization
- *
- * Modified:
- *               Copyright 2004-2006 Analog Devices Inc.
- *
- * Bugs:         Enter bugs at http://blackfin.uclinux.org/
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see the file COPYING, or write
- * to the Free Software Foundation, Inc.,
- * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-
-/* This function sets up the data and instruction cache. The
- * tables like icplb table, dcplb table and Page Descriptor table
- * are defined in cplbtab.h. You can configure those tables for
- * your suitable requirements
- */
-
-#include <linux/linkage.h>
-#include <asm/blackfin.h>
-
-.text
-
-#if ANOMALY_05000125
-#if defined(CONFIG_BFIN_ICACHE)
-ENTRY(_bfin_write_IMEM_CONTROL)
-
-	/* Enable Instruction Cache */
-	P0.l = LO(IMEM_CONTROL);
-	P0.h = HI(IMEM_CONTROL);
-
-	/* Anomaly 05000125 */
-	CLI R1;
-	SSYNC;		/* SSYNC required before writing to IMEM_CONTROL. */
-	.align 8;
-	[P0] = R0;
-	SSYNC;
-	STI R1;
-	RTS;
-
-ENDPROC(_bfin_write_IMEM_CONTROL)
-#endif
-
-#if defined(CONFIG_BFIN_DCACHE)
-ENTRY(_bfin_write_DMEM_CONTROL)
-	P0.l = LO(DMEM_CONTROL);
-	P0.h = HI(DMEM_CONTROL);
-
-	CLI R1;
-	SSYNC;		/* SSYNC required before writing to DMEM_CONTROL. */
-	.align 8;
-	[P0] = R0;
-	SSYNC;
-	STI R1;
-	RTS;
-
-ENDPROC(_bfin_write_DMEM_CONTROL)
-#endif
-
-#endif
diff --git a/arch/blackfin/mach-common/dpmc_modes.S
b/arch/blackfin/mach-common/dpmc_modes.S
index 5e3f1d8..838b0b2 100644
--- a/arch/blackfin/mach-common/dpmc_modes.S
+++ b/arch/blackfin/mach-common/dpmc_modes.S
@@ -78,62 +78,6 @@ ENTRY(_hibernate_mode)
 	jump .Lforever;
 ENDPROC(_hibernate_mode)

-ENTRY(_deep_sleep)
-	[--SP] = ( R7:0, P5:0 );
-	[--SP] =  RETS;
-
-	CLI R4;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-
-	call _set_dram_srfs;
-
-	/* Clear all the interrupts,bits sticky */
-	R0 = 0xFFFF (Z);
-	call _set_rtc_istat
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R0 = W[P0](z);
-	BITSET (R0, 5);
-	W[P0] = R0.L;
-
-	call _test_pll_locked;
-
-	SSYNC;
-	IDLE;
-
-	call _unset_dram_srfs;
-
-	call _test_pll_locked;
-
-	R0 = IWR_ENABLE(0);
-	R1 = IWR_DISABLE_ALL;
-	R2 = IWR_DISABLE_ALL;
-
-	call _set_sic_iwr;
-
-	P0.H = hi(PLL_CTL);
-	P0.L = lo(PLL_CTL);
-	R0 = w[p0](z);
-	BITCLR (R0, 3);
-	BITCLR (R0, 5);
-	BITCLR (R0, 8);
-	w[p0] = R0;
-	IDLE;
-	call _test_pll_locked;
-
-	STI R4;
-
-	RETS = [SP++];
-	( R7:0, P5:0 ) = [SP++];
-	RTS;
-ENDPROC(_deep_sleep)
-
 ENTRY(_sleep_deeper)
 	[--SP] = ( R7:0, P5:0 );
 	[--SP] =  RETS;
diff --git a/arch/blackfin/mach-common/entry.S
b/arch/blackfin/mach-common/entry.S
index eceb484..117c01c 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -158,14 +158,16 @@ ENTRY(_ex_single_step)
 	cc = r7 == r6;
 	if cc jump _bfin_return_from_exception;

+#ifdef CONFIG_KGDB
 	/* Don't do single step in hardware exception handler */
         p5.l = lo(IPEND);
         p5.h = hi(IPEND);
 	r6 = [p5];
+	cc = bittst(r6, 4);
+	if cc jump _bfin_return_from_exception;
 	cc = bittst(r6, 5);
 	if cc jump _bfin_return_from_exception;

-#ifdef CONFIG_KGDB
 	/* skip single step if current interrupt priority is higher than
 	 * that of the first instruction, from which gdb starts single step */
 	r6 >>= 6;
@@ -186,17 +188,27 @@ ENTRY(_ex_single_step)
 	if cc jump .Ldo_single_step;
 	r6 += -1;
 	cc = r6 < r7;
-	if cc jump _bfin_return_from_exception;
+	if cc jump 1f;
 .Ldo_single_step:
-#endif
-
+#else
 	/* If we were in user mode, do the single step normally.  */
+	p5.l = lo(IPEND);
+	p5.h = hi(IPEND);
 	r6 = [p5];
 	r7 = 0xffe0 (z);
 	r7 = r7 & r6;
 	cc = r7 == 0;
-	if cc jump 1f;
+	if !cc jump 1f;
+#endif

+	/* Single stepping only a single instruction, so clear the trace
+	 * bit here.  */
+	r7 = syscfg;
+	bitclr (r7, 0);
+	syscfg = R7;
+	jump _ex_trap_c;
+
+1:
 	/*
 	 * We were in an interrupt handler.  By convention, all of them save
 	 * SYSCFG with their first instruction, so by checking whether our
@@ -224,15 +236,11 @@ ENTRY(_ex_single_step)
 	cc = R7 == R6;
 	if !cc jump _bfin_return_from_exception;

-1:
-	/* Single stepping only a single instruction, so clear the trace
-	 * bit here.  */
 	r7 = syscfg;
 	bitclr (r7, 0);
 	syscfg = R7;

-	jump _ex_trap_c;
-
+	/* Fall through to _bfin_return_from_exception.  */
 ENDPROC(_ex_single_step)

 ENTRY(_bfin_return_from_exception)
@@ -1414,6 +1422,12 @@ ENTRY(_sys_call_table)
 	.long _sys_semtimedop
 	.long _sys_timerfd_settime
 	.long _sys_timerfd_gettime
+	.long _sys_signalfd4		/* 360 */
+	.long _sys_eventfd2
+	.long _sys_epoll_create1
+	.long _sys_dup3
+	.long _sys_pipe2
+	.long _sys_inotify_init1	/* 365 */

 	.rept NR_syscalls-(.-_sys_call_table)/4
 	.long _sys_ni_syscall
diff --git a/arch/blackfin/mach-common/head.S b/arch/blackfin/mach-common/head.S
new file mode 100644
index 0000000..191b4e9
--- /dev/null
+++ b/arch/blackfin/mach-common/head.S
@@ -0,0 +1,207 @@
+/*
+ * Common Blackfin startup code
+ *
+ * Copyright 2004-2008 Analog Devices Inc.
+ *
+ * Enter bugs at http://blackfin.uclinux.org/
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/linkage.h>
+#include <linux/init.h>
+#include <asm/blackfin.h>
+#include <asm/thread_info.h>
+#include <asm/trace.h>
+
+__INIT
+
+#define INITIAL_STACK	(L1_SCRATCH_START + L1_SCRATCH_LENGTH - 12)
+
+ENTRY(__start)
+	/* R0: argument of command line string, passed from uboot, save it */
+	R7 = R0;
+	/* Enable Cycle Counter and Nesting Of Interrupts */
+#ifdef CONFIG_BFIN_SCRATCH_REG_CYCLES
+	R0 = SYSCFG_SNEN;
+#else
+	R0 = SYSCFG_SNEN | SYSCFG_CCEN;
+#endif
+	SYSCFG = R0;
+	R0 = 0;
+
+	/* Clear Out All the data and pointer Registers */
+	R1 = R0;
+	R2 = R0;
+	R3 = R0;
+	R4 = R0;
+	R5 = R0;
+	R6 = R0;
+
+	P0 = R0;
+	P1 = R0;
+	P2 = R0;
+	P3 = R0;
+	P4 = R0;
+	P5 = R0;
+
+	LC0 = r0;
+	LC1 = r0;
+	L0 = r0;
+	L1 = r0;
+	L2 = r0;
+	L3 = r0;
+
+	/* Clear Out All the DAG Registers */
+	B0 = r0;
+	B1 = r0;
+	B2 = r0;
+	B3 = r0;
+
+	I0 = r0;
+	I1 = r0;
+	I2 = r0;
+	I3 = r0;
+
+	M0 = r0;
+	M1 = r0;
+	M2 = r0;
+	M3 = r0;
+
+	trace_buffer_init(p0,r0);
+	P0 = R1;
+	R0 = R1;
+
+	/* Turn off the icache */
+	p0.l = LO(IMEM_CONTROL);
+	p0.h = HI(IMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENICPLB;
+	R0 = R0 & R1;
+	[p0] = R0;
+	SSYNC;
+
+	/* Turn off the dcache */
+	p0.l = LO(DMEM_CONTROL);
+	p0.h = HI(DMEM_CONTROL);
+	R1 = [p0];
+	R0 = ~ENDCPLB;
+	R0 = R0 & R1;
+	[p0] = R0;
+	SSYNC;
+
+	/* Save RETX, in case of doublefault */
+	p0.l = ___retx;
+	p0.h = ___retx;
+	R0 = RETX;
+	[P0] = R0;
+
+	/* Initialize stack pointer */
+	sp.l = lo(INITIAL_STACK);
+	sp.h = hi(INITIAL_STACK);
+	fp = sp;
+	usp = sp;
+
+#ifdef CONFIG_EARLY_PRINTK
+	call _init_early_exception_vectors;
+#endif
+
+	/* Put The Code for PLL Programming and SDRAM Programming in L1 ISRAM */
+	call _bf53x_relocate_l1_mem;
+#ifdef CONFIG_BFIN_KERNEL_CLOCK
+	call _start_dma_code;
+#endif
+
+	/* This section keeps the processor in supervisor mode
+	 * during kernel boot.  Switches to user mode at end of boot.
+	 * See page 3-9 of Hardware Reference manual for documentation.
+	 */
+
+	/* EVT15 = _real_start */
+
+	p0.l = lo(EVT15);
+	p0.h = hi(EVT15);
+	p1.l = _real_start;
+	p1.h = _real_start;
+	[p0] = p1;
+	csync;
+
+	p0.l = lo(IMASK);
+	p0.h = hi(IMASK);
+	p1.l = IMASK_IVG15;
+	p1.h = 0x0;
+	[p0] = p1;
+	csync;
+
+	raise 15;
+	p0.l = .LWAIT_HERE;
+	p0.h = .LWAIT_HERE;
+	reti = p0;
+#if ANOMALY_05000281
+	nop; nop; nop;
+#endif
+	rti;
+
+.LWAIT_HERE:
+	jump .LWAIT_HERE;
+ENDPROC(__start)
+
+/* A little BF561 glue ... */
+#ifndef WDOG_CTL
+# define WDOG_CTL WDOGA_CTL
+#endif
+
+ENTRY(_real_start)
+	/* Enable nested interrupts */
+	[--sp] = reti;
+
+	/* watchdog off for now */
+	p0.l = lo(WDOG_CTL);
+	p0.h = hi(WDOG_CTL);
+	r0 = 0xAD6(z);
+	w[p0] = r0;
+	ssync;
+
+	/* Zero out the bss region
+	 * Note: this will fail if bss is 0 bytes ...
+	 */
+	r0 = 0 (z);
+	r1.l = ___bss_start;
+	r1.h = ___bss_start;
+	r2.l = ___bss_stop;
+	r2.h = ___bss_stop;
+	r2 = r2 - r1;
+	r2 >>= 2;
+	p1 = r1;
+	p2 = r2;
+	lsetup (.L_clear_bss, .L_clear_bss) lc0 = p2;
+.L_clear_bss:
+	[p1++] = r0;
+
+	/* In case there is a NULL pointer reference,
+	 * zero out region before stext
+	 */
+	p1 = r0;
+	r2.l = __stext;
+	r2.h = __stext;
+	r2 >>= 2;
+	p2 = r2;
+	lsetup (.L_clear_zero, .L_clear_zero) lc0 = p2;
+.L_clear_zero:
+	[p1++] = r0;
+
+	/* Pass the u-boot arguments to the global value command line */
+	R0 = R7;
+	call _cmdline_init;
+
+	/* Load the current thread pointer and stack */
+	sp.l = _init_thread_union;
+	sp.h = _init_thread_union;
+	p1 = THREAD_SIZE (z);
+	sp = sp + p1;
+	usp = sp;
+	fp = sp;
+	jump.l _start_kernel;
+ENDPROC(_real_start)
+
+__FINIT
diff --git a/arch/blackfin/mach-common/ints-priority.c
b/arch/blackfin/mach-common/ints-priority.c
index 64d7461..62f8883 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -71,6 +71,7 @@ atomic_t num_spurious;

 #ifdef CONFIG_PM
 unsigned long bfin_sic_iwr[3];	/* Up to 3 SIC_IWRx registers */
+unsigned vr_wakeup;
 #endif

 struct ivgx {
@@ -184,17 +185,56 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 #ifdef CONFIG_PM
 int bfin_internal_set_wake(unsigned int irq, unsigned int state)
 {
-	unsigned bank, bit;
+	unsigned bank, bit, wakeup = 0;
 	unsigned long flags;
 	bank = SIC_SYSIRQ(irq) / 32;
 	bit = SIC_SYSIRQ(irq) % 32;

+	switch (irq) {
+#ifdef IRQ_RTC
+	case IRQ_RTC:
+	wakeup |= WAKE;
+	break;
+#endif
+#ifdef IRQ_CAN0_RX
+	case IRQ_CAN0_RX:
+	wakeup |= CANWE;
+	break;
+#endif
+#ifdef IRQ_CAN1_RX
+	case IRQ_CAN1_RX:
+	wakeup |= CANWE;
+	break;
+#endif
+#ifdef IRQ_USB_INT0
+	case IRQ_USB_INT0:
+	wakeup |= USBWE;
+	break;
+#endif
+#ifdef IRQ_KEY
+	case IRQ_KEY:
+	wakeup |= KPADWE;
+	break;
+#endif
+#ifdef IRQ_CNT
+	case IRQ_CNT:
+	wakeup |= ROTWE;
+	break;
+#endif
+	default:
+	break;
+	}
+
 	local_irq_save(flags);

-	if (state)
+	if (state) {
 		bfin_sic_iwr[bank] |= (1 << bit);
-	else
+		vr_wakeup  |= wakeup;
+
+	} else {
 		bfin_sic_iwr[bank] &= ~(1 << bit);
+		vr_wakeup  &= ~wakeup;
+	}

 	local_irq_restore(flags);

@@ -943,6 +983,11 @@ int __init init_arch_irq(void)

 	local_irq_disable();

+#if defined(CONFIG_BF527) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
+	/* Clear EMAC Interrupt Status bits so we can demux it later */
+	bfin_write_EMAC_SYSTAT(-1);
+#endif
+
 #ifdef CONFIG_BF54x
 # ifdef CONFIG_PINTx_REASSIGN
 	pint[0]->assign = CONFIG_PINT0_ASSIGN;
@@ -1028,13 +1073,22 @@ int __init init_arch_irq(void)
 	    IMASK_IVG10 | IMASK_IVG9 | IMASK_IVG8 | IMASK_IVG7 | IMASK_IVGHW;

 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x) || defined(CONFIG_BF561)
-	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
-	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR0(IWR_DISABLE_ALL);
+#if defined(CONFIG_BF52x)
+	/* BF52x system reset does not properly reset SIC_IWR1 which
+	 * will screw up the bootrom as it relies on MDMA0/1 waking it
+	 * up from IDLE instructions.  See this report for more info:
+	 * http://blackfin.uclinux.org/gf/tracker/4323
+	 */
+	bfin_write_SIC_IWR1(IWR_ENABLE(10) | IWR_ENABLE(11));
+#else
+	bfin_write_SIC_IWR1(IWR_DISABLE_ALL);
+#endif
 # ifdef CONFIG_BF54x
-	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR2(IWR_DISABLE_ALL);
 # endif
 #else
-	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR(IWR_DISABLE_ALL);
 #endif

 	return 0;
diff --git a/arch/blackfin/mach-common/lock.S b/arch/blackfin/mach-common/lock.S
index 30b887e..9daf012 100644
--- a/arch/blackfin/mach-common/lock.S
+++ b/arch/blackfin/mach-common/lock.S
@@ -28,13 +28,10 @@
  */

 #include <linux/linkage.h>
-#include <asm/cplb.h>
 #include <asm/blackfin.h>

 .text

-#ifdef CONFIG_BFIN_ICACHE_LOCK
-
 /* When you come here, it is assumed that
  * R0 - Which way to be locked
  */
@@ -189,18 +186,38 @@ ENTRY(_cache_lock)
 	RTS;
 ENDPROC(_cache_lock)

-#endif	/* BFIN_ICACHE_LOCK */
-
-/* Return the ILOC bits of IMEM_CONTROL
+/* Invalidate the Entire Instruction cache by
+ * disabling IMC bit
  */
+ENTRY(_invalidate_entire_icache)
+	[--SP] = ( R7:5);

-ENTRY(_read_iloc)
-	P1.H = HI(IMEM_CONTROL);
-	P1.L = LO(IMEM_CONTROL);
-	R1 = 0xF;
-	R0 = [P1];
-	R0 = R0 >> 3;
-	R0 = R0 & R1;
+	P0.L = LO(IMEM_CONTROL);
+	P0.H = HI(IMEM_CONTROL);
+	R7 = [P0];
+
+	/* Clear the IMC bit , All valid bits in the instruction
+	 * cache are set to the invalid state
+	 */
+	BITCLR(R7,IMC_P);
+	CLI R6;
+	SSYNC;		/* SSYNC required before invalidating cache. */
+	.align 8;
+	[P0] = R7;
+	SSYNC;
+	STI R6;
+
+	/* Configures the instruction cache agian */
+	R6 = (IMC | ENICPLB);
+	R7 = R7 | R6;
+
+	CLI R6;
+	SSYNC;		/* SSYNC required before writing to IMEM_CONTROL. */
+	.align 8;
+	[P0] = R7;
+	SSYNC;
+	STI R6;

+	( R7:5) = [SP++];
 	RTS;
-ENDPROC(_read_iloc)
+ENDPROC(_invalidate_entire_icache)
diff --git a/arch/blackfin/mach-common/pm.c b/arch/blackfin/mach-common/pm.c
index 4fe6a23..e28c6af 100644
--- a/arch/blackfin/mach-common/pm.c
+++ b/arch/blackfin/mach-common/pm.c
@@ -83,13 +83,22 @@ void bfin_pm_suspend_standby_enter(void)
 	bfin_pm_standby_restore();

 #if defined(CONFIG_BF54x) || defined(CONFIG_BF52x)  || defined(CONFIG_BF561)
-	bfin_write_SIC_IWR0(IWR_ENABLE_ALL);
-	bfin_write_SIC_IWR1(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR0(IWR_DISABLE_ALL);
+#if defined(CONFIG_BF52x)
+	/* BF52x system reset does not properly reset SIC_IWR1 which
+	 * will screw up the bootrom as it relies on MDMA0/1 waking it
+	 * up from IDLE instructions.  See this report for more info:
+	 * http://blackfin.uclinux.org/gf/tracker/4323
+	 */
+	bfin_write_SIC_IWR1(IWR_ENABLE(10) | IWR_ENABLE(11));
+#else
+	bfin_write_SIC_IWR1(IWR_DISABLE_ALL);
+#endif
 # ifdef CONFIG_BF54x
-	bfin_write_SIC_IWR2(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR2(IWR_DISABLE_ALL);
 # endif
 #else
-	bfin_write_SIC_IWR(IWR_ENABLE_ALL);
+	bfin_write_SIC_IWR(IWR_DISABLE_ALL);
 #endif

 	local_irq_restore(flags);
@@ -229,28 +238,12 @@ int bfin_pm_suspend_mem_enter(void)
 	wakeup = bfin_read_VR_CTL() & ~FREQ;
 	wakeup |= SCKELOW;

-	/* FIXME: merge this somehow with set_irq_wake */
-#ifdef CONFIG_PM_BFIN_WAKE_RTC
-	wakeup |= WAKE;
-#endif
 #ifdef CONFIG_PM_BFIN_WAKE_PH6
 	wakeup |= PHYWE;
 #endif
-#ifdef CONFIG_PM_BFIN_WAKE_CAN
-	wakeup |= CANWE;
-#endif
 #ifdef CONFIG_PM_BFIN_WAKE_GP
 	wakeup |= GPWE;
 #endif
-#ifdef CONFIG_PM_BFIN_WAKE_USB
-	wakeup |= USBWE;
-#endif
-#ifdef CONFIG_PM_BFIN_WAKE_KEYPAD
-	wakeup |= KPADWE;
-#endif
-#ifdef CONFIG_PM_BFIN_WAKE_ROTARY
-	wakeup |= ROTWE;
-#endif

 	local_irq_save(flags);

@@ -268,7 +261,7 @@ int bfin_pm_suspend_mem_enter(void)
 	icache_disable();
 	bf53x_suspend_l1_mem(memptr);

-	do_hibernate(wakeup);	/* Goodbye */
+	do_hibernate(wakeup | vr_wakeup);	/* Goodbye */

 	bf53x_resume_l1_mem(memptr);

diff --git a/arch/blackfin/mm/blackfin_sram.c b/arch/blackfin/mm/blackfin_sram.c
index 5af3c31..9d2be43 100644
--- a/arch/blackfin/mm/blackfin_sram.c
+++ b/arch/blackfin/mm/blackfin_sram.c
@@ -66,7 +66,7 @@ static struct sram_piece free_l1_data_B_sram_head,
used_l1_data_B_sram_head;
 static struct sram_piece free_l1_inst_sram_head, used_l1_inst_sram_head;
 #endif

-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 static struct sram_piece free_l2_sram_head, used_l2_sram_head;
 #endif

@@ -175,7 +175,7 @@ static void __init l1_inst_sram_init(void)

 static void __init l2_sram_init(void)
 {
-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 	free_l2_sram_head.next =
 		kmem_cache_alloc(sram_piece_cache, GFP_KERNEL);
 	if (!free_l2_sram_head.next) {
@@ -367,7 +367,7 @@ int sram_free(const void *addr)
 		 && addr < (void *)(L1_DATA_B_START + L1_DATA_B_LENGTH))
 		return l1_data_B_sram_free(addr);
 #endif
-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 	else if (addr >= (void *)L2_START
 		 && addr < (void *)(L2_START + L2_LENGTH))
 		return l2_sram_free(addr);
@@ -604,7 +604,7 @@ int l1sram_free(const void *addr)

 void *l2_sram_alloc(size_t size)
 {
-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 	unsigned flags;
 	void *addr;

@@ -640,7 +640,7 @@ EXPORT_SYMBOL(l2_sram_zalloc);

 int l2_sram_free(const void *addr)
 {
-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 	unsigned flags;
 	int ret;

@@ -779,7 +779,7 @@ static int sram_proc_read(char *buf, char **start,
off_t offset, int count,
 			&free_l1_inst_sram_head, &used_l1_inst_sram_head))
 		goto not_done;
 #endif
-#ifdef L2_LENGTH
+#if L2_LENGTH != 0
 	if (_sram_proc_read(buf, &len, count, "L2",
 			&free_l2_sram_head, &used_l2_sram_head))
 		goto not_done;
diff --git a/include/asm-blackfin/Kbuild b/include/asm-blackfin/Kbuild
index 71f8fe7..606ecfd 100644
--- a/include/asm-blackfin/Kbuild
+++ b/include/asm-blackfin/Kbuild
@@ -1,3 +1,3 @@
 include include/asm-generic/Kbuild.asm

-header-y += fixed_code.h
+unifdef-y += fixed_code.h
diff --git a/include/asm-blackfin/bfin-global.h
b/include/asm-blackfin/bfin-global.h
index 320aa5e..7ba70de 100644
--- a/include/asm-blackfin/bfin-global.h
+++ b/include/asm-blackfin/bfin-global.h
@@ -56,37 +56,20 @@ extern void dump_bfin_process(struct pt_regs *regs);
 extern void dump_bfin_mem(struct pt_regs *regs);
 extern void dump_bfin_trace_buffer(void);

+/* init functions only */
 extern int init_arch_irq(void);
-extern void bfin_reset(void);
-extern void _cplb_hdr(void);
-/* Blackfin cache functions */
 extern void bfin_icache_init(void);
 extern void bfin_dcache_init(void);
-extern int read_iloc(void);
-extern int bfin_console_init(void);
-extern asmlinkage void lower_to_irq14(void);
-extern asmlinkage void bfin_return_from_exception(void);
 extern void init_exception_vectors(void);
-extern void init_dma(void);
 extern void program_IAR(void);
-extern void evt14_softirq(void);
+
+extern void bfin_reset(void);
+extern asmlinkage void lower_to_irq14(void);
+extern asmlinkage void bfin_return_from_exception(void);
+extern asmlinkage void evt14_softirq(void);
 extern asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs);
-extern void bfin_gpio_interrupt_setup(int irq, int irq_pfx, int type);
 extern int bfin_internal_set_wake(unsigned int irq, unsigned int state);

-extern asmlinkage void finish_atomic_sections (struct pt_regs *regs);
-extern char fixed_code_start;
-extern char fixed_code_end;
-extern int atomic_xchg32(void);
-extern int atomic_cas32(void);
-extern int atomic_add32(void);
-extern int atomic_sub32(void);
-extern int atomic_ior32(void);
-extern int atomic_and32(void);
-extern int atomic_xor32(void);
-extern void safe_user_instruction(void);
-extern void sigreturn_stub(void);
-
 extern void *l1_data_A_sram_alloc(size_t);
 extern void *l1_data_B_sram_alloc(size_t);
 extern void *l1_inst_sram_alloc(size_t);
@@ -110,11 +93,10 @@ extern void *sram_alloc_with_lsl(size_t, unsigned long);
 extern int sram_free_with_lsl(const void*);

 extern const char bfin_board_name[];
-extern unsigned long wall_jiffies;

 extern unsigned long bfin_sic_iwr[];
+extern unsigned vr_wakeup;
 extern u16 _bfin_swrst; /* shadow for Software Reset Register (SWRST) */
-extern struct file_operations dpmc_fops;
 extern unsigned long _ramstart, _ramend, _rambase;
 extern unsigned long memory_start, memory_end, physical_mem_end;
 extern char _stext_l1[], _etext_l1[], _sdata_l1[], _edata_l1[], _sbss_l1[],
@@ -122,8 +104,12 @@ extern char _stext_l1[], _etext_l1[],
_sdata_l1[], _edata_l1[], _sbss_l1[],
 	_stext_l2[], _etext_l2[], _sdata_l2[], _edata_l2[], _sbss_l2[],
 	_ebss_l2[], _l2_lma_start[];

-#ifdef CONFIG_MTD_UCLINUX
+/* only used when CONFIG_MTD_UCLINUX */
 extern unsigned long memory_mtd_start, memory_mtd_end, mtd_size;
+
+#ifdef CONFIG_BFIN_ICACHE_LOCK
+extern void cache_grab_lock(int way);
+extern void cache_lock(int way);
 #endif

 #endif
diff --git a/include/asm-blackfin/dpmc.h b/include/asm-blackfin/dpmc.h
index de28e6e..96e8208 100644
--- a/include/asm-blackfin/dpmc.h
+++ b/include/asm-blackfin/dpmc.h
@@ -11,7 +11,6 @@
 #ifndef __ASSEMBLY__

 void sleep_mode(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
-void deep_sleep(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void hibernate_mode(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void sleep_deeper(u32 sic_iwr0, u32 sic_iwr1, u32 sic_iwr2);
 void do_hibernate(int wakeup);
diff --git a/include/asm-blackfin/fixed_code.h
b/include/asm-blackfin/fixed_code.h
index 37db66c..32c4d49 100644
--- a/include/asm-blackfin/fixed_code.h
+++ b/include/asm-blackfin/fixed_code.h
@@ -1,6 +1,28 @@
 /* This file defines the fixed addresses where userspace programs can find
    atomic code sequences.  */

+#ifndef __BFIN_ASM_FIXED_CODE_H__
+#define __BFIN_ASM_FIXED_CODE_H__
+
+#ifdef __KERNEL__
+#ifndef __ASSEMBLY__
+#include <linux/linkage.h>
+#include <linux/ptrace.h>
+extern asmlinkage void finish_atomic_sections(struct pt_regs *regs);
+extern char fixed_code_start;
+extern char fixed_code_end;
+extern int atomic_xchg32(void);
+extern int atomic_cas32(void);
+extern int atomic_add32(void);
+extern int atomic_sub32(void);
+extern int atomic_ior32(void);
+extern int atomic_and32(void);
+extern int atomic_xor32(void);
+extern void safe_user_instruction(void);
+extern void sigreturn_stub(void);
+#endif
+#endif
+
 #define FIXED_CODE_START	0x400

 #define SIGRETURN_STUB		0x400
@@ -20,3 +42,5 @@
 #define SAFE_USER_INSTRUCTION   0x480

 #define FIXED_CODE_END		0x490
+
+#endif
diff --git a/include/asm-blackfin/mach-bf527/mem_map.h
b/include/asm-blackfin/mach-bf527/mem_map.h
index 193082d..ef46dc9 100644
--- a/include/asm-blackfin/mach-bf527/mem_map.h
+++ b/include/asm-blackfin/mach-bf527/mem_map.h
@@ -89,6 +89,11 @@
 #define BFIN_DSUPBANKS	0
 #endif				/*CONFIG_BFIN_DCACHE */

+/* Level 2 Memory - none */
+
+#define L2_START	0
+#define L2_LENGTH	0
+
 /* Scratch Pad Memory */

 #define L1_SCRATCH_START	0xFFB00000
diff --git a/include/asm-blackfin/mach-bf533/mem_init.h
b/include/asm-blackfin/mach-bf533/mem_init.h
index 995c06b..ed2034b 100644
--- a/include/asm-blackfin/mach-bf533/mem_init.h
+++ b/include/asm-blackfin/mach-bf533/mem_init.h
@@ -47,7 +47,7 @@
 #define SDRAM_tRCD      TRCD_2
 #define SDRAM_tWR       TWR_2
 #endif
-#if (CONFIG_SCLK_HZ > 8955223) && (CONFIG_SCLK_HZ <= 104477612)
+#if (CONFIG_SCLK_HZ > 89552239) && (CONFIG_SCLK_HZ <= 104477612)
 #define SDRAM_tRP       TRP_2
 #define SDRAM_tRP_num   2
 #define SDRAM_tRAS      TRAS_5
diff --git a/include/asm-blackfin/mach-bf533/mem_map.h
b/include/asm-blackfin/mach-bf533/mem_map.h
index bd30b6f..581fc6e 100644
--- a/include/asm-blackfin/mach-bf533/mem_map.h
+++ b/include/asm-blackfin/mach-bf533/mem_map.h
@@ -158,6 +158,11 @@

 #endif

+/* Level 2 Memory - none */
+
+#define L2_START	0
+#define L2_LENGTH	0
+
 /* Scratch Pad Memory */

 #define L1_SCRATCH_START	0xFFB00000
diff --git a/include/asm-blackfin/mach-bf537/mem_map.h
b/include/asm-blackfin/mach-bf537/mem_map.h
index 5c6726d..5078b66 100644
--- a/include/asm-blackfin/mach-bf537/mem_map.h
+++ b/include/asm-blackfin/mach-bf537/mem_map.h
@@ -166,6 +166,11 @@

 #endif

+/* Level 2 Memory - none */
+
+#define L2_START	0
+#define L2_LENGTH	0
+
 /* Scratch Pad Memory */

 #define L1_SCRATCH_START	0xFFB00000
diff --git a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
index ede210e..d39c396 100644
--- a/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
+++ b/include/asm-blackfin/mach-common/cdef_LPBlackfin.h
@@ -39,11 +39,7 @@
 #define bfin_read_SRAM_BASE_ADDRESS()        bfin_read32(SRAM_BASE_ADDRESS)
 #define bfin_write_SRAM_BASE_ADDRESS(val)
bfin_write32(SRAM_BASE_ADDRESS,val)
 #define bfin_read_DMEM_CONTROL()             bfin_read32(DMEM_CONTROL)
-#if ANOMALY_05000125
-extern void bfin_write_DMEM_CONTROL(unsigned int val);
-#else
 #define bfin_write_DMEM_CONTROL(val)         bfin_write32(DMEM_CONTROL,val)
-#endif
 #define bfin_read_DCPLB_STATUS()             bfin_read32(DCPLB_STATUS)
 #define bfin_write_DCPLB_STATUS(val)         bfin_write32(DCPLB_STATUS,val)
 #define bfin_read_DCPLB_FAULT_ADDR()         bfin_read32(DCPLB_FAULT_ADDR)
@@ -129,11 +125,7 @@ extern void bfin_write_DMEM_CONTROL(unsigned int val);
 #define DTEST_DATA3            0xFFE0040C
 */
 #define bfin_read_IMEM_CONTROL()             bfin_read32(IMEM_CONTROL)
-#if ANOMALY_05000125
-extern void bfin_write_IMEM_CONTROL(unsigned int val);
-#else
 #define bfin_write_IMEM_CONTROL(val)         bfin_write32(IMEM_CONTROL,val)
-#endif
 #define bfin_read_ICPLB_STATUS()             bfin_read32(ICPLB_STATUS)
 #define bfin_write_ICPLB_STATUS(val)         bfin_write32(ICPLB_STATUS,val)
 #define bfin_read_ICPLB_FAULT_ADDR()         bfin_read32(ICPLB_FAULT_ADDR)
diff --git a/include/asm-blackfin/unistd.h b/include/asm-blackfin/unistd.h
index 42955d0..1e57b63 100644
--- a/include/asm-blackfin/unistd.h
+++ b/include/asm-blackfin/unistd.h
@@ -372,8 +372,14 @@
 #define __NR_semtimedop		357
 #define __NR_timerfd_settime	358
 #define __NR_timerfd_gettime	359
+#define __NR_signalfd4		360
+#define __NR_eventfd2		361
+#define __NR_epoll_create1	362
+#define __NR_dup3		363
+#define __NR_pipe2		364
+#define __NR_inotify_init1	365

-#define __NR_syscall		360
+#define __NR_syscall		366
 #define NR_syscalls		__NR_syscall

 /* Old optional stuff no one actually uses */
