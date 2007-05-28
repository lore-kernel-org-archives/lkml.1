Return-Path: <linux-kernel-owner+w=401wt.eu-S932341AbXE1ImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341AbXE1ImI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761522AbXE1Igy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:7605 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759458AbXE1Igf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:35 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="31069467:sNHT36010387"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 11/20] Blackfin arch: update defconfigs
Date: Mon, 28 May 2007 16:37:46 +0800
Message-Id: <1180341479617-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11803414753217-git-send-email-bryan.wu@analog.com>
References: <11803414753217-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/configs/BF533-EZKIT_defconfig |  241 +++++++++++++++++++++------
 arch/blackfin/configs/BF533-STAMP_defconfig |   92 +++++++----
 arch/blackfin/configs/BF537-STAMP_defconfig |   98 +++++++----
 arch/blackfin/configs/BF561-EZKIT_defconfig |  192 ++++++++++++++++------
 arch/blackfin/configs/PNAV-10_defconfig     |  119 ++++++++-----
 5 files changed, 528 insertions(+), 214 deletions(-)

diff --git a/arch/blackfin/configs/BF533-EZKIT_defconfig b/arch/blackfin/configs/BF533-EZKIT_defconfig
index 377c8e0..90d58aa 100644
--- a/arch/blackfin/configs/BF533-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF533-EZKIT_defconfig
@@ -1,20 +1,21 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.19.3
+# Linux kernel version: 2.6.21.3
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
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
@@ -33,13 +34,16 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -54,9 +58,7 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_EPOLL=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
 CONFIG_SLAB=y
@@ -80,7 +82,9 @@ CONFIG_KMOD=y
 # Block layer
 #
 CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
 
 #
 # IO Schedulers
@@ -109,7 +113,6 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF532 is not set
 CONFIG_BF533=y
 # CONFIG_BF534 is not set
-# CONFIG_BF535 is not set
 # CONFIG_BF536 is not set
 # CONFIG_BF537 is not set
 # CONFIG_BF561 is not set
@@ -125,6 +128,7 @@ CONFIG_BFIN533_EZKIT=y
 # CONFIG_BFIN537_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_EZKIT is not set
+# CONFIG_BFIN561_TEPLA is not set
 # CONFIG_PNAV10 is not set
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC16M16A2TG_75=y
@@ -168,6 +172,7 @@ CONFIG_WDTIMER=13
 #
 # Board customizations
 #
+# CONFIG_CMDLINE_BOOL is not set
 
 #
 # Board Setup
@@ -178,19 +183,6 @@ CONFIG_MEM_ADD_WIDTH=9
 CONFIG_BOOT_LOAD=0x1000
 
 #
-# Console UART Setup
-#
-# CONFIG_BAUD_9600 is not set
-# CONFIG_BAUD_19200 is not set
-# CONFIG_BAUD_38400 is not set
-CONFIG_BAUD_57600=y
-# CONFIG_BAUD_115200 is not set
-CONFIG_BAUD_NO_PARITY=y
-# CONFIG_BAUD_PARITY is not set
-CONFIG_BAUD_1_STOPBIT=y
-# CONFIG_BAUD_2_STOPBIT is not set
-
-#
 # Blackfin Kernel Optimizations
 #
 
@@ -199,6 +191,7 @@ CONFIG_BAUD_1_STOPBIT=y
 #
 # CONFIG_HZ_100 is not set
 CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
 
@@ -217,6 +210,7 @@ CONFIG_MEMSET_L1=y
 CONFIG_MEMCPY_L1=y
 CONFIG_SYS_BFIN_SPINLOCK_L1=y
 # CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
 # CONFIG_SYSCALL_TAB_L1 is not set
 # CONFIG_CPLB_SWITCH_TAB_L1 is not set
 CONFIG_RAMKERNEL=y
@@ -230,6 +224,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -302,7 +297,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 CONFIG_PM=y
-CONFIG_PM_LEGACY=y
+# CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
 CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
@@ -330,6 +325,7 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -356,6 +352,7 @@ CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_INET6_XFRM_TUNNEL is not set
 # CONFIG_INET6_TUNNEL is not set
@@ -399,7 +396,48 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
+CONFIG_IRDA=m
+
+#
+# IrDA protocols
+#
+CONFIG_IRLAN=m
+CONFIG_IRCOMM=m
+# CONFIG_IRDA_ULTRA is not set
+
+#
+# IrDA options
+#
+CONFIG_IRDA_CACHE_LAST_LSAP=y
+# CONFIG_IRDA_FAST_RR is not set
+# CONFIG_IRDA_DEBUG is not set
+
+#
+# Infrared-port device drivers
+#
+
+#
+# SIR device drivers
+#
+CONFIG_IRTTY_SIR=m
+
+#
+# Dongle support
+#
+# CONFIG_DONGLE is not set
+
+#
+# Old SIR device drivers
+#
+# CONFIG_IRPORT_SIR is not set
+
+#
+# Old Serial dongle support
+#
+
+#
+# FIR device drivers
+#
 # CONFIG_BT is not set
 # CONFIG_IEEE80211 is not set
 
@@ -434,6 +472,7 @@ CONFIG_MTD_PARTITIONS=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
@@ -489,6 +528,8 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 #
 # Self-contained MTD device drivers
 #
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
@@ -519,6 +560,7 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -530,14 +572,12 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -636,7 +676,26 @@ CONFIG_SMC91X=y
 #
 # Input device support
 #
-# CONFIG_INPUT is not set
+CONFIG_INPUT=m
+# CONFIG_INPUT_FF_MEMLESS is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+CONFIG_INPUT_EVDEV=m
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
 
 #
 # Hardware I/O ports
