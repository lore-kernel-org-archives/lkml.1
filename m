Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0CKUK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:10:26 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:29682 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518Ab0CKUKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:10:23 -0500
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
To: linux@arm.linux.org.uk, mroberto@cpti.cetuc.puc-rio.br
Cc: mad_soft@inbox.ru, rpjday@crashcourse.ca, jaswinderrajput@gmail.com,
       kristoffer.ericson@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mach-sa1100: Put nanoEngine support back in the kernel.
Date: Thu, 11 Mar 2010 17:09:59 -0300
Message-Id: <1268338199-32222-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Bright Star Engineering's nanoEngine board support to the kernel.

Signed-off-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
---
 arch/arm/configs/nanoengine_defconfig | 1396 +++++++++++++++++++++++++++++++++
 arch/arm/mach-sa1100/Kconfig          |    8 +
 arch/arm/mach-sa1100/Makefile         |    2 +
 arch/arm/mach-sa1100/nanoengine.c     |  116 +++
 4 files changed, 1522 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/configs/nanoengine_defconfig
 create mode 100644 arch/arm/mach-sa1100/nanoengine.c

diff --git a/arch/arm/configs/nanoengine_defconfig b/arch/arm/configs/nanoengine_defconfig
new file mode 100644
index 0000000..a56d55c
--- /dev/null
+++ b/arch/arm/configs/nanoengine_defconfig
@@ -0,0 +1,1396 @@
+#
+# Automatically generated make config: don't edit
+# Linux kernel version: 2.6.34-rc1
+# Tue Mar  9 14:17:28 2010
+#
+CONFIG_ARM=y
+CONFIG_SYS_SUPPORTS_APM_EMULATION=y
+CONFIG_GENERIC_GPIO=y
+CONFIG_GENERIC_TIME=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_HAVE_PROC_CPU=y
+CONFIG_GENERIC_HARDIRQS=y
+CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
+CONFIG_LOCKDEP_SUPPORT=y
+CONFIG_TRACE_IRQFLAGS_SUPPORT=y
+CONFIG_HARDIRQS_SW_RESEND=y
+CONFIG_GENERIC_IRQ_PROBE=y
+CONFIG_RWSEM_GENERIC_SPINLOCK=y
+CONFIG_ARCH_HAS_CPUFREQ=y
+CONFIG_GENERIC_HWEIGHT=y
+CONFIG_GENERIC_CALIBRATE_DELAY=y
+CONFIG_ARCH_MTD_XIP=y
+CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
+CONFIG_VECTORS_BASE=0xffff0000
+CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
+
+#
+# General setup
+#
+CONFIG_EXPERIMENTAL=y
+CONFIG_BROKEN_ON_SMP=y
+CONFIG_LOCK_KERNEL=y
+CONFIG_INIT_ENV_ARG_LIMIT=32
+CONFIG_LOCALVERSION=""
+# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_HAVE_KERNEL_GZIP=y
+CONFIG_HAVE_KERNEL_LZO=y
+CONFIG_KERNEL_GZIP=y
+# CONFIG_KERNEL_BZIP2 is not set
+# CONFIG_KERNEL_LZMA is not set
+# CONFIG_KERNEL_LZO is not set
+CONFIG_SWAP=y
+# CONFIG_SYSVIPC is not set
+# CONFIG_POSIX_MQUEUE is not set
+# CONFIG_BSD_PROCESS_ACCT is not set
+# CONFIG_TASKSTATS is not set
+# CONFIG_AUDIT is not set
+
+#
+# RCU Subsystem
+#
+# CONFIG_TREE_RCU is not set
+CONFIG_TREE_PREEMPT_RCU=y
+# CONFIG_TINY_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=32
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_IKCONFIG is not set
+CONFIG_LOG_BUF_SHIFT=18
+# CONFIG_CGROUPS is not set
+# CONFIG_SYSFS_DEPRECATED_V2 is not set
+# CONFIG_RELAY is not set
+CONFIG_NAMESPACES=y
+# CONFIG_UTS_NS is not set
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
+# CONFIG_NET_NS is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
+CONFIG_RD_LZO=y
+CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+CONFIG_SYSCTL=y
+CONFIG_ANON_INODES=y
+# CONFIG_EMBEDDED is not set
+CONFIG_UID16=y
+CONFIG_SYSCTL_SYSCALL=y
+CONFIG_KALLSYMS=y
+# CONFIG_KALLSYMS_EXTRA_PASS is not set
+CONFIG_HOTPLUG=y
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
+CONFIG_HAVE_PERF_EVENTS=y
+CONFIG_PERF_USE_VMALLOC=y
+
+#
+# Kernel Performance Events And Counters
+#
+# CONFIG_PERF_EVENTS is not set
+# CONFIG_PERF_COUNTERS is not set
+CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_COMPAT_BRK=y
+CONFIG_SLAB=y
+# CONFIG_SLUB is not set
+# CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+CONFIG_HAVE_OPROFILE=y
+# CONFIG_KPROBES is not set
+CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
+CONFIG_HAVE_CLK=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_SLOW_WORK is not set
+CONFIG_HAVE_GENERIC_DMA_COHERENT=y
+CONFIG_SLABINFO=y
+CONFIG_RT_MUTEXES=y
+CONFIG_BASE_SMALL=0
+CONFIG_MODULES=y
+CONFIG_MODULE_FORCE_LOAD=y
+CONFIG_MODULE_UNLOAD=y
+CONFIG_MODULE_FORCE_UNLOAD=y
+CONFIG_MODVERSIONS=y
+CONFIG_MODULE_SRCVERSION_ALL=y
+CONFIG_BLOCK=y
+CONFIG_LBDAF=y
+CONFIG_BLK_DEV_BSG=y
+# CONFIG_BLK_DEV_INTEGRITY is not set
+
+#
+# IO Schedulers
+#
+CONFIG_IOSCHED_NOOP=y
+CONFIG_IOSCHED_DEADLINE=y
+CONFIG_IOSCHED_CFQ=y
+# CONFIG_DEFAULT_DEADLINE is not set
+CONFIG_DEFAULT_CFQ=y
+# CONFIG_DEFAULT_NOOP is not set
+CONFIG_DEFAULT_IOSCHED="cfq"
+# CONFIG_INLINE_SPIN_TRYLOCK is not set
+# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK is not set
+# CONFIG_INLINE_SPIN_LOCK_BH is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_SPIN_UNLOCK is not set
+# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
+# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
+# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_READ_TRYLOCK is not set
+# CONFIG_INLINE_READ_LOCK is not set
+# CONFIG_INLINE_READ_LOCK_BH is not set
+# CONFIG_INLINE_READ_LOCK_IRQ is not set
+# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_READ_UNLOCK is not set
+# CONFIG_INLINE_READ_UNLOCK_BH is not set
+# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
+# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
+# CONFIG_INLINE_WRITE_TRYLOCK is not set
+# CONFIG_INLINE_WRITE_LOCK is not set
+# CONFIG_INLINE_WRITE_LOCK_BH is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
+# CONFIG_INLINE_WRITE_UNLOCK is not set
+# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
+# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
+# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
+# CONFIG_MUTEX_SPIN_ON_OWNER is not set
+# CONFIG_FREEZER is not set
+
+#
+# System Type
+#
+CONFIG_MMU=y
+# CONFIG_ARCH_AAEC2000 is not set
+# CONFIG_ARCH_INTEGRATOR is not set
+# CONFIG_ARCH_REALVIEW is not set
+# CONFIG_ARCH_VERSATILE is not set
+# CONFIG_ARCH_AT91 is not set
+# CONFIG_ARCH_CLPS711X is not set
+# CONFIG_ARCH_GEMINI is not set
+# CONFIG_ARCH_EBSA110 is not set
+# CONFIG_ARCH_EP93XX is not set
+# CONFIG_ARCH_FOOTBRIDGE is not set
+# CONFIG_ARCH_MXC is not set
+# CONFIG_ARCH_STMP3XXX is not set
+# CONFIG_ARCH_NETX is not set
+# CONFIG_ARCH_H720X is not set
+# CONFIG_ARCH_NOMADIK is not set
+# CONFIG_ARCH_IOP13XX is not set
+# CONFIG_ARCH_IOP32X is not set
+# CONFIG_ARCH_IOP33X is not set
+# CONFIG_ARCH_IXP23XX is not set
+# CONFIG_ARCH_IXP2000 is not set
+# CONFIG_ARCH_IXP4XX is not set
+# CONFIG_ARCH_L7200 is not set
+# CONFIG_ARCH_DOVE is not set
+# CONFIG_ARCH_KIRKWOOD is not set
+# CONFIG_ARCH_LOKI is not set
+# CONFIG_ARCH_MV78XX0 is not set
+# CONFIG_ARCH_ORION5X is not set
+# CONFIG_ARCH_MMP is not set
+# CONFIG_ARCH_KS8695 is not set
+# CONFIG_ARCH_NS9XXX is not set
+# CONFIG_ARCH_W90X900 is not set
+# CONFIG_ARCH_NUC93X is not set
+# CONFIG_ARCH_PNX4008 is not set
+# CONFIG_ARCH_PXA is not set
+# CONFIG_ARCH_MSM is not set
+# CONFIG_ARCH_RPC is not set
+CONFIG_ARCH_SA1100=y
+# CONFIG_ARCH_S3C2410 is not set
+# CONFIG_ARCH_S3C64XX is not set
+# CONFIG_ARCH_S5PC1XX is not set
+# CONFIG_ARCH_SHARK is not set
+# CONFIG_ARCH_LH7A40X is not set
+# CONFIG_ARCH_U300 is not set
+# CONFIG_ARCH_DAVINCI is not set
+# CONFIG_ARCH_OMAP is not set
+# CONFIG_ARCH_BCMRING is not set
+# CONFIG_ARCH_U8500 is not set
+
+#
+# SA11x0 Implementations
+#
+# CONFIG_SA1100_ASSABET is not set
+# CONFIG_SA1100_CERF is not set
+# CONFIG_SA1100_COLLIE is not set
+# CONFIG_SA1100_H3100 is not set
+# CONFIG_SA1100_H3600 is not set
+# CONFIG_SA1100_BADGE4 is not set
+# CONFIG_SA1100_JORNADA720 is not set
+# CONFIG_SA1100_HACKKIT is not set
+# CONFIG_SA1100_LART is not set
+CONFIG_SA1100_NANOENGINE=y
+# CONFIG_SA1100_PLEB is not set
+# CONFIG_SA1100_SHANNON is not set
+# CONFIG_SA1100_SIMPAD is not set
+# CONFIG_SA1100_SSP is not set
+
+#
+# Processor Type
+#
+CONFIG_CPU_SA1100=y
+CONFIG_CPU_32v4=y
+CONFIG_CPU_ABRT_EV4=y
+CONFIG_CPU_PABRT_LEGACY=y
+CONFIG_CPU_CACHE_V4WB=y
+CONFIG_CPU_CACHE_VIVT=y
+CONFIG_CPU_TLB_V4WB=y
+CONFIG_CPU_CP15=y
+CONFIG_CPU_CP15_MMU=y
+
+#
+# Processor Features
+#
+# CONFIG_CPU_ICACHE_DISABLE is not set
+# CONFIG_CPU_DCACHE_DISABLE is not set
+CONFIG_ARM_L1_CACHE_SHIFT=5
+
+#
+# Bus support
+#
+CONFIG_ISA=y
+# CONFIG_PCI_SYSCALL is not set
+# CONFIG_ARCH_SUPPORTS_MSI is not set
+CONFIG_PCCARD=y
+CONFIG_PCMCIA=y
+CONFIG_PCMCIA_LOAD_CIS=y
+
+#
+# PC-card bridges
+#
+# CONFIG_I82365 is not set
+# CONFIG_TCIC is not set
+CONFIG_PCMCIA_SOC_COMMON=y
+CONFIG_PCMCIA_SA1100=y
+CONFIG_PCMCIA_DEBUG=y
+
+#
+# Kernel Features
+#
+CONFIG_TICK_ONESHOT=y
+# CONFIG_NO_HZ is not set
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+CONFIG_VMSPLIT_3G=y
+# CONFIG_VMSPLIT_2G is not set
+# CONFIG_VMSPLIT_1G is not set
+CONFIG_PAGE_OFFSET=0xC0000000
+# CONFIG_PREEMPT_NONE is not set
+# CONFIG_PREEMPT_VOLUNTARY is not set
+CONFIG_PREEMPT=y
+CONFIG_HZ=100
+# CONFIG_AEABI is not set
+CONFIG_ARCH_SPARSEMEM_ENABLE=y
+CONFIG_ARCH_SPARSEMEM_DEFAULT=y
+# CONFIG_ARCH_SELECT_MEMORY_MODEL is not set
+# CONFIG_HIGHMEM is not set
+CONFIG_SELECT_MEMORY_MODEL=y
+# CONFIG_FLATMEM_MANUAL is not set
+# CONFIG_DISCONTIGMEM_MANUAL is not set
+CONFIG_SPARSEMEM_MANUAL=y
+CONFIG_SPARSEMEM=y
+CONFIG_HAVE_MEMORY_PRESENT=y
+CONFIG_SPARSEMEM_EXTREME=y
+CONFIG_SPLIT_PTLOCK_CPUS=999999
+# CONFIG_PHYS_ADDR_T_64BIT is not set
+CONFIG_ZONE_DMA_FLAG=0
+CONFIG_VIRT_TO_BUS=y
+# CONFIG_KSM is not set
+CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
+# CONFIG_LEDS is not set
+CONFIG_ALIGNMENT_TRAP=y
+# CONFIG_UACCESS_WITH_MEMCPY is not set
+
+#
+# Boot options
+#
+CONFIG_ZBOOT_ROM_TEXT=0x11000
+CONFIG_ZBOOT_ROM_BSS=0xc1e00000
+# CONFIG_ZBOOT_ROM is not set
+CONFIG_CMDLINE="mtdparts=sa1100:64k(param)ro,704k(kernel),1280k(initrd),-(jffs2) console=ttySA0 root=/dev/ram"
+# CONFIG_XIP_KERNEL is not set
+CONFIG_KEXEC=y
+CONFIG_ATAGS_PROC=y
+
+#
+# CPU Power Management
+#
+CONFIG_CPU_FREQ=y
+CONFIG_CPU_FREQ_TABLE=y
+# CONFIG_CPU_FREQ_DEBUG is not set
+CONFIG_CPU_FREQ_STAT=y
+# CONFIG_CPU_FREQ_STAT_DETAILS is not set
+CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
+# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
+# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
+CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
+# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
+# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
+# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
+# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
+CONFIG_CPU_FREQ_SA1100=y
+# CONFIG_CPU_IDLE is not set
+
+#
+# Floating point emulation
+#
+
+#
+# At least one emulation must be selected
+#
+CONFIG_FPE_NWFPE=y
+# CONFIG_FPE_NWFPE_XP is not set
+# CONFIG_FPE_FASTFPE is not set
+
+#
+# Userspace binary formats
+#
+CONFIG_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+CONFIG_HAVE_AOUT=y
+# CONFIG_BINFMT_AOUT is not set
+# CONFIG_BINFMT_MISC is not set
+# CONFIG_ARTHUR is not set
+
+#
+# Power management options
+#
+# CONFIG_PM is not set
+CONFIG_ARCH_SUSPEND_POSSIBLE=y
+CONFIG_NET=y
+
+#
+# Networking options
+#
+# CONFIG_PACKET is not set
+CONFIG_UNIX=y
+# CONFIG_NET_KEY is not set
+CONFIG_INET=y
+# CONFIG_IP_MULTICAST is not set
+# CONFIG_IP_ADVANCED_ROUTER is not set
+CONFIG_IP_FIB_HASH=y
+CONFIG_IP_PNP=y
+CONFIG_IP_PNP_DHCP=y
+CONFIG_IP_PNP_BOOTP=y
+CONFIG_IP_PNP_RARP=y
+# CONFIG_NET_IPIP is not set
+# CONFIG_NET_IPGRE is not set
+# CONFIG_ARPD is not set
+# CONFIG_SYN_COOKIES is not set
+# CONFIG_INET_AH is not set
+# CONFIG_INET_ESP is not set
+# CONFIG_INET_IPCOMP is not set
+# CONFIG_INET_XFRM_TUNNEL is not set
+# CONFIG_INET_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
+# CONFIG_INET_XFRM_MODE_TUNNEL is not set
+# CONFIG_INET_XFRM_MODE_BEET is not set
+CONFIG_INET_LRO=y
+# CONFIG_INET_DIAG is not set
+# CONFIG_TCP_CONG_ADVANCED is not set
+CONFIG_TCP_CONG_CUBIC=y
+CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
+# CONFIG_IPV6 is not set
+# CONFIG_NETWORK_SECMARK is not set
+# CONFIG_NETFILTER is not set
+# CONFIG_IP_DCCP is not set
+# CONFIG_IP_SCTP is not set
+# CONFIG_RDS is not set
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
+# CONFIG_PHONET is not set
+# CONFIG_IEEE802154 is not set
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
+# CONFIG_WIRELESS is not set
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
+CONFIG_UEVENT_HELPER_PATH=""
+# CONFIG_DEVTMPFS is not set
+# CONFIG_STANDALONE is not set
+CONFIG_PREVENT_FIRMWARE_BUILD=y
+CONFIG_FW_LOADER=y
+# CONFIG_FIRMWARE_IN_KERNEL is not set
+CONFIG_EXTRA_FIRMWARE=""
+# CONFIG_SYS_HYPERVISOR is not set
+# CONFIG_CONNECTOR is not set
+CONFIG_MTD=y
+# CONFIG_MTD_DEBUG is not set
+# CONFIG_MTD_TESTS is not set
+# CONFIG_MTD_CONCAT is not set
+CONFIG_MTD_PARTITIONS=y
+# CONFIG_MTD_REDBOOT_PARTS is not set
+CONFIG_MTD_CMDLINE_PARTS=y
+CONFIG_MTD_AFS_PARTS=y
+# CONFIG_MTD_AR7_PARTS is not set
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
+CONFIG_MTD_CFI_INTELEXT=y
+CONFIG_MTD_CFI_AMDSTD=y
+CONFIG_MTD_CFI_STAA=y
+CONFIG_MTD_CFI_UTIL=y
+# CONFIG_MTD_RAM is not set
+# CONFIG_MTD_ROM is not set
+# CONFIG_MTD_ABSENT is not set
+# CONFIG_MTD_XIP is not set
+
+#
+# Mapping drivers for chip access
+#
+# CONFIG_MTD_COMPLEX_MAPPINGS is not set
+# CONFIG_MTD_PHYSMAP is not set
+# CONFIG_MTD_ARM_INTEGRATOR is not set
+CONFIG_MTD_SA1100=y
+# CONFIG_MTD_IMPA7 is not set
+# CONFIG_MTD_PLATRAM is not set
+
+#
+# Self-contained MTD device drivers
+#
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
+# LPDDR flash memory drivers
+#
+# CONFIG_MTD_LPDDR is not set
+
+#
+# UBI - Unsorted block images
+#
+# CONFIG_MTD_UBI is not set
+# CONFIG_PARPORT is not set
+# CONFIG_PNP is not set
+CONFIG_BLK_DEV=y
+# CONFIG_BLK_DEV_COW_COMMON is not set
+CONFIG_BLK_DEV_LOOP=m
+# CONFIG_BLK_DEV_CRYPTOLOOP is not set
+
+#
+# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
+#
+# CONFIG_BLK_DEV_NBD is not set
+# CONFIG_BLK_DEV_UB is not set
+CONFIG_BLK_DEV_RAM=y
+CONFIG_BLK_DEV_RAM_COUNT=16
+CONFIG_BLK_DEV_RAM_SIZE=128000
+# CONFIG_BLK_DEV_XIP is not set
+# CONFIG_CDROM_PKTCDVD is not set
+# CONFIG_ATA_OVER_ETH is not set
+# CONFIG_MG_DISK is not set
+CONFIG_MISC_DEVICES=y
+# CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_93CX6 is not set
+CONFIG_HAVE_IDE=y
+CONFIG_IDE=y
+
+#
+# Please see Documentation/ide/ide.txt for help/info on IDE drives
+#
+CONFIG_IDE_ATAPI=y
+# CONFIG_BLK_DEV_IDE_SATA is not set
+CONFIG_IDE_GD=y
+CONFIG_IDE_GD_ATA=y
+# CONFIG_IDE_GD_ATAPI is not set
+CONFIG_BLK_DEV_IDECS=m
+CONFIG_BLK_DEV_IDECD=m
+CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
+# CONFIG_BLK_DEV_IDETAPE is not set
+# CONFIG_IDE_TASK_IOCTL is not set
+CONFIG_IDE_PROC_FS=y
+
+#
+# IDE chipset support/bugfixes
+#
+# CONFIG_BLK_DEV_PLATFORM is not set
+# CONFIG_BLK_DEV_IDEDMA is not set
+
+#
+# SCSI device support
+#
+# CONFIG_RAID_ATTRS is not set
+CONFIG_SCSI=m
+CONFIG_SCSI_DMA=y
+# CONFIG_SCSI_TGT is not set
+# CONFIG_SCSI_NETLINK is not set
+CONFIG_SCSI_PROC_FS=y
+
+#
+# SCSI support type (disk, tape, CD-ROM)
+#
+CONFIG_BLK_DEV_SD=m
+# CONFIG_CHR_DEV_ST is not set
+# CONFIG_CHR_DEV_OSST is not set
+# CONFIG_BLK_DEV_SR is not set
+CONFIG_CHR_DEV_SG=m
+# CONFIG_CHR_DEV_SCH is not set
+# CONFIG_SCSI_MULTI_LUN is not set
+# CONFIG_SCSI_CONSTANTS is not set
+# CONFIG_SCSI_LOGGING is not set
+# CONFIG_SCSI_SCAN_ASYNC is not set
+CONFIG_SCSI_WAIT_SCAN=m
+
+#
+# SCSI Transports
+#
+# CONFIG_SCSI_SPI_ATTRS is not set
+# CONFIG_SCSI_FC_ATTRS is not set
+# CONFIG_SCSI_ISCSI_ATTRS is not set
+# CONFIG_SCSI_SAS_ATTRS is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+# CONFIG_SCSI_SRP_ATTRS is not set
+# CONFIG_SCSI_LOWLEVEL is not set
+# CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
+# CONFIG_SCSI_DH is not set
+# CONFIG_SCSI_OSD_INITIATOR is not set
+CONFIG_ATA=m
+# CONFIG_ATA_NONSTANDARD is not set
+CONFIG_ATA_VERBOSE_ERROR=y
+# CONFIG_SATA_PMP is not set
+CONFIG_ATA_SFF=y
+# CONFIG_SATA_MV is not set
+# CONFIG_PATA_LEGACY is not set
+CONFIG_PATA_PCMCIA=m
+# CONFIG_PATA_QDI is not set
+# CONFIG_PATA_WINBOND_VLB is not set
+# CONFIG_MD is not set
+CONFIG_NETDEVICES=y
+CONFIG_DUMMY=m
+# CONFIG_BONDING is not set
+# CONFIG_MACVLAN is not set
+# CONFIG_EQUALIZER is not set
+CONFIG_TUN=m
+# CONFIG_VETH is not set
+# CONFIG_ARCNET is not set
+# CONFIG_PHYLIB is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+# CONFIG_AX88796 is not set
+# CONFIG_NET_VENDOR_3COM is not set
+# CONFIG_NET_VENDOR_SMC is not set
+# CONFIG_SMC91X is not set
+# CONFIG_DM9000 is not set
+# CONFIG_ETHOC is not set
+# CONFIG_SMC911X is not set
+# CONFIG_SMSC911X is not set
+# CONFIG_NET_VENDOR_RACAL is not set
+# CONFIG_DNET is not set
+# CONFIG_AT1700 is not set
+# CONFIG_DEPCA is not set
+# CONFIG_HP100 is not set
+# CONFIG_NET_ISA is not set
+# CONFIG_IBM_NEW_EMAC_ZMII is not set
+# CONFIG_IBM_NEW_EMAC_RGMII is not set
+# CONFIG_IBM_NEW_EMAC_TAH is not set
+# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+CONFIG_NET_PCI=y
+# CONFIG_AC3200 is not set
+# CONFIG_APRICOT is not set
+# CONFIG_B44 is not set
+# CONFIG_CS89x0 is not set
+# CONFIG_KS8842 is not set
+# CONFIG_KS8851_MLL is not set
+# CONFIG_NETDEV_1000 is not set
+# CONFIG_NETDEV_10000 is not set
+# CONFIG_TR is not set
+# CONFIG_WLAN is not set
+
+#
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+
+#
+# USB Network Adapters
+#
+# CONFIG_USB_CATC is not set
+# CONFIG_USB_KAWETH is not set
+# CONFIG_USB_PEGASUS is not set
+# CONFIG_USB_RTL8150 is not set
+# CONFIG_USB_USBNET is not set
+# CONFIG_NET_PCMCIA is not set
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
+# CONFIG_INPUT_SPARSEKMAP is not set
+
+#
+# Userland interfaces
+#
+CONFIG_INPUT_MOUSEDEV=y
+CONFIG_INPUT_MOUSEDEV_PSAUX=y
+CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
+CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
+# CONFIG_INPUT_JOYDEV is not set
+CONFIG_INPUT_EVDEV=y
+# CONFIG_INPUT_EVBUG is not set
+
+#
+# Input Device Drivers
+#
+# CONFIG_INPUT_KEYBOARD is not set
+CONFIG_INPUT_MOUSE=y
+CONFIG_MOUSE_PS2=y
+CONFIG_MOUSE_PS2_ALPS=y
+CONFIG_MOUSE_PS2_LOGIPS2PP=y
+CONFIG_MOUSE_PS2_SYNAPTICS=y
+CONFIG_MOUSE_PS2_TRACKPOINT=y
+# CONFIG_MOUSE_PS2_ELANTECH is not set
+# CONFIG_MOUSE_PS2_SENTELIC is not set
+# CONFIG_MOUSE_PS2_TOUCHKIT is not set
+# CONFIG_MOUSE_SERIAL is not set
+# CONFIG_MOUSE_APPLETOUCH is not set
+# CONFIG_MOUSE_BCM5974 is not set
+# CONFIG_MOUSE_INPORT is not set
+# CONFIG_MOUSE_LOGIBM is not set
+# CONFIG_MOUSE_PC110PAD is not set
+# CONFIG_MOUSE_VSXXXAA is not set
+# CONFIG_MOUSE_GPIO is not set
+# CONFIG_INPUT_JOYSTICK is not set
+# CONFIG_INPUT_TABLET is not set
+# CONFIG_INPUT_TOUCHSCREEN is not set
+CONFIG_INPUT_MISC=y
+# CONFIG_INPUT_ATI_REMOTE is not set
+# CONFIG_INPUT_ATI_REMOTE2 is not set
+# CONFIG_INPUT_KEYSPAN_REMOTE is not set
+# CONFIG_INPUT_POWERMATE is not set
+# CONFIG_INPUT_YEALINK is not set
+# CONFIG_INPUT_CM109 is not set
+# CONFIG_INPUT_UINPUT is not set
+# CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
+
+#
+# Hardware I/O ports
+#
+CONFIG_SERIO=y
+CONFIG_SERIO_SERPORT=y
+CONFIG_SERIO_LIBPS2=y
+# CONFIG_SERIO_RAW is not set
+# CONFIG_SERIO_ALTERA_PS2 is not set
+# CONFIG_GAMEPORT is not set
+
+#
+# Character devices
+#
+CONFIG_VT=y
+CONFIG_CONSOLE_TRANSLATIONS=y
+CONFIG_VT_CONSOLE=y
+CONFIG_HW_CONSOLE=y
+CONFIG_VT_HW_CONSOLE_BINDING=y
+# CONFIG_DEVKMEM is not set
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
+CONFIG_SERIAL_SA1100=y
+CONFIG_SERIAL_SA1100_CONSOLE=y
+CONFIG_SERIAL_CORE=y
+CONFIG_SERIAL_CORE_CONSOLE=y
+# CONFIG_SERIAL_TIMBERDALE is not set
+CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
+# CONFIG_LEGACY_PTYS is not set
+# CONFIG_IPMI_HANDLER is not set
+CONFIG_HW_RANDOM=y
+CONFIG_HW_RANDOM_TIMERIOMEM=y
+# CONFIG_DTLK is not set
+# CONFIG_R3964 is not set
+
+#
+# PCMCIA character devices
+#
+# CONFIG_SYNCLINK_CS is not set
+# CONFIG_CARDMAN_4000 is not set
+# CONFIG_CARDMAN_4040 is not set
+# CONFIG_IPWIRELESS is not set
+CONFIG_RAW_DRIVER=y
+CONFIG_MAX_RAW_DEVS=4096
+# CONFIG_TCG_TPM is not set
+CONFIG_DEVPORT=y
+# CONFIG_I2C is not set
+# CONFIG_SPI is not set
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
+CONFIG_ARCH_REQUIRE_GPIOLIB=y
+CONFIG_GPIOLIB=y
+# CONFIG_GPIO_SYSFS is not set
+
+#
+# Memory mapped GPIO expanders:
+#
+# CONFIG_GPIO_IT8761E is not set
+
+#
+# I2C GPIO expanders:
+#
+
+#
+# PCI GPIO expanders:
+#
+
+#
+# SPI GPIO expanders:
+#
+
+#
+# AC97 GPIO expanders:
+#
+# CONFIG_W1 is not set
+# CONFIG_POWER_SUPPLY is not set
+# CONFIG_HWMON is not set
+# CONFIG_THERMAL is not set
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
+# CONFIG_MFD_ASIC3 is not set
+# CONFIG_HTC_EGPIO is not set
+# CONFIG_HTC_PASIC3 is not set
+# CONFIG_MFD_TMIO is not set
+# CONFIG_MFD_T7L66XB is not set
+# CONFIG_MFD_TC6387XB is not set
+# CONFIG_MFD_TC6393XB is not set
+
+#
+# Multimedia Capabilities Port drivers
+#
+# CONFIG_MCP_SA11X0 is not set
+# CONFIG_REGULATOR is not set
+# CONFIG_MEDIA_SUPPORT is not set
+
+#
+# Graphics support
+#
+# CONFIG_VGASTATE is not set
+CONFIG_VIDEO_OUTPUT_CONTROL=y
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
+# CONFIG_MDA_CONSOLE is not set
+CONFIG_DUMMY_CONSOLE=y
+# CONFIG_SOUND is not set
+CONFIG_HID_SUPPORT=y
+# CONFIG_HID is not set
+
+#
+# USB Input Devices
+#
+# CONFIG_USB_HID is not set
+# CONFIG_HID_PID is not set
+CONFIG_USB_SUPPORT=y
+CONFIG_USB_ARCH_HAS_HCD=y
+# CONFIG_USB_ARCH_HAS_OHCI is not set
+# CONFIG_USB_ARCH_HAS_EHCI is not set
+CONFIG_USB=m
+# CONFIG_USB_DEBUG is not set
+CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
+
+#
+# Miscellaneous USB options
+#
+# CONFIG_USB_DEVICEFS is not set
+# CONFIG_USB_DEVICE_CLASS is not set
+# CONFIG_USB_DYNAMIC_MINORS is not set
+# CONFIG_USB_OTG is not set
+# CONFIG_USB_MON is not set
+# CONFIG_USB_WUSB is not set
+# CONFIG_USB_WUSB_CBAF is not set
+
+#
+# USB Host Controller Drivers
+#
+# CONFIG_USB_C67X00_HCD is not set
+# CONFIG_USB_OXU210HP_HCD is not set
+# CONFIG_USB_ISP116X_HCD is not set
+# CONFIG_USB_ISP1760_HCD is not set
+# CONFIG_USB_ISP1362_HCD is not set
+# CONFIG_USB_SL811_HCD is not set
+# CONFIG_USB_R8A66597_HCD is not set
+# CONFIG_USB_HWA_HCD is not set
+
+#
+# Enable Host or Gadget support to see Inventra options
+#
+# CONFIG_USB_MUSB_HDRC is not set
+
+#
+# USB Device Class drivers
+#
+# CONFIG_USB_ACM is not set
+# CONFIG_USB_PRINTER is not set
+# CONFIG_USB_WDM is not set
+# CONFIG_USB_TMC is not set
+
+#
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
+#
+
+#
+# also be needed; see USB_STORAGE Help for more info
+#
+CONFIG_USB_STORAGE=m
+# CONFIG_USB_STORAGE_DEBUG is not set
+# CONFIG_USB_STORAGE_DATAFAB is not set
+# CONFIG_USB_STORAGE_FREECOM is not set
+# CONFIG_USB_STORAGE_ISD200 is not set
+# CONFIG_USB_STORAGE_USBAT is not set
+# CONFIG_USB_STORAGE_SDDR09 is not set
+# CONFIG_USB_STORAGE_SDDR55 is not set
+# CONFIG_USB_STORAGE_JUMPSHOT is not set
+# CONFIG_USB_STORAGE_ALAUDA is not set
+# CONFIG_USB_STORAGE_ONETOUCH is not set
+# CONFIG_USB_STORAGE_KARMA is not set
+# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
+# CONFIG_USB_LIBUSUAL is not set
+
+#
+# USB Imaging devices
+#
+# CONFIG_USB_MDC800 is not set
+# CONFIG_USB_MICROTEK is not set
+
+#
+# USB port drivers
+#
+# CONFIG_USB_SERIAL is not set
+
+#
+# USB Miscellaneous drivers
+#
+# CONFIG_USB_EMI62 is not set
+# CONFIG_USB_EMI26 is not set
+# CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_SEVSEG is not set
+# CONFIG_USB_RIO500 is not set
+# CONFIG_USB_LEGOTOWER is not set
+# CONFIG_USB_LCD is not set
+# CONFIG_USB_LED is not set
+# CONFIG_USB_CYPRESS_CY7C63 is not set
+# CONFIG_USB_CYTHERM is not set
+# CONFIG_USB_IDMOUSE is not set
+# CONFIG_USB_FTDI_ELAN is not set
+# CONFIG_USB_APPLEDISPLAY is not set
+# CONFIG_USB_LD is not set
+# CONFIG_USB_TRANCEVIBRATOR is not set
+# CONFIG_USB_IOWARRIOR is not set
+# CONFIG_USB_TEST is not set
+# CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_GADGET is not set
+
+#
+# OTG and related infrastructure
+#
+# CONFIG_USB_GPIO_VBUS is not set
+# CONFIG_USB_ULPI is not set
+# CONFIG_NOP_USB_XCEIV is not set
+# CONFIG_MMC is not set
+# CONFIG_MEMSTICK is not set
+# CONFIG_NEW_LEDS is not set
+# CONFIG_ACCESSIBILITY is not set
+CONFIG_RTC_LIB=y
+CONFIG_RTC_CLASS=y
+CONFIG_RTC_HCTOSYS=y
+CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
+CONFIG_RTC_DEBUG=y
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
+# SPI RTC drivers
+#
+
+#
+# Platform RTC drivers
+#
+# CONFIG_RTC_DRV_CMOS is not set
+# CONFIG_RTC_DRV_DS1286 is not set
+# CONFIG_RTC_DRV_DS1511 is not set
+# CONFIG_RTC_DRV_DS1553 is not set
+# CONFIG_RTC_DRV_DS1742 is not set
+# CONFIG_RTC_DRV_STK17TA8 is not set
+# CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
+# CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_MSM6242 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
+# CONFIG_RTC_DRV_RP5C01 is not set
+# CONFIG_RTC_DRV_V3020 is not set
+
+#
+# on-CPU RTC drivers
+#
+CONFIG_RTC_DRV_SA1100=y
+CONFIG_DMADEVICES=y
+# CONFIG_DMADEVICES_DEBUG is not set
+
+#
+# DMA Devices
+#
+# CONFIG_AUXDISPLAY is not set
+# CONFIG_UIO is not set
+
+#
+# TI VLYNQ
+#
+# CONFIG_STAGING is not set
+
+#
+# File systems
+#
+CONFIG_EXT2_FS=y
+# CONFIG_EXT2_FS_XATTR is not set
+# CONFIG_EXT2_FS_XIP is not set
+# CONFIG_EXT3_FS is not set
+# CONFIG_EXT4_FS is not set
+# CONFIG_REISERFS_FS is not set
+# CONFIG_JFS_FS is not set
+CONFIG_FS_POSIX_ACL=y
+# CONFIG_XFS_FS is not set
+# CONFIG_GFS2_FS is not set
+# CONFIG_OCFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
+# CONFIG_NILFS2_FS is not set
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
+# CONFIG_DNOTIFY is not set
+# CONFIG_INOTIFY is not set
+CONFIG_INOTIFY_USER=y
+# CONFIG_QUOTA is not set
+# CONFIG_AUTOFS_FS is not set
+# CONFIG_AUTOFS4_FS is not set
+# CONFIG_FUSE_FS is not set
+CONFIG_GENERIC_ACL=y
+
+#
+# Caches
+#
+# CONFIG_FSCACHE is not set
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
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SYSFS=y
+CONFIG_TMPFS=y
+CONFIG_TMPFS_POSIX_ACL=y
+# CONFIG_HUGETLB_PAGE is not set
+CONFIG_CONFIGFS_FS=y
+CONFIG_MISC_FILESYSTEMS=y
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
+CONFIG_JFFS2_COMPRESSION_OPTIONS=y
+CONFIG_JFFS2_ZLIB=y
+CONFIG_JFFS2_LZO=y
+CONFIG_JFFS2_RTIME=y
+# CONFIG_JFFS2_RUBIN is not set
+# CONFIG_JFFS2_CMODE_NONE is not set
+CONFIG_JFFS2_CMODE_PRIORITY=y
+# CONFIG_JFFS2_CMODE_SIZE is not set
+# CONFIG_JFFS2_CMODE_FAVOURLZO is not set
+# CONFIG_LOGFS is not set
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
+# CONFIG_NETWORK_FILESYSTEMS is not set
+
+#
+# Partition Types
+#
+CONFIG_PARTITION_ADVANCED=y
+# CONFIG_ACORN_PARTITION is not set
+# CONFIG_OSF_PARTITION is not set
+# CONFIG_AMIGA_PARTITION is not set
+# CONFIG_ATARI_PARTITION is not set
+# CONFIG_MAC_PARTITION is not set
+CONFIG_MSDOS_PARTITION=y
+# CONFIG_BSD_DISKLABEL is not set
+# CONFIG_MINIX_SUBPARTITION is not set
+# CONFIG_SOLARIS_X86_PARTITION is not set
+# CONFIG_UNIXWARE_DISKLABEL is not set
+# CONFIG_LDM_PARTITION is not set
+# CONFIG_SGI_PARTITION is not set
+# CONFIG_ULTRIX_PARTITION is not set
+# CONFIG_SUN_PARTITION is not set
+# CONFIG_KARMA_PARTITION is not set
+# CONFIG_EFI_PARTITION is not set
+# CONFIG_SYSV68_PARTITION is not set
+CONFIG_NLS=y
+CONFIG_NLS_DEFAULT="utf8"
+CONFIG_NLS_CODEPAGE_437=m
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
+CONFIG_NLS_ISO8859_1=m
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
+CONFIG_NLS_UTF8=m
+# CONFIG_DLM is not set
+
+#
+# Kernel hacking
+#
+# CONFIG_PRINTK_TIME is not set
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
+# CONFIG_ENABLE_MUST_CHECK is not set
+CONFIG_FRAME_WARN=1024
+# CONFIG_MAGIC_SYSRQ is not set
+# CONFIG_STRIP_ASM_SYMS is not set
+# CONFIG_UNUSED_SYMBOLS is not set
+# CONFIG_DEBUG_FS is not set
+# CONFIG_HEADERS_CHECK is not set
+# CONFIG_DEBUG_KERNEL is not set
+CONFIG_DEBUG_BUGVERBOSE=y
+CONFIG_DEBUG_MEMORY_INIT=y
+CONFIG_FRAME_POINTER=y
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
+# CONFIG_LATENCYTOP is not set
+# CONFIG_SYSCTL_SYSCALL_CHECK is not set
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_TRACING_SUPPORT=y
+# CONFIG_FTRACE is not set
+# CONFIG_SAMPLES is not set
+CONFIG_HAVE_ARCH_KGDB=y
+# CONFIG_DEBUG_USER is not set
+# CONFIG_OC_ETM is not set
+
+#
+# Security options
+#
+# CONFIG_KEYS is not set
+# CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
+# CONFIG_DEFAULT_SECURITY_SELINUX is not set
+# CONFIG_DEFAULT_SECURITY_SMACK is not set
+# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
+CONFIG_DEFAULT_SECURITY_DAC=y
+CONFIG_DEFAULT_SECURITY=""
+CONFIG_CRYPTO=y
+
+#
+# Crypto core or helper
+#
+CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+CONFIG_CRYPTO_PCOMP=y
+# CONFIG_CRYPTO_MANAGER is not set
+# CONFIG_CRYPTO_MANAGER2 is not set
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
+# CONFIG_CRYPTO_CBC is not set
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
+# CONFIG_CRYPTO_VMAC is not set
+
+#
+# Digest
+#
+CONFIG_CRYPTO_CRC32C=y
+# CONFIG_CRYPTO_GHASH is not set
+# CONFIG_CRYPTO_MD4 is not set
+# CONFIG_CRYPTO_MD5 is not set
+# CONFIG_CRYPTO_MICHAEL_MIC is not set
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
+# CONFIG_CRYPTO_DES is not set
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
+CONFIG_CRYPTO_ZLIB=y
+CONFIG_CRYPTO_LZO=y
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
+# CONFIG_CRYPTO_HW is not set
+# CONFIG_BINARY_PRINTF is not set
+
+#
+# Library routines
+#
+CONFIG_BITREVERSE=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
+# CONFIG_CRC_CCITT is not set
+# CONFIG_CRC16 is not set
+# CONFIG_CRC_T10DIF is not set
+# CONFIG_CRC_ITU_T is not set
+CONFIG_CRC32=y
+# CONFIG_CRC7 is not set
+# CONFIG_LIBCRC32C is not set
+CONFIG_ZLIB_INFLATE=y
+CONFIG_ZLIB_DEFLATE=y
+CONFIG_LZO_COMPRESS=y
+CONFIG_LZO_DECOMPRESS=y
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_DECOMPRESS_BZIP2=y
+CONFIG_DECOMPRESS_LZMA=y
+CONFIG_DECOMPRESS_LZO=y
+CONFIG_HAS_IOMEM=y
+CONFIG_HAS_IOPORT=y
+CONFIG_HAS_DMA=y
+CONFIG_NLATTR=y
+CONFIG_GENERIC_ATOMIC64=y
diff --git a/arch/arm/mach-sa1100/Kconfig b/arch/arm/mach-sa1100/Kconfig
index b17d52f..e6ce667 100644
--- a/arch/arm/mach-sa1100/Kconfig
+++ b/arch/arm/mach-sa1100/Kconfig
@@ -118,6 +118,14 @@ config SA1100_LART
 	  (also known as the LART).  See <http://www.lartmaker.nl/> for
 	  information on the LART.
 
