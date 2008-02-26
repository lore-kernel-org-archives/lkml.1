Return-Path: <linux-kernel-owner+w=401wt.eu-S1764046AbYBZRs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764046AbYBZRs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762672AbYBZRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:48:16 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50344 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762642AbYBZRsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:48:10 -0500
Date: Tue, 26 Feb 2008 19:47:03 +0200
From: Adrian Bunk <bunk@kernel.org>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: dev-etrax@axis.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch v2] cris: proper defconfig setup
Message-ID: <20080226174703.GD8287@cs181133002.pp.htv.fi>
References: <20080226172847.GB8287@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080226172847.GB8287@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the cris defconfigs to arch/cris/configs/ where they 
belong.

As a side effect they can now be used directly through e.g.
  make ARCH=cris artpec_3_defconfig

The default defconfig is set through KBUILD_DEFCONFIG.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

Patch updated after I discovered an additional defconfig in 
arch/cris/arch-v10/defconfig

 arch/cris/Makefile                         |    2 
 arch/cris/arch-v10/defconfig               |  502 ------------------
 arch/cris/artpec_3_defconfig               |  582 --------------------
 arch/cris/configs/artpec_3_defconfig       |  582 ++++++++++++++++++++
 arch/cris/configs/etrax-100lx_defconfig    |  502 ++++++++++++++++++
 arch/cris/configs/etrax-100lx_v2_defconfig |  580 ++++++++++++++++++++
 arch/cris/configs/etraxfs_defconfig        |  585 +++++++++++++++++++++
 arch/cris/defconfig                        |  580 --------------------
 arch/cris/etraxfs_defconfig                |  585 ---------------------
 9 files changed, 2251 insertions(+), 2249 deletions(-)

f43d92ac3143510427416af956e3a093acc51a00 diff --git a/arch/cris/Makefile b/arch/cris/Makefile
index 838cd2a..c6f5f5a 100644
--- a/arch/cris/Makefile
+++ b/arch/cris/Makefile
@@ -10,6 +10,8 @@
 # License.  See the file "COPYING" in the main directory of this archive
 # for more details.
 
+KBUILD_DEFCONFIG := etrax-100lx_v2_defconfig
+
 arch-y := v10
 arch-$(CONFIG_ETRAX_ARCH_V10) := v10
 arch-$(CONFIG_ETRAX_ARCH_V32) := v32