@@ -649,12 +708,14 @@ CONFIG_SMC91X=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF533_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BF5xx_TIMERS is not set
 # CONFIG_BF5xx_PPI is not set
-# CONFIG_BFIN_SPORT is not set
+CONFIG_BFIN_SPORT=y
 # CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_AD5304 is not set
+# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
@@ -691,16 +752,19 @@ CONFIG_UNIX98_PTYS=y
 #
 # Watchdog Cards
 #
-# CONFIG_WATCHDOG is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 CONFIG_BLACKFIN_DPMC=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
 # CONFIG_RAW_DRIVER is not set
 
 #
@@ -716,8 +780,19 @@ CONFIG_BLACKFIN_DPMC=y
 #
 # SPI support
 #
-# CONFIG_SPI is not set
-# CONFIG_SPI_MASTER is not set
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
 
 #
 # Dallas's 1-wire bus
@@ -731,10 +806,17 @@ CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
 # CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_PC87427 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
@@ -747,9 +829,8 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
-# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+# CONFIG_FB is not set
 
 #
 # Sound
@@ -757,6 +838,12 @@ CONFIG_FIRMWARE_EDID=y
 # CONFIG_SOUND is not set
 
 #
+# HID Devices
+#
+CONFIG_HID=m
+# CONFIG_HID_DEBUG is not set
+
+#
 # USB support
 #
 CONFIG_USB_ARCH_HAS_HCD=y
@@ -776,6 +863,7 @@ CONFIG_USB_ARCH_HAS_HCD=y
 #
 # MMC/SD Card support
 #
+# CONFIG_SPI_MMC is not set
 # CONFIG_MMC is not set
 
 #
@@ -821,8 +909,10 @@ CONFIG_RTC_INTF_DEV=y
 #
 # CONFIG_RTC_DRV_DS1553 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_RS5C348 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
 # CONFIG_RTC_DRV_TEST is not set
+# CONFIG_RTC_DRV_MAX6902 is not set
 # CONFIG_RTC_DRV_V3020 is not set
 CONFIG_RTC_DRV_BFIN=y
 
@@ -840,6 +930,14 @@ CONFIG_RTC_DRV_BFIN=y
 #
 
 #
+# Auxiliary Display support
+#
+
+#
+# Virtualization
+#
+
+#
 # PBX support
 #
 # CONFIG_PBX is not set
@@ -847,13 +945,9 @@ CONFIG_RTC_DRV_BFIN=y
 #
 # File systems
 #
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-# CONFIG_EXT2_FS_POSIX_ACL is not set
-# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 # CONFIG_EXT4DEV_FS is not set
-CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
@@ -862,7 +956,8 @@ CONFIG_FS_MBCACHE=y
 # CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
-# CONFIG_INOTIFY is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 # CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
@@ -913,7 +1008,6 @@ CONFIG_YAFFS_CHECKPOINT_RESERVED_BLOCKS=10
 # CONFIG_YAFFS_DISABLE_WIDE_TNODES is not set
 # CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED is not set
 CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
-# CONFIG_JFFS_FS is not set
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
@@ -945,7 +1039,8 @@ CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=m
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
+CONFIG_SMB_FS=m
+# CONFIG_SMB_NLS_DEFAULT is not set
 # CONFIG_CIFS is not set
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
@@ -961,7 +1056,51 @@ CONFIG_MSDOS_PARTITION=y
 #
 # Native Language Support
 #
-# CONFIG_NLS is not set
+CONFIG_NLS=m
+CONFIG_NLS_DEFAULT="iso8859-1"
+# CONFIG_NLS_CODEPAGE_437 is not set
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
+# CONFIG_NLS_ASCII is not set
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
+# CONFIG_NLS_UTF8 is not set
+
+#
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
 
 #
 # Profiling support
@@ -975,19 +1114,16 @@ CONFIG_MSDOS_PARTITION=y
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_UNWIND_INFO is not set
-# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_SERIAL_EARLY_INIT is not set
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 # CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
-# CONFIG_BOOTPARAM is not set
-# CONFIG_NO_KERNEL_MSG is not set
 CONFIG_CPLB_INFO=y
-# CONFIG_NO_ACCESS_CHECK is not set
+CONFIG_ACCESS_CHECK=y
 
 #
 # Security options
@@ -995,7 +1131,7 @@ CONFIG_CPLB_INFO=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=y
+CONFIG_SECURITY_CAPABILITIES=m
 
 #
 # Cryptographic options
@@ -1005,10 +1141,13 @@ CONFIG_SECURITY_CAPABILITIES=y
 #
 # Library routines
 #
-# CONFIG_CRC_CCITT is not set
+CONFIG_BITREVERSE=y
+CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
 CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
diff --git a/arch/blackfin/configs/BF533-STAMP_defconfig b/arch/blackfin/configs/BF533-STAMP_defconfig
index 14a948c..fee9189 100644
--- a/arch/blackfin/configs/BF533-STAMP_defconfig
+++ b/arch/blackfin/configs/BF533-STAMP_defconfig
@@ -1,12 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20.4
+# Linux kernel version: 2.6.21.3
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
 CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
@@ -33,6 +34,7 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
@@ -41,6 +43,7 @@ CONFIG_SYSVIPC=y
 # CONFIG_IKCONFIG is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -55,9 +58,7 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_EPOLL=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
 CONFIG_SLAB=y
@@ -127,6 +128,7 @@ CONFIG_BFIN533_STAMP=y
 # CONFIG_BFIN537_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_EZKIT is not set
