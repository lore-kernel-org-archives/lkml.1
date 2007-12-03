Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbXLFM45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbXLFM45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXLFMos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:48 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53778 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbXLFMon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:43 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <18b918a80bf9d85a1d7dc364636cb84671b5fbde.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Date: Mon, 3 Dec 2007 11:37:14 +0100
Subject: [PATCH 45/47] New default config for CRISv10.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/defconfig |  796 ++++++++++++++++++---------------------------------
 1 files changed, 274 insertions(+), 522 deletions(-)

diff --git a/arch/cris/defconfig b/arch/cris/defconfig
index 9c33ae6..ec857c6 100644
--- a/arch/cris/defconfig
+++ b/arch/cris/defconfig
@@ -1,52 +1,92 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.11
-# Mon Jun 20 13:42:02 2005
+# Linux kernel version: 2.6.24-rc3
+# Mon Dec  3 11:34:27 2007
 #
 CONFIG_MMU=y
-CONFIG_UID16=y
+CONFIG_ZONE_DMA=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_GENERIC_IOMAP=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_NO_IOPORT=y
+CONFIG_NO_IOMEM=y
+CONFIG_FORCE_MAX_ZONEORDER=6
 CONFIG_CRIS=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_CLEAN_COMPILE=y
 CONFIG_BROKEN_ON_SMP=y
-
-#
-# General setup
-#
+CONFIG_INIT_ENV_ARG_LIMIT=32
 CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION_AUTO=y
 # CONFIG_SWAP is not set
 # CONFIG_SYSVIPC is not set
 # CONFIG_POSIX_MQUEUE is not set
 # CONFIG_BSD_PROCESS_ACCT is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 # CONFIG_AUDIT is not set
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_HOTPLUG is not set
-CONFIG_KOBJECT_UEVENT=y
 # CONFIG_IKCONFIG is not set
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
 CONFIG_EMBEDDED=y
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
 # CONFIG_KALLSYMS is not set
+# CONFIG_HOTPLUG is not set
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
-CONFIG_CC_ALIGN_FUNCTIONS=0
-CONFIG_CC_ALIGN_LABELS=0
-CONFIG_CC_ALIGN_LOOPS=0
-CONFIG_CC_ALIGN_JUMPS=0
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
 
 #
-# Loadable module support
+# IO Schedulers
 #
-# CONFIG_MODULES is not set
+CONFIG_IOSCHED_NOOP=y
+# CONFIG_IOSCHED_AS is not set
+# CONFIG_IOSCHED_DEADLINE is not set
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
 
 #
 # General setup
@@ -54,12 +94,27 @@ CONFIG_CC_ALIGN_JUMPS=0
 CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 CONFIG_GENERIC_HARDIRQS=y
-# CONFIG_SMP is not set
 CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
 # CONFIG_ETRAX_WATCHDOG is not set
 CONFIG_ETRAX_FAST_TIMER=y
-# CONFIG_PREEMPT is not set
+# CONFIG_ETRAX_KMALLOCED_MODULES is not set
 # CONFIG_OOM_REBOOT is not set
+CONFIG_PREEMPT_NONE=y
+# CONFIG_PREEMPT_VOLUNTARY is not set
+# CONFIG_PREEMPT is not set
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
+CONFIG_BOUNCE=y
+CONFIG_VIRT_TO_BUS=y
 
 #
 # Hardware setup
@@ -68,127 +123,180 @@ CONFIG_ETRAX_FAST_TIMER=y
 CONFIG_ETRAX100LX_V2=y
 # CONFIG_SVINTO_SIM is not set
 # CONFIG_ETRAXFS is not set
-# CONFIG_ETRAXFS_SIM is not set
+# CONFIG_CRIS_MACH_ARTPEC3 is not set
+# CONFIG_ETRAX_VCS_SIM is not set
 CONFIG_ETRAX_ARCH_V10=y
 # CONFIG_ETRAX_ARCH_V32 is not set
 CONFIG_ETRAX_DRAM_SIZE=32
 CONFIG_ETRAX_FLASH_BUSWIDTH=2
+CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
 CONFIG_ETRAX_FLASH1_SIZE=4
+# CONFIG_ETRAX_DEBUG_PORT0 is not set
+# CONFIG_ETRAX_DEBUG_PORT1 is not set
+# CONFIG_ETRAX_DEBUG_PORT2 is not set
+# CONFIG_ETRAX_DEBUG_PORT3 is not set
+CONFIG_ETRAX_DEBUG_PORT_NULL=y
+
+#
+# CRIS v10 options
+#
 CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
 CONFIG_ETRAX_PA_LEDS=y
 # CONFIG_ETRAX_PB_LEDS is not set
 # CONFIG_ETRAX_CSP0_LEDS is not set
 # CONFIG_ETRAX_NO_LEDS is not set
 CONFIG_ETRAX_LED1G=2
-CONFIG_ETRAX_LED1R=2
-CONFIG_ETRAX_LED2G=3
-CONFIG_ETRAX_LED2R=3
+CONFIG_ETRAX_LED1R=3
+CONFIG_ETRAX_LED2G=4
+CONFIG_ETRAX_LED2R=5
 CONFIG_ETRAX_LED3G=2
 CONFIG_ETRAX_LED3R=2
-CONFIG_ETRAX_DEBUG_PORT0=y
-# CONFIG_ETRAX_DEBUG_PORT1 is not set
-# CONFIG_ETRAX_DEBUG_PORT2 is not set
-# CONFIG_ETRAX_DEBUG_PORT3 is not set
-# CONFIG_ETRAX_DEBUG_PORT_NULL is not set
 CONFIG_ETRAX_RESCUE_SER0=y
 # CONFIG_ETRAX_RESCUE_SER1 is not set
 # CONFIG_ETRAX_RESCUE_SER2 is not set
 # CONFIG_ETRAX_RESCUE_SER3 is not set
-CONFIG_ETRAX_DEF_R_WAITSTATES=0x95a6
-CONFIG_ETRAX_DEF_R_BUS_CONFIG=0x4
-CONFIG_ETRAX_SDRAM=y
-CONFIG_ETRAX_DEF_R_SDRAM_CONFIG=0x09e05757
-CONFIG_ETRAX_DEF_R_SDRAM_TIMING=0x80008002
-CONFIG_ETRAX_DEF_R_PORT_PA_DIR=0x1d
-CONFIG_ETRAX_DEF_R_PORT_PA_DATA=0x00
-CONFIG_ETRAX_DEF_R_PORT_PB_CONFIG=0x00
-CONFIG_ETRAX_DEF_R_PORT_PB_DIR=0x1e
-CONFIG_ETRAX_DEF_R_PORT_PB_DATA=0xf3
+CONFIG_ETRAX_DEF_R_WAITSTATES=95a6
+CONFIG_ETRAX_DEF_R_BUS_CONFIG=104
+# CONFIG_ETRAX_SDRAM is not set
+CONFIG_ETRAX_DEF_R_DRAM_CONFIG=1a200040
+CONFIG_ETRAX_DEF_R_DRAM_TIMING=5611
+CONFIG_ETRAX_DEF_R_PORT_PA_DIR=1c
+CONFIG_ETRAX_DEF_R_PORT_PA_DATA=00
+CONFIG_ETRAX_DEF_R_PORT_PB_CONFIG=00
+CONFIG_ETRAX_DEF_R_PORT_PB_DIR=00
+CONFIG_ETRAX_DEF_R_PORT_PB_DATA=ff
 # CONFIG_ETRAX_SOFT_SHUTDOWN is not set
 
 #
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
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+# CONFIG_IP_PNP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
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
+# CONFIG_IP_VS is not set
+# CONFIG_IPV6 is not set
+# CONFIG_INET6_XFRM_TUNNEL is not set
+# CONFIG_INET6_TUNNEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+CONFIG_NETFILTER=y
+# CONFIG_NETFILTER_DEBUG is not set
+
+#
+# Core Netfilter Configuration
+#
+# CONFIG_NETFILTER_NETLINK is not set
+# CONFIG_NF_CONNTRACK_ENABLED is not set
+# CONFIG_NF_CONNTRACK is not set
+# CONFIG_NETFILTER_XTABLES is not set
+
+#
+# IP: Netfilter Configuration
+#
+# CONFIG_IP_NF_QUEUE is not set
+# CONFIG_IP_NF_IPTABLES is not set
+# CONFIG_IP_NF_ARPTABLES is not set
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
 # Drivers for built-in interfaces
 #
 CONFIG_ETRAX_ETHERNET=y
-# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
-CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
 CONFIG_ETRAX_SERIAL=y
 # CONFIG_ETRAX_SERIAL_FAST_TIMER is not set
 # CONFIG_ETRAX_SERIAL_FLUSH_DMA_FAST is not set
 CONFIG_ETRAX_SERIAL_RX_TIMEOUT_TICKS=5
-CONFIG_ETRAX_SERIAL_PORT0=y
-# CONFIG_ETRAX_SERIAL_PORT0_NO_DMA_OUT is not set
-CONFIG_ETRAX_SERIAL_PORT0_DMA6_OUT=y
-# CONFIG_ETRAX_SERIAL_PORT0_NO_DMA_IN is not set
-CONFIG_ETRAX_SERIAL_PORT0_DMA7_IN=y
-CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_ON_NONE=y
-# CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_ON_PA is not set
-# CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_ON_PB is not set
-# CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_MIXED is not set
-CONFIG_ETRAX_SER0_DTR_ON_PA_BIT=-1
-CONFIG_ETRAX_SER0_RI_ON_PA_BIT=-1
-CONFIG_ETRAX_SER0_DSR_ON_PA_BIT=-1
-CONFIG_ETRAX_SER0_CD_ON_PA_BIT=-1
-CONFIG_ETRAX_SER0_DTR_ON_PB_BIT=-1
-CONFIG_ETRAX_SER0_RI_ON_PB_BIT=-1
-CONFIG_ETRAX_SER0_DSR_ON_PB_BIT=-1
-CONFIG_ETRAX_SER0_CD_ON_PB_BIT=-1
+# CONFIG_ETRAX_SERIAL_PORT0 is not set
 # CONFIG_ETRAX_SERIAL_PORT1 is not set
-CONFIG_ETRAX_SERIAL_PORT2=y
-# CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_OUT is not set
-CONFIG_ETRAX_SERIAL_PORT2_DMA2_OUT=y
-# CONFIG_ETRAX_SERIAL_PORT2_NO_DMA_IN is not set
-CONFIG_ETRAX_SERIAL_PORT2_DMA3_IN=y
-CONFIG_ETRAX_SER2_DTR_RI_DSR_CD_ON_NONE=y
-# CONFIG_ETRAX_SER2_DTR_RI_DSR_CD_ON_PA is not set
-# CONFIG_ETRAX_SER2_DTR_RI_DSR_CD_ON_PB is not set
-# CONFIG_ETRAX_SER2_DTR_RI_DSR_CD_MIXED is not set
-CONFIG_ETRAX_SER2_DTR_ON_PA_BIT=-1
-CONFIG_ETRAX_SER2_RI_ON_PA_BIT=-1
-CONFIG_ETRAX_SER2_DSR_ON_PA_BIT=-1
-CONFIG_ETRAX_SER2_CD_ON_PA_BIT=-1
-CONFIG_ETRAX_SER2_DTR_ON_PB_BIT=-1
-CONFIG_ETRAX_SER2_RI_ON_PB_BIT=-1
-CONFIG_ETRAX_SER2_DSR_ON_PB_BIT=-1
-CONFIG_ETRAX_SER2_CD_ON_PB_BIT=-1
+# CONFIG_ETRAX_SERIAL_PORT2 is not set
 # CONFIG_ETRAX_SERIAL_PORT3 is not set
