Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbXKJNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbXKJNnU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 08:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbXKJNnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 08:43:10 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:44942 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbXKJNnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 08:43:05 -0500
Date: Sat, 10 Nov 2007 14:41:54 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Adrian Bunk <bunk@kernel.org>, Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <20071110134154.GS8087@pengutronix.de>
References: <20071110080629.GA18520@linux-sh.org> <20071110091057.GA10446@flint.arm.linux.org.uk> <20071110112632.GQ8087@pengutronix.de> <20071110114953.GL26163@stusta.de> <20071110134048.GR8087@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071110134048.GR8087@pengutronix.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:40:57 up 221 days,  7:06, 17 users,  load average: 0.29, 0.19, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: [PATCH] netx: remove bogus defconfig patch with wrong -p
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove bogus commit f33bac8dd4573428b94c67149c5607be489092d1 which had
an incorrect path in the patch, leading to modify arm/... instead of
arch/arm/..., then re-add the right netx_defconfig file.

Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>
---
 arch/arm/configs/netx_defconfig |  550 +++++++++++------------
 arm/configs/netx_defconfig      |  925 ---------------------------------------
 2 files changed, 266 insertions(+), 1209 deletions(-)

diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 57f32f3..4ed31f8 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -1,44 +1,64 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.17-rc6
-# Tue Jun  6 15:26:53 2006
+# Linux kernel version: 2.6.24-rc2
+# Sat Nov 10 14:00:40 2007
 #
 CONFIG_ARM=y
+CONFIG_SYS_SUPPORTS_APM_EMULATION=y
+# CONFIG_GENERIC_GPIO is not set
+# CONFIG_GENERIC_TIME is not set
+# CONFIG_GENERIC_CLOCKEVENTS is not set
 CONFIG_MMU=y
+# CONFIG_NO_IOPORT is not set
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_HARDIRQS_SW_RESEND=y
+CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_ZONE_DMA=y
 CONFIG_VECTORS_BASE=0xffff0000
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
-# Code maturity level options
+# General setup
 #
 CONFIG_EXPERIMENTAL=y
 CONFIG_BROKEN_ON_SMP=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
 CONFIG_LOCALVERSION=""
 CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
+CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 CONFIG_BSD_PROCESS_ACCT=y
 # CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
+# CONFIG_TASKSTATS is not set
+# CONFIG_USER_NS is not set
 # CONFIG_AUDIT is not set
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
+CONFIG_LOG_BUF_SHIFT=17
+# CONFIG_CGROUPS is not set
+CONFIG_FAIR_GROUP_SCHED=y
+CONFIG_FAIR_USER_SCHED=y
+# CONFIG_FAIR_CGROUP_SCHED is not set
+CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
-CONFIG_INITRAMFS_SOURCE=""
-CONFIG_UID16=y
+# CONFIG_BLK_DEV_INITRD is not set
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
 # CONFIG_EMBEDDED is not set
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
-# CONFIG_KALLSYMS_ALL is not set
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
@@ -46,28 +66,29 @@ CONFIG_BUG=y
 CONFIG_ELF_CORE=y
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
+CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
+CONFIG_SIGNALFD=y
+CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
+CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
-# CONFIG_SLOB is not set
-CONFIG_OBSOLETE_INTERMODULE=y
-
-#
-# Loadable module support
-#
 CONFIG_MODULES=y
 CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_KMOD=y
-
-#
-# Block layer
-#
+CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
+# CONFIG_BLK_DEV_BSG is not set
 
 #
 # IO Schedulers
@@ -85,32 +106,47 @@ CONFIG_DEFAULT_IOSCHED="anticipatory"
 #
 # System Type
 #
+# CONFIG_ARCH_AAEC2000 is not set
+# CONFIG_ARCH_INTEGRATOR is not set
+# CONFIG_ARCH_REALVIEW is not set
+# CONFIG_ARCH_VERSATILE is not set
+# CONFIG_ARCH_AT91 is not set
 # CONFIG_ARCH_CLPS7500 is not set
 # CONFIG_ARCH_CLPS711X is not set
 # CONFIG_ARCH_CO285 is not set
 # CONFIG_ARCH_EBSA110 is not set
 # CONFIG_ARCH_EP93XX is not set
 # CONFIG_ARCH_FOOTBRIDGE is not set
-# CONFIG_ARCH_INTEGRATOR is not set
-# CONFIG_ARCH_IOP3XX is not set
-# CONFIG_ARCH_IXP4XX is not set
-# CONFIG_ARCH_IXP2000 is not set
+CONFIG_ARCH_NETX=y
+# CONFIG_ARCH_H720X is not set
+# CONFIG_ARCH_IMX is not set
+# CONFIG_ARCH_IOP13XX is not set
+# CONFIG_ARCH_IOP32X is not set
+# CONFIG_ARCH_IOP33X is not set
 # CONFIG_ARCH_IXP23XX is not set
+# CONFIG_ARCH_IXP2000 is not set
+# CONFIG_ARCH_IXP4XX is not set
 # CONFIG_ARCH_L7200 is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_PNX4008 is not set
 # CONFIG_ARCH_PXA is not set
 # CONFIG_ARCH_RPC is not set
 # CONFIG_ARCH_SA1100 is not set
 # CONFIG_ARCH_S3C2410 is not set
 # CONFIG_ARCH_SHARK is not set
 # CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_DAVINCI is not set
 # CONFIG_ARCH_OMAP is not set
-# CONFIG_ARCH_VERSATILE is not set
-# CONFIG_ARCH_REALVIEW is not set
-# CONFIG_ARCH_IMX is not set
-# CONFIG_ARCH_H720X is not set
-# CONFIG_ARCH_AAEC2000 is not set
-# CONFIG_ARCH_AT91RM9200 is not set
-CONFIG_ARCH_NETX=y
+
+#
+# Boot options
+#
+
+#
+# Power management
+#
 
 #
 # NetX Implementations
@@ -129,6 +165,8 @@ CONFIG_CPU_ABRT_EV5TJ=y
 CONFIG_CPU_CACHE_VIVT=y
 CONFIG_CPU_COPY_V4WB=y
 CONFIG_CPU_TLB_V4WBI=y
+CONFIG_CPU_CP15=y
+CONFIG_CPU_CP15_MMU=y
 
 #
 # Processor Features
@@ -138,21 +176,21 @@ CONFIG_ARM_THUMB=y
 # CONFIG_CPU_DCACHE_DISABLE is not set
 # CONFIG_CPU_DCACHE_WRITETHROUGH is not set
 # CONFIG_CPU_CACHE_ROUND_ROBIN is not set