+# CONFIG_BFIN561_TEPLA is not set
 # CONFIG_PNAV10 is not set
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC64M4A2FB_7E=y
@@ -193,19 +195,6 @@ CONFIG_BFIN_IDLE_LED_PORT=0xFFC00700
 CONFIG_BFIN_IDLE_LED_DPORT=0xFFC00730
 
 #
-# Console UART Setup
-#
-# CONFIG_BAUD_9600 is not set
-# CONFIG_BAUD_19200 is not set
-# CONFIG_BAUD_38400 is not set
-CONFIG_BAUD_57600=y
-# CONFIG_BAUD_115200 is not set
-CONFIG_BAUD_NO_PARITY=y
-# CONFIG_BAUD_PARITY is not set
-CONFIG_BAUD_1_STOPBIT=y
-# CONFIG_BAUD_2_STOPBIT is not set
-
-#
 # Blackfin Kernel Optimizations
 #
 
@@ -233,6 +222,7 @@ CONFIG_MEMSET_L1=y
 CONFIG_MEMCPY_L1=y
 CONFIG_SYS_BFIN_SPINLOCK_L1=y
 # CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
 # CONFIG_SYSCALL_TAB_L1 is not set
 # CONFIG_CPLB_SWITCH_TAB_L1 is not set
 CONFIG_RAMKERNEL=y
@@ -246,6 +236,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -318,7 +309,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 CONFIG_PM=y
-CONFIG_PM_LEGACY=y
+# CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
 CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
@@ -346,6 +337,7 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -580,6 +572,7 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -591,14 +584,12 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -733,7 +724,7 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=39
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF533_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BF5xx_TIMERS is not set
 # CONFIG_BF5xx_PPI is not set
@@ -742,6 +733,8 @@ CONFIG_BFIN_SPORT=y
 CONFIG_TWI_LCD=m
 CONFIG_TWI_LCD_SLAVE_ADDR=34
 # CONFIG_AD5304 is not set
+# CONFIG_BF5xx_TEA5764 is not set
+# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
@@ -778,7 +771,14 @@ CONFIG_UNIX98_PTYS=y
 #
 # Watchdog Cards
 #
-# CONFIG_WATCHDOG is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 CONFIG_BLACKFIN_DPMC=y
@@ -840,12 +840,13 @@ CONFIG_SPI_MASTER=y
 #
 # SPI Master Controller Drivers
 #
+CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BITBANG is not set
 
 #
 # SPI Protocol Masters
 #
-CONFIG_SPI_BFIN=y
+# CONFIG_SPI_AT25 is not set
 
 #
 # Dallas's 1-wire bus
@@ -861,6 +862,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
 # CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
 # CONFIG_SENSORS_ASB100 is not set
@@ -900,6 +902,11 @@ CONFIG_HWMON=y
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
@@ -912,15 +919,22 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 CONFIG_FB=m
+CONFIG_FIRMWARE_EDID=y
+# CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=m
 CONFIG_FB_CFB_COPYAREA=m
 CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_SVGALIB is not set
 # CONFIG_FB_MACMODES is not set
 # CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
 CONFIG_FB_BFIN_7171=m
 CONFIG_FB_BFIN_7393=m
 CONFIG_NTSC=y
@@ -938,7 +952,6 @@ CONFIG_ADV7393_1XMEM=y
 # Logo configuration
 #
 # CONFIG_LOGO is not set
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
@@ -971,6 +984,18 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_MPU401 is not set
 
 #
+# ALSA Blackfin devices
+#
+# CONFIG_SND_BLACKFIN_AD1836 is not set
+# CONFIG_SND_BLACKFIN_AD1981B is not set
+# CONFIG_SND_BFIN_AD73311 is not set
+
+#
+# SoC audio support
+#
+# CONFIG_SND_SOC is not set
+
+#
 # Open Sound System
 #
 # CONFIG_SOUND_PRIME is not set
@@ -979,6 +1004,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # HID Devices
 #
 CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
 
 #
 # USB support
@@ -1051,7 +1077,6 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
-# CONFIG_RTC_DRV_PCF8583 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
@@ -1074,6 +1099,10 @@ CONFIG_RTC_DRV_BFIN=y
 #
 
 #
+# Auxiliary Display support
+#
+
+#
 # Virtualization
 #
 
@@ -1085,13 +1114,9 @@ CONFIG_RTC_DRV_BFIN=y
 #
 # File systems
 #
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-# CONFIG_EXT2_FS_POSIX_ACL is not set
-# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 # CONFIG_EXT4DEV_FS is not set
-CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
@@ -1103,7 +1128,7 @@ CONFIG_FS_MBCACHE=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
+# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -1275,7 +1300,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=y
+CONFIG_SECURITY_CAPABILITIES=m
 
 #
 # Cryptographic options
@@ -1293,4 +1318,5 @@ CONFIG_CRC32=y
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
 CONFIG_PLIST=y
-CONFIG_IOMAP_COPY=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
diff --git a/arch/blackfin/configs/BF537-STAMP_defconfig b/arch/blackfin/configs/BF537-STAMP_defconfig
index 8ed67dc..37688bb 100644
--- a/arch/blackfin/configs/BF537-STAMP_defconfig
+++ b/arch/blackfin/configs/BF537-STAMP_defconfig
@@ -1,12 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20.4
+# Linux kernel version: 2.6.21.3
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
 CONFIG_BFIN=y
 CONFIG_SEMAPHORE_SLEEPERS=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
@@ -33,6 +34,7 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
@@ -41,6 +43,7 @@ CONFIG_SYSVIPC=y
 # CONFIG_IKCONFIG is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