-CONFIG_ETRAX_RS485=y
-# CONFIG_ETRAX_RS485_ON_PA is not set
-# CONFIG_ETRAX_RS485_DISABLE_RECEIVER is not set
-CONFIG_ETRAX_IDE=y
-CONFIG_ETRAX_IDE_DELAY=15
-CONFIG_ETRAX_IDE_PB7_RESET=y
-# CONFIG_ETRAX_IDE_G27_RESET is not set
-CONFIG_ETRAX_USB_HOST=y
-CONFIG_ETRAX_USB_HOST_PORT1=y
-CONFIG_ETRAX_USB_HOST_PORT2=y
+# CONFIG_ETRAX_RS485 is not set
+# CONFIG_ETRAX_IDE is not set
+# CONFIG_ETRAX_USB_HOST is not set
 CONFIG_ETRAX_AXISFLASHMAP=y
 CONFIG_ETRAX_PTABLE_SECTOR=65536
 # CONFIG_ETRAX_I2C is not set
 # CONFIG_ETRAX_GPIO is not set
-CONFIG_ETRAX_RTC=y
-CONFIG_ETRAX_DS1302=y
-# CONFIG_ETRAX_PCF8563 is not set
-CONFIG_ETRAX_DS1302_RST_ON_GENERIC_PORT=y
-CONFIG_ETRAX_DS1302_RSTBIT=0
-CONFIG_ETRAX_DS1302_SCLBIT=1
-CONFIG_ETRAX_DS1302_SDABIT=0
-CONFIG_ETRAX_DS1302_TRICKLE_CHARGE=0
+# CONFIG_ETRAX_RTC is not set
+# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
+CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
 
 #
 # Generic Driver Options
 #
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_FW_LOADER is not set
-
-#
-# Memory Technology Devices (MTD)
-#
+# CONFIG_SYS_HYPERVISOR is not set
 CONFIG_MTD=y
 # CONFIG_MTD_DEBUG is not set
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CONCAT=y
+CONFIG_MTD_PARTITIONS=y
 # CONFIG_MTD_REDBOOT_PARTS is not set
 # CONFIG_MTD_CMDLINE_PARTS is not set
 
@@ -196,16 +304,20 @@ CONFIG_MTD_CONCAT=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
 # CONFIG_INFTL is not set
+# CONFIG_RFD_FTL is not set
+# CONFIG_SSFDC is not set
+# CONFIG_MTD_OOPS is not set
 
 #
 # RAM/ROM/Flash chip drivers
 #
 CONFIG_MTD_CFI=y
-# CONFIG_MTD_JEDECPROBE is not set
+CONFIG_MTD_JEDECPROBE=y
 CONFIG_MTD_GEN_PROBE=y
 # CONFIG_MTD_CFI_ADV_OPTIONS is not set
 CONFIG_MTD_MAP_BANK_WIDTH_1=y
@@ -220,20 +332,18 @@ CONFIG_MTD_CFI_I2=y
 # CONFIG_MTD_CFI_I8 is not set
 # CONFIG_MTD_CFI_INTELEXT is not set
 CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_CFI_AMDSTD_RETRY=0
 # CONFIG_MTD_CFI_STAA is not set
 CONFIG_MTD_CFI_UTIL=y
 CONFIG_MTD_RAM=y
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_SHARP is not set
-# CONFIG_MTD_JEDEC is not set
 
 #
 # Mapping drivers for chip access
 #
 CONFIG_MTD_COMPLEX_MAPPINGS=y
 # CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
 
 #
 # Self-contained MTD device drivers
@@ -244,7 +354,6 @@ CONFIG_MTD_MTDRAM=y
 CONFIG_MTDRAM_TOTAL_SIZE=0
 CONFIG_MTDRAM_ERASE_SIZE=64
 CONFIG_MTDRAM_ABS_POS=0x0
