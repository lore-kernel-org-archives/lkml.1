Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbZHOLgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbZHOLgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 07:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbZHOLgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 07:36:17 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:33520 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbZHOLgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 07:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=e9jqFUg+K10nTzqrrUBM/yQcLgNHfuj8XDpdmWS8IHUj6b+J7sVsM1YO2ZFSfeR6Wg
         vV/wGsIJP5om5nmaWDEQNqSoK6KDvKdtzaVDuSKWVlVtOvpIQAPrLn8lzhc5akIfw57W
         aKiyHszTJjvLgqlJsyabEJ7rW/Bo816KFyZSI=
Message-ID: <4A869DAA.1040400@gmail.com>
Date: Sat, 15 Aug 2009 19:36:10 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 8/9] ARM: update w90p910_defconfig for w90p910 platform
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Russell,

update w90p910_defconfig for w90p910 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 arch/arm/configs/w90p910_defconfig |  112 +++++++++++++++---------------------
 1 files changed, 47 insertions(+), 65 deletions(-)

diff --git a/arch/arm/configs/w90p910_defconfig b/arch/arm/configs/w90p910_defconfig
index 5245655..f82c082 100644
--- a/arch/arm/configs/w90p910_defconfig
+++ b/arch/arm/configs/w90p910_defconfig
@@ -1,15 +1,14 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.30
-# Wed Jun 10 22:09:25 2009
+# Linux kernel version: 2.6.31-rc5
+# Sat Aug 15 17:12:57 2009
 #
 CONFIG_ARM=y
 CONFIG_SYS_SUPPORTS_APM_EMULATION=y
 CONFIG_GENERIC_GPIO=y
-# CONFIG_GENERIC_TIME is not set
-# CONFIG_GENERIC_CLOCKEVENTS is not set
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_MMU=y
-# CONFIG_NO_IOPORT is not set
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_HAVE_LATENCYTOP_SUPPORT=y
@@ -18,13 +17,12 @@ CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_HARDIRQS_SW_RESEND=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
 CONFIG_VECTORS_BASE=0xffff0000
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
 
 #
 # General setup
@@ -66,10 +64,6 @@ CONFIG_INITRAMFS_SOURCE=""
 CONFIG_RD_GZIP=y
 CONFIG_RD_BZIP2=y
 CONFIG_RD_LZMA=y
-# CONFIG_INITRAMFS_COMPRESSION_NONE is not set
-# CONFIG_INITRAMFS_COMPRESSION_GZIP is not set
-# CONFIG_INITRAMFS_COMPRESSION_BZIP2 is not set
-# CONFIG_INITRAMFS_COMPRESSION_LZMA is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
@@ -78,7 +72,6 @@ CONFIG_UID16=y
 CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
-# CONFIG_STRIP_ASM_SYMS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
@@ -91,17 +84,27 @@ CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_AIO=y
+
+#
+# Performance Counters
+#
 CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_STRIP_ASM_SYMS is not set
 CONFIG_COMPAT_BRK=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 # CONFIG_PROFILING is not set
-CONFIG_TRACEPOINTS=y
 # CONFIG_MARKERS is not set
 CONFIG_HAVE_OPROFILE=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_CLK=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_GCOV_KERNEL is not set
 # CONFIG_SLOW_WORK is not set
 CONFIG_HAVE_GENERIC_DMA_COHERENT=y
 CONFIG_SLABINFO=y
@@ -109,7 +112,7 @@ CONFIG_RT_MUTEXES=y
 CONFIG_BASE_SMALL=0
 # CONFIG_MODULES is not set
 CONFIG_BLOCK=y
-CONFIG_LBD=y
+CONFIG_LBDAF=y
 CONFIG_BLK_DEV_BSG=y
 # CONFIG_BLK_DEV_INTEGRITY is not set
 
@@ -136,13 +139,14 @@ CONFIG_DEFAULT_IOSCHED="cfq"
 # CONFIG_ARCH_VERSATILE is not set
 # CONFIG_ARCH_AT91 is not set
 # CONFIG_ARCH_CLPS711X is not set