@@ -55,9 +58,7 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_EPOLL=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
 CONFIG_SLAB=y
@@ -127,6 +128,7 @@ CONFIG_BFIN537_STAMP=y
 # CONFIG_BFIN537_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_EZKIT is not set
+# CONFIG_BFIN561_TEPLA is not set
 # CONFIG_PNAV10 is not set
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC32M8A2_75=y
@@ -196,19 +198,6 @@ CONFIG_MEM_ADD_WIDTH=10
 CONFIG_BOOT_LOAD=0x1000
 
 #
-# Console UART Setup
-#
-# CONFIG_BAUD_9600 is not set
-# CONFIG_BAUD_19200 is not set
-# CONFIG_BAUD_38400 is not set
-CONFIG_BAUD_57600=y
-# CONFIG_BAUD_115200 is not set
-CONFIG_BAUD_NO_PARITY=y
-# CONFIG_BAUD_PARITY is not set
-CONFIG_BAUD_1_STOPBIT=y
-# CONFIG_BAUD_2_STOPBIT is not set
-
-#
 # Blackfin Kernel Optimizations
 #
 
@@ -236,6 +225,7 @@ CONFIG_MEMSET_L1=y
 CONFIG_MEMCPY_L1=y
 CONFIG_SYS_BFIN_SPINLOCK_L1=y
 # CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
 # CONFIG_SYSCALL_TAB_L1 is not set
 # CONFIG_CPLB_SWITCH_TAB_L1 is not set
 CONFIG_RAMKERNEL=y
@@ -249,6 +239,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -321,7 +312,7 @@ CONFIG_BINFMT_ZFLAT=y
 # Power management options
 #
 CONFIG_PM=y
-CONFIG_PM_LEGACY=y
+# CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
 CONFIG_PM_WAKEUP_GPIO_BY_SIC_IWR=y
@@ -349,6 +340,7 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -593,6 +585,7 @@ CONFIG_MTD_NAND_IDS=m
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -604,14 +597,12 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -751,7 +742,7 @@ CONFIG_BFIN_TWIKEYPAD_IRQ_PFX=72
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF533_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BF5xx_TIMERS is not set
 # CONFIG_BF5xx_PPI is not set
@@ -760,6 +751,8 @@ CONFIG_BFIN_SPORT=y
 CONFIG_TWI_LCD=m
 CONFIG_TWI_LCD_SLAVE_ADDR=34
 # CONFIG_AD5304 is not set
+# CONFIG_BF5xx_TEA5764 is not set
+# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
@@ -804,7 +797,14 @@ CONFIG_CAN_BLACKFIN=m
 #
 # Watchdog Cards
 #
-# CONFIG_WATCHDOG is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 CONFIG_BLACKFIN_DPMC=y
@@ -868,12 +868,13 @@ CONFIG_SPI_MASTER=y
 #
 # SPI Master Controller Drivers
 #
+CONFIG_SPI_BFIN=y
 # CONFIG_SPI_BITBANG is not set
 
 #
 # SPI Protocol Masters
 #
-CONFIG_SPI_BFIN=y
+# CONFIG_SPI_AT25 is not set
 
 #
 # Dallas's 1-wire bus
@@ -889,6 +890,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
 # CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
 # CONFIG_SENSORS_ASB100 is not set
@@ -928,6 +930,11 @@ CONFIG_HWMON=y
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
@@ -940,15 +947,24 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=m
+CONFIG_LCD_CLASS_DEVICE=m
 CONFIG_FB=m
+CONFIG_FIRMWARE_EDID=y
+# CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=m
 CONFIG_FB_CFB_COPYAREA=m
 CONFIG_FB_CFB_IMAGEBLIT=m
+# CONFIG_FB_SVGALIB is not set
 # CONFIG_FB_MACMODES is not set
 # CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
 CONFIG_FB_BFIN_7171=m
 CONFIG_FB_BFIN_7393=m
 CONFIG_NTSC=y
@@ -970,11 +986,6 @@ CONFIG_LQ035_SLAVE_ADDR=0x58
 # Logo configuration
 #
 # CONFIG_LOGO is not set
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
-CONFIG_BACKLIGHT_CLASS_DEVICE=m
-CONFIG_BACKLIGHT_DEVICE=y
-CONFIG_LCD_CLASS_DEVICE=m
-CONFIG_LCD_DEVICE=y
 
 #
 # Sound
@@ -1007,6 +1018,18 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # CONFIG_SND_MPU401 is not set
 
 #
+# ALSA Blackfin devices
+#
+# CONFIG_SND_BLACKFIN_AD1836 is not set
+# CONFIG_SND_BLACKFIN_AD1981B is not set
+# CONFIG_SND_BFIN_AD73311 is not set
+
+#
+# SoC audio support
+#
+# CONFIG_SND_SOC is not set
+
+#
 # Open Sound System
 #
 # CONFIG_SOUND_PRIME is not set
@@ -1015,6 +1038,7 @@ CONFIG_SND_VERBOSE_PROCFS=y
 # HID Devices
 #
 CONFIG_HID=y
+# CONFIG_HID_DEBUG is not set
 
 #
 # USB support
@@ -1087,7 +1111,6 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
-# CONFIG_RTC_DRV_PCF8583 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
@@ -1110,6 +1133,10 @@ CONFIG_RTC_DRV_BFIN=y
 #
 
 #
+# Auxiliary Display support
+#
+
+#
 # Virtualization
 #
 
