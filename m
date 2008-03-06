Return-Path: <linux-kernel-owner+w=401wt.eu-S1760004AbYCFIRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760004AbYCFIRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYCFIQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:16:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:44581 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbYCFIQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:16:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,455,1199692800"; 
   d="scan'208";a="350649361"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: AE_ERROR, ACPI thermal trip point state changed
Date: Thu, 6 Mar 2008 16:05:41 +0800
Message-ID: <823A93EED437D048963A3697DB0E35DE0129BB78@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: AE_ERROR, ACPI thermal trip point state changed
Thread-Index: Ach/XdBQ3g47WTA0SHaA4D3chf+JqgAAu+Og
References: <47B328AA.1000800@freemail.hu> <47B3F147.7000704@freemail.hu> <47CF96E2.9020302@freemail.hu> <1204757373.10256.179.camel@acpi-hp-zz.sh.intel.com>
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>,
       =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: <linux-acpi@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 06 Mar 2008 08:05:46.0047 (UTC) FILETIME=[E1B654F0:01C87F60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please attach the result of "cat /proc/acpi/thermal_zone/*/*" after this message is shown.

Thanks,
rui

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org
>[mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of Zhang, Rui
>Sent: Thursday, March 06, 2008 6:50 AM
>To: Németh Márton
>Cc: linux-acpi@vger.kernel.org; LKML
>Subject: Re: AE_ERROR, ACPI thermal trip point state changed
>
>hi, Márton,
>
>Please re-send the acpidump using the latest pmtools at
>http://www.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/
>
>thanks,
>rui
>
>On Thu, 2008-03-06 at 08:01 +0100, Németh Márton wrote:
>> Hi,
>>
>> in my dmesg the following lines appear with linux-2.6.25-rc4 on Clevo D410J
>laptop:
>>
>> ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state changed
>> Please send acpidump to linux-acpi@vger.kernel.org
>>  [20070126]
>>
>> Should I do something else than sending the acpidump?
>>
>> 	Márton Németh
>>
>>
>> Németh Márton wrote:
>> > Hi,
>> >
>> > I get the following message from the kernel 2.6.25-rc1 on Clevo D410J laptop:
>> >
>> > ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state
>changed
>> > Please send acpidump to linux-acpi@vger.kernel.org
>> >  [20070126]
>> >
>> > So I am writing this email to you.
>> >
>> > 	Márton Németh
>>
>> plain text document attachment (dmesg-2.6.25-rc4.txt)
>> Linux version 2.6.25-rc4 (nmarci@europa) (gcc version 4.2.3 20080114
>(prerelease) (Debian 4.2.2-7)) #1 PREEMPT Wed Mar 5 21:34:08 CET 2008
>> BIOS-provided physical RAM map:
>>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000d8000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 000000003bf70000 (usable)
>>  BIOS-e820: 000000003bf70000 - 000000003bf7a000 (ACPI data)
>>  BIOS-e820: 000000003bf7a000 - 000000003bf80000 (ACPI NVS)
>>  BIOS-e820: 000000003bf80000 - 0000000040000000 (reserved)
>>  BIOS-e820: 00000000fffe0000 - 0000000100000000 (reserved)
>> 63MB HIGHMEM available.
>> 896MB LOWMEM available.
>> Scan SMP from c0000000 for 1024 bytes.
>> Scan SMP from c009fc00 for 1024 bytes.
>> Scan SMP from c00f0000 for 65536 bytes.
>> found SMP MP-table at [c00f6870] 000f6870
>> Entering add_active_range(0, 0, 245616) 0 entries of 256 used
>> Zone PFN ranges:
>>   DMA             0 ->     4096
>>   Normal       4096 ->   229376
>>   HighMem    229376 ->   245616
>> Movable zone start PFN for each node
>> early_node_map[1] active PFN ranges
>>     0:        0 ->   245616
>> On node 0 totalpages: 245616
>>   DMA zone: 32 pages used for memmap
>>   DMA zone: 0 pages reserved
>>   DMA zone: 4064 pages, LIFO batch:0
>>   Normal zone: 1760 pages used for memmap
>>   Normal zone: 223520 pages, LIFO batch:31
>>   HighMem zone: 126 pages used for memmap
>>   HighMem zone: 16114 pages, LIFO batch:3
>>   Movable zone: 0 pages used for memmap
>> DMI present.
>> ACPI: RSDP 000F68D0, 0014 (r0 PTLTD )
>> ACPI: RSDT 3BF7600B, 0030 (r1 PTLTD    RSDT    6040000  LTP        0)
>> ACPI: FACP 3BF79E87, 0074 (r1 AMDK8  PTLTW     6040000 PTL_    F4240)
>> ACPI: DSDT 3BF7603B, 3E4C (r1  VIA   PTL_ACPI  6040000 MSFT  100000E)
>> ACPI: FACS 3BF7AFC0, 0040
>> ACPI: SSDT 3BF79EFB, 00B5 (r1 PTLTD  POWERNOW  6040000  LTP        1)
>> ACPI: APIC 3BF79FB0, 0050 (r1 PTLTD  	 APIC    6040000  LTP        0)
>> ACPI: PM-Timer IO Port: 0x4008
>> ACPI: Local APIC address 0xfee00000
>> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>> Processor #0 15:12 APIC version 16
>> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>> ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>> IOAPIC[0]: apic_id 1, version 3, address 0xfec00000, GSI 0-23
>> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
>> ACPI: IRQ0 used by override.
>> ACPI: IRQ2 used by override.
>> ACPI: IRQ10 used by override.
>> Enabling APIC mode:  Flat.  Using 1 I/O APICs
>> Using ACPI (MADT) for SMP configuration information
>> Allocating PCI resources starting at 50000000 (gap: 40000000:bffe0000)
>> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
>> PM: Registered nosave memory: 00000000000a0000 - 00000000000d8000
>> PM: Registered nosave memory: 00000000000d8000 - 0000000000100000
>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 243698
>> Kernel command line: root=/dev/hda3 ro log_buf_len=1M resume=/dev/hda2
>> log_buf_len: 1048576
>> mapped APIC to ffffb000 (fee00000)
>> mapped IOAPIC to ffffa000 (fec00000)
>> Enabling fast FPU save and restore... done.
>> Enabling unmasked SIMD FPU exception support... done.
>> Initializing CPU#0
>> PID hash table entries: 4096 (order: 12, 16384 bytes)
>> Detected 1603.695 MHz processor.
>> Console: colour VGA+ 80x25
>> console [tty0] enabled
>> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
>> ... MAX_LOCKDEP_SUBCLASSES:    8
>> ... MAX_LOCK_DEPTH:          48
>> ... MAX_LOCKDEP_KEYS:        2048
>> ... CLASSHASH_SIZE:           1024
>> ... MAX_LOCKDEP_ENTRIES:     8192
>> ... MAX_LOCKDEP_CHAINS:      16384
>> ... CHAINHASH_SIZE:          8192
>>  memory used by lock dependency info: 992 kB
>>  per task-struct memory footprint: 1920 bytes
>> ------------------------
>> | Locking API testsuite:
>>
>---------------------------------------------------------------------------
>-
>>                                  | spin |wlock |rlock |mutex | wsem | rsem
>|
>>
>--------------------------------------------------------------------------
>>                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok
>|
>>
>--------------------------------------------------------------------------
>>               recursive read-lock:             |  ok  |             |  ok
>|
>>            recursive read-lock #2:             |  ok  |             |  ok
>|
>>             mixed read-write-lock:             |  ok  |             |  ok
>|
>>             mixed write-read-lock:             |  ok  |             |  ok
>|
>>
>--------------------------------------------------------------------------
>>      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>>      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
>>      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>>      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
>>        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
>>        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
>>          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>>          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
>>          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>>          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
>>     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>>     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
>>       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
>>       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
>>       hard-irq read-recursion/123:  ok  |
>>       soft-irq read-recursion/123:  ok  |
>>       hard-irq read-recursion/132:  ok  |
>>       soft-irq read-recursion/132:  ok  |
>>       hard-irq read-recursion/213:  ok  |
>>       soft-irq read-recursion/213:  ok  |
>>       hard-irq read-recursion/231:  ok  |
>>       soft-irq read-recursion/231:  ok  |
>>       hard-irq read-recursion/312:  ok  |
>>       soft-irq read-recursion/312:  ok  |
>>       hard-irq read-recursion/321:  ok  |
>>       soft-irq read-recursion/321:  ok  |
>> -------------------------------------------------------
>> Good, all 218 testcases passed! |
>> ---------------------------------
>> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
>> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
>> Memory: 966876k/982464k available (2071k kernel code, 15072k reserved, 891k
>data, 272k init, 64960k highmem)
>> virtual kernel memory layout:
>>     fixmap  : 0xfffa8000 - 0xfffff000   ( 348 kB)
>>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>>       .init : 0xc03e8000 - 0xc042c000   ( 272 kB)
>>       .data : 0xc0305c2b - 0xc03e4c18   ( 891 kB)
>>       .text : 0xc0100000 - 0xc0305c2b   (2071 kB)
>> Checking if this processor honours the WP bit even in supervisor mode...Ok.
>> CPA: page pool initialized 1 of 1 pages preallocated
>> Calibrating delay using timer specific routine.. 3210.53 BogoMIPS
>(lpj=1605269)
>> Mount-cache hash table entries: 512
>> CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>> CPU: L2 Cache: 128K (64 bytes/line)
>> Intel machine check architecture supported.
>> Intel machine check reporting enabled on CPU#0.
>> Compat vDSO mapped to ffffe000.
>> CPU: AMD Mobile AMD Sempron(tm) Processor 2600+ stepping 00
>> Checking 'hlt' instruction... OK.
>> Freeing SMP alternatives: 0k freed
>> ACPI: Core revision 20070126
>> Parsing all Control Methods:
>> Table [DSDT](id 0001) - 480 Objects with 49 Devices 147 Methods 13 Regions
>> Parsing all Control Methods:
>> Table [SSDT](id 0002) - 3 Objects with 0 Devices 0 Methods 0 Regions
>>  tbxface-0598 [00] tb_load_namespace     : ACPI Tables successfully acquired
>> evxfevnt-0091 [00] enable                : Transition to ACPI mode successful
>> ENABLING IO-APIC IRQs
>> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
>> net_namespace: 604 bytes
>> NET: Registered protocol family 16
>> EISA bus registered
>> ACPI: bus type pci registered
>> PCI: PCI BIOS revision 2.10 entry at 0xfd88c, last bus=1
>> PCI: Using configuration type 1
>> Setting up standard PCI resources
>> evgpeblk-0956 [00] ev_create_gpe_block   : GPE 00 to 0F [_GPE] 2 regs on int
>0xA
>> evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 4 Wake, Enabled 0 Runtime
>GPEs in this block
>> ACPI: EC: Look up EC in DSDT
>> Completing Region/Field/Buffer/Package
>initialization:.....................................................
>> Initialized 11/13 Regions 1/1 Fields 23/24 Buffers 18/26 Packages (492 nodes)
>> Initializing Device/Processor/Thermal objects by executing _INI methods:.
>> Executed 1 _INI methods requiring 1 _STA executions (examined 53 objects)
>> ACPI: Interpreter enabled
>> ACPI: (supports S0 S3 S4 S5)
>> ACPI: Using IOAPIC for interrupt routing
>> ACPI: EC: non-query interrupt received, switching to interrupt mode
>> ACPI: EC: missing write data confirmation, don't expect it any longer.
>> ACPI: EC: GPE = 0xb, I/O: command/status = 0x66, data = 0x62
>> ACPI: EC: driver started in interrupt mode
>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>> pci 0000:00:11.0: quirk: region 4000-407f claimed by vt8235 PM
>> pci 0000:00:11.0: quirk: region 8100-810f claimed by vt8235 SMB
>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>> ACPI: PCI Interrupt Link [ALKA] (IRQs 16 17 18 19 20 21 22 23) *9, disabled.
>> ACPI: PCI Interrupt Link [ALKB] (IRQs 16 17 18 19 20 21 22 23) *11, disabled.
>> ACPI: PCI Interrupt Link [ALKC] (IRQs 22) *10, disabled.
>> ACPI: PCI Interrupt Link [ALKD] (IRQs 21) *5, disabled.
>> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 *9 12 14 15)
>> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 10 12 14 15) *11
>> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 11 12 14 15) *10
>> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 7 9 10 11 12 14 15)
>> Linux Plug and Play Support v0.97 (c) Adam Belay
>> pnp: PnP ACPI init
>> ACPI: bus type pnp registered
>> pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
>> pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
>> pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
>> pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
>> pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
>>  00:05: calling quirk 0xc025ae70: quirk_supermicro_h8dce_system+0x0/0x110()
>> pnp 00:05: Plug and Play ACPI device, IDs PNP0c01 (active)
>>  00:06: calling quirk 0xc025ae70: quirk_supermicro_h8dce_system+0x0/0x110()
>> pnp 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
>> pnp 00:07: Plug and Play ACPI device, IDs PNP0f13 (active)
>> pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
>> pnp 00:09: Plug and Play ACPI device, IDs PNP0501 (active)
>> pnp 00:0a: Plug and Play ACPI device, IDs PNP0401 (active)
>> pnp: PnP ACPI: found 11 devices
>> ACPI: ACPI bus type pnp unregistered
>> PCI: Using ACPI for IRQ routing
>> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
>> pnp: the driver 'system' has been registered
>> system 00:05: iomem range 0x0-0x9ffff could not be reserved
>> system 00:05: iomem range 0xe0000-0xfffff could not be reserved
>> system 00:05: iomem range 0xfff00000-0xffffffff could not be reserved
>> system 00:05: iomem range 0xffee0000-0xffefffff has been reserved
>> system 00:05: iomem range 0xfec00000-0xfec00fff has been reserved
>> system 00:05: iomem range 0xfee00000-0xfee00fff has been reserved
>> system 00:05: driver attached
>> system 00:06: ioport range 0x4d0-0x4d1 has been reserved
>> system 00:06: ioport range 0xfe10-0xfe11 has been reserved
>> system 00:06: ioport range 0xfe00-0xfe00 has been reserved
>> system 00:06: ioport range 0x4000-0x407f has been reserved
>> system 00:06: ioport range 0x8100-0x811f could not be reserved
>> Time: tsc clocksource has been installed.
>> system 00:06: driver attached
>> PCI: Bridge: 0000:00:01.0
>>   IO window: disabled.
>>   MEM window: 0xd1000000-0xd1ffffff
>>   PREFETCH window: 0x00000000f0000000-0x00000000f3ffffff
>> PCI: Bus 2, cardbus bridge: 0000:00:0c.0
>>   IO window: 0x00002000-0x000020ff
>>   IO window: 0x00002400-0x000024ff
>>   PREFETCH window: 0x50000000-0x53ffffff
>>   MEM window: 0x54000000-0x57ffffff
>> PCI: Setting latency timer of device 0000:00:01.0 to 64
>> PCI: Enabling device 0000:00:0c.0 (0000 -> 0003)
>> ACPI: PCI Interrupt 0000:00:0c.0[A] -> GSI 16 (level, low) -> IRQ 16
>> PCI: Setting latency timer of device 0000:00:0c.0 to 64
>> NET: Registered protocol family 2
>> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
>> TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
>> TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
>> TCP: Hash tables configured (established 131072 bind 65536)
>> TCP reno registered
>> audit: initializing netlink socket (disabled)
>> type=2000 audit(1204788516.711:1): initialized
>> highmem bounce pool size: 64 pages
>> io scheduler noop registered
>> io scheduler cfq registered (default)
>> PCI: VIA PCI bridge detected. Disabling DAC.
>> pci 0000:01:00.0: Boot video device
>> isapnp: Scanning for PnP cards...
>> isapnp: No Plug & Play device found
>> Uniform Multi-Platform E-IDE driver
>> ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
>> VP_IDE: IDE controller (0x1106:0x0571 rev 0x06) at  PCI slot 0000:00:11.1
>> ACPI: PCI Interrupt Link [ALKA] disabled and referenced, BIOS bug
>> ACPI: PCI Interrupt Link [ALKA] BIOS reported IRQ 0, using IRQ 23
>> ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 23
>> ACPI: PCI Interrupt 0000:00:11.1[A] -> Link [ALKA] -> GSI 23 (level, low) ->
>IRQ 23
>> VP_IDE: not 100% native mode: will probe irqs later
>> VP_IDE: VIA vt8235 (rev 00) IDE UDMA133 controller on pci0000:00:11.1
>>     ide0: BM-DMA at 0x1c60-0x1c67, BIOS settings: hda:DMA, hdb:PIO
>>     ide1: BM-DMA at 0x1c68-0x1c6f, BIOS settings: hdc:DMA, hdd:PIO
>> Probing IDE interface ide0...
>> Switched to high resolution mode on CPU 0
>> hdb: IRQ probe failed (0xfffffbfe)
>> hdb: IRQ probe failed (0xfffffbfe)
>> hda: SAMSUNG MP0804H, ATA DISK drive
>> hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
>> hda: UDMA/100 mode selected
>> Probing IDE interface ide1...
>> hdc: Optiarc DVD RW AD-7543A, ATAPI CD/DVD-ROM drive
>> hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
>> hdc: UDMA/33 mode selected
>> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>> ide1 at 0x170-0x177,0x376 on irq 15
>> pnp: the driver 'ide' has been registered
>> hda: max request size: 512KiB
>> hda: 156368016 sectors (80060 MB) w/8192KiB Cache, CHS=16383/255/63
>> hda: cache flushes supported
>>  hda: hda1 hda2 hda3
>> TCP cubic registered
>> NET: Registered protocol family 1
>> NET: Registered protocol family 17
>> Using IPI Shortcut mode
>> ReiserFS: hda3: found reiserfs format "3.6" with standard journal
>> ReiserFS: hda3: using ordered data mode
>> ReiserFS: hda3: journal params: device hda3, size 8192, journal first block
>18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
>> ReiserFS: hda3: checking transaction log (hda3)
>> ReiserFS: hda3: Using r5 hash to sort names
>> VFS: Mounted root (reiserfs filesystem) readonly.
>> Freeing unused kernel memory: 272k freed
>> Write protecting the kernel read-only data: 732k
>> ACPI: CPU0 (power states: C1[C1] C2[C2])
>> ACPI: ACPI0007:00 is registered as cooling_device0
>> input: Power Button (FF) as /class/input/input0
>> ACPI: Power Button (FF) [PWRF]
>> input: Power Button (CM) as /class/input/input1
>> ACPI: Power Button (CM) [PWB]
>> input: Sleep Button (CM) as /class/input/input2
>> ACPI: Sleep Button (CM) [SLPB]
>> input: Lid Switch as /class/input/input3
>> ACPI: Lid Switch [LID]
>> ACPI: LNXTHERM:01 is registered as thermal_zone0
>> ACPI: Thermal Zone [THRM] (14 C)
>> ACPI: AC Adapter [AC] (on-line)
>> ACPI: Battery Slot [BAT0] (battery present)
>> Yenta: CardBus bridge found at 0000:00:0c.0 [1558:4702]
>> Yenta: Using CSCINT to route CSC interrupts to PCI
>> Yenta: Routing CardBus interrupts to PCI
>> Yenta TI: socket 0000:00:0c.0, mfunc 0x00001002, devctl 0x44
>> 8139too Fast Ethernet driver 0.9.28
>> hdc: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
>> Uniform CD-ROM driver Revision: 3.20
>> Yenta: ISA IRQ mask 0x0840, PCI irq 16
>> Socket status: 30000006
>> ACPI: PCI Interrupt 0000:00:08.0[A] -> GSI 19 (level, low) -> IRQ 19
>> eth0: RealTek RTL8139 at 0xf88fa000, 00:90:f5:3e:5a:ca, IRQ 19
>> eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
>> Marking TSC unstable due to: possible TSC halt in C2.
>> Time: acpi_pm clocksource has been installed.
>> usbcore: registered new interface driver usbfs
>> usbcore: registered new interface driver hub
>> usbcore: registered new device driver usb
>> input: PC Speaker as /class/input/input4
>> pnp: the driver 'parport_pc' has been registered
>> parport_pc 00:0a: reported by Plug and Play ACPI
>> parport0: PC-style at 0x378 (0x778), irq 7, dma 1
>[PCSPP,TRISTATE,COMPAT,ECP,DMA]
>> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
>> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> Real Time Clock Driver v1.12ac
>> parport_pc 00:0a: driver attached
>> USB Universal Host Controller Interface driver v3.0
>> ACPI: PCI Interrupt Link [ALKD] disabled and referenced, BIOS bug
>> ACPI: PCI Interrupt Link [ALKD] BIOS reported IRQ 0, using IRQ 21
>> ACPI: PCI Interrupt Link [ALKD] enabled at IRQ 21
>> ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [ALKD] -> GSI 21 (level, low) ->
>IRQ 21
>> uhci_hcd 0000:00:10.0: UHCI Host Controller
>> uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 1
>> uhci_hcd 0000:00:10.0: irq 21, io base 0x00001c00
>> usb usb1: configuration #1 chosen from 1 choice
>> hub 1-0:1.0: USB hub found
>> hub 1-0:1.0: 2 ports detected
>> ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [ALKD] -> GSI 21 (level, low) ->
>IRQ 21
>> uhci_hcd 0000:00:10.1: UHCI Host Controller
>> uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 2
>> uhci_hcd 0000:00:10.1: irq 21, io base 0x00001c20
>> usb usb2: configuration #1 chosen from 1 choice
>> hub 2-0:1.0: USB hub found
>> hub 2-0:1.0: 2 ports detected
>> ACPI: PCI Interrupt 0000:00:10.2[C] -> Link [ALKD] -> GSI 21 (level, low) ->
>IRQ 21
>> uhci_hcd 0000:00:10.2: UHCI Host Controller
>> uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 3
>> uhci_hcd 0000:00:10.2: irq 21, io base 0x00001c40
>> usb usb3: configuration #1 chosen from 1 choice
>> hub 3-0:1.0: USB hub found
>> hub 3-0:1.0: 2 ports detected
>> pnp: the driver 'serial' has been registered
>> 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> serial 00:09: driver attached
>> ACPI: PCI Interrupt 0000:00:10.3[D] -> Link [ALKD] -> GSI 21 (level, low) ->
>IRQ 21
>> ehci_hcd 0000:00:10.3: EHCI Host Controller
>> ehci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 4
>> ehci_hcd 0000:00:10.3: irq 21, io mem 0xd0004400
>> ehci_hcd 0000:00:10.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
>> usb usb4: configuration #1 chosen from 1 choice
>> hub 4-0:1.0: USB hub found
>> hub 4-0:1.0: 6 ports detected
>> cs: IO port probe 0x100-0x4ff: clean.
>> cs: IO port probe 0x800-0x8ff: clean.
>> cs: IO port probe 0xc00-0xcff: clean.
>> cs: IO port probe 0xa00-0xaff: clean.
>> ACPI: PCI Interrupt Link [ALKC] disabled and referenced, BIOS bug
>> ACPI: PCI Interrupt Link [ALKC] BIOS reported IRQ 0, using IRQ 22
>> ACPI: PCI Interrupt Link [ALKC] enabled at IRQ 22
>> ACPI: PCI Interrupt 0000:00:11.6[C] -> Link [ALKC] -> GSI 22 (level, low) ->
>IRQ 22
>> PCI: Setting latency timer of device 0000:00:11.6 to 64
>> ACPI: PCI Interrupt 0000:00:11.5[C] -> Link [ALKC] -> GSI 22 (level, low) ->
>IRQ 22
>> PCI: Setting latency timer of device 0000:00:11.5 to 64
>> Adding 1951888k swap on /dev/hda2.  Priority:-1 extents:1 across:1951888k
>> pnp: the driver 'i8042 kbd' has been registered
>> i8042 kbd 00:08: driver attached
>> pnp: the driver 'i8042 aux' has been registered
>> i8042 aux 00:07: driver attached
>> PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
>> i8042.c: Detected active multiplexing controller, rev 1.1.
>> serio: i8042 KBD port at 0x60,0x64 irq 1
>> serio: i8042 AUX0 port at 0x60,0x64 irq 12
>> serio: i8042 AUX1 port at 0x60,0x64 irq 12
>> serio: i8042 AUX2 port at 0x60,0x64 irq 12
>> serio: i8042 AUX3 port at 0x60,0x64 irq 12
>> input: AT Translated Set 2 keyboard as /class/input/input5
>> powernow-k8: Found 1 Mobile AMD Sempron(tm) Processor 2600+ processors (1 cpu
>cores) (version 2.20.00)
>> powernow-k8:    0 : fid 0x8 (1600 MHz), vid 0x6
>> powernow-k8:    1 : fid 0x0 (800 MHz), vid 0x18
>> powernow-k8: ph2 null fid transition 0x8
>> input: PS/2 Mouse as /class/input/input6
>> input: AlpsPS/2 ALPS GlidePoint as /class/input/input7
>> mice: PS/2 mouse device common for all mice
>> Linux agpgart interface v0.103
>> [drm] Initialized drm 1.1.0 20060810
>> ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
>> [drm] Initialized via 2.11.1 20070202 on minor 0
>> leds_clevo_mail: 'Clevo D410J' found
>> Registered led device: clevo::mail
>> ACPI Exception (thermal-0514): AE_ERROR, ACPI thermal trip point state changed
>> Please send acpidump to linux-acpi@vger.kernel.org
>>  [20070126]
>> ReiserFS: hda1: found reiserfs format "3.6" with standard journal
>> ReiserFS: hda1: using ordered data mode
>> ReiserFS: hda1: journal params: device hda1, size 8192, journal first block
>18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
>> ReiserFS: hda1: checking transaction log (hda1)
>> ReiserFS: hda1: Using r5 hash to sort names
>> ip_tables: (C) 2000-2006 Netfilter Core Team
>> eth0: link up, 100Mbps, full-duplex, lpa 0x41E1
>> NET: Registered protocol family 10
>> lp0: using parport0 (interrupt-driven).
>> ppdev: user-space parallel port driver
>> Clocksource tsc unstable (delta = -282353088 ns)
>> eth0: no IPv6 routers present
>> warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
>> irq 16: nobody cared (try booting with the "irqpoll" option)
>> Pid: 0, comm: swapper Not tainted 2.6.25-rc4 #1
>>  [<c0157227>] __report_bad_irq+0x27/0x90
>>  [<c01574c6>] note_interrupt+0x236/0x270
>>  [<c01568d3>] ? handle_IRQ_event+0x53/0x60
>>  [<c0157b6a>] handle_fasteoi_irq+0x7a/0xd0
>>  [<c0106174>] do_IRQ+0x44/0xa0
>>  [<c0104c66>] common_interrupt+0x2e/0x34
>>  [<c0301ac8>] ? _spin_unlock_irq+0x28/0x50
>>  [<c0118974>] finish_task_switch+0x54/0xc0
>>  [<c0118920>] ? finish_task_switch+0x0/0xc0
>>  [<c02ff326>] schedule+0x2b6/0x470
>>  [<f892fdae>] ? acpi_processor_idle+0x0/0x436 [processor]
>>  [<c0102b65>] cpu_idle+0xb5/0xd0
>>  [<c02fa66c>] rest_init+0x5c/0x60
>>  =======================
>> handlers:
>> [<f8915830>] (yenta_interrupt+0x0/0xe0 [yenta_socket])
>> [<f8aee3f0>] (via_driver_irq_handler+0x0/0x1c0 [via])
>> Disabling IRQ #16
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
