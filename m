Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZKSMQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZKSMQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 07:16:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZKSMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 07:16:06 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:60627 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZKSMQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 07:16:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=le1dX8zd/qqiTd5wGaW4r3eyP7WgHOOGzcS46RPG2AF5aPYboiunABWVa4bAJa+Jw0
         JDn9o4FFSM4ZmdFJAgGfqUE/bTBXCxJKCoQBezRHZAjNkOAbUNDWrtQyC1Q8m4kWHa6V
         pybaiBAQHF3rFcQCcNjqhlCX4eVxul0izcLfE=
MIME-Version: 1.0
Date: Thu, 19 Nov 2009 13:16:05 +0100
Message-ID: <d0ced6d70911190416w3a354a50jcb0e93934805ca07@mail.gmail.com>
Subject: Crash 2.6.19
From: bluedefense bluedefense <bbbluedefense@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I really dont know if this is the right mailing list. But I have a
really serious problem with the linux kernel on a production server.
The kernel version is 2.6.19 and the following is my config:

-------------- CUT
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.19.2
# Mon Jan 14 09:18:58 2008
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# Code maturity level options
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32

#
# General setup
#
CONFIG_LOCALVERSION="mykernelname2007"
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
# CONFIG_IPC_NS is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_UTS_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_CPUSETS is not set
# CONFIG_RELAY is not set
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
# CONFIG_SLOB is not set

#
# Loadable module support
#
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
CONFIG_MODVERSIONS=y
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y

#
# Block layer
#
CONFIG_BLOCK=y
# CONFIG_LBD is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
# CONFIG_LSF is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_AS=y
# CONFIG_DEFAULT_DEADLINE is not set
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="anticipatory"

#
# Processor type and features
#
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
CONFIG_MPENTIUM4=y
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_CMPXCHG=y
CONFIG_X86_XADD=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
# CONFIG_HPET_TIMER is not set
CONFIG_NR_CPUS=2
CONFIG_SCHED_SMT=y
# CONFIG_SCHED_MC is not set
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
# CONFIG_X86_REBOOTFIXUPS is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y

#
# Firmware Drivers
#
# CONFIG_EDD is not set
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_RESOURCES_64BIT is not set
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
# CONFIG_EFI is not set
CONFIG_IRQBALANCE=y
# CONFIG_REGPARM is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
# CONFIG_KEXEC is not set
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x100000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_HOTKEY is not set
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_IBM is not set
# CONFIG_ACPI_TOSHIBA is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set

#
# APM (Advanced Power Management) BIOS Support
#
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# Bus options (PCI, PCMCIA, EISA, MCA, ISA)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_HT_IRQ is not set
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

#
# PCI Hotplug Support
#
# CONFIG_HOTPLUG_PCI is not set

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
# CONFIG_NETDEBUG is not set
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set

#
# DCCP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP is not set

#
# SCTP Configuration (EXPERIMENTAL)
#
# CONFIG_IP_SCTP is not set

#
# TIPC Configuration (EXPERIMENTAL)
#
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set

#
# QoS and/or fair queueing
#
# CONFIG_NET_SCHED is not set

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_IEEE80211 is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
# CONFIG_FW_LOADER is not set
# CONFIG_SYS_HYPERVISOR is not set

#
# Connector - unified userspace <-> kernelspace linker
#
# CONFIG_CONNECTOR is not set

#
# Memory Technology Devices (MTD)
#
# CONFIG_MTD is not set

#
# Parallel port support
#
# CONFIG_PARPORT is not set

#
# Plug and Play support
#
# CONFIG_PNP is not set

#
# Block devices
#
CONFIG_BLK_DEV_FD=y
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set

#
# Misc devices
#
# CONFIG_IBM_ASM is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set