+# CONFIG_OUTER_CACHE is not set
 CONFIG_ARM_VIC=y
 
 #
 # Bus support
 #
 CONFIG_ARM_AMBA=y
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
 # CONFIG_PCCARD is not set
 
 #
 # Kernel Features
 #
+# CONFIG_TICK_ONESHOT is not set
 CONFIG_PREEMPT=y
 # CONFIG_NO_IDLE_HZ is not set
 CONFIG_HZ=100
@@ -165,7 +203,12 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
+# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4096
+# CONFIG_RESOURCES_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=1
+CONFIG_BOUNCE=y
+CONFIG_VIRT_TO_BUS=y
 CONFIG_ALIGNMENT_TRAP=y
 
 #
@@ -175,6 +218,7 @@ CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
 CONFIG_CMDLINE="console=ttySMX0,115200"
 # CONFIG_XIP_KERNEL is not set
+# CONFIG_KEXEC is not set
 
 #
 # Floating point emulation
@@ -199,7 +243,7 @@ CONFIG_BINFMT_ELF=y
 # Power management options
 #
 # CONFIG_PM is not set
-# CONFIG_APM is not set
+CONFIG_SUSPEND_UP_POSSIBLE=y
 
 #
 # Networking
@@ -209,13 +253,15 @@ CONFIG_NET=y
 #
 # Networking options
 #
-# CONFIG_NETDEBUG is not set
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
 CONFIG_XFRM=y
 CONFIG_XFRM_USER=m
+# CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 CONFIG_NET_KEY=y
+# CONFIG_NET_KEY_MIGRATE is not set
 CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
 # CONFIG_IP_ADVANCED_ROUTER is not set
@@ -235,24 +281,35 @@ CONFIG_INET_ESP=y
 CONFIG_INET_IPCOMP=y
 CONFIG_INET_XFRM_TUNNEL=y
 CONFIG_INET_TUNNEL=y
+CONFIG_INET_XFRM_MODE_TRANSPORT=y
+CONFIG_INET_XFRM_MODE_TUNNEL=y
+CONFIG_INET_XFRM_MODE_BEET=y
+# CONFIG_INET_LRO is not set
 CONFIG_INET_DIAG=y
 CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_BIC=y
-
-#
-# IP: Virtual Server Configuration
-#
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IP_VS is not set
 CONFIG_IPV6=m
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
+# CONFIG_IPV6_OPTIMISTIC_DAD is not set
 CONFIG_INET6_AH=m
 CONFIG_INET6_ESP=m
 CONFIG_INET6_IPCOMP=m
+# CONFIG_IPV6_MIP6 is not set
 CONFIG_INET6_XFRM_TUNNEL=m
 CONFIG_INET6_TUNNEL=m
+CONFIG_INET6_XFRM_MODE_TRANSPORT=m
+CONFIG_INET6_XFRM_MODE_TUNNEL=m
+CONFIG_INET6_XFRM_MODE_BEET=m
+# CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
+CONFIG_IPV6_SIT=m
 # CONFIG_IPV6_TUNNEL is not set
+# CONFIG_IPV6_MULTIPLE_TABLES is not set
+# CONFIG_NETWORK_SECMARK is not set
 CONFIG_NETFILTER=y
 # CONFIG_NETFILTER_DEBUG is not set
 
@@ -260,43 +317,24 @@ CONFIG_NETFILTER=y
 # Core Netfilter Configuration
 #
 # CONFIG_NETFILTER_NETLINK is not set
+# CONFIG_NF_CONNTRACK_ENABLED is not set
+# CONFIG_NF_CONNTRACK is not set
 # CONFIG_NETFILTER_XTABLES is not set
 
 #
 # IP: Netfilter Configuration
 #
-CONFIG_IP_NF_CONNTRACK=m
-# CONFIG_IP_NF_CT_ACCT is not set
-# CONFIG_IP_NF_CONNTRACK_MARK is not set
-# CONFIG_IP_NF_CONNTRACK_EVENTS is not set
-# CONFIG_IP_NF_CT_PROTO_SCTP is not set
-CONFIG_IP_NF_FTP=m
-CONFIG_IP_NF_IRC=m
-# CONFIG_IP_NF_NETBIOS_NS is not set
-CONFIG_IP_NF_TFTP=m
-CONFIG_IP_NF_AMANDA=m
-# CONFIG_IP_NF_PPTP is not set
-# CONFIG_IP_NF_H323 is not set
 CONFIG_IP_NF_QUEUE=m
+# CONFIG_IP_NF_IPTABLES is not set
+# CONFIG_IP_NF_ARPTABLES is not set
 
 #
 # IPv6: Netfilter Configuration (EXPERIMENTAL)
 #
 # CONFIG_IP6_NF_QUEUE is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
+# CONFIG_IP6_NF_IPTABLES is not set
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
@@ -307,13 +345,8 @@ CONFIG_IP_NF_QUEUE=m
 # CONFIG_ATALK is not set
 # CONFIG_X25 is not set
 # CONFIG_LAPB is not set
-# CONFIG_NET_DIVERT is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
 # CONFIG_NET_SCHED is not set
 
 #
@@ -323,7 +356,17 @@ CONFIG_NET_PKTGEN=m
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
@@ -332,19 +375,12 @@ CONFIG_NET_PKTGEN=m
 #
 # Generic Driver Options
 #
+CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 CONFIG_FW_LOADER=y
-# CONFIG_DEBUG_DRIVER is not set
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
@@ -357,11 +393,14 @@ CONFIG_MTD_CMDLINE_PARTS=y
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
+# CONFIG_MTD_OOPS is not set
 
 #
 # RAM/ROM/Flash chip drivers
@@ -387,7 +426,6 @@ CONFIG_MTD_CFI_UTIL=y
 CONFIG_MTD_RAM=y
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
 
 #
 # Mapping drivers for chip access
@@ -411,105 +449,62 @@ CONFIG_MTD_PLATRAM=y
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
 CONFIG_BLK_DEV_LOOP=m
 CONFIG_BLK_DEV_CRYPTOLOOP=m
 # CONFIG_BLK_DEV_NBD is not set
 # CONFIG_BLK_DEV_RAM is not set
-# CONFIG_BLK_DEV_INITRD is not set
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_EEPROM_93CX6 is not set
 
 #
 # SCSI device support
 #
 # CONFIG_RAID_ATTRS is not set
 # CONFIG_SCSI is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
