Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbYKFUo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbYKFUo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 15:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYKFUor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 15:44:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:53117 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYKFUoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 15:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:references;
        b=VYELmD/IjkhiN1qvIssQRV9EDwB0sEkXIvRW7NfT28wmgVRf7pnf6dMkbVUMtB6s9f
         1g6helOjzM5cjoavLE8gB/oWcJ8Odd6QTw3QIP+0nd8TjJ7kjtvSluTNOrqILxQh1s3/
         7RdrZv+Xt/fJACdTsbK+LyNYpTMfmQHoRczig=
Message-ID: <7c86c4470811061244n36092f19i5710cdfb45774636@mail.gmail.com>
Date: Thu, 6 Nov 2008 21:44:40 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: next-20081106: perfmon on ia64
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081106185458.GA506@x200.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_10740_3611406.1226004280962"
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
	 <20081106185458.GA506@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_10740_3611406.1226004280962
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Alexey, Stephen,

This is coming from a name collision between the legacy perfmon (v2.0)
of IA-64 and the new generation (v3.0) which is being introduced.

I have now fixed that in my linux-next GIT tree.

Stephen, please pull from my tree again.

Patch is attached.

Sorry about that.


On Thu, Nov 6, 2008 at 7:54 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> perfmon busts ia64:
>
>  CC      perfmon/perfmon_ctx.o
> In file included from include/linux/perfmon_kern.h:30,
>                 from perfmon/perfmon_ctx.c:42:
> include/linux/perfmon.h:53: error: 'PFM_ARCH_MAX_PMCS' undeclared here (not in a function)
> include/linux/perfmon.h:54: error: 'PFM_ARCH_MAX_PMDS' undeclared here (not in a function)
> In file included from include/linux/perfmon_kern.h:30,
>                 from perfmon/perfmon_ctx.c:42:
> include/linux/perfmon.h:95:1: warning: "PFM_VERSION_MAJ" redefined
> In file included from include/linux/perfmon.h:32,
>                 from include/linux/perfmon_kern.h:30,
>                 from perfmon/perfmon_ctx.c:42:
> arch/ia64/include/asm/perfmon.h:162:1: warning: this is the location of the previous definition
> In file included from include/linux/perfmon_kern.h:30,
>                 from perfmon/perfmon_ctx.c:42:
> include/linux/perfmon.h:97:1: warning: "PFM_VERSION" redefined
> In file included from include/linux/perfmon.h:32,
>                 from include/linux/perfmon_kern.h:30,
>                 from perfmon/perfmon_ctx.c:42:
> arch/ia64/include/asm/perfmon.h:164:1: warning: this is the location of the previous definition
> In file included from perfmon/perfmon_ctx.c:42:
> include/linux/perfmon_kern.h:187: error: conflicting types for 'pfm_handle_work'
>        ...
>
>
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.28-rc3
> # Thu Nov  6 18:45:12 2008
> #
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
>
> #
> # General setup
> #
> CONFIG_EXPERIMENTAL=y
> CONFIG_LOCK_KERNEL=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_LOCALVERSION=""
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_POSIX_MQUEUE=y
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> # CONFIG_AUDIT is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=16
> # CONFIG_CGROUPS is not set
> # CONFIG_GROUP_SCHED is not set
> CONFIG_SYSFS_DEPRECATED=y
> CONFIG_SYSFS_DEPRECATED_V2=y
> # CONFIG_RELAY is not set
> CONFIG_NAMESPACES=y
> # CONFIG_UTS_NS is not set
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_BLK_DEV_INITRD is not set
> CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> CONFIG_SYSCTL=y
> # CONFIG_EMBEDDED is not set
> CONFIG_SYSCTL_SYSCALL=y
> CONFIG_KALLSYMS=y
> # CONFIG_KALLSYMS_ALL is not set
> CONFIG_HOTPLUG=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_COMPAT_BRK=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_ANON_INODES=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_PCI_QUIRKS=y
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_PROFILING=y
> # CONFIG_MARKERS is not set
> CONFIG_OPROFILE=y
> CONFIG_HAVE_OPROFILE=y
> # CONFIG_KPROBES is not set
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_USE_GENERIC_SMP_HELPERS=y
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> # CONFIG_TINY_SHMEM is not set
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> CONFIG_STOP_MACHINE=y
> CONFIG_BLOCK=y
> # CONFIG_BLK_DEV_IO_TRACE is not set
> # CONFIG_BLK_DEV_BSG is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> CONFIG_BLOCK_COMPAT=y
>
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_AS=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_DEFAULT_AS=y
> # CONFIG_DEFAULT_DEADLINE is not set
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="anticipatory"
> CONFIG_CLASSIC_RCU=y
> # CONFIG_FREEZER is not set
>
> #
> # Processor type and features
> #
> CONFIG_IA64=y
> CONFIG_64BIT=y
> CONFIG_ZONE_DMA=y
> CONFIG_QUICKLIST=y
> CONFIG_MMU=y
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_GENERIC_LOCKBREAK=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_HUGETLB_PAGE_SIZE_VARIABLE=y
> CONFIG_GENERIC_FIND_NEXT_BIT=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_GENERIC_TIME=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_DMI=y
> CONFIG_EFI=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> CONFIG_AUDIT_ARCH=y
> # CONFIG_PARAVIRT_GUEST is not set
> # CONFIG_IA64_GENERIC is not set
> CONFIG_IA64_DIG=y
> # CONFIG_IA64_DIG_VTD is not set
> # CONFIG_IA64_HP_ZX1 is not set
> # CONFIG_IA64_HP_ZX1_SWIOTLB is not set
> # CONFIG_IA64_SGI_SN2 is not set
> # CONFIG_IA64_SGI_UV is not set
> # CONFIG_IA64_HP_SIM is not set
> # CONFIG_IA64_XEN_GUEST is not set
> CONFIG_ITANIUM=y
> # CONFIG_MCKINLEY is not set
> # CONFIG_IA64_PAGE_SIZE_4KB is not set
> # CONFIG_IA64_PAGE_SIZE_8KB is not set
> CONFIG_IA64_PAGE_SIZE_16KB=y
> # CONFIG_IA64_PAGE_SIZE_64KB is not set
> CONFIG_PGTABLE_3=y
> # CONFIG_PGTABLE_4 is not set
> CONFIG_HZ=250
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> # CONFIG_SCHED_HRTICK is not set
> CONFIG_IA64_BRL_EMU=y
> CONFIG_IA64_L1_CACHE_SHIFT=6
> # CONFIG_IA64_CYCLONE is not set
> CONFIG_IOSAPIC=y
> CONFIG_FORCE_MAX_ZONEORDER=17
> # CONFIG_VIRT_CPU_ACCOUNTING is not set
> CONFIG_SMP=y
> CONFIG_NR_CPUS=2
> # CONFIG_HOTPLUG_CPU is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> # CONFIG_SCHED_SMT is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_DISCONTIGMEM_MANUAL is not set
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_MIGRATION=y
> CONFIG_RESOURCES_64BIT=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=1
> CONFIG_BOUNCE=y
> CONFIG_NR_QUICK=1
> CONFIG_VIRT_TO_BUS=y
> CONFIG_UNEVICTABLE_LRU=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_POPULATES_NODE_MAP=y
> # CONFIG_VIRTUAL_MEM_MAP is not set
> CONFIG_IA32_SUPPORT=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> # CONFIG_IA64_MCA_RECOVERY is not set
> CONFIG_PERFMON=y
> CONFIG_IA64_PALINFO=y
> # CONFIG_IA64_MC_ERR_INJECT is not set
> # CONFIG_IA64_ESI is not set
> # CONFIG_IA64_HP_AML_NFW is not set
>
> #
> # Firmware Drivers
> #
> # CONFIG_FIRMWARE_MEMMAP is not set
> CONFIG_EFI_VARS=y
> CONFIG_EFI_PCDP=y
> CONFIG_DMIID=y
> CONFIG_BINFMT_ELF=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> # CONFIG_HAVE_AOUT is not set
> CONFIG_BINFMT_MISC=m
>
> #
> # Power management and ACPI
> #
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_ACPI=y
> # CONFIG_ACPI_PROCFS is not set
> CONFIG_ACPI_PROCFS_POWER=y
> CONFIG_ACPI_SYSFS_POWER=y
> CONFIG_ACPI_PROC_EVENT=y
> CONFIG_ACPI_BUTTON=m
> CONFIG_ACPI_FAN=m
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=m
> CONFIG_ACPI_THERMAL=m
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> CONFIG_ACPI_BLACKLIST_YEAR=0
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_EC=y
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_ACPI_POWER=y
> CONFIG_ACPI_SYSTEM=y
> # CONFIG_ACPI_CONTAINER is not set
>
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
>
> #
> # Bus options (PCI, PCMCIA)
> #
> CONFIG_PCI=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCI_SYSCALL=y
> # CONFIG_PCIEPORTBUS is not set
> CONFIG_ARCH_SUPPORTS_MSI=y
> # CONFIG_PCI_MSI is not set
> CONFIG_PCI_LEGACY=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_PCCARD is not set
> CONFIG_NET=y
>
> #
> # Networking options
> #
> # CONFIG_NET_NS is not set
> CONFIG_PACKET=y
> CONFIG_PACKET_MMAP=y
> CONFIG_UNIX=y
> CONFIG_XFRM=y
> # CONFIG_XFRM_USER is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> # CONFIG_NET_KEY is not set
> CONFIG_INET=y
> # CONFIG_IP_MULTICAST is not set
> # CONFIG_IP_ADVANCED_ROUTER is not set
> CONFIG_IP_FIB_HASH=y
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE is not set
> # CONFIG_ARPD is not set
> # CONFIG_SYN_COOKIES is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_XFRM_TUNNEL is not set
> # CONFIG_INET_TUNNEL is not set
> CONFIG_INET_XFRM_MODE_TRANSPORT=y
> CONFIG_INET_XFRM_MODE_TUNNEL=y
> CONFIG_INET_XFRM_MODE_BEET=y
> # CONFIG_INET_LRO is not set
> CONFIG_INET_DIAG=y
> CONFIG_INET_TCP_DIAG=y
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> # CONFIG_TCP_MD5SIG is not set
> # CONFIG_IPV6 is not set
> # CONFIG_NETWORK_SECMARK is not set
> # CONFIG_NETFILTER is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> # CONFIG_LLC2 is not set
> # CONFIG_IPX is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_ECONET is not set
> # CONFIG_WAN_ROUTER is not set
> # CONFIG_NET_SCHED is not set
>
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> # CONFIG_PHONET is not set
> CONFIG_WIRELESS=y
> # CONFIG_CFG80211 is not set
> CONFIG_WIRELESS_OLD_REGULATORY=y
> # CONFIG_WIRELESS_EXT is not set
> # CONFIG_LIB80211 is not set
> # CONFIG_MAC80211 is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
>
> #
> # Device Drivers
> #
>
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> CONFIG_STANDALONE=y
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> CONFIG_FW_LOADER=y
> CONFIG_FIRMWARE_IN_KERNEL=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_CONNECTOR is not set
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> CONFIG_PNP_DEBUG_MESSAGES=y
>
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_CPQ_DA is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_CRYPTOLOOP=m
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_UB is not set
> CONFIG_BLK_DEV_RAM=m
> CONFIG_BLK_DEV_RAM_COUNT=16
> CONFIG_BLK_DEV_RAM_SIZE=4096
> # CONFIG_BLK_DEV_XIP is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> # CONFIG_BLK_DEV_HD is not set
> CONFIG_MISC_DEVICES=y
> # CONFIG_PHANTOM is not set
> # CONFIG_EEPROM_93CX6 is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> CONFIG_HAVE_IDE=y
> CONFIG_IDE=m
>
> #
> # Please see Documentation/ide/ide.txt for help/info on IDE drives
> #
> # CONFIG_BLK_DEV_IDE_SATA is not set
> CONFIG_IDE_GD=m
> CONFIG_IDE_GD_ATA=y
> # CONFIG_IDE_GD_ATAPI is not set
> CONFIG_BLK_DEV_IDECD=m
> CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
> # CONFIG_BLK_DEV_IDETAPE is not set
> # CONFIG_BLK_DEV_IDESCSI is not set
> # CONFIG_BLK_DEV_IDEACPI is not set
> # CONFIG_IDE_TASK_IOCTL is not set
> CONFIG_IDE_PROC_FS=y
>
> #
> # IDE chipset support/bugfixes
> #
> # CONFIG_IDE_GENERIC is not set
> # CONFIG_BLK_DEV_PLATFORM is not set
> # CONFIG_BLK_DEV_IDEPNP is not set
> CONFIG_BLK_DEV_IDEDMA_SFF=y
>
> #
> # PCI IDE chipsets support
> #
> CONFIG_BLK_DEV_IDEPCI=y
> # CONFIG_BLK_DEV_OFFBOARD is not set
> CONFIG_BLK_DEV_GENERIC=m
> # CONFIG_BLK_DEV_OPTI621 is not set
> CONFIG_BLK_DEV_IDEDMA_PCI=y
> # CONFIG_BLK_DEV_AEC62XX is not set
> # CONFIG_BLK_DEV_ALI15X3 is not set
> # CONFIG_BLK_DEV_AMD74XX is not set
> # CONFIG_BLK_DEV_CMD64X is not set
> # CONFIG_BLK_DEV_TRIFLEX is not set
> # CONFIG_BLK_DEV_CS5520 is not set
> # CONFIG_BLK_DEV_CS5530 is not set
> # CONFIG_BLK_DEV_HPT366 is not set
> # CONFIG_BLK_DEV_JMICRON is not set
> # CONFIG_BLK_DEV_SC1200 is not set
> CONFIG_BLK_DEV_PIIX=m
> # CONFIG_BLK_DEV_IT8213 is not set
> # CONFIG_BLK_DEV_IT821X is not set
> # CONFIG_BLK_DEV_NS87415 is not set
> # CONFIG_BLK_DEV_PDC202XX_OLD is not set
> # CONFIG_BLK_DEV_PDC202XX_NEW is not set
> # CONFIG_BLK_DEV_SVWKS is not set
> # CONFIG_BLK_DEV_SIIMAGE is not set
> # CONFIG_BLK_DEV_SLC90E66 is not set
> # CONFIG_BLK_DEV_TRM290 is not set
> # CONFIG_BLK_DEV_VIA82CXXX is not set
> # CONFIG_BLK_DEV_TC86C001 is not set
> CONFIG_BLK_DEV_IDEDMA=y
>
> #
> # SCSI device support
> #
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> # CONFIG_SCSI_TGT is not set
> # CONFIG_SCSI_NETLINK is not set
> CONFIG_SCSI_PROC_FS=y
>
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> # CONFIG_CHR_DEV_OSST is not set
> # CONFIG_BLK_DEV_SR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
>
> #
> # Some SCSI devices (e.g. CD jukebox) support multiple LUNs
> #
> # CONFIG_SCSI_MULTI_LUN is not set
> CONFIG_SCSI_CONSTANTS=y
> CONFIG_SCSI_LOGGING=y
> # CONFIG_SCSI_SCAN_ASYNC is not set
> CONFIG_SCSI_WAIT_SCAN=m
>
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=m
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC7XXX_OLD is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_DPT_I2O is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_FUTURE_DOMAIN is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> CONFIG_SCSI_QLOGIC_1280=y
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_DH is not set
> # CONFIG_ATA is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> CONFIG_MD_LINEAR=m
> CONFIG_MD_RAID0=m
> CONFIG_MD_RAID1=m
> CONFIG_MD_RAID10=m
> # CONFIG_MD_RAID456 is not set
> CONFIG_MD_MULTIPATH=m
> # CONFIG_MD_FAULTY is not set
> CONFIG_BLK_DEV_DM=m
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_MIRROR=m
> CONFIG_DM_ZERO=m
> # CONFIG_DM_MULTIPATH is not set
> # CONFIG_DM_DELAY is not set
> # CONFIG_DM_UEVENT is not set
> # CONFIG_FUSION is not set
>
> #
> # IEEE 1394 (FireWire) support
> #
>
> #
> # Enable only one of the two stacks, unless you know what you are doing
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_IEEE1394 is not set
> # CONFIG_I2O is not set
> CONFIG_NETDEVICES=y
> CONFIG_DUMMY=y
> # CONFIG_BONDING is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_TUN is not set
> # CONFIG_VETH is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_ARCNET is not set
> # CONFIG_PHYLIB is not set
> CONFIG_NET_ETHERNET=y
> CONFIG_MII=y
> # CONFIG_HAPPYMEAL is not set
> # CONFIG_SUNGEM is not set
> # CONFIG_CASSINI is not set
> # CONFIG_NET_VENDOR_3COM is not set
> # CONFIG_NET_TULIP is not set
> # CONFIG_HP100 is not set
> # CONFIG_IBM_NEW_EMAC_ZMII is not set
> # CONFIG_IBM_NEW_EMAC_RGMII is not set
> # CONFIG_IBM_NEW_EMAC_TAH is not set
> # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> CONFIG_NET_PCI=y
> # CONFIG_PCNET32 is not set
> # CONFIG_AMD8111_ETH is not set
> # CONFIG_ADAPTEC_STARFIRE is not set
> # CONFIG_B44 is not set
> # CONFIG_FORCEDETH is not set
> # CONFIG_E100 is not set
> # CONFIG_FEALNX is not set
> # CONFIG_NATSEMI is not set
> # CONFIG_NE2K_PCI is not set
> # CONFIG_8139CP is not set
> # CONFIG_8139TOO is not set
> # CONFIG_R6040 is not set
> # CONFIG_SIS900 is not set
> # CONFIG_EPIC100 is not set
> # CONFIG_SUNDANCE is not set
> # CONFIG_TLAN is not set
> # CONFIG_VIA_RHINE is not set
> # CONFIG_SC92031 is not set
> # CONFIG_ATL2 is not set
> CONFIG_NETDEV_1000=y
> # CONFIG_ACENIC is not set
> # CONFIG_DL2K is not set
> # CONFIG_E1000 is not set
> # CONFIG_E1000E is not set
> # CONFIG_IP1000 is not set
> # CONFIG_IGB is not set
> # CONFIG_NS83820 is not set
> # CONFIG_HAMACHI is not set
> # CONFIG_YELLOWFIN is not set
> # CONFIG_R8169 is not set
> # CONFIG_SIS190 is not set
> # CONFIG_SKGE is not set
> # CONFIG_SKY2 is not set
> # CONFIG_VIA_VELOCITY is not set
> # CONFIG_TIGON3 is not set
> # CONFIG_BNX2 is not set
> # CONFIG_QLA3XXX is not set
> # CONFIG_ATL1 is not set
> # CONFIG_ATL1E is not set
> # CONFIG_JME is not set
> CONFIG_NETDEV_10000=y
> # CONFIG_CHELSIO_T1 is not set
> # CONFIG_CHELSIO_T3 is not set
> # CONFIG_ENIC is not set
> # CONFIG_IXGBE is not set
> # CONFIG_IXGB is not set
> # CONFIG_S2IO is not set
> # CONFIG_MYRI10GE is not set
> # CONFIG_NETXEN_NIC is not set
> # CONFIG_NIU is not set
> # CONFIG_MLX4_EN is not set
> # CONFIG_MLX4_CORE is not set
> # CONFIG_TEHUTI is not set
> # CONFIG_BNX2X is not set
> # CONFIG_QLGE is not set
> # CONFIG_SFC is not set
> # CONFIG_TR is not set
>
> #
> # Wireless LAN
> #
> # CONFIG_WLAN_PRE80211 is not set
> # CONFIG_WLAN_80211 is not set
> # CONFIG_IWLWIFI_LEDS is not set
>
> #
> # USB Network Adapters
> #
> # CONFIG_USB_CATC is not set
> # CONFIG_USB_KAWETH is not set
> # CONFIG_USB_PEGASUS is not set
> # CONFIG_USB_RTL8150 is not set
> # CONFIG_USB_USBNET is not set
> # CONFIG_WAN is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> # CONFIG_NET_FC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_NETPOLL is not set
> # CONFIG_NET_POLL_CONTROLLER is not set
> # CONFIG_ISDN is not set
> # CONFIG_PHONE is not set
>
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_POLLDEV is not set
>
> #
> # Userland interfaces
> #
> CONFIG_INPUT_MOUSEDEV=y
> CONFIG_INPUT_MOUSEDEV_PSAUX=y
> CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> # CONFIG_INPUT_JOYDEV is not set
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
>
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ATKBD=y
> # CONFIG_KEYBOARD_SUNKBD is not set
> # CONFIG_KEYBOARD_LKKBD is not set
> # CONFIG_KEYBOARD_XTKBD is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_INPUT_MOUSE=y
> CONFIG_MOUSE_PS2=y
> CONFIG_MOUSE_PS2_ALPS=y
> CONFIG_MOUSE_PS2_LOGIPS2PP=y
> CONFIG_MOUSE_PS2_SYNAPTICS=y
> CONFIG_MOUSE_PS2_LIFEBOOK=y
> CONFIG_MOUSE_PS2_TRACKPOINT=y
> # CONFIG_MOUSE_PS2_ELANTECH is not set
> # CONFIG_MOUSE_PS2_TOUCHKIT is not set
> # CONFIG_MOUSE_SERIAL is not set
> # CONFIG_MOUSE_APPLETOUCH is not set
> # CONFIG_MOUSE_BCM5974 is not set
> # CONFIG_MOUSE_VSXXXAA is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
>
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> # CONFIG_SERIO_RAW is not set
> # CONFIG_GAMEPORT is not set
>
> #
> # Character devices
> #
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_HW_CONSOLE=y
> # CONFIG_VT_HW_CONSOLE_BINDING is not set
> CONFIG_DEVKMEM=y
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
>
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_SERIAL_8250_PCI=y
> CONFIG_SERIAL_8250_PNP=y
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
>
> #
> # Non-8250 serial port support
> #
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_UNIX98_PTYS=y
> CONFIG_LEGACY_PTYS=y
> CONFIG_LEGACY_PTY_COUNT=256
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> CONFIG_EFI_RTC=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HPET is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_CHARDEV=y
> CONFIG_I2C_HELPER_AUTO=y
>
> #
> # I2C Hardware Bus support
> #
>
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
>
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> # CONFIG_I2C_OCORES is not set
> # CONFIG_I2C_SIMTEC is not set
>
> #
> # External I2C/SMBus adapter drivers
> #
> # CONFIG_I2C_PARPORT_LIGHT is not set
> # CONFIG_I2C_TAOS_EVM is not set
> # CONFIG_I2C_TINY_USB is not set
>
> #
> # Graphics adapter I2C/DDC channel drivers
> #
> # CONFIG_I2C_VOODOO3 is not set
>
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_STUB is not set
>
> #
> # Miscellaneous I2C Chip support
> #
> # CONFIG_DS1682 is not set
> # CONFIG_AT24 is not set
> # CONFIG_SENSORS_EEPROM is not set
> # CONFIG_SENSORS_PCF8574 is not set
> # CONFIG_PCF8575 is not set
> # CONFIG_SENSORS_PCA9539 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_SENSORS_MAX6875 is not set
> # CONFIG_SENSORS_TSL2550 is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_I2C_DEBUG_CHIP is not set
> # CONFIG_SPI is not set
> # CONFIG_W1 is not set
> CONFIG_POWER_SUPPLY=y
> # CONFIG_POWER_SUPPLY_DEBUG is not set
> # CONFIG_PDA_POWER is not set
> # CONFIG_BATTERY_DS2760 is not set
> # CONFIG_BATTERY_BQ27x00 is not set
> CONFIG_HWMON=y
> # CONFIG_HWMON_VID is not set
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> # CONFIG_SENSORS_ADM1021 is not set
> # CONFIG_SENSORS_ADM1025 is not set
> # CONFIG_SENSORS_ADM1026 is not set
> # CONFIG_SENSORS_ADM1029 is not set
> # CONFIG_SENSORS_ADM1031 is not set
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7473 is not set
> # CONFIG_SENSORS_ATXP1 is not set
> # CONFIG_SENSORS_DS1621 is not set
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> # CONFIG_SENSORS_F75375S is not set
> # CONFIG_SENSORS_GL518SM is not set
> # CONFIG_SENSORS_GL520SM is not set
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_LM63 is not set
> # CONFIG_SENSORS_LM75 is not set
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> # CONFIG_SENSORS_LM80 is not set
> # CONFIG_SENSORS_LM83 is not set
> # CONFIG_SENSORS_LM85 is not set
> # CONFIG_SENSORS_LM87 is not set
> # CONFIG_SENSORS_LM90 is not set
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> # CONFIG_SENSORS_MAX1619 is not set
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_PC87360 is not set
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_SIS5595 is not set
> # CONFIG_SENSORS_DME1737 is not set
> # CONFIG_SENSORS_SMSC47M1 is not set
> # CONFIG_SENSORS_SMSC47M192 is not set
> # CONFIG_SENSORS_SMSC47B397 is not set
> # CONFIG_SENSORS_ADS7828 is not set
> # CONFIG_SENSORS_THMC50 is not set
> # CONFIG_SENSORS_VIA686A is not set
> # CONFIG_SENSORS_VT1211 is not set
> # CONFIG_SENSORS_VT8231 is not set
> # CONFIG_SENSORS_W83781D is not set
> # CONFIG_SENSORS_W83791D is not set
> # CONFIG_SENSORS_W83792D is not set
> # CONFIG_SENSORS_W83793 is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> # CONFIG_HWMON_DEBUG_CHIP is not set
> CONFIG_THERMAL=m
> # CONFIG_THERMAL_HWMON is not set
> # CONFIG_WATCHDOG is not set
>
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB_POSSIBLE=y
> # CONFIG_SSB is not set
>
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_PMIC_DA903X is not set
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_REGULATOR is not set
>
> #
> # Multimedia devices
> #
>
> #
> # Multimedia core support
> #
> # CONFIG_VIDEO_DEV is not set
> # CONFIG_DVB_CORE is not set
> # CONFIG_VIDEO_MEDIA is not set
>
> #
> # Multimedia drivers
> #
> # CONFIG_DAB is not set
>
> #
> # Graphics support
> #
> CONFIG_AGP=m
> CONFIG_AGP_I460=m
> CONFIG_DRM=m
> # CONFIG_DRM_TDFX is not set
> CONFIG_DRM_R128=m
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_SIS is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_VIDEO_OUTPUT_CONTROL is not set
> # CONFIG_FB is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
>
> #
> # Display device support
> #
> # CONFIG_DISPLAY_SUPPORT is not set
>
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> # CONFIG_VGACON_SOFT_SCROLLBACK is not set
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_SOUND=m
> CONFIG_SOUND_OSS_CORE=y
> CONFIG_SND=m
> CONFIG_SND_TIMER=m
> CONFIG_SND_PCM=m
> CONFIG_SND_HWDEP=m
> CONFIG_SND_RAWMIDI=m
> CONFIG_SND_SEQUENCER=m
> # CONFIG_SND_SEQ_DUMMY is not set
> CONFIG_SND_OSSEMUL=y
> CONFIG_SND_MIXER_OSS=m
> CONFIG_SND_PCM_OSS=m
> CONFIG_SND_PCM_OSS_PLUGINS=y
> # CONFIG_SND_SEQUENCER_OSS is not set
> # CONFIG_SND_DYNAMIC_MINORS is not set
> CONFIG_SND_SUPPORT_OLD_API=y
> CONFIG_SND_VERBOSE_PROCFS=y
> # CONFIG_SND_VERBOSE_PRINTK is not set
> # CONFIG_SND_DEBUG is not set
> CONFIG_SND_VMASTER=y
> CONFIG_SND_OPL3_LIB=m
> CONFIG_SND_AC97_CODEC=m
> CONFIG_SND_DRIVERS=y
> # CONFIG_SND_DUMMY is not set
> # CONFIG_SND_VIRMIDI is not set
> # CONFIG_SND_MTPAV is not set
> # CONFIG_SND_SERIAL_U16550 is not set
> # CONFIG_SND_MPU401 is not set
> # CONFIG_SND_AC97_POWER_SAVE is not set
> CONFIG_SND_PCI=y
> # CONFIG_SND_AD1889 is not set
> # CONFIG_SND_ALS300 is not set
> # CONFIG_SND_ALI5451 is not set
> # CONFIG_SND_ATIIXP is not set
> # CONFIG_SND_ATIIXP_MODEM is not set
> # CONFIG_SND_AU8810 is not set
> # CONFIG_SND_AU8820 is not set
> # CONFIG_SND_AU8830 is not set
> # CONFIG_SND_AW2 is not set
> # CONFIG_SND_AZT3328 is not set
> # CONFIG_SND_BT87X is not set
> # CONFIG_SND_CA0106 is not set
> # CONFIG_SND_CMIPCI is not set
> # CONFIG_SND_OXYGEN is not set
> CONFIG_SND_CS4281=m
> # CONFIG_SND_CS46XX is not set
> # CONFIG_SND_DARLA20 is not set
> # CONFIG_SND_GINA20 is not set
> # CONFIG_SND_LAYLA20 is not set
> # CONFIG_SND_DARLA24 is not set
> # CONFIG_SND_GINA24 is not set
> # CONFIG_SND_LAYLA24 is not set
> # CONFIG_SND_MONA is not set
> # CONFIG_SND_MIA is not set
> # CONFIG_SND_ECHO3G is not set
> # CONFIG_SND_INDIGO is not set
> # CONFIG_SND_INDIGOIO is not set
> # CONFIG_SND_INDIGODJ is not set
> # CONFIG_SND_EMU10K1 is not set
> # CONFIG_SND_EMU10K1X is not set
> # CONFIG_SND_ENS1370 is not set
> # CONFIG_SND_ENS1371 is not set
> # CONFIG_SND_ES1938 is not set
> # CONFIG_SND_ES1968 is not set
> # CONFIG_SND_FM801 is not set
> # CONFIG_SND_HDA_INTEL is not set
> # CONFIG_SND_HDSP is not set
> # CONFIG_SND_HDSPM is not set
> # CONFIG_SND_HIFIER is not set
> # CONFIG_SND_ICE1712 is not set
> # CONFIG_SND_ICE1724 is not set
> # CONFIG_SND_INTEL8X0 is not set
> # CONFIG_SND_INTEL8X0M is not set
> # CONFIG_SND_KORG1212 is not set
> # CONFIG_SND_MAESTRO3 is not set
> # CONFIG_SND_MIXART is not set
> # CONFIG_SND_NM256 is not set
> # CONFIG_SND_PCXHR is not set
> # CONFIG_SND_RIPTIDE is not set
> # CONFIG_SND_RME32 is not set
> # CONFIG_SND_RME96 is not set
> # CONFIG_SND_RME9652 is not set
> # CONFIG_SND_SONICVIBES is not set
> # CONFIG_SND_TRIDENT is not set
> # CONFIG_SND_VIA82XX is not set
> # CONFIG_SND_VIA82XX_MODEM is not set
> # CONFIG_SND_VIRTUOSO is not set
> # CONFIG_SND_VX222 is not set
> # CONFIG_SND_YMFPCI is not set
> CONFIG_SND_USB=y
> # CONFIG_SND_USB_AUDIO is not set
> # CONFIG_SND_USB_CAIAQ is not set
> # CONFIG_SND_SOC is not set
> # CONFIG_SOUND_PRIME is not set
> CONFIG_AC97_BUS=m
> CONFIG_HID_SUPPORT=y
> CONFIG_HID=y
> CONFIG_HID_DEBUG=y
> # CONFIG_HIDRAW is not set
>
> #
> # USB Input Devices
> #
> CONFIG_USB_HID=m
> # CONFIG_HID_PID is not set
> CONFIG_USB_HIDDEV=y
>
> #
> # USB HID Boot Protocol drivers
> #
> # CONFIG_USB_KBD is not set
> # CONFIG_USB_MOUSE is not set
>
> #
> # Special HID drivers
> #
> CONFIG_HID_COMPAT=y
> CONFIG_HID_A4TECH=m
> CONFIG_HID_APPLE=m
> CONFIG_HID_BELKIN=m
> CONFIG_HID_CHERRY=m
> CONFIG_HID_CHICONY=m
> CONFIG_HID_CYPRESS=m
> CONFIG_HID_EZKEY=m
> CONFIG_HID_GYRATION=m
> CONFIG_HID_LOGITECH=m
> # CONFIG_LOGITECH_FF is not set
> # CONFIG_LOGIRUMBLEPAD2_FF is not set
> CONFIG_HID_MICROSOFT=m
> CONFIG_HID_MONTEREY=m
> CONFIG_HID_PANTHERLORD=m
> # CONFIG_PANTHERLORD_FF is not set
> CONFIG_HID_PETALYNX=m
> CONFIG_HID_SAMSUNG=m
> CONFIG_HID_SONY=m
> CONFIG_HID_SUNPLUS=m
> # CONFIG_THRUSTMASTER_FF is not set
> # CONFIG_ZEROPLUS_FF is not set
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_OHCI=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB=m
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
>
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEVICEFS=y
> CONFIG_USB_DEVICE_CLASS=y
> # CONFIG_USB_DYNAMIC_MINORS is not set
> # CONFIG_USB_SUSPEND is not set
> # CONFIG_USB_OTG is not set
> CONFIG_USB_MON=y
> # CONFIG_USB_WUSB is not set
> # CONFIG_USB_WUSB_CBAF is not set
>
> #
> # USB Host Controller Drivers
> #
> # CONFIG_USB_C67X00_HCD is not set
> # CONFIG_USB_EHCI_HCD is not set
> # CONFIG_USB_OXU210HP_HCD is not set
> # CONFIG_USB_ISP116X_HCD is not set
> # CONFIG_USB_ISP1760_HCD is not set
> # CONFIG_USB_OHCI_HCD is not set
> CONFIG_USB_UHCI_HCD=m
> # CONFIG_USB_SL811_HCD is not set
> # CONFIG_USB_R8A66597_HCD is not set
> # CONFIG_USB_WHCI_HCD is not set
> # CONFIG_USB_HWA_HCD is not set
>
> #
> # Enable Host or Gadget support to see Inventra options
> #
>
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=m
> CONFIG_USB_PRINTER=m
> # CONFIG_USB_WDM is not set
> # CONFIG_USB_TMC is not set
>
> #
> # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
> #
>
> #
> # may also be needed; see USB_STORAGE Help for more information
> #
> CONFIG_USB_STORAGE=m
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_DATAFAB is not set
> # CONFIG_USB_STORAGE_FREECOM is not set
> # CONFIG_USB_STORAGE_ISD200 is not set
> # CONFIG_USB_STORAGE_DPCM is not set
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> # CONFIG_USB_STORAGE_SDDR55 is not set
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> # CONFIG_USB_STORAGE_ALAUDA is not set
> # CONFIG_USB_STORAGE_ONETOUCH is not set
> # CONFIG_USB_STORAGE_KARMA is not set
> # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> # CONFIG_USB_LIBUSUAL is not set
>
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> # CONFIG_USB_MICROTEK is not set
>
> #
> # USB port drivers
> #
> # CONFIG_USB_SERIAL is not set
>
> #
> # USB Miscellaneous drivers
> #
> # CONFIG_USB_EMI62 is not set
> # CONFIG_USB_EMI26 is not set
> # CONFIG_USB_ADUTUX is not set
> # CONFIG_USB_SEVSEG is not set
> # CONFIG_USB_RIO500 is not set
> # CONFIG_USB_LEGOTOWER is not set
> # CONFIG_USB_LCD is not set
> # CONFIG_USB_BERRY_CHARGE is not set
> # CONFIG_USB_LED is not set
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> # CONFIG_USB_CYTHERM is not set
> # CONFIG_USB_PHIDGET is not set
> # CONFIG_USB_IDMOUSE is not set
> # CONFIG_USB_FTDI_ELAN is not set
> # CONFIG_USB_APPLEDISPLAY is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> # CONFIG_USB_ISIGHTFW is not set
> # CONFIG_USB_VST is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_UIO is not set
> # CONFIG_MSPEC is not set
>
> #
> # File systems
> #
> CONFIG_EXT2_FS=y
> # CONFIG_EXT2_FS_XATTR is not set
> # CONFIG_EXT2_FS_XIP is not set
> CONFIG_EXT3_FS=y
> CONFIG_EXT3_FS_XATTR=y
> # CONFIG_EXT3_FS_POSIX_ACL is not set
> # CONFIG_EXT3_FS_SECURITY is not set
> # CONFIG_EXT4_FS is not set
> CONFIG_JBD=y
> CONFIG_FS_MBCACHE=y
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_FS_POSIX_ACL=y
> CONFIG_FILE_LOCKING=y
> CONFIG_XFS_FS=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> # CONFIG_XFS_RT is not set
> # CONFIG_XFS_DEBUG is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_OCFS2_FS is not set
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY=y
> CONFIG_INOTIFY_USER=y
> # CONFIG_QUOTA is not set
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS_FS=m
> CONFIG_AUTOFS4_FS=m
> # CONFIG_FUSE_FS is not set
>
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=m
> CONFIG_JOLIET=y
> # CONFIG_ZISOFS is not set
> CONFIG_UDF_FS=m
> CONFIG_UDF_NLS=y
>
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_NTFS_FS is not set
>
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> # CONFIG_TMPFS_POSIX_ACL is not set
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> # CONFIG_CONFIGFS_FS is not set
>
> #
> # Miscellaneous filesystems
> #
> # CONFIG_ADFS_FS is not set
> # CONFIG_AFFS_FS is not set
> # CONFIG_HFS_FS is not set
> # CONFIG_HFSPLUS_FS is not set
> # CONFIG_BEFS_FS is not set
> # CONFIG_BFS_FS is not set
> # CONFIG_EFS_FS is not set
> # CONFIG_CRAMFS is not set
> # CONFIG_VXFS_FS is not set
> # CONFIG_MINIX_FS is not set
> # CONFIG_OMFS_FS is not set
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> # CONFIG_ROMFS_FS is not set
> # CONFIG_SYSV_FS is not set
> # CONFIG_UFS_FS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=m
> CONFIG_NFS_V3=y
> # CONFIG_NFS_V3_ACL is not set
> CONFIG_NFS_V4=y
> CONFIG_NFSD=m
> CONFIG_NFSD_V3=y
> # CONFIG_NFSD_V3_ACL is not set
> CONFIG_NFSD_V4=y
> CONFIG_LOCKD=m
> CONFIG_LOCKD_V4=y
> CONFIG_EXPORTFS=m
> CONFIG_NFS_COMMON=y
> CONFIG_SUNRPC=m
> CONFIG_SUNRPC_GSS=m
> # CONFIG_SUNRPC_REGISTER_V4 is not set
> CONFIG_RPCSEC_GSS_KRB5=m
> # CONFIG_RPCSEC_GSS_SPKM3 is not set
> # CONFIG_SMB_FS is not set
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> # CONFIG_CIFS_STATS2 is not set
> # CONFIG_CIFS_WEAK_PW_HASH is not set
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> # CONFIG_CIFS_DEBUG2 is not set
> # CONFIG_CIFS_EXPERIMENTAL is not set
> # CONFIG_NCP_FS is not set
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
>
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> CONFIG_SGI_PARTITION=y
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> # CONFIG_NLS_ASCII is not set
> CONFIG_NLS_ISO8859_1=y
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
> CONFIG_HAVE_KVM=y
> CONFIG_VIRTUALIZATION=y
> # CONFIG_KVM is not set
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_BALLOON is not set
>
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> # CONFIG_CRC_CCITT is not set
> # CONFIG_CRC16 is not set
> # CONFIG_CRC_T10DIF is not set
> CONFIG_CRC_ITU_T=m
> CONFIG_CRC32=y
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> CONFIG_PLIST=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT=y
> CONFIG_HAS_DMA=y
> CONFIG_GENERIC_HARDIRQS=y
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_IRQ_PER_CPU=y
>
> #
> # Kernel hacking
> #
> # CONFIG_PRINTK_TIME is not set
> CONFIG_ENABLE_WARN_DEPRECATED=y
> CONFIG_ENABLE_MUST_CHECK=y
> CONFIG_FRAME_WARN=2048
> CONFIG_MAGIC_SYSRQ=y
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_SHIRQ is not set
> CONFIG_DETECT_SOFTLOCKUP=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
> CONFIG_SCHED_DEBUG=y
> # CONFIG_SCHEDSTATS is not set
> # CONFIG_TIMER_STATS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_WRITECOUNT is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_FAULT_INJECTION is not set
> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
>
> #
> # Tracers
> #
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_CONTEXT_SWITCH_TRACER is not set
> # CONFIG_BOOT_TRACER is not set
> # CONFIG_DYNAMIC_PRINTK_DEBUG is not set
> # CONFIG_SAMPLES is not set
> # CONFIG_IA64_GRANULE_16MB is not set
> CONFIG_IA64_GRANULE_64MB=y
> # CONFIG_IA64_PRINT_HAZARDS is not set
> # CONFIG_DISABLE_VHPT is not set
> # CONFIG_IA64_DEBUG_CMPXCHG is not set
> # CONFIG_IA64_DEBUG_IRQ is not set
> CONFIG_SYSVIPC_COMPAT=y
>
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
> CONFIG_CRYPTO=y
>
> #
> # Crypto core or helper
> #
> # CONFIG_CRYPTO_FIPS is not set
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_BLKCIPHER=m
> CONFIG_CRYPTO_HASH=m
> CONFIG_CRYPTO_RNG=m
> CONFIG_CRYPTO_MANAGER=m
> # CONFIG_CRYPTO_GF128MUL is not set
> # CONFIG_CRYPTO_NULL is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> # CONFIG_CRYPTO_AUTHENC is not set
> # CONFIG_CRYPTO_TEST is not set
>
> #
> # Authenticated Encryption with Associated Data
> #
> # CONFIG_CRYPTO_CCM is not set
> # CONFIG_CRYPTO_GCM is not set
> # CONFIG_CRYPTO_SEQIV is not set
>
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=m
> # CONFIG_CRYPTO_CTR is not set
> # CONFIG_CRYPTO_CTS is not set
> # CONFIG_CRYPTO_ECB is not set
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
>
> #
> # Hash modes
> #
> # CONFIG_CRYPTO_HMAC is not set
> # CONFIG_CRYPTO_XCBC is not set
>
> #
> # Digest
> #
> # CONFIG_CRYPTO_CRC32C is not set
> # CONFIG_CRYPTO_MD4 is not set
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD128 is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_RMD256 is not set
> # CONFIG_CRYPTO_RMD320 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA256 is not set
> # CONFIG_CRYPTO_SHA512 is not set
> # CONFIG_CRYPTO_TGR192 is not set
> # CONFIG_CRYPTO_WP512 is not set
>
> #
> # Ciphers
> #
> # CONFIG_CRYPTO_AES is not set
> # CONFIG_CRYPTO_ANUBIS is not set
> # CONFIG_CRYPTO_ARC4 is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SEED is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_TEA is not set
> # CONFIG_CRYPTO_TWOFISH is not set
>
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> # CONFIG_CRYPTO_LZO is not set
>
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
>