#
# ATA/ATAPI/MFM/RLL support
#
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives
#
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEFLOPPY is not set
# CONFIG_BLK_DEV_IDESCSI is not set
# CONFIG_IDE_TASK_IOCTL is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_IDEPCI_SHARE_IRQ is not set
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=y
# CONFIG_BLK_DEV_OPTI621 is not set
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
# CONFIG_BLK_DEV_IDEDMA_FORCED is not set
# CONFIG_IDEDMA_PCI_AUTO is not set
# CONFIG_BLK_DEV_AEC62XX is not set
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
# CONFIG_BLK_DEV_ATIIXP is not set
# CONFIG_BLK_DEV_CMD64X is not set
# CONFIG_BLK_DEV_TRIFLEX is not set
# CONFIG_BLK_DEV_CY82C693 is not set
# CONFIG_BLK_DEV_CS5520 is not set
# CONFIG_BLK_DEV_CS5530 is not set
# CONFIG_BLK_DEV_CS5535 is not set
# CONFIG_BLK_DEV_HPT34X is not set
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
CONFIG_BLK_DEV_PIIX=y
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_BLK_DEV_PDC202XX_NEW is not set
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
# CONFIG_BLK_DEV_TRM290 is not set
# CONFIG_BLK_DEV_VIA82CXXX is not set
# CONFIG_IDE_ARM is not set
CONFIG_BLK_DEV_IDEDMA=y
# CONFIG_IDEDMA_IVB is not set
# CONFIG_IDEDMA_AUTO is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
# CONFIG_SCSI_MULTI_LUN is not set
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set

#
# SCSI low-level drivers
#
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set

#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_SATA_AHCI is not set
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
CONFIG_SATA_PROMISE=y
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INTEL_COMBINED=y
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# Multi-device support (RAID and LVM)
#
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
# CONFIG_MD_LINEAR is not set
# CONFIG_MD_RAID0 is not set
CONFIG_MD_RAID1=y
# CONFIG_MD_RAID10 is not set
# CONFIG_MD_RAID456 is not set
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
# CONFIG_DM_CRYPT is not set
# CONFIG_DM_SNAPSHOT is not set
# CONFIG_DM_MIRROR is not set
# CONFIG_DM_ZERO is not set
# CONFIG_DM_MULTIPATH is not set

#
# Fusion MPT device support
#
# CONFIG_FUSION is not set
# CONFIG_FUSION_SPI is not set
# CONFIG_FUSION_FC is not set
# CONFIG_FUSION_SAS is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_IEEE1394 is not set

#
# I2O device support
#
# CONFIG_I2O is not set

#
# Network device support
#
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_EQUALIZER is not set
# CONFIG_TUN is not set

#
# ARCnet devices
#
# CONFIG_ARCNET is not set

#
# PHY device support
#

#
# Ethernet (10 or 100Mbit)
#
# CONFIG_NET_ETHERNET is not set

#
# Ethernet (1000 Mbit)
#
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
# CONFIG_R8169_NAPI is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_SK98LIN is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set

#
# Ethernet (10000 Mbit)
#
# CONFIG_CHELSIO_T1 is not set
# CONFIG_IXGB is not set
# CONFIG_S2IO is not set
# CONFIG_MYRI10GE is not set

#
# Token Ring devices
#
# CONFIG_TR is not set

#
# Wireless LAN (non-hamradio)
#
# CONFIG_NET_RADIO is not set

#
# Wan interfaces
#
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set

#
# ISDN subsystem
#
# CONFIG_ISDN is not set

#
# Telephony Support
#
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
# CONFIG_INPUT_TSDEV is not set
# CONFIG_INPUT_EVDEV is not set
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=y
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_SERIAL_NONSTANDARD is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256

#
# IPMI
#
# CONFIG_IPMI_HANDLER is not set

#
# Watchdog Cards
#
# CONFIG_WATCHDOG is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
# CONFIG_DTLK is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set

#
# Ftape, the floppy tape device driver
#
# CONFIG_AGP is not set
# CONFIG_DRM is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
# CONFIG_HANGCHECK_TIMER is not set

#
# TPM devices
#
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
# CONFIG_I2C_ALGOBIT is not set
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=y
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_ISA=y
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set
# CONFIG_I2C_PCA_ISA is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
CONFIG_SENSORS_EEPROM=y
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set

#
# Dallas's 1-wire bus
#
# CONFIG_W1 is not set

#
# Hardware Monitoring support
#
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
CONFIG_SENSORS_W83627EHF=y
# CONFIG_SENSORS_HDAPS is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set

#
# Digital Video Broadcasting Devices
#
# CONFIG_DVB is not set
# CONFIG_USB_DABUSB is not set

#
# Graphics support
#
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
# CONFIG_VIDEO_SELECT is not set
CONFIG_DUMMY_CONSOLE=y
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Sound
#
# CONFIG_SOUND is not set