@@ -1121,13 +1148,9 @@ CONFIG_RTC_DRV_BFIN=y
 #
 # File systems
 #
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-# CONFIG_EXT2_FS_POSIX_ACL is not set
-# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 # CONFIG_EXT4DEV_FS is not set
-CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
@@ -1139,7 +1162,7 @@ CONFIG_FS_MBCACHE=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
+# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -1311,7 +1334,7 @@ CONFIG_ACCESS_CHECK=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=y
+CONFIG_SECURITY_CAPABILITIES=m
 
 #
 # Cryptographic options
@@ -1329,4 +1352,5 @@ CONFIG_CRC32=y
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
 CONFIG_PLIST=y
-CONFIG_IOMAP_COPY=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
diff --git a/arch/blackfin/configs/BF561-EZKIT_defconfig b/arch/blackfin/configs/BF561-EZKIT_defconfig
index e32ca20..fe4e67d 100644
--- a/arch/blackfin/configs/BF561-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF561-EZKIT_defconfig
@@ -1,20 +1,21 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.19.3
+# Linux kernel version: 2.6.21.3
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
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
@@ -33,18 +34,21 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
-# CONFIG_UID16 is not set
+CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
@@ -54,9 +58,7 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_EPOLL=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=3
-# CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
 CONFIG_SLAB=y
@@ -80,7 +82,9 @@ CONFIG_KMOD=y
 # Block layer
 #
 CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
 
 #
 # IO Schedulers
@@ -109,7 +113,6 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
 # CONFIG_BF534 is not set
-# CONFIG_BF535 is not set
 # CONFIG_BF536 is not set
 # CONFIG_BF537 is not set
 CONFIG_BF561=y
@@ -125,6 +128,7 @@ CONFIG_BFIN_DUAL_CORE=y
 # CONFIG_BFIN537_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
 CONFIG_BFIN561_EZKIT=y
+# CONFIG_BFIN561_TEPLA is not set
 # CONFIG_PNAV10 is not set
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC16M16A2TG_75=y
@@ -214,6 +218,7 @@ CONFIG_IRQ_WDTIMER=13
 #
 # Board customizations
 #
+# CONFIG_CMDLINE_BOOL is not set
 
 #
 # Board Setup
@@ -224,19 +229,6 @@ CONFIG_MEM_ADD_WIDTH=9
 CONFIG_BOOT_LOAD=0x1000
 
 #
-# Console UART Setup
-#
-# CONFIG_BAUD_9600 is not set
-# CONFIG_BAUD_19200 is not set
-# CONFIG_BAUD_38400 is not set
-CONFIG_BAUD_57600=y
-# CONFIG_BAUD_115200 is not set
-CONFIG_BAUD_NO_PARITY=y
-# CONFIG_BAUD_PARITY is not set
-CONFIG_BAUD_1_STOPBIT=y
-# CONFIG_BAUD_2_STOPBIT is not set
-
-#
 # Blackfin Kernel Optimizations
 #
 
@@ -245,6 +237,7 @@ CONFIG_BAUD_1_STOPBIT=y
 #
 # CONFIG_HZ_100 is not set
 CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
 
@@ -263,6 +256,7 @@ CONFIG_MEMSET_L1=y
 CONFIG_MEMCPY_L1=y
 CONFIG_SYS_BFIN_SPINLOCK_L1=y
 # CONFIG_IP_CHECKSUM_L1 is not set
+CONFIG_CACHELINE_ALIGNED_L1=y
 # CONFIG_SYSCALL_TAB_L1 is not set
 # CONFIG_CPLB_SWITCH_TAB_L1 is not set
 CONFIG_RAMKERNEL=y
@@ -276,6 +270,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -368,6 +363,7 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -394,6 +390,7 @@ CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_INET6_XFRM_TUNNEL is not set
 # CONFIG_INET6_TUNNEL is not set
@@ -437,7 +434,48 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
+CONFIG_IRDA=m
+
+#
+# IrDA protocols
+#
+CONFIG_IRLAN=m
+CONFIG_IRCOMM=m
+# CONFIG_IRDA_ULTRA is not set
+
+#
+# IrDA options
+#
+CONFIG_IRDA_CACHE_LAST_LSAP=y
+# CONFIG_IRDA_FAST_RR is not set
+# CONFIG_IRDA_DEBUG is not set
+
+#
+# Infrared-port device drivers
+#
+
+#
+# SIR device drivers
+#
+CONFIG_IRTTY_SIR=m
+
+#
+# Dongle support
+#
+# CONFIG_DONGLE is not set
+
+#
+# Old SIR device drivers
+#
+# CONFIG_IRPORT_SIR is not set
+
+#
+# Old Serial dongle support
+#
+
+#
+# FIR device drivers
+#
 # CONFIG_BT is not set
 # CONFIG_IEEE80211 is not set
 
@@ -472,6 +510,7 @@ CONFIG_MTD_PARTITIONS=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
@@ -528,6 +567,8 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 #
 # Self-contained MTD device drivers
 #
+# CONFIG_MTD_DATAFLASH is not set
+# CONFIG_MTD_M25P80 is not set
 # CONFIG_MTD_SLRAM is not set
 # CONFIG_MTD_PHRAM is not set
 # CONFIG_MTD_MTDRAM is not set
@@ -558,6 +599,7 @@ CONFIG_BFIN_FLASH_BANK_3=0x7BB0
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -569,14 +611,12 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -675,7 +715,26 @@ CONFIG_SMC91X=y
 #
 # Input device support
 #
