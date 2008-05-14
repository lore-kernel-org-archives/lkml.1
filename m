Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYENF7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYENF7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYENF6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:58:54 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:11798 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbYENF6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:58:50 -0400
X-RZG-CLASS-ID: mo07
X-RZG-AUTH: kN+8IwndbR6Uv2ejxj19QCPuh8a6M5fIB5EQYDxa6UzG74Ew5HDhXeKIQES+L7Y=
Message-ID: <482A7F92.8030504@au-79.de>
Date: Wed, 14 May 2008 07:58:42 +0200
From: Robert Goldner <robert@au-79.de>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with mainboard INTEL D201GLY2A, pci devices only available
 with acpi=noirq
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I use a INTEL D201GLY2A mainboard, and after serveral trys PCI devices 
were only useable (not visable) with the boot-parameter acpi=noirq (or 
noacpi). I tryed several kernel-versions (stated with 2.6.22), and no 
sucess without his parameter.
Without acpi=noirq all pci devices are deteced well, but if you want to 
use them, there is no response.

So, now some (as I thnik) relevant informations:
lspci
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 662 Host (rev 01)
00:01.0 PCI bridge: Silicon Integrated Systems [SiS] SiS AGP Port
00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS964 [MuTIOL
00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev
00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS]
00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.1
00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0
00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI
00:05.0 IDE interface: Silicon Integrated Systems [SiS] SATA (rev 01)
00:06.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213
00:1f.0 PCI bridge: Silicon Integrated Systems [SiS] PCI-to-PCI bridge
01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS]


.config (I did not attach all information about drivers, because I don´t 
think that this is relevant)

CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_AUDIT=y
CONFIG_IKCONFIG=y
CONFIG_LOG_BUF_SHIFT=14
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_USER_SCHED=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_NAMESPACES=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_SYSCTL=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_COMPAT_BRK=y
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
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_CLASSIC_RCU=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_X86_PC=y
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
CONFIG_MPENTIUM4=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_P6_NOP=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=6
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_PREEMPT_NONE=y
CONFIG_VM86=y
CONFIG_X86_MSR=y
CONFIG_NOHIGHMEM=y
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MTRR=y
CONFIG_EFI=y
CONFIG_HZ_100=y
CONFIG_HZ=100
CONFIG_SCHED_HRTICK=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_PM=y
CONFIG_PM_LEGACY=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_PCI=y
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCI_LEGACY=y
CONFIG_ISA_DMA_API=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_NET_KEY=y
CONFIG_INET=y
CONFIG_IP_FIB_HASH=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_CFG80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_IEEE80211=y
CONFIG_IEEE80211_CRYPT_WEP=y
CONFIG_IEEE80211_CRYPT_CCMP=y
CONFIG_IEEE80211_CRYPT_TKIP=y
CONFIG_IEEE80211_SOFTMAC=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
CONFIG_PNP=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_HAVE_IDE=y
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y
CONFIG_BLK_DEV_IDEDISK=y
CONFIG_BLK_DEV_IDECD=y
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
CONFIG_BLK_DEV_IDEACPI=y
CONFIG_IDE_PROC_FS=y
CONFIG_IDE_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_SFF=y
CONFIG_BLK_DEV_IDEPCI=y
CONFIG_BLK_DEV_GENERIC=y
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_SIS5513=y
CONFIG_BLK_DEV_IDEDMA=y
CONFIG_IDE_ARCH_OBSOLETE_INIT=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_SG=y
CONFIG_SCSI_WAIT_SCAN=m
CONFIG_ATA=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIS=y
CONFIG_PATA_SIS=y
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
CONFIG_NETDEVICES=y
CONFIG_TUN=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_NET_PCI=y
CONFIG_SIS900=y
....


