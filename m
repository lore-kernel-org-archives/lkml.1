Return-Path: <linux-kernel-owner+w=401wt.eu-S1761365AbYBAXAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365AbYBAXAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYBAXAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:00:23 -0500
Received: from dxv01.wellsfargo.com ([151.151.5.42]:7569 "EHLO
	dxv01.wellsfargo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYBAXAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:00:19 -0500
X-Greylist: delayed 3399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2008 18:00:19 EST
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
Subject: ARM fails compile in vgacon.c 2.6.24
Date: Fri, 1 Feb 2008 16:03:31 -0600
Message-ID: <1E7A4807A136DF45AD33DB341D93C3BD428099@msgswbmnmsp46.wellsfargo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: ARM fails compile in vgacon.c 2.6.24
Thread-Index: AchlHd6Y225SYwzeT6yPQaj9lLaPhwAAB8HQ
From: <Greg.Chandler@wellsfargo.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Feb 2008 22:03:30.0900 (UTC) FILETIME=[47DAB940:01C8651E]
X-WFMX: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Did someone undo a previous patch for this on ARM, it used to work.?


  CHK     include/linux/version.h
make[1]: `include/asm-arm/mach-types.h' is up to date.
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
<stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
<stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
<stdin>:1321:2: warning: #warning syscall pselect6 not implemented
<stdin>:1325:2: warning: #warning syscall ppoll not implemented
<stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
  CHK     include/linux/compile.h
  CC      drivers/video/console/vgacon.o
In file included from drivers/video/console/vgacon.c:51:
include/video/vga.h: In function 'vga_io_r':
include/video/vga.h:226: warning: cast to pointer from integer of
different size
include/video/vga.h: In function 'vga_io_w':
include/video/vga.h:231: warning: cast to pointer from integer of
different size
include/video/vga.h: In function 'vga_io_w_fast':
include/video/vga.h:237: warning: cast to pointer from integer of
different size
drivers/video/console/vgacon.c: In function 'write_vga':
drivers/video/console/vgacon.c:149: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:150: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vgacon_startup':
drivers/video/console/vgacon.c:494: error: 'PCIMEM_BASE' undeclared
(first use in this function)
drivers/video/console/vgacon.c:494: error: (Each undeclared identifier
is reported only once
drivers/video/console/vgacon.c:494: error: for each function it appears
in.)
drivers/video/console/vgacon.c: In function 'vgacon_set_cursor_size':
drivers/video/console/vgacon.c:652: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:653: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:654: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:655: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:664: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:665: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:666: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:667: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vgacon_doresize':
drivers/video/console/vgacon.c:748: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:749: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:754: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:755: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:763: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:764: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:772: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:773: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:774: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:775: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:778: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:779: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:780: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:781: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:784: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:785: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:786: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:787: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:790: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:791: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vga_vesa_blank':
drivers/video/console/vgacon.c:879: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:883: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:884: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:885: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:886: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:887: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:888: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:889: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:890: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:891: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:892: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:893: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:894: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:895: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:896: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:897: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:898: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:917: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:918: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:919: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:920: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:921: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:922: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:931: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:932: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:933: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:934: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:939: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vga_vesa_unblank':
drivers/video/console/vgacon.c:949: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:950: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:951: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:952: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:953: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:954: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:955: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:956: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:957: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:958: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:959: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:960: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:961: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:962: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:963: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:964: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:970: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vgacon_do_font_op':
drivers/video/console/vgacon.c:1052: error: 'PCIMEM_BASE' undeclared
(first use in this function)
drivers/video/console/vgacon.c:1167: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1172: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c: In function 'vgacon_adjust_height':
drivers/video/console/vgacon.c:1202: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1203: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1204: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1205: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1214: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1215: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1216: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1217: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1218: warning: cast to pointer from
integer of different size
drivers/video/console/vgacon.c:1219: warning: cast to pointer from
integer of different size
make[3]: *** [drivers/video/console/vgacon.o] Error 1
make[2]: *** [drivers/video/console] Error 2
make[1]: *** [drivers/video] Error 2
make: *** [drivers] Error 2



#
# Automatically generated make config: don't edit # Linux kernel
version: 2.6.24 # Fri Feb  1 15:54:08 2008 # CONFIG_ARM=y
CONFIG_SYS_SUPPORTS_APM_EMULATION=y
CONFIG_GENERIC_GPIO=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_MMU=y
# CONFIG_NO_IOPORT is not set
CONFIG_GENERIC_HARDIRQS=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_HARDIRQS_SW_RESEND=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ZONE_DMA=y
CONFIG_ARCH_MTD_XIP=y
CONFIG_VECTORS_BASE=0xffff0000
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_SWAP=y
# CONFIG_SYSVIPC is not set
# CONFIG_POSIX_MQUEUE is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=14
# CONFIG_CGROUPS is not set
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_FAIR_USER_SCHED=y
# CONFIG_FAIR_CGROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
# CONFIG_BLK_DEV_BSG is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"

#
# System Type
#
# CONFIG_ARCH_AAEC2000 is not set
# CONFIG_ARCH_INTEGRATOR is not set
# CONFIG_ARCH_REALVIEW is not set
# CONFIG_ARCH_VERSATILE is not set
# CONFIG_ARCH_AT91 is not set
# CONFIG_ARCH_CLPS7500 is not set
# CONFIG_ARCH_CLPS711X is not set
# CONFIG_ARCH_CO285 is not set
# CONFIG_ARCH_EBSA110 is not set
# CONFIG_ARCH_EP93XX is not set
# CONFIG_ARCH_FOOTBRIDGE is not set
# CONFIG_ARCH_NETX is not set
# CONFIG_ARCH_H720X is not set
# CONFIG_ARCH_IMX is not set
# CONFIG_ARCH_IOP13XX is not set
# CONFIG_ARCH_IOP32X is not set
# CONFIG_ARCH_IOP33X is not set
# CONFIG_ARCH_IXP23XX is not set
# CONFIG_ARCH_IXP2000 is not set
# CONFIG_ARCH_IXP4XX is not set
# CONFIG_ARCH_L7200 is not set
# CONFIG_ARCH_KS8695 is not set
# CONFIG_ARCH_NS9XXX is not set
# CONFIG_ARCH_MXC is not set
# CONFIG_ARCH_PNX4008 is not set
CONFIG_ARCH_PXA=y
# CONFIG_ARCH_RPC is not set
# CONFIG_ARCH_SA1100 is not set
# CONFIG_ARCH_S3C2410 is not set
# CONFIG_ARCH_SHARK is not set
# CONFIG_ARCH_LH7A40X is not set
# CONFIG_ARCH_DAVINCI is not set
# CONFIG_ARCH_OMAP is not set
CONFIG_DMABOUNCE=y

#
# Intel PXA2xx/PXA3xx Implementations
#
CONFIG_ARCH_LUBBOCK=y
# CONFIG_MACH_LOGICPD_PXA270 is not set
# CONFIG_MACH_MAINSTONE is not set
# CONFIG_ARCH_PXA_IDP is not set
# CONFIG_PXA_SHARPSL is not set
# CONFIG_MACH_TRIZEPS4 is not set
# CONFIG_MACH_EM_X270 is not set
# CONFIG_MACH_ZYLONITE is not set
# CONFIG_MACH_ARMCORE is not set
CONFIG_PXA25x=y

#
# Boot options
#

#
# Power management
#

#
# Processor Type
#
CONFIG_CPU_32=y
CONFIG_CPU_XSCALE=y
CONFIG_CPU_32v5=y
CONFIG_CPU_ABRT_EV5T=y
CONFIG_CPU_CACHE_VIVT=y
CONFIG_CPU_TLB_V4WBI=y
CONFIG_CPU_CP15=y
CONFIG_CPU_CP15_MMU=y

#
# Processor Features
#
CONFIG_ARM_THUMB=y
# CONFIG_CPU_DCACHE_DISABLE is not set
# CONFIG_OUTER_CACHE is not set
CONFIG_IWMMXT=y
CONFIG_XSCALE_PMU=y
CONFIG_SA1111=y
CONFIG_FORCE_MAX_ZONEORDER=9

#
# Bus support
#
# CONFIG_PCI_SYSCALL is not set
# CONFIG_ARCH_SUPPORTS_MSI is not set
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y

#
# PC-card bridges
#
CONFIG_PCMCIA_PXA2XX=y

#
# Kernel Features
#
# CONFIG_TICK_ONESHOT is not set
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_PREEMPT=y
CONFIG_HZ=100
# CONFIG_AEABI is not set
# CONFIG_ARCH_DISCONTIGMEM_ENABLE is not set
CONFIG_SELECT_MEMORY_MODEL=y CONFIG_FLATMEM_MANUAL=y #
CONFIG_DISCONTIGMEM_MANUAL is not set # CONFIG_SPARSEMEM_MANUAL is not
set CONFIG_FLATMEM=y CONFIG_FLAT_NODE_MEM_MAP=y #
CONFIG_SPARSEMEM_STATIC is not set # CONFIG_SPARSEMEM_VMEMMAP_ENABLE is
not set
CONFIG_SPLIT_PTLOCK_CPUS=4096
# CONFIG_RESOURCES_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_LEDS is not set
CONFIG_ALIGNMENT_TRAP=y

#
# Boot options
#
CONFIG_ZBOOT_ROM_TEXT=0
CONFIG_ZBOOT_ROM_BSS=0
CONFIG_CMDLINE=""
# CONFIG_XIP_KERNEL is not set
# CONFIG_KEXEC is not set

#
# Floating point emulation
#

#
# At least one emulation must be selected # CONFIG_FPE_NWFPE=y
CONFIG_FPE_NWFPE_XP=y # CONFIG_FPE_FASTFPE is not set

#
# Userspace binary formats
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
# CONFIG_ARTHUR is not set

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_LEGACY=y
# CONFIG_PM_DEBUG is not set
CONFIG_SUSPEND_UP_POSSIBLE=y
# CONFIG_SUSPEND is not set
CONFIG_APM_EMULATION=y

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
# CONFIG_PACKET_MMAP is not set
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
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set #
CONFIG_INET_XFRM_MODE_TUNNEL is not set # CONFIG_INET_XFRM_MODE_BEET is
not set # CONFIG_INET_LRO is not set # CONFIG_INET_DIAG is not set #
CONFIG_TCP_CONG_ADVANCED is not set CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETFILTER is not set
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
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
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
CONFIG_IRCOMM=y
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set # CONFIG_IRDA_FAST_RR is not
set # CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#
# CONFIG_KINGSUN_DONGLE is not set
# CONFIG_KSDAZZLE_DONGLE is not set
# CONFIG_KS959_DONGLE is not set

#
# Old SIR device drivers
#
# CONFIG_IRPORT_SIR is not set

#
# Old Serial dongle support
#

#
# FIR device drivers
#
# CONFIG_USB_IRDA is not set
# CONFIG_SIGMATEL_FIR is not set
CONFIG_PXA_FICP=y
# CONFIG_MCS_FIR is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=y
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=y
CONFIG_MAC80211_RCSIMPLE=y
# CONFIG_MAC80211_DEBUG is not set
CONFIG_IEEE80211=y
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
# CONFIG_IEEE80211_SOFTMAC is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
CONFIG_BLK_DEV_NBD=y
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_MISC_DEVICES=y
# CONFIG_EEPROM_93CX6 is not set
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

#
# Please see Documentation/ide.txt for help/info on IDE drives # #
CONFIG_BLK_DEV_IDE_SATA is not set CONFIG_BLK_DEV_IDEDISK=y #
CONFIG_IDEDISK_MULTI_MODE is not set CONFIG_BLK_DEV_IDECS=y
CONFIG_BLK_DEV_IDECD=y # CONFIG_BLK_DEV_IDETAPE is not set #
CONFIG_BLK_DEV_IDEFLOPPY is not set # CONFIG_IDE_TASK_IOCTL is not set
CONFIG_IDE_PROC_FS=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_PLATFORM is not set
# CONFIG_IDE_ARM is not set
# CONFIG_BLK_DEV_IDEDMA is not set
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
# CONFIG_SCSI is not set
# CONFIG_SCSI_DMA is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set # CONFIG_DUMMY is not set #
CONFIG_BONDING is not set # CONFIG_MACVLAN is not set # CONFIG_EQUALIZER
is not set # CONFIG_TUN is not set # CONFIG_VETH is not set #
CONFIG_NET_ETHERNET is not set # CONFIG_NETDEV_1000 is not set #
CONFIG_NETDEV_10000 is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=y
CONFIG_PCMCIA_HERMES=y
CONFIG_PCMCIA_SPECTRUM=y
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
# CONFIG_PCMCIA_WL3501 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_RTL8187 is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_USB is not set
CONFIG_HOSTAP=y
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_CS is not set
CONFIG_B43=y
CONFIG_B43_PCMCIA=y
# CONFIG_B43_DEBUG is not set
CONFIG_B43_DMA=y
CONFIG_B43_PIO=y
CONFIG_B43_DMA_AND_PIO_MODE=y
# CONFIG_B43_DMA_MODE is not set
# CONFIG_B43_PIO_MODE is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
CONFIG_NET_PCMCIA=y
# CONFIG_PCMCIA_3C589 is not set
# CONFIG_PCMCIA_3C574 is not set
# CONFIG_PCMCIA_FMVJ18X is not set
# CONFIG_PCMCIA_PCNET is not set
# CONFIG_PCMCIA_NMCLAN is not set
# CONFIG_PCMCIA_SMC91C92 is not set
# CONFIG_PCMCIA_XIRC2PS is not set
# CONFIG_PCMCIA_AXNET is not set
# CONFIG_WAN is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_SHAPER is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
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
# CONFIG_KEYBOARD_GPIO is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_GPIO is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=y
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set # CONFIG_TOUCHSCREEN_TOUCHRIGHT
is not set # CONFIG_TOUCHSCREEN_TOUCHWIN is not set #
CONFIG_TOUCHSCREEN_UCB1400 is not set # CONFIG_TOUCHSCREEN_USB_COMPOSITE
is not set # CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_SA1111 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set # CONFIG_SERIAL_NONSTANDARD is
not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set

#
# Non-8250 serial port support
#
CONFIG_SERIAL_PXA=y
CONFIG_SERIAL_PXA_CONSOLE=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=y
CONFIG_NVRAM=y
# CONFIG_R3964 is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
# CONFIG_RAW_DRIVER is not set
# CONFIG_TCG_TPM is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
# CONFIG_I2C_ALGOPCF is not set
# CONFIG_I2C_ALGOPCA is not set

#
# I2C Hardware Bus support
#
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_SLAVE=y
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_SENSORS_DS1337 is not set
# CONFIG_SENSORS_DS1374 is not set
# CONFIG_DS1682 is not set
# CONFIG_SENSORS_EEPROM is not set
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_SENSORS_PCA9539 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
# CONFIG_POWER_SUPPLY is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
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
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_HWMON_DEBUG_CHIP is not set
# CONFIG_WATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
# CONFIG_VIDEO_DEV is not set
# CONFIG_DVB_CORE is not set
# CONFIG_DAB is not set

#
# Graphics support
#
# CONFIG_VGASTATE is not set
# CONFIG_VIDEO_OUTPUT_CONTROL is not set # CONFIG_FB is not set #
CONFIG_BACKLIGHT_LCD_SUPPORT is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set CONFIG_DUMMY_CONSOLE=y

#
# Sound
#
CONFIG_SOUND=y

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
# CONFIG_SND_SEQUENCER is not set
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_DYNAMIC_MINORS is not set
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# ALSA ARM devices
#
CONFIG_SND_PXA2XX_PCM=y
CONFIG_SND_PXA2XX_AC97=y

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# PCMCIA devices
#
# CONFIG_SND_VXPOCKET is not set
# CONFIG_SND_PDAUDIOCF is not set

#
# System on Chip audio support
#
CONFIG_SND_SOC=y
CONFIG_SND_PXA2XX_SOC=y

#
# SoC Audio support for SuperH
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_USB_HIDINPUT_POWERBOOK is not set # CONFIG_HID_FF is not set #
CONFIG_USB_HIDDEV is not set CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y CONFIG_USB_ARCH_HAS_OHCI=y #
CONFIG_USB_ARCH_HAS_EHCI is not set CONFIG_USB=y # CONFIG_USB_DEBUG is
not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
CONFIG_USB_DEVICE_CLASS=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_SUSPEND is not set
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_OHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information # #
CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
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
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set

#
# USB DSL modem support
#

#
# USB Gadget Support
#
# CONFIG_USB_GADGET is not set
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
# CONFIG_SDIO_UART is not set

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_PXA=y
# CONFIG_NEW_LEDS is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set # CONFIG_RTC_DRV_TEST is not
set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_SA1100=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_INOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_DNOTIFY=y
# CONFIG_AUTOFS_FS is not set
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
# CONFIG_MSDOS_FS is not set
# CONFIG_VFAT_FS is not set
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
# CONFIG_TMPFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
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
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFS_DIRECTIO=y
CONFIG_NFSD=y
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_TCP=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_SUNRPC_BIND34=y
CONFIG_RPCSEC_GSS_KRB5=y
# CONFIG_RPCSEC_GSS_SPKM3 is not set
# CONFIG_SMB_FS is not set
# CONFIG_CIFS is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_NLS is not set
# CONFIG_DLM is not set
CONFIG_INSTRUMENTATION=y
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set

#
# Kernel hacking
#
# CONFIG_PRINTK_TIME is not set
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
# CONFIG_MAGIC_SYSRQ is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_DEBUG_FS is not set
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_SLUB_DEBUG_ON is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_FRAME_POINTER=y
# CONFIG_SAMPLES is not set
# CONFIG_DEBUG_USER is not set

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y CONFIG_CRYPTO_ABLKCIPHER=y CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_BLKCIPHER=y CONFIG_CRYPTO_HASH=y CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=y CONFIG_CRYPTO_XCBC=y CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_MD4=y CONFIG_CRYPTO_MD5=y CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y CONFIG_CRYPTO_SHA512=y CONFIG_CRYPTO_WP512=y
CONFIG_CRYPTO_TGR192=y CONFIG_CRYPTO_GF128MUL=y CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_CBC=y CONFIG_CRYPTO_PCBC=y CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_XTS=y CONFIG_CRYPTO_CRYPTD=y CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y CONFIG_CRYPTO_BLOWFISH=y CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y CONFIG_CRYPTO_SERPENT=y
CONFIG_CRYPTO_AES=y CONFIG_CRYPTO_CAST5=y CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_TEA=y CONFIG_CRYPTO_ARC4=y CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_ANUBIS=y CONFIG_CRYPTO_SEED=y CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_MICHAEL_MIC=y CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CAMELLIA=y # CONFIG_CRYPTO_TEST is not set
CONFIG_CRYPTO_AUTHENC=y # CONFIG_CRYPTO_HW is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