+config SA1100_NANOENGINE
+	bool "nanoEngine"
+	select CPU_FREQ_SA1100
+	help
+	  Say Y here if you are using the Bright Star Engineering nanoEngine.
+	  See <http://www.brightstareng.com/arm/nanoeng.htm> for information
+	  on the BSE nanoEngine.
+
 config SA1100_PLEB
 	bool "PLEB"
 	select CPU_FREQ_SA1100
diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 89349c1..8029fe2 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -37,6 +37,8 @@ obj-$(CONFIG_SA1100_JORNADA720_SSP)	+= jornada720_ssp.o
 obj-$(CONFIG_SA1100_LART)		+= lart.o
 led-$(CONFIG_SA1100_LART)		+= leds-lart.o
 
+obj-$(CONFIG_SA1100_NANOENGINE)		+= nanoengine.o
+
 obj-$(CONFIG_SA1100_PLEB)		+= pleb.o
 
 obj-$(CONFIG_SA1100_SHANNON)		+= shannon.o
diff --git a/arch/arm/mach-sa1100/nanoengine.c b/arch/arm/mach-sa1100/nanoengine.c
new file mode 100644
index 0000000..7ac23e5
--- /dev/null
+++ b/arch/arm/mach-sa1100/nanoengine.c
@@ -0,0 +1,116 @@
+/*
+ * linux/arch/arm/mach-sa1100/nanoengine.c
+ *
+ * Bright Star Engineering's nanoEngine board init code.
+ *
+ * Copyright (C) 2009 Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/root_dev.h>
+#include <linux/tty.h>
+
+#include <asm/mach-types.h>
+#include <asm/setup.h>
+
+#include <asm/mach/arch.h>
+#include <asm/mach/flash.h>
+#include <asm/mach/map.h>
+#include <asm/mach/serial_sa1100.h>
+
+#include <mach/hardware.h>
+
+#include "generic.h"
+
+/* Flash bank 0 */
+static struct mtd_partition nanoengine_partitions[] = {
+	{
+	.name		= "nanoEngine boot firmware and parameter table",
+	.size		= 0x00010000,  /* 32K */
+	.offset		= 0,
+	.mask_flags	= MTD_WRITEABLE,
+	}, {
+	.name		= "kernel/initrd reserved",
+	.size		= 0x002f0000,
+	.offset		= 0x00010000,
+	.mask_flags	= MTD_WRITEABLE,
+	}, {
+	.name		= "experimental filesystem allocation",
+	.size		= 0x00100000,
+	.offset		= 0x00300000,
+	.mask_flags	= MTD_WRITEABLE,
+	}
+};
+
+static struct flash_platform_data nanoengine_flash_data = {
+	.map_name	= "jedec_probe",
+	.parts		= nanoengine_partitions,
+	.nr_parts	= ARRAY_SIZE(nanoengine_partitions),
+};
+
+static struct resource nanoengine_flash_resources[] = {
+	{
+	.start	= SA1100_CS0_PHYS,
+	.end	= SA1100_CS0_PHYS + SZ_32M - 1,
+	.flags	= IORESOURCE_MEM,
+	}, {
+	.start	= SA1100_CS1_PHYS,
+	.end	= SA1100_CS1_PHYS + SZ_32M - 1,
+	.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct map_desc nanoengine_io_desc[] __initdata = {
+	{
+	/* System Registers */
+	.virtual	= 0xf0000000,
+	.pfn		= __phys_to_pfn(0x10000000),
+	.length		= 0x00100000,
+	.type		= MT_DEVICE
+	}, {
+	/* Internal PCI Config Space */
+	.virtual	= 0xf1000000,
+	.pfn		= __phys_to_pfn(0x18A00000),
+	.length		= 0x00100000,
+	.type		= MT_DEVICE
+	}
+};
+
+static void __init nanoengine_map_io(void)
+{
+	sa1100_map_io();
+	iotable_init(nanoengine_io_desc, ARRAY_SIZE(nanoengine_io_desc));
+
+	sa1100_register_uart(0, 1);
+	sa1100_register_uart(1, 2);
+	sa1100_register_uart(2, 3);
+	Ser1SDCR0 |= SDCR0_UART;
+	/* disable IRDA -- UART2 is used as a normal serial port */
+	Ser2UTCR4 = 0;
+	Ser2HSCR0 = 0;
+}
+
+static void __init nanoengine_init(void)
+{
+	sa11x0_register_mtd(&nanoengine_flash_data, nanoengine_flash_resources,
+		ARRAY_SIZE(nanoengine_flash_resources));
+}
+
+MACHINE_START(NANOENGINE, "BSE nanoEngine")
+	.phys_io	= 0x80000000,
+	.io_pg_offst	= ((0xf8000000) >> 18) & 0xfffc,
+	.boot_params	= 0xc0000000,
+	.map_io		= nanoengine_map_io,
+	.init_irq	= sa1100_init_irq,
+	.timer		= &sa1100_timer,
+	.init_machine	= nanoengine_init,
+MACHINE_END
+
-- 
1.7.0.1