-# CONFIG_INPUT is not set
+CONFIG_INPUT=m
+# CONFIG_INPUT_FF_MEMLESS is not set
+
+#
+# Userland interfaces
+#
+# CONFIG_INPUT_MOUSEDEV is not set
+# CONFIG_INPUT_JOYDEV is not set
+# CONFIG_INPUT_TSDEV is not set
+CONFIG_INPUT_EVDEV=m
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+# CONFIG_INPUT_MOUSE is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+# CONFIG_INPUT_MISC is not set
 
 #
 # Hardware I/O ports
@@ -688,12 +747,14 @@ CONFIG_SMC91X=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF533_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BF5xx_TIMERS is not set
 # CONFIG_BF5xx_PPI is not set
 # CONFIG_BFIN_SPORT is not set
 # CONFIG_BFIN_TIMER_LATENCY is not set
+# CONFIG_AD5304 is not set
+# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
@@ -730,16 +791,19 @@ CONFIG_UNIX98_PTYS=y
 #
 # Watchdog Cards
 #
-# CONFIG_WATCHDOG is not set
+CONFIG_WATCHDOG=y
+# CONFIG_WATCHDOG_NOWAYOUT is not set
+
+#
+# Watchdog Device Drivers
+#
+# CONFIG_SOFT_WATCHDOG is not set
+CONFIG_BFIN_WDT=y
 CONFIG_HW_RANDOM=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_BLACKFIN_DPMC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
 # CONFIG_RAW_DRIVER is not set
 
 #
@@ -755,8 +819,19 @@ CONFIG_HW_RANDOM=y
 #
 # SPI support
 #
-# CONFIG_SPI is not set
-# CONFIG_SPI_MASTER is not set
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
 
 #
 # Dallas's 1-wire bus
@@ -770,10 +845,17 @@ CONFIG_HWMON=y
 # CONFIG_HWMON_VID is not set
 # CONFIG_SENSORS_ABITUGURU is not set
 # CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_LM70 is not set
+# CONFIG_SENSORS_PC87427 is not set
 # CONFIG_SENSORS_VT1211 is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
@@ -786,9 +868,8 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
-# CONFIG_FB is not set
 # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+# CONFIG_FB is not set
 
 #
 # Sound
@@ -796,6 +877,12 @@ CONFIG_FIRMWARE_EDID=y
 # CONFIG_SOUND is not set
 
 #
+# HID Devices
+#
+CONFIG_HID=m
+# CONFIG_HID_DEBUG is not set
+
+#
 # USB support
 #
 CONFIG_USB_ARCH_HAS_HCD=y
@@ -815,6 +902,7 @@ CONFIG_USB_ARCH_HAS_HCD=y
 #
 # MMC/SD Card support
 #
+# CONFIG_SPI_MMC is not set
 # CONFIG_MMC is not set
 
 #
@@ -857,6 +945,14 @@ CONFIG_USB_ARCH_HAS_HCD=y
 #
 
 #
+# Auxiliary Display support
+#
+
+#
+# Virtualization
+#
+
+#
 # PBX support
 #
 # CONFIG_PBX is not set
@@ -864,13 +960,9 @@ CONFIG_USB_ARCH_HAS_HCD=y
 #
 # File systems
 #
-CONFIG_EXT2_FS=y
-CONFIG_EXT2_FS_XATTR=y
-# CONFIG_EXT2_FS_POSIX_ACL is not set
-# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
 # CONFIG_EXT4DEV_FS is not set
-CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
@@ -882,7 +974,7 @@ CONFIG_FS_MBCACHE=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
+# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -931,7 +1023,6 @@ CONFIG_YAFFS_CHECKPOINT_RESERVED_BLOCKS=10
 # CONFIG_YAFFS_DISABLE_WIDE_TNODES is not set
 # CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED is not set
 CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
-# CONFIG_JFFS_FS is not set
 CONFIG_JFFS2_FS=m
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
@@ -1022,6 +1113,11 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_UTF8 is not set
 
 #
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
 # Profiling support
 #
 # CONFIG_PROFILING is not set
@@ -1033,20 +1129,17 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_UNWIND_INFO is not set
-# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_SERIAL_EARLY_INIT is not set
 CONFIG_DEBUG_HUNT_FOR_ZERO=y
 # CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
 # CONFIG_DUAL_CORE_TEST_MODULE is not set
-# CONFIG_BOOTPARAM is not set
-# CONFIG_NO_KERNEL_MSG is not set
 CONFIG_CPLB_INFO=y
-# CONFIG_NO_ACCESS_CHECK is not set
+CONFIG_ACCESS_CHECK=y
 
 #
 # Security options
@@ -1054,7 +1147,7 @@ CONFIG_CPLB_INFO=y
 # CONFIG_KEYS is not set
 CONFIG_SECURITY=y
 # CONFIG_SECURITY_NETWORK is not set
-CONFIG_SECURITY_CAPABILITIES=y
+CONFIG_SECURITY_CAPABILITIES=m
 
 #
 # Cryptographic options
@@ -1064,10 +1157,13 @@ CONFIG_SECURITY_CAPABILITIES=y
 #
 # Library routines
 #
-# CONFIG_CRC_CCITT is not set
+CONFIG_BITREVERSE=y
+CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
 CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 97b4ffa..a783ff6 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -1,20 +1,21 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.19.3
+# Linux kernel version: 2.6.21.3
 #
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
 CONFIG_BLACKFIN=y
+CONFIG_ZONE_DMA=y
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
@@ -33,14 +34,16 @@ CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
 # CONFIG_UTS_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
-CONFIG_INITRAMFS_SOURCE=""
+# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
 CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
@@ -54,9 +57,7 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
-CONFIG_EPOLL=y
 CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC=9