+# CONFIG_SCSI_DMA is not set
+# CONFIG_SCSI_NETLINK is not set
+# CONFIG_ATA is not set
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
+# CONFIG_VETH is not set
 # CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
 CONFIG_NET_ETHERNET=y
 CONFIG_MII=y
+# CONFIG_AX88796 is not set
 # CONFIG_SMC91X is not set
 CONFIG_NET_NETX=y
 # CONFIG_DM9000 is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_B44 is not set
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
@@ -517,16 +512,14 @@ CONFIG_NET_NETX=y
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
 # CONFIG_ISDN is not set
 
 #
 # Input device support
 #
 CONFIG_INPUT=y
+# CONFIG_INPUT_FF_MEMLESS is not set
+# CONFIG_INPUT_POLLDEV is not set
 
 #
 # Userland interfaces
@@ -536,7 +529,6 @@ CONFIG_INPUT_MOUSEDEV=y
 CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
 CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
 # CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
 # CONFIG_INPUT_EVDEV is not set
 # CONFIG_INPUT_EVBUG is not set
 
@@ -546,6 +538,7 @@ CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
 # CONFIG_INPUT_KEYBOARD is not set
 # CONFIG_INPUT_MOUSE is not set
 # CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
 # CONFIG_INPUT_TOUCHSCREEN is not set
 # CONFIG_INPUT_MISC is not set
 
@@ -564,6 +557,7 @@ CONFIG_SERIO_SERPORT=y
 CONFIG_VT=y
 CONFIG_VT_CONSOLE=y
 CONFIG_HW_CONSOLE=y
+# CONFIG_VT_HW_CONSOLE_BINDING is not set
 # CONFIG_SERIAL_NONSTANDARD is not set
 
 #
@@ -583,34 +577,12 @@ CONFIG_SERIAL_NETX_CONSOLE=y
 CONFIG_UNIX98_PTYS=y
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
-# CONFIG_WATCHDOG is not set
+CONFIG_HW_RANDOM=m
 CONFIG_NVRAM=m
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
@@ -618,60 +590,64 @@ CONFIG_NVRAM=m
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
-
-#
-# Misc devices
-#
-
-#
-# LED devices
-#
-# CONFIG_NEW_LEDS is not set
+# CONFIG_WATCHDOG is not set
 
 #
-# LED drivers
+# Sonics Silicon Backplane
 #
+CONFIG_SSB_POSSIBLE=y
+# CONFIG_SSB is not set
 
 #
-# LED Triggers
+# Multifunction device drivers
 #
+# CONFIG_MFD_SM501 is not set
 
 #
 # Multimedia devices
 #
 # CONFIG_VIDEO_DEV is not set
-CONFIG_VIDEO_V4L2=y
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
+# CONFIG_DVB_CORE is not set
+CONFIG_DAB=y
 
 #
 # Graphics support
 #
+# CONFIG_VGASTATE is not set
+# CONFIG_VIDEO_OUTPUT_CONTROL is not set
 CONFIG_FB=y
+# CONFIG_FIRMWARE_EDID is not set
+# CONFIG_FB_DDC is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
+# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
+# CONFIG_FB_SYS_FILLRECT is not set
+# CONFIG_FB_SYS_COPYAREA is not set
+# CONFIG_FB_SYS_IMAGEBLIT is not set
+# CONFIG_FB_SYS_FOPS is not set
+CONFIG_FB_DEFERRED_IO=y
+# CONFIG_FB_SVGALIB is not set
 # CONFIG_FB_MACMODES is not set
-CONFIG_FB_FIRMWARE_EDID=y
+# CONFIG_FB_BACKLIGHT is not set
 # CONFIG_FB_MODE_HELPERS is not set
 # CONFIG_FB_TILEBLITTING is not set
+
+#
+# Frame buffer hardware drivers
+#
 CONFIG_FB_ARMCLCD=y
 # CONFIG_FB_S1D13XXX is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
+
+#
+# Display device support
+#
+# CONFIG_DISPLAY_SUPPORT is not set
 
 #
 # Console display driver support
@@ -679,28 +655,25 @@ CONFIG_FB_ARMCLCD=y
 # CONFIG_VGA_CONSOLE is not set
 CONFIG_DUMMY_CONSOLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
+# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
 # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
 # CONFIG_FONTS is not set
 CONFIG_FONT_8x8=y
 CONFIG_FONT_8x16=y
-
-#
-# Logo configuration
-#
 CONFIG_LOGO=y
 CONFIG_LOGO_LINUX_MONO=y
 CONFIG_LOGO_LINUX_VGA16=y
 CONFIG_LOGO_LINUX_CLUT224=y
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
 
 #
 # Sound
 #
 # CONFIG_SOUND is not set
-
-#
-# USB support
-#
+CONFIG_HID_SUPPORT=y
+CONFIG_HID=y
+CONFIG_HID_DEBUG=y
+# CONFIG_HIDRAW is not set
+CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 # CONFIG_USB_ARCH_HAS_OHCI is not set
 # CONFIG_USB_ARCH_HAS_EHCI is not set
@@ -714,47 +687,57 @@ CONFIG_USB_ARCH_HAS_HCD=y
 # USB Gadget Support
 #
 # CONFIG_USB_GADGET is not set
+# CONFIG_MMC is not set
+# CONFIG_NEW_LEDS is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=m
 
 #
-# MMC/SD Card support
+# RTC interfaces
 #
-# CONFIG_MMC is not set
+CONFIG_RTC_INTF_SYSFS=y
+CONFIG_RTC_INTF_PROC=y
+CONFIG_RTC_INTF_DEV=y
+# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
+# CONFIG_RTC_DRV_TEST is not set
 
 #
-# Real Time Clock
+# SPI RTC drivers
 #
-CONFIG_RTC_LIB=y
-CONFIG_RTC_CLASS=m
 
 #
-# RTC interfaces
+# Platform RTC drivers
 #
-CONFIG_RTC_INTF_SYSFS=m
-CONFIG_RTC_INTF_PROC=m
-CONFIG_RTC_INTF_DEV=m
+# CONFIG_RTC_DRV_CMOS is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_V3020 is not set
 
 #
-# RTC drivers
+# on-CPU RTC drivers
 #
-# CONFIG_RTC_DRV_M48T86 is not set
-CONFIG_RTC_DRV_NETX=m
-# CONFIG_RTC_DRV_TEST is not set
+# CONFIG_RTC_DRV_PL031 is not set
 
 #
 # File systems
 #
 # CONFIG_EXT2_FS is not set
 # CONFIG_EXT3_FS is not set
