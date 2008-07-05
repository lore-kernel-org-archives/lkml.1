Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbYGEWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbYGEWxq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYGEWxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:53:39 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:31657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbYGEWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:53:37 -0400
Message-ID: <cccedfc60807051553r69c74bb2wf5080b3c8e9c5036@mail.gmail.com>
Date: Sat, 5 Jul 2008 17:53:36 -0500
From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
To: "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <486FC5D2.80600@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.u8J+BqAcxU1mg8ob9pMBJaAHBPo@ifi.uio.no>
	 <486FBFAB.5050303@shaw.ca>
	 <cccedfc60807051154m7d0a8b44h3294ec29fe07d35a@mail.gmail.com>
	 <486FC5D2.80600@shaw.ca>
X-Google-Sender-Auth: f5c38093d36494ec
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2008 at 2:04 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Jon Nelson wrote:
>>
>> Where should APIC errors be posted?
>> My EPoX MF570-SLI *will not boot* without noapic or nolapic.
>
> Post on linux-kernel about that one, with the dmesg from noapic mode and
> whatever info you can gather from when it won't boot. You might want to also
> test with 2.6.26-rc8 to see if the problem has already been fixed there.

Here is the boot log from booting my EPoX MF570SLI in nolapic mode.
When I boot without nolapic or noapic I get as far as

io scheduler cfq registered (default)

I can't boot to serial right now.


Inspecting /boot/System.map-2.6.22.18-0.2-default
Loaded 26669 symbols from /boot/System.map-2.6.22.18-0.2-default.
Symbols match kernel version 2.6.22.
No module symbols loaded - kernel modules not enabled.

