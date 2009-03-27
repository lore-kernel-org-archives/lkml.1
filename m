Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbZC0BcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbZC0BcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763151AbZC0Bb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:31:58 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:35809 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762701AbZC0Bb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:31:56 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 1/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF05CD1996.00155773-ON48257586.0007E097-48257586.0008511F@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:29:06 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:29:07,
	Serialize complete at 2009/03/27 ?? 09:29:07
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/boot/Makefile 
linux-2.6-git.new/arch/score/boot/Makefile
--- linux-2.6-git.ori/arch/score/boot/Makefile  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/boot/Makefile  2009-03-24 
16:55:29.000000000 +0800
@@ -0,0 +1,12 @@
+#
+# arch/score/boot/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General 
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+targets                := vmlinux.bin
+
+$(obj)/vmlinux.bin: vmlinux FORCE
+       $(call if_changed,objcopy)
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/configs/spct6600_defconfig 
linux-2.6-git.new/arch/score/configs/spct6600_defconfig
--- linux-2.6-git.ori/arch/score/configs/spct6600_defconfig     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/configs/spct6600_defconfig     2009-03-26 
16:16:28.000000000 +0800
@@ -0,0 +1,753 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.29-rc8
+# Fri Mar 20 09:14:43 2009
+#
+CONFIG_SCORE=y
+
+#
+# Machine selection
+#
+CONFIG_MACH_SPCT6600=y
+# CONFIG_MACH_SPG300 is not set
+# CONFIG_SCORE_SIM is not set
+CONFIG_CPU_SCORE7=y
+CONFIG_GENERIC_IOMAP=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_TIME=y
+CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
+# CONFIG_CPU_BIG_ENDIAN is not set
+CONFIG_CPU_LITTLE_ENDIAN=y
+CONFIG_SYS_SUPPORTS_LITTLE_ENDIAN=y
+CONFIG_SCORE_L1_CACHE_SHIFT=5
+
+#
+# Kernel type
+#
+CONFIG_32BIT=y
+CONFIG_PAGE_SIZE_4KB=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_ARCH_FLATMEM_ENABLE=y
+CONFIG_ARCH_POPULATES_NODE_MAP=y
+CONFIG_SELECT_MEMORY_MODEL=y
+CONFIG_FLATMEM_MANUAL=y
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+# CONFIG_SPARSEMEM_MANUAL is not set
+CONFIG_FLATMEM=y
+CONFIG_FLAT_NODE_MEM_MAP=y
+CONFIG_PAGEFLAGS_EXTENDED=y
+CONFIG_SPLIT_PTLOCK_CPUS=4
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
+CONFIG_MEMORY_START=0xa0000000
+# CONFIG_NO_HZ is not set
+# CONFIG_HIGH_RES_TIMERS is not set
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+# CONFIG_HZ_48 is not set
+CONFIG_HZ_100=y
+# CONFIG_HZ_128 is not set
+# CONFIG_HZ_250 is not set
+# CONFIG_HZ_256 is not set
+CONFIG_SYS_SUPPORTS_ARBIT_HZ=y
+CONFIG_HZ=100
+# CONFIG_PREEMPT_NONE is not set
+CONFIG_PREEMPT_VOLUNTARY=y
+# CONFIG_PREEMPT is not set
+# CONFIG_KEXEC is not set
+# CONFIG_SECCOMP is not set
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_SWAP=y
+CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
+CONFIG_POSIX_MQUEUE=y
+CONFIG_BSD_PROCESS_ACCT=y
+# CONFIG_BSD_PROCESS_ACCT_V3 is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+CONFIG_CLASSIC_RCU=y
+# CONFIG_TREE_RCU is not set
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=12
+# CONFIG_GROUP_SCHED is not set
+# CONFIG_CGROUPS is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
+# CONFIG_RELAY is not set
+# CONFIG_NAMESPACES is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_INITRAMFS_ROOT_UID=0
+CONFIG_INITRAMFS_ROOT_GID=0
+# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+CONFIG_EMBEDDED=y
+CONFIG_SYSCTL_SYSCALL=y
+# CONFIG_KALLSYMS is not set
+# CONFIG_HOTPLUG is not set
+CONFIG_PRINTK=y
+CONFIG_BUG=y
+CONFIG_ELF_CORE=y
+CONFIG_BASE_FULL=y
+CONFIG_FUTEX=y
+CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
+CONFIG_EVENTFD=y
+CONFIG_SHMEM=y
+CONFIG_AIO=y
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_COMPAT_BRK=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_FORCE_LOAD=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+# CONFIG_MODVERSIONS is not set
+# CONFIG_MODULE_SRCVERSION_ALL is not set
+CONFIG_BLOCK=y
+CONFIG_LBD=y
+# CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_BLK_DEV_BSG is not set
+# CONFIG_BLK_DEV_INTEGRITY is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_AS=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_AS is not set
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+# CONFIG_PROBE_INITRD_HEADER is not set
+
+#
+# Bus options (PCI, PCMCIA, EISA, ISA, TC)
+#
+CONFIG_MMU=y
+
+#
+# Executable file formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_HAVE_AOUT is not set
+CONFIG_BINFMT_MISC=y
+
+#
+# Power management options
+#
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+# CONFIG_PM is not set
+CONFIG_NET=y
+
+#
+# Networking options
+#
+CONFIG_COMPAT_NET_DEV_OPS=y
+# CONFIG_PACKET is not set
+CONFIG_UNIX=y
+CONFIG_XFRM=y
+# CONFIG_XFRM_USER is not set
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
+CONFIG_NET_KEY=y
+# CONFIG_NET_KEY_MIGRATE is not set
+CONFIG_INET=y
+CONFIG_IP_MULTICAST=y
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+# CONFIG_IP_PNP is not set
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_IP_MROUTE is not set
+CONFIG_ARPD=y
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
+# CONFIG_IPV6 is not set
+# CONFIG_NETLABEL is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_TIPC is not set
+# CONFIG_ATM is not set
+# CONFIG_BRIDGE is not set
+# CONFIG_NET_DSA is not set
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
+# CONFIG_DCB is not set
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
+# CONFIG_PHONET is not set
+CONFIG_WIRELESS=y
+# CONFIG_CFG80211 is not set
+CONFIG_WIRELESS_OLD_REGULATORY=y
+# CONFIG_WIRELESS_EXT is not set
+# CONFIG_LIB80211 is not set
+# CONFIG_MAC80211 is not set
+# CONFIG_WIMAX is not set
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
+# CONFIG_STANDALONE is not set
+# CONFIG_PREVENT_FIRMWARE_BUILD is not set
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+# CONFIG_MTD is not set
+# CONFIG_PARPORT is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_BLK_DEV_CRYPTOLOOP=y
+# CONFIG_BLK_DEV_NBD is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=1
+CONFIG_BLK_DEV_RAM_SIZE=4096
+# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_MISC_DEVICES is not set
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
+# CONFIG_DUMMY is not set
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+# CONFIG_TUN is not set
+# CONFIG_VETH is not set
+CONFIG_PHYLIB=y
+
+#
+# MII PHY device drivers
+#
+# CONFIG_MARVELL_PHY is not set
+# CONFIG_DAVICOM_PHY is not set
+# CONFIG_QSEMI_PHY is not set
+# CONFIG_LXT_PHY is not set
+# CONFIG_CICADA_PHY is not set
+# CONFIG_VITESSE_PHY is not set
+# CONFIG_SMSC_PHY is not set
+# CONFIG_BROADCOM_PHY is not set
+# CONFIG_ICPLUS_PHY is not set
+CONFIG_REALTEK_PHY=y
+# CONFIG_NATIONAL_PHY is not set
+# CONFIG_STE10XP is not set
+# CONFIG_LSI_ET1011C_PHY is not set
+# CONFIG_FIXED_PHY is not set
+# CONFIG_MDIO_BITBANG is not set
+CONFIG_NET_ETHERNET=y
+# CONFIG_MII is not set
+# CONFIG_DNET is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
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
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
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
+# CONFIG_INPUT_EVDEV is not set
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
+CONFIG_VT=y
+CONFIG_CONSOLE_TRANSLATIONS=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
+CONFIG_DEVKMEM=y
+CONFIG_SERIAL_NONSTANDARD=y
+# CONFIG_N_HDLC is not set
+# CONFIG_RISCOM8 is not set
+# CONFIG_SPECIALIX is not set
+# CONFIG_RIO is not set
+CONFIG_STALDRV=y
+
+#
+# Serial drivers
+#
+# CONFIG_SERIAL_8250 is not set
+
+#
+# Non-8250 serial port support
+#
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+CONFIG_SERIAL_SCT=y
+CONFIG_SERIAL_SCT_CONSOLE=y
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+CONFIG_LEGACY_PTYS=y
+CONFIG_LEGACY_PTY_COUNT=256
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+# CONFIG_RTC is not set
+# CONFIG_GEN_RTC is not set
+# CONFIG_R3964 is not set
+CONFIG_RAW_DRIVER=y
+CONFIG_MAX_RAW_DEVS=8192
+# CONFIG_TCG_TPM is not set
+# CONFIG_I2C is not set
+# CONFIG_SPI is not set
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
+# CONFIG_THERMAL_HWMON is not set
+# CONFIG_WATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
+
+#
+# Sonics Silicon Backplane
+#
+# CONFIG_SSB is not set
+
+#
+# Multifunction device drivers
+#
+# CONFIG_MFD_CORE is not set
+# CONFIG_MFD_SM501 is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_REGULATOR is not set
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
+# Console display driver support
+#
+# CONFIG_VGA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_SOUND is not set
+# CONFIG_HID_SUPPORT is not set
+# CONFIG_USB_SUPPORT is not set
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
+# CONFIG_RTC_CLASS is not set
+# CONFIG_DMADEVICES is not set
+# CONFIG_UIO is not set
+# CONFIG_STAGING is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+CONFIG_EXT2_FS_XATTR=y
+CONFIG_EXT2_FS_POSIX_ACL=y
+# CONFIG_EXT2_FS_SECURITY is not set
+# CONFIG_EXT2_FS_XIP is not set
+CONFIG_EXT3_FS=y
+CONFIG_EXT3_FS_XATTR=y
+CONFIG_EXT3_FS_POSIX_ACL=y
+# CONFIG_EXT3_FS_SECURITY is not set
+# CONFIG_EXT4_FS is not set
+CONFIG_JBD=y
+CONFIG_FS_MBCACHE=y
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
+CONFIG_DNOTIFY=y
+CONFIG_INOTIFY=y
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+CONFIG_AUTOFS_FS=y
+CONFIG_AUTOFS4_FS=y
+# CONFIG_FUSE_FS is not set
+CONFIG_GENERIC_ACL=y
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
+# CONFIG_PROC_PAGE_MONITOR is not set
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+# CONFIG_HUGETLB_PAGE is not set
+# CONFIG_CONFIGFS_FS is not set
+CONFIG_MISC_FILESYSTEMS=y
+# CONFIG_ADFS_FS is not set
+# CONFIG_AFFS_FS is not set
+# CONFIG_ECRYPT_FS is not set
+# CONFIG_HFS_FS is not set
+# CONFIG_HFSPLUS_FS is not set
+# CONFIG_BEFS_FS is not set
+# CONFIG_BFS_FS is not set
+# CONFIG_EFS_FS is not set
+# CONFIG_CRAMFS is not set
+# CONFIG_SQUASHFS is not set
+# CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
+# CONFIG_OMFS_FS is not set
+# CONFIG_HPFS_FS is not set
+# CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
+# CONFIG_SYSV_FS is not set
+# CONFIG_UFS_FS is not set
+CONFIG_NETWORK_FILESYSTEMS=y
+CONFIG_NFS_FS=y
+CONFIG_NFS_V3=y
+CONFIG_NFS_V3_ACL=y
+CONFIG_NFS_V4=y
+CONFIG_NFSD=y
+CONFIG_NFSD_V2_ACL=y
+CONFIG_NFSD_V3=y
+CONFIG_NFSD_V3_ACL=y
+CONFIG_NFSD_V4=y
+CONFIG_LOCKD=y
+CONFIG_LOCKD_V4=y
+CONFIG_EXPORTFS=y
+CONFIG_NFS_ACL_SUPPORT=y
+CONFIG_NFS_COMMON=y
+CONFIG_SUNRPC=y
+CONFIG_SUNRPC_GSS=y
+# CONFIG_SUNRPC_REGISTER_V4 is not set
+CONFIG_RPCSEC_GSS_KRB5=y
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
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+# CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
+CONFIG_FRAME_WARN=1024
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+# CONFIG_DEBUG_MEMORY_INIT is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_SYSCTL_SYSCALL_CHECK is not set
+
+#
+# Tracers
+#
+# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
+# CONFIG_SAMPLES is not set
+CONFIG_CMDLINE=""
+
+#
+# Security options
+#
+CONFIG_KEYS=y
+CONFIG_KEYS_DEBUG_PROC_KEYS=y
+CONFIG_SECURITY=y
+# CONFIG_SECURITYFS is not set
+CONFIG_SECURITY_NETWORK=y
+# CONFIG_SECURITY_NETWORK_XFRM is not set
+# CONFIG_SECURITY_PATH is not set
+CONFIG_SECURITY_FILE_CAPABILITIES=y
+CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=0
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+# CONFIG_CRYPTO_FIPS is not set
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_AEAD=y
+CONFIG_CRYPTO_AEAD2=y
+CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_BLKCIPHER2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+CONFIG_CRYPTO_RNG=y
+CONFIG_CRYPTO_RNG2=y
+CONFIG_CRYPTO_MANAGER=y
+CONFIG_CRYPTO_MANAGER2=y
+# CONFIG_CRYPTO_GF128MUL is not set
+CONFIG_CRYPTO_NULL=y
+CONFIG_CRYPTO_CRYPTD=y
+# CONFIG_CRYPTO_AUTHENC is not set
+# CONFIG_CRYPTO_TEST is not set
+
+#
+# Authenticated Encryption with Associated Data
+#
+# CONFIG_CRYPTO_CCM is not set
+# CONFIG_CRYPTO_GCM is not set
+CONFIG_CRYPTO_SEQIV=y
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
+CONFIG_CRYPTO_CRC32C=y
+CONFIG_CRYPTO_MD4=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_MICHAEL_MIC=y
+# CONFIG_CRYPTO_RMD128 is not set
+# CONFIG_CRYPTO_RMD160 is not set
+# CONFIG_CRYPTO_RMD256 is not set
+# CONFIG_CRYPTO_RMD320 is not set
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
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_HW is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
+CONFIG_CRC_CCITT=y
+CONFIG_CRC16=y
+# CONFIG_CRC_T10DIF is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+CONFIG_LIBCRC32C=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/a.out.h 
linux-2.6-git.new/arch/score/include/asm/a.out.h
--- linux-2.6-git.ori/arch/score/include/asm/a.out.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/a.out.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,23 @@
+#ifndef _ASM_A_OUT_H
+#define _ASM_A_OUT_H
+
+struct exec
+{
+       unsigned long a_info;   /* Use macros N_MAGIC, etc for access */
+       unsigned a_text;        /* length of text, in bytes */
+       unsigned a_data;        /* length of data, in bytes */
+       unsigned a_bss;         /* length of uninitialized data area for
+                                   file, in bytes */
+       unsigned a_syms;        /* length of symbol table data in file,
+                                  in bytes */
+       unsigned a_entry;       /* start address */
+       unsigned a_trsize;      /* length of relocation info for text, in
+                                   bytes */
+       unsigned a_drsize;      /* length of relocation info for data, in 
bytes */
+};
+
+#define N_TRSIZE(a)    ((a).a_trsize)
+#define N_DRSIZE(a)    ((a).a_drsize)
+#define N_SYMSIZE(a)   ((a).a_syms)
+
+#endif /* _ASM_A_OUT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/asm.h 
linux-2.6-git.new/arch/score/include/asm/asm.h
--- linux-2.6-git.ori/arch/score/include/asm/asm.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/asm.h      2009-03-19 
11:47:06.000000000 +0800
@@ -0,0 +1,161 @@
+#ifndef __ASM_ASM_H
+#define __ASM_ASM_H
+
+#include <asm/asm-offsets.h>
+
+#ifdef __ASSEMBLY__
+
+.macro SAVE_ALL
+       mfcr    r30, cr0
+       mv      r31, r0
+       nop
+       /* if UMs == 1, change stack.  */
+       slli.c  r30, r30, 28
+       bpl     8f
+       la      r31, kernelsp
+       lw      r31, [r31]
+8:
+       mv      r30, r0
+       addri   r0, r31, -PT_SIZE
+
+       sw      r30, [r0, PT_R0]
+       .set    r1
+       sw      r1, [r0, PT_R1]
+       .set    nor1
+       sw      r2, [r0, PT_R2]
+       sw      r3, [r0, PT_R3]
+       sw      r4, [r0, PT_R4]
+       sw      r5, [r0, PT_R5]
+       sw      r6, [r0, PT_R6]
+       sw      r7, [r0, PT_R7]
+
+       sw      r8, [r0, PT_R8]
+       sw      r9, [r0, PT_R9]
+       sw      r10, [r0, PT_R10]
+       sw      r11, [r0, PT_R11]
+       sw      r12, [r0, PT_R12]
+       sw      r13, [r0, PT_R13]
+       sw      r14, [r0, PT_R14]
+       sw      r15, [r0, PT_R15]
+
+       sw      r16, [r0, PT_R16]
+       sw      r17, [r0, PT_R17]
+       sw      r18, [r0, PT_R18]
+       sw      r19, [r0, PT_R19]
+       sw      r20, [r0, PT_R20]
+       sw      r21, [r0, PT_R21]
+       sw      r22, [r0, PT_R22]
+       sw      r23, [r0, PT_R23]
+
+       sw      r24, [r0, PT_R24]
+       sw      r25, [r0, PT_R25]
+       sw      r25, [r0, PT_R25]
+       sw      r26, [r0, PT_R26]
+       sw      r27, [r0, PT_R27]
+
+       sw      r28, [r0, PT_R28]
+       sw      r29, [r0, PT_R29]
+       orri    r28, r0, 0x1fff
+       li      r31, 0x00001fff
+       xor     r28, r28, r31
+
+       mfcehl  r30, r31
+       sw      r30, [r0, PT_CEH]
+       sw      r31, [r0, PT_CEL]
+
+       mfcr    r31, cr0
+       sw      r31, [r0, PT_PSR]
+
+       mfcr    r31, cr1
+       sw      r31, [r0, PT_CONDITION]
+
+       mfcr    r31, cr2
+       sw      r31, [r0, PT_ECR]
+ 
+       mfcr    r31, cr5
+       srli    r31, r31, 1
+       slli    r31, r31, 1
+       sw      r31, [r0, PT_EPC]
+.endm
+
+.macro RESTORE_ALL_AND_RET
+       mfcr    r30, cr0
+       srli    r30, r30, 1
+       slli    r30, r30, 1
+       mtcr    r30, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       .set    r1
+       ldis    r1, 0x00ff
+       and     r30, r30, r1
+       not     r1, r1
+       lw      r31, [r0, PT_PSR]
+       and     r31, r31, r1
+       .set    nor1
+       or      r31, r31, r30
+       mtcr    r31, cr0
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CONDITION]
+       mtcr    r30, cr1
+       nop
+       nop
+       nop
+       nop
+       nop
+
+       lw      r30, [r0, PT_CEH]
+       lw      r31, [r0, PT_CEL]
+       mtcehl  r30, r31
+
+       .set    r1
+       lw      r1, [r0, PT_R1]
+       .set    nor1
+       lw      r2, [r0, PT_R2]
+       lw      r3, [r0, PT_R3]
+       lw      r4, [r0, PT_R4]
+       lw      r5, [r0, PT_R5]
+       lw      r6, [r0, PT_R6]
+       lw      r7, [r0, PT_R7]
+
+       lw      r8, [r0, PT_R8]
+       lw      r9, [r0, PT_R9]
+       lw      r10, [r0, PT_R10]
+       lw      r11, [r0, PT_R11]
+       lw      r12, [r0, PT_R12]
+       lw      r13, [r0, PT_R13]
+       lw      r14, [r0, PT_R14]
+       lw      r15, [r0, PT_R15]
+
+       lw      r16, [r0, PT_R16]
+       lw      r17, [r0, PT_R17]
+       lw      r18, [r0, PT_R18]
+       lw      r19, [r0, PT_R19]
+       lw      r20, [r0, PT_R20]
+       lw      r21, [r0, PT_R21]
+       lw      r22, [r0, PT_R22]
+       lw      r23, [r0, PT_R23]
+
+       lw      r24, [r0, PT_R24]
+       lw      r25, [r0, PT_R25]
+       lw      r26, [r0, PT_R26]
+       lw      r27, [r0, PT_R27]
+       lw      r28, [r0, PT_R28]
+       lw      r29, [r0, PT_R29]
+
+       lw      r30, [r0, PT_EPC]
+       lw      r0, [r0, PT_R0]
+       mtcr    r30, cr5
+       rte
+.endm
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_ASM_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/atomic.h 
linux-2.6-git.new/arch/score/include/asm/atomic.h
--- linux-2.6-git.ori/arch/score/include/asm/atomic.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/atomic.h   2009-03-23 
17:45:14.000000000 +0800
@@ -0,0 +1,240 @@
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#include <linux/irqflags.h>
+#include <asm/system.h>
+
+#define ATOMIC_INIT(i)         {(i)}
+
+/*
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+#define atomic_read(v)         ((v)->counter)
+
+/*
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+#define atomic_set(v, i)       ((v)->counter = (i))
+
+/*
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static __inline__ void atomic_add(int i, atomic_t *v)
+{
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       v->counter += i;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * atomic_sub - subtract the atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static __inline__ void atomic_sub(int i, atomic_t *v)
+{
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       v->counter -= i;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * Same as above, but return the result value
+ */
+static __inline__ int atomic_add_return(int i, atomic_t *v)
+{
+       unsigned long flags;
+       int temp;
+
+       raw_local_irq_save(flags);
+       temp = v->counter;
+       temp += i;
+       v->counter = temp;
+       raw_local_irq_restore(flags);
+
+       return temp;
+}
+
+static __inline__ int atomic_sub_return(int i, atomic_t *v)
+{
+       unsigned long flags;
+       int temp;
+
+       raw_local_irq_save(flags);
+       temp = v->counter;
+       temp -= i;
+       v->counter = temp;
+       raw_local_irq_restore(flags);
+
+       return temp;
+}
+
+/*
+ * atomic_sub_if_positive - conditionally subtract integer from atomic 
variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically test @v and subtract @i if @v is greater or equal than @i.
+ * The function returns the old value of @v minus @i.
+ */
+static __inline__ int atomic_sub_if_positive(int i, atomic_t *v)
+{
+       unsigned long result;
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       result = v->counter;
+       result -= i;
+       if (result >= 0)
+               v->counter = result;
+       raw_local_irq_restore(flags);
+
+       return result;
+}
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+       unsigned long flags;
+       int prev;
+
+       raw_local_irq_save(flags);
+       prev = atomic_read(v);
+       if (prev == old)
+               atomic_set(v, new);
+       raw_local_irq_restore(flags);
+       return prev;
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+       unsigned long flags;
+       int prev;
+
+       raw_local_irq_save(flags);
+       prev = atomic_read(v);
+       atomic_set(v, new);
+       raw_local_irq_restore(flags);
+       return prev;
+}
+
+/**
+ * atomic_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
+{
+       int c, old;
+       c = atomic_read(v);
+       for (;;) {
+               if (unlikely(c == (u)))
+                       break;
+               old = atomic_cmpxchg((v), c, c + (a));
+               if (likely(old == c))
+                       break;
+               c = old;
+       }
+       return c != (u);
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+#define atomic_dec_return(v) atomic_sub_return(1, (v))
+#define atomic_inc_return(v) atomic_add_return(1, (v))
+
+/*
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
+
+/*
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+#define atomic_inc_and_test(v) (atomic_inc_return(v) == 0)
+
+/*
+ * atomic_dec_and_test - decrement by 1 and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+#define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
+
+/*
+ * atomic_dec_if_positive - decrement by 1 if old value positive
+ * @v: pointer of type atomic_t
+ */
+#define atomic_dec_if_positive(v)      atomic_sub_if_positive(1, v)
+
+/*
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+#define atomic_inc(v) atomic_add(1, (v))
+
+/*
+ * atomic_dec - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+#define atomic_dec(v) atomic_sub(1, (v))
+
+/*
+ * atomic_add_negative - add and test if negative
+ * @v: pointer of type atomic_t
+ * @i: integer value to add
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+#define atomic_add_negative(i, v) (atomic_add_return(i, (v)) < 0)
+
+/*
+ * atomic*_return operations are serializing but not the non-*_return
+ * versions.
+ */
+#define smp_mb__before_atomic_dec()    barrier()
+#define smp_mb__after_atomic_dec()     barrier()
+#define smp_mb__before_atomic_inc()    barrier()
+#define smp_mb__after_atomic_inc()     barrier()
+
+#include <asm-generic/atomic.h>
+#endif /* _ASM_ATOMIC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/auxvec.h 
linux-2.6-git.new/arch/score/include/asm/auxvec.h
--- linux-2.6-git.ori/arch/score/include/asm/auxvec.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/auxvec.h   2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,4 @@
+#ifndef _ASM_AUXVEC_H
+#define _ASM_AUXVEC_H
+
+#endif /* _ASM_AUXVEC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/bitops.h 
linux-2.6-git.new/arch/score/include/asm/bitops.h
--- linux-2.6-git.ori/arch/score/include/asm/bitops.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/bitops.h   2009-03-25 
09:48:23.000000000 +0800
@@ -0,0 +1,253 @@
+#ifndef _ASM_BITOPS_H
+#define _ASM_BITOPS_H
+
+#ifndef _LINUX_BITOPS_H
+#error only <linux/bitops.h> can be included directly
+#endif
+
+#include <linux/compiler.h>
+#include <linux/irqflags.h>
+#include <linux/types.h>
+#include <asm/system.h>
+#include <asm/byteorder.h>
+
+#define SZLONG_LOG 5
+#define SZLONG_MASK 31UL
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()     barrier()
+#define smp_mb__after_clear_bit()      barrier()
+
+/*
+ * set_bit - Atomically set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This function is atomic and may not be reordered.  See __set_bit()
+ * if you do not require the atomic guarantees.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void set_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * clear_bit - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and may not be reordered.  However, it does
+ * not contain a memory barrier, so if it is used for locking purposes,
+ * you should call smp_mb__before_clear_bit() and/or 
smp_mb__after_clear_bit()
+ * in order to ensure changes are visible on other processors.
+ */
+static inline void clear_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a &= ~mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * clear_bit() is atomic and implies release semantics before the memory
+ * operation. It can be used for an unlock.
+ */
+static inline void
+clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+       clear_bit(nr, addr);
+}
+
+/*
+ * change_bit - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * change_bit() is atomic and may not be reordered.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+static inline void change_bit(unsigned long nr, volatile unsigned long 
*addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       *a ^= mask;
+       raw_local_irq_restore(flags);
+}
+
+/*
+ * test_and_set_bit - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+/*
+ * test_and_set_bit_lock - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic and implies acquire ordering semantics
+ * after the memory operation.
+ */
+static inline int
+test_and_set_bit_lock(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a |= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+/*
+ * test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a &= ~mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+/*
+ * test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic and cannot be reordered.
+ * It also implies a memory barrier.
+ */
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
+{
+       unsigned short bit = nr & SZLONG_MASK;
+       unsigned long res;
+       volatile unsigned long *a = addr;
+       unsigned long mask;
+       unsigned long flags;
+
+       a += nr >> SZLONG_LOG;
+       mask = 1UL << bit;
+       raw_local_irq_save(flags);
+       res = (mask & *a);
+       *a ^= mask;
+       raw_local_irq_restore(flags);
+
+       return res != 0;
+}
+
+#include <asm-generic/bitops/non-atomic.h>
+
+/*
+ * __clear_bit_unlock - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * __clear_bit() is non-atomic and implies release semantics before the 
memory
+ * operation. It can be used for an unlock if no other CPUs can 
concurrently
+ * modify other bits in the word.
+ */
+static inline void
+__clear_bit_unlock(unsigned long nr, volatile unsigned long *addr)
+{
+       __clear_bit(nr, addr);
+}
+
+#include <asm-generic/bitops/__ffs.h>
+#include <asm-generic/bitops/__fls.h>
+#include <asm-generic/bitops/ffs.h>
+#include <asm-generic/bitops/fls.h>
+#include <asm-generic/bitops/fls64.h>
+
+#include <asm-generic/bitops/ffz.h>
+#include <asm-generic/bitops/find.h>
+
+#ifdef __KERNEL__
+
+#include <asm-generic/bitops/sched.h>
+#include <asm-generic/bitops/hweight.h>
+#include <asm-generic/bitops/ext2-non-atomic.h>
+#include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/minix.h>
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_BITOPS_H */


