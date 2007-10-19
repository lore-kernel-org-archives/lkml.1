Return-Path: <linux-kernel-owner+w=401wt.eu-S1764505AbXJSBsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764505AbXJSBsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 21:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbXJSBrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 21:47:55 -0400
Received: from rex.snapgear.com ([203.143.235.140]:36359 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759872AbXJSBrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 21:47:53 -0400
Date: Fri, 19 Oct 2007 11:46:22 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200710190146.l9J1kMAi003801@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: updated defconfig
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updated defconfig with new options for m68knommu.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.23/arch/m68knommu/defconfig linux-2.6.23-uc0/arch/m68knommu/defconfig
--- linux-2.6.23/arch/m68knommu/defconfig	2007-10-19 10:30:58.000000000 +1000
+++ linux-2.6.23-uc0/arch/m68knommu/defconfig	2007-10-19 10:35:41.000000000 +1000
@@ -1,41 +1,48 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.17
-# Tue Jun 27 12:57:06 2006
+# Linux kernel version: 2.6.23
+# Thu Oct 18 13:17:38 2007
 #
 CONFIG_M68K=y
 # CONFIG_MMU is not set
 # CONFIG_FPU is not set
+CONFIG_ZONE_DMA=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_FIND_NEXT_BIT=y
 CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_TIME_LOW_RES=y
+CONFIG_NO_IOPORT=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 # CONFIG_SYSVIPC is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_SYSCTL is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
 # CONFIG_AUDIT is not set
 # CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=14
+# CONFIG_SYSFS_DEPRECATED is not set
 # CONFIG_RELAY is not set
-CONFIG_INITRAMFS_SOURCE=""
-CONFIG_UID16=y
+# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_PRINTK=y
@@ -44,20 +51,25 @@ CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 # CONFIG_FUTEX is not set
 # CONFIG_EPOLL is not set
+# CONFIG_SIGNALFD is not set
+# CONFIG_EVENTFD is not set
+# CONFIG_VM_EVENT_COUNTERS is not set
 CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
 CONFIG_TINY_SHMEM=y
 CONFIG_BASE_SMALL=0
-# CONFIG_SLOB is not set
-
-#
-# Loadable module support
-#
-# CONFIG_MODULES is not set
-
-#
-# Block layer
-#
+CONFIG_MODULES=y
+CONFIG_MODULE_UNLOAD=y
+# CONFIG_MODULE_FORCE_UNLOAD is not set
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+# CONFIG_KMOD is not set
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
 
 #
 # IO Schedulers
@@ -99,6 +111,7 @@ CONFIG_CLOCK_DIV=1
 #
 # Platform
 #
+# CONFIG_UC5272 is not set
 CONFIG_M5272C3=y
 # CONFIG_COBRA5272 is not set
 # CONFIG_CANCam is not set
@@ -107,7 +120,6 @@ CONFIG_M5272C3=y
 # CONFIG_CPU16B is not set
 # CONFIG_MOD5272 is not set
 CONFIG_FREESCALE=y
-# CONFIG_LARGE_ALLOCS is not set
 CONFIG_4KSTACKS=y
 
 #
@@ -121,6 +133,11 @@ CONFIG_RAMAUTOBIT=y
 # CONFIG_RAM8BIT is not set
 # CONFIG_RAM16BIT is not set
 # CONFIG_RAM32BIT is not set
+
+#
+# ROM configuration
+#
+# CONFIG_ROM is not set
 CONFIG_RAMKERNEL=y
 # CONFIG_ROMKERNEL is not set
 CONFIG_SELECT_MEMORY_MODEL=y
@@ -131,20 +148,19 @@ CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_VIRT_TO_BUS=y
 
 #
 # Bus options (PCI, PCMCIA, EISA, MCA, ISA)
 #
 # CONFIG_PCI is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
 
 #
 # PCCARD (PCMCIA/CardBus) support
 #
-# CONFIG_PCCARD is not set
-
-#
-# PCI Hotplug Support
-#
 
 #
 # Executable file formats
@@ -168,7 +184,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NETDEBUG is not set
 CONFIG_PACKET=y
 # CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
@@ -187,27 +202,21 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
 # CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
 # CONFIG_INET_DIAG is not set
 # CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_BIC=y
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_INET6_XFRM_TUNNEL is not set
 # CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
 # CONFIG_NETFILTER is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
 # CONFIG_IP_SCTP is not set
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
@@ -218,7 +227,6 @@ CONFIG_TCP_CONG_BIC=y
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
 
@@ -234,7 +242,17 @@ CONFIG_TCP_CONG_BIC=y
 # CONFIG_HAMRADIO is not set
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
+# CONFIG_AF_RXRPC is not set
+
+#
+# Wireless
+#
+# CONFIG_CFG80211 is not set
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_MAC80211 is not set
 # CONFIG_IEEE80211 is not set
+# CONFIG_RFKILL is not set
+# CONFIG_NET_9P is not set
 
 #
 # Device Drivers
@@ -245,16 +263,8 @@ CONFIG_TCP_CONG_BIC=y
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
+# CONFIG_SYS_HYPERVISOR is not set
 # CONFIG_CONNECTOR is not set
-
-#
-# Memory Technology Devices (MTD)
-#
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
 # CONFIG_MTD_CONCAT is not set
@@ -266,11 +276,13 @@ CONFIG_MTD_PARTITIONS=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
 # CONFIG_INFTL is not set
 # CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -290,7 +302,6 @@ CONFIG_MTD_CFI_I2=y
 CONFIG_MTD_RAM=y
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
 
 #
 # Mapping drivers for chip access
@@ -313,42 +324,25 @@ CONFIG_MTD_UCLINUX=y
 # CONFIG_MTD_DOC2000 is not set
 # CONFIG_MTD_DOC2001 is not set
 # CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
 # CONFIG_MTD_NAND is not set
-
-#
-# OneNAND Flash Device Drivers
-#
 # CONFIG_MTD_ONENAND is not set
 
 #
-# Parallel port support
+# UBI - Unsorted block images
 #
+# CONFIG_MTD_UBI is not set
 # CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-
-#
-# Block devices
-#
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
-# CONFIG_BLK_DEV_INITRD is not set
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# ATA/ATAPI/MFM/RLL support
-#
+# CONFIG_MISC_DEVICES is not set
 # CONFIG_IDE is not set
 
 #
@@ -356,67 +350,29 @@ CONFIG_BLK_DEV_RAM_SIZE=4096
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
 # CONFIG_MD is not set
-
-#
-# Fusion MPT device support
-#
-# CONFIG_FUSION is not set
-
-#
-# IEEE 1394 (FireWire) support
-#
-
-#
-# I2O device support
-#
-
-#
-# Network device support
-#
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
-
-#
-# PHY device support
-#
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 # CONFIG_MII is not set
 CONFIG_FEC=y
 # CONFIG_FEC2 is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
 
 #
-# Ethernet (1000 Mbit)
-#
-
-#
-# Ethernet (10000 Mbit)
-#
-
-#
-# Token Ring devices
-#
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Wan interfaces
+# Wireless LAN
 #
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
 # CONFIG_WAN is not set
 CONFIG_PPP=y
 # CONFIG_PPP_MULTILINK is not set
@@ -427,20 +383,14 @@ CONFIG_PPP=y
 # CONFIG_PPP_BSDCOMP is not set
 # CONFIG_PPP_MPPE is not set
 # CONFIG_PPPOE is not set
+# CONFIG_PPPOL2TP is not set
 # CONFIG_SLIP is not set
+CONFIG_SLHC=y
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
 # CONFIG_PHONE is not set
 
 #
@@ -472,34 +422,13 @@ CONFIG_SERIAL_COLDFIRE=y
 # CONFIG_UNIX98_PTYS is not set
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
-
-#
-# IPMI
-#
 # CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
 # CONFIG_WATCHDOG is not set
+# CONFIG_HW_RANDOM is not set
 # CONFIG_GEN_RTC is not set
-# CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
 # CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
 # CONFIG_TCG_TPM is not set
-# CONFIG_TELCLOCK is not set
-
-#
-# I2C support
-#
 # CONFIG_I2C is not set
 
 #
@@ -507,101 +436,74 @@ CONFIG_LEGACY_PTY_COUNT=256
 #
 # CONFIG_SPI is not set
 # CONFIG_SPI_MASTER is not set
-
-#
-# Dallas's 1-wire bus
-#
 # CONFIG_W1 is not set
-
-#
-# Hardware Monitoring support
-#
+# CONFIG_POWER_SUPPLY is not set
 # CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
 
 #
-# Misc devices
+# Multifunction device drivers
 #
+# CONFIG_MFD_SM501 is not set
 
 #
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
-CONFIG_VIDEO_V4L2=y
+# CONFIG_DVB_CORE is not set
+CONFIG_DAB=y
 
 #
-# Digital Video Broadcasting Devices
+# Graphics support
 #
-# CONFIG_DVB is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
-# Graphics support
+# Display device support
 #
+# CONFIG_DISPLAY_SUPPORT is not set
+# CONFIG_VGASTATE is not set
+CONFIG_VIDEO_OUTPUT_CONTROL=y
 # CONFIG_FB is not set
 
 #
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# USB support
-#
-# CONFIG_USB_ARCH_HAS_HCD is not set
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
-
-#
-# MMC/SD Card support
-#
+# CONFIG_USB_SUPPORT is not set
 # CONFIG_MMC is not set
-
-#
-# LED devices
-#
 # CONFIG_NEW_LEDS is not set
+# CONFIG_RTC_CLASS is not set
 
 #
-# LED drivers
+# DMA Engine support
 #
+# CONFIG_DMA_ENGINE is not set
 
 #
-# LED Triggers
+# DMA Clients
 #
 
 #
-# InfiniBand support
+# DMA Devices
 #
 
 #
-# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
+# Userspace I/O
 #
-
-#
-# Real Time Clock
-#
-# CONFIG_RTC_CLASS is not set
+# CONFIG_UIO is not set
 
 #
 # File systems
 #
 CONFIG_EXT2_FS=y
 # CONFIG_EXT2_FS_XATTR is not set
-# CONFIG_EXT2_FS_XIP is not set
 # CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 CONFIG_ROMFS_FS=y
@@ -629,6 +531,7 @@ CONFIG_ROMFS_FS=y
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 # CONFIG_TMPFS is not set
 # CONFIG_HUGETLB_PAGE is not set
@@ -645,7 +548,6 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
-# CONFIG_JFFS_FS is not set
 # CONFIG_JFFS2_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
@@ -664,7 +566,6 @@ CONFIG_RAMFS=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
 
 #
 # Partition Types
@@ -678,15 +579,21 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_NLS is not set
 
 #
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
 # CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
 # CONFIG_DEBUG_KERNEL is not set
-CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DEBUG_BUGVERBOSE is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_UNWIND_INFO is not set
 # CONFIG_FULLDEBUG is not set
 # CONFIG_HIGHPROFILE is not set
 # CONFIG_BOOTPARAM is not set
@@ -699,20 +606,16 @@ CONFIG_LOG_BUF_SHIFT=14
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-#
-
-#
 # Library routines
 #
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 # CONFIG_CRC32 is not set
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_DMA=y