klogd 1.4.1, log source = ksyslog started.
<5>Linux version 2.6.22.18-0.2-default (geeko@buildhost) (gcc version
4.2.1 (SUSE Linux)) #1 SMP 2008-06-09 13:53:20 +0200
<6>Command line:
root=/dev/disk/by-id/scsi-SATA_Hitachi_HDT7250_VFB200R210J8UJ-part1
splash=silent showopts nolapic
<6>BIOS-provided physical RAM map:
<4> BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
<4> BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
<4> BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
<4> BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
<4> BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
<4> BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
<4> BIOS-e820: 00000000d0000000 - 00000000f0000000 (reserved)
<4> BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
<7>Entering add_active_range(0, 0, 159) 0 entries of 3200 used
<7>Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
<4>end_pfn_map = 1048576
<6>DMI 2.2 present.
<4>ACPI: RSDP 000F80B0, 0014 (r0 Nvidia)
<4>ACPI: RSDT 3FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
<4>ACPI: FACP 3FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
<4>ACPI: DSDT 3FFF3180, 6732 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
<4>ACPI: FACS 3FFF0000, 0040
<4>ACPI: SSDT 3FFF99C0, 01C4 (r1 PTLTD  POWERNOW        1  LTP        1)
<4>ACPI: MCFG 3FFF9C00, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
<4>ACPI: APIC 3FFF9900, 0072 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
<6>Scanning NUMA topology in Northbridge 24
<6>No NUMA configuration found
<6>Faking a node at 0000000000000000-000000003fff0000
<7>Entering add_active_range(0, 0, 159) 0 entries of 3200 used
<7>Entering add_active_range(0, 256, 262128) 1 entries of 3200 used
<6>Bootmem setup node 0 0000000000000000-000000003fff0000
<4>Zone PFN ranges:
<4>  DMA             0 ->     4096
<4>  DMA32        4096 ->  1048576
<4>  Normal    1048576 ->  1048576
<4>early_node_map[2] active PFN ranges
<4>    0:        0 ->      159
<4>    0:      256 ->   262128
<7>On node 0 totalpages: 262031
<7>  DMA zone: 56 pages used for memmap
<7>  DMA zone: 1270 pages reserved
<7>  DMA zone: 2673 pages, LIFO batch:0
<7>  DMA32 zone: 3527 pages used for memmap
<7>  DMA32 zone: 254505 pages, LIFO batch:31
<7>  Normal zone: 0 pages used for memmap
<6>Nvidia board detected. Ignoring ACPI timer override.
<6>If you got timer trouble try acpi_use_timer_override
<6>ACPI: PM-Timer IO Port: 0x1008
<4>Intel MultiProcessor Specification v1.4
<6>MPTABLE: OEM ID: OEM00000 MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
<6>Processor #0 (Bootup-CPU)
<6>Processor #1
<4>I/O APIC #2 at 0xFEC00000.
<6>Setting APIC routing to flat
<6>Processors: 2
<4>swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
<4>swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000f0000
<4>swsusp: Registered nosave memory region: 00000000000f0000 - 0000000000100000
<6>Allocating PCI resources starting at 50000000 (gap: 40000000:90000000)
<6>SMP: Allowing 2 CPUs, 0 hotplug CPUs
<6>PERCPU: Allocating 50296 bytes of per cpu data
<4>Built 1 zonelists.  Total pages: 257178
<5>Kernel command line:
root=/dev/disk/by-id/scsi-SATA_Hitachi_HDT7250_VFB200R210J8UJ-part1
splash=silent showopts nolapic
<6>bootsplash: silent mode.
<4>Initializing CPU#0
<4>PID hash table entries: 4096 (order: 12, 32768 bytes)
<4>Marking TSC unstable due to TSCs unsynchronized
<6>time.c: Detected 1909.819 MHz processor.
<4>Console: colour VGA+ 80x25
<4>Checking aperture...
<4>CPU 0: aperture @ 4a0000000 size 32 MB
<4>Aperture too small (32 MB)
<4>No AGP bridge found
<4>Memory: 1025640k/1048512k available (2054k kernel code, 22484k
reserved, 1017k data, 316k init)
<4>Calibrating delay using timer specific routine.. 3822.77 BogoMIPS
(lpj=7645557)
<6>Security Framework v1.0.0 initialized
<4>Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
<4>Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
<4>Mount-cache hash table entries: 256
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 512K (64 bytes/line)
<6>CPU 0/0 -> Node 0
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 0
<6>SMP alternatives: switching to UP code
<6>Unpacking initramfs... done
<6>Freeing initrd memory: 2802k freed
<6>ACPI: Core revision 20070126
<4>ACPI: successfully read 23791 bytes from file /DSDT.aml
<4>ACPI: Override [DSDT-AWRDACPI] from initramfs - tainting kernel
<4>ACPI: Table DSDT replaced by host OS
<4>ACPI: DSDT 00000000, 5CEF (r1 NVIDIA AWRDACPI     1000 INTL 20060912)
<4>Parsing all Control Methods:
<4>Table [DSDT](id 0001) - 1114 Objects with 104 Devices 325 Methods 43 Regions
<4>Parsing all Control Methods:
<4>Table [SSDT](id 0002) - 8 Objects with 0 Devices 0 Methods 0 Regions
<4> tbxface-0587 [00] tb_load_namespace     : ACPI Tables successfully acquired
<4>ACPI: setting ELCR to 0200 (from 0ca0)
<4>evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
<4>ExtINT not setup in hardware but reported by MP table
<6>Using local APIC timer interrupts.
<4>result 12564602
<6>Detected 12.564 MHz APIC timer.
<6>SMP alternatives: switching to SMP code
<6>Booting processor 1/2 APIC 0x1
<4>Initializing CPU#1
<4>Calibrating delay using timer specific routine.. 3819.83 BogoMIPS
(lpj=7639667)
<6>CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
<6>CPU: L2 Cache: 512K (64 bytes/line)
<6>CPU 1/1 -> Node 0
<6>CPU: Physical Processor ID: 0
<6>CPU: Processor Core ID: 1
<4>AMD Athlon(tm) 64 X2 Dual Core Processor 3600+ stepping 01
<6>Brought up 2 CPUs
<4>migration_cost=192
<6>NET: Registered protocol family 16
<6>ACPI: bus type pci registered
<6>PCI: Using MMCONFIG at e0000000 - efffffff
<5>PCI: No mmconfig possible on device 00:18
<4>evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 1F [_GPE] 4
regs on int 0x9
<4>evgpeblk-0956 [00] ev_create_gpe_block   : GPE 20 to 5F [_GPE] 8
regs on int 0x9
<4>evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 8 Wake, Enabled 1
Runtime GPEs in this block
<4>evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 0 Wake, Enabled 0
Runtime GPEs in this block
<7>ACPI: EC: Look up EC in DSDT
<4>Completing Region/Field/Buffer/Package
initialization:...................................................................................................
<4>Initialized 39/43 Regions 9/9 Fields 34/34 Buffers 17/29 Packages
(1131 nodes)
<4>Initializing Device/Processor/Thermal objects by executing _INI methods:..
<4>Executed 2 _INI methods requiring 1 _STA executions (examined 109 objects)
<6>ACPI: Interpreter enabled
<6>ACPI: (supports S0 S1 S4 S5)
<6>ACPI: Using PIC for interrupt routing
<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
<7>PCI: Probing PCI hardware (bus 00)
<6>PCI: Transparent bridge - 0000:00:06.0
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
<7>ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
<4>ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK2] (IRQs 5 *7 9 10 11 14 15)
<4>ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LUBA] (IRQs 5 *7 9 10 11 14 15)
<4>ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
<4>ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 10 *11 14 15)
<4>ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 *11 14 15)
<4>ACPI: PCI Interrupt Link [LUB2] (IRQs *5 7 9 10 11 14 15)
<4>ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
<4>ACPI: PCI Interrupt Link [LSID] (IRQs *5 7 9 10 11 14 15)
<4>ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
<4>ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 *11 14 15)
<4>ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
<4>ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0, disabled.
<4>ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0, disabled.
<6>Linux Plug and Play Support v0.97 (c) Adam Belay
<6>pnp: PnP ACPI init
<6>ACPI: bus type pnp registered
<6>pnp: PnP ACPI: found 10 devices
<6>ACPI: ACPI bus type pnp unregistered
<6>PCI: Using ACPI for IRQ routing
<6>PCI: If a device doesn't work, try "pci=routeirq".  If it helps,
post a report
<4>ACPI: RTC can wake from S4
<6>pnp: 00:01: ioport range 0x1000-0x107f has been reserved
<6>pnp: 00:01: ioport range 0x1080-0x10ff has been reserved
<6>pnp: 00:01: ioport range 0x1400-0x147f has been reserved
<6>pnp: 00:01: ioport range 0x1480-0x14ff has been reserved
<6>pnp: 00:01: ioport range 0x1800-0x187f has been reserved
<6>pnp: 00:01: ioport range 0x1880-0x18ff has been reserved
<6>pnp: 00:01: iomem range 0xfff00000-0x10fefffff has been reserved
<6>pnp: 00:08: iomem range 0xe0000000-0xefffffff could not be reserved
<6>pnp: 00:09: iomem range 0xf0000-0xf3fff could not be reserved
<6>pnp: 00:09: iomem range 0xf4000-0xf7fff could not be reserved
<6>pnp: 00:09: iomem range 0xf8000-0xfbfff could not be reserved
<6>pnp: 00:09: iomem range 0xfc000-0xfffff could not be reserved
<6>PCI: Bridge: 0000:00:06.0
<6>  IO window: a000-afff
<6>  MEM window: fc800000-fd3fffff
<6>  PREFETCH window: fde00000-fdefffff
<6>Time: acpi_pm clocksource has been installed.
<6>PCI: Bridge: 0000:00:0a.0
<6>  IO window: 9000-9fff
<6>  MEM window: fdd00000-fddfffff
<6>  PREFETCH window: fdc00000-fdcfffff
<6>PCI: Bridge: 0000:00:0b.0
<6>  IO window: 8000-8fff
<6>  MEM window: fdb00000-fdbfffff
<6>  PREFETCH window: fda00000-fdafffff
<6>PCI: Bridge: 0000:00:0d.0
<6>  IO window: 7000-7fff
<6>  MEM window: fd900000-fd9fffff
<6>  PREFETCH window: fd800000-fd8fffff
<6>PCI: Bridge: 0000:00:0e.0
<6>  IO window: 6000-6fff
<6>  MEM window: fd700000-fd7fffff
<6>  PREFETCH window: fd600000-fd6fffff
<6>PCI: Bridge: 0000:00:0f.0
<6>  IO window: 5000-5fff
<6>  MEM window: fd500000-fd5fffff
<6>  PREFETCH window: fd400000-fd4fffff
<7>PCI: Setting latency timer of device 0000:00:06.0 to 64
<7>PCI: Setting latency timer of device 0000:00:0a.0 to 64
<7>PCI: Setting latency timer of device 0000:00:0b.0 to 64
<7>PCI: Setting latency timer of device 0000:00:0d.0 to 64
<7>PCI: Setting latency timer of device 0000:00:0e.0 to 64
<7>PCI: Setting latency timer of device 0000:00:0f.0 to 64
<6>NET: Registered protocol family 2
<4>IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
<4>TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
<4>TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
<6>TCP: Hash tables configured (established 131072 bind 65536)
<6>TCP reno registered
<6>audit: initializing netlink socket (disabled)
<5>audit(1214863836.464:1): initialized
<4>Total HugeTLB memory allocated, 0
<5>VFS: Disk quotas dquot_6.5.1
<4>Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
<6>io scheduler noop registered
<6>io scheduler anticipatory registered
<6>io scheduler deadline registered
<6>io scheduler cfq registered (default)