#
# USB support
#
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_BANDWIDTH is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_SPLIT_ISO is not set
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_SL811_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_DPCM is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT is not set
CONFIG_USB_HIDDEV=y
# CONFIG_USB_AIPTEK is not set
# CONFIG_USB_WACOM is not set
# CONFIG_USB_ACECAD is not set
# CONFIG_USB_KBTAB is not set
# CONFIG_USB_POWERMATE is not set
# CONFIG_USB_TOUCHSCREEN is not set
# CONFIG_USB_YEALINK is not set
# CONFIG_USB_XPAD is not set
# CONFIG_USB_ATI_REMOTE is not set
# CONFIG_USB_ATI_REMOTE2 is not set
# CONFIG_USB_KEYSPAN_REMOTE is not set
# CONFIG_USB_APPLETOUCH is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET_MII is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#

#
# USB Serial Converter support
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_TEST is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set

#
# MMC/SD Card support
#
# CONFIG_MMC is not set

#
# LED devices
#
# CONFIG_NEW_LEDS is not set

#
# LED drivers
#

#
# LED Triggers
#

#
# InfiniBand support
#
# CONFIG_INFINIBAND is not set

#
# EDAC - error detection and reporting (RAS) (EXPERIMENTAL)
#
# CONFIG_EDAC is not set

#
# Real Time Clock
#
# CONFIG_RTC_CLASS is not set

#
# DMA Engine support
#
# CONFIG_DMA_ENGINE is not set

#
# DMA Clients
#

#
# DMA Devices
#

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
# CONFIG_EXT2_FS_XIP is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
# CONFIG_REISERFS_FS_SECURITY is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
# CONFIG_XFS_SECURITY is not set
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_DNOTIFY=y
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_RAMFS=y
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set

#
# Network File Systems
#
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
CONFIG_SMB_FS=y
CONFIG_SMB_NLS_DEFAULT=y
CONFIG_SMB_NLS_REMOTE="cp850"
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
# CONFIG_CIFS_WEAK_PW_HASH is not set
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
# CONFIG_9P_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y

#
# Native Language Support
#
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="UTF8"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Instrumentation Support
#
# CONFIG_PROFILING is not set
# CONFIG_KPROBES is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_MUST_CHECK is not set
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_KERNEL is not set
CONFIG_LOG_BUF_SHIFT=15
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_FS is not set
# CONFIG_UNWIND_INFO is not set
# CONFIG_HEADERS_CHECK is not set
CONFIG_EARLY_PRINTK=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set

#
# Cryptographic options
#
# CONFIG_CRYPTO is not set

#
# Library routines
#
# CONFIG_CRC_CCITT is not set
# CONFIG_CRC16 is not set
CONFIG_CRC32=y
# CONFIG_LIBCRC32C is not set
CONFIG_PLIST=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y

-------------- CUT




and the following are the kernel log before the crash:


------------- CUT