-# CONFIG_MTD_BLKMTD is not set
 # CONFIG_MTD_BLOCK2MTD is not set
 
 #
@@ -253,216 +362,54 @@ CONFIG_MTDRAM_ABS_POS=0x0
 # CONFIG_MTD_DOC2000 is not set
 # CONFIG_MTD_DOC2001 is not set
 # CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
 # CONFIG_MTD_NAND is not set
+# CONFIG_MTD_ONENAND is not set
 
 #
-# Parallel port support
-#
-# CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
+# UBI - Unsorted block images
 #
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_FD is not set
+# CONFIG_MTD_UBI is not set
+CONFIG_BLK_DEV=y
 # CONFIG_BLK_DEV_COW_COMMON is not set
 # CONFIG_BLK_DEV_LOOP is not set
-# CONFIG_BLK_DEV_CRYPTOLOOP is not set
 # CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_UB is not set
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
-# CONFIG_BLK_DEV_INITRD is not set
-CONFIG_INITRAMFS_SOURCE=""
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
 # CONFIG_CDROM_PKTCDVD is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-CONFIG_IOSCHED_CFQ=y
 # CONFIG_ATA_OVER_ETH is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
-# CONFIG_MD is not set
-
-#
-# ATA/ATAPI/MFM/RLL support
-#
-# CONFIG_IDE is not set
-# CONFIG_PARIDE is not set
-
-#
-# Please see Documentation/ide.txt for help/info on IDE drives
-#
-# CONFIG_BLK_DEV_IDE_SATA is not set
-# CONFIG_IDEDISK_MULTI_MODE is not set
-# CONFIG_BLK_DEV_IDETAPE is not set
-# CONFIG_BLK_DEV_IDEFLOPPY is not set
-# CONFIG_IDE_TASK_IOCTL is not set
-
-#
-# IDE chipset support/bugfixes
-#
-# CONFIG_IDE_GENERIC is not set
-# CONFIG_IDE_ARM is not set
-# CONFIG_IDEDMA_AUTO is not set
-# CONFIG_BLK_DEV_HD is not set
-
-#
-# SCSI device support
-#
-# CONFIG_SCSI is not set
-# CONFIG_ISCSI_TCP is not set
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
-# Networking support
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-# CONFIG_NETLINK_DEV is not set
-CONFIG_UNIX=y
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_IP_TCPDIAG=y
-# CONFIG_IP_TCPDIAG_IPV6 is not set
-
-#
-# IP: Virtual Server Configuration
-#
-# CONFIG_IP_VS is not set
-# CONFIG_IPV6 is not set
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-
-#
-# IP: Netfilter Configuration
-#
-# CONFIG_IP_NF_CONNTRACK is not set
-# CONFIG_IP_NF_CONNTRACK_MARK is not set
-# CONFIG_IP_NF_QUEUE is not set
-# CONFIG_IP_NF_IPTABLES is not set
-# CONFIG_IP_NF_ARPTABLES is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-# CONFIG_NET_CLS_ROUTE is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_AF_RXRPC is not set
-# CONFIG_AF_RXRPC_DEBUG is not set
-# CONFIG_BT is not set
-# CONFIG_I2C is not set
-
 CONFIG_NETDEVICES=y
+# CONFIG_NETDEVICES_MULTIQUEUE is not set
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
 # CONFIG_EQUALIZER is not set
 # CONFIG_TUN is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
+# CONFIG_VETH is not set
+# CONFIG_PHYLIB is not set
 CONFIG_NET_ETHERNET=y
-# CONFIG_MII is not set
+CONFIG_MII=y
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
 
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
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
 # CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN is not set
-
-#
-# Telephony Support
-#
-# CONFIG_PHONE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_RTC_CLASS is not set
 
 #
 # Input device support
@@ -470,7 +417,7 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_INPUT is not set
 
 #