dmesg without! acpi=noirq:
Linux version 2.6.25-berta (root@hepto) (gcc version 4.2.3 (Debian 
4.2.3-2)) #21 Tue May 13 20:10:08 CEST 2008
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003d135000 (usable)
  BIOS-e820: 000000003d135000 - 000000003d236000 (ACPI NVS)
  BIOS-e820: 000000003d236000 - 000000003ddf2000 (usable)
  BIOS-e820: 000000003ddf2000 - 000000003ddf4000 (reserved)
  BIOS-e820: 000000003ddf4000 - 000000003de79000 (usable)
  BIOS-e820: 000000003de79000 - 000000003def7000 (ACPI NVS)
  BIOS-e820: 000000003def7000 - 000000003def8000 (usable)
  BIOS-e820: 000000003def8000 - 000000003deff000 (ACPI data)
  BIOS-e820: 000000003deff000 - 000000003df00000 (usable)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   229376
On node 0 totalpages: 229376
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3DEFE038, 002C (r1 INTEL  DG965CO        7A       1000013)
ACPI: FACP 3DEFD000, 0074 (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: DSDT 3DEF9000, 30F6 (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: FACS 3DEBC000, 0040
ACPI: APIC 3DEF8000, 006C (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 40000000 (gap: 3df00000:c2080000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227584
Kernel command line: BOOT_IMAGE=2.6.25-berta root=301 lang=de
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1200.099 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 904240k/917504k available (3212k kernel code, 12776k reserved, 
1149k data, 224k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
     vmalloc : 0xf8800000 - 0xffff4000   ( 119 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0546000 - 0xc057e000   ( 224 kB)
       .data : 0xc0423328 - 0xc0542838   (1149 kB)
       .text : 0xc0100000 - 0xc0423328   (3212 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 2401.29 BogoMIPS 
(lpj=12006493)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Celeron(R) CPU          220  @ 1.20GHz stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0c00)
net_namespace: 440 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
system 00:08: ioport range 0x800-0x8fe has been reserved
system 00:08: ioport range 0x8ff-0x8ff has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x295-0x29e has been reserved
system 00:08: ioport range 0x2e8-0x2ef has been reserved
system 00:08: ioport range 0x481-0x48f has been reserved
system 00:09: iomem range 0x0-0x9ffff could not be reserved
system 00:09: iomem range 0xec000-0xfffff could not be reserved
system 00:09: iomem range 0x100000-0x3dffffff could not be reserved
system 00:09: iomem range 0xe0000000-0xefffffff has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: 1000-1fff
   MEM window: 0x4a000000-0x4a0fffff
   PREFETCH window: 0x0000000040000000-0x0000000047ffffff
PCI: Bridge: 0000:00:1f.0
   IO window: disabled.
   MEM window: 0x3e000000-0x3e0fffff
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:1f.0 (0000 -> 0002)
PCI: Setting latency timer of device 0000:00:1f.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
type=2000 audit(1210710476.299:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:1f.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1f.0:pcie00]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart: Detected SiS chipset - id:1634
agpgart: AGP aperture is 32M @ 0x48000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 10 (level, 
low) -> IRQ 10
PCI: Setting latency timer of device 0000:01:00.0 to 64
[drm] Initialized sis 1.3.0 20070626 on minor 0
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
loop: module loaded
sis900.c: v1.08.10 Apr. 2 2006
ACPI: PCI Interrupt 0000:00:04.0[A] -> GSI 19 (level, low) -> IRQ 19
0000:00:04.0: SiS 900 on Foxconn 661 7MI transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x2000, IRQ 19, 00:1c:c0:08:08:de
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ath_rate_sample: 1.2 (0.9.4)
ath_pci: 0.9.4
ACPI: Unable to derive IRQ for device 0000:00:06.0
ACPI: PCI Interrupt 0000:00:06.0[A]: no GSI - using IRQ 10
Switched to high resolution mode on CPU 0
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 
24Mbps 36Mbps 48Mbps 54Mbps
wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
wifi0: mac 7.9 phy 4.5 radio 5.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
failed to automatically load module: wlan_scan_sta; errno: -2
unable to load wlan_scan_sta
wifi0: Atheros 5212: mem=0x4a100000, irq=10
ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
wlan: 0.9.4
wlan: mac acl policy registered
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller (0x1039:0x5513 rev 0x01) at  PCI slot 0000:00:02.5
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
     ide0: BM-DMA at 0x2310-0x2317, BIOS settings: hda:PIO, hdb:PIO
     ide1: BM-DMA at 0x2318-0x231f, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: TRANSCEND, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 7952112 sectors (4071 MB) w/2KiB Cache, CHS=7889/16/63
  hda: hda1
Driver 'sd' needs updating - please use bus_type methods
sata_sis 0000:00:05.0: version 1.0
ACPI: PCI Interrupt 0000:00:05.0[A] -> GSI 17 (level, low) -> IRQ 17
sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
ACPI: PCI interrupt for device 0000:00:05.0 disabled
sata_sis: probe of 0000:00:05.0 failed with error -22
PCI: Enabling device 0000:00:03.3 (0100 -> 0102)
ACPI: PCI Interrupt 0000:00:03.3[D] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.3: request interrupt 23 failed
ehci_hcd 0000:00:03.3: USB bus 1 deregistered
ACPI: PCI interrupt for device 0000:00:03.3 disabled
ehci_hcd 0000:00:03.3: init 0000:00:03.3 fail, -22
ehci_hcd: probe of 0000:00:03.3 failed with error -22
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0000:00:03.0 (0100 -> 0102)
ACPI: PCI Interrupt 0000:00:03.0[A] -> GSI 20 (level, low) -> IRQ 20
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.0: request interrupt 20 failed
ohci_hcd 0000:00:03.0: USB bus 1 deregistered
ACPI: PCI interrupt for device 0000:00:03.0 disabled
ohci_hcd 0000:00:03.0: init 0000:00:03.0 fail, -22
ohci_hcd: probe of 0000:00:03.0 failed with error -22
PCI: Enabling device 0000:00:03.1 (0100 -> 0102)
ACPI: PCI Interrupt 0000:00:03.1[B] -> GSI 21 (level, low) -> IRQ 21
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.1: request interrupt 21 failed
ohci_hcd 0000:00:03.1: USB bus 1 deregistered
ACPI: PCI interrupt for device 0000:00:03.1 disabled
ohci_hcd 0000:00:03.1: init 0000:00:03.1 fail, -22
ohci_hcd: probe of 0000:00:03.1 failed with error -22
PCI: Enabling device 0000:00:03.2 (0100 -> 0102)
ACPI: PCI Interrupt 0000:00:03.2[C] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.2: request interrupt 22 failed
ohci_hcd 0000:00:03.2: USB bus 1 deregistered
ACPI: PCI interrupt for device 0000:00:03.2 disabled
ohci_hcd 0000:00:03.2: init 0000:00:03.2 fail, -22
ohci_hcd: probe of 0000:00:03.2 failed with error -22
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
w83627ehf: Found W83627DHG chip at 0x290
input: AT Translated Set 2 keyboard as /class/input/input2
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 
16:40:16 2008 UTC).
ACPI: PCI Interrupt 0000:00:02.7[C] -> GSI 18 (level, low) -> IRQ 18
unable to grab IRQ 18
ACPI: PCI interrupt for device 0000:00:02.7 disabled
Intel ICH: probe of 0000:00:02.7 failed with error -16
ALSA device list:
   No soundcards found.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
Using IPI Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.


dmesg with acpi=noirq:
Linux version 2.6.25-berta (root@hepto) (gcc version 4.2.3 (Debian 
4.2.3-2)) #21 Tue May 13 20:10:08 CEST 2008
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000003d135000 (usable)
  BIOS-e820: 000000003d135000 - 000000003d236000 (ACPI NVS)
  BIOS-e820: 000000003d236000 - 000000003ddf2000 (usable)
  BIOS-e820: 000000003ddf2000 - 000000003ddf4000 (reserved)
  BIOS-e820: 000000003ddf4000 - 000000003de79000 (usable)
  BIOS-e820: 000000003de79000 - 000000003def7000 (ACPI NVS)
  BIOS-e820: 000000003def7000 - 000000003def8000 (usable)
  BIOS-e820: 000000003def8000 - 000000003deff000 (ACPI data)
  BIOS-e820: 000000003deff000 - 000000003df00000 (usable)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
Warning only 896MB will be used.
Use a HIGHMEM enabled kernel.
896MB LOWMEM available.
Entering add_active_range(0, 0, 229376) 0 entries of 256 used
Zone PFN ranges:
   DMA             0 ->     4096
   Normal       4096 ->   229376
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
     0:        0 ->   229376
On node 0 totalpages: 229376
   DMA zone: 32 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 4064 pages, LIFO batch:0
   Normal zone: 1760 pages used for memmap
   Normal zone: 223520 pages, LIFO batch:31
   Movable zone: 0 pages used for memmap
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 3DEFE038, 002C (r1 INTEL  DG965CO        7A       1000013)
ACPI: FACP 3DEFD000, 0074 (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: DSDT 3DEF9000, 30F6 (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: FACS 3DEBC000, 0040
ACPI: APIC 3DEF8000, 006C (r1 INTEL  DG965CO        7A MSFT  1000013)
ACPI: PM-Timer IO Port: 0x808
Allocating PCI resources starting at 40000000 (gap: 3df00000:c2080000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 227584
Kernel command line: BOOT_IMAGE=2.6.25-berta root=301 lang=de acpi=noirq
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1200.063 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 904240k/917504k available (3212k kernel code, 12776k reserved, 
1149k data, 224k init, 0k highmem)
virtual kernel memory layout:
     fixmap  : 0xffff6000 - 0xfffff000   (  36 kB)
     vmalloc : 0xf8800000 - 0xffff4000   ( 119 MB)
     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
       .init : 0xc0546000 - 0xc057e000   ( 224 kB)
       .data : 0xc0423328 - 0xc0542838   (1149 kB)
       .text : 0xc0100000 - 0xc0423328   (3212 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
Calibrating delay using timer specific routine.. 2401.29 BogoMIPS 
(lpj=12006495)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 512K
using mwait in idle threads.
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Celeron(R) CPU          220  @ 1.20GHz stepping 01
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 0k freed
ACPI: Core revision 20070126
ACPI: setting ELCR to 0e00 (from 0c00)
net_namespace: 440 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
PCI: Using IRQ router default [1039/0964] at 0000:00:02.0
system 00:08: ioport range 0x800-0x8fe has been reserved
system 00:08: ioport range 0x8ff-0x8ff has been reserved
system 00:08: ioport range 0x4d0-0x4d1 has been reserved
system 00:08: ioport range 0x4d6-0x4d6 has been reserved
system 00:08: ioport range 0x295-0x29e has been reserved
system 00:08: ioport range 0x2e8-0x2ef has been reserved
system 00:08: ioport range 0x481-0x48f has been reserved
system 00:09: iomem range 0x0-0x9ffff could not be reserved
system 00:09: iomem range 0xec000-0xfffff could not be reserved
system 00:09: iomem range 0x100000-0x3dffffff could not be reserved
system 00:09: iomem range 0xe0000000-0xefffffff has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
PCI: Bridge: 0000:00:01.0
   IO window: 1000-1fff
   MEM window: 0x4a000000-0x4a0fffff
   PREFETCH window: 0x0000000040000000-0x0000000047ffffff
PCI: Bridge: 0000:00:1f.0
   IO window: disabled.
   MEM window: 0x3e000000-0x3e0fffff
   PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Enabling device 0000:00:1f.0 (0000 -> 0002)
PCI: Setting latency timer of device 0000:00:1f.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
audit: initializing netlink socket (disabled)
type=2000 audit(1210710972.289:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:1f.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1f.0:pcie00]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart: Detected SiS chipset - id:1634
agpgart: AGP aperture is 32M @ 0x48000000
[drm] Initialized drm 1.1.0 20060810
PCI: Setting latency timer of device 0000:01:00.0 to 64
[drm] Initialized sis 1.3.0 20070626 on minor 0
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP(,...)]
loop: module loaded
sis900.c: v1.08.10 Apr. 2 2006
0000:00:04.0: SiS 900 on Foxconn 661 7MI transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x2000, IRQ 11, 00:1c:c0:08:08:de
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ath_rate_sample: 1.2 (0.9.4)
ath_pci: 0.9.4
Switched to high resolution mode on CPU 0
wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps 9Mbps 12Mbps 18Mbps 
24Mbps 36Mbps 48Mbps 54Mbps
wifi0: turboG rates: 6Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
wifi0: H/W encryption support: WEP AES AES_CCM TKIP
wifi0: mac 7.9 phy 4.5 radio 5.6
wifi0: Use hw queue 1 for WME_AC_BE traffic
wifi0: Use hw queue 0 for WME_AC_BK traffic
wifi0: Use hw queue 2 for WME_AC_VI traffic
wifi0: Use hw queue 3 for WME_AC_VO traffic
wifi0: Use hw queue 8 for CAB traffic
wifi0: Use hw queue 9 for beacons
failed to automatically load module: wlan_scan_sta; errno: -2
unable to load wlan_scan_sta
wifi0: Atheros 5212: mem=0x4a100000, irq=10
ath_hal: 0.9.18.0 (AR5210, AR5211, AR5212, RF5111, RF5112, RF2413, RF5413)
wlan: 0.9.4
wlan: mac acl policy registered
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller (0x1039:0x5513 rev 0x01) at  PCI slot 0000:00:02.5
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
     ide0: BM-DMA at 0x2310-0x2317, BIOS settings: hda:PIO, hdb:PIO
     ide1: BM-DMA at 0x2318-0x231f, BIOS settings: hdc:PIO, hdd:PIO
Probing IDE interface ide0...
hda: TRANSCEND, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Probing IDE interface ide1...
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hda: max request size: 128KiB
hda: 7952112 sectors (4071 MB) w/2KiB Cache, CHS=7889/16/63
  hda: hda1
Driver 'sd' needs updating - please use bus_type methods
sata_sis 0000:00:05.0: version 1.0
sata_sis 0000:00:05.0: Detected SiS 180/181/964 chipset in SATA mode
scsi0 : sata_sis
scsi1 : sata_sis
ata1: SATA max UDMA/133 cmd 0x2328 ctl 0x2334 bmdma 0x2300 irq 10
ata2: SATA max UDMA/133 cmd 0x2320 ctl 0x2330 bmdma 0x2308 irq 10
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA7EA, max UDMA/133
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT72503 V54O PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 1:0:0:0: [sda] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 sda3
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:0:0: Attached scsi generic sg0 type 0
PCI: Enabling device 0000:00:03.3 (0100 -> 0102)
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:03.3: irq 10, io mem 0x4a111000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-berta ehci_hcd
usb usb1: SerialNumber: 0000:00:03.3
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
PCI: Enabling device 0000:00:03.0 (0100 -> 0102)
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.0: irq 11, io mem 0x4a114000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-berta ohci_hcd
usb usb2: SerialNumber: 0000:00:03.0
PCI: Enabling device 0000:00:03.1 (0100 -> 0102)
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:03.1: irq 10, io mem 0x4a113000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-berta ohci_hcd
usb usb3: SerialNumber: 0000:00:03.1
PCI: Enabling device 0000:00:03.2 (0100 -> 0102)
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
ohci_hcd 0000:00:03.2: irq 11, io mem 0x4a112000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: OHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-berta ohci_hcd
usb usb4: SerialNumber: 0000:00:03.2
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
w83627ehf: Found W83627DHG chip at 0x290
input: AT Translated Set 2 keyboard as /class/input/input2
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 
16:40:16 2008 UTC).
intel8x0_measure_ac97_clock: measured 58679 usecs
intel8x0: clocking to 48000
ALSA device list:
   #0: SiS SI7012 with AD1888 at irq 11
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 15
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
ieee80211: 802.11 data/management/control stack, git-1.1.13
ieee80211: Copyright (C) 2004-2005 Intel Corporation 
<jketreno@linux.intel.com>
ieee80211_crypt: registered algorithm 'NULL'
ieee80211_crypt: registered algorithm 'WEP'
ieee80211_crypt: registered algorithm 'CCMP'
ieee80211_crypt: registered algorithm 'TKIP'
Using IPI Shortcut mode
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 224k freed
input: PC Speaker as /class/input/input3
EXT3 FS on hda1, internal journal



So if you have any suggestions, please let me know.


All the best

Robert