diff --git a/arch/cris/arch-v10/defconfig b/arch/cris/arch-v10/defconfig
deleted file mode 100644
index 572f119..0000000
--- a/arch/cris/arch-v10/defconfig
+++ /dev/null
@@ -1,502 +0,0 @@
-#
-# Automatically generated make config: don't edit
-#
-CONFIG_UID16=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=y
-
-#
-# General setup
-#
-CONFIG_NET=y
-CONFIG_SYSVIPC=y
-# CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_SYSCTL is not set
-CONFIG_BINFMT_ELF=y
-# CONFIG_ETRAX_KGDB is not set
-# CONFIG_ETRAX_WATCHDOG is not set
-
-#
-# Hardware setup
-#
-CONFIG_ETRAX100LX=y
-# CONFIG_ETRAX100LX_V2 is not set
-# CONFIG_SVINTO_SIM is not set
-CONFIG_CRIS_LOW_MAP=y
-CONFIG_ETRAX_DRAM_VIRTUAL_BASE=60000000
-CONFIG_ETRAX_DRAM_SIZE=8
-CONFIG_ETRAX_FLASH_BUSWIDTH=2
-CONFIG_ETRAX_ROOT_DEVICE="/dev/mtdblock3"
-CONFIG_ETRAX_PA_LEDS=y
-# CONFIG_ETRAX_PB_LEDS is not set
-# CONFIG_ETRAX_CSP0_LEDS is not set
-# CONFIG_ETRAX_NO_LEDS is not set
-CONFIG_ETRAX_LED1G=2
-CONFIG_ETRAX_LED1R=2
-CONFIG_ETRAX_LED2G=2
-CONFIG_ETRAX_LED2R=2
-CONFIG_ETRAX_LED3R=2
-CONFIG_ETRAX_LED3G=2
-CONFIG_ETRAX_LED4R=2
-CONFIG_ETRAX_LED4G=2
-CONFIG_ETRAX_LED5R=2
-CONFIG_ETRAX_LED5G=2
-CONFIG_ETRAX_LED6R=2
-CONFIG_ETRAX_LED6G=2
-CONFIG_ETRAX_LED7R=2
-CONFIG_ETRAX_LED7G=2
-CONFIG_ETRAX_LED8Y=2
-CONFIG_ETRAX_LED9Y=2
-CONFIG_ETRAX_LED10Y=2
-CONFIG_ETRAX_LED11Y=2
-CONFIG_ETRAX_LED12R=2
-CONFIG_ETRAX_DEBUG_PORT0=y
-# CONFIG_ETRAX_DEBUG_PORT1 is not set
-# CONFIG_ETRAX_DEBUG_PORT2 is not set
-# CONFIG_ETRAX_DEBUG_PORT3 is not set
-CONFIG_ETRAX_RESCUE_SER0=y
-# CONFIG_ETRAX_RESCUE_SER1 is not set
-# CONFIG_ETRAX_RESCUE_SER2 is not set
-# CONFIG_ETRAX_RESCUE_SER3 is not set
-CONFIG_ETRAX_DEF_R_WAITSTATES=95a6
-CONFIG_ETRAX_DEF_R_BUS_CONFIG=104
-# CONFIG_ETRAX_SDRAM is not set
-CONFIG_ETRAX_DEF_R_DRAM_CONFIG=1a200040
-CONFIG_ETRAX_DEF_R_DRAM_TIMING=5611
-CONFIG_ETRAX_DEF_R_PORT_PA_DIR=1d
-CONFIG_ETRAX_DEF_R_PORT_PA_DATA=f0
-CONFIG_ETRAX_DEF_R_PORT_PB_CONFIG=00
-CONFIG_ETRAX_DEF_R_PORT_PB_DIR=1e
-CONFIG_ETRAX_DEF_R_PORT_PB_DATA=f3
-# CONFIG_ETRAX_SOFT_SHUTDOWN is not set
-
-#
-# Drivers for ETRAX 100LX built-in interfaces
-#
-CONFIG_ETRAX_ETHERNET=y
-CONFIG_NET_ETHERNET=y
-# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
-CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
-# CONFIG_ETRAX_ETHERNET_LPSLAVE is not set
-CONFIG_ETRAX_SERIAL=y
-CONFIG_ETRAX_SERIAL_PORT0=y
-# CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_ON_PB is not set
-CONFIG_ETRAX_SERIAL_PORT1=y
-# CONFIG_ETRAX_SER1_DTR_RI_DSR_CD_ON_PB is not set
-# CONFIG_ETRAX_SERIAL_PORT2 is not set
-# CONFIG_ETRAX_SERIAL_PORT3 is not set
-# CONFIG_ETRAX_RS485 is not set
-# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
-# CONFIG_ETRAX_IDE is not set
-CONFIG_ETRAX_AXISFLASHMAP=y
-CONFIG_ETRAX_PTABLE_SECTOR=65536
-CONFIG_MTD=y
-CONFIG_MTD_CFI=y
-# CONFIG_MTD_CFI_INTELEXT is not set
-CONFIG_MTD_CFI_AMDSTD=y
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-CONFIG_ETRAX_I2C=y
-CONFIG_ETRAX_I2C_USES_PB_NOT_PB_I2C=y
-# CONFIG_ETRAX_I2C_EEPROM is not set
-CONFIG_ETRAX_GPIO=y
-CONFIG_ETRAX_PA_BUTTON_BITMASK=02
-CONFIG_ETRAX_PA_CHANGEABLE_DIR=00
-CONFIG_ETRAX_PA_CHANGEABLE_BITS=FF
-CONFIG_ETRAX_PB_CHANGEABLE_DIR=00
-CONFIG_ETRAX_PB_CHANGEABLE_BITS=FF
-# CONFIG_ETRAX_USB_HOST is not set
-# CONFIG_USB is not set
-# CONFIG_ETRAX_DS1302 is not set
-
-#
-# Memory Technology Devices (MTD)
-#
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC1000 is not set
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOCPROBE is not set
-
-#
-# RAM/ROM Device Drivers
-#
-# CONFIG_MTD_PMC551 is not set
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_RAM is not set
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_MTDRAM is not set
-
-#
-# Linearly Mapped Flash Device Drivers
-#
-CONFIG_MTD_CFI=y
-# CONFIG_MTD_CFI_GEOMETRY is not set
-# CONFIG_MTD_CFI_INTELEXT is not set
-CONFIG_MTD_CFI_AMDSTD=y
-# CONFIG_MTD_SHARP is not set
-# CONFIG_MTD_PHYSMAP is not set
-# CONFIG_MTD_NORA is not set
-# CONFIG_MTD_PNC2000 is not set
-# CONFIG_MTD_RPXLITE is not set
-# CONFIG_MTD_SC520CDP is not set
-# CONFIG_MTD_SBC_MEDIAGX is not set
-# CONFIG_MTD_ELAN_104NC is not set
-# CONFIG_MTD_SA1100 is not set
-# CONFIG_MTD_DC21285 is not set
-# CONFIG_MTD_CSTM_CFI_JEDEC is not set
-# CONFIG_MTD_JEDEC is not set
-# CONFIG_MTD_MIXMEM is not set
-# CONFIG_MTD_OCTAGON is not set
-# CONFIG_MTD_VMAX is not set
-
-#
-# NAND Flash Device Drivers
-#
-# CONFIG_MTD_NAND is not set
-# CONFIG_MTD_NAND_SPIA is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-
-#
-# Parallel port support
-#
-# CONFIG_PARPORT is not set
-
-#
-# Plug and Play configuration
-#
-# CONFIG_PNP is not set
-# CONFIG_ISAPNP is not set
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_FD is not set
-# CONFIG_BLK_DEV_XD is not set
-# CONFIG_PARIDE is not set
-# CONFIG_BLK_CPQ_DA is not set
-# CONFIG_BLK_CPQ_CISS_DA is not set
-# CONFIG_BLK_DEV_DAC960 is not set
-# CONFIG_BLK_DEV_LOOP is not set
-# CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_RAM is not set
-# CONFIG_BLK_DEV_INITRD is not set
-
-#
-# Networking options
-#
-# CONFIG_PACKET is not set
-# CONFIG_NETLINK is not set
-# CONFIG_NETFILTER is not set
-# CONFIG_FILTER is not set
-CONFIG_UNIX=y
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_INET_ECN is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_IPV6 is not set
-# CONFIG_KHTTPD is not set
-# CONFIG_ATM is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_DECNET is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_LLC is not set
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_HW_FLOWCONTROL is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Telephony Support
-#
-# CONFIG_PHONE is not set
-# CONFIG_PHONE_IXJ is not set
-
-#
-# ATA/IDE/MFM/RLL support
-#
-# CONFIG_IDE is not set
-
-#
-# IDE, ATA and ATAPI Block devices
-#
-# CONFIG_BLK_DEV_IDE is not set
-# CONFIG_BLK_DEV_HD_IDE is not set
-# CONFIG_BLK_DEV_HD is not set
-# CONFIG_BLK_DEV_IDEDISK is not set
-# CONFIG_IDEDISK_MULTI_MODE is not set
-# CONFIG_BLK_DEV_IDECS is not set
-# CONFIG_BLK_DEV_IDECD is not set
-# CONFIG_BLK_DEV_IDETAPE is not set
-# CONFIG_BLK_DEV_IDEFLOPPY is not set
-# CONFIG_BLK_DEV_IDESCSI is not set
-# CONFIG_BLK_DEV_CMD640 is not set
-# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
-# CONFIG_BLK_DEV_ISAPNP is not set
-# CONFIG_IDE_CHIPSETS is not set
-# CONFIG_IDEDMA_AUTO is not set
-# CONFIG_BLK_DEV_IDE_MODES is not set
-
-#
-# SCSI support
-#
-# CONFIG_SCSI is not set
-
-#
-# I2O device support
-#
-# CONFIG_I2O is not set
-# CONFIG_I2O_BLOCK is not set
-# CONFIG_I2O_LAN is not set
-# CONFIG_I2O_SCSI is not set
-# CONFIG_I2O_PROC is not set
-
-#
-# Network device support
-#
-CONFIG_NETDEVICES=y
-
-#
-# ARCnet devices
-#
-# CONFIG_ARCNET is not set
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-# CONFIG_NET_SB1000 is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
-CONFIG_NET_ETHERNET=y
-# CONFIG_NET_VENDOR_3COM is not set
-# CONFIG_LANCE is not set
-# CONFIG_NET_VENDOR_SMC is not set
-# CONFIG_NET_VENDOR_RACAL is not set
-# CONFIG_AT1700 is not set
-# CONFIG_DEPCA is not set
-# CONFIG_NET_ISA is not set
-# CONFIG_NET_PCI is not set
-# CONFIG_NET_POCKET is not set
-
-#
-# Ethernet (1000 Mbit)
-#
-# CONFIG_ACENIC is not set
-# CONFIG_HAMACHI is not set
-# CONFIG_YELLOWFIN is not set
-# CONFIG_SK98LIN is not set
-# CONFIG_FDDI is not set
-# CONFIG_HIPPI is not set
-# CONFIG_PLIP is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-
-#
-# Wireless LAN (non-hamradio)
-#
-# CONFIG_NET_RADIO is not set
-
-#
-# Token Ring devices
-#
-# CONFIG_TR is not set
-# CONFIG_NET_FC is not set
-# CONFIG_RCPCI is not set
-# CONFIG_SHAPER is not set
-
-#
-# Wan interfaces
-#
-# CONFIG_WAN is not set
-
-#
-# Amateur Radio support
-#
-# CONFIG_HAMRADIO is not set
-
-#
-# IrDA (infrared) support
-#
-# CONFIG_IRDA is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN is not set
-
-#
-# CD-ROM drivers (not for SCSI or IDE/ATAPI drives)
-#
-# CONFIG_CD_NO_IDESCSI is not set
-
-#
-# Input core support
-#
-# CONFIG_INPUT is not set
-
-#
-# Character devices
-#
-# CONFIG_VT is not set
-# CONFIG_SERIAL is not set
-# CONFIG_SERIAL_EXTENDED is not set
-# CONFIG_SERIAL_NONSTANDARD is not set
-# CONFIG_UNIX98_PTYS is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# Mice
-#
-# CONFIG_BUSMOUSE is not set
-# CONFIG_MOUSE is not set
-
-#
-# Joysticks
-#
-# CONFIG_JOYSTICK is not set
-# CONFIG_QIC02_TAPE is not set
-
-#
-# Watchdog Cards
-#
-# CONFIG_WATCHDOG is not set
-# CONFIG_INTEL_RNG is not set
-# CONFIG_NVRAM is not set
-# CONFIG_RTC is not set
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-# CONFIG_APPLICOM is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_FTAPE is not set
-# CONFIG_AGP is not set
-# CONFIG_DRM is not set
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-
-#
-# File systems
-#
-# CONFIG_QUOTA is not set
-# CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
-# CONFIG_ADFS_FS is not set
-# CONFIG_ADFS_FS_RW is not set
-# CONFIG_AFFS_FS is not set
-# CONFIG_HFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_FAT_FS is not set
-# CONFIG_MSDOS_FS is not set
-# CONFIG_VFAT_FS is not set
-# CONFIG_EFS_FS is not set
-# CONFIG_JFFS_FS is not set
-CONFIG_CRAMFS=y
-CONFIG_RAMFS=y
-# CONFIG_ISO9660_FS is not set
-# CONFIG_JOLIET is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_NTFS_FS is not set
-# CONFIG_NTFS_DEBUG is not set
-# CONFIG_NTFS_RW is not set
-# CONFIG_HPFS_FS is not set
-CONFIG_PROC_FS=y
-# CONFIG_DEVFS_FS is not set
-# CONFIG_DEVFS_MOUNT is not set
-# CONFIG_DEVFS_DEBUG is not set
-# CONFIG_DEVPTS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_QNX4FS_RW is not set
-# CONFIG_ROMFS_FS is not set
-# CONFIG_EXT2_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_SYSV_FS_WRITE is not set
-# CONFIG_UDF_FS is not set
-# CONFIG_UDF_RW is not set
-# CONFIG_UFS_FS is not set
-# CONFIG_UFS_FS_WRITE is not set
-
-#
-# Network File Systems
-#
-# CONFIG_CODA_FS is not set
-# CONFIG_NFS_FS is not set
-# CONFIG_NFS_V3 is not set
-# CONFIG_ROOT_NFS is not set
-# CONFIG_NFSD is not set
-# CONFIG_NFSD_V3 is not set
-# CONFIG_SUNRPC is not set
-# CONFIG_LOCKD is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_NCPFS_PACKET_SIGNING is not set
-# CONFIG_NCPFS_IOCTL_LOCKING is not set
-# CONFIG_NCPFS_STRONG is not set
-# CONFIG_NCPFS_NFS_NS is not set
-# CONFIG_NCPFS_OS2_NS is not set
-# CONFIG_NCPFS_SMALLDOS is not set
-# CONFIG_NCPFS_MOUNT_SUBDIR is not set
-# CONFIG_NCPFS_NDS_DOMAINS is not set
-# CONFIG_NCPFS_NLS is not set
-# CONFIG_NCPFS_EXTRAS is not set
-
-#
-# Partition Types
-#
-# CONFIG_PARTITION_ADVANCED is not set
-CONFIG_MSDOS_PARTITION=y
-# CONFIG_NLS is not set
-
-#
-# Sound
-#
-# CONFIG_SOUND is not set
-
-#
-# USB support
-#
-# CONFIG_USB is not set
-
-#
-# Kernel hacking
-#
-# CONFIG_PROFILE is not set
diff --git a/arch/cris/artpec_3_defconfig b/arch/cris/artpec_3_defconfig
deleted file mode 100644
index 41fe674..0000000
--- a/arch/cris/artpec_3_defconfig
+++ /dev/null
@@ -1,582 +0,0 @@
-#
-# Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24-rc3
-# Mon Dec  3 11:18:54 2007
-#
-CONFIG_MMU=y
-CONFIG_ZONE_DMA=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_IOMAP=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_GENERIC_FIND_NEXT_BIT=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_NO_IOPORT=y
-CONFIG_FORCE_MAX_ZONEORDER=6
-CONFIG_CRIS=y
-CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
-
-#
-# General setup
-#
-CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION=""
-CONFIG_LOCALVERSION_AUTO=y
-# CONFIG_SWAP is not set
-# CONFIG_SYSVIPC is not set
-# CONFIG_POSIX_MQUEUE is not set
-# CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
-# CONFIG_PID_NS is not set
-# CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_CGROUPS is not set
-CONFIG_FAIR_GROUP_SCHED=y
-CONFIG_FAIR_USER_SCHED=y
-# CONFIG_FAIR_CGROUP_SCHED is not set
-CONFIG_SYSFS_DEPRECATED=y
-# CONFIG_RELAY is not set
-# CONFIG_BLK_DEV_INITRD is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
-CONFIG_UID16=y
-CONFIG_SYSCTL_SYSCALL=y
-# CONFIG_KALLSYMS is not set
-# CONFIG_HOTPLUG is not set
-CONFIG_PRINTK=y
-CONFIG_BUG=y
-CONFIG_ELF_CORE=y
-CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
-CONFIG_EPOLL=y
-CONFIG_SIGNALFD=y
-CONFIG_EVENTFD=y
-CONFIG_SHMEM=y
-CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_SLUB_DEBUG=y
-# CONFIG_SLAB is not set
-CONFIG_SLUB=y
-# CONFIG_SLOB is not set
-CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
-CONFIG_BASE_SMALL=0
-# CONFIG_MODULES is not set
-CONFIG_BLOCK=y
-# CONFIG_LBD is not set
-# CONFIG_BLK_DEV_IO_TRACE is not set
-# CONFIG_LSF is not set
-# CONFIG_BLK_DEV_BSG is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_DEFAULT_AS is not set
-# CONFIG_DEFAULT_DEADLINE is not set
-CONFIG_DEFAULT_CFQ=y
-# CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="cfq"
-
-#
-# General setup
-#
-CONFIG_BINFMT_ELF=y
-# CONFIG_BINFMT_MISC is not set
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
-# CONFIG_ETRAX_WATCHDOG is not set
-CONFIG_ETRAX_FAST_TIMER=y
-# CONFIG_ETRAX_KMALLOCED_MODULES is not set
-# CONFIG_OOM_REBOOT is not set
-CONFIG_PREEMPT_NONE=y
-# CONFIG_PREEMPT_VOLUNTARY is not set
-# CONFIG_PREEMPT is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
-CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
-CONFIG_ZONE_DMA_FLAG=1
-CONFIG_BOUNCE=y
-CONFIG_VIRT_TO_BUS=y
-
-#
-# Hardware setup
-#
-# CONFIG_ETRAX100LX is not set
-# CONFIG_ETRAX100LX_V2 is not set
-# CONFIG_SVINTO_SIM is not set
-# CONFIG_ETRAXFS is not set
-CONFIG_CRIS_MACH_ARTPEC3=y
-# CONFIG_ETRAX_VCS_SIM is not set
-# CONFIG_ETRAX_ARCH_V10 is not set
-CONFIG_ETRAX_ARCH_V32=y
-CONFIG_ETRAX_DRAM_SIZE=32
-CONFIG_ETRAX_VMEM_SIZE=8
-CONFIG_ETRAX_FLASH_BUSWIDTH=2
-CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
-CONFIG_ETRAX_FLASH1_SIZE=4
-CONFIG_ETRAX_DEBUG_PORT0=y
-# CONFIG_ETRAX_DEBUG_PORT1 is not set
-# CONFIG_ETRAX_DEBUG_PORT2 is not set
-# CONFIG_ETRAX_DEBUG_PORT3 is not set
-# CONFIG_ETRAX_DEBUG_PORT_NULL is not set
-CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
-CONFIG_ETRAX_SERIAL_PORTS=5
-CONFIG_ETRAX_DEF_GIO_PA_OE=1c
-CONFIG_ETRAX_DEF_GIO_PA_OUT=00
-CONFIG_ETRAX_DEF_GIO_PB_OE=00000
-CONFIG_ETRAX_DEF_GIO_PB_OUT=00000
-CONFIG_ETRAX_DEF_GIO_PC_OE=00000
-CONFIG_ETRAX_DEF_GIO_PC_OUT=00000
-
-#
-# Artpec-3 options
-#
-CONFIG_ETRAX_L2CACHE=y
-CONFIG_ETRAX_DDR=y
-CONFIG_ETRAX_DDR2_MRS=0
-CONFIG_ETRAX_DDR2_TIMING=0
-CONFIG_ETRAX_DDR2_CONFIG=0
-CONFIG_ETRAX_PIO_CE0_CFG=0
-CONFIG_ETRAX_PIO_CE1_CFG=0
-CONFIG_ETRAX_PIO_CE2_CFG=0
-# CONFIG_CPU_FREQ is not set
-# CONFIG_ETRAX_NBR_LED_GRP_ZERO is not set
-CONFIG_ETRAX_NBR_LED_GRP_ONE=y
-# CONFIG_ETRAX_NBR_LED_GRP_TWO is not set
-CONFIG_ETRAX_LED_G_NET0="PA3"
-CONFIG_ETRAX_LED_R_NET0="PA4"
-CONFIG_ETRAX_V32_LED2G="PA5"
-CONFIG_ETRAX_V32_LED2R="PA6"
-CONFIG_ETRAX_V32_LED3G="PA7"
-CONFIG_ETRAX_V32_LED3R="PA7"
-
-#
-# Networking
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-CONFIG_XFRM=y
-# CONFIG_XFRM_USER is not set
-# CONFIG_XFRM_SUB_POLICY is not set
-# CONFIG_XFRM_MIGRATE is not set
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_FIB_HASH=y
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_XFRM_TUNNEL is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
-# CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
-CONFIG_INET_TCP_DIAG=y
-# CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_CUBIC=y
-CONFIG_DEFAULT_TCP_CONG="cubic"
-# CONFIG_TCP_MD5SIG is not set
-# CONFIG_IP_VS is not set
-# CONFIG_IPV6 is not set
-# CONFIG_INET6_XFRM_TUNNEL is not set
-# CONFIG_INET6_TUNNEL is not set
-# CONFIG_NETWORK_SECMARK is not set
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-
-#
-# Core Netfilter Configuration
-#
-# CONFIG_NETFILTER_NETLINK is not set
-# CONFIG_NF_CONNTRACK_ENABLED is not set
-# CONFIG_NF_CONNTRACK is not set
-# CONFIG_NETFILTER_XTABLES is not set
-
-#
-# IP: Netfilter Configuration
-#
-# CONFIG_IP_NF_QUEUE is not set
-# CONFIG_IP_NF_IPTABLES is not set
-# CONFIG_IP_NF_ARPTABLES is not set
-# CONFIG_IP_DCCP is not set
-# CONFIG_IP_SCTP is not set
-# CONFIG_TIPC is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_AF_RXRPC is not set
-
-#
-# Wireless
-#
-# CONFIG_CFG80211 is not set
-# CONFIG_WIRELESS_EXT is not set
-# CONFIG_MAC80211 is not set
-# CONFIG_IEEE80211 is not set
-# CONFIG_RFKILL is not set
-# CONFIG_NET_9P is not set
-
-#
-# Drivers for built-in interfaces
-#
-CONFIG_ETRAX_ETHERNET=y
-# CONFIG_ETRAX_IDE is not set
-CONFIG_ETRAX_AXISFLASHMAP=y
-CONFIG_ETRAX_PTABLE_SECTOR=65536
-# CONFIG_ETRAX_I2C is not set
-# CONFIG_ETRAX_GPIO is not set
-# CONFIG_ETRAX_NO_PHY is not set
-# CONFIG_ETRAX_ETHERNET_IFACE0 is not set
-# CONFIG_ETRAX_ETHERNET_GBIT is not set
-# CONFIG_ETRAXFS_SERIAL is not set
-# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
-# CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE is not set
-# CONFIG_ETRAX_NANDFLASH is not set
-# CONFIG_ETRAX_CARDBUS is not set
-# CONFIG_ETRAX_IOP_FW_LOAD is not set
-# CONFIG_ETRAX_STREAMCOPROC is not set
-# CONFIG_ETRAX_SPI_MMC is not set
-# CONFIG_ETRAX_SPI_MMC_BOARD is not set
-# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
-CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
-
-#
-# Generic Driver Options
-#
-CONFIG_STANDALONE=y
-CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_SYS_HYPERVISOR is not set
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-# CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLKDEVS=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-# CONFIG_INFTL is not set
-# CONFIG_RFD_FTL is not set
-# CONFIG_SSFDC is not set
-# CONFIG_MTD_OOPS is not set
-
-#
-# RAM/ROM/Flash chip drivers
-#
-CONFIG_MTD_CFI=y
-CONFIG_MTD_JEDECPROBE=y
-CONFIG_MTD_GEN_PROBE=y
-# CONFIG_MTD_CFI_ADV_OPTIONS is not set
-CONFIG_MTD_MAP_BANK_WIDTH_1=y
-CONFIG_MTD_MAP_BANK_WIDTH_2=y
-CONFIG_MTD_MAP_BANK_WIDTH_4=y
-# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
-CONFIG_MTD_CFI_I1=y
-CONFIG_MTD_CFI_I2=y
-# CONFIG_MTD_CFI_I4 is not set
-# CONFIG_MTD_CFI_I8 is not set
-# CONFIG_MTD_CFI_INTELEXT is not set
-CONFIG_MTD_CFI_AMDSTD=y
-# CONFIG_MTD_CFI_STAA is not set
-CONFIG_MTD_CFI_UTIL=y
-CONFIG_MTD_RAM=y
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_ABSENT is not set
-
-#
-# Mapping drivers for chip access
-#
-CONFIG_MTD_COMPLEX_MAPPINGS=y
-# CONFIG_MTD_PHYSMAP is not set
-# CONFIG_MTD_PLATRAM is not set
-
-#
-# Self-contained MTD device drivers
-#
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_PHRAM is not set
-CONFIG_MTD_MTDRAM=y
-CONFIG_MTDRAM_TOTAL_SIZE=0
-CONFIG_MTDRAM_ERASE_SIZE=64
-CONFIG_MTDRAM_ABS_POS=0x0
-# CONFIG_MTD_BLOCK2MTD is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOC2001PLUS is not set
-# CONFIG_MTD_NAND is not set
-# CONFIG_MTD_ONENAND is not set
-
-#
-# UBI - Unsorted block images
-#
-# CONFIG_MTD_UBI is not set
-CONFIG_BLK_DEV=y
-# CONFIG_BLK_DEV_COW_COMMON is not set
-# CONFIG_BLK_DEV_LOOP is not set
-# CONFIG_BLK_DEV_NBD is not set
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=16
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_CDROM_PKTCDVD is not set
-# CONFIG_ATA_OVER_ETH is not set
-CONFIG_NETDEVICES=y
-# CONFIG_NETDEVICES_MULTIQUEUE is not set
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_MACVLAN is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-# CONFIG_VETH is not set
-# CONFIG_PHYLIB is not set
-CONFIG_NET_ETHERNET=y
-CONFIG_MII=y
-# CONFIG_IBM_NEW_EMAC_ZMII is not set
-# CONFIG_IBM_NEW_EMAC_RGMII is not set
-# CONFIG_IBM_NEW_EMAC_TAH is not set
-# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
-CONFIG_NETDEV_1000=y
-CONFIG_NETDEV_10000=y
-
-#
-# Wireless LAN
-#
-# CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
-# CONFIG_WAN is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
-# CONFIG_NETCONSOLE is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_RTC_CLASS is not set
-
-#
-# Input device support
-#
-# CONFIG_INPUT is not set
-
-#
-# Hardware I/O ports
-#
-CONFIG_SERIO=y
-# CONFIG_SERIO_I8042 is not set
-# CONFIG_SERIO_SERPORT is not set
-# CONFIG_SERIO_LIBPS2 is not set
-# CONFIG_SERIO_RAW is not set
-# CONFIG_GAMEPORT is not set
-
-#
-# Character devices
-#
-# CONFIG_VT is not set
-CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
-CONFIG_HW_RANDOM=y
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
-# CONFIG_R3964 is not set
-# CONFIG_RAW_DRIVER is not set
-
-#
-# File systems
-#
-# CONFIG_EXT2_FS is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_EXT4DEV_FS is not set
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_FS_POSIX_ACL is not set
-# CONFIG_XFS_FS is not set
-# CONFIG_GFS2_FS is not set
-# CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
-CONFIG_INOTIFY_USER=y
-# CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
-# CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
-# CONFIG_FUSE_FS is not set
-
-#
-# CD-ROM/DVD Filesystems
-#
-# CONFIG_ISO9660_FS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-# CONFIG_MSDOS_FS is not set
-# CONFIG_VFAT_FS is not set
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-CONFIG_PROC_KCORE=y
-CONFIG_PROC_SYSCTL=y
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-# CONFIG_TMPFS_POSIX_ACL is not set
-# CONFIG_HUGETLB_PAGE is not set
-# CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-# CONFIG_AFFS_FS is not set
-# CONFIG_HFS_FS is not set
-# CONFIG_HFSPLUS_FS is not set
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_JFFS2_FS=y
-CONFIG_JFFS2_FS_DEBUG=0
-CONFIG_JFFS2_FS_WRITEBUFFER=y
-# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
-# CONFIG_JFFS2_SUMMARY is not set
-# CONFIG_JFFS2_FS_XATTR is not set
-# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
-CONFIG_JFFS2_ZLIB=y
-# CONFIG_JFFS2_LZO is not set
-CONFIG_JFFS2_RTIME=y
-# CONFIG_JFFS2_RUBIN is not set
-CONFIG_CRAMFS=y
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-CONFIG_NETWORK_FILESYSTEMS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V3_ACL is not set
-# CONFIG_NFS_V4 is not set
-# CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_NFS_COMMON=y
-CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_BIND34 is not set
-# CONFIG_RPCSEC_GSS_KRB5 is not set
-# CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-# CONFIG_PARTITION_ADVANCED is not set
-CONFIG_MSDOS_PARTITION=y
-# CONFIG_NLS is not set
-# CONFIG_DLM is not set
-
-#
-# Kernel hacking
-#
-# CONFIG_PROFILING is not set
-# CONFIG_SYSTEM_PROFILER is not set
-# CONFIG_PRINTK_TIME is not set
-CONFIG_ENABLE_WARN_DEPRECATED=y
-CONFIG_ENABLE_MUST_CHECK=y
-# CONFIG_MAGIC_SYSRQ is not set
-# CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_HEADERS_CHECK is not set
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_SLUB_DEBUG_ON is not set
-# CONFIG_SAMPLES is not set
-
-#
-# Security options
-#
-# CONFIG_KEYS is not set
-# CONFIG_SECURITY is not set
-# CONFIG_SECURITY_FILE_CAPABILITIES is not set
-# CONFIG_CRYPTO is not set
-
-#
-# Library routines
-#
-CONFIG_BITREVERSE=y
-# CONFIG_CRC_CCITT is not set
-# CONFIG_CRC16 is not set
-# CONFIG_CRC_ITU_T is not set
-CONFIG_CRC32=y
-# CONFIG_CRC7 is not set
-# CONFIG_LIBCRC32C is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-CONFIG_PLIST=y
-CONFIG_HAS_DMA=y
diff --git a/arch/cris/configs/artpec_3_defconfig b/arch/cris/configs/artpec_3_defconfig
new file mode 100644
index 0000000..41fe674
--- /dev/null
+++ b/arch/cris/configs/artpec_3_defconfig
@@ -0,0 +1,582 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24-rc3
+# Mon Dec  3 11:18:54 2007
+#
+CONFIG_MMU=y
+CONFIG_ZONE_DMA=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_GENERIC_IOMAP=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_NO_IOPORT=y
+CONFIG_FORCE_MAX_ZONEORDER=6
+CONFIG_CRIS=y
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
+# CONFIG_SWAP is not set
+# CONFIG_SYSVIPC is not set
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
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
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
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
+CONFIG_SHMEM=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
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
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
+# General setup
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
+# CONFIG_ETRAX_WATCHDOG is not set
+CONFIG_ETRAX_FAST_TIMER=y
+# CONFIG_ETRAX_KMALLOCED_MODULES is not set
+# CONFIG_OOM_REBOOT is not set
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
+
+#
+# Hardware setup
+#
+# CONFIG_ETRAX100LX is not set
+# CONFIG_ETRAX100LX_V2 is not set
+# CONFIG_SVINTO_SIM is not set
+# CONFIG_ETRAXFS is not set
+CONFIG_CRIS_MACH_ARTPEC3=y
+# CONFIG_ETRAX_VCS_SIM is not set
+# CONFIG_ETRAX_ARCH_V10 is not set
+CONFIG_ETRAX_ARCH_V32=y
+CONFIG_ETRAX_DRAM_SIZE=32
+CONFIG_ETRAX_VMEM_SIZE=8
+CONFIG_ETRAX_FLASH_BUSWIDTH=2
+CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
+CONFIG_ETRAX_FLASH1_SIZE=4
+CONFIG_ETRAX_DEBUG_PORT0=y
+# CONFIG_ETRAX_DEBUG_PORT1 is not set
+# CONFIG_ETRAX_DEBUG_PORT2 is not set
+# CONFIG_ETRAX_DEBUG_PORT3 is not set
+# CONFIG_ETRAX_DEBUG_PORT_NULL is not set
+CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
+CONFIG_ETRAX_SERIAL_PORTS=5
+CONFIG_ETRAX_DEF_GIO_PA_OE=1c
+CONFIG_ETRAX_DEF_GIO_PA_OUT=00
+CONFIG_ETRAX_DEF_GIO_PB_OE=00000
+CONFIG_ETRAX_DEF_GIO_PB_OUT=00000
+CONFIG_ETRAX_DEF_GIO_PC_OE=00000
+CONFIG_ETRAX_DEF_GIO_PC_OUT=00000
+
+#
+# Artpec-3 options
+#
+CONFIG_ETRAX_L2CACHE=y
+CONFIG_ETRAX_DDR=y
+CONFIG_ETRAX_DDR2_MRS=0
+CONFIG_ETRAX_DDR2_TIMING=0
+CONFIG_ETRAX_DDR2_CONFIG=0
+CONFIG_ETRAX_PIO_CE0_CFG=0
+CONFIG_ETRAX_PIO_CE1_CFG=0
+CONFIG_ETRAX_PIO_CE2_CFG=0
+# CONFIG_CPU_FREQ is not set
+# CONFIG_ETRAX_NBR_LED_GRP_ZERO is not set
+CONFIG_ETRAX_NBR_LED_GRP_ONE=y
+# CONFIG_ETRAX_NBR_LED_GRP_TWO is not set
+CONFIG_ETRAX_LED_G_NET0="PA3"
+CONFIG_ETRAX_LED_R_NET0="PA4"
+CONFIG_ETRAX_V32_LED2G="PA5"
+CONFIG_ETRAX_V32_LED2R="PA6"
+CONFIG_ETRAX_V32_LED3G="PA7"
+CONFIG_ETRAX_V32_LED3R="PA7"
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
+# Drivers for built-in interfaces
+#
+CONFIG_ETRAX_ETHERNET=y
+# CONFIG_ETRAX_IDE is not set
+CONFIG_ETRAX_AXISFLASHMAP=y
+CONFIG_ETRAX_PTABLE_SECTOR=65536
+# CONFIG_ETRAX_I2C is not set
+# CONFIG_ETRAX_GPIO is not set
+# CONFIG_ETRAX_NO_PHY is not set
+# CONFIG_ETRAX_ETHERNET_IFACE0 is not set
+# CONFIG_ETRAX_ETHERNET_GBIT is not set
+# CONFIG_ETRAXFS_SERIAL is not set
+# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
+# CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE is not set
+# CONFIG_ETRAX_NANDFLASH is not set
+# CONFIG_ETRAX_CARDBUS is not set
+# CONFIG_ETRAX_IOP_FW_LOAD is not set
+# CONFIG_ETRAX_STREAMCOPROC is not set
+# CONFIG_ETRAX_SPI_MMC is not set
+# CONFIG_ETRAX_SPI_MMC_BOARD is not set
+# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
+CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+CONFIG_MTD_CONCAT=y
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
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_GEN_PROBE=y
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
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+CONFIG_MTD_RAM=y
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+CONFIG_MTD_MTDRAM=y
+CONFIG_MTDRAM_TOTAL_SIZE=0
+CONFIG_MTDRAM_ERASE_SIZE=64
+CONFIG_MTDRAM_ABS_POS=0x0
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
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
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
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+# CONFIG_SERIO_I8042 is not set
+# CONFIG_SERIO_SERPORT is not set
+# CONFIG_SERIO_LIBPS2 is not set
+# CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_HW_RANDOM=y
+# CONFIG_RTC is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
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
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
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
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
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
+CONFIG_CRAMFS=y
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PROFILING is not set
+# CONFIG_SYSTEM_PROFILER is not set
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
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_DMA=y
diff --git a/arch/cris/configs/etrax-100lx_defconfig b/arch/cris/configs/etrax-100lx_defconfig
new file mode 100644
index 0000000..572f119
--- /dev/null
+++ b/arch/cris/configs/etrax-100lx_defconfig
@@ -0,0 +1,502 @@
+#
+# Automatically generated make config: don't edit
+#
+CONFIG_UID16=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
+
+#
+# Code maturity level options
+#
+CONFIG_EXPERIMENTAL=y
+
+#
+# General setup
+#
+CONFIG_NET=y
+CONFIG_SYSVIPC=y
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_SYSCTL is not set
+CONFIG_BINFMT_ELF=y
+# CONFIG_ETRAX_KGDB is not set
+# CONFIG_ETRAX_WATCHDOG is not set
+
+#
+# Hardware setup
+#
+CONFIG_ETRAX100LX=y
+# CONFIG_ETRAX100LX_V2 is not set
+# CONFIG_SVINTO_SIM is not set
+CONFIG_CRIS_LOW_MAP=y
+CONFIG_ETRAX_DRAM_VIRTUAL_BASE=60000000
+CONFIG_ETRAX_DRAM_SIZE=8
+CONFIG_ETRAX_FLASH_BUSWIDTH=2
+CONFIG_ETRAX_ROOT_DEVICE="/dev/mtdblock3"
+CONFIG_ETRAX_PA_LEDS=y
+# CONFIG_ETRAX_PB_LEDS is not set
+# CONFIG_ETRAX_CSP0_LEDS is not set
+# CONFIG_ETRAX_NO_LEDS is not set
+CONFIG_ETRAX_LED1G=2
+CONFIG_ETRAX_LED1R=2
+CONFIG_ETRAX_LED2G=2
+CONFIG_ETRAX_LED2R=2
+CONFIG_ETRAX_LED3R=2
+CONFIG_ETRAX_LED3G=2
+CONFIG_ETRAX_LED4R=2
+CONFIG_ETRAX_LED4G=2
+CONFIG_ETRAX_LED5R=2
+CONFIG_ETRAX_LED5G=2
+CONFIG_ETRAX_LED6R=2
+CONFIG_ETRAX_LED6G=2
+CONFIG_ETRAX_LED7R=2
+CONFIG_ETRAX_LED7G=2
+CONFIG_ETRAX_LED8Y=2
+CONFIG_ETRAX_LED9Y=2
+CONFIG_ETRAX_LED10Y=2
+CONFIG_ETRAX_LED11Y=2
+CONFIG_ETRAX_LED12R=2
+CONFIG_ETRAX_DEBUG_PORT0=y
+# CONFIG_ETRAX_DEBUG_PORT1 is not set
+# CONFIG_ETRAX_DEBUG_PORT2 is not set
+# CONFIG_ETRAX_DEBUG_PORT3 is not set
+CONFIG_ETRAX_RESCUE_SER0=y
+# CONFIG_ETRAX_RESCUE_SER1 is not set
+# CONFIG_ETRAX_RESCUE_SER2 is not set
+# CONFIG_ETRAX_RESCUE_SER3 is not set
+CONFIG_ETRAX_DEF_R_WAITSTATES=95a6
+CONFIG_ETRAX_DEF_R_BUS_CONFIG=104
+# CONFIG_ETRAX_SDRAM is not set
+CONFIG_ETRAX_DEF_R_DRAM_CONFIG=1a200040
+CONFIG_ETRAX_DEF_R_DRAM_TIMING=5611
+CONFIG_ETRAX_DEF_R_PORT_PA_DIR=1d
+CONFIG_ETRAX_DEF_R_PORT_PA_DATA=f0
+CONFIG_ETRAX_DEF_R_PORT_PB_CONFIG=00
+CONFIG_ETRAX_DEF_R_PORT_PB_DIR=1e
+CONFIG_ETRAX_DEF_R_PORT_PB_DATA=f3
+# CONFIG_ETRAX_SOFT_SHUTDOWN is not set
+
+#
+# Drivers for ETRAX 100LX built-in interfaces
+#
+CONFIG_ETRAX_ETHERNET=y
+CONFIG_NET_ETHERNET=y
+# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
+CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
+# CONFIG_ETRAX_ETHERNET_LPSLAVE is not set
+CONFIG_ETRAX_SERIAL=y
+CONFIG_ETRAX_SERIAL_PORT0=y
+# CONFIG_ETRAX_SER0_DTR_RI_DSR_CD_ON_PB is not set
+CONFIG_ETRAX_SERIAL_PORT1=y
+# CONFIG_ETRAX_SER1_DTR_RI_DSR_CD_ON_PB is not set
+# CONFIG_ETRAX_SERIAL_PORT2 is not set
+# CONFIG_ETRAX_SERIAL_PORT3 is not set
+# CONFIG_ETRAX_RS485 is not set
+# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
+# CONFIG_ETRAX_IDE is not set
+CONFIG_ETRAX_AXISFLASHMAP=y
+CONFIG_ETRAX_PTABLE_SECTOR=65536
+CONFIG_MTD=y
+CONFIG_MTD_CFI=y
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+CONFIG_ETRAX_I2C=y
+CONFIG_ETRAX_I2C_USES_PB_NOT_PB_I2C=y
+# CONFIG_ETRAX_I2C_EEPROM is not set
+CONFIG_ETRAX_GPIO=y
+CONFIG_ETRAX_PA_BUTTON_BITMASK=02
+CONFIG_ETRAX_PA_CHANGEABLE_DIR=00
+CONFIG_ETRAX_PA_CHANGEABLE_BITS=FF
+CONFIG_ETRAX_PB_CHANGEABLE_DIR=00
+CONFIG_ETRAX_PB_CHANGEABLE_BITS=FF
+# CONFIG_ETRAX_USB_HOST is not set
+# CONFIG_USB is not set
+# CONFIG_ETRAX_DS1302 is not set
+
+#
+# Memory Technology Devices (MTD)
+#
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+
+#
+# Disk-On-Chip Device Drivers
+#
+# CONFIG_MTD_DOC1000 is not set
+# CONFIG_MTD_DOC2000 is not set
+# CONFIG_MTD_DOC2001 is not set
+# CONFIG_MTD_DOCPROBE is not set
+
+#
+# RAM/ROM Device Drivers
+#
+# CONFIG_MTD_PMC551 is not set
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_MTDRAM is not set
+
+#
+# Linearly Mapped Flash Device Drivers
+#
+CONFIG_MTD_CFI=y
+# CONFIG_MTD_CFI_GEOMETRY is not set
+# CONFIG_MTD_CFI_INTELEXT is not set
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_SHARP is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_NORA is not set
+# CONFIG_MTD_PNC2000 is not set
+# CONFIG_MTD_RPXLITE is not set
+# CONFIG_MTD_SC520CDP is not set
+# CONFIG_MTD_SBC_MEDIAGX is not set
+# CONFIG_MTD_ELAN_104NC is not set
+# CONFIG_MTD_SA1100 is not set
+# CONFIG_MTD_DC21285 is not set
+# CONFIG_MTD_CSTM_CFI_JEDEC is not set
+# CONFIG_MTD_JEDEC is not set
+# CONFIG_MTD_MIXMEM is not set
+# CONFIG_MTD_OCTAGON is not set
+# CONFIG_MTD_VMAX is not set
+
+#
+# NAND Flash Device Drivers
+#
+# CONFIG_MTD_NAND is not set
+# CONFIG_MTD_NAND_SPIA is not set
+
+#
+# User Modules And Translation Layers
+#
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLOCK=y
+# CONFIG_FTL is not set
+# CONFIG_NFTL is not set
+
+#
+# Parallel port support
+#
+# CONFIG_PARPORT is not set
+
+#
+# Plug and Play configuration
+#
+# CONFIG_PNP is not set
+# CONFIG_ISAPNP is not set
+
+#
+# Block devices
+#
+# CONFIG_BLK_DEV_FD is not set
+# CONFIG_BLK_DEV_XD is not set
+# CONFIG_PARIDE is not set
+# CONFIG_BLK_CPQ_DA is not set
+# CONFIG_BLK_CPQ_CISS_DA is not set
+# CONFIG_BLK_DEV_DAC960 is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_RAM is not set
+# CONFIG_BLK_DEV_INITRD is not set
+
+#
+# Networking options
+#
+# CONFIG_PACKET is not set
+# CONFIG_NETLINK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_FILTER is not set
+CONFIG_UNIX=y
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+# CONFIG_IP_PNP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_INET_ECN is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_IPV6 is not set
+# CONFIG_KHTTPD is not set
+# CONFIG_ATM is not set
+# CONFIG_IPX is not set
+# CONFIG_ATALK is not set
+# CONFIG_DECNET is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_X25 is not set
+# CONFIG_LAPB is not set
+# CONFIG_LLC is not set
+# CONFIG_NET_DIVERT is not set
+# CONFIG_ECONET is not set
+# CONFIG_WAN_ROUTER is not set
+# CONFIG_NET_HW_FLOWCONTROL is not set
+
+#
+# QoS and/or fair queueing
+#
+# CONFIG_NET_SCHED is not set
+
+#
+# Telephony Support
+#
+# CONFIG_PHONE is not set
+# CONFIG_PHONE_IXJ is not set
+
+#
+# ATA/IDE/MFM/RLL support
+#
+# CONFIG_IDE is not set
+
+#
+# IDE, ATA and ATAPI Block devices
+#
+# CONFIG_BLK_DEV_IDE is not set
+# CONFIG_BLK_DEV_HD_IDE is not set
+# CONFIG_BLK_DEV_HD is not set
+# CONFIG_BLK_DEV_IDEDISK is not set
+# CONFIG_IDEDISK_MULTI_MODE is not set
+# CONFIG_BLK_DEV_IDECS is not set
+# CONFIG_BLK_DEV_IDECD is not set
+# CONFIG_BLK_DEV_IDETAPE is not set
+# CONFIG_BLK_DEV_IDEFLOPPY is not set
+# CONFIG_BLK_DEV_IDESCSI is not set
+# CONFIG_BLK_DEV_CMD640 is not set
+# CONFIG_BLK_DEV_CMD640_ENHANCED is not set
+# CONFIG_BLK_DEV_ISAPNP is not set
+# CONFIG_IDE_CHIPSETS is not set
+# CONFIG_IDEDMA_AUTO is not set
+# CONFIG_BLK_DEV_IDE_MODES is not set
+
+#
+# SCSI support
+#
+# CONFIG_SCSI is not set
+
+#
+# I2O device support
+#
+# CONFIG_I2O is not set
+# CONFIG_I2O_BLOCK is not set
+# CONFIG_I2O_LAN is not set
+# CONFIG_I2O_SCSI is not set
+# CONFIG_I2O_PROC is not set
+
+#
+# Network device support
+#
+CONFIG_NETDEVICES=y
+
+#
+# ARCnet devices
+#
+# CONFIG_ARCNET is not set
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_NET_SB1000 is not set
+
+#
+# Ethernet (10 or 100Mbit)
+#
+CONFIG_NET_ETHERNET=y
+# CONFIG_NET_VENDOR_3COM is not set
+# CONFIG_LANCE is not set
+# CONFIG_NET_VENDOR_SMC is not set
+# CONFIG_NET_VENDOR_RACAL is not set
+# CONFIG_AT1700 is not set
+# CONFIG_DEPCA is not set
+# CONFIG_NET_ISA is not set
+# CONFIG_NET_PCI is not set
+# CONFIG_NET_POCKET is not set
+
+#
+# Ethernet (1000 Mbit)
+#
+# CONFIG_ACENIC is not set
+# CONFIG_HAMACHI is not set
+# CONFIG_YELLOWFIN is not set
+# CONFIG_SK98LIN is not set
+# CONFIG_FDDI is not set
+# CONFIG_HIPPI is not set
+# CONFIG_PLIP is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+
+#
+# Wireless LAN (non-hamradio)
+#
+# CONFIG_NET_RADIO is not set
+
+#
+# Token Ring devices
+#
+# CONFIG_TR is not set
+# CONFIG_NET_FC is not set
+# CONFIG_RCPCI is not set
+# CONFIG_SHAPER is not set
+
+#
+# Wan interfaces
+#
+# CONFIG_WAN is not set
+
+#
+# Amateur Radio support
+#
+# CONFIG_HAMRADIO is not set
+
+#
+# IrDA (infrared) support
+#
+# CONFIG_IRDA is not set
+
+#
+# ISDN subsystem
+#
+# CONFIG_ISDN is not set
+
+#
+# CD-ROM drivers (not for SCSI or IDE/ATAPI drives)
+#
+# CONFIG_CD_NO_IDESCSI is not set
+
+#
+# Input core support
+#
+# CONFIG_INPUT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+# CONFIG_SERIAL is not set
+# CONFIG_SERIAL_EXTENDED is not set
+# CONFIG_SERIAL_NONSTANDARD is not set
+# CONFIG_UNIX98_PTYS is not set
+
+#
+# I2C support
+#
+# CONFIG_I2C is not set
+
+#
+# Mice
+#
+# CONFIG_BUSMOUSE is not set
+# CONFIG_MOUSE is not set
+
+#
+# Joysticks
+#
+# CONFIG_JOYSTICK is not set
+# CONFIG_QIC02_TAPE is not set
+
+#
+# Watchdog Cards
+#
+# CONFIG_WATCHDOG is not set
+# CONFIG_INTEL_RNG is not set
+# CONFIG_NVRAM is not set
+# CONFIG_RTC is not set
+# CONFIG_DTLK is not set
+# CONFIG_R3964 is not set
+# CONFIG_APPLICOM is not set
+
+#
+# Ftape, the floppy tape device driver
+#
+# CONFIG_FTAPE is not set
+# CONFIG_AGP is not set
+# CONFIG_DRM is not set
+
+#
+# Multimedia devices
+#
+# CONFIG_VIDEO_DEV is not set
+
+#
+# File systems
+#
+# CONFIG_QUOTA is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_ADFS_FS is not set
+# CONFIG_ADFS_FS_RW is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_FAT_FS is not set
+# CONFIG_MSDOS_FS is not set
+# CONFIG_VFAT_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_JFFS_FS is not set
+CONFIG_CRAMFS=y
+CONFIG_RAMFS=y
+# CONFIG_ISO9660_FS is not set
+# CONFIG_JOLIET is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_NTFS_FS is not set
+# CONFIG_NTFS_DEBUG is not set
+# CONFIG_NTFS_RW is not set
+# CONFIG_HPFS_FS is not set
+CONFIG_PROC_FS=y
+# CONFIG_DEVFS_FS is not set
+# CONFIG_DEVFS_MOUNT is not set
+# CONFIG_DEVFS_DEBUG is not set
+# CONFIG_DEVPTS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_QNX4FS_RW is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_EXT2_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_SYSV_FS_WRITE is not set
+# CONFIG_UDF_FS is not set
+# CONFIG_UDF_RW is not set
+# CONFIG_UFS_FS is not set
+# CONFIG_UFS_FS_WRITE is not set
+
+#
+# Network File Systems
+#
+# CONFIG_CODA_FS is not set
+# CONFIG_NFS_FS is not set
+# CONFIG_NFS_V3 is not set
+# CONFIG_ROOT_NFS is not set
+# CONFIG_NFSD is not set
+# CONFIG_NFSD_V3 is not set
+# CONFIG_SUNRPC is not set
+# CONFIG_LOCKD is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_NCPFS_PACKET_SIGNING is not set
+# CONFIG_NCPFS_IOCTL_LOCKING is not set
+# CONFIG_NCPFS_STRONG is not set
+# CONFIG_NCPFS_NFS_NS is not set
+# CONFIG_NCPFS_OS2_NS is not set
+# CONFIG_NCPFS_SMALLDOS is not set
+# CONFIG_NCPFS_MOUNT_SUBDIR is not set
+# CONFIG_NCPFS_NDS_DOMAINS is not set
+# CONFIG_NCPFS_NLS is not set
+# CONFIG_NCPFS_EXTRAS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+
+#
+# Sound
+#
+# CONFIG_SOUND is not set
+
+#
+# USB support
+#
+# CONFIG_USB is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PROFILE is not set
diff --git a/arch/cris/configs/etrax-100lx_v2_defconfig b/arch/cris/configs/etrax-100lx_v2_defconfig
new file mode 100644
index 0000000..59f36a5
--- /dev/null
+++ b/arch/cris/configs/etrax-100lx_v2_defconfig
@@ -0,0 +1,580 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24-rc3
+# Mon Dec  3 11:34:27 2007
+#
+CONFIG_MMU=y
+CONFIG_ZONE_DMA=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_GENERIC_IOMAP=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_NO_IOPORT=y
+CONFIG_FORCE_MAX_ZONEORDER=6
+CONFIG_CRIS=y
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
+# CONFIG_SWAP is not set
+# CONFIG_SYSVIPC is not set
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
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
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
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
+CONFIG_SHMEM=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
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
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
+# General setup
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
+# CONFIG_ETRAX_WATCHDOG is not set
+CONFIG_ETRAX_FAST_TIMER=y
+# CONFIG_ETRAX_KMALLOCED_MODULES is not set
+# CONFIG_OOM_REBOOT is not set
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
+
+#
+# Hardware setup
+#
+# CONFIG_ETRAX100LX is not set
+CONFIG_ETRAX100LX_V2=y
+# CONFIG_SVINTO_SIM is not set
+# CONFIG_ETRAXFS is not set
+# CONFIG_CRIS_MACH_ARTPEC3 is not set
+# CONFIG_ETRAX_VCS_SIM is not set
+CONFIG_ETRAX_ARCH_V10=y
+# CONFIG_ETRAX_ARCH_V32 is not set
+CONFIG_ETRAX_DRAM_SIZE=32
+CONFIG_ETRAX_FLASH_BUSWIDTH=2
+CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
+CONFIG_ETRAX_FLASH1_SIZE=4
+# CONFIG_ETRAX_DEBUG_PORT0 is not set
+# CONFIG_ETRAX_DEBUG_PORT1 is not set
+# CONFIG_ETRAX_DEBUG_PORT2 is not set
+# CONFIG_ETRAX_DEBUG_PORT3 is not set
+CONFIG_ETRAX_DEBUG_PORT_NULL=y
+
+#
+# CRIS v10 options
+#
+CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
+CONFIG_ETRAX_PA_LEDS=y
+# CONFIG_ETRAX_PB_LEDS is not set
+# CONFIG_ETRAX_CSP0_LEDS is not set
+# CONFIG_ETRAX_NO_LEDS is not set
+CONFIG_ETRAX_LED1G=2
+CONFIG_ETRAX_LED1R=3
+CONFIG_ETRAX_LED2G=4
+CONFIG_ETRAX_LED2R=5
+CONFIG_ETRAX_LED3G=2
+CONFIG_ETRAX_LED3R=2
+CONFIG_ETRAX_RESCUE_SER0=y
+# CONFIG_ETRAX_RESCUE_SER1 is not set
+# CONFIG_ETRAX_RESCUE_SER2 is not set
+# CONFIG_ETRAX_RESCUE_SER3 is not set
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
+# CONFIG_ETRAX_SOFT_SHUTDOWN is not set
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
+# Drivers for built-in interfaces
+#
+CONFIG_ETRAX_ETHERNET=y
+CONFIG_ETRAX_SERIAL=y
+# CONFIG_ETRAX_SERIAL_FAST_TIMER is not set
+# CONFIG_ETRAX_SERIAL_FLUSH_DMA_FAST is not set
+CONFIG_ETRAX_SERIAL_RX_TIMEOUT_TICKS=5
+# CONFIG_ETRAX_SERIAL_PORT0 is not set
+# CONFIG_ETRAX_SERIAL_PORT1 is not set
+# CONFIG_ETRAX_SERIAL_PORT2 is not set
+# CONFIG_ETRAX_SERIAL_PORT3 is not set
+# CONFIG_ETRAX_RS485 is not set
+# CONFIG_ETRAX_IDE is not set
+# CONFIG_ETRAX_USB_HOST is not set
+CONFIG_ETRAX_AXISFLASHMAP=y
+CONFIG_ETRAX_PTABLE_SECTOR=65536
+# CONFIG_ETRAX_I2C is not set
+# CONFIG_ETRAX_GPIO is not set
+# CONFIG_ETRAX_RTC is not set
+# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
+CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+CONFIG_MTD_CONCAT=y
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
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_GEN_PROBE=y
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
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+CONFIG_MTD_RAM=y
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+CONFIG_MTD_MTDRAM=y
+CONFIG_MTDRAM_TOTAL_SIZE=0
+CONFIG_MTDRAM_ERASE_SIZE=64
+CONFIG_MTDRAM_ABS_POS=0x0
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
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
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
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+# CONFIG_SERIO_I8042 is not set
+# CONFIG_SERIO_SERPORT is not set
+# CONFIG_SERIO_LIBPS2 is not set
+# CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_HW_RANDOM=y
+# CONFIG_RTC is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
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
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
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
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
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
+CONFIG_CRAMFS=y
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PROFILING is not set
+# CONFIG_SYSTEM_PROFILER is not set
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
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_DMA=y
diff --git a/arch/cris/configs/etraxfs_defconfig b/arch/cris/configs/etraxfs_defconfig
new file mode 100644
index 0000000..73c646a
--- /dev/null
+++ b/arch/cris/configs/etraxfs_defconfig
@@ -0,0 +1,585 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.24-rc3
+# Fri Nov 30 14:24:26 2007
+#
+CONFIG_MMU=y
+CONFIG_ZONE_DMA=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_GENERIC_IOMAP=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_NO_IOPORT=y
+CONFIG_FORCE_MAX_ZONEORDER=6
+CONFIG_CRIS=y
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
+# CONFIG_SWAP is not set
+# CONFIG_SYSVIPC is not set
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_AUDIT is not set
+# CONFIG_IKCONFIG is not set
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
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
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
+CONFIG_SHMEM=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
+# CONFIG_TINY_SHMEM is not set
+CONFIG_BASE_SMALL=0
+# CONFIG_MODULES is not set
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
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+
+#
+# General setup
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_BINFMT_MISC is not set
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
+# CONFIG_ETRAX_WATCHDOG is not set
+CONFIG_ETRAX_FAST_TIMER=y
+# CONFIG_ETRAX_KMALLOCED_MODULES is not set
+# CONFIG_OOM_REBOOT is not set
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
+
+#
+# Hardware setup
+#
+# CONFIG_ETRAX100LX is not set
+# CONFIG_ETRAX100LX_V2 is not set
+# CONFIG_SVINTO_SIM is not set
+CONFIG_ETRAXFS=y
+# CONFIG_CRIS_MACH_ARTPEC3 is not set
+# CONFIG_ETRAX_VCS_SIM is not set
+# CONFIG_ETRAX_ARCH_V10 is not set
+CONFIG_ETRAX_ARCH_V32=y
+CONFIG_ETRAX_DRAM_SIZE=32
+CONFIG_ETRAX_FLASH_BUSWIDTH=2
+CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
+CONFIG_ETRAX_FLASH1_SIZE=4
+CONFIG_ETRAX_DEBUG_PORT0=y
+# CONFIG_ETRAX_DEBUG_PORT1 is not set
+# CONFIG_ETRAX_DEBUG_PORT2 is not set
+# CONFIG_ETRAX_DEBUG_PORT3 is not set
+# CONFIG_ETRAX_DEBUG_PORT_NULL is not set
+CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
+
+#
+# ETRAX FS options
+#
+CONFIG_ETRAX_SERIAL_PORTS=4
+CONFIG_ETRAX_MEM_GRP1_CONFIG=4044a
+CONFIG_ETRAX_MEM_GRP2_CONFIG=0
+CONFIG_ETRAX_MEM_GRP3_CONFIG=0
+CONFIG_ETRAX_MEM_GRP4_CONFIG=0
+CONFIG_ETRAX_SDRAM_GRP0_CONFIG=336
+CONFIG_ETRAX_SDRAM_GRP1_CONFIG=0
+CONFIG_ETRAX_SDRAM_TIMING=104a
+CONFIG_ETRAX_SDRAM_COMMAND=0
+CONFIG_ETRAX_DEF_GIO_PA_OE=1c
+CONFIG_ETRAX_DEF_GIO_PA_OUT=00
+CONFIG_ETRAX_DEF_GIO_PB_OE=00000
+CONFIG_ETRAX_DEF_GIO_PB_OUT=00000
+CONFIG_ETRAX_DEF_GIO_PC_OE=00000
+CONFIG_ETRAX_DEF_GIO_PC_OUT=00000
+CONFIG_ETRAX_DEF_GIO_PD_OE=00000
+CONFIG_ETRAX_DEF_GIO_PD_OUT=00000
+CONFIG_ETRAX_DEF_GIO_PE_OE=00000
+CONFIG_ETRAX_DEF_GIO_PE_OUT=00000
+# CONFIG_CPU_FREQ is not set
+# CONFIG_ETRAX_NBR_LED_GRP_ZERO is not set
+CONFIG_ETRAX_NBR_LED_GRP_ONE=y
+# CONFIG_ETRAX_NBR_LED_GRP_TWO is not set
+CONFIG_ETRAX_LED_G_NET0="PA3"
+CONFIG_ETRAX_LED_R_NET0="PA4"
+CONFIG_ETRAX_V32_LED2G="PA5"
+CONFIG_ETRAX_V32_LED2R="PA6"
+CONFIG_ETRAX_V32_LED3G="PA7"
+CONFIG_ETRAX_V32_LED3R="PA7"
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
+# Drivers for built-in interfaces
+#
+CONFIG_ETRAX_ETHERNET=y
+# CONFIG_ETRAX_IDE is not set
+CONFIG_ETRAX_AXISFLASHMAP=y
+CONFIG_ETRAX_PTABLE_SECTOR=65536
+# CONFIG_ETRAX_I2C is not set
+# CONFIG_ETRAX_GPIO is not set
+# CONFIG_ETRAX_NO_PHY is not set
+# CONFIG_ETRAX_ETHERNET_IFACE0 is not set
+# CONFIG_ETRAX_ETHERNET_IFACE1 is not set
+# CONFIG_ETRAXFS_SERIAL is not set
+# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
+# CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE is not set
+# CONFIG_ETRAX_NANDFLASH is not set
+# CONFIG_ETRAX_CARDBUS is not set
+# CONFIG_ETRAX_IOP_FW_LOAD is not set
+# CONFIG_ETRAX_STREAMCOPROC is not set
+# CONFIG_ETRAX_SPI_MMC is not set
+# CONFIG_ETRAX_SPI_MMC_BOARD is not set
+# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
+CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
+
+#
+# Generic Driver Options
+#
+CONFIG_STANDALONE=y
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+# CONFIG_SYS_HYPERVISOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+CONFIG_MTD_CONCAT=y
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
+CONFIG_MTD_CFI=y
+CONFIG_MTD_JEDECPROBE=y
+CONFIG_MTD_GEN_PROBE=y
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
+CONFIG_MTD_CFI_AMDSTD=y
+# CONFIG_MTD_CFI_STAA is not set
+CONFIG_MTD_CFI_UTIL=y
+CONFIG_MTD_RAM=y
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+
+#
+# Mapping drivers for chip access
+#
+CONFIG_MTD_COMPLEX_MAPPINGS=y
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
+# CONFIG_MTD_SLRAM is not set
+# CONFIG_MTD_PHRAM is not set
+CONFIG_MTD_MTDRAM=y
+CONFIG_MTDRAM_TOTAL_SIZE=0
+CONFIG_MTDRAM_ERASE_SIZE=64
+CONFIG_MTDRAM_ABS_POS=0x0
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
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+# CONFIG_BLK_DEV_LOOP is not set
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=4096
+CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
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
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+CONFIG_NETDEV_1000=y
+CONFIG_NETDEV_10000=y
+
+#
+# Wireless LAN
+#
+# CONFIG_WLAN_PRE80211 is not set
+# CONFIG_WLAN_80211 is not set
+# CONFIG_WAN is not set
+# CONFIG_PPP is not set
+# CONFIG_SLIP is not set
+# CONFIG_SHAPER is not set
+# CONFIG_NETCONSOLE is not set
+# CONFIG_NETPOLL is not set
+# CONFIG_NET_POLL_CONTROLLER is not set
+# CONFIG_RTC_CLASS is not set
+
+#
+# Input device support
+#
+# CONFIG_INPUT is not set
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+# CONFIG_SERIO_I8042 is not set
+# CONFIG_SERIO_SERPORT is not set
+# CONFIG_SERIO_LIBPS2 is not set
+# CONFIG_SERIO_RAW is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+# CONFIG_VT is not set
+CONFIG_UNIX98_PTYS=y
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+CONFIG_HW_RANDOM=y
+# CONFIG_RTC is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+# CONFIG_RAW_DRIVER is not set
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
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_ROMFS_FS is not set
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_DNOTIFY=y
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
+CONFIG_PROC_KCORE=y
+CONFIG_PROC_SYSCTL=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
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
+CONFIG_CRAMFS=y
+# CONFIG_VXFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+# CONFIG_NFS_V3_ACL is not set
+# CONFIG_NFS_V4 is not set
+# CONFIG_NFS_DIRECTIO is not set
+# CONFIG_NFSD is not set
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_BIND34 is not set
+# CONFIG_RPCSEC_GSS_KRB5 is not set
+# CONFIG_RPCSEC_GSS_SPKM3 is not set
+# CONFIG_SMB_FS is not set
+# CONFIG_CIFS is not set
+# CONFIG_NCP_FS is not set
+# CONFIG_CODA_FS is not set
+# CONFIG_AFS_FS is not set
+
+#
+# Partition Types
+#
+# CONFIG_PARTITION_ADVANCED is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_NLS is not set
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PROFILING is not set
+# CONFIG_SYSTEM_PROFILER is not set
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
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITY_FILE_CAPABILITIES is not set
+# CONFIG_CRYPTO is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_DMA=y
diff --git a/arch/cris/defconfig b/arch/cris/defconfig
deleted file mode 100644
index 59f36a5..0000000
--- a/arch/cris/defconfig
+++ /dev/null
@@ -1,580 +0,0 @@
-#
-# Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24-rc3
-# Mon Dec  3 11:34:27 2007
-#
-CONFIG_MMU=y
-CONFIG_ZONE_DMA=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_IOMAP=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_GENERIC_FIND_NEXT_BIT=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_NO_IOPORT=y
-CONFIG_FORCE_MAX_ZONEORDER=6
-CONFIG_CRIS=y
-CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
-
-#
-# General setup
-#
-CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION=""
-CONFIG_LOCALVERSION_AUTO=y
-# CONFIG_SWAP is not set
-# CONFIG_SYSVIPC is not set
-# CONFIG_POSIX_MQUEUE is not set
-# CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
-# CONFIG_PID_NS is not set
-# CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_CGROUPS is not set
-CONFIG_FAIR_GROUP_SCHED=y
-CONFIG_FAIR_USER_SCHED=y
-# CONFIG_FAIR_CGROUP_SCHED is not set
-CONFIG_SYSFS_DEPRECATED=y
-# CONFIG_RELAY is not set
-# CONFIG_BLK_DEV_INITRD is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
-CONFIG_UID16=y
-CONFIG_SYSCTL_SYSCALL=y
-# CONFIG_KALLSYMS is not set
-# CONFIG_HOTPLUG is not set
-CONFIG_PRINTK=y
-CONFIG_BUG=y
-CONFIG_ELF_CORE=y
-CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
-CONFIG_EPOLL=y
-CONFIG_SIGNALFD=y
-CONFIG_EVENTFD=y
-CONFIG_SHMEM=y
-CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_SLUB_DEBUG=y
-# CONFIG_SLAB is not set
-CONFIG_SLUB=y
-# CONFIG_SLOB is not set
-CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
-CONFIG_BASE_SMALL=0
-# CONFIG_MODULES is not set
-CONFIG_BLOCK=y
-# CONFIG_LBD is not set
-# CONFIG_BLK_DEV_IO_TRACE is not set
-# CONFIG_LSF is not set
-# CONFIG_BLK_DEV_BSG is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_DEFAULT_AS is not set
-# CONFIG_DEFAULT_DEADLINE is not set
-CONFIG_DEFAULT_CFQ=y
-# CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="cfq"
-
-#
-# General setup
-#
-CONFIG_BINFMT_ELF=y
-# CONFIG_BINFMT_MISC is not set
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
-# CONFIG_ETRAX_WATCHDOG is not set
-CONFIG_ETRAX_FAST_TIMER=y
-# CONFIG_ETRAX_KMALLOCED_MODULES is not set
-# CONFIG_OOM_REBOOT is not set
-CONFIG_PREEMPT_NONE=y
-# CONFIG_PREEMPT_VOLUNTARY is not set
-# CONFIG_PREEMPT is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
-CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
-CONFIG_ZONE_DMA_FLAG=1
-CONFIG_BOUNCE=y
-CONFIG_VIRT_TO_BUS=y
-
-#
-# Hardware setup
-#
-# CONFIG_ETRAX100LX is not set
-CONFIG_ETRAX100LX_V2=y
-# CONFIG_SVINTO_SIM is not set
-# CONFIG_ETRAXFS is not set
-# CONFIG_CRIS_MACH_ARTPEC3 is not set
-# CONFIG_ETRAX_VCS_SIM is not set
-CONFIG_ETRAX_ARCH_V10=y
-# CONFIG_ETRAX_ARCH_V32 is not set
-CONFIG_ETRAX_DRAM_SIZE=32
-CONFIG_ETRAX_FLASH_BUSWIDTH=2
-CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
-CONFIG_ETRAX_FLASH1_SIZE=4
-# CONFIG_ETRAX_DEBUG_PORT0 is not set
-# CONFIG_ETRAX_DEBUG_PORT1 is not set
-# CONFIG_ETRAX_DEBUG_PORT2 is not set
-# CONFIG_ETRAX_DEBUG_PORT3 is not set
-CONFIG_ETRAX_DEBUG_PORT_NULL=y
-
-#
-# CRIS v10 options
-#
-CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
-CONFIG_ETRAX_PA_LEDS=y
-# CONFIG_ETRAX_PB_LEDS is not set
-# CONFIG_ETRAX_CSP0_LEDS is not set
-# CONFIG_ETRAX_NO_LEDS is not set
-CONFIG_ETRAX_LED1G=2
-CONFIG_ETRAX_LED1R=3
-CONFIG_ETRAX_LED2G=4
-CONFIG_ETRAX_LED2R=5
-CONFIG_ETRAX_LED3G=2
-CONFIG_ETRAX_LED3R=2
-CONFIG_ETRAX_RESCUE_SER0=y
-# CONFIG_ETRAX_RESCUE_SER1 is not set
-# CONFIG_ETRAX_RESCUE_SER2 is not set
-# CONFIG_ETRAX_RESCUE_SER3 is not set
-CONFIG_ETRAX_DEF_R_WAITSTATES=95a6
-CONFIG_ETRAX_DEF_R_BUS_CONFIG=104
-# CONFIG_ETRAX_SDRAM is not set
-CONFIG_ETRAX_DEF_R_DRAM_CONFIG=1a200040
-CONFIG_ETRAX_DEF_R_DRAM_TIMING=5611
-CONFIG_ETRAX_DEF_R_PORT_PA_DIR=1c
-CONFIG_ETRAX_DEF_R_PORT_PA_DATA=00
-CONFIG_ETRAX_DEF_R_PORT_PB_CONFIG=00
-CONFIG_ETRAX_DEF_R_PORT_PB_DIR=00
-CONFIG_ETRAX_DEF_R_PORT_PB_DATA=ff
-# CONFIG_ETRAX_SOFT_SHUTDOWN is not set
-
-#
-# Networking
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-CONFIG_XFRM=y
-# CONFIG_XFRM_USER is not set
-# CONFIG_XFRM_SUB_POLICY is not set
-# CONFIG_XFRM_MIGRATE is not set
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_FIB_HASH=y
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_XFRM_TUNNEL is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
-# CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
-CONFIG_INET_TCP_DIAG=y
-# CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_CUBIC=y
-CONFIG_DEFAULT_TCP_CONG="cubic"
-# CONFIG_TCP_MD5SIG is not set
-# CONFIG_IP_VS is not set
-# CONFIG_IPV6 is not set
-# CONFIG_INET6_XFRM_TUNNEL is not set
-# CONFIG_INET6_TUNNEL is not set
-# CONFIG_NETWORK_SECMARK is not set
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-
-#
-# Core Netfilter Configuration
-#
-# CONFIG_NETFILTER_NETLINK is not set
-# CONFIG_NF_CONNTRACK_ENABLED is not set
-# CONFIG_NF_CONNTRACK is not set
-# CONFIG_NETFILTER_XTABLES is not set
-
-#
-# IP: Netfilter Configuration
-#
-# CONFIG_IP_NF_QUEUE is not set
-# CONFIG_IP_NF_IPTABLES is not set
-# CONFIG_IP_NF_ARPTABLES is not set
-# CONFIG_IP_DCCP is not set
-# CONFIG_IP_SCTP is not set
-# CONFIG_TIPC is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_AF_RXRPC is not set
-
-#
-# Wireless
-#
-# CONFIG_CFG80211 is not set
-# CONFIG_WIRELESS_EXT is not set
-# CONFIG_MAC80211 is not set
-# CONFIG_IEEE80211 is not set
-# CONFIG_RFKILL is not set
-# CONFIG_NET_9P is not set
-
-#
-# Drivers for built-in interfaces
-#
-CONFIG_ETRAX_ETHERNET=y
-CONFIG_ETRAX_SERIAL=y
-# CONFIG_ETRAX_SERIAL_FAST_TIMER is not set
-# CONFIG_ETRAX_SERIAL_FLUSH_DMA_FAST is not set
-CONFIG_ETRAX_SERIAL_RX_TIMEOUT_TICKS=5
-# CONFIG_ETRAX_SERIAL_PORT0 is not set
-# CONFIG_ETRAX_SERIAL_PORT1 is not set
-# CONFIG_ETRAX_SERIAL_PORT2 is not set
-# CONFIG_ETRAX_SERIAL_PORT3 is not set
-# CONFIG_ETRAX_RS485 is not set
-# CONFIG_ETRAX_IDE is not set
-# CONFIG_ETRAX_USB_HOST is not set
-CONFIG_ETRAX_AXISFLASHMAP=y
-CONFIG_ETRAX_PTABLE_SECTOR=65536
-# CONFIG_ETRAX_I2C is not set
-# CONFIG_ETRAX_GPIO is not set
-# CONFIG_ETRAX_RTC is not set
-# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
-CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
-
-#
-# Generic Driver Options
-#
-CONFIG_STANDALONE=y
-CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_SYS_HYPERVISOR is not set
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-# CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLKDEVS=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-# CONFIG_INFTL is not set
-# CONFIG_RFD_FTL is not set
-# CONFIG_SSFDC is not set
-# CONFIG_MTD_OOPS is not set
-
-#
-# RAM/ROM/Flash chip drivers
-#
-CONFIG_MTD_CFI=y
-CONFIG_MTD_JEDECPROBE=y
-CONFIG_MTD_GEN_PROBE=y
-# CONFIG_MTD_CFI_ADV_OPTIONS is not set
-CONFIG_MTD_MAP_BANK_WIDTH_1=y
-CONFIG_MTD_MAP_BANK_WIDTH_2=y
-CONFIG_MTD_MAP_BANK_WIDTH_4=y
-# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
-CONFIG_MTD_CFI_I1=y
-CONFIG_MTD_CFI_I2=y
-# CONFIG_MTD_CFI_I4 is not set
-# CONFIG_MTD_CFI_I8 is not set
-# CONFIG_MTD_CFI_INTELEXT is not set
-CONFIG_MTD_CFI_AMDSTD=y
-# CONFIG_MTD_CFI_STAA is not set
-CONFIG_MTD_CFI_UTIL=y
-CONFIG_MTD_RAM=y
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_ABSENT is not set
-
-#
-# Mapping drivers for chip access
-#
-CONFIG_MTD_COMPLEX_MAPPINGS=y
-# CONFIG_MTD_PHYSMAP is not set
-# CONFIG_MTD_PLATRAM is not set
-
-#
-# Self-contained MTD device drivers
-#
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_PHRAM is not set
-CONFIG_MTD_MTDRAM=y
-CONFIG_MTDRAM_TOTAL_SIZE=0
-CONFIG_MTDRAM_ERASE_SIZE=64
-CONFIG_MTDRAM_ABS_POS=0x0
-# CONFIG_MTD_BLOCK2MTD is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOC2001PLUS is not set
-# CONFIG_MTD_NAND is not set
-# CONFIG_MTD_ONENAND is not set
-
-#
-# UBI - Unsorted block images
-#
-# CONFIG_MTD_UBI is not set
-CONFIG_BLK_DEV=y
-# CONFIG_BLK_DEV_COW_COMMON is not set
-# CONFIG_BLK_DEV_LOOP is not set
-# CONFIG_BLK_DEV_NBD is not set
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=16
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_CDROM_PKTCDVD is not set
-# CONFIG_ATA_OVER_ETH is not set
-CONFIG_NETDEVICES=y
-# CONFIG_NETDEVICES_MULTIQUEUE is not set
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_MACVLAN is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-# CONFIG_VETH is not set
-# CONFIG_PHYLIB is not set
-CONFIG_NET_ETHERNET=y
-CONFIG_MII=y
-# CONFIG_IBM_NEW_EMAC_ZMII is not set
-# CONFIG_IBM_NEW_EMAC_RGMII is not set
-# CONFIG_IBM_NEW_EMAC_TAH is not set
-# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
-CONFIG_NETDEV_1000=y
-CONFIG_NETDEV_10000=y
-
-#
-# Wireless LAN
-#
-# CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
-# CONFIG_WAN is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
-# CONFIG_NETCONSOLE is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_RTC_CLASS is not set
-
-#
-# Input device support
-#
-# CONFIG_INPUT is not set
-
-#
-# Hardware I/O ports
-#
-CONFIG_SERIO=y
-# CONFIG_SERIO_I8042 is not set
-# CONFIG_SERIO_SERPORT is not set
-# CONFIG_SERIO_LIBPS2 is not set
-# CONFIG_SERIO_RAW is not set
-# CONFIG_GAMEPORT is not set
-
-#
-# Character devices
-#
-# CONFIG_VT is not set
-CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
-CONFIG_HW_RANDOM=y
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
-# CONFIG_R3964 is not set
-# CONFIG_RAW_DRIVER is not set
-
-#
-# File systems
-#
-# CONFIG_EXT2_FS is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_EXT4DEV_FS is not set
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_FS_POSIX_ACL is not set
-# CONFIG_XFS_FS is not set
-# CONFIG_GFS2_FS is not set
-# CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
-CONFIG_INOTIFY_USER=y
-# CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
-# CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
-# CONFIG_FUSE_FS is not set
-
-#
-# CD-ROM/DVD Filesystems
-#
-# CONFIG_ISO9660_FS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-# CONFIG_MSDOS_FS is not set
-# CONFIG_VFAT_FS is not set
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-CONFIG_PROC_KCORE=y
-CONFIG_PROC_SYSCTL=y
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-# CONFIG_TMPFS_POSIX_ACL is not set
-# CONFIG_HUGETLB_PAGE is not set
-# CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-# CONFIG_AFFS_FS is not set
-# CONFIG_HFS_FS is not set
-# CONFIG_HFSPLUS_FS is not set
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_JFFS2_FS=y
-CONFIG_JFFS2_FS_DEBUG=0
-CONFIG_JFFS2_FS_WRITEBUFFER=y
-# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
-# CONFIG_JFFS2_SUMMARY is not set
-# CONFIG_JFFS2_FS_XATTR is not set
-# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
-CONFIG_JFFS2_ZLIB=y
-# CONFIG_JFFS2_LZO is not set
-CONFIG_JFFS2_RTIME=y
-# CONFIG_JFFS2_RUBIN is not set
-CONFIG_CRAMFS=y
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-CONFIG_NETWORK_FILESYSTEMS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V3_ACL is not set
-# CONFIG_NFS_V4 is not set
-# CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_NFS_COMMON=y
-CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_BIND34 is not set
-# CONFIG_RPCSEC_GSS_KRB5 is not set
-# CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-# CONFIG_PARTITION_ADVANCED is not set
-CONFIG_MSDOS_PARTITION=y
-# CONFIG_NLS is not set
-# CONFIG_DLM is not set
-
-#
-# Kernel hacking
-#
-# CONFIG_PROFILING is not set
-# CONFIG_SYSTEM_PROFILER is not set
-# CONFIG_PRINTK_TIME is not set
-CONFIG_ENABLE_WARN_DEPRECATED=y
-CONFIG_ENABLE_MUST_CHECK=y
-# CONFIG_MAGIC_SYSRQ is not set
-# CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_HEADERS_CHECK is not set
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_SLUB_DEBUG_ON is not set
-# CONFIG_SAMPLES is not set
-
-#
-# Security options
-#
-# CONFIG_KEYS is not set
-# CONFIG_SECURITY is not set
-# CONFIG_SECURITY_FILE_CAPABILITIES is not set
-# CONFIG_CRYPTO is not set
-
-#
-# Library routines
-#
-CONFIG_BITREVERSE=y
-# CONFIG_CRC_CCITT is not set
-# CONFIG_CRC16 is not set
-# CONFIG_CRC_ITU_T is not set
-CONFIG_CRC32=y
-# CONFIG_CRC7 is not set
-# CONFIG_LIBCRC32C is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-CONFIG_PLIST=y
-CONFIG_HAS_DMA=y
diff --git a/arch/cris/etraxfs_defconfig b/arch/cris/etraxfs_defconfig
deleted file mode 100644
index 73c646a..0000000
--- a/arch/cris/etraxfs_defconfig
+++ /dev/null
@@ -1,585 +0,0 @@
-#
-# Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24-rc3
-# Fri Nov 30 14:24:26 2007
-#
-CONFIG_MMU=y
-CONFIG_ZONE_DMA=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_IOMAP=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
-CONFIG_GENERIC_FIND_NEXT_BIT=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_NO_IOPORT=y
-CONFIG_FORCE_MAX_ZONEORDER=6
-CONFIG_CRIS=y
-CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
-
-#
-# General setup
-#
-CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION=""
-CONFIG_LOCALVERSION_AUTO=y
-# CONFIG_SWAP is not set
-# CONFIG_SYSVIPC is not set
-# CONFIG_POSIX_MQUEUE is not set
-# CONFIG_BSD_PROCESS_ACCT is not set
-# CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
-# CONFIG_PID_NS is not set
-# CONFIG_AUDIT is not set
-# CONFIG_IKCONFIG is not set
-CONFIG_LOG_BUF_SHIFT=14
-# CONFIG_CGROUPS is not set
-CONFIG_FAIR_GROUP_SCHED=y
-CONFIG_FAIR_USER_SCHED=y
-# CONFIG_FAIR_CGROUP_SCHED is not set
-CONFIG_SYSFS_DEPRECATED=y
-# CONFIG_RELAY is not set
-# CONFIG_BLK_DEV_INITRD is not set
-# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
-CONFIG_SYSCTL=y
-CONFIG_EMBEDDED=y
-CONFIG_UID16=y
-CONFIG_SYSCTL_SYSCALL=y
-# CONFIG_KALLSYMS is not set
-# CONFIG_HOTPLUG is not set
-CONFIG_PRINTK=y
-CONFIG_BUG=y
-CONFIG_ELF_CORE=y
-CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
-CONFIG_ANON_INODES=y
-CONFIG_EPOLL=y
-CONFIG_SIGNALFD=y
-CONFIG_EVENTFD=y
-CONFIG_SHMEM=y
-CONFIG_VM_EVENT_COUNTERS=y
-CONFIG_SLUB_DEBUG=y
-# CONFIG_SLAB is not set
-CONFIG_SLUB=y
-# CONFIG_SLOB is not set
-CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
-CONFIG_BASE_SMALL=0
-# CONFIG_MODULES is not set
-CONFIG_BLOCK=y
-# CONFIG_LBD is not set
-# CONFIG_BLK_DEV_IO_TRACE is not set
-# CONFIG_LSF is not set
-# CONFIG_BLK_DEV_BSG is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-# CONFIG_IOSCHED_AS is not set
-# CONFIG_IOSCHED_DEADLINE is not set
-CONFIG_IOSCHED_CFQ=y
-# CONFIG_DEFAULT_AS is not set
-# CONFIG_DEFAULT_DEADLINE is not set
-CONFIG_DEFAULT_CFQ=y
-# CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="cfq"
-
-#
-# General setup
-#
-CONFIG_BINFMT_ELF=y
-# CONFIG_BINFMT_MISC is not set
-CONFIG_GENERIC_HARDIRQS=y
-CONFIG_ETRAX_CMDLINE="root=/dev/mtdblock3 init=/linuxrc"
-# CONFIG_ETRAX_WATCHDOG is not set
-CONFIG_ETRAX_FAST_TIMER=y
-# CONFIG_ETRAX_KMALLOCED_MODULES is not set
-# CONFIG_OOM_REBOOT is not set
-CONFIG_PREEMPT_NONE=y
-# CONFIG_PREEMPT_VOLUNTARY is not set
-# CONFIG_PREEMPT is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
-CONFIG_SPLIT_PTLOCK_CPUS=4
-# CONFIG_RESOURCES_64BIT is not set
-CONFIG_ZONE_DMA_FLAG=1
-CONFIG_BOUNCE=y
-CONFIG_VIRT_TO_BUS=y
-
-#
-# Hardware setup
-#
-# CONFIG_ETRAX100LX is not set
-# CONFIG_ETRAX100LX_V2 is not set
-# CONFIG_SVINTO_SIM is not set
-CONFIG_ETRAXFS=y
-# CONFIG_CRIS_MACH_ARTPEC3 is not set
-# CONFIG_ETRAX_VCS_SIM is not set
-# CONFIG_ETRAX_ARCH_V10 is not set
-CONFIG_ETRAX_ARCH_V32=y
-CONFIG_ETRAX_DRAM_SIZE=32
-CONFIG_ETRAX_FLASH_BUSWIDTH=2
-CONFIG_ETRAX_NANDFLASH_BUSWIDTH=1
-CONFIG_ETRAX_FLASH1_SIZE=4
-CONFIG_ETRAX_DEBUG_PORT0=y
-# CONFIG_ETRAX_DEBUG_PORT1 is not set
-# CONFIG_ETRAX_DEBUG_PORT2 is not set
-# CONFIG_ETRAX_DEBUG_PORT3 is not set
-# CONFIG_ETRAX_DEBUG_PORT_NULL is not set
-CONFIG_ETRAX_DRAM_VIRTUAL_BASE=c0000000
-
-#
-# ETRAX FS options
-#
-CONFIG_ETRAX_SERIAL_PORTS=4
-CONFIG_ETRAX_MEM_GRP1_CONFIG=4044a
-CONFIG_ETRAX_MEM_GRP2_CONFIG=0
-CONFIG_ETRAX_MEM_GRP3_CONFIG=0
-CONFIG_ETRAX_MEM_GRP4_CONFIG=0
-CONFIG_ETRAX_SDRAM_GRP0_CONFIG=336
-CONFIG_ETRAX_SDRAM_GRP1_CONFIG=0
-CONFIG_ETRAX_SDRAM_TIMING=104a
-CONFIG_ETRAX_SDRAM_COMMAND=0
-CONFIG_ETRAX_DEF_GIO_PA_OE=1c
-CONFIG_ETRAX_DEF_GIO_PA_OUT=00
-CONFIG_ETRAX_DEF_GIO_PB_OE=00000
-CONFIG_ETRAX_DEF_GIO_PB_OUT=00000
-CONFIG_ETRAX_DEF_GIO_PC_OE=00000
-CONFIG_ETRAX_DEF_GIO_PC_OUT=00000
-CONFIG_ETRAX_DEF_GIO_PD_OE=00000
-CONFIG_ETRAX_DEF_GIO_PD_OUT=00000
-CONFIG_ETRAX_DEF_GIO_PE_OE=00000
-CONFIG_ETRAX_DEF_GIO_PE_OUT=00000
-# CONFIG_CPU_FREQ is not set
-# CONFIG_ETRAX_NBR_LED_GRP_ZERO is not set
-CONFIG_ETRAX_NBR_LED_GRP_ONE=y
-# CONFIG_ETRAX_NBR_LED_GRP_TWO is not set
-CONFIG_ETRAX_LED_G_NET0="PA3"
-CONFIG_ETRAX_LED_R_NET0="PA4"
-CONFIG_ETRAX_V32_LED2G="PA5"
-CONFIG_ETRAX_V32_LED2R="PA6"
-CONFIG_ETRAX_V32_LED3G="PA7"
-CONFIG_ETRAX_V32_LED3R="PA7"
-
-#
-# Networking
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-CONFIG_PACKET=y
-# CONFIG_PACKET_MMAP is not set
-CONFIG_UNIX=y
-CONFIG_XFRM=y
-# CONFIG_XFRM_USER is not set
-# CONFIG_XFRM_SUB_POLICY is not set
-# CONFIG_XFRM_MIGRATE is not set
-# CONFIG_NET_KEY is not set
-CONFIG_INET=y
-# CONFIG_IP_MULTICAST is not set
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_FIB_HASH=y
-# CONFIG_IP_PNP is not set
-# CONFIG_NET_IPIP is not set
-# CONFIG_NET_IPGRE is not set
-# CONFIG_ARPD is not set
-# CONFIG_SYN_COOKIES is not set
-# CONFIG_INET_AH is not set
-# CONFIG_INET_ESP is not set
-# CONFIG_INET_IPCOMP is not set
-# CONFIG_INET_XFRM_TUNNEL is not set
-# CONFIG_INET_TUNNEL is not set
-CONFIG_INET_XFRM_MODE_TRANSPORT=y
-CONFIG_INET_XFRM_MODE_TUNNEL=y
-CONFIG_INET_XFRM_MODE_BEET=y
-# CONFIG_INET_LRO is not set
-CONFIG_INET_DIAG=y
-CONFIG_INET_TCP_DIAG=y
-# CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_CUBIC=y
-CONFIG_DEFAULT_TCP_CONG="cubic"
-# CONFIG_TCP_MD5SIG is not set
-# CONFIG_IP_VS is not set
-# CONFIG_IPV6 is not set
-# CONFIG_INET6_XFRM_TUNNEL is not set
-# CONFIG_INET6_TUNNEL is not set
-# CONFIG_NETWORK_SECMARK is not set
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-
-#
-# Core Netfilter Configuration
-#
-# CONFIG_NETFILTER_NETLINK is not set
-# CONFIG_NF_CONNTRACK_ENABLED is not set
-# CONFIG_NF_CONNTRACK is not set
-# CONFIG_NETFILTER_XTABLES is not set
-
-#
-# IP: Netfilter Configuration
-#
-# CONFIG_IP_NF_QUEUE is not set
-# CONFIG_IP_NF_IPTABLES is not set
-# CONFIG_IP_NF_ARPTABLES is not set
-# CONFIG_IP_DCCP is not set
-# CONFIG_IP_SCTP is not set
-# CONFIG_TIPC is not set
-# CONFIG_ATM is not set
-# CONFIG_BRIDGE is not set
-# CONFIG_VLAN_8021Q is not set
-# CONFIG_DECNET is not set
-# CONFIG_LLC2 is not set
-# CONFIG_IPX is not set
-# CONFIG_ATALK is not set
-# CONFIG_X25 is not set
-# CONFIG_LAPB is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-# CONFIG_NET_PKTGEN is not set
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_AF_RXRPC is not set
-
-#
-# Wireless
-#
-# CONFIG_CFG80211 is not set
-# CONFIG_WIRELESS_EXT is not set
-# CONFIG_MAC80211 is not set
-# CONFIG_IEEE80211 is not set
-# CONFIG_RFKILL is not set
-# CONFIG_NET_9P is not set
-
-#
-# Drivers for built-in interfaces
-#
-CONFIG_ETRAX_ETHERNET=y
-# CONFIG_ETRAX_IDE is not set
-CONFIG_ETRAX_AXISFLASHMAP=y
-CONFIG_ETRAX_PTABLE_SECTOR=65536
-# CONFIG_ETRAX_I2C is not set
-# CONFIG_ETRAX_GPIO is not set
-# CONFIG_ETRAX_NO_PHY is not set
-# CONFIG_ETRAX_ETHERNET_IFACE0 is not set
-# CONFIG_ETRAX_ETHERNET_IFACE1 is not set
-# CONFIG_ETRAXFS_SERIAL is not set
-# CONFIG_ETRAX_SYNCHRONOUS_SERIAL is not set
-# CONFIG_ETRAX_AXISFLASHMAP_MTD0WHOLE is not set
-# CONFIG_ETRAX_NANDFLASH is not set
-# CONFIG_ETRAX_CARDBUS is not set
-# CONFIG_ETRAX_IOP_FW_LOAD is not set
-# CONFIG_ETRAX_STREAMCOPROC is not set
-# CONFIG_ETRAX_SPI_MMC is not set
-# CONFIG_ETRAX_SPI_MMC_BOARD is not set
-# CONFIG_ETRAX_NETWORK_LED_ON_WHEN_LINK is not set
-CONFIG_ETRAX_NETWORK_LED_ON_WHEN_ACTIVITY=y
-
-#
-# Generic Driver Options
-#
-CONFIG_STANDALONE=y
-CONFIG_PREVENT_FIRMWARE_BUILD=y
-# CONFIG_SYS_HYPERVISOR is not set
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
-# CONFIG_MTD_REDBOOT_PARTS is not set
-# CONFIG_MTD_CMDLINE_PARTS is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLKDEVS=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-# CONFIG_INFTL is not set
-# CONFIG_RFD_FTL is not set
-# CONFIG_SSFDC is not set
-# CONFIG_MTD_OOPS is not set
-
-#
-# RAM/ROM/Flash chip drivers
-#
-CONFIG_MTD_CFI=y
-CONFIG_MTD_JEDECPROBE=y
-CONFIG_MTD_GEN_PROBE=y
-# CONFIG_MTD_CFI_ADV_OPTIONS is not set
-CONFIG_MTD_MAP_BANK_WIDTH_1=y
-CONFIG_MTD_MAP_BANK_WIDTH_2=y
-CONFIG_MTD_MAP_BANK_WIDTH_4=y
-# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
-# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
-CONFIG_MTD_CFI_I1=y
-CONFIG_MTD_CFI_I2=y
-# CONFIG_MTD_CFI_I4 is not set
-# CONFIG_MTD_CFI_I8 is not set
-# CONFIG_MTD_CFI_INTELEXT is not set
-CONFIG_MTD_CFI_AMDSTD=y
-# CONFIG_MTD_CFI_STAA is not set
-CONFIG_MTD_CFI_UTIL=y
-CONFIG_MTD_RAM=y
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_ABSENT is not set
-
-#
-# Mapping drivers for chip access
-#
-CONFIG_MTD_COMPLEX_MAPPINGS=y
-# CONFIG_MTD_PHYSMAP is not set
-# CONFIG_MTD_PLATRAM is not set
-
-#
-# Self-contained MTD device drivers
-#
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_PHRAM is not set
-CONFIG_MTD_MTDRAM=y
-CONFIG_MTDRAM_TOTAL_SIZE=0
-CONFIG_MTDRAM_ERASE_SIZE=64
-CONFIG_MTDRAM_ABS_POS=0x0
-# CONFIG_MTD_BLOCK2MTD is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOC2001PLUS is not set
-# CONFIG_MTD_NAND is not set
-# CONFIG_MTD_ONENAND is not set
-
-#
-# UBI - Unsorted block images
-#
-# CONFIG_MTD_UBI is not set
-CONFIG_BLK_DEV=y
-# CONFIG_BLK_DEV_COW_COMMON is not set
-# CONFIG_BLK_DEV_LOOP is not set
-# CONFIG_BLK_DEV_NBD is not set
-CONFIG_BLK_DEV_RAM=y
-CONFIG_BLK_DEV_RAM_COUNT=16
-CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
-# CONFIG_CDROM_PKTCDVD is not set
-# CONFIG_ATA_OVER_ETH is not set
-CONFIG_NETDEVICES=y
-# CONFIG_NETDEVICES_MULTIQUEUE is not set
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_MACVLAN is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-# CONFIG_VETH is not set
-# CONFIG_PHYLIB is not set
-CONFIG_NET_ETHERNET=y
-CONFIG_MII=y
-# CONFIG_IBM_NEW_EMAC_ZMII is not set
-# CONFIG_IBM_NEW_EMAC_RGMII is not set
-# CONFIG_IBM_NEW_EMAC_TAH is not set
-# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
-CONFIG_NETDEV_1000=y
-CONFIG_NETDEV_10000=y
-
-#
-# Wireless LAN
-#
-# CONFIG_WLAN_PRE80211 is not set
-# CONFIG_WLAN_80211 is not set
-# CONFIG_WAN is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
-# CONFIG_NETCONSOLE is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-# CONFIG_RTC_CLASS is not set
-
-#
-# Input device support
-#
-# CONFIG_INPUT is not set
-
-#
-# Hardware I/O ports
-#
-CONFIG_SERIO=y
-# CONFIG_SERIO_I8042 is not set
-# CONFIG_SERIO_SERPORT is not set
-# CONFIG_SERIO_LIBPS2 is not set
-# CONFIG_SERIO_RAW is not set
-# CONFIG_GAMEPORT is not set
-
-#
-# Character devices
-#
-# CONFIG_VT is not set
-CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
-CONFIG_HW_RANDOM=y
-# CONFIG_RTC is not set
-# CONFIG_GEN_RTC is not set
-# CONFIG_R3964 is not set
-# CONFIG_RAW_DRIVER is not set
-
-#
-# File systems
-#
-# CONFIG_EXT2_FS is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_EXT4DEV_FS is not set
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_FS_POSIX_ACL is not set
-# CONFIG_XFS_FS is not set
-# CONFIG_GFS2_FS is not set
-# CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
-CONFIG_INOTIFY_USER=y
-# CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
-# CONFIG_AUTOFS_FS is not set
-# CONFIG_AUTOFS4_FS is not set
-# CONFIG_FUSE_FS is not set
-
-#
-# CD-ROM/DVD Filesystems
-#
-# CONFIG_ISO9660_FS is not set
-# CONFIG_UDF_FS is not set
-
-#
-# DOS/FAT/NT Filesystems
-#
-# CONFIG_MSDOS_FS is not set
-# CONFIG_VFAT_FS is not set
-# CONFIG_NTFS_FS is not set
-
-#
-# Pseudo filesystems
-#
-CONFIG_PROC_FS=y
-CONFIG_PROC_KCORE=y
-CONFIG_PROC_SYSCTL=y
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-# CONFIG_TMPFS_POSIX_ACL is not set
-# CONFIG_HUGETLB_PAGE is not set
-# CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
-# CONFIG_ADFS_FS is not set
-# CONFIG_AFFS_FS is not set
-# CONFIG_HFS_FS is not set
-# CONFIG_HFSPLUS_FS is not set
-# CONFIG_BEFS_FS is not set
-# CONFIG_BFS_FS is not set
-# CONFIG_EFS_FS is not set
-CONFIG_JFFS2_FS=y
-CONFIG_JFFS2_FS_DEBUG=0
-CONFIG_JFFS2_FS_WRITEBUFFER=y
-# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
-# CONFIG_JFFS2_SUMMARY is not set
-# CONFIG_JFFS2_FS_XATTR is not set
-# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
-CONFIG_JFFS2_ZLIB=y
-# CONFIG_JFFS2_LZO is not set
-CONFIG_JFFS2_RTIME=y
-# CONFIG_JFFS2_RUBIN is not set
-CONFIG_CRAMFS=y
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-CONFIG_NETWORK_FILESYSTEMS=y
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V3_ACL is not set
-# CONFIG_NFS_V4 is not set
-# CONFIG_NFS_DIRECTIO is not set
-# CONFIG_NFSD is not set
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_NFS_COMMON=y
-CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_BIND34 is not set
-# CONFIG_RPCSEC_GSS_KRB5 is not set
-# CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
-
-#
-# Partition Types
-#
-# CONFIG_PARTITION_ADVANCED is not set
-CONFIG_MSDOS_PARTITION=y
-# CONFIG_NLS is not set
-# CONFIG_DLM is not set
-
-#
-# Kernel hacking
-#
-# CONFIG_PROFILING is not set
-# CONFIG_SYSTEM_PROFILER is not set
-# CONFIG_PRINTK_TIME is not set
-CONFIG_ENABLE_WARN_DEPRECATED=y
-CONFIG_ENABLE_MUST_CHECK=y
-# CONFIG_MAGIC_SYSRQ is not set
-# CONFIG_UNUSED_SYMBOLS is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_HEADERS_CHECK is not set
-# CONFIG_DEBUG_KERNEL is not set
-# CONFIG_SLUB_DEBUG_ON is not set
-# CONFIG_SAMPLES is not set
-
-#
-# Security options
-#
-# CONFIG_KEYS is not set
-# CONFIG_SECURITY is not set
-# CONFIG_SECURITY_FILE_CAPABILITIES is not set
-# CONFIG_CRYPTO is not set
-
-#
-# Library routines
-#
-CONFIG_BITREVERSE=y
-# CONFIG_CRC_CCITT is not set
-# CONFIG_CRC16 is not set
-# CONFIG_CRC_ITU_T is not set
-CONFIG_CRC32=y
-# CONFIG_CRC7 is not set
-# CONFIG_LIBCRC32C is not set
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-CONFIG_PLIST=y
-CONFIG_HAS_DMA=y