-# CONFIG_LIMIT_PAGECACHE is not set
 CONFIG_BUDDY=y
 # CONFIG_NP2 is not set
 CONFIG_SLAB=y
@@ -80,7 +81,9 @@ CONFIG_KMOD=y
 # Block layer
 #
 CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
 
 #
 # IO Schedulers
@@ -109,7 +112,6 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_BF532 is not set
 # CONFIG_BF533 is not set
 # CONFIG_BF534 is not set
-# CONFIG_BF535 is not set
 # CONFIG_BF536 is not set
 CONFIG_BF537=y
 # CONFIG_BF561 is not set
@@ -125,6 +127,7 @@ CONFIG_BFIN_SINGLE_CORE=y
 # CONFIG_BFIN537_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_BLUETECHNIX_CM is not set
 # CONFIG_BFIN561_EZKIT is not set
+# CONFIG_BFIN561_TEPLA is not set
 CONFIG_PNAV10=y
 # CONFIG_GENERIC_BOARD is not set
 CONFIG_MEM_MT48LC32M8A2_75=y
@@ -183,6 +186,7 @@ CONFIG_IRQ_WATCH=13
 #
 # Board customizations
 #
+# CONFIG_CMDLINE_BOOL is not set
 
 #
 # Board Setup
@@ -193,19 +197,6 @@ CONFIG_MEM_ADD_WIDTH=10
 CONFIG_BOOT_LOAD=0x1000
 
 #
-# Console UART Setup
-#
-# CONFIG_BAUD_9600 is not set
-# CONFIG_BAUD_19200 is not set
-# CONFIG_BAUD_38400 is not set
-# CONFIG_BAUD_57600 is not set
-CONFIG_BAUD_115200=y
-CONFIG_BAUD_NO_PARITY=y
-# CONFIG_BAUD_PARITY is not set
-CONFIG_BAUD_1_STOPBIT=y
-# CONFIG_BAUD_2_STOPBIT is not set
-
-#
 # Blackfin Kernel Optimizations
 #
 
@@ -214,6 +205,7 @@ CONFIG_BAUD_1_STOPBIT=y
 #
 # CONFIG_HZ_100 is not set
 CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
 
@@ -232,6 +224,7 @@ CONFIG_MEMSET_L1=y
 CONFIG_MEMCPY_L1=y
 CONFIG_SYS_BFIN_SPINLOCK_L1=y
 CONFIG_IP_CHECKSUM_L1=y
+CONFIG_CACHELINE_ALIGNED_L1=y
 CONFIG_SYSCALL_TAB_L1=y
 CONFIG_CPLB_SWITCH_TAB_L1=y
 CONFIG_RAMKERNEL=y
@@ -245,6 +238,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_LARGE_ALLOCS=y
 CONFIG_BFIN_DMA_5XX=y
 # CONFIG_DMA_UNCACHED_2M is not set
@@ -338,6 +332,7 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 # CONFIG_NET_KEY is not set
 CONFIG_INET=y
 # CONFIG_IP_MULTICAST is not set
@@ -364,6 +359,7 @@ CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_INET6_XFRM_TUNNEL is not set
 # CONFIG_INET6_TUNNEL is not set
@@ -442,6 +438,7 @@ CONFIG_MTD_PARTITIONS=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=m
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
@@ -522,6 +519,7 @@ CONFIG_MTD_NAND_IDS=y
 #
 # Plug and Play support
 #
+# CONFIG_PNPACPI is not set
 
 #
 # Block devices
@@ -533,14 +531,12 @@ CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
 CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
 #
 # Misc devices
 #
-# CONFIG_TIFM_CORE is not set
 
 #
 # ATA/ATAPI/MFM/RLL support
@@ -674,6 +670,7 @@ CONFIG_TOUCHSCREEN_AD7877=y
 # CONFIG_TOUCHSCREEN_PENMOUNT is not set
 # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
 # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
+# CONFIG_TOUCHSCREEN_UCB1400 is not set
 CONFIG_INPUT_MISC=y
 CONFIG_INPUT_UINPUT=y
 # CONFIG_BF53X_PFBUTTONS is not set
@@ -690,7 +687,7 @@ CONFIG_INPUT_UINPUT=y
 #
 # CONFIG_AD9960 is not set
 # CONFIG_SPI_ADC_BF533 is not set
-# CONFIG_BF533_PFLAGS is not set
+# CONFIG_BF5xx_PFLAGS is not set
 # CONFIG_BF5xx_PPIFCD is not set
 # CONFIG_BF5xx_TIMERS is not set
 # CONFIG_BF5xx_PPI is not set
@@ -699,6 +696,8 @@ CONFIG_BFIN_SPORT=y
 CONFIG_TWI_LCD=m
 CONFIG_TWI_LCD_SLAVE_ADDR=34
 # CONFIG_AD5304 is not set
+# CONFIG_BF5xx_TEA5764 is not set
+# CONFIG_BF5xx_FBDMA is not set
 # CONFIG_VT is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
@@ -750,10 +749,6 @@ CONFIG_HW_RANDOM=y
 CONFIG_BLACKFIN_DPMC=y
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
 # CONFIG_RAW_DRIVER is not set
 
 #
@@ -777,9 +772,9 @@ CONFIG_I2C_CHARDEV=y
 #
 # I2C Hardware Bus support
 #
-# CONFIG_I2C_BFIN_GPIO is not set
-CONFIG_I2C_BFIN_TWI=y
-CONFIG_TWICLK_KHZ=50
+# CONFIG_I2C_BLACKFIN_GPIO is not set
+CONFIG_I2C_BLACKFIN_TWI=y
+CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ=50
 # CONFIG_I2C_OCORES is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_STUB is not set