-# Input I/O drivers
+# Hardware I/O ports
 #
 CONFIG_SERIO=y
 # CONFIG_SERIO_I8042 is not set
@@ -480,94 +427,39 @@ CONFIG_SERIO=y
 # CONFIG_GAMEPORT is not set
 
 #
-# Input Device Drivers
-#
-CONFIG_INPUT_KEYBOARD=y
-CONFIG_KEYBOARD_ATKBD=y
-# CONFIG_KEYBOARD_SUNKBD is not set
-# CONFIG_KEYBOARD_LKKBD is not set
-# CONFIG_KEYBOARD_XTKBD is not set
-# CONFIG_KEYBOARD_NEWTON is not set
-CONFIG_INPUT_MOUSE=y
-CONFIG_MOUSE_PS2=y
-# CONFIG_MOUSE_SERIAL is not set
-# CONFIG_MOUSE_VSXXXAA is not set
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TABLET is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-# CONFIG_INPUT_MISC is not set
-
-#
 # Character devices
 #
 # CONFIG_VT is not set
-# CONFIG_SERIAL_NONSTANDARD is not set
-
-#
-# Serial drivers
-#
-# CONFIG_SERIAL_8250 is not set
-
-#
-# Non-8250 serial port support
-#
-CONFIG_SERIAL_CORE=y
-CONFIG_SERIAL_CORE_CONSOLE=y
 CONFIG_UNIX98_PTYS=y
 CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
-
-#
-# IPMI
-#
-# CONFIG_IPMI_HANDLER is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=y
 # CONFIG_RTC is not set
 # CONFIG_GEN_RTC is not set
-# CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-# CONFIG_RTC_LIB is not set
-# CONFIG_RTC_CLASS is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_DRM is not set
 # CONFIG_RAW_DRIVER is not set
 
 #
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-
-#
 # File systems
 #
 # CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
-# CONFIG_JBD is not set
+# CONFIG_EXT4DEV_FS is not set
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
-
-#
-# XFS support
-#
+# CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
 CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
 
 #
 # CD-ROM/DVD Filesystems
@@ -587,13 +479,12 @@ CONFIG_DNOTIFY=y
 #
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
-# CONFIG_DEVFS_FS is not set
-# CONFIG_DEVPTS_FS_XATTR is not set
 CONFIG_TMPFS=y
-# CONFIG_TMPFS_XATTR is not set
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
+# CONFIG_CONFIGFS_FS is not set
 
 #
 # Miscellaneous filesystems
@@ -605,15 +496,15 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
-CONFIG_JFFS_FS=y
-CONFIG_JFFS_FS_VERBOSE=0
-# CONFIG_JFFS_PROC_FS is not set
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
-# CONFIG_JFFS2_FS_NAND is not set
-# CONFIG_JFFS2_FS_NOR_ECC is not set
+CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
+# CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 CONFIG_CRAMFS=y
@@ -622,12 +513,10 @@ CONFIG_CRAMFS=y
 # CONFIG_QNX4FS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
+CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
 # CONFIG_NFS_V4 is not set
 # CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
@@ -649,181 +538,44 @@ CONFIG_SUNRPC=y
 #
 # CONFIG_PARTITION_ADVANCED is not set
 CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
 # CONFIG_NLS is not set
