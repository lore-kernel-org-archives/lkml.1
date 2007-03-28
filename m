Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbXC1Uz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbXC1Uz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 16:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbXC1Uz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 16:55:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:13400 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXC1Uz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 16:55:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=tjUtJCS/UZjJpemj32OPTnVBUx1p8BTIxC9OksNmc/nNYIJqazsBPlUzVzgBjkbyFL+YmNqgF9Mwt4Mz7RO4PnxU+TM7c7/FTGjoEqh6ecC824RAm4X7BpkmxSlydHxb/ipwxxVwLuGxB7GEF3sx7aXxfFND7znWFZ2eqGfLb+E=
Message-ID: <a44ae5cd0703281355h13f1bd70s9eb94092bfa9c3e@mail.gmail.com>
Date: Wed, 28 Mar 2007 13:55:54 -0700
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Andy Grover" <andrew.grover@intel.com>,
       "Paul Diefenbaugh" <paul.s.diefenbaugh@intel.com>, len.brown@intel.com
Subject: 2.6.21-rc5-mm2 -- ACPI problems (lid switch broken, always shows running from AC, plugging in AC hangs machine)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

My laptop (HP dv1240us) is always showing that my laptop is plugged
into AC power, even when it is running off of the battery.  When I
plug into the AC after running on the battery, the machine immediately
locks up.  Also, the laptop lid button isn't working -- pressing it
doesn't trigger a suspend.

#
# Power management options (ACPI, APM)
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
# CONFIG_PM_SYSFS_DEPRECATED is not set
CONFIG_SOFTWARE_SUSPEND=y
CONFIG_PM_STD_PARTITION=""

#
# ACPI (Advanced Configuration and Power Interface) Support
#
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_SLEEP_PROC_FS=y
# CONFIG_ACPI_SLEEP_PROC_SLEEP is not set
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=m
# CONFIG_ACPI_BAY is not set
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_THERMAL=m
CONFIG_ACPI_ASUS=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_ACPI_BLACKLIST_YEAR=2000
CONFIG_ACPI_DEBUG=y
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m

CONFIG_APM=m
# CONFIG_APM_IGNORE_USER_SUSPEND is not set
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
# CONFIG_APM_ALLOW_INTS is not set
# CONFIG_APM_REAL_MODE_POWER_OFF is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_PERFORMANCE=m
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_SPEEDSTEP_ICH=m

CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y

#
# CPU idle PM support
#
# CONFIG_CPU_IDLE is not set