+# CONFIG_EXT4DEV_FS is not set
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 # CONFIG_FS_POSIX_ACL is not set
 # CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
+# CONFIG_INOTIFY is not set
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
+# CONFIG_DNOTIFY is not set
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -776,10 +759,11 @@ CONFIG_DNOTIFY=y
 # Pseudo filesystems
 #
 CONFIG_PROC_FS=y
+CONFIG_PROC_SYSCTL=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
+# CONFIG_TMPFS_POSIX_ACL is not set
 # CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
 # CONFIG_CONFIGFS_FS is not set
 
 #
@@ -792,13 +776,15 @@ CONFIG_RAMFS=y
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
-# CONFIG_JFFS_FS is not set
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
+# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
 # CONFIG_JFFS2_SUMMARY is not set
+# CONFIG_JFFS2_FS_XATTR is not set
 # CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
 CONFIG_JFFS2_ZLIB=y
+# CONFIG_JFFS2_LZO is not set
 CONFIG_JFFS2_RTIME=y
 # CONFIG_JFFS2_RUBIN is not set
 # CONFIG_CRAMFS is not set
@@ -807,15 +793,12 @@ CONFIG_JFFS2_RTIME=y
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
 # CONFIG_NFS_V3_ACL is not set
 CONFIG_NFS_V4=y
-CONFIG_NFS_DIRECTIO=y
+# CONFIG_NFS_DIRECTIO is not set
 # CONFIG_NFSD is not set
 CONFIG_ROOT_NFS=y
 CONFIG_LOCKD=y
@@ -823,6 +806,7 @@ CONFIG_LOCKD_V4=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
+# CONFIG_SUNRPC_BIND34 is not set
 CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -830,96 +814,94 @@ CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_NCP_FS is not set
 # CONFIG_CODA_FS is not set
 # CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
 
 #
 # Partition Types
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
-# Profiling support
-#
-# CONFIG_PROFILING is not set
+# CONFIG_DLM is not set
+# CONFIG_INSTRUMENTATION is not set
 
 #
 # Kernel hacking
 #
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
+CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_LOG_BUF_SHIFT=17
-CONFIG_DETECT_SOFTLOCKUP=y
-# CONFIG_SCHEDSTATS is not set
-# CONFIG_DEBUG_SLAB is not set
-CONFIG_DEBUG_PREEMPT=y
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_KOBJECT is not set
-CONFIG_DEBUG_BUGVERBOSE=y
-# CONFIG_DEBUG_INFO is not set
+# CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_DEBUG_FS is not set
-# CONFIG_DEBUG_VM is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_FRAME_POINTER=y
-# CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
-# CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_SAMPLES is not set
 # CONFIG_DEBUG_USER is not set
-CONFIG_DEBUG_ERRORS=y
-# CONFIG_DEBUG_LL is not set
 
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
 CONFIG_CRYPTO=y
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_HMAC=y
-CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_MD4=m
+# CONFIG_CRYPTO_XCBC is not set
+# CONFIG_CRYPTO_NULL is not set
+# CONFIG_CRYPTO_MD4 is not set
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_SHA1=y
-CONFIG_CRYPTO_SHA256=m
-CONFIG_CRYPTO_SHA512=m
+# CONFIG_CRYPTO_SHA256 is not set
+# CONFIG_CRYPTO_SHA512 is not set
 # CONFIG_CRYPTO_WP512 is not set
 # CONFIG_CRYPTO_TGR192 is not set
+# CONFIG_CRYPTO_GF128MUL is not set
+# CONFIG_CRYPTO_ECB is not set
+CONFIG_CRYPTO_CBC=y
+# CONFIG_CRYPTO_PCBC is not set
+# CONFIG_CRYPTO_LRW is not set
+# CONFIG_CRYPTO_XTS is not set
+# CONFIG_CRYPTO_CRYPTD is not set
 CONFIG_CRYPTO_DES=y
-CONFIG_CRYPTO_BLOWFISH=m
-CONFIG_CRYPTO_TWOFISH=m
-CONFIG_CRYPTO_SERPENT=m
-CONFIG_CRYPTO_AES=m
-CONFIG_CRYPTO_CAST5=m
-CONFIG_CRYPTO_CAST6=m
+# CONFIG_CRYPTO_FCRYPT is not set
+# CONFIG_CRYPTO_BLOWFISH is not set
+# CONFIG_CRYPTO_TWOFISH is not set
+# CONFIG_CRYPTO_SERPENT is not set
+# CONFIG_CRYPTO_AES is not set
+# CONFIG_CRYPTO_CAST5 is not set
+# CONFIG_CRYPTO_CAST6 is not set
 # CONFIG_CRYPTO_TEA is not set
-CONFIG_CRYPTO_ARC4=m
+# CONFIG_CRYPTO_ARC4 is not set
 # CONFIG_CRYPTO_KHAZAD is not set
 # CONFIG_CRYPTO_ANUBIS is not set
+# CONFIG_CRYPTO_SEED is not set
 CONFIG_CRYPTO_DEFLATE=y
-CONFIG_CRYPTO_MICHAEL_MIC=m
-CONFIG_CRYPTO_CRC32C=m
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
+# CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_CAMELLIA is not set
 # CONFIG_CRYPTO_TEST is not set
-
-#
-# Hardware crypto devices
-#
+# CONFIG_CRYPTO_AUTHENC is not set
+# CONFIG_CRYPTO_HW is not set
 
 #
 # Library routines
 #