-
-#
-# Sound
-#
-# CONFIG_SOUND is not set
-
-#
-# Generic devices
-#
-# CONFIG_SND_MPU401_UART is not set
-# CONFIG_SND_DUMMY is not set
-# CONFIG_SND_VIRMIDI is not set
-# CONFIG_SND_MTPAV is not set
-# CONFIG_SND_SERIAL_U16550 is not set
-# CONFIG_SND_MPU401 is not set
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
-# CONFIG_PCCARD is not set
-# CONFIG_PARPORT_PC_PCMCIA is not set
-# CONFIG_NET_PCMCIA is not set
-
-#
-# PC-card bridges
-#
-
-#
-# USB support
-#
-CONFIG_USB=y
-# CONFIG_USB_DEBUG is not set
-
-#
-# Miscellaneous USB options
-#
-CONFIG_USB_DEVICEFS=y
-# CONFIG_USB_BANDWIDTH is not set
-# CONFIG_USB_DYNAMIC_MINORS is not set
-# CONFIG_USB_OTG is not set
-# CONFIG_USB_ARCH_HAS_HCD is not set
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-
-#
-# USB Host Controller Drivers
-#
-# CONFIG_USB_SL811_HCD is not set
-
-#
-# USB Device Class drivers
-#
-
-#
-# USB Bluetooth TTY can only be used with disabled Bluetooth subsystem
-#
-# CONFIG_USB_ACM is not set
-# CONFIG_USB_PRINTER is not set
-
-#
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support' may also be needed; see USB_STORAGE Help for more information
-#
-# CONFIG_USB_STORAGE is not set
-
-#
-# USB Input Devices
-#
-# CONFIG_USB_HID is not set
-# HID_SUPPORT is not set
-
-#
-# USB HID Boot Protocol drivers
-#
-# CONFIG_USB_KBD is not set
-# CONFIG_USB_MOUSE is not set
-# CONFIG_USB_AIPTEK is not set
-# CONFIG_USB_WACOM is not set
-# CONFIG_USB_KBTAB is not set
-# CONFIG_USB_POWERMATE is not set
-# CONFIG_USB_MTOUCH is not set
-# CONFIG_USB_EGALAX is not set
-# CONFIG_USB_XPAD is not set
-# CONFIG_USB_ATI_REMOTE is not set
-
-#
-# USB Imaging devices
-#
-# CONFIG_USB_MDC800 is not set
-
-#
-# USB Multimedia devices
-#
-# CONFIG_USB_DABUSB is not set
-
-#
-# Video4Linux support is needed for USB Multimedia device support
-#
-
-#
-# USB Network Adapters
-#
-# CONFIG_USB_CATC is not set
-# CONFIG_USB_KAWETH is not set
-# CONFIG_USB_PEGASUS is not set
-CONFIG_USB_RTL8150=y
-# CONFIG_USB_USBNET is not set
-
-#
-# USB port drivers
-#
-
-#
-# USB Serial Converter support
-#
-# CONFIG_USB_SERIAL is not set
-
-#
-# USB Miscellaneous drivers
-#
-# CONFIG_USB_EMI62 is not set
-# CONFIG_USB_EMI26 is not set
-# CONFIG_USB_AUERSWALD is not set
-# CONFIG_USB_RIO500 is not set
-# CONFIG_USB_LEGOTOWER is not set
-# CONFIG_USB_LCD is not set
-# CONFIG_USB_LED is not set
-# CONFIG_USB_CYTHERM is not set
-# CONFIG_USB_PHIDGETKIT is not set
-# CONFIG_USB_PHIDGETSERVO is not set
-# CONFIG_USB_IDMOUSE is not set
-# CONFIG_USB_TEST is not set
-
-#
-# USB ATM/DSL drivers
-#
-
-#
-# USB Gadget Support
-#
-# CONFIG_USB_GADGET is not set
+# CONFIG_DLM is not set
 
 #
 # Kernel hacking
 #
 # CONFIG_PROFILING is not set
 # CONFIG_SYSTEM_PROFILER is not set
-# CONFIG_ETRAX_KGDB is not set
-# CONFIG_DEBUG_INFO is not set
-# CONFIG_FRAME_POINTER is not set
-# CONFIG_DEBUG_NMI_OOPS is not set
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_SLUB_DEBUG_ON is not set
+# CONFIG_SAMPLES is not set
 
 #
 # Security options
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
 # CONFIG_CRYPTO is not set
 
 #
-# Hardware crypto devices
-# CONFIG_CRYPTO_HW is not set
-
-#
 # Library routines
 #
+CONFIG_BITREVERSE=y
 # CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_DMA=y
-- 
1.5.3.6.970.gd25430

