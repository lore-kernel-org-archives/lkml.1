Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYKCOf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYKCOf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYKCOfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:35:21 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:29865 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbYKCOfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:35:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=o7/s2l/HpNQoG0Sig+O7Sujl9vBxVsPeLmdGo7S+MUEC2aakhtrgvx5X8RCkIoRM/H
         kpAoG3EP+Mq/HLs0B67NzunXZWN10L199Waxr51Bnzmq6klCqLstRycJocIVg9yYsQxV
         0mjmeoUXRRqNiQFZiRlOzCRasIF5f+0RVxTds=
Message-ID: <efeafa350811030635g11be10f1s6479f62cdd16f0a9@mail.gmail.com>
Date: Mon, 3 Nov 2008 15:35:15 +0100
From: Lazy <lazy404@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: 2.6.27.4 WARNING: at kernel/softirq.c:136
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on a dell SC1435 (2 socket Dual Core Opteron)
same thing happens on PE2900 ( 1x4 core Xeon

during boot we get this warning but machine is stable

CPU3: AMD Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (16000.72 BogoMIPS).
------------[ cut here ]------------
WARNING: at kernel/softirq.c:136 ()
Modules linked in:
Pid: 16, comm: khelper Not tainted 2.6.27.4-grsec-www #1
 [<c041f2c2>]  [<c04d1279>]  [<c046ed8e>]  [<c048e78a>]  [<c0422fea>]
[<c0420a42>]  [<c0421d29>]  [<c042bb2f>]  [<c042bc2e>]  [<c042bb2f>]
[<c0403e67>]  ====
===================
---[ end trace 847e4d83bdf41d97 ]---
net_namespace: 596 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT


32 bit kernel is patched with grsecurity, tommorrow I will try a
vanilla kernel if it makes any diference


kernel config follows
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION="-www"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_CGROUPS=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_USER_SCHED=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLAB=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_CLASSIC_RCU=y

CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_MK8=y
CONFIG_X86_GENERIC=y
CONFIG_X86_CPU=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_NR_CPUS=8
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_VM86=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
CONFIG_HIGHMEM64G=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_NEED_NODE_MEMMAP_SIZE=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_IRQBALANCE=y
CONFIG_HZ_250=y
CONFIG_HZ=250
CONFIG_PHYSICAL_START=0x200000
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

CONFIG_PM=y
CONFIG_ACPI=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y

CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y

CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_X86_POWERNOW_K8_ACPI=y

CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

CONFIG_PCI=y
CONFIG_PCI_GODIRECT=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
CONFIG_ISA_DMA_API=y

CONFIG_BINFMT_ELF=y
CONFIG_NET=y

CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_DEFAULT_HTCP=y
CONFIG_DEFAULT_TCP_CONG="htcp"
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y

CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_XTABLES=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
CONFIG_VLAN_8021Q=m
CONFIG_NET_SCHED=y

CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y




CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PNP=y
CONFIG_PNP_DEBUG=y

CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=m
CONFIG_ATA_OVER_ETH=m
CONFIG_HAVE_IDE=y
CONFIG_IDE=m
CONFIG_BLK_DEV_IDE=m

CONFIG_IDE_TIMINGS=y
CONFIG_BLK_DEV_IDEDISK=m
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_IDE_PROC_FS=y

CONFIG_IDE_GENERIC=m
CONFIG_BLK_DEV_IDEDMA_SFF=y

CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_GENERIC=m
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AMD74XX=m
CONFIG_BLK_DEV_PIIX=m
CONFIG_BLK_DEV_VIA82CXXX=m
CONFIG_BLK_DEV_IDEDMA=y

CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m

CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_WAIT_SCAN=m

CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=15000
CONFIG_AIC79XX_DEBUG_ENABLE=y
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=m
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_ARCMSR=m
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_SAS=m
CONFIG_ATA=m
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=m
CONFIG_SATA_NV=m
CONFIG_SATA_VIA=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_VIA=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y


CONFIG_NETDEVICES=y
CONFIG_BONDING=m
CONFIG_TUN=m
CONFIG_PHYLIB=m

CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_NET_PCI=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_E100=m
CONFIG_8139TOO=m
CONFIG_8139TOO_PIO=y
CONFIG_NETDEV_1000=y
CONFIG_E1000=m
CONFIG_E1000E=m
CONFIG_IGB=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SKGE=m
CONFIG_TIGON3=m
CONFIG_BNX2=m



CONFIG_INPUT=y
CONFIG_INPUT_POLLDEV=m

CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=m

CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_KEYBOARD_SUNKBD=m
CONFIG_KEYBOARD_LKKBD=m
CONFIG_KEYBOARD_XTKBD=m
CONFIG_KEYBOARD_NEWTON=m

CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_LIBPS2=y

CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_DEVKMEM=y

CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=16
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_SHARE_IRQ=y

CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=16
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_RTC=y
CONFIG_DEVPORT=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_POWER_SUPPLY=y
CONFIG_THERMAL=y

CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y







CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y

CONFIG_USB_HID=m

CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y

CONFIG_USB_DEVICEFS=y
CONFIG_USB_DEVICE_CLASS=y
CONFIG_USB_SUSPEND=y

CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_OHCI_HCD=m
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
CONFIG_USB_SL811_HCD=m



CONFIG_USB_STORAGE=m




CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y

CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_PRINT_QUOTA_WARNING=y
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y

CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"

CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_CONFIGFS_FS=m


CONFIG_MSDOS_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-2"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m

CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0


CONFIG_GRKERNSEC=y
CONFIG_GRKERNSEC_CUSTOM=y

CONFIG_GRKERNSEC_BRUTE=y
CONFIG_GRKERNSEC_MODSTOP=y
CONFIG_GRKERNSEC_HIDESYM=y

CONFIG_GRKERNSEC_ACL_MAXTRIES=3
CONFIG_GRKERNSEC_ACL_TIMEOUT=30

full dmesg
Initializing cgroup subsys cpuset
Linux version 2.6.27.4-grsec-www (root@pendrive) (gcc version 4.1.2
20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Oct 28 23:32:15
CET 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
 BIOS-e820: 0000000000100000 - 00000000dfef8000 (usable)
 BIOS-e820: 00000000dfef8000 - 00000000dff07c00 (ACPI data)
 BIOS-e820: 00000000dff07c00 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
 BIOS-e820: 00000000fe000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
last_pfn = 0x120000 max_arch_pfn = 0x1000000
kernel direct mapping tables up to 38000000 @ 7000-c000
NX (Execute Disable) protection: active
RAMDISK: 37cf6000 - 37fef116
DMI 2.4 present.
ACPI: RSDP 000F2630, 0024 (r2 DELL  )
ACPI: XSDT 000F2694, 005C (r1 DELL   PE_SC3          1 DELL        1)
ACPI: FACP 000F2764, 00F4 (r3 DELL   PE_SC3          1 DELL        1)
ACPI: DSDT DFEF8000, 3636 (r1 DELL   PE_SC3          1 MSFT  2000001)
ACPI: FACS DFF07000, 0040
ACPI: APIC 000F2858, 0092 (r1 DELL   PE_SC3          1 DELL        1)
ACPI: SPCR 000F28EB, 0050 (r1 DELL   PE_SC3          1 DELL        1)
ACPI: HPET 000F293B, 0038 (r1 DELL   PE_SC3          1 DELL        1)
ACPI: MCFG 000F2973, 003C (r1 DELL   PE_SC3          1 DELL        1)
ACPI: SRAT 000FC4A4, 0110 (r1 DELL   PE_SC3          1 DELL        1)
ACPI: SSDT DFF07400, 0030 (r1 DELL   PE_SC3          1 DELL        1)
3712MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00009000 - 00010000
(9 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000200000 - 0000692890]    TEXT DATA BSS ==> [0000200000 - 0000692890]
  #4 [0037cf6000 - 0037fef116]          RAMDISK ==> [0037cf6000 - 0037fef116]
  #5 [0000693000 - 000069b000]    INIT_PG_TABLE ==> [0000693000 - 000069b000]
  #6 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
  #7 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
found SMP MP-table at [c00fe710] 000fe710
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x00120000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x00000100 -> 0x000dfef8
    0: 0x00100000 -> 0x00120000
On node 0 totalpages: 1048216
  DMA zone: 3968 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 811512 pages, LIFO batch:31
Detected use of extended apic ids on hypertransport bus
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-15
ACPI: IOAPIC (id[0x05] address[0xfec01000] gsi_base[32])
IOAPIC[1]: apic_id 5, version 17, address 0xfec01000, GSI 32-47
ACPI: IOAPIC (id[0x06] address[0xfec02000] gsi_base[64])
IOAPIC[2]: apic_id 6, version 17, address 0xfec02000, GSI 64-79
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 3 I/O APICs
ACPI: HPET id: 0x1166a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
mapped IOAPIC to ffff9000 (fec01000)
mapped IOAPIC to ffff8000 (fec02000)
Allocating PCI resources starting at e1000000 (gap: e0000000:10000000)
PERCPU: Allocating 16668 bytes of per cpu data
NR_CPUS: 8, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1039000
Kernel command line: root=/dev/sda1 ro
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2000.052 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 4146372k/4718592k available (1645k kernel code, 45656k
reserved, 221k data, 2032k init, 3275744k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4a000 - 0xfffff000   ( 724 kB)
    pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
    vmalloc : 0xf8800000 - 0xff9fe000   ( 113 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0204000 - 0xc0400000   (2032 kB)
      .data : 0xc0606000 - 0xc063d444   ( 221 kB)
      .text : 0xc0400000 - 0xc059b643   (1645 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4000.10 BogoMIPS (lpj=8000208)
Security Framework initialized
Mount-cache hash table entries: 512
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
using C1E aware idle routine
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4000.20 BogoMIPS (lpj=8000412)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 0
CPU1: AMD Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4000.20 BogoMIPS (lpj=8000417)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 2(2) -> Core 1
CPU2: AMD Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4000.20 BogoMIPS (lpj=8000412)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 3(2) -> Core 1
CPU3: AMD Dual-Core AMD Opteron(tm) Processor 2212 stepping 02
Brought up 4 CPUs
Total of 4 processors activated (16000.72 BogoMIPS).
------------[ cut here ]------------
WARNING: at kernel/softirq.c:136 ()
Modules linked in:
Pid: 16, comm: khelper Not tainted 2.6.27.4-grsec-www #1
 [<c041f2c2>]  [<c04d1279>]  [<c046ed8e>]  [<c048e78a>]  [<c0422fea>]
[<c0420a42>]  [<c0421d29>]  [<c042bb2f>]  [<c042bc2e>]  [<c042bb2f>]
[<c0403e67>]  ====
===================
---[ end trace 847e4d83bdf41d97 ]---
net_namespace: 596 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: Enabling HT MSI Mapping
PCI: 0000:00:02.1 reg 10 io port: [1f0, 1f7]
PCI: 0000:00:02.1 reg 14 io port: [3f4, 3f7]
PCI: 0000:00:02.1 reg 18 io port: [170, 177]
PCI: 0000:00:02.1 reg 1c io port: [374, 377]
PCI: 0000:00:02.1 reg 20 io port: [8c0, 8cf]
PCI: 0000:00:03.0 reg 10 32bit mmio: [ef9ed000, ef9edfff]
PCI: 0000:00:03.0 reg 14 io port: [c000, c0ff]
PCI: 0000:00:03.1 reg 10 32bit mmio: [ef9ee000, ef9eefff]
PCI: 0000:00:03.1 reg 14 io port: [c400, c4ff]
PCI: 0000:00:03.2 reg 10 32bit mmio: [ef9ef000, ef9effff]
PCI: 0000:00:03.2 reg 14 io port: [c800, c8ff]
pci 0000:00:03.2: supports D1
pci 0000:00:03.2: supports D2
pci 0000:00:03.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:03.2: PME# disabled
PCI: 0000:00:04.0 reg 10 32bit mmio: [e0000000, e7ffffff]
PCI: 0000:00:04.0 reg 14 io port: [cc00, ccff]
PCI: 0000:00:04.0 reg 18 32bit mmio: [ef9f0000, ef9fffff]
PCI: 0000:00:04.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:00:04.0: supports D1
pci 0000:00:04.0: supports D2
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:08.0: PME# supported from D0 D3hot D3cold
pci 0000:00:08.0: PME# disabled
pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
pci 0000:00:09.0: PME# disabled
pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
PCI: 0000:03:0e.0 reg 10 io port: [ecb0, ecb7]
PCI: 0000:03:0e.0 reg 14 io port: [eca0, eca3]
PCI: 0000:03:0e.0 reg 18 io port: [ecb8, ecbf]
PCI: 0000:03:0e.0 reg 1c io port: [eca4, eca7]
PCI: 0000:03:0e.0 reg 20 io port: [ece0, ecef]
PCI: 0000:03:0e.0 reg 24 32bit mmio: [efbfe000, efbfffff]
PCI: 0000:03:0e.0 reg 30 32bit mmio: [0, 1ffff]
PCI: bridge 0000:00:01.0 io port: [e000, efff]
PCI: bridge 0000:00:01.0 32bit mmio: [efa00000, efbfffff]
PCI: 0000:01:00.0 reg 10 64bit mmio: [efcf0000, efcfffff]
pci 0000:01:00.0: PME# supported from D3hot D3cold
pci 0000:01:00.0: PME# disabled
PCI: bridge 0000:00:08.0 32bit mmio: [efc00000, efcfffff]
PCI: 0000:02:00.0 reg 10 64bit mmio: [efdf0000, efdfffff]
pci 0000:02:00.0: PME# supported from D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:09.0 32bit mmio: [efd00000, efdfffff]
PCI: 0000:06:00.0 reg 10 io port: [dc00, dcff]
PCI: 0000:06:00.0 reg 14 64bit mmio: [effec000, effeffff]
PCI: 0000:06:00.0 reg 1c 64bit mmio: [efff0000, efffffff]
PCI: 0000:06:00.0 reg 30 32bit mmio: [efe00000, efefffff]
pci 0000:06:00.0: supports D1
pci 0000:06:00.0: supports D2
PCI: bridge 0000:00:0a.0 io port: [d000, dfff]
PCI: bridge 0000:00:0a.0 32bit mmio: [efe00000, efffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PXB_.PPBX._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXB4._PRT]
ACPI: PCI Interrupt Link [LK10] (IRQs 3 4 5 *6 7 10 11)
ACPI: PCI Interrupt Link [LK11] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LK12] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK13] (IRQs 3 4 5 *6 7 10 11)
ACPI: PCI Interrupt Link [LK14] (IRQs 3 4 *5 6 7 10 11)
ACPI: PCI Interrupt Link [LK15] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LK16] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK17] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK18] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK19] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1A] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1B] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1C] (IRQs 3 4 5 6 7 *10 11)
ACPI: PCI Interrupt Link [LK1D] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1E] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK1F] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK20] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK21] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK22] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK23] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK24] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK25] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK26] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK27] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK28] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK29] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2A] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2B] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2C] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2D] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2E] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK2F] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LK01] (IRQs 3 4 5 6 7 10 *11 12 14)
ACPI: PCI Interrupt Link [LK07] (IRQs 3 4 5 *6 7 10 11 12 14)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: parse allocated resources
pnp 00:00:   add io  0xcf8-0xcff flags 0x1
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: parse allocated resources
pnp 00:01:   add io  0x80-0x9f flags 0x1
pnp 00:01:   add io  0x0-0x1f flags 0x1
pnp 00:01:   add io  0xc0-0xdf flags 0x1
pnp 00:01:   add dma 4 flags 0x2
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: parse allocated resources
pnp 00:02:   add io  0xf0-0xff flags 0x1
pnp 00:02:   add irq 13 flags 0x1
pnp 00:02: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:03: parse allocated resources
pnp 00:03:   add io  0x61-0x61 flags 0x1
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: parse allocated resources
pnp 00:04:   add io  0x70-0x7f flags 0x1
pnp 00:04:   add irq 8 flags 0x1
pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:05: parse allocated resources
pnp 00:05:   add io  0x3f8-0x3ff flags 0x1
pnp 00:05:   add irq 4 flags 0x1
pnp 00:05: parse resource options
pnp 00:05:   dependent set 0 (acceptable) io  min 0x3f8 max 0x3f8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 0 (acceptable) irq 4 flags 0x1
pnp 00:05:   dependent set 1 (acceptable) io  min 0x3e8 max 0x3e8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 1 (acceptable) irq 4 flags 0x1
pnp 00:05:   dependent set 2 (acceptable) io  min 0x3f8 max 0x3f8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 2 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 3 (acceptable) io  min 0x2f8 max 0x2f8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 3 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 4 (acceptable) io  min 0x220 max 0x220
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 4 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 5 (acceptable) io  min 0x228 max 0x228
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 5 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 6 (acceptable) io  min 0x238 max 0x238
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 6 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 7 (acceptable) io  min 0x2e8 max 0x2e8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 7 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 8 (acceptable) io  min 0x338 max 0x338
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 8 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05:   dependent set 9 (acceptable) io  min 0x3e8 max 0x3e8
align 8 size 8 flags 0x1
pnp 00:05:   dependent set 9 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:06: parse allocated resources
pnp 00:06:   add io  0x2f8-0x2ff flags 0x1
pnp 00:06:   add irq 3 flags 0x1
pnp 00:06: parse resource options
pnp 00:06:   dependent set 0 (acceptable) io  min 0x2f8 max 0x2f8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 0 (acceptable) irq 3 flags 0x1
pnp 00:06:   dependent set 1 (acceptable) io  min 0x2e8 max 0x2e8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 1 (acceptable) irq 3 flags 0x1
pnp 00:06:   dependent set 2 (acceptable) io  min 0x3f8 max 0x3f8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 2 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 3 (acceptable) io  min 0x2f8 max 0x2f8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 3 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 4 (acceptable) io  min 0x220 max 0x220
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 4 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 5 (acceptable) io  min 0x228 max 0x228
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 5 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 6 (acceptable) io  min 0x238 max 0x238
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 6 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 7 (acceptable) io  min 0x2e8 max 0x2e8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 7 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 8 (acceptable) io  min 0x338 max 0x338
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 8 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06:   dependent set 9 (acceptable) io  min 0x3e8 max 0x3e8
align 8 size 8 flags 0x1
pnp 00:06:   dependent set 9 (acceptable) irq 3 4 5 6 7 12 flags 0x1
pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
pnp 00:07: parse allocated resources
pnp 00:07:   add io  0x800-0x87f flags 0x1
pnp 00:07:   add io  0x880-0x89f flags 0x1
pnp 00:07:   add io  0xcd6-0xcd7 flags 0x1
pnp 00:07:   add io  0xe0-0xe3 flags 0x1
pnp 00:07:   add io  0xe4-0xe7 flags 0x1
pnp 00:07:   add io  0x40b-0x40b flags 0x1
pnp 00:07:   add io  0x4d6-0x4d6 flags 0x1
pnp 00:07:   add io  0x8d0-0x8df flags 0x1
pnp 00:07:   add io  0x8a0-0x8bf flags 0x1
pnp 00:07:   add io  0x8e0-0x8e3 flags 0x1
pnp 00:07:   add io  0x8e4-0x8e7 flags 0x1
pnp 00:07:   add io  0xc00-0xca7 flags 0x1
pnp 00:07:   add io  0xca0-0xca7 flags 0x1
pnp 00:07:   add io  0xca9-0xcab flags 0x1
pnp 00:07:   add io  0xcad-0xcaf flags 0x1
pnp 00:07:   add io  0xf50-0xf58 flags 0x1
pnp 00:07:   add io  0x60-0x60 flags 0x1
pnp 00:07:   add io  0x64-0x64 flags 0x1
pnp 00:07: PNP0c01: calling <7>pnp 00:07: Plug and Play ACPI device,
IDs PNP0c01 (active)
pnp 00:08: parse allocated resources
pnp 00:08:   add io  0xca8-0xca8 flags 0x1
pnp 00:08:   add io  0xcac-0xcac flags 0x1
pnp 00:08: PNP0c01: calling <7>pnp 00:08: Plug and Play ACPI device,
IDs IPI0001 PNP0c01 (active)
pnp 00:09: parse allocated resources
pnp 00:09:   add mem 0xf0000000-0xf1ffffff flags 0x1
pnp 00:09: PNP0c02: calling <7>pnp 00:09: Plug and Play ACPI device,
IDs PNP0c02 (active)
pnp 00:0a: parse allocated resources
pnp 00:0a:   add mem 0xfed00000-0xfed003ff flags 0x1
pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
Switched to NOHz mode on CPU #0
pnp: the driver 'system' has been registered
system 00:07: ioport range 0x800-0x87f has been reserved
system 00:07: ioport range 0x880-0x89f has been reserved
system 00:07: ioport range 0xcd6-0xcd7 has been reserved
system 00:07: ioport range 0x40b-0x40b has been reserved
system 00:07: ioport range 0x4d6-0x4d6 has been reserved
system 00:07: ioport range 0x8d0-0x8df has been reserved
system 00:07: ioport range 0x8a0-0x8bf has been reserved
system 00:07: ioport range 0x8e0-0x8e3 has been reserved
Switched to NOHz mode on CPU #3
Switched to NOHz mode on CPU #2
Switched to NOHz mode on CPU #1
system 00:07: ioport range 0x8e4-0x8e7 has been reserved
system 00:07: ioport range 0xc00-0xca7 has been reserved
system 00:07: ioport range 0xca0-0xca7 has been reserved
system 00:07: ioport range 0xca9-0xcab has been reserved
system 00:07: ioport range 0xcad-0xcaf has been reserved
system 00:07: ioport range 0xf50-0xf58 has been reserved
system 00:07: driver attached
system 00:08: ioport range 0xca8-0xca8 has been reserved
system 00:08: ioport range 0xcac-0xcac has been reserved
system 00:08: driver attached
system 00:09: iomem range 0xf0000000-0xf1ffffff could not be reserved
system 00:09: driver attached
pci 0000:03:0d.0: PCI bridge, secondary bus 0000:04
pci 0000:03:0d.0:   IO window: disabled
pci 0000:03:0d.0:   MEM window: disabled
pci 0000:03:0d.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI bridge, secondary bus 0000:03
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xefa00000-0xefbfffff
pci 0000:00:01.0:   PREFETCH window: 0x000000e8000000-0x000000e80fffff
pci 0000:00:07.0: PCI bridge, secondary bus 0000:05
pci 0000:00:07.0:   IO window: disabled
pci 0000:00:07.0:   MEM window: disabled
pci 0000:00:07.0:   PREFETCH window: disabled
pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
pci 0000:00:08.0:   IO window: disabled
pci 0000:00:08.0:   MEM window: 0xefc00000-0xefcfffff
pci 0000:00:08.0:   PREFETCH window: disabled
pci 0000:00:09.0: PCI bridge, secondary bus 0000:02
pci 0000:00:09.0:   IO window: disabled
pci 0000:00:09.0:   MEM window: 0xefd00000-0xefdfffff
pci 0000:00:09.0:   PREFETCH window: disabled
pci 0000:00:0a.0: PCI bridge, secondary bus 0000:06
pci 0000:00:0a.0:   IO window: 0xd000-0xdfff
pci 0000:00:0a.0:   MEM window: 0xefe00000-0xefffffff
pci 0000:00:0a.0:   PREFETCH window: disabled
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:07
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:07.0: PCI INT A -> GSI 32 (level, low) -> IRQ 32
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:08.0: PCI INT A -> GSI 33 (level, low) -> IRQ 33
pci 0000:00:08.0: setting latency timer to 64
pci 0000:00:09.0: PCI INT A -> GSI 37 (level, low) -> IRQ 37
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0a.0: PCI INT A -> GSI 35 (level, low) -> IRQ 35
pci 0000:00:0a.0: setting latency timer to 64
pci 0000:00:0b.0: PCI INT A -> GSI 36 (level, low) -> IRQ 36
pci 0000:00:0b.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 03 index 0 io port: [e000, efff]
bus: 03 index 1 mmio: [efa00000, efbfffff]
bus: 03 index 2 mmio: [e8000000, e80fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [0, 0]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [0, 0]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 mmio: [0, 0]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [efc00000, efcfffff]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [efd00000, efdfffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [d000, dfff]
bus: 06 index 1 mmio: [efe00000, efffffff]
bus: 06 index 2 mmio: [0, 0]
bus: 06 index 3 mmio: [0, 0]
bus: 07 index 0 mmio: [0, 0]
bus: 07 index 1 mmio: [0, 0]
bus: 07 index 2 mmio: [0, 0]
bus: 07 index 3 mmio: [0, 0]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
Unpacking initramfs... done


any advice what do try next ? Disable Tickless system, get rid of grsecurity ?

-- 
Lazy