-CONFIG_CRC_CCITT=m
+CONFIG_BITREVERSE=y
+# CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
+# CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=y
-CONFIG_LIBCRC32C=m
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
+CONFIG_PLIST=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
diff --git a/arm/configs/netx_defconfig b/arm/configs/netx_defconfig
deleted file mode 100644
index 57f32f3..0000000
--- a/arm/configs/netx_defconfig
+++ /dev/null
@@ -1,925 +0,0 @@
-#
-# Automatically generated make config: don't edit
-# Linux kernel version: 2.6.17-rc6
-# Tue Jun  6 15:26:53 2006
-#
-CONFIG_ARM=y
-CONFIG_MMU=y
-CONFIG_RWSEM_GENERIC_SPINLOCK=y
-CONFIG_GENERIC_HWEIGHT=y
-CONFIG_GENERIC_CALIBRATE_DELAY=y
-CONFIG_VECTORS_BASE=0xffff0000
-
-#
-# Code maturity level options
-#
-CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_LOCK_KERNEL=y
-CONFIG_INIT_ENV_ARG_LIMIT=32
-
-#
-# General setup
-#
-CONFIG_LOCALVERSION=""
-CONFIG_LOCALVERSION_AUTO=y
-CONFIG_SWAP=y
-CONFIG_SYSVIPC=y
-CONFIG_POSIX_MQUEUE=y
-CONFIG_BSD_PROCESS_ACCT=y
-# CONFIG_BSD_PROCESS_ACCT_V3 is not set
-CONFIG_SYSCTL=y
-# CONFIG_AUDIT is not set
-CONFIG_IKCONFIG=y
-CONFIG_IKCONFIG_PROC=y
-# CONFIG_RELAY is not set
-CONFIG_INITRAMFS_SOURCE=""
-CONFIG_UID16=y
-CONFIG_CC_OPTIMIZE_FOR_SIZE=y
-# CONFIG_EMBEDDED is not set
-CONFIG_KALLSYMS=y
-# CONFIG_KALLSYMS_ALL is not set
-# CONFIG_KALLSYMS_EXTRA_PASS is not set
-CONFIG_HOTPLUG=y
-CONFIG_PRINTK=y
-CONFIG_BUG=y
-CONFIG_ELF_CORE=y
-CONFIG_BASE_FULL=y
-CONFIG_FUTEX=y
-CONFIG_EPOLL=y
-CONFIG_SHMEM=y
-CONFIG_SLAB=y
-# CONFIG_TINY_SHMEM is not set
-CONFIG_BASE_SMALL=0
-# CONFIG_SLOB is not set
-CONFIG_OBSOLETE_INTERMODULE=y
-
-#
-# Loadable module support
-#
-CONFIG_MODULES=y
-CONFIG_MODULE_UNLOAD=y
-CONFIG_MODULE_FORCE_UNLOAD=y
-# CONFIG_MODVERSIONS is not set
-# CONFIG_MODULE_SRCVERSION_ALL is not set
-CONFIG_KMOD=y
-
-#
-# Block layer
-#
-# CONFIG_BLK_DEV_IO_TRACE is not set
-
-#
-# IO Schedulers
-#
-CONFIG_IOSCHED_NOOP=y
-CONFIG_IOSCHED_AS=y
-CONFIG_IOSCHED_DEADLINE=y
-CONFIG_IOSCHED_CFQ=y
-CONFIG_DEFAULT_AS=y
-# CONFIG_DEFAULT_DEADLINE is not set
-# CONFIG_DEFAULT_CFQ is not set
-# CONFIG_DEFAULT_NOOP is not set
-CONFIG_DEFAULT_IOSCHED="anticipatory"
-
-#
-# System Type
-#
-# CONFIG_ARCH_CLPS7500 is not set
-# CONFIG_ARCH_CLPS711X is not set
-# CONFIG_ARCH_CO285 is not set
-# CONFIG_ARCH_EBSA110 is not set
-# CONFIG_ARCH_EP93XX is not set
-# CONFIG_ARCH_FOOTBRIDGE is not set
-# CONFIG_ARCH_INTEGRATOR is not set
-# CONFIG_ARCH_IOP3XX is not set
-# CONFIG_ARCH_IXP4XX is not set
-# CONFIG_ARCH_IXP2000 is not set
-# CONFIG_ARCH_IXP23XX is not set
-# CONFIG_ARCH_L7200 is not set
-# CONFIG_ARCH_PXA is not set
-# CONFIG_ARCH_RPC is not set
-# CONFIG_ARCH_SA1100 is not set
-# CONFIG_ARCH_S3C2410 is not set
-# CONFIG_ARCH_SHARK is not set
-# CONFIG_ARCH_LH7A40X is not set
-# CONFIG_ARCH_OMAP is not set
-# CONFIG_ARCH_VERSATILE is not set
-# CONFIG_ARCH_REALVIEW is not set
-# CONFIG_ARCH_IMX is not set
-# CONFIG_ARCH_H720X is not set
-# CONFIG_ARCH_AAEC2000 is not set
-# CONFIG_ARCH_AT91RM9200 is not set
-CONFIG_ARCH_NETX=y
-
-#
-# NetX Implementations
-#
-CONFIG_MACH_NXDKN=y
-CONFIG_MACH_NXDB500=y
-CONFIG_MACH_NXEB500HMI=y
-
-#
-# Processor Type
-#
-CONFIG_CPU_32=y
-CONFIG_CPU_ARM926T=y
-CONFIG_CPU_32v5=y
-CONFIG_CPU_ABRT_EV5TJ=y
-CONFIG_CPU_CACHE_VIVT=y
-CONFIG_CPU_COPY_V4WB=y
-CONFIG_CPU_TLB_V4WBI=y
-
-#
-# Processor Features
-#
-CONFIG_ARM_THUMB=y
-# CONFIG_CPU_ICACHE_DISABLE is not set
-# CONFIG_CPU_DCACHE_DISABLE is not set
-# CONFIG_CPU_DCACHE_WRITETHROUGH is not set
-# CONFIG_CPU_CACHE_ROUND_ROBIN is not set
-CONFIG_ARM_VIC=y
-
-#
-# Bus support
-#
-CONFIG_ARM_AMBA=y
-
-#
-# PCCARD (PCMCIA/CardBus) support
-#
-# CONFIG_PCCARD is not set
-
-#
-# Kernel Features
-#
-CONFIG_PREEMPT=y
-# CONFIG_NO_IDLE_HZ is not set
-CONFIG_HZ=100
-# CONFIG_AEABI is not set
-# CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
-CONFIG_SELECT_MEMORY_MODEL=y
-CONFIG_FLATMEM_MANUAL=y
-# CONFIG_DISCONTIGMEM_MANUAL is not set
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_FLATMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
-# CONFIG_SPARSEMEM_STATIC is not set
-CONFIG_SPLIT_PTLOCK_CPUS=4096
-CONFIG_ALIGNMENT_TRAP=y
-
-#
-# Boot options
-#
-CONFIG_ZBOOT_ROM_TEXT=0x0
-CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_CMDLINE="console=ttySMX0,115200"
-# CONFIG_XIP_KERNEL is not set
-
-#
-# Floating point emulation
-#
-
-#
-# At least one emulation must be selected
-#
-# CONFIG_FPE_NWFPE is not set
-# CONFIG_FPE_FASTFPE is not set
-# CONFIG_VFP is not set
-
-#
-# Userspace binary formats
-#
-CONFIG_BINFMT_ELF=y
-# CONFIG_BINFMT_AOUT is not set
-# CONFIG_BINFMT_MISC is not set
-# CONFIG_ARTHUR is not set
-
-#
-# Power management options
-#
-# CONFIG_PM is not set
-# CONFIG_APM is not set
-
-#
-# Networking
-#
-CONFIG_NET=y
-
-#
-# Networking options
-#
-# CONFIG_NETDEBUG is not set
-CONFIG_PACKET=y
-CONFIG_PACKET_MMAP=y
-CONFIG_UNIX=y
-CONFIG_XFRM=y
-CONFIG_XFRM_USER=m
-CONFIG_NET_KEY=y
-CONFIG_INET=y
-CONFIG_IP_MULTICAST=y
-# CONFIG_IP_ADVANCED_ROUTER is not set
-CONFIG_IP_FIB_HASH=y
-CONFIG_IP_PNP=y
-CONFIG_IP_PNP_DHCP=y
-# CONFIG_IP_PNP_BOOTP is not set
-# CONFIG_IP_PNP_RARP is not set
-# CONFIG_NET_IPIP is not set
-CONFIG_NET_IPGRE=m
-# CONFIG_NET_IPGRE_BROADCAST is not set
-# CONFIG_IP_MROUTE is not set
-# CONFIG_ARPD is not set
-CONFIG_SYN_COOKIES=y
-CONFIG_INET_AH=y
-CONFIG_INET_ESP=y
-CONFIG_INET_IPCOMP=y
-CONFIG_INET_XFRM_TUNNEL=y
-CONFIG_INET_TUNNEL=y
-CONFIG_INET_DIAG=y
-CONFIG_INET_TCP_DIAG=y
-# CONFIG_TCP_CONG_ADVANCED is not set
-CONFIG_TCP_CONG_BIC=y
-
-#
-# IP: Virtual Server Configuration
-#
-# CONFIG_IP_VS is not set
-CONFIG_IPV6=m
-# CONFIG_IPV6_PRIVACY is not set
-# CONFIG_IPV6_ROUTER_PREF is not set
-CONFIG_INET6_AH=m
-CONFIG_INET6_ESP=m
-CONFIG_INET6_IPCOMP=m
-CONFIG_INET6_XFRM_TUNNEL=m
-CONFIG_INET6_TUNNEL=m
-# CONFIG_IPV6_TUNNEL is not set
-CONFIG_NETFILTER=y
-# CONFIG_NETFILTER_DEBUG is not set
-
-#
-# Core Netfilter Configuration
-#
-# CONFIG_NETFILTER_NETLINK is not set
-# CONFIG_NETFILTER_XTABLES is not set
-
-#
-# IP: Netfilter Configuration
-#
-CONFIG_IP_NF_CONNTRACK=m
-# CONFIG_IP_NF_CT_ACCT is not set
-# CONFIG_IP_NF_CONNTRACK_MARK is not set
-# CONFIG_IP_NF_CONNTRACK_EVENTS is not set
-# CONFIG_IP_NF_CT_PROTO_SCTP is not set
-CONFIG_IP_NF_FTP=m
-CONFIG_IP_NF_IRC=m
-# CONFIG_IP_NF_NETBIOS_NS is not set
-CONFIG_IP_NF_TFTP=m
-CONFIG_IP_NF_AMANDA=m
-# CONFIG_IP_NF_PPTP is not set
-# CONFIG_IP_NF_H323 is not set
-CONFIG_IP_NF_QUEUE=m
-
-#
-# IPv6: Netfilter Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP6_NF_QUEUE is not set
-
-#
-# DCCP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_DCCP is not set
-
-#
-# SCTP Configuration (EXPERIMENTAL)
-#
-# CONFIG_IP_SCTP is not set
-
-#
-# TIPC Configuration (EXPERIMENTAL)
-#
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
-# CONFIG_NET_DIVERT is not set
-# CONFIG_ECONET is not set
-# CONFIG_WAN_ROUTER is not set
-
-#
-# QoS and/or fair queueing
-#
-# CONFIG_NET_SCHED is not set
-
-#
-# Network testing
-#
-CONFIG_NET_PKTGEN=m
-# CONFIG_HAMRADIO is not set
-# CONFIG_IRDA is not set
-# CONFIG_BT is not set
-# CONFIG_IEEE80211 is not set
-
-#
-# Device Drivers
-#
-
-#
-# Generic Driver Options
-#
-CONFIG_STANDALONE=y
-CONFIG_PREVENT_FIRMWARE_BUILD=y
-CONFIG_FW_LOADER=y
-# CONFIG_DEBUG_DRIVER is not set
-
-#
-# Connector - unified userspace <-> kernelspace linker
-#
-# CONFIG_CONNECTOR is not set
-
-#
-# Memory Technology Devices (MTD)
-#
-CONFIG_MTD=y
-# CONFIG_MTD_DEBUG is not set
-# CONFIG_MTD_CONCAT is not set
-CONFIG_MTD_PARTITIONS=y
-# CONFIG_MTD_REDBOOT_PARTS is not set
-CONFIG_MTD_CMDLINE_PARTS=y
-# CONFIG_MTD_AFS_PARTS is not set
-
-#
-# User Modules And Translation Layers
-#
-CONFIG_MTD_CHAR=y
-CONFIG_MTD_BLOCK=y
-# CONFIG_FTL is not set
-# CONFIG_NFTL is not set
-# CONFIG_INFTL is not set
-# CONFIG_RFD_FTL is not set
-
-#
-# RAM/ROM/Flash chip drivers
-#
-CONFIG_MTD_CFI=y
-# CONFIG_MTD_JEDECPROBE is not set
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
-CONFIG_MTD_CFI_INTELEXT=y
-# CONFIG_MTD_CFI_AMDSTD is not set
-# CONFIG_MTD_CFI_STAA is not set
-CONFIG_MTD_CFI_UTIL=y
-CONFIG_MTD_RAM=y
-# CONFIG_MTD_ROM is not set
-# CONFIG_MTD_ABSENT is not set
-# CONFIG_MTD_OBSOLETE_CHIPS is not set
-
-#
-# Mapping drivers for chip access
-#
-# CONFIG_MTD_COMPLEX_MAPPINGS is not set
-# CONFIG_MTD_PHYSMAP is not set
-# CONFIG_MTD_ARM_INTEGRATOR is not set
-CONFIG_MTD_PLATRAM=y
-
-#
-# Self-contained MTD device drivers
-#
-# CONFIG_MTD_SLRAM is not set
-# CONFIG_MTD_PHRAM is not set
-# CONFIG_MTD_MTDRAM is not set
-# CONFIG_MTD_BLOCK2MTD is not set
-
-#
-# Disk-On-Chip Device Drivers
-#
-# CONFIG_MTD_DOC2000 is not set
-# CONFIG_MTD_DOC2001 is not set
-# CONFIG_MTD_DOC2001PLUS is not set
-
-#
-# NAND Flash Device Drivers
-#
-# CONFIG_MTD_NAND is not set
-
-#
-# OneNAND Flash Device Drivers
-#
-# CONFIG_MTD_ONENAND is not set
-
-#
-# Parallel port support
-#
-# CONFIG_PARPORT is not set
-
-#
-# Plug and Play support
-#
-
-#
-# Block devices
-#
-# CONFIG_BLK_DEV_COW_COMMON is not set
-CONFIG_BLK_DEV_LOOP=m
-CONFIG_BLK_DEV_CRYPTOLOOP=m
-# CONFIG_BLK_DEV_NBD is not set
-# CONFIG_BLK_DEV_RAM is not set
-# CONFIG_BLK_DEV_INITRD is not set
-# CONFIG_CDROM_PKTCDVD is not set
-# CONFIG_ATA_OVER_ETH is not set
-
-#
-# SCSI device support
-#
-# CONFIG_RAID_ATTRS is not set
-# CONFIG_SCSI is not set
-
-#
-# Multi-device support (RAID and LVM)
-#
-# CONFIG_MD is not set
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
-CONFIG_NETDEVICES=y
-# CONFIG_DUMMY is not set
-# CONFIG_BONDING is not set
-# CONFIG_EQUALIZER is not set
-# CONFIG_TUN is not set
-
-#
-# PHY device support
-#
-# CONFIG_PHYLIB is not set
-
-#
-# Ethernet (10 or 100Mbit)
-#
-CONFIG_NET_ETHERNET=y
-CONFIG_MII=y
-# CONFIG_SMC91X is not set
-CONFIG_NET_NETX=y
-# CONFIG_DM9000 is not set
-
-#
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
-#
-# CONFIG_WAN is not set
-# CONFIG_PPP is not set
-# CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
-# CONFIG_NETCONSOLE is not set
-# CONFIG_NETPOLL is not set
-# CONFIG_NET_POLL_CONTROLLER is not set
-
-#
-# ISDN subsystem
-#
-# CONFIG_ISDN is not set
-
-#
-# Input device support
-#
-CONFIG_INPUT=y
-
-#
-# Userland interfaces
-#
-CONFIG_INPUT_MOUSEDEV=y
-# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
-CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
-CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
-# CONFIG_INPUT_JOYDEV is not set
-# CONFIG_INPUT_TSDEV is not set
-# CONFIG_INPUT_EVDEV is not set
-# CONFIG_INPUT_EVBUG is not set
-
-#
-# Input Device Drivers
-#
-# CONFIG_INPUT_KEYBOARD is not set
-# CONFIG_INPUT_MOUSE is not set
-# CONFIG_INPUT_JOYSTICK is not set
-# CONFIG_INPUT_TOUCHSCREEN is not set
-# CONFIG_INPUT_MISC is not set
-
-#
-# Hardware I/O ports
-#
-CONFIG_SERIO=y
-CONFIG_SERIO_SERPORT=y
-# CONFIG_SERIO_AMBAKMI is not set
-# CONFIG_SERIO_RAW is not set
-# CONFIG_GAMEPORT is not set
-
-#
-# Character devices
-#
-CONFIG_VT=y
-CONFIG_VT_CONSOLE=y
-CONFIG_HW_CONSOLE=y
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
-# CONFIG_SERIAL_AMBA_PL010 is not set
-# CONFIG_SERIAL_AMBA_PL011 is not set
-CONFIG_SERIAL_CORE=y
-CONFIG_SERIAL_CORE_CONSOLE=y
-CONFIG_SERIAL_NETX=y
-CONFIG_SERIAL_NETX_CONSOLE=y
-CONFIG_UNIX98_PTYS=y
-CONFIG_LEGACY_PTYS=y
-CONFIG_LEGACY_PTY_COUNT=256
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
-CONFIG_NVRAM=m
-# CONFIG_DTLK is not set
-# CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
-# CONFIG_RAW_DRIVER is not set
-
-#
-# TPM devices
-#
-# CONFIG_TCG_TPM is not set
-# CONFIG_TELCLOCK is not set
-
-#
-# I2C support
-#
-# CONFIG_I2C is not set
-
-#
-# SPI support
-#
-# CONFIG_SPI is not set
-# CONFIG_SPI_MASTER is not set
-
-#
-# Dallas's 1-wire bus
-#
-# CONFIG_W1 is not set
-
-#
-# Hardware Monitoring support
-#
-# CONFIG_HWMON is not set
-# CONFIG_HWMON_VID is not set
-
-#
-# Misc devices
-#
-
-#
-# LED devices
-#
-# CONFIG_NEW_LEDS is not set
-
-#
-# LED drivers
-#
-
-#
-# LED Triggers
-#
-
-#
-# Multimedia devices
-#
-# CONFIG_VIDEO_DEV is not set
-CONFIG_VIDEO_V4L2=y
-
-#
-# Digital Video Broadcasting Devices
-#
-# CONFIG_DVB is not set
-
-#
-# Graphics support
-#
-CONFIG_FB=y
-CONFIG_FB_CFB_FILLRECT=y
-CONFIG_FB_CFB_COPYAREA=y
-CONFIG_FB_CFB_IMAGEBLIT=y
-# CONFIG_FB_MACMODES is not set
-CONFIG_FB_FIRMWARE_EDID=y
-# CONFIG_FB_MODE_HELPERS is not set
-# CONFIG_FB_TILEBLITTING is not set
-CONFIG_FB_ARMCLCD=y
-# CONFIG_FB_S1D13XXX is not set
-# CONFIG_FB_VIRTUAL is not set
-
-#
-# Console display driver support
-#
-# CONFIG_VGA_CONSOLE is not set
-CONFIG_DUMMY_CONSOLE=y
-CONFIG_FRAMEBUFFER_CONSOLE=y
-# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
-# CONFIG_FONTS is not set
-CONFIG_FONT_8x8=y
-CONFIG_FONT_8x16=y
-
-#
-# Logo configuration
-#
-CONFIG_LOGO=y
-CONFIG_LOGO_LINUX_MONO=y
-CONFIG_LOGO_LINUX_VGA16=y
-CONFIG_LOGO_LINUX_CLUT224=y
-# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
-
-#
-# Sound
-#
-# CONFIG_SOUND is not set
-
-#
-# USB support
-#
-CONFIG_USB_ARCH_HAS_HCD=y
-# CONFIG_USB_ARCH_HAS_OHCI is not set
-# CONFIG_USB_ARCH_HAS_EHCI is not set
-# CONFIG_USB is not set
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
-# CONFIG_MMC is not set
-
-#
-# Real Time Clock
-#
-CONFIG_RTC_LIB=y
-CONFIG_RTC_CLASS=m
-
-#
-# RTC interfaces
-#
-CONFIG_RTC_INTF_SYSFS=m
-CONFIG_RTC_INTF_PROC=m
-CONFIG_RTC_INTF_DEV=m
-
-#
-# RTC drivers
-#
-# CONFIG_RTC_DRV_M48T86 is not set
-CONFIG_RTC_DRV_NETX=m
-# CONFIG_RTC_DRV_TEST is not set
-
-#
-# File systems
-#
-# CONFIG_EXT2_FS is not set
-# CONFIG_EXT3_FS is not set
-# CONFIG_REISERFS_FS is not set
-# CONFIG_JFS_FS is not set
-# CONFIG_FS_POSIX_ACL is not set
-# CONFIG_XFS_FS is not set
-# CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
-CONFIG_INOTIFY=y
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
-CONFIG_SYSFS=y
-CONFIG_TMPFS=y
-# CONFIG_HUGETLB_PAGE is not set
-CONFIG_RAMFS=y
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
-# CONFIG_JFFS_FS is not set
-CONFIG_JFFS2_FS=y
-CONFIG_JFFS2_FS_DEBUG=0
-CONFIG_JFFS2_FS_WRITEBUFFER=y
-# CONFIG_JFFS2_SUMMARY is not set
-# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
-CONFIG_JFFS2_ZLIB=y
-CONFIG_JFFS2_RTIME=y
-# CONFIG_JFFS2_RUBIN is not set
-# CONFIG_CRAMFS is not set
-# CONFIG_VXFS_FS is not set
-# CONFIG_HPFS_FS is not set
-# CONFIG_QNX4FS_FS is not set
-# CONFIG_SYSV_FS is not set
-# CONFIG_UFS_FS is not set
-
-#
-# Network File Systems
-#
-CONFIG_NFS_FS=y
-CONFIG_NFS_V3=y
-# CONFIG_NFS_V3_ACL is not set
-CONFIG_NFS_V4=y
-CONFIG_NFS_DIRECTIO=y
-# CONFIG_NFSD is not set
-CONFIG_ROOT_NFS=y
-CONFIG_LOCKD=y
-CONFIG_LOCKD_V4=y
-CONFIG_NFS_COMMON=y
-CONFIG_SUNRPC=y
-CONFIG_SUNRPC_GSS=y
-CONFIG_RPCSEC_GSS_KRB5=y
-# CONFIG_RPCSEC_GSS_SPKM3 is not set
-# CONFIG_SMB_FS is not set
-# CONFIG_CIFS is not set
-# CONFIG_NCP_FS is not set
-# CONFIG_CODA_FS is not set
-# CONFIG_AFS_FS is not set
-# CONFIG_9P_FS is not set
-
-#
-# Partition Types
-#
-# CONFIG_PARTITION_ADVANCED is not set
-CONFIG_MSDOS_PARTITION=y
-
-#
-# Native Language Support
-#
-# CONFIG_NLS is not set
-
-#
-# Profiling support
-#
-# CONFIG_PROFILING is not set
-
-#
-# Kernel hacking
-#
-# CONFIG_PRINTK_TIME is not set
-CONFIG_MAGIC_SYSRQ=y
-CONFIG_DEBUG_KERNEL=y
-CONFIG_LOG_BUF_SHIFT=17
-CONFIG_DETECT_SOFTLOCKUP=y
-# CONFIG_SCHEDSTATS is not set
-# CONFIG_DEBUG_SLAB is not set
-CONFIG_DEBUG_PREEMPT=y
-# CONFIG_DEBUG_MUTEXES is not set
-# CONFIG_DEBUG_SPINLOCK is not set
-# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
-# CONFIG_DEBUG_KOBJECT is not set
-CONFIG_DEBUG_BUGVERBOSE=y
-# CONFIG_DEBUG_INFO is not set
-# CONFIG_DEBUG_FS is not set
-# CONFIG_DEBUG_VM is not set
-CONFIG_FRAME_POINTER=y
-# CONFIG_UNWIND_INFO is not set
-CONFIG_FORCED_INLINING=y
-# CONFIG_RCU_TORTURE_TEST is not set
-# CONFIG_DEBUG_USER is not set
-CONFIG_DEBUG_ERRORS=y
-# CONFIG_DEBUG_LL is not set
-
-#
-# Security options
-#
-# CONFIG_KEYS is not set
-# CONFIG_SECURITY is not set
-
-#
-# Cryptographic options
-#
-CONFIG_CRYPTO=y
-CONFIG_CRYPTO_HMAC=y
-CONFIG_CRYPTO_NULL=m
-CONFIG_CRYPTO_MD4=m
-CONFIG_CRYPTO_MD5=y
-CONFIG_CRYPTO_SHA1=y
-CONFIG_CRYPTO_SHA256=m
-CONFIG_CRYPTO_SHA512=m
-# CONFIG_CRYPTO_WP512 is not set
-# CONFIG_CRYPTO_TGR192 is not set
-CONFIG_CRYPTO_DES=y
-CONFIG_CRYPTO_BLOWFISH=m
-CONFIG_CRYPTO_TWOFISH=m
-CONFIG_CRYPTO_SERPENT=m
-CONFIG_CRYPTO_AES=m
-CONFIG_CRYPTO_CAST5=m
-CONFIG_CRYPTO_CAST6=m
-# CONFIG_CRYPTO_TEA is not set
-CONFIG_CRYPTO_ARC4=m
-# CONFIG_CRYPTO_KHAZAD is not set
-# CONFIG_CRYPTO_ANUBIS is not set
-CONFIG_CRYPTO_DEFLATE=y
-CONFIG_CRYPTO_MICHAEL_MIC=m
-CONFIG_CRYPTO_CRC32C=m
-# CONFIG_CRYPTO_TEST is not set
-
-#
-# Hardware crypto devices
-#
-
-#
-# Library routines
-#
-CONFIG_CRC_CCITT=m
-# CONFIG_CRC16 is not set
-CONFIG_CRC32=y
-CONFIG_LIBCRC32C=m
-CONFIG_ZLIB_INFLATE=y
-CONFIG_ZLIB_DEFLATE=y
-- 
1.5.3.4

