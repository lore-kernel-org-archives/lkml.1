Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZCESLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZCESLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZCESL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:11:29 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:40346 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbZCESLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:11:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=RNjB5zFGsfe9NpEtxb2ZD7ZoIdl+9owmVFYWfbVkQ6gJKtLTAVO1XpHFn056UB7urP
         ByvQxER1DKGCJkyz2jN9FGqf6GuEn1QioOG07TccF4uCxUClmo8PnmPS/HO+njtwGK6l
         BJjsn7bYUBG+nUEFFMpfcKX74O1VzKQB8yZ4o=
MIME-Version: 1.0
Date: Fri, 6 Mar 2009 02:11:19 +0800
X-Google-Sender-Auth: 86397e6bd6f8720f
Message-ID: <386072610903051011u5fb2825dvff93543fa8a6d3e@mail.gmail.com>
Subject: Blackfin fixing and updates for 2.6.29-rc7+
From: Bryan Wu <cooloney@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin.git/ for-linus

to receive the following updates:

 arch/blackfin/Kconfig                              |    7 +
 arch/blackfin/Kconfig.debug                        |    6 -
 arch/blackfin/configs/BF518F-EZBRD_defconfig       |   63 ++-
 arch/blackfin/configs/BF527-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BF533-STAMP_defconfig        |    4 +-
 arch/blackfin/configs/BF537-STAMP_defconfig        |   14 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig        |    6 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig        |    4 +-
 arch/blackfin/configs/BlackStamp_defconfig         |    4 +-
 arch/blackfin/configs/CM-BF527_defconfig           |    4 +-
 arch/blackfin/configs/CM-BF548_defconfig           |    6 +-
 arch/blackfin/configs/IP0X_defconfig               |    2 +-
 arch/blackfin/configs/SRV1_defconfig               |    4 +-
 arch/blackfin/include/asm/Kbuild                   |    1 +
 arch/blackfin/include/asm/bfin_sport.h             |   45 +-
 arch/blackfin/include/asm/ipipe.h                  |  100 +--
 arch/blackfin/include/asm/ipipe_base.h             |   12 +-
 arch/blackfin/include/asm/irq.h                    |   36 +-
 arch/blackfin/include/asm/thread_info.h            |    2 +
 arch/blackfin/kernel/Makefile                      |    8 +-
 arch/blackfin/kernel/cplb-nompu/cplbinit.c         |    4 +
 arch/blackfin/kernel/ipipe.c                       |  176 ++----
 arch/blackfin/kernel/irqchip.c                     |   14 +-
 arch/blackfin/kernel/kgdb_test.c                   |    9 +-
 arch/blackfin/kernel/ptrace.c                      |    5 +-
 arch/blackfin/kernel/setup.c                       |   10 +-
 arch/blackfin/kernel/time.c                        |    5 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c            |   33 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h    |   17 +-
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |    4 +-
 arch/blackfin/mach-bf527/boards/cm_bf527.c         |   26 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c            |   24 +-
 arch/blackfin/mach-bf527/include/mach/anomaly.h    |    6 +-
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |    4 +-
 arch/blackfin/mach-bf533/boards/Kconfig            |    5 -
 arch/blackfin/mach-bf533/boards/Makefile           |    1 -
 arch/blackfin/mach-bf533/boards/blackstamp.c       |   24 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c         |   24 +-
 arch/blackfin/mach-bf533/boards/generic_board.c    |  126 ----
 arch/blackfin/mach-bf533/boards/ip0x.c             |   13 +-
 arch/blackfin/mach-bf533/include/mach/anomaly.h    |    7 +-
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-bf537/boards/Kconfig            |    5 -
 arch/blackfin/mach-bf537/boards/Makefile           |    1 -
 arch/blackfin/mach-bf537/boards/cm_bf537.c         |   26 +-
 arch/blackfin/mach-bf537/boards/generic_board.c    |  745 --------------------
 arch/blackfin/mach-bf537/boards/minotaur.c         |   24 +-
 arch/blackfin/mach-bf537/boards/pnav10.c           |   24 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c        |   24 +-
 arch/blackfin/mach-bf537/include/mach/anomaly.h    |    7 +-
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |    4 +-
 arch/blackfin/mach-bf538/include/mach/anomaly.h    |    6 +-
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |    4 +-
 arch/blackfin/mach-bf548/include/mach/anomaly.h    |   22 +-
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |   22 +-
 arch/blackfin/mach-bf548/include/mach/irq.h        |    8 +-
 arch/blackfin/mach-bf561/boards/Kconfig            |    5 -
 arch/blackfin/mach-bf561/boards/Makefile           |    1 -
 arch/blackfin/mach-bf561/boards/cm_bf561.c         |   15 +-
 arch/blackfin/mach-bf561/boards/generic_board.c    |  113 ---
 arch/blackfin/mach-bf561/include/mach/anomaly.h    |    7 +-
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |    2 +-
 arch/blackfin/mach-common/arch_checks.c            |    9 +
 arch/blackfin/mach-common/cache.S                  |   22 +
 arch/blackfin/mach-common/clocks-init.c            |    2 +-
 arch/blackfin/mach-common/dpmc_modes.S             |   24 +
 arch/blackfin/mach-common/entry.S                  |   61 ++-
 arch/blackfin/mach-common/interrupt.S              |   12 +-
 arch/blackfin/mach-common/ints-priority.c          |  126 ++--
 arch/blackfin/mach-common/smp.c                    |    6 +-
 arch/blackfin/mm/init.c                            |    2 +-
 73 files changed, 607 insertions(+), 1601 deletions(-)
 delete mode 100644 arch/blackfin/mach-bf533/boards/generic_board.c
 delete mode 100644 arch/blackfin/mach-bf537/boards/generic_board.c
 delete mode 100644 arch/blackfin/mach-bf561/boards/generic_board.c

Alon Bar-Lev (1):
      Blackfin arch: cleanup bfin_sport.h header and export it to userspace

Bernd Schmidt (1):
      Blackfin arch: fix bug - jump_to_zero test case failed on noMPU kernel

Enrik Berkhan (1):
      Blackfin arch: fix bug - The SPORT_HYS bit is not set for BF561 0.5

Graf Yang (2):
      Blackfin arch: Fix bug - make ksz8893m driver available when
bfin_mac is enabled
      Blackfin arch: update default kernel config, select KSZ8893M
driver for BF518

Jie Zhang (1):
      Blackfin arch: fix bug - gdb signull case make trunk kernel
panic frequently

Michael Hennerich (6):
      Blackfin arch: Make IRQ_EPPIx_ERROR naming consistent
      Blackfin arch: Enable Write Back Cache on all Blackfin Boards
      Blackfin arch: PM_BFIN_WAKE_GP: update help
      Blackfin arch: Fix BUG - kernel fails to build in pm.c when
allow wakeup fromi standby by GPIO
      Blackfin arch: fix bug - On bf548-ezkit, ethernet fails to work
after wakeup from "mem"
      Blackfin arch: SPI_MMC is now mainlined MMC_SPI

Mike Frysinger (10):
      Blackfin arch: drop untested and useless "generic" board file
      Blackfin arch: use common KGDB_TESTS rather than our own KGDB_TESTCASE
      Blackfin arch: fix compile failure when missing the anomaly definition
      Blackfin arch: update anomaly sheets to match latest public info
      Blackfin arch: make sure people do not set the kernel load
address too high
      Blackfin arch: mark init_pda as __init as only __init funcs all it
      Blackfin arch: remove spurious dash when dcache is off
      Blackfin arch: add stubs for anomalies 447 and 448
      Blackfin arch: remove duplicated ANOMALY_05000448 ifdef check
      Blackfin arch: disable legacy /proc/scsi/ support by default

Philippe Gerum (1):
      Blackfin arch:  Update adeos blackfin arch patch to 1.9-00

Robin Getz (1):
      Blackfin arch: Random read/write errors are a bad thing

Sonic Zhang (3):
      Blackfin arch: Disable NAND option by default
      Blackfin arch: fix bug - kgdb fails to continue after setting
breakpoint on bf561-ezkit kernel with smp patch
      Blackfin arch: Fix bug - KGDB single step into the middle of a 4
bytes instruction on bf561 after soft bp is hit

Tom Parker (1):
      Blackfin arch: fix bug - Error if one serial has hardware flow
control and the other doesn't

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 8f1f97d..0c1f86e 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1129,6 +1129,7 @@ endchoice

 config PM_WAKEUP_BY_GPIO
 	bool "Allow Wakeup from Standby by GPIO"
+	depends on PM && !BF54x

 config PM_WAKEUP_GPIO_NUMBER
 	int "GPIO number"
@@ -1168,6 +1169,12 @@ config PM_BFIN_WAKE_GP
 	default n
 	help
 	  Enable General-Purpose Wake-Up (Voltage Regulator Power-Up)
+	  (all processors, except ADSP-BF549). This option sets
+	  the general-purpose wake-up enable (GPWE) control bit to enable
+	  wake-up upon detection of an active low signal on the /GPW (PH7) pin.
+	  On ADSP-BF549 this option enables the the same functionality on the
+	  /MRXON pin also PH7.
+
 endmenu

 menu "CPU Frequency scaling"
diff --git a/arch/blackfin/Kconfig.debug b/arch/blackfin/Kconfig.debug
index 5f981d9..79e7e63 100644
--- a/arch/blackfin/Kconfig.debug
+++ b/arch/blackfin/Kconfig.debug
@@ -21,12 +21,6 @@ config DEBUG_STACK_USAGE
 config HAVE_ARCH_KGDB
 	def_bool y

-config KGDB_TESTCASE
-	tristate "KGDB: for test case in expect"
-	default n
-	help
-	  This is a kgdb test case for automated testing.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff --git a/arch/blackfin/configs/BF518F-EZBRD_defconfig
b/arch/blackfin/configs/BF518F-EZBRD_defconfig
index 4fdb9e0..281f4b6 100644
--- a/arch/blackfin/configs/BF518F-EZBRD_defconfig
+++ b/arch/blackfin/configs/BF518F-EZBRD_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.28-rc2
-# Fri Jan  9 17:58:41 2009
+# Linux kernel version: 2.6.28
+# Fri Feb 20 10:01:44 2009
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
@@ -133,10 +133,15 @@ CONFIG_BF518=y
 # CONFIG_BF538 is not set
 # CONFIG_BF539 is not set
 # CONFIG_BF542 is not set
+# CONFIG_BF542M is not set
 # CONFIG_BF544 is not set
+# CONFIG_BF544M is not set
 # CONFIG_BF547 is not set
+# CONFIG_BF547M is not set
 # CONFIG_BF548 is not set
+# CONFIG_BF548M is not set
 # CONFIG_BF549 is not set
+# CONFIG_BF549M is not set
 # CONFIG_BF561 is not set
 CONFIG_BF_REV_MIN=0
 CONFIG_BF_REV_MAX=2
@@ -426,7 +431,17 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
-# CONFIG_NET_DSA is not set
+CONFIG_NET_DSA=y
+# CONFIG_NET_DSA_TAG_DSA is not set
+# CONFIG_NET_DSA_TAG_EDSA is not set
+# CONFIG_NET_DSA_TAG_TRAILER is not set
+CONFIG_NET_DSA_TAG_STPID=y
+# CONFIG_NET_DSA_MV88E6XXX is not set
+# CONFIG_NET_DSA_MV88E6060 is not set
+# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
+# CONFIG_NET_DSA_MV88E6131 is not set
+# CONFIG_NET_DSA_MV88E6123_61_65 is not set
+CONFIG_NET_DSA_KSZ8893M=y
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 # CONFIG_LLC2 is not set
@@ -529,6 +544,8 @@ CONFIG_MTD_COMPLEX_MAPPINGS=y
 #
 # Self-contained MTD device drivers
 #
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
@@ -561,7 +578,9 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 # CONFIG_BLK_DEV_HD is not set
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set

@@ -607,6 +626,7 @@ CONFIG_BFIN_RX_DESC_NUM=20
 # CONFIG_SMC91X is not set
 # CONFIG_SMSC911X is not set
 # CONFIG_DM9000 is not set
+# CONFIG_ENC28J60 is not set
 # CONFIG_IBM_NEW_EMAC_ZMII is not set
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
@@ -764,7 +784,23 @@ CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=100
 # CONFIG_I2C_DEBUG_ALGO is not set
 # CONFIG_I2C_DEBUG_BUS is not set
 # CONFIG_I2C_DEBUG_CHIP is not set
-# CONFIG_SPI is not set
+CONFIG_SPI=y
+# CONFIG_SPI_DEBUG is not set
+CONFIG_SPI_MASTER=y
+
+#
+# SPI Master Controller Drivers
+#
+CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BFIN_LOCK is not set
+# CONFIG_SPI_BITBANG is not set
+
+#
+# SPI Protocol Masters
+#
+# CONFIG_SPI_AT25 is not set
+# CONFIG_SPI_SPIDEV is not set
+# CONFIG_SPI_TLE62X0 is not set
 CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
 # CONFIG_GPIOLIB is not set
 # CONFIG_W1 is not set
@@ -788,8 +824,10 @@ CONFIG_BFIN_WDT=y
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
 # CONFIG_MFD_WM8400 is not set
 # CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_REGULATOR is not set

 #
 # Multimedia devices
@@ -861,10 +899,18 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set

 #
 # SPI RTC drivers
 #
+# CONFIG_RTC_DRV_M41T94 is not set
+# CONFIG_RTC_DRV_DS1305 is not set
+# CONFIG_RTC_DRV_DS1390 is not set
+# CONFIG_RTC_DRV_MAX6902 is not set
+# CONFIG_RTC_DRV_R9701 is not set
+# CONFIG_RTC_DRV_RS5C348 is not set
+# CONFIG_RTC_DRV_DS3234 is not set

 #
 # Platform RTC drivers
@@ -1062,12 +1108,20 @@ CONFIG_DEBUG_INFO=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+
+#
+# Tracers
+#
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
 # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
 # CONFIG_DEBUG_STACKOVERFLOW is not set
 # CONFIG_DEBUG_STACK_USAGE is not set
+# CONFIG_KGDB_TESTCASE is not set
 CONFIG_DEBUG_VERBOSE=y
 CONFIG_DEBUG_MMRS=y
 # CONFIG_DEBUG_HWERR is not set
@@ -1100,6 +1154,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_FIPS is not set
 # CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
diff --git a/arch/blackfin/configs/BF527-EZKIT_defconfig
b/arch/blackfin/configs/BF527-EZKIT_defconfig
index 833128b..a50050f 100644
--- a/arch/blackfin/configs/BF527-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF527-EZKIT_defconfig
@@ -327,8 +327,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig
b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 334c94b..0a2a00d 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -290,8 +290,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig
b/arch/blackfin/configs/BF533-STAMP_defconfig
index 9d73343..eb02758 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -290,8 +290,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig
b/arch/blackfin/configs/BF537-STAMP_defconfig
index 4fb4108..9e62b9f 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -298,8 +298,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
@@ -568,15 +568,7 @@ CONFIG_MTD_PHYSMAP_BANKWIDTH=2
 # CONFIG_MTD_DOC2000 is not set
 # CONFIG_MTD_DOC2001 is not set
 # CONFIG_MTD_DOC2001PLUS is not set
-CONFIG_MTD_NAND=m
-# CONFIG_MTD_NAND_VERIFY_WRITE is not set
-# CONFIG_MTD_NAND_ECC_SMC is not set
-# CONFIG_MTD_NAND_MUSEUM_IDS is not set
-# CONFIG_MTD_NAND_BFIN is not set
-CONFIG_MTD_NAND_IDS=m
-# CONFIG_MTD_NAND_DISKONCHIP is not set
-# CONFIG_MTD_NAND_NANDSIM is not set
-CONFIG_MTD_NAND_PLATFORM=m
+# CONFIG_MTD_NAND is not set
 # CONFIG_MTD_ONENAND is not set

 #
diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig
b/arch/blackfin/configs/BF538-EZKIT_defconfig
index cb32f56..dd6ad6b 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -306,8 +306,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/BF548-EZKIT_defconfig
b/arch/blackfin/configs/BF548-EZKIT_defconfig
index 0f86976..6bc2fb1 100644
--- a/arch/blackfin/configs/BF548-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF548-EZKIT_defconfig
@@ -361,8 +361,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_BFIN_L2_CACHEABLE is not set
 # CONFIG_MPU is not set

@@ -680,7 +680,7 @@ CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
 # CONFIG_SCSI_TGT is not set
 # CONFIG_SCSI_NETLINK is not set
-CONFIG_SCSI_PROC_FS=y
+# CONFIG_SCSI_PROC_FS is not set

 #
 # SCSI support type (disk, tape, CD-ROM)
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig
b/arch/blackfin/configs/BF561-EZKIT_defconfig
index 042c7ad..69714fb 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -329,8 +329,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_BFIN_L2_CACHEABLE is not set
 # CONFIG_MPU is not set

diff --git a/arch/blackfin/configs/BlackStamp_defconfig
b/arch/blackfin/configs/BlackStamp_defconfig
index 3a20e28..017c6ea 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -288,8 +288,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/CM-BF527_defconfig
b/arch/blackfin/configs/CM-BF527_defconfig
index 865ed85..d880ef7 100644
--- a/arch/blackfin/configs/CM-BF527_defconfig
+++ b/arch/blackfin/configs/CM-BF527_defconfig
@@ -332,8 +332,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 # CONFIG_MPU is not set

 #
diff --git a/arch/blackfin/configs/CM-BF548_defconfig
b/arch/blackfin/configs/CM-BF548_defconfig
index efe9741..f410430 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -336,8 +336,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 CONFIG_L1_MAX_PIECE=16
 # CONFIG_MPU is not set

@@ -595,7 +595,7 @@ CONFIG_SCSI=y
 CONFIG_SCSI_DMA=y
 # CONFIG_SCSI_TGT is not set
 # CONFIG_SCSI_NETLINK is not set
-CONFIG_SCSI_PROC_FS=y
+# CONFIG_SCSI_PROC_FS is not set

 #
 # SCSI support type (disk, tape, CD-ROM)
diff --git a/arch/blackfin/configs/IP0X_defconfig
b/arch/blackfin/configs/IP0X_defconfig
index eae83b5..7db9387 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -612,7 +612,7 @@ CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 CONFIG_SCSI=y
 # CONFIG_SCSI_TGT is not set
 # CONFIG_SCSI_NETLINK is not set
-CONFIG_SCSI_PROC_FS=y
+# CONFIG_SCSI_PROC_FS is not set

 #
 # SCSI support type (disk, tape, CD-ROM)
diff --git a/arch/blackfin/configs/SRV1_defconfig
b/arch/blackfin/configs/SRV1_defconfig
index fa580af..a46529c 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -282,8 +282,8 @@ CONFIG_BFIN_ICACHE=y
 CONFIG_BFIN_DCACHE=y
 # CONFIG_BFIN_DCACHE_BANKA is not set
 # CONFIG_BFIN_ICACHE_LOCK is not set
-# CONFIG_BFIN_WB is not set
-CONFIG_BFIN_WT=y
+CONFIG_BFIN_WB=y
+# CONFIG_BFIN_WT is not set
 CONFIG_L1_MAX_PIECE=16

 #
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 606ecfd..09c3141 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -1,3 +1,4 @@
 include include/asm-generic/Kbuild.asm

+unifdef-y += bfin_sport.h
 unifdef-y += fixed_code.h
diff --git a/arch/blackfin/include/asm/bfin_sport.h
b/arch/blackfin/include/asm/bfin_sport.h
index fe88a2c..65a651d 100644
--- a/arch/blackfin/include/asm/bfin_sport.h
+++ b/arch/blackfin/include/asm/bfin_sport.h
@@ -1,30 +1,9 @@
 /*
- * File:         include/asm-blackfin/bfin_sport.h
- * Based on:
- * Author:       Roy Huang (roy.huang@analog.com)
+ * bfin_sport.h - userspace header for bfin sport driver
  *
- * Created:      Thu Aug. 24 2006
- * Description:
+ * Copyright 2004-2008 Analog Devices Inc.
  *
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
+ * Licensed under the GPL-2 or later.
  */

 #ifndef __BFIN_SPORT_H__
@@ -42,11 +21,10 @@
 #define NORM_FORMAT	0x0
 #define ALAW_FORMAT	0x2
 #define ULAW_FORMAT	0x3
-struct sport_register;

 /* Function driver which use sport must initialize the structure */
 struct sport_config {
-	/*TDM (multichannels), I2S or other mode */
+	/* TDM (multichannels), I2S or other mode */
 	unsigned int mode:3;

 	/* if TDM mode is selected, channels must be set */
@@ -72,12 +50,18 @@ struct sport_config {
 	int serial_clk;
 	int fsync_clk;

-	unsigned int data_format:2;	/*Normal, u-law or a-law */
+	unsigned int data_format:2;	/* Normal, u-law or a-law */

 	int word_len;		/* How length of the word in bits, 3-32 bits */
 	int dma_enabled;
 };

+/* Userspace interface */
+#define SPORT_IOC_MAGIC		'P'
+#define SPORT_IOC_CONFIG	_IOWR('P', 0x01, struct sport_config)
+
+#ifdef __KERNEL__
+
 struct sport_register {
 	unsigned short tcr1;
 	unsigned short reserved0;
@@ -117,9 +101,6 @@ struct sport_register {
 	unsigned long mrcs3;
 };

-#define SPORT_IOC_MAGIC		'P'
-#define SPORT_IOC_CONFIG	_IOWR('P', 0x01, struct sport_config)
-
 struct sport_dev {
 	struct cdev cdev;	/* Char device structure */

@@ -149,6 +130,8 @@ struct sport_dev {
 	struct sport_config config;
 };

+#endif
+
 #define SPORT_TCR1	0
 #define	SPORT_TCR2	1
 #define	SPORT_TCLKDIV	2
@@ -169,4 +152,4 @@ struct sport_dev {
 #define SPORT_MRCS2	22
 #define SPORT_MRCS3	23

-#endif				/*__BFIN_SPORT_H__*/
+#endif
diff --git a/arch/blackfin/include/asm/ipipe.h
b/arch/blackfin/include/asm/ipipe.h
index 76f53d8..343b563 100644
--- a/arch/blackfin/include/asm/ipipe.h
+++ b/arch/blackfin/include/asm/ipipe.h
@@ -35,9 +35,9 @@
 #include <asm/atomic.h>
 #include <asm/traps.h>

-#define IPIPE_ARCH_STRING     "1.8-00"
+#define IPIPE_ARCH_STRING     "1.9-00"
 #define IPIPE_MAJOR_NUMBER    1
-#define IPIPE_MINOR_NUMBER    8
+#define IPIPE_MINOR_NUMBER    9
 #define IPIPE_PATCH_NUMBER    0

 #ifdef CONFIG_SMP
@@ -83,9 +83,9 @@ struct ipipe_sysinfo {
 				"%2 = CYCLES2\n"		\
 				"CC = %2 == %0\n"		\
 				"if ! CC jump 1b\n"		\
-				: "=r" (((unsigned long *)&t)[1]),	\
-				  "=r" (((unsigned long *)&t)[0]),	\
-				  "=r" (__cy2)				\
+				: "=d,a" (((unsigned long *)&t)[1]),	\
+				  "=d,a" (((unsigned long *)&t)[0]),	\
+				  "=d,a" (__cy2)				\
 				: /*no input*/ : "CC");			\
 	t;								\
 	})
@@ -118,35 +118,40 @@ void __ipipe_disable_irqdesc(struct ipipe_domain *ipd,

 #define __ipipe_disable_irq(irq)	(irq_desc[irq].chip->mask(irq))

-#define __ipipe_lock_root()					\
-	set_bit(IPIPE_ROOTLOCK_FLAG, &ipipe_root_domain->flags)
+static inline int __ipipe_check_tickdev(const char *devname)
+{
+	return 1;
+}

-#define __ipipe_unlock_root()					\
-	clear_bit(IPIPE_ROOTLOCK_FLAG, &ipipe_root_domain->flags)
+static inline void __ipipe_lock_root(void)
+{
+	set_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status));
+}
+
+static inline void __ipipe_unlock_root(void)
+{
+	clear_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status));
+}

 void __ipipe_enable_pipeline(void);

 #define __ipipe_hook_critical_ipi(ipd) do { } while (0)

-#define __ipipe_sync_pipeline(syncmask)					\
-	do {								\
-		struct ipipe_domain *ipd = ipipe_current_domain;	\
-		if (likely(ipd != ipipe_root_domain ||
!test_bit(IPIPE_ROOTLOCK_FLAG, &ipd->flags))) \
-			__ipipe_sync_stage(syncmask);			\
-	} while (0)
+#define __ipipe_sync_pipeline  ___ipipe_sync_pipeline
+void ___ipipe_sync_pipeline(unsigned long syncmask);

 void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs);

 int __ipipe_get_irq_priority(unsigned irq);

-int __ipipe_get_irqthread_priority(unsigned irq);
-
 void __ipipe_stall_root_raw(void);

 void __ipipe_unstall_root_raw(void);

 void __ipipe_serial_debug(const char *fmt, ...);

+asmlinkage void __ipipe_call_irqtail(unsigned long addr);
+
 DECLARE_PER_CPU(struct pt_regs, __ipipe_tick_regs);

 extern unsigned long __ipipe_core_clock;
@@ -162,42 +167,25 @@ static inline unsigned long __ipipe_ffnz(unsigned long ul)

 #define __ipipe_run_irqtail()  /* Must be a macro */			\
 	do {								\
-		asmlinkage void __ipipe_call_irqtail(void);		\
 		unsigned long __pending;				\
-		CSYNC();					\
+		CSYNC();						\
 		__pending = bfin_read_IPEND();				\
 		if (__pending & 0x8000) {				\
 			__pending &= ~0x8010;				\
 			if (__pending && (__pending & (__pending - 1)) == 0) \
-				__ipipe_call_irqtail();			\
+				__ipipe_call_irqtail(__ipipe_irq_tail_hook); \
 		}							\
 	} while (0)

 #define __ipipe_run_isr(ipd, irq)					\
 	do {								\
 		if (ipd == ipipe_root_domain) {				\
-			/*						\
-			 * Note: the I-pipe implements a threaded interrupt model on \
-			 * this arch for Linux external IRQs. The interrupt handler we \
-			 * call here only wakes up the associated IRQ thread. \
-			 */						\
-			if (ipipe_virtual_irq_p(irq)) {			\
-				/* No irqtail here; virtual interrupts have no effect \
-				   on IPEND so there is no need for processing \
-				   deferral. */				\
-				local_irq_enable_nohead(ipd);		\
+			local_irq_enable_hw();				\
+			if (ipipe_virtual_irq_p(irq))			\
 				ipd->irqs[irq].handler(irq, ipd->irqs[irq].cookie); \
-				local_irq_disable_nohead(ipd);		\
-			} else						\
-				/*					\
-				 * No need to run the irqtail here either; \
-				 * we can't be preempted by hw IRQs, so	\
-				 * non-Linux IRQs cannot stack over the short \
-				 * thread wakeup code. Which in turn means \
-				 * that no irqtail condition could be pending \
-				 * for domains above Linux in the pipeline. \
-				 */					\
+			else						\
 				ipd->irqs[irq].handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs)); \
+			local_irq_disable_hw();				\
 		} else {						\
 			__clear_bit(IPIPE_SYNC_FLAG, &ipipe_cpudom_var(ipd, status)); \
 			local_irq_enable_nohead(ipd);			\
@@ -217,42 +205,24 @@ void ipipe_init_irq_threads(void);

 int ipipe_start_irq_thread(unsigned irq, struct irq_desc *desc);

-#define IS_SYSIRQ(irq)		((irq) > IRQ_CORETMR && (irq) <= SYS_IRQS)
-#define IS_GPIOIRQ(irq)		((irq) >= GPIO_IRQ_BASE && (irq) < NR_IRQS)
-
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+#define IRQ_SYSTMR		IRQ_CORETMR
+#define IRQ_PRIOTMR		IRQ_CORETMR
+#else
 #define IRQ_SYSTMR		IRQ_TIMER0
 #define IRQ_PRIOTMR		CONFIG_IRQ_TIMER0
+#endif

-#if defined(CONFIG_BF531) || defined(CONFIG_BF532) || defined(CONFIG_BF533)
-#define PRIO_GPIODEMUX(irq)	CONFIG_PFA
-#elif defined(CONFIG_BF534) || defined(CONFIG_BF536) || defined(CONFIG_BF537)
-#define PRIO_GPIODEMUX(irq)	CONFIG_IRQ_PROG_INTA
-#elif defined(CONFIG_BF52x)
-#define PRIO_GPIODEMUX(irq)	((irq) == IRQ_PORTF_INTA ?
CONFIG_IRQ_PORTF_INTA : \
-				 (irq) == IRQ_PORTG_INTA ? CONFIG_IRQ_PORTG_INTA : \
-				 (irq) == IRQ_PORTH_INTA ? CONFIG_IRQ_PORTH_INTA : \
-				 -1)
-#elif defined(CONFIG_BF561)
-#define PRIO_GPIODEMUX(irq)	((irq) == IRQ_PROG0_INTA ?
CONFIG_IRQ_PROG0_INTA : \
-				 (irq) == IRQ_PROG1_INTA ? CONFIG_IRQ_PROG1_INTA : \
-				 (irq) == IRQ_PROG2_INTA ? CONFIG_IRQ_PROG2_INTA : \
-				 -1)
+#ifdef CONFIG_BF561
 #define bfin_write_TIMER_DISABLE(val)	bfin_write_TMRS8_DISABLE(val)
 #define bfin_write_TIMER_ENABLE(val)	bfin_write_TMRS8_ENABLE(val)
 #define bfin_write_TIMER_STATUS(val)	bfin_write_TMRS8_STATUS(val)
 #define bfin_read_TIMER_STATUS()	bfin_read_TMRS8_STATUS()
 #elif defined(CONFIG_BF54x)
-#define PRIO_GPIODEMUX(irq)	((irq) == IRQ_PINT0 ? CONFIG_IRQ_PINT0 : \
-				 (irq) == IRQ_PINT1 ? CONFIG_IRQ_PINT1 : \
-				 (irq) == IRQ_PINT2 ? CONFIG_IRQ_PINT2 : \
-				 (irq) == IRQ_PINT3 ? CONFIG_IRQ_PINT3 : \
-				 -1)
 #define bfin_write_TIMER_DISABLE(val)	bfin_write_TIMER_DISABLE0(val)
 #define bfin_write_TIMER_ENABLE(val)	bfin_write_TIMER_ENABLE0(val)
 #define bfin_write_TIMER_STATUS(val)	bfin_write_TIMER_STATUS0(val)
 #define bfin_read_TIMER_STATUS(val)	bfin_read_TIMER_STATUS0(val)
-#else
-# error "no PRIO_GPIODEMUX() for this part"
 #endif

 #define __ipipe_root_tick_p(regs)	((regs->ipend & 0x10) != 0)
@@ -275,4 +245,6 @@ int ipipe_start_irq_thread(unsigned irq, struct
irq_desc *desc);

 #endif /* !CONFIG_IPIPE */

+#define ipipe_update_tick_evtdev(evtdev)	do { } while (0)
+
 #endif	/* !__ASM_BLACKFIN_IPIPE_H */
diff --git a/arch/blackfin/include/asm/ipipe_base.h
b/arch/blackfin/include/asm/ipipe_base.h
index cb1025a..3e8acbd 100644
--- a/arch/blackfin/include/asm/ipipe_base.h
+++ b/arch/blackfin/include/asm/ipipe_base.h
@@ -1,5 +1,5 @@
 /*   -*- linux-c -*-
- *   include/asm-blackfin/_baseipipe.h
+ *   include/asm-blackfin/ipipe_base.h
  *
  *   Copyright (C) 2007 Philippe Gerum.
  *
@@ -27,8 +27,9 @@
 #define IPIPE_NR_XIRQS		NR_IRQS
 #define IPIPE_IRQ_ISHIFT	5	/* 2^5 for 32bits arch. */