[    0.000000] Linux version 2.6.21-rc5-mm2 (root@FractalPath) (gcc
version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #7 Wed Mar 28 10:55:43 PDT 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size:
000000000009f800 end: 000000000009f800 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f800 size:
0000000000000800 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000ce000 size:
0000000000002000 end: 00000000000d0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size:
0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size:
000000003dde0000 end: 000000003dee0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003dee0000 size:
000000000000c000 end: 000000003deec000 type: 3
[    0.000000] copy_e820_map() start: 000000003deec000 size:
0000000000014000 end: 000000003df00000 type: 4
[    0.000000] copy_e820_map() start: 000000003df00000 size:
0000000002100000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000fec00000 size:
0000000000010000 end: 00000000fec10000 type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size:
0000000000001000 end: 00000000fee01000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff800000 size:
0000000000400000 end: 00000000ffc00000 type: 2
[    0.000000] copy_e820_map() start: 00000000fffffc00 size:
0000000000000400 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ce000 - 00000000000d0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003dee0000 (usable)
[    0.000000]  BIOS-e820: 000000003dee0000 - 000000003deec000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003deec000 - 000000003df00000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003df00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffffc00 - 0000000100000000 (reserved)
[    0.000000] 94MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f7e30
[    0.000000] Entering add_active_range(0, 0, 253664) 0 entries of 256 used
[    0.000000] sizeof(struct page) = 32
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   253664
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   253664
[    0.000000] On node 0 totalpages: 253664
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 189 pages used for memmap
[    0.000000]   HighMem zone: 24099 pages, LIFO batch:3
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F7E00, 0014 (r0 HP    )
[    0.000000] ACPI: RSDT 3DEE76BB, 0040 (r1 HP     09B8      6040000
LTP        0)
[    0.000000] ACPI: FACP 3DEEBE8C, 0074 (r1 HP     09B8      6040000
PTL        50)
[    0.000000] ACPI: DSDT 3DEE7B9A, 42F2 (r1 HP     09B8      6040000
MSFT  100000E)
[    0.000000] ACPI: FACS 3DEFCFC0, 0040
[    0.000000] ACPI: HPET 3DEEBF00, 0038 (r1 HP     09B8      6040000
PTL         0)
[    0.000000] ACPI: APIC 3DEEBF38, 005A (r1 HP     09B8      6040000
PTL        50)
[    0.000000] ACPI: APIC 3DEEBF92, 0046 (r1 HP     09B8      6040000
PTL         0)
[    0.000000] ACPI: BOOT 3DEEBFD8, 0028 (r1 HP     09B8      6040000
LTP        1)
[    0.000000] ACPI: SSDT 3DEE7AFE, 009C (r1 HP     09B8            1
INTL 20030224)
[    0.000000] ACPI: SSDT 3DEE76FB, 0277 (r1 HP     09B8         2000
INTL 20030224)
[    0.000000] ACPI: BIOS bug: multiple APIC/MADT found, using 2
[    0.000000] ACPI: If "acpi_apic_instance=0" works better, notify
linux-acpi@vger.kernel.org
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:13 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0x0
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:bec00000)
[    0.000000] Built 1 zonelists.  Total pages: 251683
[    0.000000] Kernel command line:
root=UUID=47a91ab9-c44b-4802-8012-5748803bb3ef pci=assign-busses
vga=0x27e ro splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1695.771 MHz processor.
[   57.648280] Console: colour VGA+ 80x60
[   57.653235] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[   57.653359] ... MAX_LOCKDEP_SUBCLASSES:    8
[   57.653435] ... MAX_LOCK_DEPTH:          30
[   57.653512] ... MAX_LOCKDEP_KEYS:        2048
[   57.653588] ... CLASSHASH_SIZE:           1024
[   57.653665] ... MAX_LOCKDEP_ENTRIES:     8192
[   57.653742] ... MAX_LOCKDEP_CHAINS:      16384
[   57.653819] ... CHAINHASH_SIZE:          8192
[   57.653896]  memory used by lock dependency info: 992 kB
[   57.653975]  per task-struct memory footprint: 1200 bytes
[   57.654496] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   57.655077] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   57.693759] Memory: 996500k/1014656k available (1671k kernel code,
17420k reserved, 885k data, 176k init, 97152k highmem)
[   57.693898] virtual kernel memory layout:
[   57.693899]     fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
[   57.693901]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[   57.693902]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[   57.693903]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   57.693905]       .init : 0xc0382000 - 0xc03ae000   ( 176 kB)
[   57.693906]       .data : 0xc02a1e0c - 0xc037f4b4   ( 885 kB)
[   57.693907]       .text : 0xc0100000 - 0xc02a1e0c   (1671 kB)
[   57.694526] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   57.778324] Calibrating delay using timer specific routine..
3394.89 BogoMIPS (lpj=5655824)
[   57.778624] Security Framework v1.0.0 initialized
[   57.778705] SELinux:  Disabled at boot.
[   57.778824] Mount-cache hash table entries: 512
[   57.779471] CPU: After generic identify, caps: afe9fbbf 00000000
00000000 00000000 00000180 00000000 00000000
[   57.779483] CPU: L1 I cache: 32K, L1 D cache: 32K
[   57.779590] CPU: L2 cache: 2048K
[   57.779665] CPU: After all inits, caps: afe9fbbf 00000000 00000000
00002040 00000180 00000000 00000000
[   57.779672] Intel machine check architecture supported.
[   57.779754] Intel machine check reporting enabled on CPU#0.
[   57.779837] Compat vDSO mapped to ffffe000.
[   57.779923] CPU: Intel(R) Pentium(R) M processor 1.70GHz stepping 06
[   57.780061] Checking 'hlt' instruction... OK.
[   57.791759] ACPI: Core revision 20070126
[   57.801182] Parsing all Control Methods:
[   57.801363] Table [DSDT](id 0001) - 654 Objects with 50 Devices 163
Methods 17 Regions
[   57.801622] Parsing all Control Methods:
[   57.801761] Table [SSDT](id 0002) - 1 Objects with 0 Devices 1
Methods 0 Regions
[   57.802103] Parsing all Control Methods:
[   57.802243] Table [SSDT](id 0003) - 6 Objects with 0 Devices 3
Methods 0 Regions
[   57.802433]  tbxface-0587 [02] tb_load_namespace     : ACPI Tables
successfully acquired
[   57.876949] evxfevnt-0091 [02] enable                : Transition
to ACPI mode successful
[   57.877622] ENABLING IO-APIC IRQs
[   57.877901] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[   58.015431] NET: Registered protocol family 16
[   58.016104] ACPI: bus type pci registered
[   58.017441] PCI: PCI BIOS revision 2.10 entry at 0xfd9c2, last bus=2
[   58.017523] PCI: Using configuration type 1
[   58.017599] Setting up standard PCI resources
[   58.038873] evgpeblk-0952 [04] ev_create_gpe_block   : GPE 00 to 1F
[_GPE] 4 regs on int 0x9
[   58.043249] evgpeblk-1049 [03] ev_initialize_gpe_bloc: Found 6
Wake, Enabled 0 Runtime GPEs in this block
[   58.045984] Completing Region/Field/Buffer/Package
initialization:.....................................................
[   58.066979] Initialized 17/17 Regions 0/0 Fields 22/22 Buffers
14/23 Packages (670 nodes)
[   58.067181] Initializing Device/Processor/Thermal objects by
executing _INI methods:.
[   58.068782] Executed 1 _INI methods requiring 0 _STA executions
(examined 54 objects)
[   58.069405] ACPI: Interpreter enabled
[   58.069491] ACPI: (supports S0 S3 S4 S5)
[   58.070114] ACPI: Using IOAPIC for interrupt routing
[   60.181724] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   60.182937] PCI quirk: region 1000-107f claimed by ICH4 ACPI/GPIO/TCO
[   60.183021] PCI quirk: region 1180-11bf claimed by ICH4 GPIO
[   60.183189] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[   60.183272] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[   60.183355] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[   60.183438] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[   60.184541] PCI: Transparent bridge - 0000:00:1e.0
[   60.184927] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   60.185741] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[   60.203605] ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
[   60.204097] ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
[   60.204582] ACPI: PCI Interrupt Link [LNKC] (IRQs *4)
[   60.205113] ACPI: PCI Interrupt Link [LNKD] (IRQs *3)
[   60.205613] ACPI: PCI Interrupt Link [LNKE] (IRQs *11)
[   60.206099] ACPI: PCI Interrupt Link [LNKF] (IRQs 3) *0, disabled.
[   60.206643] ACPI: PCI Interrupt Link [LNKG] (IRQs *4)
[   60.207127] ACPI: PCI Interrupt Link [LNKH] (IRQs *3)
[   60.207663] Linux Plug and Play Support v0.97 (c) Adam Belay
[   60.207789] pnp: PnP ACPI init
[   61.209150] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
[   61.212569] pnp: PnP ACPI: found 7 devices
[   61.215195] PCI: Using ACPI for IRQ routing
[   61.215272] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   61.221489] pnp: 00:04: iomem range 0xfec10000-0xfec1ffff has been reserved
[   61.223047] Time: tsc clocksource has been installed.
[   61.254320] PCI: Bus 2, cardbus bridge: 0000:01:09.0
[   61.254399]   IO window: 00003400-000034ff
[   61.254478]   IO window: 00003800-000038ff
[   61.254558]   PREFETCH window: 50000000-53ffffff
[   61.254639]   MEM window: 58000000-5bffffff
[   61.254718] PCI: Bridge: 0000:00:1e.0
[   61.254795]   IO window: 3000-3fff
[   61.254875]   MEM window: e0200000-e02fffff
[   61.254955]   PREFETCH window: 50000000-53ffffff
[   61.255047] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   61.255069] ACPI: PCI Interrupt 0000:01:09.0[A] -> GSI 20 (level,
low) -> IRQ 20
[   61.255275] NET: Registered protocol family 2
[   61.286400] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   61.286930] TCP established hash table entries: 65536 (order: 9,
2883584 bytes)
[   61.294850] TCP bind hash table entries: 65536 (order: 9, 2883584 bytes)
[   61.304630] TCP: Hash tables configured (established 65536 bind 65536)
[   61.304775] TCP reno registered
[   61.314210] Unpacking initramfs... done
[   61.540219] Freeing initrd memory: 3143k freed
[   61.540720] Simple Boot Flag at 0x36 set to 0x1
[   61.542835] audit: initializing netlink socket (disabled)
[   61.542981] audit(1175081081.359:1): initialized
[   61.543489] highmem bounce pool size: 64 pages
[   61.543977] VFS: Disk quotas dquot_6.5.1
[   61.544069] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[   61.544412] io scheduler noop registered
[   61.544508] io scheduler cfq registered (default)
[   61.544613] Boot video device is 0000:00:02.0
[   61.567170] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports,
IRQ sharing enabled
[   61.569794] ACPI: PCI Interrupt 0000:00:1f.6[B] -> GSI 17 (level,
low) -> IRQ 17
[   61.569955] ACPI: PCI interrupt for device 0000:00:1f.6 disabled
[   61.571055] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PSM1] at
0x60,0x64 irq 1,12
[   61.573460] serio: i8042 KBD port at 0x60,0x64 irq 1
[   61.573548] serio: i8042 AUX port at 0x60,0x64 irq 12
[   61.574073] mice: PS/2 mouse device common for all mice
[   61.574704] async_tx: api initialized (async)
[   61.574782] xor: automatically using best checksumming function: pIII_sse
[   61.589151]    pIII_sse  :  4524.000 MB/sec
[   61.589228] xor: using function: pIII_sse (4524.000 MB/sec)
[   61.589461] TCP cubic registered
[   61.589564] NET: Registered protocol family 1
[   61.589651] Using IPI Shortcut mode
[   61.590694] Freeing unused kernel memory: 176k freed
[   61.590865] Write protecting the kernel read-only data: 676k
[   61.623774] input: AT Translated Set 2 keyboard as /class/input/input0
[   61.705748] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
[   61.755589] Switched to high resolution mode on CPU 0
[   63.010750] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   63.510190] [ACPI Debug]  String: [0x11] "Current temp is: "
[   63.510212] [ACPI Debug]  Integer: 0x00000040
[   64.009511] [ACPI Debug]  String: [0x11] "Current temp is: "
[   64.009531] [ACPI Debug]  Integer: 0x00000040
[   64.009641] ACPI: Thermal Zone [THRM] (64 C)
[   64.332671] usbcore: registered new interface driver usbfs
[   64.332794] usbcore: registered new interface driver hub
[   64.333180] usbcore: registered new device driver usb
[   64.334334] USB Universal Host Controller Interface driver v3.0
[   64.334483] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   64.334507] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   64.334512] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   64.334889] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   64.334939] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001820
[   64.335109] usb usb1: new device found, idVendor=0000, idProduct=0000
[   64.335112] usb usb1: new device strings: Mfr=3, Product=2, SerialNumber=1
[   64.335116] usb usb1: Product: UHCI Host Controller
[   64.335118] usb usb1: Manufacturer: Linux 2.6.21-rc5-mm2 uhci_hcd
[   64.335121] usb usb1: SerialNumber: 0000:00:1d.0
[   64.335545] usb usb1: configuration #1 chosen from 1 choice
[   64.335694] hub 1-0:1.0: USB hub found
[   64.335812] hub 1-0:1.0: 2 ports detected
[   64.343404] 8139too Fast Ethernet driver 0.9.28
[   64.353232] ieee1394: Initialized config rom entry `ip1394'
[   64.401839] SCSI subsystem initialized
[   64.407421] libata version 2.20 loaded.
[   64.439323] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[   64.439351] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   64.439356] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   64.439482] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   64.439536] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001840
[   64.439707] usb usb2: new device found, idVendor=0000, idProduct=0000
[   64.439711] usb usb2: new device strings: Mfr=3, Product=2, SerialNumber=1
[   64.439714] usb usb2: Product: UHCI Host Controller
[   64.439716] usb usb2: Manufacturer: Linux 2.6.21-rc5-mm2 uhci_hcd
[   64.439719] usb usb2: SerialNumber: 0000:00:1d.1
[   64.440075] usb usb2: configuration #1 chosen from 1 choice
[   64.440214] hub 2-0:1.0: USB hub found
[   64.440236] hub 2-0:1.0: 2 ports detected
[   64.547839] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[   64.547865] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   64.547870] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   64.548007] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   64.548064] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001860
[   64.548211] usb usb3: new device found, idVendor=0000, idProduct=0000
[   64.548214] usb usb3: new device strings: Mfr=3, Product=2, SerialNumber=1
[   64.548218] usb usb3: Product: UHCI Host Controller
[   64.548220] usb usb3: Manufacturer: Linux 2.6.21-rc5-mm2 uhci_hcd
[   64.548222] usb usb3: SerialNumber: 0000:00:1d.2
[   64.548543] usb usb3: configuration #1 chosen from 1 choice
[   64.548684] hub 3-0:1.0: USB hub found
[   64.548706] hub 3-0:1.0: 2 ports detected
[   64.649153] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 23 (level,
low) -> IRQ 23
[   64.649179] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   64.649184] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   64.649305] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 4
[   64.649405] ehci_hcd 0000:00:1d.7: debug port 1
[   64.649413] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[   64.649431] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0100000
[   64.653321] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   64.653410] usb usb4: new device found, idVendor=0000, idProduct=0000
[   64.653413] usb usb4: new device strings: Mfr=3, Product=2, SerialNumber=1
[   64.653416] usb usb4: Product: EHCI Host Controller
[   64.653418] usb usb4: Manufacturer: Linux 2.6.21-rc5-mm2 ehci_hcd
[   64.653420] usb usb4: SerialNumber: 0000:00:1d.7
[   64.653769] usb usb4: configuration #1 chosen from 1 choice
[   64.653921] hub 4-0:1.0: USB hub found
[   64.653987] hub 4-0:1.0: 6 ports detected
[   64.756012] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   64.756623] eth0: RealTek RTL8139 at 0xf884a800, 00:c0:9f:95:18:1b, IRQ 16
[   64.756626] eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
[   64.756813] ACPI: PCI Interrupt 0000:01:09.2[C] -> GSI 22 (level,
low) -> IRQ 22
[   64.824200] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]
MMIO=[e0207000-e02077ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   64.824408] ata_piix 0000:00:1f.1: version 2.10ac1
[   64.824431] PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
[   64.824441] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[   64.824481] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[   64.826262] ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00011810 irq 14
[   64.826500] ata2: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376
bmdma 0x00011818 irq 15
[   64.826541] scsi0 : ata_piix
[   64.985031] ata1.00: ATA-6: FUJITSU MHU2100AT, 00000008, max UDMA/100
[   64.985035] ata1.00: 195371568 sectors, multi 16: LBA
[   64.991676] ata1.00: configured for UDMA/100
[   64.991687] scsi1 : ata_piix
[   65.304593] ata2.00: ATAPI, max UDMA/33
[   65.464372] ata2.00: configured for UDMA/33
[   65.464829] scsi 0:0:0:0: Direct-Access     ATA      FUJITSU
MHU2100A 0000 PQ: 0 ANSI: 5
[   65.470205] scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM
GMA-4080N 0S35 PQ: 0 ANSI: 5
[   65.499844] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[   65.499966] sd 0:0:0:0: [sda] Write Protect is off
[   65.500045] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.500099] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   65.500431] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
[   65.500540] sd 0:0:0:0: [sda] Write Protect is off
[   65.500619] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   65.500674] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   65.500835]  sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[   66.025799] sd 0:0:0:0: [sda] Attached SCSI disk
[   66.036659] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   66.041191] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   66.074746] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw
xa/form2 cdda tray
[   66.074878] Uniform CD-ROM driver Revision: 3.20
[   66.075191] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   66.093784] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00c09f00004fec18]
[   66.930058] Attempting manual resume
[   66.957700] EXT3-fs: INFO: recovery required on readonly filesystem.
[   66.957788] EXT3-fs: write access will be enabled during recovery.
[   70.600696] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
[   71.099947] [ACPI Debug]  String: [0x11] "Current temp is: "
[   71.100101] [ACPI Debug]  Integer: 0x0000003B
[   71.599282] [ACPI Debug]  String: [0x1C] "Temperature increasing: _Q80"
[   72.098616] [ACPI Debug]  String: [0x11] "Current temp is: "
[   72.098777] [ACPI Debug]  Integer: 0x0000003B
[   73.220486] kjournald starting.  Commit interval 5 seconds
[   73.595518] EXT3-fs: mounted filesystem with ordered data mode.
[   91.722734] IPv4 FIB: Using LC-trie version 0.407
[   92.953555] Linux agpgart interface v0.102 (c) Dave Jones
[   93.050389] agpgart: Detected an Intel 855 Chipset.
[   93.051364] agpgart: Detected 32636K stolen memory.
[   93.062734] agpgart: AGP aperture is 128M @ 0xe8000000
[   93.151484] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   93.176187] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   93.190053] iTCO_vendor_support: vendor-support=0
[   93.191528] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
[   93.191946] iTCO_wdt: Found a ICH4-M TCO device (Version=1, TCOBASE=0x1060)
[   93.192230] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   93.316838] Real Time Clock Driver v1.12ac
[   93.363658] intel_rng: FWH not detected
[   93.396467] ieee80211_crypt: registered algorithm 'NULL'
[   93.412614] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   93.412703] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   93.453208] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network
Driver, 1.2.0kdmprq
[   93.453338] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   93.454065] ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 18 (level,
low) -> IRQ 18
[   93.485935] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
[   93.639978] sdhci: Secure Digital Host Controller Interface driver
[   93.640070] sdhci: Copyright(c) Pierre Ossman
[   93.912114] Synaptics Touchpad, model: 1, fw: 5.10, id: 0x258eb1,
caps: 0xa04713/0x0
[   93.943409] input: SynPS/2 Synaptics TouchPad as /class/input/input1
[   94.396392] ipw2200: Detected geography ZZM (11 802.11bg channels,
0 802.11a channels)
[   94.396769] Yenta: CardBus bridge found at 0000:01:09.0 [103c:3080]
[   94.396869] Yenta: Enabling burst memory read transactions
[   94.396951] Yenta: Using CSCINT to route CSC interrupts to PCI
[   94.397030] Yenta: Routing CardBus interrupts to PCI
[   94.397112] Yenta TI: socket 0000:01:09.0, mfunc 0x01a01b22, devctl 0x64
[   94.625731] Yenta: ISA IRQ mask 0x0cf8, PCI irq 20
[   94.625816] Socket status: 30000006
[   94.625900] pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
[   94.626005] pcmcia: parent PCI bridge Memory window: 0xe0200000 - 0xe02fffff
[   94.626089] pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
[   94.630308] ACPI: PCI Interrupt 0000:01:09.3[A] -> GSI 20 (level,
low) -> IRQ 20
[   94.648973] sdhci: SDHCI controller found at 0000:01:09.4 [104c:8034] (rev 0)
[   94.649083] ACPI: PCI Interrupt 0000:01:09.4[A] -> GSI 20 (level,
low) -> IRQ 20
[   94.649524] mmc0: SDHCI at 0xe0208400 irq 20 DMA
[   94.649745] mmc1: SDHCI at 0xe0208000 irq 20 DMA
[   94.649981] mmc2: SDHCI at 0xe0207c00 irq 20 DMA
[   94.650192] ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 17 (level,
low) -> IRQ 17
[   94.650389] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[   94.964469] intel8x0_measure_ac97_clock: measured 50171 usecs
[   94.964556] intel8x0: clocking to 48000
[   95.251403] lp: driver loaded but no devices found
[   95.348575] fuse init (API version 7.8)
[   95.404135] Adding 1052216k swap on
/dev/disk/by-uuid/f5d0cec6-779a-4035-bb7b-9a0837ac3e66.  Priority:-1
extents:1 across:1052216k
[   95.711279] EXT3 FS on sda11, internal journal
[  117.771965] kjournald starting.  Commit interval 5 seconds
[  117.772356] EXT3 FS on sda10, internal journal
[  117.772366] EXT3-fs: mounted filesystem with ordered data mode.
[  117.996602] kjournald starting.  Commit interval 5 seconds
[  118.000404] EXT3 FS on sda6, internal journal
[  118.000414] EXT3-fs: mounted filesystem with ordered data mode.
[  118.028237] kjournald starting.  Commit interval 5 seconds
[  118.028711] EXT3 FS on sda7, internal journal
[  118.028719] EXT3-fs: mounted filesystem with ordered data mode.
[  118.032497] kjournald starting.  Commit interval 5 seconds
[  118.032897] EXT3 FS on sda9, internal journal
[  118.032905] EXT3-fs: mounted filesystem with ordered data mode.
[  122.294327] ACPI: AC Adapter [ACAD] (on-line)
[  124.381468] ACPI: Battery Slot [BAT0] (battery present)
[  124.401835] input: Power Button (FF) as /class/input/input2
[  124.402332] ACPI: Power Button (FF) [PWRF]
[  124.404691] input: Lid Switch as /class/input/input3
[  124.404790] ACPI: Lid Switch [LID0]
[  124.404993] input: Sleep Button (CM) as /class/input/input4
[  124.405084] ACPI: Sleep Button (CM) [SLPB]
[  126.529386] No dock devices found.
[  126.585634] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[  126.606239] ACPI: Video Device [GFX0] (multi-head: yes  rom: yes  post: no)
[  130.847807] Capability LSM initialized
[  130.891859] eth0: link down
[  133.317897] [drm] Initialized drm 1.1.0 20060810
[  133.323604] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level,
low) -> IRQ 16
[  133.326885] [drm] Initialized i915 1.6.0 20060119 on minor 0
[  133.330064] [drm] Initialized i915 1.6.0 20060119 on minor 1
[  134.373854] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   77.413325] Marking TSC unstable due to: cpufreq changes.
[   77.416658] Time: acpi_pm clocksource has been installed.
[   77.889992] Clocksource tsc unstable (delta = -312378109 ns)
[  108.756655] NET: Registered protocol family 10
[  108.756655] lo: Disabled Privacy Extensions
[  108.756655] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  118.973321] eth1: no IPv6 routers present

00:00.0 Host bridge: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
	Latency: 0
	Region 0: Memory at <unassigned> (32-bit, prefetchable)
	Capabilities: [40] Vendor Specific Information

00:00.1 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:00.3 System peripheral: Intel Corporation 82852/82855 GM/GME/PM/GMV
Processor to I/O Controller (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:02.0 VGA compatible controller: Intel Corporation 82852/855GM
Integrated Graphics Device (rev 02) (prog-if 00 [VGA])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e8000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at e0000000 (32-bit, non-prefetchable) [size=512K]
	Region 2: I/O ports at 1800 [size=8]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:02.1 Display controller: Intel Corporation 82852/855GM Integrated
Graphics Device (rev 02)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Region 0: Memory at f0000000 (32-bit, prefetchable) [disabled] [size=128M]
	Region 1: Memory at e0080000 (32-bit, non-prefetchable) [disabled] [size=512K]
	Capabilities: [d0] Power Management version 1
		Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 03) (prog-if 00
[UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at 1820 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 03) (prog-if 00
[UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at 1840 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 03) (prog-if 00
[UHCI])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at 1860 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M)
USB2 EHCI Controller (rev 03) (prog-if 20 [EHCI])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin D routed to IRQ 23
	Region 0: Memory at e0100000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 83)
(prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR+
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=05, sec-latency=64
	I/O behind bridge: 00003000-00003fff
	Memory behind bridge: e0200000-e02fffff
	Prefetchable memory behind bridge: 50000000-53ffffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 03) (prog-if 8a [Master SecP PriP])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin A routed to IRQ 18
	Region 0: I/O ports at 01f0 [size=8]
	Region 1: I/O ports at 03f4 [size=1]
	Region 2: I/O ports at 0170 [size=8]
	Region 3: I/O ports at 0374 [size=1]
	Region 4: I/O ports at 1810 [size=16]
	Region 5: Memory at 54000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 5
	Region 4: I/O ports at 1880 [size=32]

00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 03)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 1c00 [size=256]
	Region 1: I/O ports at 18c0 [size=64]
	Region 2: Memory at e0100c00 (32-bit, non-prefetchable) [size=512]
	Region 3: Memory at e0100800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Modem Controller (rev 03) (prog-if 00 [Generic])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 17
	Region 0: I/O ports at 2400 [size=256]
	Region 1: I/O ports at 2000 [size=128]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 10)
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (8000ns min, 16000ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at 3000 [size=256]
	Region 1: Memory at e0207800 (32-bit, non-prefetchable) [size=256]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0-,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:06.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
	Subsystem: Hewlett-Packard Company Unknown device 12f5
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 6000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 18
	Region 0: Memory at e0206000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-

01:09.0 CardBus bridge: Texas Instruments PCIxx21/x515 Cardbus Controller
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 168, Cache Line Size: 128 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e0209000 (32-bit, non-prefetchable) [size=4K]
	Bus: primary=01, secondary=02, subordinate=05, sec-latency=176
	Memory window 0: 50000000-53fff000 (prefetchable)
	Memory window 1: 58000000-5bfff000
	I/O window 0: 00003400-000034ff
	I/O window 1: 00003800-000038ff
	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
	16-bit legacy interface ports at 0001

01:09.2 FireWire (IEEE 1394): Texas Instruments OHCI Compliant IEEE
1394 Host Controller (prog-if 10 [OHCI])
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin C routed to IRQ 22
	Region 0: Memory at e0207000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at e0200000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+

01:09.3 Mass storage controller: Texas Instruments PCIxx21 Integrated
FlashMedia Controller
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e0204000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:09.4 Generic system peripheral [0805]: Texas Instruments
PCI6411/6421/6611/6621/7411/7421/7611/7621 Secure Digital Controller
	Subsystem: Hewlett-Packard Company Unknown device 3080
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR+ FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
	Latency: 64 (1750ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at e0208400 (32-bit, non-prefetchable) [size=256]
	Region 1: Memory at e0208000 (32-bit, non-prefetchable) [size=256]
	Region 2: Memory at e0207c00 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