Nov 19 11:43:15  kernel: Bad page state in process 'smbd'
Nov 19 11:43:15  kernel: page:c10d4880 flags:0x4000000c
mapping:f55eef50 mapcount:0 count:0
Nov 19 11:43:15  kernel: Trying to fix it up, but a reboot is needed
Nov 19 11:43:15  kernel: Backtrace:
Nov 19 11:43:15  kernel: [<c0141183>] bad_page+0x5e/0x91
Nov 19 11:43:15  kernel: [<c014185c>] free_hot_cold_page+0x123/0x134
Nov 19 11:43:15  kernel: [<c027a8d4>] xfs_buf_free+0x38/0xfc
Nov 19 11:43:15  kernel: [<c023b401>] xfs_da_brelse+0x7f/0xc3
Nov 19 11:43:15  kernel: [<c0224aeb>] xfs_attr_fetch+0x28e/0x2bc
Nov 19 11:43:15  kernel: [<c0224c58>] xfs_attr_get+0xb2/0xce
Nov 19 11:43:15  kernel: [<c0224ba6>] xfs_attr_get+0x0/0xce
Nov 19 11:43:15  kernel: [<c021a2fc>] xfs_acl_get_attr+0x53/0x7c
Nov 19 11:43:15  kernel: [<c021a8c7>] xfs_acl_vget+0x43/0x228
Nov 19 11:43:15  kernel: [<c021adf5>] xfs_acl_iaccess+0x188/0x323
Nov 19 11:43:15  kernel: [<c0221a3c>] attr_system_get+0x37/0x6c
Nov 19 11:43:15  kernel: [<c027f63a>] xfs_vn_getxattr+0x7c/0x8c
Nov 19 11:43:15  kernel: [<c0174dd2>] vfs_getxattr+0x50/0x78
Nov 19 11:43:15  kernel: [<c0174e62>] getxattr+0x68/0x109
Nov 19 11:43:15  kernel: [<c0170231>] mntput_no_expire+0x1c/0x77
Nov 19 11:43:15  kernel: [<c0164540>] link_path_walk+0x73/0xe2
Nov 19 11:43:15  kernel: [<c016478d>] do_path_lookup+0x89/0x1d1
Nov 19 11:43:15  kernel: [<c0163530>] getname+0x80/0xb9
Nov 19 11:43:15  kernel: [<c016515e>] __user_walk_fd+0x43/0x4d
Nov 19 11:43:15  kernel: [<c0174fcd>] sys_getxattr+0x3d/0x4f
Nov 19 11:43:15  kernel: [<c0102e9b>] syscall_call+0x7/0xb
Nov 19 11:43:15  kernel: [<c01559fc>] shmem_file_setup+0x1a/0x1ad
Nov 19 11:43:15  kernel: =======================
Nov 19 11:48:55  kernel: Bad page state in process 'smbd'
Nov 19 11:48:55  kernel: page:c10c0e00 flags:0x4000000c
mapping:f746e4d0 mapcount:0 count:0
Nov 19 11:48:55  kernel: Trying to fix it up, but a reboot is needed
Nov 19 11:48:55  kernel: Backtrace:
Nov 19 11:48:55  kernel: [<c0141183>] bad_page+0x5e/0x91
Nov 19 11:48:55  kernel: [<c014185c>] free_hot_cold_page+0x123/0x134
Nov 19 11:48:55  kernel: [<c027a8d4>] xfs_buf_free+0x38/0xfc
Nov 19 11:48:55  kernel: [<c023b401>] xfs_da_brelse+0x7f/0xc3
Nov 19 11:48:55  kernel: [<c0224aeb>] xfs_attr_fetch+0x28e/0x2bc
Nov 19 11:48:55  kernel: [<c0224c58>] xfs_attr_get+0xb2/0xce
Nov 19 11:48:55  kernel: [<c0224ba6>] xfs_attr_get+0x0/0xce
Nov 19 11:48:55  kernel: [<c021a2fc>] xfs_acl_get_attr+0x53/0x7c
Nov 19 11:48:55  kernel: [<c021a8c7>] xfs_acl_vget+0x43/0x228
Nov 19 11:48:55  kernel: [<c021adf5>] xfs_acl_iaccess+0x188/0x323
Nov 19 11:48:55  kernel: [<c0221a3c>] attr_system_get+0x37/0x6c
Nov 19 11:48:55  kernel: [<c027f63a>] xfs_vn_getxattr+0x7c/0x8c
Nov 19 11:48:55  kernel: [<c0174dd2>] vfs_getxattr+0x50/0x78
Nov 19 11:48:55  kernel: [<c0174e62>] getxattr+0x68/0x109
Nov 19 11:48:55  kernel: [<c0170231>] mntput_no_expire+0x1c/0x77
Nov 19 11:48:55  kernel: [<c0164540>] link_path_walk+0x73/0xe2
Nov 19 11:48:55  kernel: [<c016478d>] do_path_lookup+0x89/0x1d1
Nov 19 11:48:55  kernel: [<c0163530>] getname+0x80/0xb9
Nov 19 11:48:55  kernel: [<c016515e>] __user_walk_fd+0x43/0x4d
Nov 19 11:48:55  kernel: [<c0174fcd>] sys_getxattr+0x3d/0x4f
Nov 19 11:48:55  kernel: [<c0102e9b>] syscall_call+0x7/0xb
Nov 19 11:48:55  kernel: =======================
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-13050:
reiserfs_update_sd: i/o failure occurred trying to update [140 8161
0x0 SD] stat data
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-13050:
reiserfs_update_sd: i/o failure occurred trying to update [140 8161
0x0 SD] stat data
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-13050:
reiserfs_update_sd: i/o failure occurred trying to update [140 8161
0x0 SD] stat data
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?