************* without "nolapic" or "noapic" the above message is the
last I ever see ***********

<4>0000:00:02.1 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
<7>Boot video device is 0000:01:05.0
<7>PCI: Setting latency timer of device 0000:00:0a.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:0a.0:pcie00]
<7>Allocate Port Service[0000:00:0a.0:pcie03]
<7>PCI: Setting latency timer of device 0000:00:0b.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:0b.0:pcie00]
<7>Allocate Port Service[0000:00:0b.0:pcie03]
<7>PCI: Setting latency timer of device 0000:00:0d.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:0d.0:pcie00]
<7>Allocate Port Service[0000:00:0d.0:pcie03]
<7>PCI: Setting latency timer of device 0000:00:0e.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:0e.0:pcie00]
<7>Allocate Port Service[0000:00:0e.0:pcie03]
<7>PCI: Setting latency timer of device 0000:00:0f.0 to 64
<4>assign_interrupt_mode Found MSI capability
<7>Allocate Port Service[0000:00:0f.0:pcie00]
<7>Allocate Port Service[0000:00:0f.0:pcie03]
<6>Real Time Clock Driver v1.12ac
<6>Non-volatile memory driver v1.2
<6>Linux agpgart interface v0.102 (c) Dave Jones
<6>Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
<6>PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
<4>PNP: PS/2 controller doesn't have AUX irq; using default 12
<6>serio: i8042 KBD port at 0x60,0x64 irq 1
<6>mice: PS/2 mouse device common for all mice
<6>input: AT Translated Set 2 keyboard as /class/input/input0
<6>input: PC Speaker as /class/input/input1
<6>NET: Registered protocol family 1
<6>Freeing unused kernel memory: 316k freed
<6>ACPI: Thermal Zone [THRM] (38 C)
<5>SCSI subsystem initialized

....

the rest is normal booting noise like it finding the SATA controller,
ethernet, etc...




-- 
Jon