------=_Part_10740_3611406.1226004280962
Content-Type: application/octet-stream; name=perfmon-config-ia64.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn7v9sr90
Content-Disposition: attachment; filename=perfmon-config-ia64.diff

Y29tbWl0IDQ2YjRkZmRjMWRkNDk3NmQ4OTJmYTQ3YjVlOGEyNTUxZmU2Mjc4ZmEKQXV0aG9yOiBT
dGVwaGFuZSBFcmFuaWFuIDxlcmFuaWFuQGdtYWlsLmNvbT4KRGF0ZTogICBUaHUgTm92IDYgMjE6
NDA6NTQgMjAwOCArMDEwMAoKICAgIHBlcmZtb24oaWE2NCk6IHJlbmFtZSBDT05GSUdfUEVSRk1P
TiB0byBDT05GSUdfUEVSRk1PTl9WMjAKICAgIAogICAgCUF2b2lkIG5hbWUgY29sbGlzaW9uIHdp
dGggZ2VuZXJpYyBDT05GSUdfUEVSRk1PTgogICAgCXdoaWNoIGN1cnJlbnRseSBvbmx5IHdvcmtz
IG9uIHg4Ni4KICAgIAogICAgU2lnbmVkLW9mZi1ieTogU3RlcGhhbmUgRXJhbmlhbiA8ZXJhbmlh
bkBnbWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L0tjb25maWcgYi9hcmNoL2lhNjQv
S2NvbmZpZwppbmRleCAyN2VlYzcxLi4zMGE4NWM1IDEwMDY0NAotLS0gYS9hcmNoL2lhNjQvS2Nv
bmZpZworKysgYi9hcmNoL2lhNjQvS2NvbmZpZwpAQCAtNTA0LDcgKzUwNCw3IEBAIGNvbmZpZyBD
T01QQVRfRk9SX1U2NF9BTElHTk1FTlQKIGNvbmZpZyBJQTY0X01DQV9SRUNPVkVSWQogCXRyaXN0
YXRlICJNQ0EgcmVjb3ZlcnkgZnJvbSBlcnJvcnMgb3RoZXIgdGhhbiBUTEIuIgogCi1jb25maWcg
UEVSRk1PTgorY29uZmlnIFBFUkZNT05fVjIwCiAJYm9vbCAiUGVyZm9ybWFuY2UgbW9uaXRvciBz
dXBwb3J0IgogCWhlbHAKIAkgIFNlbGVjdHMgd2hldGhlciBzdXBwb3J0IGZvciB0aGUgSUEtNjQg
cGVyZm9ybWFuY2UgbW9uaXRvciBoYXJkd2FyZQpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2NvbmZp
Z3MvYmlnc3VyX2RlZmNvbmZpZyBiL2FyY2gvaWE2NC9jb25maWdzL2JpZ3N1cl9kZWZjb25maWcK
aW5kZXggNmRkODY1NS4uMmMwNGZiZSAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2NvbmZpZ3MvYmln
c3VyX2RlZmNvbmZpZworKysgYi9hcmNoL2lhNjQvY29uZmlncy9iaWdzdXJfZGVmY29uZmlnCkBA
IC0xMzQsNyArMTM0LDcgQEAgQ09ORklHX0FSQ0hfU1BBUlNFTUVNX0VOQUJMRT15CiBDT05GSUdf
SUEzMl9TVVBQT1JUPXkKIENPTkZJR19DT01QQVQ9eQogIyBDT05GSUdfSUE2NF9NQ0FfUkVDT1ZF
UlkgaXMgbm90IHNldAotQ09ORklHX1BFUkZNT049eQorQ09ORklHX1BFUkZNT05fVjIwPXkKIENP
TkZJR19JQTY0X1BBTElORk89eQogCiAjCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQvY29uZmlncy9n
ZW5lcmljX2RlZmNvbmZpZyBiL2FyY2gvaWE2NC9jb25maWdzL2dlbmVyaWNfZGVmY29uZmlnCmlu
ZGV4IGUwNWY5ZTEuLjdkODlhMTkgMTAwNjQ0Ci0tLSBhL2FyY2gvaWE2NC9jb25maWdzL2dlbmVy
aWNfZGVmY29uZmlnCisrKyBiL2FyY2gvaWE2NC9jb25maWdzL2dlbmVyaWNfZGVmY29uZmlnCkBA
IC0yMDksNyArMjA5LDcgQEAgQ09ORklHX0lBMzJfU1VQUE9SVD15CiBDT05GSUdfQ09NUEFUPXkK
IENPTkZJR19DT01QQVRfRk9SX1U2NF9BTElHTk1FTlQ9eQogQ09ORklHX0lBNjRfTUNBX1JFQ09W
RVJZPXkKLUNPTkZJR19QRVJGTU9OPXkKK0NPTkZJR19QRVJGTU9OX1YyMD15CiBDT05GSUdfSUE2
NF9QQUxJTkZPPXkKICMgQ09ORklHX0lBNjRfTUNfRVJSX0lOSkVDVCBpcyBub3Qgc2V0CiBDT05G
SUdfU0dJX1NOPXkKZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9jb25maWdzL2dlbnNwYXJzZV9kZWZj
b25maWcgYi9hcmNoL2lhNjQvY29uZmlncy9nZW5zcGFyc2VfZGVmY29uZmlnCmluZGV4IGU4NmZi
ZDMuLjVmOGM3NzIgMTAwNjQ0Ci0tLSBhL2FyY2gvaWE2NC9jb25maWdzL2dlbnNwYXJzZV9kZWZj
b25maWcKKysrIGIvYXJjaC9pYTY0L2NvbmZpZ3MvZ2Vuc3BhcnNlX2RlZmNvbmZpZwpAQCAtMTQy
LDcgKzE0Miw3IEBAIENPTkZJR19IQVZFX0FSQ0hfRUFSTFlfUEZOX1RPX05JRD15CiBDT05GSUdf
SUEzMl9TVVBQT1JUPXkKIENPTkZJR19DT01QQVQ9eQogQ09ORklHX0lBNjRfTUNBX1JFQ09WRVJZ
PXkKLUNPTkZJR19QRVJGTU9OPXkKK0NPTkZJR19QRVJGTU9OX1YyMD15CiBDT05GSUdfSUE2NF9Q
QUxJTkZPPXkKIENPTkZJR19TR0lfU049eQogCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQvY29uZmln
cy9zaW1fZGVmY29uZmlnIGIvYXJjaC9pYTY0L2NvbmZpZ3Mvc2ltX2RlZmNvbmZpZwppbmRleCA1
NDZhNzcyLi5kNTE0NTdhIDEwMDY0NAotLS0gYS9hcmNoL2lhNjQvY29uZmlncy9zaW1fZGVmY29u
ZmlnCisrKyBiL2FyY2gvaWE2NC9jb25maWdzL3NpbV9kZWZjb25maWcKQEAgLTEzMyw3ICsxMzMs
NyBAQCBDT05GSUdfQVJDSF9TUEFSU0VNRU1fRU5BQkxFPXkKIENPTkZJR19JQTMyX1NVUFBPUlQ9
eQogQ09ORklHX0NPTVBBVD15CiAjIENPTkZJR19JQTY0X01DQV9SRUNPVkVSWSBpcyBub3Qgc2V0
Ci0jIENPTkZJR19QRVJGTU9OIGlzIG5vdCBzZXQKKyMgQ09ORklHX1BFUkZNT05fVjIwIGlzIG5v
dCBzZXQKIENPTkZJR19JQTY0X1BBTElORk89bQogCiAjCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQv
Y29uZmlncy90aWdlcl9kZWZjb25maWcgYi9hcmNoL2lhNjQvY29uZmlncy90aWdlcl9kZWZjb25m
aWcKaW5kZXggYzUyMmVkZi4uMzE4ZDg0NiAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2NvbmZpZ3Mv
dGlnZXJfZGVmY29uZmlnCisrKyBiL2FyY2gvaWE2NC9jb25maWdzL3RpZ2VyX2RlZmNvbmZpZwpA
QCAtMTU2LDcgKzE1Niw3IEBAIENPTkZJR19WSVJUVUFMX01FTV9NQVA9eQogQ09ORklHX0hPTEVT
X0lOX1pPTkU9eQogIyBDT05GSUdfSUEzMl9TVVBQT1JUIGlzIG5vdCBzZXQKIENPTkZJR19JQTY0
X01DQV9SRUNPVkVSWT15Ci1DT05GSUdfUEVSRk1PTj15CitDT05GSUdfUEVSRk1PTl9WMjA9eQog
Q09ORklHX0lBNjRfUEFMSU5GTz15CiAjIENPTkZJR19JQTY0X01DX0VSUl9JTkpFQ1QgaXMgbm90
IHNldAogIyBDT05GSUdfSUE2NF9FU0kgaXMgbm90IHNldApkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0
L2NvbmZpZ3MvengxX2RlZmNvbmZpZyBiL2FyY2gvaWE2NC9jb25maWdzL3p4MV9kZWZjb25maWcK
aW5kZXggMGEwNmIxMy4uMmJmMGFkNCAxMDA2NDQKLS0tIGEvYXJjaC9pYTY0L2NvbmZpZ3Mvengx
X2RlZmNvbmZpZworKysgYi9hcmNoL2lhNjQvY29uZmlncy96eDFfZGVmY29uZmlnCkBAIC0xNTMs
NyArMTUzLDcgQEAgQ09ORklHX0hPTEVTX0lOX1pPTkU9eQogQ09ORklHX0lBMzJfU1VQUE9SVD15
CiBDT05GSUdfQ09NUEFUPXkKIENPTkZJR19JQTY0X01DQV9SRUNPVkVSWT15Ci1DT05GSUdfUEVS
Rk1PTj15CitDT05GSUdfUEVSRk1PTl9WMjA9eQogQ09ORklHX0lBNjRfUEFMSU5GTz15CiAjIENP
TkZJR19JQTY0X0VTSSBpcyBub3Qgc2V0CiAjIENPTkZJR19LRVhFQyBpcyBub3Qgc2V0CmRpZmYg
LS1naXQgYS9hcmNoL2lhNjQvaW5jbHVkZS9hc20vcHJvY2Vzc29yLmggYi9hcmNoL2lhNjQvaW5j
bHVkZS9hc20vcHJvY2Vzc29yLmgKaW5kZXggZjg4ZmEwNS4uM2VjZjdlMCAxMDA2NDQKLS0tIGEv
YXJjaC9pYTY0L2luY2x1ZGUvYXNtL3Byb2Nlc3Nvci5oCisrKyBiL2FyY2gvaWE2NC9pbmNsdWRl
L2FzbS9wcm9jZXNzb3IuaApAQCAtMzIxLDcgKzMyMSw3IEBAIHN0cnVjdCB0aHJlYWRfc3RydWN0
IHsKICNlbHNlCiAjIGRlZmluZSBJTklUX1RIUkVBRF9JQTMyCiAjZW5kaWYgLyogQ09ORklHX0lB
MzJfU1VQUE9SVCAqLwotI2lmZGVmIENPTkZJR19QRVJGTU9OCisjaWZkZWYgQ09ORklHX1BFUkZN
T05fVjIwCiAJdm9pZCAqcGZtX2NvbnRleHQ7CQkgICAgIC8qIHBvaW50ZXIgdG8gZGV0YWlsZWQg
UE1VIGNvbnRleHQgKi8KIAl1bnNpZ25lZCBsb25nIHBmbV9uZWVkc19jaGVja2luZzsgICAgLyog
d2hlbiA+MCwgcGVuZGluZyBwZXJmbW9uIHdvcmsgb24ga2VybmVsIGV4aXQgKi8KICMgZGVmaW5l
IElOSVRfVEhSRUFEX1BNCQkucGZtX2NvbnRleHQgPQkJTlVMTCwgICAgIFwKZGlmZiAtLWdpdCBh
L2FyY2gvaWE2NC9pbmNsdWRlL2FzbS9zeXN0ZW0uaCBiL2FyY2gvaWE2NC9pbmNsdWRlL2FzbS9z
eXN0ZW0uaAppbmRleCA5MjdhMzgxLi4zODdlNTQwIDEwMDY0NAotLS0gYS9hcmNoL2lhNjQvaW5j
bHVkZS9hc20vc3lzdGVtLmgKKysrIGIvYXJjaC9pYTY0L2luY2x1ZGUvYXNtL3N5c3RlbS5oCkBA
IC0yMjQsNyArMjI0LDcgQEAgZXh0ZXJuIHZvaWQgaWE2NF9hY2NvdW50X29uX3N3aXRjaCAoc3Ry
dWN0IHRhc2tfc3RydWN0ICpwcmV2LCBzdHJ1Y3QgdGFza19zdHJ1Y3QKICMgZGVmaW5lIElBNjRf
QUNDT1VOVF9PTl9TV0lUQ0gocCxuKQogI2VuZGlmCiAKLSNpZmRlZiBDT05GSUdfUEVSRk1PTgor
I2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogICBERUNMQVJFX1BFUl9DUFUodW5zaWduZWQgbG9u
ZywgcGZtX3N5c3RfaW5mbyk7CiAjIGRlZmluZSBQRVJGTU9OX0lTX1NZU1dJREUoKSAoX19nZXRf
Y3B1X3ZhcihwZm1fc3lzdF9pbmZvKSAmIDB4MSkKICNlbHNlCmRpZmYgLS1naXQgYS9hcmNoL2lh
NjQva2VybmVsL01ha2VmaWxlIGIvYXJjaC9pYTY0L2tlcm5lbC9NYWtlZmlsZQppbmRleCBjMzgx
ZWE5Li45MzgxOWNjIDEwMDY0NAotLS0gYS9hcmNoL2lhNjQva2VybmVsL01ha2VmaWxlCisrKyBi
L2FyY2gvaWE2NC9rZXJuZWwvTWFrZWZpbGUKQEAgLTIzLDcgKzIzLDcgQEAgb2JqLSQoQ09ORklH
X0lPU0FQSUMpCQkrPSBpb3NhcGljLm8KIG9iai0kKENPTkZJR19NT0RVTEVTKQkJKz0gbW9kdWxl
Lm8KIG9iai0kKENPTkZJR19TTVApCQkrPSBzbXAubyBzbXBib290Lm8KIG9iai0kKENPTkZJR19O
VU1BKQkJKz0gbnVtYS5vCi1vYmotJChDT05GSUdfUEVSRk1PTikJCSs9IHBlcmZtb25fZGVmYXVs
dF9zbXBsLm8KK29iai0kKENPTkZJR19QRVJGTU9OX1YyMCkJKz0gcGVyZm1vbl9kZWZhdWx0X3Nt
cGwubwogb2JqLSQoQ09ORklHX0lBNjRfQ1lDTE9ORSkJKz0gY3ljbG9uZS5vCiBvYmotJChDT05G
SUdfQ1BVX0ZSRVEpCQkrPSBjcHVmcmVxLwogb2JqLSQoQ09ORklHX0lBNjRfTUNBX1JFQ09WRVJZ
KQkrPSBtY2FfcmVjb3ZlcnkubwpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tlcm5lbC9pcnFfaWE2
NC5jIGIvYXJjaC9pYTY0L2tlcm5lbC9pcnFfaWE2NC5jCmluZGV4IDI4ZDNkNDguLmRiNTRiZDQg
MTAwNjQ0Ci0tLSBhL2FyY2gvaWE2NC9rZXJuZWwvaXJxX2lhNjQuYworKysgYi9hcmNoL2lhNjQv
a2VybmVsL2lycV9pYTY0LmMKQEAgLTQwLDcgKzQwLDcgQEAKICNpbmNsdWRlIDxhc20vc3lzdGVt
Lmg+CiAjaW5jbHVkZSA8YXNtL3RsYmZsdXNoLmg+CiAKLSNpZmRlZiBDT05GSUdfUEVSRk1PTgor
I2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogIyBpbmNsdWRlIDxhc20vcGVyZm1vbi5oPgogI2Vu
ZGlmCiAKQEAgLTY2MCw3ICs2NjAsNyBAQCBpbml0X0lSUSAodm9pZCkKIAl9CiAjZW5kaWYKICNl
bmRpZgotI2lmZGVmIENPTkZJR19QRVJGTU9OCisjaWZkZWYgQ09ORklHX1BFUkZNT05fVjIwCiAJ
cGZtX2luaXRfcGVyY3B1KCk7CiAjZW5kaWYKIAlwbGF0Zm9ybV9pcnFfaW5pdCgpOwpkaWZmIC0t
Z2l0IGEvYXJjaC9pYTY0L2tlcm5lbC9wZXJmbW9uLmMgYi9hcmNoL2lhNjQva2VybmVsL3BlcmZt
b24uYwppbmRleCA2NTQzYTU1Li4zYmQxODgzIDEwMDY0NAotLS0gYS9hcmNoL2lhNjQva2VybmVs
L3BlcmZtb24uYworKysgYi9hcmNoL2lhNjQva2VybmVsL3BlcmZtb24uYwpAQCAtNTIsNyArNTIs
NyBAQAogI2luY2x1ZGUgPGFzbS91YWNjZXNzLmg+CiAjaW5jbHVkZSA8YXNtL2RlbGF5Lmg+CiAK
LSNpZmRlZiBDT05GSUdfUEVSRk1PTgorI2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogLyoKICAq
IHBlcmZtb24gY29udGV4dCBzdGF0ZQogICovCkBAIC02ODIwLDEwICs2ODIwLDEwIEBAIHBmbV9p
bmhlcml0KHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCiAJ
ICogdGhlIHBzciBiaXRzIGFyZSBhbHJlYWR5IHNldCBwcm9wZXJseSBpbiBjb3B5X3RocmVhZHMo
KQogCSAqLwogfQotI2Vsc2UgIC8qICFDT05GSUdfUEVSRk1PTiAqLworI2Vsc2UgIC8qICFDT05G
SUdfUEVSRk1PTl92MjAgKi8KIGFzbWxpbmthZ2UgbG9uZwogc3lzX3BlcmZtb25jdGwgKGludCBm
ZCwgaW50IGNtZCwgdm9pZCAqYXJnLCBpbnQgY291bnQpCiB7CiAJcmV0dXJuIC1FTk9TWVM7CiB9
Ci0jZW5kaWYgLyogQ09ORklHX1BFUkZNT04gKi8KKyNlbmRpZiAvKiBDT05GSUdfUEVSRk1PTl9W
MjAgKi8KZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJuZWwvcHJvY2Vzcy5jIGIvYXJjaC9pYTY0
L2tlcm5lbC9wcm9jZXNzLmMKaW5kZXggYzU3MTYyNy4uYWZiZjFhOCAxMDA2NDQKLS0tIGEvYXJj
aC9pYTY0L2tlcm5lbC9wcm9jZXNzLmMKKysrIGIvYXJjaC9pYTY0L2tlcm5lbC9wcm9jZXNzLmMK
QEAgLTQ2LDcgKzQ2LDcgQEAKIAogI2luY2x1ZGUgImVudHJ5LmgiCiAKLSNpZmRlZiBDT05GSUdf
UEVSRk1PTgorI2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogIyBpbmNsdWRlIDxhc20vcGVyZm1v
bi5oPgogI2VuZGlmCiAKQEAgLTE3NCw3ICsxNzQsNyBAQCBkb19ub3RpZnlfcmVzdW1lX3VzZXIo
c2lnc2V0X3QgKnVudXNlZCwgc3RydWN0IHNpZ3NjcmF0Y2ggKnNjciwgbG9uZyBpbl9zeXNjYWxs
KQogCQlyZXR1cm47CiAJfQogCi0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRlZiBDT05GSUdf
UEVSRk1PTl9WMjAKIAlpZiAoY3VycmVudC0+dGhyZWFkLnBmbV9uZWVkc19jaGVja2luZykKIAkJ
LyoKIAkJICogTm90ZTogcGZtX2hhbmRsZV93b3JrKCkgYWxsb3cgdXMgdG8gY2FsbCBpdCB3aXRo
IGludGVycnVwdHMKQEAgLTMzNCwxNCArMzM0LDE0IEBAIGNwdV9pZGxlICh2b2lkKQogdm9pZAog
aWE2NF9zYXZlX2V4dHJhIChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spCiB7Ci0jaWZkZWYgQ09O
RklHX1BFUkZNT04KKyNpZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAKIAl1bnNpZ25lZCBsb25nIGlu
Zm87CiAjZW5kaWYKIAogCWlmICgodGFzay0+dGhyZWFkLmZsYWdzICYgSUE2NF9USFJFQURfREJH
X1ZBTElEKSAhPSAwKQogCQlpYTY0X3NhdmVfZGVidWdfcmVncygmdGFzay0+dGhyZWFkLmRiclsw
XSk7CiAKLSNpZmRlZiBDT05GSUdfUEVSRk1PTgorI2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAog
CWlmICgodGFzay0+dGhyZWFkLmZsYWdzICYgSUE2NF9USFJFQURfUE1fVkFMSUQpICE9IDApCiAJ
CXBmbV9zYXZlX3JlZ3ModGFzayk7CiAKQEAgLTM1OSwxNCArMzU5LDE0IEBAIGlhNjRfc2F2ZV9l
eHRyYSAoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQogdm9pZAogaWE2NF9sb2FkX2V4dHJhIChz
dHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spCiB7Ci0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRl
ZiBDT05GSUdfUEVSRk1PTl9WMjAKIAl1bnNpZ25lZCBsb25nIGluZm87CiAjZW5kaWYKIAogCWlm
ICgodGFzay0+dGhyZWFkLmZsYWdzICYgSUE2NF9USFJFQURfREJHX1ZBTElEKSAhPSAwKQogCQlp
YTY0X2xvYWRfZGVidWdfcmVncygmdGFzay0+dGhyZWFkLmRiclswXSk7CiAKLSNpZmRlZiBDT05G
SUdfUEVSRk1PTgorI2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogCWlmICgodGFzay0+dGhyZWFk
LmZsYWdzICYgSUE2NF9USFJFQURfUE1fVkFMSUQpICE9IDApCiAJCXBmbV9sb2FkX3JlZ3ModGFz
ayk7CiAKQEAgLTUyMyw3ICs1MjMsNyBAQCBjb3B5X3RocmVhZCAoaW50IG5yLCB1bnNpZ25lZCBs
b25nIGNsb25lX2ZsYWdzLAogCX0KICNlbmRpZgogCi0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNp
ZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAKIAlpZiAoY3VycmVudC0+dGhyZWFkLnBmbV9jb250ZXh0
KQogCQlwZm1faW5oZXJpdChwLCBjaGlsZF9wdHJlZ3MpOwogI2VuZGlmCkBAIC03MzUsNyArNzM1
LDcgQEAgZXhpdF90aHJlYWQgKHZvaWQpCiB7CiAKIAlpYTY0X2Ryb3BfZnB1KGN1cnJlbnQpOwot
I2lmZGVmIENPTkZJR19QRVJGTU9OCisjaWZkZWYgQ09ORklHX1BFUkZNT05fVjIwCiAgICAgICAg
LyogaWYgbmVlZGVkLCBzdG9wIG1vbml0b3JpbmcgYW5kIGZsdXNoIHN0YXRlIHRvIHBlcmZtb24g
Y29udGV4dCAqLwogCWlmIChjdXJyZW50LT50aHJlYWQucGZtX2NvbnRleHQpCiAJCXBmbV9leGl0
X3RocmVhZChjdXJyZW50KTsKZGlmZiAtLWdpdCBhL2FyY2gvaWE2NC9rZXJuZWwvcHRyYWNlLmMg
Yi9hcmNoL2lhNjQva2VybmVsL3B0cmFjZS5jCmluZGV4IDkyYzk2ODkuLmZmZDIxMmYgMTAwNjQ0
Ci0tLSBhL2FyY2gvaWE2NC9rZXJuZWwvcHRyYWNlLmMKKysrIGIvYXJjaC9pYTY0L2tlcm5lbC9w
dHJhY2UuYwpAQCAtMzEsNyArMzEsNyBAQAogI2luY2x1ZGUgPGFzbS9zeXN0ZW0uaD4KICNpbmNs
dWRlIDxhc20vdWFjY2Vzcy5oPgogI2luY2x1ZGUgPGFzbS91bndpbmQuaD4KLSNpZmRlZiBDT05G
SUdfUEVSRk1PTgorI2lmZGVmIENPTkZJR19QRVJGTU9OX1YyMAogI2luY2x1ZGUgPGFzbS9wZXJm
bW9uLmg+CiAjZW5kaWYKIApAQCAtMjEwNSw3ICsyMTA1LDcgQEAgYWNjZXNzX3VhcmVhKHN0cnVj
dCB0YXNrX3N0cnVjdCAqY2hpbGQsIHVuc2lnbmVkIGxvbmcgYWRkciwKIAkJCQkiYWRkcmVzcyAw
eCVseFxuIiwgYWRkcik7CiAJCXJldHVybiAtMTsKIAl9Ci0jaWZkZWYgQ09ORklHX1BFUkZNT04K
KyNpZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAKIAkvKgogCSAqIENoZWNrIGlmIGRlYnVnIHJlZ2lz
dGVycyBhcmUgdXNlZCBieSBwZXJmbW9uLiBUaGlzCiAJICogdGVzdCBtdXN0IGJlIGRvbmUgb25j
ZSB3ZSBrbm93IHRoYXQgd2UgY2FuIGRvIHRoZQpkaWZmIC0tZ2l0IGEvYXJjaC9pYTY0L2tlcm5l
bC9zbXBib290LmMgYi9hcmNoL2lhNjQva2VybmVsL3NtcGJvb3QuYwppbmRleCAxZGNiYjg1Li5m
ODY1MzE1IDEwMDY0NAotLS0gYS9hcmNoL2lhNjQva2VybmVsL3NtcGJvb3QuYworKysgYi9hcmNo
L2lhNjQva2VybmVsL3NtcGJvb3QuYwpAQCAtMzgxLDcgKzM4MSw3IEBAIHNtcF9jYWxsaW4gKHZv
aWQpCiAJZXh0ZXJuIHZvaWQgaWE2NF9pbml0X2l0bSh2b2lkKTsKIAlleHRlcm4gdm9sYXRpbGUg
aW50IHRpbWVfa2VlcGVyX2lkOwogCi0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRlZiBDT05G
SUdfUEVSRk1PTl9WMjAKIAlleHRlcm4gdm9pZCBwZm1faW5pdF9wZXJjcHUodm9pZCk7CiAjZW5k
aWYKIApAQCAtNDExLDcgKzQxMSw3IEBAIHNtcF9jYWxsaW4gKHZvaWQpCiAKIAlpYTY0X21jYV9j
bWNfdmVjdG9yX3NldHVwKCk7CS8qIFNldHVwIHZlY3RvciBvbiBBUCAqLwogCi0jaWZkZWYgQ09O
RklHX1BFUkZNT04KKyNpZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAKIAlwZm1faW5pdF9wZXJjcHUo
KTsKICNlbmRpZgogCmRpZmYgLS1naXQgYS9hcmNoL2lhNjQvbGliL01ha2VmaWxlIGIvYXJjaC9p
YTY0L2xpYi9NYWtlZmlsZQppbmRleCA5ODc3MWUyLi43NTRmNDE1IDEwMDY0NAotLS0gYS9hcmNo
L2lhNjQvbGliL01ha2VmaWxlCisrKyBiL2FyY2gvaWE2NC9saWIvTWFrZWZpbGUKQEAgLTEzLDcg
KzEzLDcgQEAgbGliLXkgOj0gX19kaXZzaTMubyBfX3VkaXZzaTMubyBfX21vZHNpMy5vIF9fdW1v
ZHNpMy5vCQkJXAogCiBvYmotJChDT05GSUdfSVRBTklVTSkJKz0gY29weV9wYWdlLm8gY29weV91
c2VyLm8gbWVtY3B5Lm8KIG9iai0kKENPTkZJR19NQ0tJTkxFWSkJKz0gY29weV9wYWdlX21jay5v
IG1lbWNweV9tY2subwotbGliLSQoQ09ORklHX1BFUkZNT04pCSs9IGNhcnRhX3JhbmRvbS5vCits
aWItJChDT05GSUdfUEVSRk1PTl9WMjApICs9IGNhcnRhX3JhbmRvbS5vCiAKIEFGTEFHU19fX2Rp
dmRpMy5vCT0KIEFGTEFHU19fX3VkaXZkaTMubwk9IC1EVU5TSUdORUQKZGlmZiAtLWdpdCBhL2Fy
Y2gvaWE2NC9vcHJvZmlsZS9NYWtlZmlsZSBiL2FyY2gvaWE2NC9vcHJvZmlsZS9NYWtlZmlsZQpp
bmRleCBhYWQyN2E3Li4zMzIzZmQ1IDEwMDY0NAotLS0gYS9hcmNoL2lhNjQvb3Byb2ZpbGUvTWFr
ZWZpbGUKKysrIGIvYXJjaC9pYTY0L29wcm9maWxlL01ha2VmaWxlCkBAIC03LDQgKzcsNCBAQCBE
UklWRVJfT0JKUyA6PSAkKGFkZHByZWZpeCAuLi8uLi8uLi9kcml2ZXJzL29wcm9maWxlLywgXAog
CQl0aW1lcl9pbnQubyApCiAKIG9wcm9maWxlLXkgOj0gJChEUklWRVJfT0JKUykgaW5pdC5vIGJh
Y2t0cmFjZS5vCi1vcHJvZmlsZS0kKENPTkZJR19QRVJGTU9OKSArPSBwZXJmbW9uLm8KK29wcm9m
aWxlLSQoQ09ORklHX1BFUkZNT05fVjIwKSArPSBwZXJmbW9uLm8KZGlmZiAtLWdpdCBhL2FyY2gv
aWE2NC9vcHJvZmlsZS9pbml0LmMgYi9hcmNoL2lhNjQvb3Byb2ZpbGUvaW5pdC5jCmluZGV4IDMx
YjU0NWMuLjllZDJiYzEgMTAwNjQ0Ci0tLSBhL2FyY2gvaWE2NC9vcHJvZmlsZS9pbml0LmMKKysr
IGIvYXJjaC9pYTY0L29wcm9maWxlL2luaXQuYwpAQCAtMjAsNyArMjAsNyBAQCBpbnQgX19pbml0
IG9wcm9maWxlX2FyY2hfaW5pdChzdHJ1Y3Qgb3Byb2ZpbGVfb3BlcmF0aW9ucyAqb3BzKQogewog
CWludCByZXQgPSAtRU5PREVWOwogCi0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRlZiBDT05G
SUdfUEVSRk1PTl9WMjAKIAkvKiBwZXJmbW9uX2luaXQoKSBjYW4gZmFpbCwgYnV0IHdlIGhhdmUg
bm8gd2F5IHRvIHJlcG9ydCBpdCAqLwogCXJldCA9IHBlcmZtb25faW5pdChvcHMpOwogI2VuZGlm
CkBAIC0zMiw3ICszMiw3IEBAIGludCBfX2luaXQgb3Byb2ZpbGVfYXJjaF9pbml0KHN0cnVjdCBv
cHJvZmlsZV9vcGVyYXRpb25zICpvcHMpCiAKIHZvaWQgb3Byb2ZpbGVfYXJjaF9leGl0KHZvaWQp
CiB7Ci0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAKIAlw
ZXJmbW9uX2V4aXQoKTsKICNlbmRpZgogfQpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9zY2hl
ZC5oIGIvaW5jbHVkZS9saW51eC9zY2hlZC5oCmluZGV4IDA0MjE1MDAuLjE2YmY0MmQgMTAwNjQ0
Ci0tLSBhL2luY2x1ZGUvbGludXgvc2NoZWQuaAorKysgYi9pbmNsdWRlL2xpbnV4L3NjaGVkLmgK
QEAgLTEzNDksNyArMTM0OSw3IEBAIHN0cnVjdCB0YXNrX3N0cnVjdCB7CiAJICovCiAJdW5zaWdu
ZWQgbG9uZyB0aW1lcl9zbGFja19uczsKIAl1bnNpZ25lZCBsb25nIGRlZmF1bHRfdGltZXJfc2xh
Y2tfbnM7Ci0jaWZkZWYgQ09ORklHX1BFUkZNT04KKyNpZmRlZiBDT05GSUdfUEVSRk1PTl9WMjAK
IAlzdHJ1Y3QgcGZtX2NvbnRleHQgKnBmbV9jb250ZXh0OwogI2VuZGlmCiB9OwpkaWZmIC0tZ2l0
IGEvaW5jbHVkZS9saW51eC9zeXNjYWxscy5oIGIvaW5jbHVkZS9saW51eC9zeXNjYWxscy5oCmlu
ZGV4IDdiYzk2MGEuLmQxMmExNzUgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc3lzY2FsbHMu
aAorKysgYi9pbmNsdWRlL2xpbnV4L3N5c2NhbGxzLmgKQEAgLTYyNSw3ICs2MjUsNyBAQCBhc21s
aW5rYWdlIGxvbmcgc3lzX2ZhbGxvY2F0ZShpbnQgZmQsIGludCBtb2RlLCBsb2ZmX3Qgb2Zmc2V0
LCBsb2ZmX3QgbGVuKTsKIAogaW50IGtlcm5lbF9leGVjdmUoY29uc3QgY2hhciAqZmlsZW5hbWUs
IGNoYXIgKmNvbnN0IGFyZ3ZbXSwgY2hhciAqY29uc3QgZW52cFtdKTsKIAotI2lmZGVmIENPTkZJ
R19QRVJGTU9OCisjaWZkZWYgQ09ORklHX1BFUkZNT05fVjIwCiBzdHJ1Y3QgcGZhcmdfc2luZm87
CiBhc21saW5rYWdlIGxvbmcgc3lzX3BmbV9jcmVhdGUoaW50IGZsYWdzLCBzdHJ1Y3QgcGZhcmdf
c2luZm8gKnMsCiAJCQkgICAgICAgY2hhciAgX191c2VyICpmLCB2b2lkIF9fdXNlciAqdWFyZywg
c2l6ZV90IHVhcmdfc2l6ZSk7CkBAIC02MzQsNiArNjM0LDYgQEAgYXNtbGlua2FnZSBsb25nIHN5
c19wZm1fd3JpdGUoaW50IGZkLCBpbnQgZmxhZ3MsIGludCB0eXBlLCB2b2lkIF9fdXNlciAqYXJn
LCBzaXoKIGFzbWxpbmthZ2UgbG9uZyBzeXNfcGZtX3JlYWQoaW50IGZkLCBpbnQgZmxhZ3MsIGlu
dCB0eXBlLCB2b2lkIF9fdXNlciAqYXJnLCBzaXplX3Qgcyk7CiBhc21saW5rYWdlIGxvbmcgc3lz
X3BmbV9hdHRhY2goaW50IGZkLCBpbnQgZmxhZ3MsIGludCB0YXJnZXQpOwogYXNtbGlua2FnZSBs
b25nIHN5c19wZm1fc2V0X3N0YXRlKGludCBmZCwgaW50IGZsYWdzLCBpbnQgc3RhdGUpOwotI2Vu
ZGlmIC8qIENPTkZJR19QRVJGTU9OICovCisjZW5kaWYgLyogQ09ORklHX1BFUkZNT05fVjIwICov
CiAKICNlbmRpZgo=
------=_Part_10740_3611406.1226004280962--
