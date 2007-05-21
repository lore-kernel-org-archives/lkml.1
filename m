Return-Path: <linux-kernel-owner+w=401wt.eu-S1764335AbXEUKQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764335AbXEUKQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761975AbXEUKJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:38 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:27800 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761419AbXEUKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:19 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510270:sNHT29272320"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 28/32] Blackfin arch: update defconfig files
Date: Mon, 21 May 2007 18:09:36 +0800
Message-Id: <1179742188941-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/defconfig |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/blackfin/defconfig b/arch/blackfin/defconfig
index d5904ca..a513fbe 100644
--- a/arch/blackfin/defconfig
+++ b/arch/blackfin/defconfig
@@ -1,19 +1,20 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20
+# Linux kernel version: 2.6.20.4
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+CONFIG_BLACKFIN=y
 CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
+# CONFIG_GENERIC_TIME is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_UCLINUX=y
 CONFIG_FORCE_MAX_ZONEORDER=14
 CONFIG_IRQCHIP_DEMUX_GPIO=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
@@ -55,6 +56,7 @@ CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_EPOLL=y
+CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
 # CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
@@ -95,6 +97,9 @@ CONFIG_DEFAULT_AS=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="anticipatory"
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
 
 #
 # Blackfin Processor Options
@@ -107,7 +112,6 @@ CONFIG_DEFAULT_IOSCHED="anticipatory"
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
 # CONFIG_BF534 is not set
-# CONFIG_BF535 is not set
 # CONFIG_BF536 is not set
 CONFIG_BF537=y
 # CONFIG_BF561 is not set
@@ -115,7 +119,6 @@ CONFIG_BF_REV_0_2=y
 # CONFIG_BF_REV_0_3 is not set
 # CONFIG_BF_REV_0_4 is not set
 # CONFIG_BF_REV_0_5 is not set
-CONFIG_BLACKFIN=y
 CONFIG_BFIN_SINGLE_CORE=y
 # CONFIG_BFIN533_EZKIT is not set
 # CONFIG_BFIN533_STAMP is not set
@@ -182,6 +185,7 @@ CONFIG_IRQ_WATCH=13
 #
 # Board customizations
 #
+# CONFIG_CMDLINE_BOOL is not set
 
 #
 # Board Setup
@@ -221,6 +225,19 @@ CONFIG_HZ=250
 # Memory Optimizations
 #
 CONFIG_I_ENTRY_L1=y
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
+# CONFIG_SYSCALL_TAB_L1 is not set
+# CONFIG_CPLB_SWITCH_TAB_L1 is not set
 CONFIG_RAMKERNEL=y
 # CONFIG_ROMKERNEL is not set
 CONFIG_SELECT_MEMORY_MODEL=y
@@ -243,6 +260,7 @@ CONFIG_DMA_UNCACHED_1M=y
 #
 CONFIG_BLKFIN_CACHE=y
 CONFIG_BLKFIN_DCACHE=y
+# CONFIG_BLKFIN_DCACHE_BANKA is not set
 # CONFIG_BLKFIN_CACHE_LOCK is not set
 # CONFIG_BLKFIN_WB is not set
 CONFIG_BLKFIN_WT=y
@@ -815,9 +833,8 @@ CONFIG_I2C_CHARDEV=m
 #
 # I2C Hardware Bus support
 #
-# CONFIG_I2C_BFIN_GPIO is not set
-CONFIG_I2C_BFIN_TWI=m
-CONFIG_TWICLK_KHZ=50
+# CONFIG_I2C_BLACKFIN_GPIO is not set
+# CONFIG_I2C_BLACKFIN_TWI is not set
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_STUB is not set
@@ -832,6 +849,7 @@ CONFIG_SENSORS_AD5252=m
 # CONFIG_SENSORS_EEPROM is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_SENSORS_PCF8575 is not set
+# CONFIG_SENSORS_PCA9543 is not set
 # CONFIG_SENSORS_PCA9539 is not set
 # CONFIG_SENSORS_PCF8591 is not set
 # CONFIG_SENSORS_MAX6875 is not set
@@ -850,11 +868,11 @@ CONFIG_SPI_MASTER=y
 # SPI Master Controller Drivers
 #
 # CONFIG_SPI_BITBANG is not set
-CONFIG_SPI_BFIN=y
 
 #
 # SPI Protocol Masters
 #
+CONFIG_SPI_BFIN=y
 
 #
 # Dallas's 1-wire bus
@@ -940,10 +958,6 @@ CONFIG_NTSC=y
 # CONFIG_PAL_YCBCR is not set
 CONFIG_ADV7393_1XMEM=y
 # CONFIG_ADV7393_2XMEM is not set
-CONFIG_FB_BF537_LQ035=m
-CONFIG_LQ035_SLAVE_ADDR=0x58
-# CONFIG_FB_BFIN_LANDSCAPE is not set
-# CONFIG_FB_BFIN_BGR is not set
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
 
@@ -1280,12 +1294,11 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
+# CONFIG_DEBUG_SERIAL_EARLY_INIT is not set
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 # CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
-# CONFIG_BOOTPARAM is not set
-# CONFIG_NO_KERNEL_MSG is not set
 CONFIG_CPLB_INFO=y
-# CONFIG_NO_ACCESS_CHECK is not set
+CONFIG_ACCESS_CHECK=y
 
 #
 # Security options
-- 
1.5.1.2