-/* Blackfin-specific, global domain flags */
-#define IPIPE_ROOTLOCK_FLAG	1	/* Lock pipeline for root */
+/* Blackfin-specific, per-cpu pipeline status */
+#define IPIPE_SYNCDEFER_FLAG	15
+#define IPIPE_SYNCDEFER_MASK	(1L << IPIPE_SYNCDEFER_MASK)

  /* Blackfin traps -- i.e. exception vector numbers */
 #define IPIPE_NR_FAULTS		52 /* We leave a gap after VEC_ILL_RES. */
@@ -48,11 +49,6 @@

 #ifndef __ASSEMBLY__

-#include <linux/bitops.h>
-
-extern int test_bit(int nr, const void *addr);
-
-
 extern unsigned long __ipipe_root_status; /* Alias to
ipipe_root_cpudom_var(status) */

 static inline void __ipipe_stall_root(void)
diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
index 3d97790..7645e85 100644
--- a/arch/blackfin/include/asm/irq.h
+++ b/arch/blackfin/include/asm/irq.h
@@ -61,20 +61,38 @@ void __ipipe_restore_root(unsigned long flags);
 #define raw_irqs_disabled_flags(flags)	(!irqs_enabled_from_flags_hw(flags))
 #define local_test_iflag_hw(x)		irqs_enabled_from_flags_hw(x)

-#define local_save_flags(x)						\
-	do {								\
-		(x) = __ipipe_test_root() ? \
+#define local_save_flags(x)					 \
+	do {							 \
+		(x) = __ipipe_test_root() ?			 \
 			__all_masked_irq_flags : bfin_irq_flags; \
+		barrier();					 \
 	} while (0)

-#define local_irq_save(x)				\
-	do {						\
-		(x) = __ipipe_test_and_stall_root();	\
+#define local_irq_save(x)					 \
+	do {						 	 \
+		(x) = __ipipe_test_and_stall_root() ?		 \
+			__all_masked_irq_flags : bfin_irq_flags; \
+		barrier();					 \
+	} while (0)
+
+static inline void local_irq_restore(unsigned long x)
+{
+	barrier();
+	__ipipe_restore_root(x == __all_masked_irq_flags);
+}
+
+#define local_irq_disable()			\
+	do {					\
+		__ipipe_stall_root();		\
+		barrier();			\
 	} while (0)

-#define local_irq_restore(x)	__ipipe_restore_root(x)
-#define local_irq_disable()	__ipipe_stall_root()
-#define local_irq_enable()	__ipipe_unstall_root()
+static inline void local_irq_enable(void)
+{
+	barrier();
+	__ipipe_unstall_root();
+}
+
 #define irqs_disabled()		__ipipe_test_root()

 #define local_save_flags_hw(x) \
diff --git a/arch/blackfin/include/asm/thread_info.h
b/arch/blackfin/include/asm/thread_info.h
index e721ce5..2920087 100644
--- a/arch/blackfin/include/asm/thread_info.h
+++ b/arch/blackfin/include/asm/thread_info.h
@@ -122,6 +122,7 @@ static inline struct thread_info *current_thread_info(void)
 #define TIF_MEMDIE              4
 #define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              6       /* is freezing for suspend */
+#define TIF_IRQ_SYNC            7       /* sync pipeline stage */

 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -130,6 +131,7 @@ static inline struct thread_info *current_thread_info(void)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
+#define _TIF_IRQ_SYNC           (1<<TIF_IRQ_SYNC)

 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on
interrupt/exception return */

diff --git a/arch/blackfin/kernel/Makefile b/arch/blackfin/kernel/Makefile
index 4a92a86..fd4d432 100644
--- a/arch/blackfin/kernel/Makefile
+++ b/arch/blackfin/kernel/Makefile
@@ -15,13 +15,15 @@ else
     obj-y += time.o
 endif

-CFLAGS_kgdb_test.o := -mlong-calls -O0
-
 obj-$(CONFIG_IPIPE)                  += ipipe.o
 obj-$(CONFIG_IPIPE_TRACE_MCOUNT)     += mcount.o
 obj-$(CONFIG_BFIN_GPTIMERS)          += gptimers.o
 obj-$(CONFIG_CPLB_INFO)              += cplbinfo.o
 obj-$(CONFIG_MODULES)                += module.o
 obj-$(CONFIG_KGDB)                   += kgdb.o
-obj-$(CONFIG_KGDB_TESTCASE)          += kgdb_test.o
+obj-$(CONFIG_KGDB_TESTS)             += kgdb_test.o
 obj-$(CONFIG_EARLY_PRINTK)           += early_printk.o
+
+# the kgdb test puts code into L2 and without linker
+# relaxation, we need to force long calls to/from it
+CFLAGS_kgdb_test.o := -mlong-calls -O0
diff --git a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
index 0e28f75..d6c0677 100644
--- a/arch/blackfin/kernel/cplb-nompu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-nompu/cplbinit.c
@@ -53,9 +53,13 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)

 	i_d = i_i = 0;

+#ifdef CONFIG_DEBUG_HUNT_FOR_ZERO
 	/* Set up the zero page.  */
 	d_tbl[i_d].addr = 0;
 	d_tbl[i_d++].data = SDRAM_OOPS | PAGE_SIZE_1KB;
+	i_tbl[i_i].addr = 0;
+	i_tbl[i_i++].data = SDRAM_OOPS | PAGE_SIZE_1KB;
+#endif

 	/* Cover kernel memory with 4M pages.  */
 	addr = 0;
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index 339be5a..a5de8d4 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -35,14 +35,8 @@
 #include <asm/atomic.h>
 #include <asm/io.h>

-static int create_irq_threads;
-
 DEFINE_PER_CPU(struct pt_regs, __ipipe_tick_regs);

-static DEFINE_PER_CPU(unsigned long, pending_irqthread_mask);
-
-static DEFINE_PER_CPU(int [IVG13 + 1], pending_irq_count);
-
 asmlinkage void asm_do_IRQ(unsigned int irq, struct pt_regs *regs);

 static void __ipipe_no_irqtail(void);
@@ -93,6 +87,7 @@ void __ipipe_enable_pipeline(void)
  */
 void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 {
+	struct ipipe_percpu_domain_data *p = ipipe_root_cpudom_ptr();
 	struct ipipe_domain *this_domain, *next_domain;
 	struct list_head *head, *pos;
 	int m_ack, s = -1;
@@ -104,7 +99,6 @@ void __ipipe_handle_irq(unsigned irq, struct pt_regs *regs)
 	 * interrupt.
 	 */
 	m_ack = (regs == NULL || irq == IRQ_SYSTMR || irq == IRQ_CORETMR);
-
 	this_domain = ipipe_current_domain;

 	if (unlikely(test_bit(IPIPE_STICKY_FLAG, &this_domain->irqs[irq].control)))
@@ -114,49 +108,28 @@ void __ipipe_handle_irq(unsigned irq, struct
pt_regs *regs)
 		next_domain = list_entry(head, struct ipipe_domain, p_link);
 		if (likely(test_bit(IPIPE_WIRED_FLAG, &next_domain->irqs[irq].control))) {
 			if (!m_ack && next_domain->irqs[irq].acknowledge != NULL)
-				next_domain->irqs[irq].acknowledge(irq, irq_desc + irq);
-			if (test_bit(IPIPE_ROOTLOCK_FLAG, &ipipe_root_domain->flags))
-				s = __test_and_set_bit(IPIPE_STALL_FLAG,
-						       &ipipe_root_cpudom_var(status));
+				next_domain->irqs[irq].acknowledge(irq, irq_to_desc(irq));
+			if (test_bit(IPIPE_SYNCDEFER_FLAG, &p->status))
+				s = __test_and_set_bit(IPIPE_STALL_FLAG, &p->status);
 			__ipipe_dispatch_wired(next_domain, irq);
-				goto finalize;
-			return;
+			goto out;
 		}
 	}

 	/* Ack the interrupt. */

 	pos = head;
-
 	while (pos != &__ipipe_pipeline) {
 		next_domain = list_entry(pos, struct ipipe_domain, p_link);
-		/*
-		 * For each domain handling the incoming IRQ, mark it
-		 * as pending in its log.
-		 */
 		if (test_bit(IPIPE_HANDLE_FLAG, &next_domain->irqs[irq].control)) {
-			/*
-			 * Domains that handle this IRQ are polled for
-			 * acknowledging it by decreasing priority
-			 * order. The interrupt must be made pending
-			 * _first_ in the domain's status flags before
-			 * the PIC is unlocked.
-			 */
 			__ipipe_set_irq_pending(next_domain, irq);
-
 			if (!m_ack && next_domain->irqs[irq].acknowledge != NULL) {
-				next_domain->irqs[irq].acknowledge(irq, irq_desc + irq);
+				next_domain->irqs[irq].acknowledge(irq, irq_to_desc(irq));
 				m_ack = 1;
 			}
 		}
-
-		/*
-		 * If the domain does not want the IRQ to be passed
-		 * down the interrupt pipe, exit the loop now.
-		 */
 		if (!test_bit(IPIPE_PASS_FLAG, &next_domain->irqs[irq].control))
 			break;
-
 		pos = next_domain->p_link.next;
 	}

@@ -166,18 +139,24 @@ void __ipipe_handle_irq(unsigned irq, struct
pt_regs *regs)
 	 * immediately to the current domain if the interrupt has been
 	 * marked as 'sticky'. This search does not go beyond the
 	 * current domain in the pipeline. We also enforce the
-	 * additional root stage lock (blackfin-specific). */
+	 * additional root stage lock (blackfin-specific).
+	 */
+	if (test_bit(IPIPE_SYNCDEFER_FLAG, &p->status))
+		s = __test_and_set_bit(IPIPE_STALL_FLAG, &p->status);

-	if (test_bit(IPIPE_ROOTLOCK_FLAG, &ipipe_root_domain->flags))
-		s = __test_and_set_bit(IPIPE_STALL_FLAG,
-				       &ipipe_root_cpudom_var(status));
-finalize:
+	/*
+	 * If the interrupt preempted the head domain, then do not
+	 * even try to walk the pipeline, unless an interrupt is
+	 * pending for it.
+	 */
+	if (test_bit(IPIPE_AHEAD_FLAG, &this_domain->flags) &&
+	    ipipe_head_cpudom_var(irqpend_himask) == 0)
+		goto out;

 	__ipipe_walk_pipeline(head);
-
+out:
 	if (!s)
-		__clear_bit(IPIPE_STALL_FLAG,
-			    &ipipe_root_cpudom_var(status));
+		__clear_bit(IPIPE_STALL_FLAG, &p->status);
 }

 int __ipipe_check_root(void)
@@ -187,7 +166,7 @@ int __ipipe_check_root(void)

 void __ipipe_enable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	int prio = desc->ic_prio;

 	desc->depth = 0;