+# CONFIG_ARCH_GEMINI is not set
 # CONFIG_ARCH_EBSA110 is not set
 # CONFIG_ARCH_EP93XX is not set
-# CONFIG_ARCH_GEMINI is not set
 # CONFIG_ARCH_FOOTBRIDGE is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_STMP3XXX is not set
 # CONFIG_ARCH_NETX is not set
 # CONFIG_ARCH_H720X is not set
-# CONFIG_ARCH_IMX is not set
 # CONFIG_ARCH_IOP13XX is not set
 # CONFIG_ARCH_IOP32X is not set
 # CONFIG_ARCH_IOP33X is not set
@@ -151,25 +155,25 @@ CONFIG_DEFAULT_IOSCHED="cfq"
 # CONFIG_ARCH_IXP4XX is not set
 # CONFIG_ARCH_L7200 is not set
 # CONFIG_ARCH_KIRKWOOD is not set
-# CONFIG_ARCH_KS8695 is not set
-# CONFIG_ARCH_NS9XXX is not set
 # CONFIG_ARCH_LOKI is not set
 # CONFIG_ARCH_MV78XX0 is not set
-# CONFIG_ARCH_MXC is not set
 # CONFIG_ARCH_ORION5X is not set
+# CONFIG_ARCH_MMP is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+CONFIG_ARCH_W90X900=y
 # CONFIG_ARCH_PNX4008 is not set
 # CONFIG_ARCH_PXA is not set
-# CONFIG_ARCH_MMP is not set
+# CONFIG_ARCH_MSM is not set
 # CONFIG_ARCH_RPC is not set
 # CONFIG_ARCH_SA1100 is not set
 # CONFIG_ARCH_S3C2410 is not set
 # CONFIG_ARCH_S3C64XX is not set
 # CONFIG_ARCH_SHARK is not set
 # CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_U300 is not set
 # CONFIG_ARCH_DAVINCI is not set
 # CONFIG_ARCH_OMAP is not set
-# CONFIG_ARCH_MSM is not set
-CONFIG_ARCH_W90X900=y
 CONFIG_CPU_W90P910=y
 
 #
@@ -178,6 +182,11 @@ CONFIG_CPU_W90P910=y
 CONFIG_MACH_W90P910EVB=y
 
 #
+# NUC950 Machines
+#
+# CONFIG_MACH_W90P950EVB is not set
+
+#
 # Processor Type
 #
 CONFIG_CPU_32=y
@@ -199,7 +208,6 @@ CONFIG_ARM_THUMB=y
 # CONFIG_CPU_DCACHE_DISABLE is not set
 # CONFIG_CPU_DCACHE_WRITETHROUGH is not set
 # CONFIG_CPU_CACHE_ROUND_ROBIN is not set
-# CONFIG_OUTER_CACHE is not set
 CONFIG_COMMON_CLKDEV=y
 
 #
@@ -212,6 +220,9 @@ CONFIG_COMMON_CLKDEV=y
 #
 # Kernel Features
 #
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_VMSPLIT_3G=y
 # CONFIG_VMSPLIT_2G is not set
 # CONFIG_VMSPLIT_1G is not set
@@ -220,7 +231,6 @@ CONFIG_PREEMPT=y
 CONFIG_HZ=100
 CONFIG_AEABI=y
 CONFIG_OABI_COMPAT=y
-# CONFIG_ARCH_HAS_HOLES_MEMORYMODEL is not set
 # CONFIG_ARCH_SPARSEMEM_DEFAULT is not set
 # CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
 # CONFIG_HIGHMEM is not set
@@ -235,10 +245,11 @@ CONFIG_SPLIT_PTLOCK_CPUS=4096
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=0
 CONFIG_VIRT_TO_BUS=y
-CONFIG_UNEVICTABLE_LRU=y
 CONFIG_HAVE_MLOCK=y
 CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 CONFIG_ALIGNMENT_TRAP=y