@@ -812,12 +807,13 @@ CONFIG_SPI_MASTER=y
 #
 # SPI Master Controller Drivers
 #
-# CONFIG_SPI_BITBANG is not set
 CONFIG_SPI_BFIN=y
+# CONFIG_SPI_BITBANG is not set
 
 #
 # SPI Protocol Masters
 #
+# CONFIG_SPI_AT25 is not set
 
 #
 # Dallas's 1-wire bus
@@ -833,6 +829,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_ADM1021 is not set
 # CONFIG_SENSORS_ADM1025 is not set
 # CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
 # CONFIG_SENSORS_ADM1031 is not set
 # CONFIG_SENSORS_ADM9240 is not set
 # CONFIG_SENSORS_ASB100 is not set
@@ -857,6 +854,7 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_LM92 is not set
 # CONFIG_SENSORS_MAX1619 is not set
 # CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
 # CONFIG_SENSORS_SMSC47M1 is not set
 # CONFIG_SENSORS_SMSC47M192 is not set
 # CONFIG_SENSORS_SMSC47B397 is not set
@@ -864,12 +862,18 @@ CONFIG_HWMON=y
 # CONFIG_SENSORS_W83781D is not set
 # CONFIG_SENSORS_W83791D is not set
 # CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
 # CONFIG_SENSORS_W83L785TS is not set
 # CONFIG_SENSORS_W83627HF is not set
 # CONFIG_SENSORS_W83627EHF is not set
 # CONFIG_HWMON_DEBUG_CHIP is not set
 
 #
+# Multifunction device drivers
+#
+# CONFIG_MFD_SM501 is not set
+
+#
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
@@ -882,15 +886,24 @@ CONFIG_HWMON=y
 #
 # Graphics support
 #
-CONFIG_FIRMWARE_EDID=y
+CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_BACKLIGHT_CLASS_DEVICE=y
+CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_FB=y
+CONFIG_FIRMWARE_EDID=y
+# CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_SVGALIB is not set
 # CONFIG_FB_MACMODES is not set
 # CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
 # CONFIG_FB_BFIN_7171 is not set
 # CONFIG_FB_BFIN_7393 is not set
 CONFIG_FB_BF537_LQ035=y
@@ -904,11 +917,6 @@ CONFIG_FB_BFIN_LANDSCAPE=y
 # Logo configuration
 #
 # CONFIG_LOGO is not set
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
-CONFIG_BACKLIGHT_CLASS_DEVICE=y
-CONFIG_BACKLIGHT_DEVICE=y
-CONFIG_LCD_CLASS_DEVICE=y
-CONFIG_LCD_DEVICE=y
 
 #
 # Sound
@@ -946,14 +954,24 @@ CONFIG_SND_BLACKFIN_AD1981B=m
 # CONFIG_SND_BFIN_AD73311 is not set
 
 #
+# SoC audio support
+#
+# CONFIG_SND_SOC is not set
+
+#
 # Open Sound System
 #
 CONFIG_SOUND_PRIME=y
-CONFIG_OSS_OBSOLETE_DRIVER=y
+# CONFIG_OBSOLETE_OSS is not set
 # CONFIG_SOUND_MSNDCLAS is not set
 # CONFIG_SOUND_MSNDPIN is not set
 
 #
+# HID Devices
+#
+# CONFIG_HID is not set
+
+#
 # USB support
 #
 CONFIG_USB_ARCH_HAS_HCD=y
@@ -1024,7 +1042,6 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_DS1672 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_PCF8563 is not set
-# CONFIG_RTC_DRV_PCF8583 is not set
 # CONFIG_RTC_DRV_RS5C348 is not set
 # CONFIG_RTC_DRV_RS5C372 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
@@ -1047,6 +1064,14 @@ CONFIG_RTC_DRV_BFIN=y
 #
 
 #
+# Auxiliary Display support
+#
+
+#
+# Virtualization
+#
+
+#
 # PBX support
 #
 # CONFIG_PBX is not set
@@ -1121,7 +1146,6 @@ CONFIG_YAFFS_CHECKPOINT_RESERVED_BLOCKS=10
 # CONFIG_YAFFS_DISABLE_WIDE_TNODES is not set
 # CONFIG_YAFFS_ALWAYS_CHECK_CHUNK_ERASED is not set
 CONFIG_YAFFS_SHORT_NAMES_IN_RAM=y
-# CONFIG_JFFS_FS is not set
 # CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
@@ -1204,6 +1228,11 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 # CONFIG_NLS_UTF8 is not set
 
 #
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
 # Profiling support
 #
 # CONFIG_PROFILING is not set
@@ -1215,19 +1244,16 @@ CONFIG_NLS_DEFAULT="iso8859-1"
 CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_MAGIC_SYSRQ is not set
 # CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_UNWIND_INFO is not set
-# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_SERIAL_EARLY_INIT is not set
 # CONFIG_DEBUG_HUNT_FOR_ZERO is not set
 # CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE is not set
-# CONFIG_BOOTPARAM is not set
-# CONFIG_NO_KERNEL_MSG is not set
 # CONFIG_CPLB_INFO is not set
-# CONFIG_NO_ACCESS_CHECK is not set
+# CONFIG_ACCESS_CHECK is not set
 
 #
 # Security options
@@ -1245,9 +1271,12 @@ CONFIG_SECURITY_CAPABILITIES=y
 #
 # Library routines
 #
+CONFIG_BITREVERSE=y
 CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 CONFIG_CRC32=y
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
-- 
1.5.2