............ A LOT OF THESE

Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-13050:
reiserfs_update_sd: i/o failure occurred trying to update [140 8161
0x0 SD] stat data
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: warning: is_tree_node: node level 0
does not match to the expected one 1
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-5150:
search_by_key: invalid format found in block 1245223. Fsck?
Nov 19 11:48:55  kernel: ReiserFS: md4: warning: vs-13050:
reiserfs_update_sd: i/o failure occurred trying to update [140 8161
0x0 SD] stat data
Nov 19 11:48:57  kernel: Bad page state in process 'smbd'
Nov 19 11:48:57  kernel: page:c10c0e00 flags:0x40000060
mapping:f7411d51 mapcount:1 count:1
Nov 19 11:48:57  kernel: Trying to fix it up, but a reboot is needed
Nov 19 11:48:57  kernel: Backtrace:
Nov 19 11:48:57  kernel: [<c0141183>] bad_page+0x5e/0x91
Nov 19 11:48:57  kernel: [<c0141bcb>] get_page_from_freelist+0x2ee/0x333
Nov 19 11:48:57  kernel: [<c0141c5f>] __alloc_pages+0x4f/0x2df
Nov 19 11:48:57  kernel: [<c022f617>] xfs_bmap_search_multi_extents+0xa8/0xf2
Nov 19 11:48:57  kernel: [<c013cef1>] find_lock_page+0x28/0x8c
Nov 19 11:48:57  kernel: [<c013db69>] find_or_create_page+0xa0/0xb4
Nov 19 11:48:57  kernel: [<c027b5ce>] xfs_buf_get_flags+0x191/0x4d5
Nov 19 11:48:57  kernel: [<c026b48b>] xfs_trans_get_buf+0x122/0x163
Nov 19 11:48:57  kernel: [<c023bd7c>] xfs_da_do_buf+0x710/0x980
Nov 19 11:48:57  kernel: [<c023c0cf>] xfs_da_get_buf+0x3b/0x3f
Nov 19 11:48:57  kernel: [<c02257e8>] xfs_attr_leaf_create+0x49/0x127
Nov 19 11:48:57  kernel: [<c02257e8>] xfs_attr_leaf_create+0x49/0x127
Nov 19 11:48:57  kernel: [<c02276fa>] xfs_attr_shortform_to_leaf+0x132/0x2b3
Nov 19 11:48:57  kernel: [<c025dd1e>] xfs_log_reserve+0x538/0x670
Nov 19 11:48:57  kernel: [<c026bb54>] xfs_trans_log_inode+0x24/0x44
Nov 19 11:48:57  kernel: [<c0226c83>] xfs_attr_shortform_create+0x63/0x6a
Nov 19 11:48:57  kernel: [<c0224354>] xfs_attr_set_int+0x633/0xb3c
Nov 19 11:48:57  kernel: [<c0277bf0>] kmem_zone_alloc+0x60/0xdd
Nov 19 11:48:57  kernel: [<c0224c74>] xfs_attr_set+0x0/0xb6
Nov 19 11:48:57  kernel: [<c021a555>] xfs_acl_set_attr+0xe4/0x119
Nov 19 11:48:57  kernel: [<c021ac32>] xfs_acl_vset+0x186/0x1c1
Nov 19 11:48:57  kernel: [<c0221bfb>] attr_system_set+0x6e/0x86
Nov 19 11:48:57  kernel: [<c017526a>] vfs_setxattr+0x9c/0x136
Nov 19 11:48:57  kernel: [<c017538e>] setxattr+0x8a/0x11d
Nov 19 11:48:57  kernel: [<c0170231>] mntput_no_expire+0x1c/0x77
Nov 19 11:48:57  kernel: [<c0164540>] link_path_walk+0x73/0xe2
Nov 19 11:48:57  kernel: [<c016478d>] do_path_lookup+0x89/0x1d1
Nov 19 11:48:57  kernel: [<c0163530>] getname+0x80/0xb9
Nov 19 11:48:57  kernel: [<c016515e>] __user_walk_fd+0x43/0x4d
Nov 19 11:48:57  kernel: [<c0175503>] sys_setxattr+0x45/0x62
Nov 19 11:48:57  kernel: [<c0102e9b>] syscall_call+0x7/0xb
Nov 19 11:48:57  kernel: [<c01559fc>] shmem_file_setup+0x1a/0x1ad
Nov 19 11:48:57  kernel: =======================
Nov 19 11:48:57  kernel: BUG: unable to handle kernel paging request
at virtual address 00100104
Nov 19 11:48:57  kernel: printing eip:
Nov 19 11:48:57  kernel: c01419c6
Nov 19 11:48:57  kernel: *pde = 00000000
Nov 19 11:48:57  kernel: Oops: 0002 [#1]
Nov 19 11:48:57  kernel: SMP
Nov 19 11:48:57  kernel: Modules linked in: sym53c8xx scsi_transport_spi
Nov 19 11:48:57  kernel: CPU:    0
Nov 19 11:48:57  kernel: EIP:    0060:[<c01419c6>]    Tainted: G    B VLI
Nov 19 11:48:57  kernel: EFLAGS: 00210002   (2.6.19.2mykernelname #1)
Nov 19 11:48:57  kernel: EIP is at get_page_from_freelist+0xe9/0x333
Nov 19 11:48:57  kernel: eax: c10c0e18   ebx: c0452a00   ecx: 00100100
  edx: 00200200
Nov 19 11:48:57  kernel: esi: c10c0e00   edi: 00000001   ebp: c0452980
  esp: d0931c94
Nov 19 11:48:57  kernel: ds: 007b   es: 007b   ss: 0068
Nov 19 11:48:57  kernel: Process smbd (pid: 17420, ti=d0930000
task=c1ab8550 task.ti=d0930000)
Nov 19 11:48:57  kernel: Stack: c0452980 00000000 00000492 00000002
00000044 00000001 00000001 00000000
Nov 19 11:48:57  kernel: 00000000 00000002 00000000 000200d2 c04530a4
00200203 00000000 ffffa5a5
Nov 19 11:48:57  kernel: 5a5a5a5a 00000000 00000001 c04530a0 c1ab8550
000200d2 00000000 c0141c5f
Nov 19 11:48:57  kernel: Call Trace:
Nov 19 11:48:57  kernel: [<c0141c5f>] __alloc_pages+0x4f/0x2df
Nov 19 11:48:57  kernel: [<c013cef1>] find_lock_page+0x28/0x8c
Nov 19 11:48:57  kernel: [<c013db69>] find_or_create_page+0xa0/0xb4
Nov 19 11:48:57  kernel: [<c017cafa>] block_truncate_page+0x6b/0x258
Nov 19 11:48:57  kernel: [<c027eed9>] xfs_vn_truncate+0x2b/0x2f
Nov 19 11:48:57  kernel: [<c0278253>] xfs_get_blocks+0x0/0x2b
Nov 19 11:48:57  kernel: [<c014afbb>] vmtruncate+0xae/0x13b
Nov 19 11:48:57  kernel: [<c0271fc5>] xfs_setattr+0x7e2/0x1247
Nov 19 11:48:57  kernel: [<c027f4b0>] xfs_vn_setattr+0x101/0x15a
Nov 19 11:48:57  kernel: [<c016ec0c>] notify_change+0xc9/0x315
Nov 19 11:48:57  kernel: [<c0159b29>] do_truncate+0x62/0x79
Nov 19 11:48:57  kernel: [<c0159f50>] do_sys_ftruncate+0xe6/0x14c
Nov 19 11:48:57  kernel: [<c0159fd1>] sys_ftruncate64+0x1b/0x1f
Nov 19 11:48:57  kernel: [<c0102e9b>] syscall_call+0x7/0xb
Nov 19 11:48:57  kernel: [<c01559fc>] shmem_file_setup+0x1a/0x1ad
Nov 19 11:48:57  kernel: =======================
Nov 19 11:48:57  kernel: Code: 0f 94 c0 89 44 24 48 8b 44 24 1c 01 c0
01 c0 03 44 24 1c 01 c0 01 c0 89 44 24 20 e9 9a 00 00 00 8b 43 0c 8d
70 e8 8b 08 8b 50 04 <89> 51 04 89 0a c7 00 00 01 10 00 c7 40 04 00 02
20 00 83 2b 01
Nov 19 11:48:57  kernel: EIP: [<c01419c6>]
get_page_from_freelist+0xe9/0x333 SS:ESP 0068:d0931c94
Nov 19 11:49:02  kernel: <0>Eeek! page_mapcount(page) went negative! (-1)
Nov 19 11:49:02  kernel: page->flags = 40000070
Nov 19 11:49:02  kernel: page->count = 2
Nov 19 11:49:02  kernel: page->mapping = f55eef50
Nov 19 11:49:02  kernel: ------------[ cut here ]------------
Nov 19 11:49:02  kernel: kernel BUG at mm/rmap.c:581!
Nov 19 11:49:02  kernel: invalid opcode: 0000 [#2]
Nov 19 11:49:02  kernel: SMP
Nov 19 11:49:02  kernel: Modules linked in: sym53c8xx scsi_transport_spi
Nov 19 11:49:02  kernel: CPU:    0
Nov 19 11:49:02  kernel: EIP:    0060:[<c014eff2>]    Tainted: G    B VLI
Nov 19 11:49:02  kernel: EFLAGS: 00210286   (2.6.19.2mykernelname #1)
Nov 19 11:49:02  kernel: EIP is at page_remove_rmap+0x92/0xa1
Nov 19 11:49:02  kernel: eax: 0000001e   ebx: c10c0e00   ecx: ffffffff
  edx: 00200046
Nov 19 11:49:02  kernel: esi: c10c0e00   edi: 08416000   ebp: 00000020
  esp: e958dea0
Nov 19 11:49:02  kernel: ds: 007b   es: 007b   ss: 0068
Nov 19 11:49:02  kernel: Process smbd (pid: 20205, ti=e958c000
task=c5f36a70 task.ti=e958c000)
Nov 19 11:49:02  kernel: Stack: c03f3ca6 f55eef50 d957d058 c014904b
c10c0e00 08416000 06070067 00000000
Nov 19 11:49:02  kernel: 00000001 084ff000 f3615084 e8607e40 c1806940
ffffffed ffffffff e8607e84
Nov 19 11:49:02  kernel: f3615084 084fefff 0023edf2 084ff000 00000000
e958df24 d769bbfc e8607e40
Nov 19 11:49:02  kernel: Call Trace:
Nov 19 11:49:02  kernel: [<c014904b>] unmap_vmas+0x295/0x566
Nov 19 11:49:02  kernel: [<c014c0a3>] exit_mmap+0x8b/0x118
Nov 19 11:49:02  kernel: [<c0119166>] mmput+0x29/0x8c
Nov 19 11:49:02  kernel: [<c011cb59>] exit_mm+0x8b/0xf8
Nov 19 11:49:02  kernel: [<c011e12d>] do_exit+0xf4/0x8c6
Nov 19 11:49:02  kernel: [<c0113613>] do_page_fault+0x501/0x64e
Nov 19 11:49:02  kernel: [<c011e92e>] do_group_exit+0x2f/0x81
Nov 19 11:49:02  kernel: [<c0102e9b>] syscall_call+0x7/0xb
Nov 19 11:49:02  kernel: [<c03d007b>] wait_for_completion_timeout+0x81/0xc3
Nov 19 11:49:02  kernel: =======================
Nov 19 11:49:02  kernel: Code: f6 c4 40 75 30 8b 42 04 89 44 24 04 c7
04 24 8f 3c 3f c0 e8 0a cf fc ff 8b 43 10 89 44 24 04 c7 04 24 a6 3c
3f c0 e8 f7 ce fc ff <0f> 0b 45 02 6d 3c 3f c0 eb 85 8b 53 0c eb cb 55
57 56 53 83 ec
Nov 19 11:49:02  kernel: EIP: [<c014eff2>] page_remove_rmap+0x92/0xa1
SS:ESP 0068:e958dea0
Nov 19 11:49:02  kernel: <1>Fixing recursive fault but reboot is needed!

------------- CUT

The server is a fileserver with 6 raid 1 disks
the filesystems are ext2 (/boot), reiserfs (/usr, /var, /tmp, /home,
/) and xfs (/srv, /srv2, /srv3)

The server has also a *unused* scsi card for dat with the following lkm:
Module                  Size  Used by
sym53c8xx              74260  0
scsi_transport_spi     25088  1 sym53c8xx

I have 2 or 3 crash per day in the last 4 - 5 days.
Before those it was a uptime of 200 days.

Anyone could help me ?

bye
lewis