@@ -199,7 +178,7 @@ EXPORT_SYMBOL(__ipipe_enable_irqdesc);

 void __ipipe_disable_irqdesc(struct ipipe_domain *ipd, unsigned irq)
 {
-	struct irq_desc *desc = irq_desc + irq;
+	struct irq_desc *desc = irq_to_desc(irq);
 	int prio = desc->ic_prio;

 	if (ipd != &ipipe_root &&
@@ -236,15 +215,18 @@ int __ipipe_syscall_root(struct pt_regs *regs)
 {
 	unsigned long flags;

-	/* We need to run the IRQ tail hook whenever we don't
+	/*
+	 * We need to run the IRQ tail hook whenever we don't
 	 * propagate a syscall to higher domains, because we know that
 	 * important operations might be pending there (e.g. Xenomai
-	 * deferred rescheduling). */
+	 * deferred rescheduling).
+	 */

-	if (!__ipipe_syscall_watched_p(current, regs->orig_p0)) {
+	if (regs->orig_p0 < NR_syscalls) {
 		void (*hook)(void) = (void (*)(void))__ipipe_irq_tail_hook;
 		hook();
-		return 0;
+		if ((current->flags & PF_EVNOTIFY) == 0)
+			return 0;
 	}

 	/*
@@ -312,112 +294,46 @@ int ipipe_trigger_irq(unsigned irq)
 {
 	unsigned long flags;

+#ifdef CONFIG_IPIPE_DEBUG
 	if (irq >= IPIPE_NR_IRQS ||
 	    (ipipe_virtual_irq_p(irq)
 	     && !test_bit(irq - IPIPE_VIRQ_BASE, &__ipipe_virtual_irq_map)))
 		return -EINVAL;
+#endif

 	local_irq_save_hw(flags);
-
 	__ipipe_handle_irq(irq, NULL);
-
 	local_irq_restore_hw(flags);

 	return 1;
 }

-/* Move Linux IRQ to threads. */
-
-static int do_irqd(void *__desc)
+asmlinkage void __ipipe_sync_root(void)
 {
-	struct irq_desc *desc = __desc;
-	unsigned irq = desc - irq_desc;
-	int thrprio = desc->thr_prio;
-	int thrmask = 1 << thrprio;
-	int cpu = smp_processor_id();
-	cpumask_t cpumask;
-
-	sigfillset(&current->blocked);
-	current->flags |= PF_NOFREEZE;
-	cpumask = cpumask_of_cpu(cpu);
-	set_cpus_allowed(current, cpumask);
-	ipipe_setscheduler_root(current, SCHED_FIFO, 50 + thrprio);
-
-	while (!kthread_should_stop()) {
-		local_irq_disable();
-		if (!(desc->status & IRQ_SCHEDULED)) {
-			set_current_state(TASK_INTERRUPTIBLE);
-resched:
-			local_irq_enable();
-			schedule();
-			local_irq_disable();
-		}
-		__set_current_state(TASK_RUNNING);
-		/*
-		 * If higher priority interrupt servers are ready to
-		 * run, reschedule immediately. We need this for the
-		 * GPIO demux IRQ handler to unmask the interrupt line
-		 * _last_, after all GPIO IRQs have run.
-		 */
-		if (per_cpu(pending_irqthread_mask, cpu) & ~(thrmask|(thrmask-1)))
-			goto resched;
-		if (--per_cpu(pending_irq_count[thrprio], cpu) == 0)
-			per_cpu(pending_irqthread_mask, cpu) &= ~thrmask;
-		desc->status &= ~IRQ_SCHEDULED;
-		desc->thr_handler(irq, &__raw_get_cpu_var(__ipipe_tick_regs));
-		local_irq_enable();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
+	unsigned long flags;

-static void kick_irqd(unsigned irq, void *cookie)
-{
-	struct irq_desc *desc = irq_desc + irq;
-	int thrprio = desc->thr_prio;
-	int thrmask = 1 << thrprio;
-	int cpu = smp_processor_id();
-
-	if (!(desc->status & IRQ_SCHEDULED)) {
-		desc->status |= IRQ_SCHEDULED;
-		per_cpu(pending_irqthread_mask, cpu) |= thrmask;
-		++per_cpu(pending_irq_count[thrprio], cpu);
-		wake_up_process(desc->thread);
-	}
-}
+	BUG_ON(irqs_disabled());

-int ipipe_start_irq_thread(unsigned irq, struct irq_desc *desc)
-{
-	if (desc->thread || !create_irq_threads)
-		return 0;
-
-	desc->thread = kthread_create(do_irqd, desc, "IRQ %d", irq);
-	if (desc->thread == NULL) {
-		printk(KERN_ERR "irqd: could not create IRQ thread %d!\n", irq);
-		return -ENOMEM;
-	}
+	local_irq_save_hw(flags);

-	wake_up_process(desc->thread);
+	clear_thread_flag(TIF_IRQ_SYNC);

-	desc->thr_handler = ipipe_root_domain->irqs[irq].handler;
-	ipipe_root_domain->irqs[irq].handler = &kick_irqd;
+	if (ipipe_root_cpudom_var(irqpend_himask) != 0)
+		__ipipe_sync_pipeline(IPIPE_IRQMASK_ANY);

-	return 0;
+	local_irq_restore_hw(flags);
 }

-void __init ipipe_init_irq_threads(void)
+void ___ipipe_sync_pipeline(unsigned long syncmask)
 {
-	unsigned irq;
-	struct irq_desc *desc;
-
-	create_irq_threads = 1;
+	struct ipipe_domain *ipd = ipipe_current_domain;

-	for (irq = 0; irq < NR_IRQS; irq++) {
-		desc = irq_desc + irq;
-		if (desc->action != NULL ||
-			(desc->status & IRQ_NOREQUEST) != 0)
-			ipipe_start_irq_thread(irq, desc);
+	if (ipd == ipipe_root_domain) {
+		if (test_bit(IPIPE_SYNCDEFER_FLAG, &ipipe_root_cpudom_var(status)))
+			return;
 	}
+
+	__ipipe_sync_stage(syncmask);
 }

 EXPORT_SYMBOL(show_stack);
diff --git a/arch/blackfin/kernel/irqchip.c b/arch/blackfin/kernel/irqchip.c
index 75724ee..7fd1265 100644
--- a/arch/blackfin/kernel/irqchip.c
+++ b/arch/blackfin/kernel/irqchip.c
@@ -144,11 +144,15 @@ asmlinkage void asm_do_IRQ(unsigned int irq,
struct pt_regs *regs)
 #endif
 	generic_handle_irq(irq);

-#ifndef CONFIG_IPIPE	/* Useless and bugous over the I-pipe: IRQs are
threaded. */
-	/* If we're the only interrupt running (ignoring IRQ15 which is for
-	   syscalls), lower our priority to IRQ14 so that softirqs run at
-	   that level.  If there's another, lower-level interrupt, irq_exit
-	   will defer softirqs to that.  */
+#ifndef CONFIG_IPIPE
+	/*
+	 * If we're the only interrupt running (ignoring IRQ15 which
+	 * is for syscalls), lower our priority to IRQ14 so that
+	 * softirqs run at that level.  If there's another,
+	 * lower-level interrupt, irq_exit will defer softirqs to
+	 * that. If the interrupt pipeline is enabled, we are already
+	 * running at IRQ14 priority, so we don't need this code.
+	 */
 	CSYNC();
 	pending = bfin_read_IPEND() & ~0x8000;
 	other_ints = pending & (pending - 1);
diff --git a/arch/blackfin/kernel/kgdb_test.c b/arch/blackfin/kernel/kgdb_test.c
index 3dba9c1..dbcf3e4 100644
--- a/arch/blackfin/kernel/kgdb_test.c
+++ b/arch/blackfin/kernel/kgdb_test.c
@@ -20,6 +20,7 @@
 static char cmdline[256];
 static unsigned long len;

+#ifndef CONFIG_SMP
 static int num1 __attribute__((l1_data));

 void kgdb_l1_test(void) __attribute__((l1_text));
@@ -32,6 +33,8 @@ void kgdb_l1_test(void)
 	printk(KERN_ALERT "L1(after change) : data variable addr = 0x%p,
data value is %d\n", &num1, num1);
 	return ;
 }
+#endif
+
 #if L2_LENGTH

 static int num2 __attribute__((l2));
@@ -59,10 +62,12 @@ int kgdb_test(char *name, int len, int count, int z)
 static int test_proc_output(char *buf)
 {
 	kgdb_test("hello world!", 12, 0x55, 0x10);
+#ifndef CONFIG_SMP
 	kgdb_l1_test();
-	#if L2_LENGTH
+#endif
+#if L2_LENGTH
 	kgdb_l2_test();
-	#endif
+#endif

 	return 0;
 }
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 594e325..d76618d 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -45,6 +45,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/dma.h>
 #include <asm/fixed_code.h>
+#include <asm/cacheflush.h>
 #include <asm/mem_map.h>

 #define TEXT_OFFSET 0
@@ -240,7 +241,7 @@ long arch_ptrace(struct task_struct *child, long
request, long addr, long data)

 			} else if (addr >= FIXED_CODE_START
 			    && addr + sizeof(tmp) <= FIXED_CODE_END) {
-				memcpy(&tmp, (const void *)(addr), sizeof(tmp));
+				copy_from_user_page(0, 0, 0, &tmp, (const void *)(addr), sizeof(tmp));
 				copied = sizeof(tmp);

 			} else
@@ -320,7 +321,7 @@ long arch_ptrace(struct task_struct *child, long
request, long addr, long data)

 			} else if (addr >= FIXED_CODE_START
 			    && addr + sizeof(data) <= FIXED_CODE_END) {
-				memcpy((void *)(addr), &data, sizeof(data));
+				copy_to_user_page(0, 0, 0, (void *)(addr), &data, sizeof(data));
 				copied = sizeof(data);

 			} else
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index e5c1162..a58687b 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -889,6 +889,10 @@ void __init setup_arch(char **cmdline_p)
 			       CPU, bfin_revid());
 	}

+	/* We can't run on BF548-0.1 due to ANOMALY 05000448 */
+	if (bfin_cpuid() == 0x27de && bfin_revid() == 1)
+		panic("You can't run on this processor due to 05000448\n");
+
 	printk(KERN_INFO "Blackfin Linux support by http://blackfin.uclinux.org/\n");

 	printk(KERN_INFO "Processor Speed: %lu MHz core clock and %lu MHz
System Clock\n",
@@ -1141,12 +1145,12 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		icache_size = 0;

 	seq_printf(m, "cache size\t: %d KB(L1 icache) "
-		"%d KB(L1 dcache-%s) %d KB(L2 cache)\n",
+		"%d KB(L1 dcache%s) %d KB(L2 cache)\n",
 		icache_size, dcache_size,
 #if defined CONFIG_BFIN_WB
-		"wb"
+		"-wb"
 #elif defined CONFIG_BFIN_WT
-		"wt"
+		"-wt"
 #endif
 		"", 0);

diff --git a/arch/blackfin/kernel/time.c b/arch/blackfin/kernel/time.c
index 172b4c5..1bbacfb 100644
--- a/arch/blackfin/kernel/time.c
+++ b/arch/blackfin/kernel/time.c
@@ -134,7 +134,10 @@ irqreturn_t timer_interrupt(int irq, void *dummy)

 	write_seqlock(&xtime_lock);
 #if defined(CONFIG_TICK_SOURCE_SYSTMR0) && !defined(CONFIG_IPIPE)
-/* FIXME: Here TIMIL0 is not set when IPIPE enabled, why? */
+	/*
+	 * TIMIL0 is latched in __ipipe_grab_irq() when the I-Pipe is
+	 * enabled.
+	 */
 	if (get_gptimer_status(0) & TIMER_STATUS_TIMIL0) {
 #endif
 		do_timer(1);
diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c
b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 0e17534..41f2eac 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -113,7 +113,6 @@ static struct platform_device bfin_mac_device = {
 	.name = "bfin_mac",
 	.dev.platform_data = &bfin_mii_bus,
 };
-#endif

 #if defined(CONFIG_NET_DSA_KSZ8893M) || defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
 static struct dsa_platform_data ksz8893m_switch_data = {
@@ -132,6 +131,7 @@ static struct platform_device ksz8893m_switch_device = {
 	.dev.platform_data = &ksz8893m_switch_data,
 };
 #endif
+#endif

 #if defined(CONFIG_MTD_M25P80) \
 	|| defined(CONFIG_MTD_M25P80_MODULE)
@@ -171,6 +171,7 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif

+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 #if defined(CONFIG_NET_DSA_KSZ8893M) \
 	|| defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
 /* SPI SWITCH CHIP */
@@ -179,10 +180,11 @@ static struct bfin5xx_spi_chip spi_switch_info = {
 	.bits_per_word = 8,
 };
 #endif
+#endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -259,6 +261,7 @@ static struct spi_board_info bfin_spi_board_info[]
__initdata = {
 	},
 #endif

+#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 #if defined(CONFIG_NET_DSA_KSZ8893M) \
 	|| defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
 	{
@@ -271,24 +274,15 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.mode = SPI_MODE_3,
 	},
 #endif
+#endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc_dummy",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
@@ -630,11 +624,10 @@ static struct platform_device *stamp_devices[]
__initdata = {
 #if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
 	&bfin_mii_bus,
 	&bfin_mac_device,
-#endif
-
 #if defined(CONFIG_NET_DSA_KSZ8893M) || defined(CONFIG_NET_DSA_KSZ8893M_MODULE)
 	&ksz8893m_switch_device,
 #endif
+#endif

 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	&bfin_spi0_device,
diff --git a/arch/blackfin/mach-bf518/include/mach/anomaly.h
b/arch/blackfin/mach-bf518/include/mach/anomaly.h
index e5b4bef..c847bb1 100644
--- a/arch/blackfin/mach-bf518/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf518/include/mach/anomaly.h
@@ -2,12 +2,12 @@
  * File: include/asm-blackfin/mach-bf518/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

 /* This file shoule be up to date with:
- *  - ????
+ *  - Revision B, 02/03/2009; ADSP-BF512/BF514/BF516/BF518 Blackfin
Processor Anomaly List
  */

 #ifndef _MACH_ANOMALY_H_
@@ -19,6 +19,8 @@
 #define ANOMALY_05000122 (1)
 /* False Hardware Error from an Access in the Shadow of a Conditional Branch */
 #define ANOMALY_05000245 (1)
+/* Incorrect Timer Pulse Width in Single-Shot PWM_OUT Mode with
External Clock */
+#define ANOMALY_05000254 (1)
 /* Sensitivity To Noise with Slow Input Edge Rates on External SPORT
TX and RX Clocks */
 #define ANOMALY_05000265 (1)
 /* False Hardware Errors Caused by Fetches at the Boundary of
Reserved Memory */
@@ -53,6 +55,12 @@
 #define ANOMALY_05000443 (1)
 /* Incorrect L1 Instruction Bank B Memory Map Location */
 #define ANOMALY_05000444 (1)
+/* Incorrect Default Hysteresis Setting for RESET, NMI, and BMODE Signals */
+#define ANOMALY_05000452 (1)
+/* PWM_TRIPB Signal Not Available on PG10 */
+#define ANOMALY_05000453 (1)
+/* PPI_FS3 is Driven One Half Cycle Later Than PPI Data */
+#define ANOMALY_05000455 (1)

 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000125 (0)
@@ -65,15 +73,20 @@
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000278 (0)
 #define ANOMALY_05000285 (0)
+#define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (0)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (0)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
index b50a63b..e21c1c3 100644
--- a/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf518/include/mach/bfin_serial_5xx.h
@@ -144,7 +144,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	 CH_UART0_TX,
 	 CH_UART0_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	 CONFIG_UART0_CTS_PIN,
 	 CONFIG_UART0_RTS_PIN,
 #endif
@@ -158,7 +158,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	 CH_UART1_TX,
 	 CH_UART1_RX,
 #endif
-#ifdef CONFIG_BFIN_UART1_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	 CONFIG_UART1_CTS_PIN,
 	 CONFIG_UART1_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c
b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 856c097..48e69ee 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -487,9 +487,9 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -585,23 +585,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad9960_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.modalias = "mmc_spi",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c
b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 83606fc..7fe480e 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -256,9 +256,9 @@ static struct bfin5xx_spi_chip spi_adc_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -366,23 +366,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc_dummy",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf527/include/mach/anomaly.h
b/arch/blackfin/mach-bf527/include/mach/anomaly.h
index 035e8d8..df6808d 100644
--- a/arch/blackfin/mach-bf527/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf527/include/mach/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf527/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -167,12 +167,16 @@
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000278 (0)
 #define ANOMALY_05000285 (0)
+#define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000312 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000363 (0)
 #define ANOMALY_05000412 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
index 75722d6..e8c41fd 100644
--- a/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf527/include/mach/bfin_serial_5xx.h
@@ -144,7 +144,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	 CH_UART0_TX,
 	 CH_UART0_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	 CONFIG_UART0_CTS_PIN,
 	 CONFIG_UART0_RTS_PIN,
 #endif
@@ -158,7 +158,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	 CH_UART1_TX,
 	 CH_UART1_RX,
 #endif
-#ifdef CONFIG_BFIN_UART1_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	 CONFIG_UART1_CTS_PIN,
 	 CONFIG_UART1_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/Kconfig
b/arch/blackfin/mach-bf533/boards/Kconfig
index 308c98d..8d8b3e7 100644
--- a/arch/blackfin/mach-bf533/boards/Kconfig
+++ b/arch/blackfin/mach-bf533/boards/Kconfig
@@ -38,9 +38,4 @@ config BFIN532_IP0X
 	help
 	  Core support for IP04/IP04 open hardware IP-PBX.

-config GENERIC_BF533_BOARD
-	bool "Generic"
-	help
-	  Generic or Custom board support.
-
 endchoice
diff --git a/arch/blackfin/mach-bf533/boards/Makefile
b/arch/blackfin/mach-bf533/boards/Makefile
index 9afbe72..ff1e832 100644
--- a/arch/blackfin/mach-bf533/boards/Makefile
+++ b/arch/blackfin/mach-bf533/boards/Makefile
@@ -2,7 +2,6 @@
 # arch/blackfin/mach-bf533/boards/Makefile
 #

-obj-$(CONFIG_GENERIC_BF533_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN533_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN532_IP0X)             += ip0x.o
 obj-$(CONFIG_BFIN533_EZKIT)            += ezkit.o
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c
b/arch/blackfin/mach-bf533/boards/blackstamp.c
index 015c18f..0765872 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -101,9 +101,9 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -129,23 +129,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c
b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index e7061c7..e897487 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -96,9 +96,9 @@ static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -138,23 +138,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/generic_board.c
b/arch/blackfin/mach-bf533/boards/generic_board.c
deleted file mode 100644
index 986eeec..0000000
--- a/arch/blackfin/mach-bf533/boards/generic_board.c
+++ /dev/null
@@ -1,126 +0,0 @@
-/*
- * File:         arch/blackfin/mach-bf533/generic_board.c
- * Based on:     arch/blackfin/mach-bf533/ezkit.c
- * Author:       Aidan Williams <aidan@nicta.com.au>
- *
- * Created:      2005
- * Description:
- *
- * Modified:
- *               Copyright 2005 National ICT Australia (NICTA)
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
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/irq.h>
-
-/*
- * Name the Board for the /proc/cpuinfo
- */
-const char bfin_board_name[] = "UNKNOWN BOARD";
-
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
-static struct platform_device rtc_device = {
-	.name = "rtc-bfin",
-	.id   = -1,
-};
-#endif
-
-/*
- *  Driver needs to know address, irq and flag pin.
- */
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-static struct resource smc91x_resources[] = {
-	{
-		.start = 0x20300300,
-		.end = 0x20300300 + 16,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_PROG_INTB,
-		.end = IRQ_PROG_INTB,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	}, {
-		.start = IRQ_PF7,
-		.end = IRQ_PF7,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-
-static struct platform_device smc91x_device = {
-	.name = "smc91x",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(smc91x_resources),
-	.resource = smc91x_resources,
-};
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-static struct resource bfin_sir0_resources[] = {
-	{
-		.start = 0xFFC00400,
-		.end = 0xFFC004FF,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = IRQ_UART0_RX,
-		.end = IRQ_UART0_RX+1,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.start = CH_UART0_RX,
-		.end = CH_UART0_RX+1,
-		.flags = IORESOURCE_DMA,
-	},
-};
-
-static struct platform_device bfin_sir0_device = {
-	.name = "bfin_sir",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(bfin_sir0_resources),
-	.resource = bfin_sir0_resources,
-};
-#endif
-#endif
-
-static struct platform_device *generic_board_devices[] __initdata = {
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
-	&rtc_device,
-#endif
-
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-	&smc91x_device,
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-	&bfin_sir0_device,
-#endif
-#endif
-};
-
-static int __init generic_board_init(void)
-{
-	printk(KERN_INFO "%s(): registering device resources\n", __func__);
-	return platform_add_devices(generic_board_devices,
ARRAY_SIZE(generic_board_devices));
-}
-
-arch_initcall(generic_board_init);
diff --git a/arch/blackfin/mach-bf533/boards/ip0x.c
b/arch/blackfin/mach-bf533/boards/ip0x.c
index e30b1b7..f19b633 100644
--- a/arch/blackfin/mach-bf533/boards/ip0x.c
+++ b/arch/blackfin/mach-bf533/boards/ip0x.c
@@ -127,8 +127,8 @@ static struct platform_device dm9000_device2 = {
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 /* all SPI peripherals info goes here */

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
 /*
  * CPOL (Clock Polarity)
  *  0 - Active high SCK
@@ -152,14 +152,13 @@ static struct bfin5xx_spi_chip spi_mmc_chip_info = {
 /* Notice: for blackfin, the speed_hz is the value of register
  * SPI_BAUD, not the real baudrate */
 static struct spi_board_info bfin_spi_board_info[] __initdata = {
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 2,
 		.bus_num = 1,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf533/include/mach/anomaly.h
b/arch/blackfin/mach-bf533/include/mach/anomaly.h
index 0d3a034..1cf893e 100644
--- a/arch/blackfin/mach-bf533/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf533/include/mach/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf533/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -160,7 +160,7 @@
 #define ANOMALY_05000301 (__SILICON_REVISION__ < 6)
 /* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
 #define ANOMALY_05000302 (__SILICON_REVISION__ < 5)
-/* New Feature: Additional Hysteresis on SPORT Input Pins (Not
Available On Older Silicon) */
+/* SPORT_HYS Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
 /* New Feature: Additional PPI Frame Sync Sampling Options (Not
Available On Older Silicon) */
 #define ANOMALY_05000306 (__SILICON_REVISION__ < 5)
@@ -278,9 +278,12 @@
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
index f3d9e49..5f517f5 100644
--- a/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf533/include/mach/bfin_serial_5xx.h
@@ -134,7 +134,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART_TX,
 	CH_UART_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART0_CTS_PIN,
 	CONFIG_UART0_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/Kconfig
b/arch/blackfin/mach-bf537/boards/Kconfig
index 42a57b0..77c59da 100644
--- a/arch/blackfin/mach-bf537/boards/Kconfig
+++ b/arch/blackfin/mach-bf537/boards/Kconfig
@@ -33,9 +33,4 @@ config CAMSIG_MINOTAUR
 	help
 	  Board supply package for CSP Minotaur

-config GENERIC_BF537_BOARD
-	bool "Generic"
-	help
-	  Generic or Custom board support.
-
 endchoice
diff --git a/arch/blackfin/mach-bf537/boards/Makefile
b/arch/blackfin/mach-bf537/boards/Makefile
index 7168cc1..68b98a7 100644
--- a/arch/blackfin/mach-bf537/boards/Makefile
+++ b/arch/blackfin/mach-bf537/boards/Makefile
@@ -2,7 +2,6 @@
 # arch/blackfin/mach-bf537/boards/Makefile
 #

-obj-$(CONFIG_GENERIC_BF537_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN537_STAMP)            += stamp.o
 obj-$(CONFIG_BFIN537_BLUETECHNIX_CM)   += cm_bf537.o
 obj-$(CONFIG_BFIN537_BLUETECHNIX_TCM)  += tcm_bf537.o
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c
b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 9cd8fb2..41c75b9 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -108,9 +108,9 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip  mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -160,23 +160,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 7,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
+		.modalias = "mmc_spi",
+		.max_speed_hz = 20000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 1,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/generic_board.c
b/arch/blackfin/mach-bf537/boards/generic_board.c
deleted file mode 100644
index da710fd..0000000
--- a/arch/blackfin/mach-bf537/boards/generic_board.c
+++ /dev/null
@@ -1,745 +0,0 @@
-/*
- * File:         arch/blackfin/mach-bf537/boards/generic_board.c
- * Based on:     arch/blackfin/mach-bf533/boards/ezkit.c
- * Author:       Aidan Williams <aidan@nicta.com.au>
- *
- * Created:
- * Description:
- *
- * Modified:
- *               Copyright 2005 National ICT Australia (NICTA)
- *               Copyright 2004-2008 Analog Devices Inc.
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
-#include <linux/device.h>
-#include <linux/etherdevice.h>
-#include <linux/platform_device.h>
-#include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
-#include <linux/spi/spi.h>
-#include <linux/spi/flash.h>
-#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-#include <linux/usb/isp1362.h>
-#endif
-#include <linux/irq.h>
-#include <linux/interrupt.h>
-#include <linux/usb/sl811.h>
-#include <asm/dma.h>
-#include <asm/bfin5xx_spi.h>
-#include <asm/reboot.h>
-#include <asm/portmux.h>
-#include <linux/spi/ad7877.h>
-
-/*
- * Name the Board for the /proc/cpuinfo
- */
-const char bfin_board_name[] = "UNKNOWN BOARD";
-
-/*
- *  Driver needs to know address, irq and flag pin.
- */
-
-#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
-#include <linux/usb/isp1760.h>
-static struct resource bfin_isp1760_resources[] = {
-	[0] = {
-		.start  = 0x203C0000,
-		.end    = 0x203C0000 + 0x000fffff,
-		.flags  = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start  = IRQ_PF7,
-		.end    = IRQ_PF7,
-		.flags  = IORESOURCE_IRQ,
-	},
-};
-
-static struct isp1760_platform_data isp1760_priv = {
-	.is_isp1761 = 0,
-	.port1_disable = 0,
-	.bus_width_16 = 1,
-	.port1_otg = 0,
-	.analog_oc = 0,
-	.dack_polarity_high = 0,
-	.dreq_polarity_high = 0,
-};
-
-static struct platform_device bfin_isp1760_device = {
-	.name           = "isp1760-hcd",
-	.id             = 0,
-	.dev = {
-		.platform_data = &isp1760_priv,
-	},
-	.num_resources  = ARRAY_SIZE(bfin_isp1760_resources),
-	.resource       = bfin_isp1760_resources,
-};
-#endif
-
-#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
-static struct resource bfin_pcmcia_cf_resources[] = {
-	{
-		.start = 0x20310000, /* IO PORT */
-		.end = 0x20312000,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = 0x20311000, /* Attribute Memory */
-		.end = 0x20311FFF,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_PF4,
-		.end = IRQ_PF4,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_LOWLEVEL,
-	}, {
-		.start = 6, /* Card Detect PF6 */
-		.end = 6,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_pcmcia_cf_device = {
-	.name = "bfin_cf_pcmcia",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(bfin_pcmcia_cf_resources),
-	.resource = bfin_pcmcia_cf_resources,
-};
-#endif
-
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
-static struct platform_device rtc_device = {
-	.name = "rtc-bfin",
-	.id   = -1,
-};
-#endif
-
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-static struct resource smc91x_resources[] = {
-	{
-		.name = "smc91x-regs",
-		.start = 0x20300300,
-		.end = 0x20300300 + 16,
-		.flags = IORESOURCE_MEM,
-	}, {
-
-		.start = IRQ_PF7,
-		.end = IRQ_PF7,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-static struct platform_device smc91x_device = {
-	.name = "smc91x",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(smc91x_resources),
-	.resource = smc91x_resources,
-};
-#endif
-
-#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
-static struct resource dm9000_resources[] = {
-	[0] = {
-		.start	= 0x203FB800,
-		.end	= 0x203FB800 + 1,
-		.flags	= IORESOURCE_MEM,
-	},
-	[1] = {
-		.start	= 0x203FB800 + 4,
-		.end	= 0x203FB800 + 5,
-		.flags	= IORESOURCE_MEM,
-	},
-	[2] = {
-		.start	= IRQ_PF9,
-		.end	= IRQ_PF9,
-		.flags	= (IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHEDGE),
-	},
-};
-
-static struct platform_device dm9000_device = {
-	.name		= "dm9000",
-	.id		= -1,
-	.num_resources	= ARRAY_SIZE(dm9000_resources),
-	.resource	= dm9000_resources,
-};
-#endif
-
-#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
-static struct resource sl811_hcd_resources[] = {
-	{
-		.start = 0x20340000,
-		.end = 0x20340000,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = 0x20340004,
-		.end = 0x20340004,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = CONFIG_USB_SL811_BFIN_IRQ,
-		.end = CONFIG_USB_SL811_BFIN_IRQ,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-
-#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
-void sl811_port_power(struct device *dev, int is_on)
-{
-	gpio_request(CONFIG_USB_SL811_BFIN_GPIO_VBUS, "usb:SL811_VBUS");
-	gpio_direction_output(CONFIG_USB_SL811_BFIN_GPIO_VBUS, is_on);
-
-}
-#endif
-
-static struct sl811_platform_data sl811_priv = {
-	.potpg = 10,
-	.power = 250,       /* == 500mA */
-#if defined(CONFIG_USB_SL811_BFIN_USE_VBUS)
-	.port_power = &sl811_port_power,
-#endif
-};
-
-static struct platform_device sl811_hcd_device = {
-	.name = "sl811-hcd",
-	.id = 0,
-	.dev = {
-		.platform_data = &sl811_priv,
-	},
-	.num_resources = ARRAY_SIZE(sl811_hcd_resources),
-	.resource = sl811_hcd_resources,
-};
-#endif
-
-#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-static struct resource isp1362_hcd_resources[] = {
-	{
-		.start = 0x20360000,
-		.end = 0x20360000,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = 0x20360004,
-		.end = 0x20360004,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
-		.end = CONFIG_USB_ISP1362_BFIN_GPIO_IRQ,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-
-static struct isp1362_platform_data isp1362_priv = {
-	.sel15Kres = 1,
-	.clknotstop = 0,
-	.oc_enable = 0,
-	.int_act_high = 0,
-	.int_edge_triggered = 0,
-	.remote_wakeup_connected = 0,
-	.no_power_switching = 1,
-	.power_switching_mode = 0,
-};
-
-static struct platform_device isp1362_hcd_device = {
-	.name = "isp1362-hcd",
-	.id = 0,
-	.dev = {
-		.platform_data = &isp1362_priv,
-	},
-	.num_resources = ARRAY_SIZE(isp1362_hcd_resources),
-	.resource = isp1362_hcd_resources,
-};
-#endif
-
-#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
-static struct platform_device bfin_mii_bus = {
-	.name = "bfin_mii_bus",
-};
-
-static struct platform_device bfin_mac_device = {
-	.name = "bfin_mac",
-	.dev.platform_data = &bfin_mii_bus,
-};
-#endif
-
-#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
-static struct resource net2272_bfin_resources[] = {
-	{
-		.start = 0x20300000,
-		.end = 0x20300000 + 0x100,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_PF7,
-		.end = IRQ_PF7,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-
-static struct platform_device net2272_bfin_device = {
-	.name = "net2272",
-	.id = -1,
-	.num_resources = ARRAY_SIZE(net2272_bfin_resources),
-	.resource = net2272_bfin_resources,
-};
-#endif
-
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-/* all SPI peripherals info goes here */
-
-#if defined(CONFIG_MTD_M25P80) \
-	|| defined(CONFIG_MTD_M25P80_MODULE)
-static struct mtd_partition bfin_spi_flash_partitions[] = {
-	{
-		.name = "bootloader(spi)",
-		.size = 0x00020000,
-		.offset = 0,
-		.mask_flags = MTD_CAP_ROM
-	}, {
-		.name = "linux kernel(spi)",
-		.size = 0xe0000,
-		.offset = 0x20000
-	}, {
-		.name = "file system(spi)",
-		.size = 0x700000,
-		.offset = 0x00100000,
-	}
-};
-
-static struct flash_platform_data bfin_spi_flash_data = {
-	.name = "m25p80",
-	.parts = bfin_spi_flash_partitions,
-	.nr_parts = ARRAY_SIZE(bfin_spi_flash_partitions),
-	.type = "m25p64",
-};
-
-/* SPI flash chip (m25p64) */
-static struct bfin5xx_spi_chip spi_flash_chip_info = {
-	.enable_dma = 0,         /* use dma transfer with this chip*/
-	.bits_per_word = 8,
-};
-#endif
-
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
-/* SPI ADC chip */
-static struct bfin5xx_spi_chip spi_adc_chip_info = {
-	.enable_dma = 1,         /* use dma transfer with this chip*/
-	.bits_per_word = 16,
-};
-#endif
-
-#if defined(CONFIG_SND_BLACKFIN_AD1836) \
-	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
-static struct bfin5xx_spi_chip ad1836_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-#endif
-
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
-	.bits_per_word = 8,
-};
-#endif
-
-#if defined(CONFIG_PBX)
-static struct bfin5xx_spi_chip spi_si3xxx_chip_info = {
-	.ctl_reg	= 0x4, /* send zero */
-	.enable_dma	= 0,
-	.bits_per_word	= 8,
-	.cs_change_per_word = 1,
-};
-#endif
-
-#if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
-static struct bfin5xx_spi_chip spi_ad7877_chip_info = {
-	.enable_dma = 0,
-	.bits_per_word = 16,
-};
-
-static const struct ad7877_platform_data bfin_ad7877_ts_info = {
-	.model			= 7877,
-	.vref_delay_usecs	= 50,	/* internal, no capacitor */
-	.x_plate_ohms		= 419,
-	.y_plate_ohms		= 486,
-	.pressure_max		= 1000,
-	.pressure_min		= 0,
-	.stopacq_polarity 	= 1,
-	.first_conversion_delay = 3,
-	.acquisition_time 	= 1,
-	.averaging 		= 1,
-	.pen_down_acc_interval 	= 1,
-};
-#endif
-
-static struct spi_board_info bfin_spi_board_info[] __initdata = {
-#if defined(CONFIG_MTD_M25P80) \
-	|| defined(CONFIG_MTD_M25P80_MODULE)
-	{
-		/* the modalias must be the same as spi device driver name */
-		.modalias = "m25p80", /* Name of spi_driver for this device */
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0, /* Framework bus number */
-		.chip_select = 1, /* Framework chip select. On STAMP537 it is SPISSEL1*/
-		.platform_data = &bfin_spi_flash_data,
-		.controller_data = &spi_flash_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
-
-#if defined(CONFIG_SPI_ADC_BF533) \
-	|| defined(CONFIG_SPI_ADC_BF533_MODULE)
-	{
-		.modalias = "bfin_spi_adc", /* Name of spi_driver for this device */
-		.max_speed_hz = 6250000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0, /* Framework bus number */
-		.chip_select = 1, /* Framework chip select. */
-		.platform_data = NULL, /* No spi_driver specific config */
-		.controller_data = &spi_adc_chip_info,
-	},
-#endif
-
-#if defined(CONFIG_SND_BLACKFIN_AD1836) \
-	|| defined(CONFIG_SND_BLACKFIN_AD1836_MODULE)
-	{
-		.modalias = "ad1836-spi",
-		.max_speed_hz = 3125000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SND_BLACKFIN_SPI_PFBIT,
-		.controller_data = &ad1836_spi_chip_info,
-	},
-#endif
-#if defined(CONFIG_AD9960) || defined(CONFIG_AD9960_MODULE)
-	{
-		.modalias = "ad9960-spi",
-		.max_speed_hz = 10000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 1,
-		.controller_data = &ad9960_spi_chip_info,
-	},
-#endif
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
-#if defined(CONFIG_PBX)
-	{
-		.modalias = "fxs-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J11_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "fxo-spi",
-		.max_speed_hz = 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 8 - CONFIG_J19_JUMPER,
-		.controller_data = &spi_si3xxx_chip_info,
-		.mode = SPI_MODE_3,
-	},
-#endif
-#if defined(CONFIG_TOUCHSCREEN_AD7877) ||
defined(CONFIG_TOUCHSCREEN_AD7877_MODULE)
-	{
-		.modalias		= "ad7877",
-		.platform_data		= &bfin_ad7877_ts_info,
-		.irq			= IRQ_PF6,
-		.max_speed_hz	= 12500000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num	= 0,
-		.chip_select  = 1,
-		.controller_data = &spi_ad7877_chip_info,
-	},
-#endif
-};
-
-/* SPI controller data */
-static struct bfin5xx_spi_master bfin_spi0_info = {
-	.num_chipselect = 8,
-	.enable_dma = 1,  /* master has the ability to do dma transfer */
-	.pin_req = {P_SPI0_SCK, P_SPI0_MISO, P_SPI0_MOSI, 0},
-};
-
-/* SPI (0) */
-static struct resource bfin_spi0_resource[] = {
-	[0] = {
-		.start = SPI0_REGBASE,
-		.end   = SPI0_REGBASE + 0xFF,
-		.flags = IORESOURCE_MEM,
-		},
-	[1] = {
-		.start = CH_SPI,
-		.end   = CH_SPI,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device bfin_spi0_device = {
-	.name = "bfin-spi",
-	.id = 0, /* Bus number */
-	.num_resources = ARRAY_SIZE(bfin_spi0_resource),
-	.resource = bfin_spi0_resource,
-	.dev = {
-		.platform_data = &bfin_spi0_info, /* Passed to driver */
-	},
-};
-#endif  /* spi master and devices */
-
-#if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
-static struct platform_device bfin_fb_device = {
-	.name = "bf537-lq035",
-};
-#endif
-
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
-#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
-static struct resource bfin_uart_resources[] = {
-	{
-		.start = 0xFFC00400,
-		.end = 0xFFC004FF,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = 0xFFC02000,
-		.end = 0xFFC020FF,
-		.flags = IORESOURCE_MEM,
-	},
-};
-
-static struct platform_device bfin_uart_device = {
-	.name = "bfin-uart",
-	.id = 1,
-	.num_resources = ARRAY_SIZE(bfin_uart_resources),
-	.resource = bfin_uart_resources,
-};
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-static struct resource bfin_sir0_resources[] = {
-	{
-		.start = 0xFFC00400,
-		.end = 0xFFC004FF,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = IRQ_UART0_RX,
-		.end = IRQ_UART0_RX+1,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.start = CH_UART0_RX,
-		.end = CH_UART0_RX+1,
-		.flags = IORESOURCE_DMA,
-	},
-};
-
-static struct platform_device bfin_sir0_device = {
-	.name = "bfin_sir",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(bfin_sir0_resources),
-	.resource = bfin_sir0_resources,
-};
-#endif
-#ifdef CONFIG_BFIN_SIR1
-static struct resource bfin_sir1_resources[] = {
-	{
-		.start = 0xFFC02000,
-		.end = 0xFFC020FF,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = IRQ_UART1_RX,
-		.end = IRQ_UART1_RX+1,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.start = CH_UART1_RX,
-		.end = CH_UART1_RX+1,
-		.flags = IORESOURCE_DMA,
-	},
-};
-
-static struct platform_device bfin_sir1_device = {
-	.name = "bfin_sir",
-	.id = 1,
-	.num_resources = ARRAY_SIZE(bfin_sir1_resources),
-	.resource = bfin_sir1_resources,
-};
-#endif
-#endif
-
-#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
-static struct resource bfin_twi0_resource[] = {
-	[0] = {
-		.start = TWI0_REGBASE,
-		.end   = TWI0_REGBASE + 0xFF,
-		.flags = IORESOURCE_MEM,
-	},
-	[1] = {
-		.start = IRQ_TWI,
-		.end   = IRQ_TWI,
-		.flags = IORESOURCE_IRQ,
-	},
-};
-
-static struct platform_device i2c_bfin_twi_device = {
-	.name = "i2c-bfin-twi",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(bfin_twi0_resource),
-	.resource = bfin_twi0_resource,
-};
-#endif
-
-#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
-static struct platform_device bfin_sport0_uart_device = {
-	.name = "bfin-sport-uart",
-	.id = 0,
-};
-
-static struct platform_device bfin_sport1_uart_device = {
-	.name = "bfin-sport-uart",
-	.id = 1,
-};
-#endif
-
-static struct platform_device *stamp_devices[] __initdata = {
-#if defined(CONFIG_BFIN_CFPCMCIA) || defined(CONFIG_BFIN_CFPCMCIA_MODULE)
-	&bfin_pcmcia_cf_device,
-#endif
-
-#if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
-	&rtc_device,
-#endif
-
-#if defined(CONFIG_USB_SL811_HCD) || defined(CONFIG_USB_SL811_HCD_MODULE)
-	&sl811_hcd_device,
-#endif
-
-#if defined(CONFIG_USB_ISP1362_HCD) || defined(CONFIG_USB_ISP1362_HCD_MODULE)
-	&isp1362_hcd_device,
-#endif
-
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-	&smc91x_device,
-#endif
-
-#if defined(CONFIG_DM9000) || defined(CONFIG_DM9000_MODULE)
-	&dm9000_device,
-#endif
-
-#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
-	&bfin_mii_bus,
-	&bfin_mac_device,
-#endif
-
-#if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
-	&net2272_bfin_device,
-#endif
-
-#if defined(CONFIG_USB_ISP1760_HCD) || defined(CONFIG_USB_ISP1760_HCD_MODULE)
-	&bfin_isp1760_device,
-#endif
-
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-	&bfin_spi0_device,
-#endif
-
-#if defined(CONFIG_FB_BF537_LQ035) || defined(CONFIG_FB_BF537_LQ035_MODULE)
-	&bfin_fb_device,
-#endif
-
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
-#if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
-	&bfin_uart_device,
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-	&bfin_sir0_device,
-#endif
-#ifdef CONFIG_BFIN_SIR1
-	&bfin_sir1_device,
-#endif
-#endif
-
-#if defined(CONFIG_I2C_BLACKFIN_TWI) || defined(CONFIG_I2C_BLACKFIN_TWI_MODULE)
-	&i2c_bfin_twi_device,
-#endif
-
-#if defined(CONFIG_SERIAL_BFIN_SPORT) ||
defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
-	&bfin_sport0_uart_device,
-	&bfin_sport1_uart_device,
-#endif
-};
-
-static int __init generic_init(void)
-{
-	printk(KERN_INFO "%s(): registering device resources\n", __func__);
-	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
-#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-	spi_register_board_info(bfin_spi_board_info,
-				ARRAY_SIZE(bfin_spi_board_info));
-#endif
-
-	return 0;
-}
-
-arch_initcall(generic_init);
-
-void native_machine_restart(char *cmd)
-{
-	/* workaround reboot hang when booting from SPI */
-	if ((bfin_read_SYSCR() & 0x7) == 0x3)
-		bfin_reset_boot_spi_cs(P_DEFAULT_BOOT_SPI_CS);
-}
-
-#if defined(CONFIG_BFIN_MAC) || defined(CONFIG_BFIN_MAC_MODULE)
-void bfin_get_ether_addr(char *addr)
-{
-	random_ether_addr(addr);
-	printk(KERN_WARNING "%s:%s: Setting Ethernet MAC to a random one\n",
__FILE__, __func__);
-}
-EXPORT_SYMBOL(bfin_get_ether_addr);
-#endif
diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c
b/arch/blackfin/mach-bf537/boards/minotaur.c
index db7d3a3..3c15981 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -134,9 +134,9 @@ static struct bfin5xx_spi_chip spi_flash_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -156,23 +156,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc_dummy",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 5000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = 0,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
-	{
-		.modalias = "spi_mmc",
-		.max_speed_hz = 5000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c
b/arch/blackfin/mach-bf537/boards/pnav10.c
index 590eb3a..4e1de1e 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -289,9 +289,9 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -364,23 +364,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad9960_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 7,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 3f4f203..53ad10f 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -108,9 +108,9 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -160,23 +160,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 	},
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-	{
-		.modalias = "spi_mmc_dummy",
-		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
-		.bus_num = 0,
-		.chip_select = 7,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
-		.mode = SPI_MODE_3,
-	},
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf537/include/mach/anomaly.h
b/arch/blackfin/mach-bf537/include/mach/anomaly.h
index 9cb3912..1bfd80c 100644
--- a/arch/blackfin/mach-bf537/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf537/include/mach/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf537/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -110,7 +110,7 @@
 #define ANOMALY_05000301 (1)
 /* SSYNCs After Writes To CAN/DMA MMR Registers Are Not Always
Handled Correctly */
 #define ANOMALY_05000304 (__SILICON_REVISION__ < 3)
-/* New Feature: Additional Hysteresis on SPORT Input Pins (Not
Available On Older Silicon) */
+/* SPORT_HYS Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 3)
 /* SCKELOW Bit Does Not Maintain State Through Hibernate */
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 3)
@@ -168,9 +168,12 @@
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
index b3f87e1..9e34700 100644
--- a/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf537/include/mach/bfin_serial_5xx.h
@@ -144,7 +144,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART0_TX,
 	CH_UART0_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART0_CTS_PIN,
 	CONFIG_UART0_RTS_PIN,
 #endif
@@ -158,7 +158,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART1_TX,
 	CH_UART1_RX,
 #endif
-#ifdef CONFIG_BFIN_UART1_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART1_CTS_PIN,
 	CONFIG_UART1_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-bf538/include/mach/anomaly.h
b/arch/blackfin/mach-bf538/include/mach/anomaly.h
index e130b4f..3a56998 100644
--- a/arch/blackfin/mach-bf538/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf538/include/mach/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf538/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -120,13 +120,17 @@
 #define ANOMALY_05000198 (0)
 #define ANOMALY_05000230 (0)
 #define ANOMALY_05000263 (0)
+#define ANOMALY_05000305 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000323 (0)
 #define ANOMALY_05000353 (1)
 #define ANOMALY_05000363 (0)
+#define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000412 (0)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
index 40503b6..3c2811e 100644
--- a/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf538/include/mach/bfin_serial_5xx.h
@@ -144,7 +144,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART0_TX,
 	CH_UART0_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART0_CTS_PIN,
 	CONFIG_UART0_RTS_PIN,
 #endif
@@ -158,7 +158,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART1_TX,
 	CH_UART1_RX,
 #endif
-#ifdef CONFIG_BFIN_UART1_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART1_CTS_PIN,
 	CONFIG_UART1_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-bf548/include/mach/anomaly.h
b/arch/blackfin/mach-bf548/include/mach/anomaly.h
index 23d03c5..882e40c 100644
--- a/arch/blackfin/mach-bf548/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf548/include/mach/anomaly.h
@@ -2,12 +2,12 @@
  * File: include/asm-blackfin/mach-bf548/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

 /* This file shoule be up to date with:
- *  - Revision G, 08/07/2008; ADSP-BF542/BF544/BF547/BF548/BF549
Blackfin Processor Anomaly List
+ *  - Revision H, 01/16/2009; ADSP-BF542/BF544/BF547/BF548/BF549
Blackfin Processor Anomaly List
  */

 #ifndef _MACH_ANOMALY_H_
@@ -91,8 +91,6 @@
 #define ANOMALY_05000371 (__SILICON_REVISION__ < 2)
 /* USB DP/DM Data Pins May Lose State When Entering Hibernate */
 #define ANOMALY_05000372 (__SILICON_REVISION__ < 1)
-/* Mobile DDR Operation Not Functional */
-#define ANOMALY_05000377 (1)
 /* Security/Authentication Speedpath Causes Authentication To Fail To
Initiate */
 #define ANOMALY_05000378 (__SILICON_REVISION__ < 2)
 /* 16-Bit NAND FLASH Boot Mode Is Not Functional */
@@ -157,8 +155,22 @@
 #define ANOMALY_05000429 (__SILICON_REVISION__ < 2)
 /* Software System Reset Corrupts PLL_LOCKCNT Register */
 #define ANOMALY_05000430 (__SILICON_REVISION__ >= 2)
+/* Incorrect Use of Stack in Lockbox Firmware During Authentication */
+#define ANOMALY_05000431 (__SILICON_REVISION__ < 3)
+/* OTP Write Accesses Not Supported */
+#define ANOMALY_05000442 (__SILICON_REVISION__ < 1)
 /* IFLUSH Instruction at End of Hardware Loop Causes Infinite Stall */
 #define ANOMALY_05000443 (1)
+/* CDMAPRIO and L2DMAPRIO Bits in the SYSCR Register Are Not Functional */
+#define ANOMALY_05000446 (1)
+/* UART IrDA Receiver Fails on Extended Bit Pulses */
+#define ANOMALY_05000447 (1)
+/* DDR Clock Duty Cycle Spec Violation (tCH, tCL) */
+#define ANOMALY_05000448 (__SILICON_REVISION__ == 1)
+/* Reduced Timing Margins on DDR Output Setup and Hold (tDS and tDH) */
+#define ANOMALY_05000449 (__SILICON_REVISION__ == 1)
+/* USB DMA Mode 1 Short Packet Data Corruption */
+#define ANOMALY_05000450 (1

 /* Anomalies that don't exist on this proc */
 #define ANOMALY_05000125 (0)
@@ -171,6 +183,8 @@
 #define ANOMALY_05000263 (0)
 #define ANOMALY_05000266 (0)
 #define ANOMALY_05000273 (0)
+#define ANOMALY_05000278 (0)
+#define ANOMALY_05000305 (0)
 #define ANOMALY_05000307 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000323 (0)
diff --git a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
index e4cf35e..c05e79c 100644
--- a/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf548/include/mach/bfin_serial_5xx.h
@@ -63,7 +63,7 @@
 #define UART_ENABLE_INTS(x, v) UART_SET_IER(x, v)
 #define UART_DISABLE_INTS(x) UART_CLEAR_IER(x, 0xF)

-#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART1_CTSRTS)
+#if defined(CONFIG_BFIN_UART0_CTSRTS) || defined(CONFIG_BFIN_UART2_CTSRTS)
 # define CONFIG_SERIAL_BFIN_CTSRTS

 # ifndef CONFIG_UART0_CTS_PIN
@@ -74,12 +74,12 @@
 #  define CONFIG_UART0_RTS_PIN -1
 # endif

-# ifndef CONFIG_UART1_CTS_PIN
-#  define CONFIG_UART1_CTS_PIN -1
+# ifndef CONFIG_UART2_CTS_PIN
+#  define CONFIG_UART2_CTS_PIN -1
 # endif

-# ifndef CONFIG_UART1_RTS_PIN
-#  define CONFIG_UART1_RTS_PIN -1
+# ifndef CONFIG_UART2_RTS_PIN
+#  define CONFIG_UART2_RTS_PIN -1
 # endif
 #endif

@@ -130,7 +130,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART0_TX,
 	CH_UART0_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART0_CTS_PIN,
 	CONFIG_UART0_RTS_PIN,
 #endif
@@ -144,6 +144,10 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART1_TX,
 	CH_UART1_RX,
 #endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	0,
+	0,
+#endif
 	},
 #endif
 #ifdef CONFIG_SERIAL_BFIN_UART2
@@ -154,7 +158,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART2_TX,
 	CH_UART2_RX,
 #endif
-#ifdef CONFIG_BFIN_UART2_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART2_CTS_PIN,
 	CONFIG_UART2_RTS_PIN,
 #endif
@@ -168,6 +172,10 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART3_TX,
 	CH_UART3_RX,
 #endif
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
+	0,
+	0,
+#endif
 	},
 #endif
 };
diff --git a/arch/blackfin/mach-bf548/include/mach/irq.h
b/arch/blackfin/mach-bf548/include/mach/irq.h
index 60299a7..f194625 100644
--- a/arch/blackfin/mach-bf548/include/mach/irq.h
+++ b/arch/blackfin/mach-bf548/include/mach/irq.h
@@ -123,8 +123,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_MXVR_ERROR		BFIN_IRQ(51)	/* MXVR Status (Error) Interrupt */
 #define IRQ_MXVR_MSG		BFIN_IRQ(52)	/* MXVR Message Interrupt */
 #define IRQ_MXVR_PKT		BFIN_IRQ(53)	/* MXVR Packet Interrupt */
-#define IRQ_EPP1_ERROR		BFIN_IRQ(54)	/* EPPI1 Error Interrupt */
-#define IRQ_EPP2_ERROR		BFIN_IRQ(55)	/* EPPI2 Error Interrupt */
+#define IRQ_EPPI1_ERROR		BFIN_IRQ(54)	/* EPPI1 Error Interrupt */
+#define IRQ_EPPI2_ERROR		BFIN_IRQ(55)	/* EPPI2 Error Interrupt */
 #define IRQ_UART3_ERROR		BFIN_IRQ(56)	/* UART3 Status (Error) Interrupt */
 #define IRQ_HOST_ERROR		BFIN_IRQ(57)	/* HOST Status (Error) Interrupt */
 #define IRQ_PIXC_ERROR		BFIN_IRQ(59)	/* PIXC Status (Error) Interrupt */
@@ -361,8 +361,8 @@ Events         (highest priority)  EMU         0
 #define IRQ_UART2_ERR 		IRQ_UART2_ERROR
 #define IRQ_CAN0_ERR  		IRQ_CAN0_ERROR
 #define IRQ_MXVR_ERR  		IRQ_MXVR_ERROR
-#define IRQ_EPP1_ERR  		IRQ_EPP1_ERROR
-#define IRQ_EPP2_ERR  		IRQ_EPP2_ERROR
+#define IRQ_EPPI1_ERR  		IRQ_EPPI1_ERROR
+#define IRQ_EPPI2_ERR  		IRQ_EPPI2_ERROR
 #define IRQ_UART3_ERR 		IRQ_UART3_ERROR
 #define IRQ_HOST_ERR  		IRQ_HOST_ERROR
 #define IRQ_PIXC_ERR  		IRQ_PIXC_ERROR
diff --git a/arch/blackfin/mach-bf561/boards/Kconfig
b/arch/blackfin/mach-bf561/boards/Kconfig
index e41a67b..e4bc6d7 100644
--- a/arch/blackfin/mach-bf561/boards/Kconfig
+++ b/arch/blackfin/mach-bf561/boards/Kconfig
@@ -19,9 +19,4 @@ config BFIN561_BLUETECHNIX_CM
 	help
 	  CM-BF561 support for EVAL- and DEV-Board.

-config GENERIC_BF561_BOARD
-	bool "Generic"
-	help
-	  Generic or Custom board support.
-
 endchoice
diff --git a/arch/blackfin/mach-bf561/boards/Makefile
b/arch/blackfin/mach-bf561/boards/Makefile
index 04add01..3a15255 100644
--- a/arch/blackfin/mach-bf561/boards/Makefile
+++ b/arch/blackfin/mach-bf561/boards/Makefile
@@ -2,7 +2,6 @@
 # arch/blackfin/mach-bf561/boards/Makefile
 #

-obj-$(CONFIG_GENERIC_BF561_BOARD)      += generic_board.o
 obj-$(CONFIG_BFIN561_BLUETECHNIX_CM)   += cm_bf561.o
 obj-$(CONFIG_BFIN561_EZKIT)            += ezkit.o
 obj-$(CONFIG_BFIN561_TEPLA)            += tepla.o
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c
b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 6880d1e..f623c6b 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -105,9 +105,9 @@ static struct bfin5xx_spi_chip ad9960_spi_chip_info = {
 };
 #endif

-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
-static struct bfin5xx_spi_chip spi_mmc_chip_info = {
-	.enable_dma = 1,
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
+static struct bfin5xx_spi_chip mmc_spi_chip_info = {
+	.enable_dma = 0,
 	.bits_per_word = 8,
 };
 #endif
@@ -155,14 +155,13 @@ static struct spi_board_info
bfin_spi_board_info[] __initdata = {
 		.controller_data = &ad9960_spi_chip_info,
 	},
 #endif
-#if defined(CONFIG_SPI_MMC) || defined(CONFIG_SPI_MMC_MODULE)
+#if defined(CONFIG_MMC_SPI) || defined(CONFIG_MMC_SPI_MODULE)
 	{
-		.modalias = "spi_mmc",
+		.modalias = "mmc_spi",
 		.max_speed_hz = 25000000,     /* max spi clock (SCK) speed in HZ */
 		.bus_num = 0,
-		.chip_select = CONFIG_SPI_MMC_CS_CHAN,
-		.platform_data = NULL,
-		.controller_data = &spi_mmc_chip_info,
+		.chip_select = 5,
+		.controller_data = &mmc_spi_chip_info,
 		.mode = SPI_MODE_3,
 	},
 #endif
diff --git a/arch/blackfin/mach-bf561/boards/generic_board.c
b/arch/blackfin/mach-bf561/boards/generic_board.c
deleted file mode 100644
index 0ba366a..0000000
--- a/arch/blackfin/mach-bf561/boards/generic_board.c
+++ /dev/null
@@ -1,113 +0,0 @@
-/*
- * File:         arch/blackfin/mach-bf561/generic_board.c
- * Based on:     arch/blackfin/mach-bf533/ezkit.c
- * Author:       Aidan Williams <aidan@nicta.com.au>
- *
- * Created:
- * Description:
- *
- * Modified:
- *               Copyright 2005 National ICT Australia (NICTA)
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
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/irq.h>
-
-const char bfin_board_name[] = "UNKNOWN BOARD";
-
-/*
- *  Driver needs to know address, irq and flag pin.
- */
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-static struct resource smc91x_resources[] = {
-	{
-		.start = 0x2C010300,
-		.end = 0x2C010300 + 16,
-		.flags = IORESOURCE_MEM,
-	}, {
-		.start = IRQ_PROG_INTB,
-		.end = IRQ_PROG_INTB,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	}, {
-		.start = IRQ_PF9,
-		.end = IRQ_PF9,
-		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_HIGHLEVEL,
-	},
-};
-
-static struct platform_device smc91x_device = {
-	.name = "smc91x",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(smc91x_resources),
-	.resource = smc91x_resources,
-};
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-static struct resource bfin_sir0_resources[] = {
-	{
-		.start = 0xFFC00400,
-		.end = 0xFFC004FF,
-		.flags = IORESOURCE_MEM,
-	},
-	{
-		.start = IRQ_UART0_RX,
-		.end = IRQ_UART0_RX+1,
-		.flags = IORESOURCE_IRQ,
-	},
-	{
-		.start = CH_UART0_RX,
-		.end = CH_UART0_RX+1,
-		.flags = IORESOURCE_DMA,
-	},
-};
-
-static struct platform_device bfin_sir0_device = {
-	.name = "bfin_sir",
-	.id = 0,
-	.num_resources = ARRAY_SIZE(bfin_sir0_resources),
-	.resource = bfin_sir0_resources,
-};
-#endif
-#endif
-
-static struct platform_device *generic_board_devices[] __initdata = {
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-	&smc91x_device,
-#endif
-
-#if defined(CONFIG_BFIN_SIR) || defined(CONFIG_BFIN_SIR_MODULE)
-#ifdef CONFIG_BFIN_SIR0
-	&bfin_sir0_device,
-#endif
-#endif
-};
-
-static int __init generic_board_init(void)
-{
-	printk(KERN_INFO "%s(): registering device resources\n", __func__);
-	return platform_add_devices(generic_board_devices,
-				    ARRAY_SIZE(generic_board_devices));
-}
-
-arch_initcall(generic_board_init);
diff --git a/arch/blackfin/mach-bf561/include/mach/anomaly.h
b/arch/blackfin/mach-bf561/include/mach/anomaly.h
index 1a9e175..d0b0b35 100644
--- a/arch/blackfin/mach-bf561/include/mach/anomaly.h
+++ b/arch/blackfin/mach-bf561/include/mach/anomaly.h
@@ -2,7 +2,7 @@
  * File: include/asm-blackfin/mach-bf561/anomaly.h
  * Bugs: Enter bugs at http://blackfin.uclinux.org/
  *
- * Copyright (C) 2004-2008 Analog Devices Inc.
+ * Copyright (C) 2004-2009 Analog Devices Inc.
  * Licensed under the GPL-2 or later.
  */

@@ -224,7 +224,7 @@
 #define ANOMALY_05000301 (1)
 /* SSYNCs After Writes To DMA MMR Registers May Not Be Handled Correctly */
 #define ANOMALY_05000302 (1)
-/* New Feature: Additional Hysteresis on SPORT Input Pins (Not
Available On Older Silicon) */
+/* SPORT_HYS Bit in PLL_CTL Register Is Not Functional */
 #define ANOMALY_05000305 (__SILICON_REVISION__ < 5)
 /* SCKELOW Bit Does Not Maintain State Through Hibernate */
 #define ANOMALY_05000307 (__SILICON_REVISION__ < 5)
@@ -283,8 +283,11 @@
 #define ANOMALY_05000273 (0)
 #define ANOMALY_05000311 (0)
 #define ANOMALY_05000353 (1)
+#define ANOMALY_05000380 (0)
 #define ANOMALY_05000386 (1)
 #define ANOMALY_05000432 (0)
 #define ANOMALY_05000435 (0)
+#define ANOMALY_05000447 (0)
+#define ANOMALY_05000448 (0)

 #endif
diff --git a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
index 043bfcf..ca8c5f6 100644
--- a/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
+++ b/arch/blackfin/mach-bf561/include/mach/bfin_serial_5xx.h
@@ -134,7 +134,7 @@ struct bfin_serial_res bfin_serial_resource[] = {
 	CH_UART_TX,
 	CH_UART_RX,
 #endif
-#ifdef CONFIG_BFIN_UART0_CTSRTS
+#ifdef CONFIG_SERIAL_BFIN_CTSRTS
 	CONFIG_UART0_CTS_PIN,
 	CONFIG_UART0_RTS_PIN,
 #endif
diff --git a/arch/blackfin/mach-common/arch_checks.c
b/arch/blackfin/mach-common/arch_checks.c
index 98133b9..80d39b2 100644
--- a/arch/blackfin/mach-common/arch_checks.c
+++ b/arch/blackfin/mach-common/arch_checks.c
@@ -62,3 +62,12 @@
 #if (CONFIG_BOOT_LOAD & 0x3)
 # error "The kernel load address must be 4 byte aligned"
 #endif
+
+/* The entire kernel must be able to make a 24bit pcrel call to start of L1 */
+#if ((0xffffffff - L1_CODE_START + 1) + CONFIG_BOOT_LOAD) > 0x1000000
+# error "The kernel load address is too high; keep it below 10meg for safety"
+#endif
+
+#if ANOMALY_05000448
+# error You are using a part with anomaly 05000448, this issue causes
random memory read/write failures - that means random crashes.
+#endif
diff --git a/arch/blackfin/mach-common/cache.S
b/arch/blackfin/mach-common/cache.S
index 3c98dac..aa0648c 100644
--- a/arch/blackfin/mach-common/cache.S
+++ b/arch/blackfin/mach-common/cache.S
@@ -66,11 +66,33 @@

 /* Invalidate all instruction cache lines assocoiated with this memory area */
 ENTRY(_blackfin_icache_flush_range)
+/*
+ * Walkaround to avoid loading wrong instruction after invalidating icache
+ * and following sequence is met.
+ *
+ * 1) One instruction address is cached in the instruction cache.
+ * 2) This instruction in SDRAM is changed.
+ * 3) IFLASH[P0] is executed only once in blackfin_icache_flush_range().
+ * 4) This instruction is executed again, but the old one is loaded.
+ */
+	P0 = R0;
+	IFLUSH[P0];
 	do_flush IFLUSH, , nop
 ENDPROC(_blackfin_icache_flush_range)

 /* Flush all cache lines assocoiated with this area of memory. */
 ENTRY(_blackfin_icache_dcache_flush_range)
+/*
+ * Walkaround to avoid loading wrong instruction after invalidating icache
+ * and following sequence is met.
+ *
+ * 1) One instruction address is cached in the instruction cache.
+ * 2) This instruction in SDRAM is changed.
+ * 3) IFLASH[P0] is executed only once in blackfin_icache_flush_range().
+ * 4) This instruction is executed again, but the old one is loaded.
+ */
+	P0 = R0;
+	IFLUSH[P0];
 	do_flush FLUSH, IFLUSH
 ENDPROC(_blackfin_icache_dcache_flush_range)

diff --git a/arch/blackfin/mach-common/clocks-init.c
b/arch/blackfin/mach-common/clocks-init.c
index 9dddb6f..3539365 100644
--- a/arch/blackfin/mach-common/clocks-init.c
+++ b/arch/blackfin/mach-common/clocks-init.c
@@ -17,7 +17,7 @@
 #define SDGCTL_WIDTH (1 << 31)	/* SDRAM external data path width */
 #define PLL_CTL_VAL \
 	(((CONFIG_VCO_MULT & 63) << 9) | CLKIN_HALF | \
-	 (PLL_BYPASS << 8) | (ANOMALY_05000265 ? 0x8000 : 0))
+	 (PLL_BYPASS << 8) | (ANOMALY_05000305 ? 0 : 0x8000))

 __attribute__((l1_text))
 static void do_sync(void)
diff --git a/arch/blackfin/mach-common/dpmc_modes.S
b/arch/blackfin/mach-common/dpmc_modes.S
index 4da50bc..8009a51 100644
--- a/arch/blackfin/mach-common/dpmc_modes.S
+++ b/arch/blackfin/mach-common/dpmc_modes.S
@@ -376,10 +376,22 @@ ENTRY(_do_hibernate)
 #endif

 #ifdef PINT0_ASSIGN
+	PM_SYS_PUSH(PINT0_MASK_SET)
+	PM_SYS_PUSH(PINT1_MASK_SET)
+	PM_SYS_PUSH(PINT2_MASK_SET)
+	PM_SYS_PUSH(PINT3_MASK_SET)
 	PM_SYS_PUSH(PINT0_ASSIGN)
 	PM_SYS_PUSH(PINT1_ASSIGN)
 	PM_SYS_PUSH(PINT2_ASSIGN)
 	PM_SYS_PUSH(PINT3_ASSIGN)
+	PM_SYS_PUSH(PINT0_INVERT_SET)
+	PM_SYS_PUSH(PINT1_INVERT_SET)
+	PM_SYS_PUSH(PINT2_INVERT_SET)
+	PM_SYS_PUSH(PINT3_INVERT_SET)
+	PM_SYS_PUSH(PINT0_EDGE_SET)
+	PM_SYS_PUSH(PINT1_EDGE_SET)
+	PM_SYS_PUSH(PINT2_EDGE_SET)
+	PM_SYS_PUSH(PINT3_EDGE_SET)
 #endif

 	PM_SYS_PUSH(EBIU_AMBCTL0)
@@ -714,10 +726,22 @@ ENTRY(_do_hibernate)
 	PM_SYS_POP(EBIU_AMBCTL0)

 #ifdef PINT0_ASSIGN
+	PM_SYS_POP(PINT3_EDGE_SET)
+	PM_SYS_POP(PINT2_EDGE_SET)
+	PM_SYS_POP(PINT1_EDGE_SET)
+	PM_SYS_POP(PINT0_EDGE_SET)
+	PM_SYS_POP(PINT3_INVERT_SET)
+	PM_SYS_POP(PINT2_INVERT_SET)
+	PM_SYS_POP(PINT1_INVERT_SET)
+	PM_SYS_POP(PINT0_INVERT_SET)
 	PM_SYS_POP(PINT3_ASSIGN)
 	PM_SYS_POP(PINT2_ASSIGN)
 	PM_SYS_POP(PINT1_ASSIGN)
 	PM_SYS_POP(PINT0_ASSIGN)
+	PM_SYS_POP(PINT3_MASK_SET)
+	PM_SYS_POP(PINT2_MASK_SET)
+	PM_SYS_POP(PINT1_MASK_SET)
+	PM_SYS_POP(PINT0_MASK_SET)
 #endif

 #ifdef SICA_IWR1
diff --git a/arch/blackfin/mach-common/entry.S
b/arch/blackfin/mach-common/entry.S
index 88de053..21e65a3 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -600,6 +600,19 @@ ENTRY(_system_call)
 	p2 = [p2];

 	[p2+(TASK_THREAD+THREAD_KSP)] = sp;
+#ifdef CONFIG_IPIPE
+	r0 = sp;
+	SP += -12;
+	call ___ipipe_syscall_root;
+	SP += 12;
+	cc = r0 == 1;
+	if cc jump .Lsyscall_really_exit;
+	cc = r0 == -1;
+	if cc jump .Lresume_userspace;
+	r3 = [sp + PT_R3];
+	r4 = [sp + PT_R4];
+	p0 = [sp + PT_ORIG_P0];
+#endif /* CONFIG_IPIPE */

 	/* Check the System Call */
 	r7 = __NR_syscall;
@@ -654,6 +667,17 @@ ENTRY(_system_call)
 	r7 =  r7 & r4;

 .Lsyscall_resched:
+#ifdef CONFIG_IPIPE
+	cc = BITTST(r7, TIF_IRQ_SYNC);
+	if !cc jump .Lsyscall_no_irqsync;
+	[--sp] = reti;
+	r0 = [sp++];
+	SP += -12;
+	call ___ipipe_sync_root;
+	SP += 12;
+	jump .Lresume_userspace_1;
+.Lsyscall_no_irqsync:
+#endif
 	cc = BITTST(r7, TIF_NEED_RESCHED);
 	if !cc jump .Lsyscall_sigpending;

@@ -685,6 +709,10 @@ ENTRY(_system_call)
 .Lsyscall_really_exit:
 	r5 = [sp + PT_RESERVED];
 	rets = r5;
+#ifdef CONFIG_IPIPE
+	[--sp] = reti;
+	r5 = [sp++];
+#endif /* CONFIG_IPIPE */
 	rts;
 ENDPROC(_system_call)

@@ -771,6 +799,15 @@ _new_old_task:
 ENDPROC(_resume)

 ENTRY(_ret_from_exception)
+#ifdef CONFIG_IPIPE
+	[--sp] = rets;
+	SP += -12;
+	call ___ipipe_check_root
+	SP += 12
+	rets = [sp++];
+	cc = r0 == 0;
+	if cc jump 4f;                /* not on behalf of Linux, get out */
+#endif /* CONFIG_IPIPE */
 	p2.l = lo(IPEND);
 	p2.h = hi(IPEND);

@@ -827,6 +864,28 @@ ENTRY(_ret_from_exception)
 	rts;
 ENDPROC(_ret_from_exception)

+#ifdef CONFIG_IPIPE
+
+_sync_root_irqs:
+	[--sp] = reti;		/* Reenable interrupts */
+	r0 = [sp++];
+	jump.l ___ipipe_sync_root
+
+_resume_kernel_from_int:
+	r0.l = _sync_root_irqs
+	r0.h = _sync_root_irqs
+	[--sp] = rets;
+	[--sp] = ( r7:4, p5:3 );
+	SP += -12;
+	call ___ipipe_call_irqtail
+	SP += 12;
+	( r7:4, p5:3 ) = [sp++];
+	rets = [sp++];
+	rts
+#else
+#define _resume_kernel_from_int	 2f
+#endif
+
 ENTRY(_return_from_int)
 	/* If someone else already raised IRQ 15, do nothing.  */
 	csync;
@@ -848,7 +907,7 @@ ENTRY(_return_from_int)
 	r1 = r0 - r1;
 	r2 = r0 & r1;
 	cc = r2 == 0;
-	if !cc jump 2f;
+	if !cc jump _resume_kernel_from_int;

 	/* Lower the interrupt level to 15.  */
 	p0.l = lo(EVT15);
diff --git a/arch/blackfin/mach-common/interrupt.S
b/arch/blackfin/mach-common/interrupt.S
index 43c4eb9..0069c2d 100644
--- a/arch/blackfin/mach-common/interrupt.S
+++ b/arch/blackfin/mach-common/interrupt.S
@@ -235,6 +235,7 @@ ENDPROC(_evt_system_call)

 #ifdef CONFIG_IPIPE
 ENTRY(___ipipe_call_irqtail)
+	p0 = r0;
 	r0.l = 1f;
 	r0.h = 1f;
 	reti = r0;
@@ -242,9 +243,6 @@ ENTRY(___ipipe_call_irqtail)
 1:
 	[--sp] = rets;
 	[--sp] = ( r7:4, p5:3 );
-	p0.l = ___ipipe_irq_tail_hook;
-	p0.h = ___ipipe_irq_tail_hook;
-	p0 = [p0];
 	sp += -12;
 	call (p0);
 	sp += 12;
@@ -259,7 +257,7 @@ ENTRY(___ipipe_call_irqtail)
 	p0.h = hi(EVT14);
 	[p0] = r0;
 	csync;
-	r0 = 0x401f;
+	r0 = 0x401f (z);
 	sti r0;
 	raise 14;
 	[--sp] = reti;          /* IRQs on. */
@@ -277,11 +275,7 @@ ENTRY(___ipipe_call_irqtail)
 	p0.h = _bfin_irq_flags;
 	r0 = [p0];
 	sti r0;
-#if 0 /* FIXME: this actually raises scheduling latencies */
-	/* Reenable interrupts */
-	[--sp] = reti;
-	r0 = [sp++];
-#endif
 	rts;
 ENDPROC(___ipipe_call_irqtail)
+
 #endif /* CONFIG_IPIPE */
diff --git a/arch/blackfin/mach-common/ints-priority.c
b/arch/blackfin/mach-common/ints-priority.c
index 2024945..a7d7b2d 100644
--- a/arch/blackfin/mach-common/ints-priority.c
+++ b/arch/blackfin/mach-common/ints-priority.c
@@ -161,11 +161,15 @@ static void bfin_core_unmask_irq(unsigned int irq)

 static void bfin_internal_mask_irq(unsigned int irq)
 {
+	unsigned long flags;
+
 #ifdef CONFIG_BF53x
+	local_irq_save_hw(flags);
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() &
 			     ~(1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
+	local_irq_save_hw(flags);
 	mask_bank = SIC_SYSIRQ(irq) / 32;
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) &
@@ -175,15 +179,20 @@ static void bfin_internal_mask_irq(unsigned int irq)
 			     ~(1 << mask_bit));
 #endif
 #endif
+	local_irq_restore_hw(flags);
 }

 static void bfin_internal_unmask_irq(unsigned int irq)
 {
+	unsigned long flags;
+
 #ifdef CONFIG_BF53x
+	local_irq_save_hw(flags);
 	bfin_write_SIC_IMASK(bfin_read_SIC_IMASK() |
 			     (1 << SIC_SYSIRQ(irq)));
 #else
 	unsigned mask_bank, mask_bit;
+	local_irq_save_hw(flags);
 	mask_bank = SIC_SYSIRQ(irq) / 32;
 	mask_bit = SIC_SYSIRQ(irq) % 32;
 	bfin_write_SIC_IMASK(mask_bank, bfin_read_SIC_IMASK(mask_bank) |
@@ -193,6 +202,7 @@ static void bfin_internal_unmask_irq(unsigned int irq)
 			     (1 << mask_bit));
 #endif
 #endif
+	local_irq_restore_hw(flags);
 }

 #ifdef CONFIG_PM
@@ -390,7 +400,7 @@ static void bfin_demux_error_irq(unsigned int int_err_irq,
 static inline void bfin_set_irq_handler(unsigned irq,
irq_flow_handler_t handle)
 {
 #ifdef CONFIG_IPIPE
-	_set_irq_handler(irq, handle_edge_irq);
+	_set_irq_handler(irq, handle_level_irq);
 #else
 	struct irq_desc *desc = irq_desc + irq;
 	/* May not call generic set_irq_handler() due to spinlock
@@ -1055,13 +1065,18 @@ int __init init_arch_irq(void)
 #endif
 		default:
 #ifdef CONFIG_IPIPE
-	/*
-	 * We want internal interrupt sources to be masked, because
-	 * ISRs may trigger interrupts recursively (e.g. DMA), but
-	 * interrupts are _not_ masked at CPU level. So let's handle
-	 * them as level interrupts.
-	 */
-			set_irq_handler(irq, handle_level_irq);
+			/*
+			 * We want internal interrupt sources to be
+			 * masked, because ISRs may trigger interrupts
+			 * recursively (e.g. DMA), but interrupts are
+			 * _not_ masked at CPU level. So let's handle
+			 * most of them as level interrupts, except
+			 * the timer interrupt which is special.
+			 */
+			if (irq == IRQ_SYSTMR || irq == IRQ_CORETMR)
+				set_irq_handler(irq, handle_simple_irq);
+			else
+				set_irq_handler(irq, handle_level_irq);
 #else /* !CONFIG_IPIPE */
 			set_irq_handler(irq, handle_simple_irq);
 #endif /* !CONFIG_IPIPE */
@@ -1123,9 +1138,8 @@ int __init init_arch_irq(void)

 #ifdef CONFIG_IPIPE
 	for (irq = 0; irq < NR_IRQS; irq++) {
-		struct irq_desc *desc = irq_desc + irq;
+		struct irq_desc *desc = irq_to_desc(irq);
 		desc->ic_prio = __ipipe_get_irq_priority(irq);
-		desc->thr_prio = __ipipe_get_irqthread_priority(irq);
 	}
 #endif /* CONFIG_IPIPE */

@@ -1208,76 +1222,21 @@ int __ipipe_get_irq_priority(unsigned irq)
 	return IVG15;
 }

-int __ipipe_get_irqthread_priority(unsigned irq)
-{
-	int ient, prio;
-	int demux_irq;
-
-	/* The returned priority value is rescaled to [0..IVG13+1]
-	 * with 0 being the lowest effective priority level. */
-
-	if (irq <= IRQ_CORETMR)
-		return IVG13 - irq + 1;
-
-	/* GPIO IRQs are given the priority of the demux
-	 * interrupt. */
-	if (IS_GPIOIRQ(irq)) {
-#if defined(CONFIG_BF54x)
-		u32 bank = PINT_2_BANK(irq2pint_lut[irq - SYS_IRQS]);
-		demux_irq = (bank == 0 ? IRQ_PINT0 :
-				bank == 1 ? IRQ_PINT1 :
-				bank == 2 ? IRQ_PINT2 :
-				IRQ_PINT3);
-#elif defined(CONFIG_BF561)
-		demux_irq = (irq >= IRQ_PF32 ? IRQ_PROG2_INTA :
-				irq >= IRQ_PF16 ? IRQ_PROG1_INTA :
-				IRQ_PROG0_INTA);
-#elif defined(CONFIG_BF52x)
-		demux_irq = (irq >= IRQ_PH0 ? IRQ_PORTH_INTA :
-				irq >= IRQ_PG0 ? IRQ_PORTG_INTA :
-				IRQ_PORTF_INTA);
-#else
-		demux_irq = irq;
-#endif
-		return IVG13 - PRIO_GPIODEMUX(demux_irq) + 1;
-	}
-
-	/* The GPIO demux interrupt is given a lower priority
-	 * than the GPIO IRQs, so that its threaded handler
-	 * unmasks the interrupt line after the decoded IRQs
-	 * have been processed. */
-	prio = PRIO_GPIODEMUX(irq);
-	/* demux irq? */
-	if (prio != -1)
-		return IVG13 - prio;
-
-	for (ient = 0; ient < NR_PERI_INTS; ient++) {
-		struct ivgx *ivg = ivg_table + ient;
-		if (ivg->irqno == irq) {
-			for (prio = 0; prio <= IVG13-IVG7; prio++) {
-				if (ivg7_13[prio].ifirst <= ivg &&
-				    ivg7_13[prio].istop > ivg)
-					return IVG7 - prio;
-			}
-		}
-	}
-
-	return 0;
-}
-
 /* Hw interrupts are disabled on entry (check SAVE_CONTEXT). */
 #ifdef CONFIG_DO_IRQ_L1
 __attribute__((l1_text))
 #endif
 asmlinkage int __ipipe_grab_irq(int vec, struct pt_regs *regs)
 {
+	struct ipipe_percpu_domain_data *p = ipipe_root_cpudom_ptr();
+	struct ipipe_domain *this_domain = ipipe_current_domain;
 	struct ivgx *ivg_stop = ivg7_13[vec-IVG7].istop;
 	struct ivgx *ivg = ivg7_13[vec-IVG7].ifirst;
-	int irq;
+	int irq, s;

 	if (likely(vec == EVT_IVTMR_P)) {
 		irq = IRQ_CORETMR;
-		goto handle_irq;
+		goto core_tick;
 	}

 	SSYNC();
@@ -1319,24 +1278,39 @@ asmlinkage int __ipipe_grab_irq(int vec,
struct pt_regs *regs)
 	irq = ivg->irqno;

 	if (irq == IRQ_SYSTMR) {
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+core_tick:
+#else
 		bfin_write_TIMER_STATUS(1); /* Latch TIMIL0 */
+#endif
 		/* This is basically what we need from the register frame. */
 		__raw_get_cpu_var(__ipipe_tick_regs).ipend = regs->ipend;
 		__raw_get_cpu_var(__ipipe_tick_regs).pc = regs->pc;
-		if (!ipipe_root_domain_p)
-			__raw_get_cpu_var(__ipipe_tick_regs).ipend |= 0x10;
-		else
+		if (this_domain != ipipe_root_domain)
 			__raw_get_cpu_var(__ipipe_tick_regs).ipend &= ~0x10;
+		else
+			__raw_get_cpu_var(__ipipe_tick_regs).ipend |= 0x10;
 	}

-handle_irq:
+#ifndef CONFIG_GENERIC_CLOCKEVENTS
+core_tick:
+#endif
+	if (this_domain == ipipe_root_domain) {
+		s = __test_and_set_bit(IPIPE_SYNCDEFER_FLAG, &p->status);
+		barrier();
+	}

 	ipipe_trace_irq_entry(irq);
 	__ipipe_handle_irq(irq, regs);
-       ipipe_trace_irq_exit(irq);
+	ipipe_trace_irq_exit(irq);

-       if (ipipe_root_domain_p)
-		return !test_bit(IPIPE_STALL_FLAG, &ipipe_root_cpudom_var(status));
+	if (this_domain == ipipe_root_domain) {
+		set_thread_flag(TIF_IRQ_SYNC);
+		if (!s) {
+			__clear_bit(IPIPE_SYNCDEFER_FLAG, &p->status);
+			return !test_bit(IPIPE_STALL_FLAG, &p->status);
+		}
+	}

        return 0;
 }
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 77c9928..93eab61 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -158,10 +158,14 @@ static irqreturn_t ipi_handler(int irq, void
*dev_instance)
 			kfree(msg);
 			break;
 		case BFIN_IPI_CALL_FUNC:
+			spin_unlock(&msg_queue->lock);
 			ipi_call_function(cpu, msg);
+			spin_lock(&msg_queue->lock);
 			break;
 		case BFIN_IPI_CPU_STOP:
+			spin_unlock(&msg_queue->lock);
 			ipi_cpu_stop(cpu);
+			spin_lock(&msg_queue->lock);
 			kfree(msg);
 			break;
 		default:
@@ -457,7 +461,7 @@ void smp_icache_flush_range_others(unsigned long
start, unsigned long end)
 	smp_flush_data.start = start;
 	smp_flush_data.end = end;

-	if (smp_call_function(&ipi_flush_icache, &smp_flush_data, 1))
+	if (smp_call_function(&ipi_flush_icache, &smp_flush_data, 0))
 		printk(KERN_WARNING "SMP: failed to run I-cache flush request on
other CPUs\n");
 }
 EXPORT_SYMBOL_GPL(smp_icache_flush_range_others);
diff --git a/arch/blackfin/mm/init.c b/arch/blackfin/mm/init.c
index d0532b7..9c3629b 100644
--- a/arch/blackfin/mm/init.c
+++ b/arch/blackfin/mm/init.c
@@ -104,7 +104,7 @@ void __init paging_init(void)
 	}
 }

-asmlinkage void init_pda(void)
+asmlinkage void __init init_pda(void)
 {
 	unsigned int cpu = raw_smp_processor_id();