+# CONFIG_UACCESS_WITH_MEMCPY is not set
 
 #
 # Boot options
@@ -389,6 +400,7 @@ CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=16384
 # CONFIG_BLK_DEV_XIP is not set
 # CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_MG_DISK is not set
 # CONFIG_MISC_DEVICES is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
@@ -412,10 +424,6 @@ CONFIG_BLK_DEV_SD=y
 # CONFIG_BLK_DEV_SR is not set
 # CONFIG_CHR_DEV_SG is not set
 # CONFIG_CHR_DEV_SCH is not set
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
 # CONFIG_SCSI_MULTI_LUN is not set
 # CONFIG_SCSI_CONSTANTS is not set
 # CONFIG_SCSI_LOGGING is not set
@@ -545,22 +553,10 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_HTC_EGPIO is not set
 # CONFIG_HTC_PASIC3 is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_MFD_T7L66XB is not set
+# CONFIG_MFD_TC6387XB is not set
 # CONFIG_MFD_TC6393XB is not set
-
-#
-# Multimedia devices
-#
-
-#
-# Multimedia core support
-#
-# CONFIG_VIDEO_DEV is not set
-# CONFIG_VIDEO_MEDIA is not set
-
-#
-# Multimedia drivers
-#
-# CONFIG_DAB is not set
+# CONFIG_MEDIA_SUPPORT is not set
 
 #
 # Graphics support
@@ -611,6 +607,7 @@ CONFIG_USB_MON=y
 # CONFIG_USB_SL811_HCD is not set
 # CONFIG_USB_R8A66597_HCD is not set
 # CONFIG_USB_HWA_HCD is not set
+# CONFIG_USB_MUSB_HDRC is not set
 
 #
 # USB Device Class drivers
@@ -673,6 +670,7 @@ CONFIG_USB_STORAGE=y
 # CONFIG_USB_LD is not set
 # CONFIG_USB_TRANCEVIBRATOR is not set
 # CONFIG_USB_IOWARRIOR is not set
+# CONFIG_USB_TEST is not set
 # CONFIG_USB_ISIGHTFW is not set
 # CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
@@ -703,12 +701,14 @@ CONFIG_RTC_LIB=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
-CONFIG_FILE_LOCKING=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_BTRFS_FS is not set
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
 # CONFIG_DNOTIFY is not set
 # CONFIG_INOTIFY is not set
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
@@ -843,32 +843,14 @@ CONFIG_FRAME_WARN=1024
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-CONFIG_STACKTRACE=y
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_LATENCYTOP is not set
 # CONFIG_SYSCTL_SYSCALL_CHECK is not set
-CONFIG_NOP_TRACER=y
 CONFIG_HAVE_FUNCTION_TRACER=y
-CONFIG_RING_BUFFER=y
-CONFIG_TRACING=y
 CONFIG_TRACING_SUPPORT=y
-
-#
-# Tracers
-#
-# CONFIG_FUNCTION_TRACER is not set
-# CONFIG_SCHED_TRACER is not set
-# CONFIG_CONTEXT_SWITCH_TRACER is not set
-# CONFIG_EVENT_TRACER is not set
-# CONFIG_BOOT_TRACER is not set
-# CONFIG_TRACE_BRANCH_PROFILING is not set
-# CONFIG_STACK_TRACER is not set
-# CONFIG_KMEMTRACE is not set
-# CONFIG_WORKQUEUE_TRACER is not set
-CONFIG_BLK_DEV_IO_TRACE=y
-# CONFIG_FTRACE_STARTUP_TEST is not set
+# CONFIG_FTRACE is not set
 # CONFIG_DYNAMIC_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
@@ -883,7 +865,7 @@ CONFIG_ARM_UNWIND=y
 # CONFIG_SECURITYFS is not set
 # CONFIG_SECURITY_FILE_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set
-CONFIG_BINARY_PRINTF=y
+# CONFIG_BINARY_PRINTF is not set
 
 #
 # Library routines
-- 
1.5.6.3

