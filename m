Return-Path: <linux-kernel-owner+w=401wt.eu-S933144AbXCURfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144AbXCURfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933196AbXCURfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:35:45 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:2017 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144AbXCURfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:35:41 -0400
Date: Wed, 21 Mar 2007 19:28:53 +0200
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [2/6] 2.6.21-rc2: known regressions
Message-ID: <20070321172853.GB5233@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	<20070305015034.GG3441@stusta.de>
	<20070308123143.GF5149@mellanox.co.il>
	<Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org>
	<20070308195735.GG17114@mellanox.co.il>
	<20070311120802.GA8823@elte.hu>
	<20070312201820.GA8995@mellanox.co.il>
	<20070317214136.GE4466@mellanox.co.il>
	<1174170796.13341.431.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <1174170796.13341.431.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> Quoting Thomas Gleixner <tglx@linutronix.de>:
> Subject: Re: [2/6] 2.6.21-rc2: known regressions
> 
> On Sat, 2007-03-17 at 23:41 +0200, Michael S. Tsirkin wrote:
> > > > a quick ping: on your box that doesnt resume - if you can log in over 
> > > > the network after resume (or somehow run shell commands), does 'date' 
> > > > advance properly or not? (or do you not get that far to be able to 
> > > > tell?)
> > > > 
> > > > 	Ingo
> > > 
> > > I just retested - 'date' does not advance after resume for me.
> > > This is with NO_HZ *not* set.
> > > Sorry it took so long.
> > 
> > Update: just re-tested with 2.6.21-rc4, same behaviour: date
> > does not advance after resume from ram.
> 
> Can you get a full dmesg from boot to resume out of the box ?
> 
> 	tglx

Here it is.
Symptoms:
1. after resume, takes up to 1 min to enable disk
2. date does not advance after resume

-- 
MST

--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=bootlog2

[    0.000000] Linux version 2.6.21-rc4-work (mst@mst-lt) (gcc version 4.0.3 (Ubuntu 4.0.3-1ubuntu5)) #5 SMP Wed Mar 21 18:13:10 IST 2007
[    0.000000] BIOS-provided physical RAM map:
[    0.000000] sanitize start
[    0.000000] sanitize end
[    0.000000] copy_e820_map() start: 0000000000000000 size: 000000000009f000 end: 000000000009f000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000000009f000 size: 0000000000001000 end: 00000000000a0000 type: 2
[    0.000000] copy_e820_map() start: 00000000000d2000 size: 0000000000002000 end: 00000000000d4000 type: 2
[    0.000000] copy_e820_map() start: 00000000000dc000 size: 0000000000024000 end: 0000000000100000 type: 2
[    0.000000] copy_e820_map() start: 0000000000100000 size: 000000003f5e0000 end: 000000003f6e0000 type: 1
[    0.000000] copy_e820_map() type is E820_RAM
[    0.000000] copy_e820_map() start: 000000003f6e0000 size: 0000000000013000 end: 000000003f6f3000 type: 3
[    0.000000] copy_e820_map() start: 000000003f6f3000 size: 000000000000d000 end: 000000003f700000 type: 4
[    0.000000] copy_e820_map() start: 000000003f700000 size: 0000000000900000 end: 0000000040000000 type: 2
[    0.000000] copy_e820_map() start: 00000000f0000000 size: 0000000004000000 end: 00000000f4000000 type: 2
[    0.000000] copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed00000 size: 0000000000000400 end: 00000000fed00400 type: 2
[    0.000000] copy_e820_map() start: 00000000fed14000 size: 0000000000006000 end: 00000000fed1a000 type: 2
[    0.000000] copy_e820_map() start: 00000000fed1c000 size: 0000000000074000 end: 00000000fed90000 type: 2
[    0.000000] copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
[    0.000000] copy_e820_map() start: 00000000ff800000 size: 0000000000800000 end: 0000000100000000 type: 2
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
[    0.000000]  BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f6e0000 (usable)
[    0.000000]  BIOS-e820: 000000003f6e0000 - 000000003f6f3000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003f6f3000 - 000000003f700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
[    0.000000] Warning only 896MB will be used.
[    0.000000] Use a HIGHMEM enabled kernel.
[    0.000000] 896MB LOWMEM available.
[    0.000000] found SMP MP-table at 000f68e0
[    0.000000] Entering add_active_range(0, 0, 229376) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   229376
[    0.000000] On node 0 totalpages: 229376
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000] DMI present.
[    0.000000] ACPI: RSDP 000F68A0, 0024 (r2 LENOVO)
[    0.000000] ACPI: XSDT 3F6E63A2, 0074 (r1 LENOVO TP-79        1051  LTP        0)
[    0.000000] ACPI: FACP 3F6E6500, 00F4 (r3 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI Warning (tbfadt-0420): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
[    0.000000] ACPI: DSDT 3F6E66E7, C6E2 (r1 LENOVO TP-79        1051 MSFT  100000E)
[    0.000000] ACPI: FACS 3F6F4000, 0040
[    0.000000] ACPI: SSDT 3F6E66B4, 0033 (r1 LENOVO TP-79        1051 MSFT  100000E)
[    0.000000] ACPI: ECDT 3F6F2DC9, 0052 (r1 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI: TCPA 3F6F2E1B, 0032 (r2 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI: APIC 3F6F2E4D, 0068 (r1 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI: MCFG 3F6F2EB5, 003E (r1 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI: HPET 3F6F2EF3, 0038 (r1 LENOVO TP-79        1051 LNVO        1)
[    0.000000] ACPI: BOOT 3F6F2FD8, 0028 (r1 LENOVO TP-79        1051  LTP        1)
[    0.000000] ACPI: SSDT 3F6E595D, 0507 (r1 LENOVO TP-79        1051 INTL 20050513)
[    0.000000] ACPI: SSDT 3F6E5785, 01D8 (r1 LENOVO TP-79        1051 INTL 20050513)
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 6:14 APIC version 20
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 6:14 APIC version 20
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] Built 1 zonelists.  Total pages: 227584
[    0.000000] Kernel command line: root=/dev/sda3 ro splash
[    0.000000] mapped APIC to ffffd000 (fee00000)
[    0.000000] mapped IOAPIC to ffffc000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 1828.761 MHz processor.
[   11.745696] Console: colour VGA+ 80x25
[   11.751844] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[   11.752430] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[   11.777663] Memory: 904220k/917504k available (2935k kernel code, 12876k reserved, 1333k data, 184k init, 0k highmem)
[   11.777766] virtual kernel memory layout:
[   11.777768]     fixmap  : 0xfffb7000 - 0xfffff000   ( 288 kB)
[   11.777770]     vmalloc : 0xf8800000 - 0xfffb5000   ( 119 MB)
[   11.777773]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[   11.777775]       .init : 0xc0532000 - 0xc0560000   ( 184 kB)
[   11.777777]       .data : 0xc03ddc81 - 0xc052b190   (1333 kB)
[   11.777779]       .text : 0xc0100000 - 0xc03ddc81   (2935 kB)
[   11.778246] Checking if this processor honours the WP bit even in supervisor mode... Ok.
[   11.928280] Calibrating delay using timer specific routine.. 3661.21 BogoMIPS (lpj=18306090)
[   11.928482] Mount-cache hash table entries: 512
[   11.928687] CPU: After generic identify, caps: bfe9fbff 00000000 00000000 00000000 0000c1a9 00000000 00000000
[   11.928698] monitor/mwait feature present.
[   11.928766] using mwait in idle threads.
[   11.928837] CPU: L1 I cache: 32K, L1 D cache: 32K
[   11.928950] CPU: L2 cache: 2048K
[   11.929016] CPU: Physical Processor ID: 0
[   11.929083] CPU: Processor Core ID: 0
[   11.929149] CPU: After all inits, caps: bfe9fbff 00000000 00000000 00002940 0000c1a9 00000000 00000000
[   11.929159] Intel machine check architecture supported.
[   11.929235] Intel machine check reporting enabled on CPU#0.
[   11.929307] Compat vDSO mapped to ffffe000.
[   11.929386] Checking 'hlt' instruction... OK.
[   11.968411] SMP alternatives: switching to UP code
[   11.968822] ACPI: Core revision 20070126
[   12.001702] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[   12.001945] SMP alternatives: switching to SMP code
[   12.002065] Booting processor 1/1 eip 3000
[   12.013090] Initializing CPU#1
[   12.158203] Calibrating delay using timer specific routine.. 3657.59 BogoMIPS (lpj=18287992)
[   12.158212] CPU: After generic identify, caps: bfe9fbff 00000000 00000000 00000000 0000c1a9 00000000 00000000
[   12.158221] monitor/mwait feature present.
[   12.158226] CPU: L1 I cache: 32K, L1 D cache: 32K
[   12.158229] CPU: L2 cache: 2048K
[   12.158233] CPU: Physical Processor ID: 0
[   12.158235] CPU: Processor Core ID: 1
[   12.158238] CPU: After all inits, caps: bfe9fbff 00000000 00000000 00002940 0000c1a9 00000000 00000000
[   12.158247] Intel machine check architecture supported.
[   12.158256] Intel machine check reporting enabled on CPU#1.
[   12.158528] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[   12.159377] Total of 2 processors activated (7318.81 BogoMIPS).
[   12.159644] ENABLING IO-APIC IRQs
[   12.159938] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[   12.497483] checking TSC synchronization [CPU#0 -> CPU#1]:
[   12.517575] Measured 578974 cycles TSC warp between CPUs, turning off TSC clock.
[   12.517674] Brought up 2 CPUs
[   12.823444] migration_cost=78
[   12.823392] PM: Adding info for No Bus:platform
[   12.823577] NET: Registered protocol family 16
[   12.823836] PM: Adding info for platform:dock.0
[   12.824223] ACPI: ACPI Dock Station Driver 
[   12.824311] PM: Adding info for No Bus:vtcon0
[   12.824360] ACPI: bus type pci registered
[   12.824439] PCI: Using MMCONFIG
[   12.825412] Setting up standard PCI resources
[   12.844565] ACPI: Interpreter enabled
[   12.844634] ACPI: (supports S0 S3 S4 S5)
[   12.844952] ACPI: Using IOAPIC for interrupt routing
[   12.845158] PM: Adding info for acpi:acpi_system:00
[   12.845224] PM: Adding info for acpi:button_power:00
[   12.845289] PM: Adding info for acpi:ACPI0007:00
[   12.845352] PM: Adding info for acpi:ACPI0007:01
[   12.845429] PM: Adding info for acpi:device:00
[   12.845991] PM: Adding info for acpi:PNP0C0F:00
[   12.846542] PM: Adding info for acpi:PNP0C0F:01
[   12.847114] PM: Adding info for acpi:PNP0C0F:02
[   12.847654] PM: Adding info for acpi:PNP0C0F:03
[   12.848197] PM: Adding info for acpi:PNP0C0F:04
[   12.848739] PM: Adding info for acpi:PNP0C0F:05
[   12.849284] PM: Adding info for acpi:PNP0C0F:06
[   12.849824] PM: Adding info for acpi:PNP0C0F:07
[   12.849903] PM: Adding info for acpi:PNP0C01:00
[   12.850104] PM: Adding info for acpi:PNP0C0D:00
[   12.850294] PM: Adding info for acpi:PNP0C0E:00
[   12.850375] PM: Adding info for acpi:PNP0A08:00
[   12.850468] PM: Adding info for acpi:device:01
[   12.850549] PM: Adding info for acpi:PNP0C02:00
[   12.850640] PM: Adding info for acpi:PNP0000:00
[   12.850712] PM: Adding info for acpi:PNP0100:00
[   12.851021] PM: Adding info for acpi:PNP0103:00
[   12.851098] PM: Adding info for acpi:PNP0200:00
[   12.851172] PM: Adding info for acpi:PNP0800:00
[   12.851254] PM: Adding info for acpi:PNP0C04:00
[   12.851331] PM: Adding info for acpi:PNP0B00:00
[   12.851407] PM: Adding info for acpi:PNP0303:00
[   12.851484] PM: Adding info for acpi:IBM0057:00
[   12.853544] PM: Adding info for acpi:IBM0071:00
[   12.853773] PM: Adding info for acpi:PNP0C09:00
[   12.853884] PM: Adding info for acpi:power_resource:00
[   12.854416] PM: Adding info for acpi:PNP0C0A:00
[   12.854901] PM: Adding info for acpi:ACPI0003:00
[   12.855162] PM: Adding info for acpi:IBM0068:00
[   12.855296] PM: Adding info for acpi:video:00
[   12.855375] PM: Adding info for acpi:device:02
[   12.855449] PM: Adding info for acpi:device:03
[   12.855537] PM: Adding info for acpi:device:04
[   12.855623] PM: Adding info for acpi:device:05
[   12.855708] PM: Adding info for acpi:video:01
[   12.855787] PM: Adding info for acpi:device:06
[   12.855862] PM: Adding info for acpi:device:07
[   12.855939] PM: Adding info for acpi:device:08
[   12.856030] PM: Adding info for acpi:device:09
[   12.856119] PM: Adding info for acpi:device:0a
[   12.856205] PM: Adding info for acpi:device:0b
[   12.856286] PM: Adding info for acpi:device:0c
[   12.856369] PM: Adding info for acpi:device:0d
[   12.856448] PM: Adding info for acpi:device:0e
[   12.856532] PM: Adding info for acpi:device:0f
[   12.856718] PM: Adding info for acpi:device:10
[   12.856803] PM: Adding info for acpi:device:11
[   12.856899] PM: Adding info for acpi:device:12
[   12.857626] PM: Adding info for acpi:bay:00
[   12.857729] PM: Adding info for acpi:device:13
[   12.857827] PM: Adding info for acpi:device:14
[   12.857908] PM: Adding info for acpi:device:15
[   12.858022] PM: Adding info for acpi:device:16
[   12.858120] PM: Adding info for acpi:device:17
[   12.858198] PM: Adding info for acpi:device:18
[   12.858271] PM: Adding info for acpi:device:19
[   12.858382] PM: Adding info for acpi:device:1a
[   12.858462] PM: Adding info for acpi:device:1b
[   12.858543] PM: Adding info for acpi:device:1c
[   12.858624] PM: Adding info for acpi:device:1d
[   12.858733] PM: Adding info for acpi:device:1e
[   12.858814] PM: Adding info for acpi:device:1f
[   12.858890] PM: Adding info for acpi:device:20
[   12.858972] PM: Adding info for acpi:device:21
[   12.859057] PM: Adding info for acpi:device:22
[   12.859834] PM: Adding info for acpi:thermal:00
[   12.859899] PM: Adding info for acpi:thermal:01
[   12.859962] PM: Adding info for acpi:thermal:02
[   12.860597] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   12.860676] PCI: Probing PCI hardware (bus 00)
[   12.860689] PM: Adding info for No Bus:pci0000:00
[   12.860786] Boot video device is 0000:00:02.0
[   12.861391] PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[   12.861465] PCI quirk: region 1180-11bf claimed by ICH6 GPIO
[   12.861585] 0000:00:1f.1: trying to change BAR0 from 0000 to 01F0
[   12.861658] 0000:00:1f.1: trying to change BAR1 from 0000 to 03F4
[   12.861730] 0000:00:1f.1: trying to change BAR2 from 0000 to 0170
[   12.861803] 0000:00:1f.1: trying to change BAR3 from 0000 to 0374
[   12.863027] PCI: Transparent bridge - 0000:00:1e.0
[   12.863250] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   12.863563] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
[   12.863784] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[   12.864005] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
[   12.864233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
[   12.864458] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[   12.864916] PM: Adding info for pci:0000:00:00.0
[   12.865159] PM: Adding info for pci:0000:00:02.0
[   12.865392] PM: Adding info for pci:0000:00:02.1
[   12.865625] PM: Adding info for pci:0000:00:1b.0
[   12.865865] PM: Adding info for pci:0000:00:1c.0
[   12.866100] PM: Adding info for pci:0000:00:1c.1
[   12.866332] PM: Adding info for pci:0000:00:1c.2
[   12.866564] PM: Adding info for pci:0000:00:1c.3
[   12.866829] PM: Adding info for pci:0000:00:1d.0
[   12.867063] PM: Adding info for pci:0000:00:1d.1
[   12.867295] PM: Adding info for pci:0000:00:1d.2
[   12.867532] PM: Adding info for pci:0000:00:1d.3
[   12.867764] PM: Adding info for pci:0000:00:1d.7
[   12.867995] PM: Adding info for pci:0000:00:1e.0
[   12.868231] PM: Adding info for pci:0000:00:1f.0
[   12.868464] PM: Adding info for pci:0000:00:1f.1
[   12.868696] PM: Adding info for pci:0000:00:1f.2
[   12.868936] PM: Adding info for pci:0000:00:1f.3
[   12.869003] PM: Adding info for pci:0000:02:00.0
[   12.869070] PM: Adding info for pci:0000:03:00.0
[   12.869244] PM: Adding info for pci:0000:15:00.0
[   12.869647] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[   12.870534] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
[   12.871418] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
[   12.872300] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[   12.873181] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[   12.874062] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
[   12.874946] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
[   12.875829] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
[   12.876843] ACPI: Power Resource [PUBS] (on)
[   12.876943] Linux Plug and Play Support v0.97 (c) Adam Belay
[   12.877022] pnp: PnP ACPI init
[   12.877099] PM: Adding info for No Bus:pnp0
[   12.879323] PM: Adding info for pnp:00:00
[   12.879416] PM: Adding info for pnp:00:01
[   12.879496] PM: Adding info for pnp:00:02
[   12.879690] PM: Adding info for pnp:00:03
[   12.879756] PM: Adding info for pnp:00:04
[   12.879817] PM: Adding info for pnp:00:05
[   12.879891] PM: Adding info for pnp:00:06
[   12.879959] PM: Adding info for pnp:00:07
[   12.880027] PM: Adding info for pnp:00:08
[   12.880094] PM: Adding info for pnp:00:09
[   12.881965] PM: Adding info for pnp:00:0a
[   12.883808] pnp: PnP ACPI: found 11 devices
[   12.884882] SCSI subsystem initialized
[   12.884999] libata version 2.20 loaded.
[   12.885078] usbcore: registered new interface driver usbfs
[   12.885198] usbcore: registered new interface driver hub
[   12.885322] usbcore: registered new device driver usb
[   12.885493] PCI: Using ACPI for IRQ routing
[   12.885561] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[   12.886025] pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
[   12.886098] pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
[   12.886172] pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
[   12.886246] pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
[   12.886325] pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
[   12.886412] pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[   12.886500] pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
[   12.886588] pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
[   12.886676] Time: hpet clocksource has been installed.
[   12.886796] PM: Adding info for No Bus:mem
[   12.886840] PM: Adding info for No Bus:kmem
[   12.886881] PM: Adding info for No Bus:null
[   12.886923] PM: Adding info for No Bus:port
[   12.886963] PM: Adding info for No Bus:zero
[   12.887010] PM: Adding info for No Bus:full
[   12.887051] PM: Adding info for No Bus:random
[   12.887092] PM: Adding info for No Bus:urandom
[   12.887133] PM: Adding info for No Bus:kmsg
[   12.917175] PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
[   12.917250] PCI: Bridge: 0000:00:1c.0
[   12.917318]   IO window: 2000-2fff
[   12.917388]   MEM window: ee000000-ee0fffff
[   12.917457]   PREFETCH window: disabled.
[   12.917527] PCI: Bridge: 0000:00:1c.1
[   12.917595]   IO window: 3000-4fff
[   12.917664]   MEM window: ec000000-edffffff
[   12.917735]   PREFETCH window: e4000000-e40fffff
[   12.917806] PCI: Bridge: 0000:00:1c.2
[   12.917873]   IO window: 5000-6fff
[   12.917943]   MEM window: e8000000-e9ffffff
[   12.918013]   PREFETCH window: e4100000-e41fffff
[   12.918084] PCI: Bridge: 0000:00:1c.3
[   12.918151]   IO window: 7000-8fff
[   12.918221]   MEM window: ea000000-ebffffff
[   12.918290]   PREFETCH window: e4200000-e42fffff
[   12.918366] PCI: Bus 22, cardbus bridge: 0000:15:00.0
[   12.918435]   IO window: 00009000-000090ff
[   12.918506]   IO window: 00009400-000094ff
[   12.918577]   PREFETCH window: e0000000-e3ffffff
[   12.918648]   MEM window: 50000000-53ffffff
[   12.918719] PCI: Bridge: 0000:00:1e.0
[   12.918786]   IO window: 9000-cfff
[   12.918855]   MEM window: e4300000-e7ffffff
[   12.918926]   PREFETCH window: e0000000-e3ffffff
[   12.919022] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
[   12.919158] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   12.919182] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
[   12.919317] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   12.919340] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
[   12.919475] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   12.919498] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
[   12.919633] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   12.919645] PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
[   12.919720] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[   12.919740] ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[   12.919912] NET: Registered protocol family 2
[   13.016480] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   13.016657] TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
[   13.018505] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[   13.019198] TCP: Hash tables configured (established 131072 bind 65536)
[   13.019270] TCP reno registered
[   13.046541] Simple Boot Flag at 0x35 set to 0x1
[   13.047398] PM: Adding info for platform:pcspkr
[   13.047625] PM: Adding info for No Bus:snapshot
[   13.048056] NTFS driver 2.1.28 [Flags: R/W].
[   13.048161] fuse init (API version 7.8)
[   13.048254] PM: Adding info for No Bus:fuse
[   13.048388] io scheduler noop registered
[   13.048517] io scheduler cfq registered (default)
[   13.048989] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[   13.049043] assign_interrupt_mode Found MSI capability
[   13.049114] Allocate Port Service[0000:00:1c.0:pcie00]
[   13.049123] PM: Adding info for pci_express:0000:00:1c.0:pcie00
[   13.049170] Allocate Port Service[0000:00:1c.0:pcie02]
[   13.049179] PM: Adding info for pci_express:0000:00:1c.0:pcie02
[   13.049225] Allocate Port Service[0000:00:1c.0:pcie03]
[   13.049234] PM: Adding info for pci_express:0000:00:1c.0:pcie03
[   13.049340] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[   13.049393] assign_interrupt_mode Found MSI capability
[   13.049464] Allocate Port Service[0000:00:1c.1:pcie00]
[   13.049473] PM: Adding info for pci_express:0000:00:1c.1:pcie00
[   13.049518] Allocate Port Service[0000:00:1c.1:pcie02]
[   13.049527] PM: Adding info for pci_express:0000:00:1c.1:pcie02
[   13.049572] Allocate Port Service[0000:00:1c.1:pcie03]
[   13.049586] PM: Adding info for pci_express:0000:00:1c.1:pcie03
[   13.049689] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[   13.049742] assign_interrupt_mode Found MSI capability
[   13.049812] Allocate Port Service[0000:00:1c.2:pcie00]
[   13.049821] PM: Adding info for pci_express:0000:00:1c.2:pcie00
[   13.049867] Allocate Port Service[0000:00:1c.2:pcie02]
[   13.049875] PM: Adding info for pci_express:0000:00:1c.2:pcie02
[   13.049920] Allocate Port Service[0000:00:1c.2:pcie03]
[   13.049929] PM: Adding info for pci_express:0000:00:1c.2:pcie03
[   13.050032] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[   13.050085] assign_interrupt_mode Found MSI capability
[   13.050155] Allocate Port Service[0000:00:1c.3:pcie00]
[   13.050163] PM: Adding info for pci_express:0000:00:1c.3:pcie00
[   13.050215] Allocate Port Service[0000:00:1c.3:pcie02]
[   13.050224] PM: Adding info for pci_express:0000:00:1c.3:pcie02
[   13.050272] Allocate Port Service[0000:00:1c.3:pcie03]
[   13.050280] PM: Adding info for pci_express:0000:00:1c.3:pcie03
[   13.050441] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   13.050512] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[   13.058733] acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_find_acpi_device:  Failed to get device information<3>acpiphp_ibm: ibm_acpiphp_init: acpi_walk_namespace failed
[   13.063910] PM: Adding info for platform:vesafb.0
[   13.064266] ACPI: AC Adapter [AC] (off-line)
[   13.072884] ACPI: Battery Slot [BAT0] (battery present)
[   13.073123] input: Power Button (FF) as /class/input/input0
[   13.073194] ACPI: Power Button (FF) [PWRF]
[   13.073359] input: Lid Switch as /class/input/input1
[   13.073432] ACPI: Lid Switch [LID]
[   13.073584] input: Sleep Button (CM) as /class/input/input2
[   13.073659] ACPI: Sleep Button (CM) [SLPB]
[   13.074248] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   13.074607] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[   13.075207] ACPI: SSDT 3F6E6121, 01ED (r1  PmRef  Cpu0Ist      100 INTL 20050513)
[   13.075894] ACPI: SSDT 3F6E5E64, 0238 (r1  PmRef  Cpu0Cst      100 INTL 20050513)
[   13.077471] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   13.077727] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.078288] ACPI: SSDT 3F6E630E, 0094 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
[   13.078953] ACPI: SSDT 3F6E609C, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
[   13.080482] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   13.080736] ACPI: Processor [CPU1] (supports 8 throttling states)
[   13.089078] ACPI: Thermal Zone [THM0] (47 C)
[   13.091466] ACPI: Thermal Zone [THM1] (47 C)
[   13.091612] ibm_acpi: IBM ThinkPad ACPI Extras v0.13
[   13.091680] ibm_acpi: http://ibm-acpi.sf.net/
[   13.091747] ibm_acpi: ThinkPad EC firmware 79HT43WW-1.02
[   13.092843] PM: Adding info for No Bus:tty
[   13.092891] PM: Adding info for No Bus:console
[   13.092939] PM: Adding info for No Bus:ptmx
[   13.092982] PM: Adding info for No Bus:tty0
[   13.093030] PM: Adding info for No Bus:vcs
[   13.093073] PM: Adding info for No Bus:vcsa
[   13.093119] PM: Adding info for No Bus:tty1
[   13.093160] PM: Adding info for No Bus:tty2
[   13.093208] PM: Adding info for No Bus:tty3
[   13.093251] PM: Adding info for No Bus:tty4
[   13.093293] PM: Adding info for No Bus:tty5
[   13.093335] PM: Adding info for No Bus:tty6
[   13.093376] PM: Adding info for No Bus:tty7
[   13.093418] PM: Adding info for No Bus:tty8
[   13.093464] PM: Adding info for No Bus:tty9
[   13.093513] PM: Adding info for No Bus:tty10
[   13.093559] PM: Adding info for No Bus:tty11
[   13.093604] PM: Adding info for No Bus:tty12
[   13.093653] PM: Adding info for No Bus:tty13
[   13.093697] PM: Adding info for No Bus:tty14
[   13.093741] PM: Adding info for No Bus:tty15
[   13.093791] PM: Adding info for No Bus:tty16
[   13.093835] PM: Adding info for No Bus:tty17
[   13.093880] PM: Adding info for No Bus:tty18
[   13.093927] PM: Adding info for No Bus:tty19
[   13.093972] PM: Adding info for No Bus:tty20
[   13.094016] PM: Adding info for No Bus:tty21
[   13.094061] PM: Adding info for No Bus:tty22
[   13.094116] PM: Adding info for No Bus:tty23
[   13.094163] PM: Adding info for No Bus:tty24
[   13.094213] PM: Adding info for No Bus:tty25
[   13.094258] PM: Adding info for No Bus:tty26
[   13.094305] PM: Adding info for No Bus:tty27
[   13.094351] PM: Adding info for No Bus:tty28
[   13.094403] PM: Adding info for No Bus:tty29
[   13.094448] PM: Adding info for No Bus:tty30
[   13.094494] PM: Adding info for No Bus:tty31
[   13.094540] PM: Adding info for No Bus:tty32
[   13.094589] PM: Adding info for No Bus:tty33
[   13.094636] PM: Adding info for No Bus:tty34
[   13.094683] PM: Adding info for No Bus:tty35
[   13.094736] PM: Adding info for No Bus:tty36
[   13.094790] PM: Adding info for No Bus:tty37
[   13.094837] PM: Adding info for No Bus:tty38
[   13.094884] PM: Adding info for No Bus:tty39
[   13.094933] PM: Adding info for No Bus:tty40
[   13.094980] PM: Adding info for No Bus:tty41
[   13.095032] PM: Adding info for No Bus:tty42
[   13.095082] PM: Adding info for No Bus:tty43
[   13.095130] PM: Adding info for No Bus:tty44
[   13.095178] PM: Adding info for No Bus:tty45
[   13.095226] PM: Adding info for No Bus:tty46
[   13.095274] PM: Adding info for No Bus:tty47
[   13.095322] PM: Adding info for No Bus:tty48
[   13.095375] PM: Adding info for No Bus:tty49
[   13.095422] PM: Adding info for No Bus:tty50
[   13.095474] PM: Adding info for No Bus:tty51
[   13.095522] PM: Adding info for No Bus:tty52
[   13.095572] PM: Adding info for No Bus:tty53
[   13.095623] PM: Adding info for No Bus:tty54
[   13.095677] PM: Adding info for No Bus:tty55
[   13.095725] PM: Adding info for No Bus:tty56
[   13.095774] PM: Adding info for No Bus:tty57
[   13.095823] PM: Adding info for No Bus:tty58
[   13.095874] PM: Adding info for No Bus:tty59
[   13.095923] PM: Adding info for No Bus:tty60
[   13.095973] PM: Adding info for No Bus:tty61
[   13.096028] PM: Adding info for No Bus:tty62
[   13.096080] PM: Adding info for No Bus:tty63
[   13.096198] PM: Adding info for No Bus:ptyp0
[   13.096251] PM: Adding info for No Bus:ptyp1
[   13.096300] PM: Adding info for No Bus:ptyp2
[   13.096348] PM: Adding info for No Bus:ptyp3
[   13.096402] PM: Adding info for No Bus:ptyp4
[   13.096453] PM: Adding info for No Bus:ptyp5
[   13.096502] PM: Adding info for No Bus:ptyp6
[   13.096552] PM: Adding info for No Bus:ptyp7
[   13.096601] PM: Adding info for No Bus:ptyp8
[   13.096653] PM: Adding info for No Bus:ptyp9
[   13.096701] PM: Adding info for No Bus:ptypa
[   13.096755] PM: Adding info for No Bus:ptypb
[   13.096804] PM: Adding info for No Bus:ptypc
[   13.096854] PM: Adding info for No Bus:ptypd
[   13.096904] PM: Adding info for No Bus:ptype
[   13.096956] PM: Adding info for No Bus:ptypf
[   13.097006] PM: Adding info for No Bus:ptyq0
[   13.097063] PM: Adding info for No Bus:ptyq1
[   13.097113] PM: Adding info for No Bus:ptyq2
[   13.097165] PM: Adding info for No Bus:ptyq3
[   13.097214] PM: Adding info for No Bus:ptyq4
[   13.097266] PM: Adding info for No Bus:ptyq5
[   13.097316] PM: Adding info for No Bus:ptyq6
[   13.097366] PM: Adding info for No Bus:ptyq7
[   13.097421] PM: Adding info for No Bus:ptyq8
[   13.097508] PM: Adding info for No Bus:ptyq9
[   13.097557] PM: Adding info for No Bus:ptyqa
[   13.097605] PM: Adding info for No Bus:ptyqb
[   13.097653] PM: Adding info for No Bus:ptyqc
[   13.097706] PM: Adding info for No Bus:ptyqd
[   13.097761] PM: Adding info for No Bus:ptyqe
[   13.097810] PM: Adding info for No Bus:ptyqf
[   13.097859] PM: Adding info for No Bus:ptyr0
[   13.097908] PM: Adding info for No Bus:ptyr1
[   13.097963] PM: Adding info for No Bus:ptyr2
[   13.098014] PM: Adding info for No Bus:ptyr3
[   13.098063] PM: Adding info for No Bus:ptyr4
[   13.098119] PM: Adding info for No Bus:ptyr5
[   13.098168] PM: Adding info for No Bus:ptyr6
[   13.098221] PM: Adding info for No Bus:ptyr7
[   13.098273] PM: Adding info for No Bus:ptyr8
[   13.098325] PM: Adding info for No Bus:ptyr9
[   13.098377] PM: Adding info for No Bus:ptyra
[   13.098436] PM: Adding info for No Bus:ptyrb
[   13.098491] PM: Adding info for No Bus:ptyrc
[   13.098545] PM: Adding info for No Bus:ptyrd
[   13.098596] PM: Adding info for No Bus:ptyre
[   13.098648] PM: Adding info for No Bus:ptyrf
[   13.098700] PM: Adding info for No Bus:ptys0
[   13.098756] PM: Adding info for No Bus:ptys1
[   13.098813] PM: Adding info for No Bus:ptys2
[   13.098866] PM: Adding info for No Bus:ptys3
[   13.098919] PM: Adding info for No Bus:ptys4
[   13.098974] PM: Adding info for No Bus:ptys5
[   13.099028] PM: Adding info for No Bus:ptys6
[   13.099081] PM: Adding info for No Bus:ptys7
[   13.099140] PM: Adding info for No Bus:ptys8
[   13.099196] PM: Adding info for No Bus:ptys9
[   13.099249] PM: Adding info for No Bus:ptysa
[   13.099303] PM: Adding info for No Bus:ptysb
[   13.099357] PM: Adding info for No Bus:ptysc
[   13.099413] PM: Adding info for No Bus:ptysd
[   13.099469] PM: Adding info for No Bus:ptyse
[   13.099529] PM: Adding info for No Bus:ptysf
[   13.099586] PM: Adding info for No Bus:ptyt0
[   13.099640] PM: Adding info for No Bus:ptyt1
[   13.099694] PM: Adding info for No Bus:ptyt2
[   13.099749] PM: Adding info for No Bus:ptyt3
[   13.099804] PM: Adding info for No Bus:ptyt4
[   13.099864] PM: Adding info for No Bus:ptyt5
[   13.099920] PM: Adding info for No Bus:ptyt6
[   13.099978] PM: Adding info for No Bus:ptyt7
[   13.100032] PM: Adding info for No Bus:ptyt8
[   13.100087] PM: Adding info for No Bus:ptyt9
[   13.100145] PM: Adding info for No Bus:ptyta
[   13.100201] PM: Adding info for No Bus:ptytb
[   13.100263] PM: Adding info for No Bus:ptytc
[   13.100329] PM: Adding info for No Bus:ptytd
[   13.100384] PM: Adding info for No Bus:ptyte
[   13.100439] PM: Adding info for No Bus:ptytf
[   13.100495] PM: Adding info for No Bus:ptyu0
[   13.100553] PM: Adding info for No Bus:ptyu1
[   13.100613] PM: Adding info for No Bus:ptyu2
[   13.100669] PM: Adding info for No Bus:ptyu3
[   13.100727] PM: Adding info for No Bus:ptyu4
[   13.100787] PM: Adding info for No Bus:ptyu5
[   13.100844] PM: Adding info for No Bus:ptyu6
[   13.100900] PM: Adding info for No Bus:ptyu7
[   13.100957] PM: Adding info for No Bus:ptyu8
[   13.101020] PM: Adding info for No Bus:ptyu9
[   13.101076] PM: Adding info for No Bus:ptyua
[   13.101133] PM: Adding info for No Bus:ptyub
[   13.101192] PM: Adding info for No Bus:ptyuc
[   13.101250] PM: Adding info for No Bus:ptyud
[   13.101308] PM: Adding info for No Bus:ptyue
[   13.101373] PM: Adding info for No Bus:ptyuf
[   13.101431] PM: Adding info for No Bus:ptyv0
[   13.101487] PM: Adding info for No Bus:ptyv1
[   13.101545] PM: Adding info for No Bus:ptyv2
[   13.101605] PM: Adding info for No Bus:ptyv3
[   13.101662] PM: Adding info for No Bus:ptyv4
[   13.101721] PM: Adding info for No Bus:ptyv5
[   13.101783] PM: Adding info for No Bus:ptyv6
[   13.101843] PM: Adding info for No Bus:ptyv7
[   13.101904] PM: Adding info for No Bus:ptyv8
[   13.101962] PM: Adding info for No Bus:ptyv9
[   13.102024] PM: Adding info for No Bus:ptyva
[   13.102083] PM: Adding info for No Bus:ptyvb
[   13.102147] PM: Adding info for No Bus:ptyvc
[   13.102207] PM: Adding info for No Bus:ptyvd
[   13.102269] PM: Adding info for No Bus:ptyve
[   13.102327] PM: Adding info for No Bus:ptyvf
[   13.102385] PM: Adding info for No Bus:ptyw0
[   13.102448] PM: Adding info for No Bus:ptyw1
[   13.102508] PM: Adding info for No Bus:ptyw2
[   13.102571] PM: Adding info for No Bus:ptyw3
[   13.102631] PM: Adding info for No Bus:ptyw4
[   13.102690] PM: Adding info for No Bus:ptyw5
[   13.102748] PM: Adding info for No Bus:ptyw6
[   13.102809] PM: Adding info for No Bus:ptyw7
[   13.102869] PM: Adding info for No Bus:ptyw8
[   13.102936] PM: Adding info for No Bus:ptyw9
[   13.102996] PM: Adding info for No Bus:ptywa
[   13.103056] PM: Adding info for No Bus:ptywb
[   13.103116] PM: Adding info for No Bus:ptywc
[   13.103177] PM: Adding info for No Bus:ptywd
[   13.103236] PM: Adding info for No Bus:ptywe
[   13.103298] PM: Adding info for No Bus:ptywf
[   13.103365] PM: Adding info for No Bus:ptyx0
[   13.103426] PM: Adding info for No Bus:ptyx1
[   13.103485] PM: Adding info for No Bus:ptyx2
[   13.103547] PM: Adding info for No Bus:ptyx3
[   13.103607] PM: Adding info for No Bus:ptyx4
[   13.103667] PM: Adding info for No Bus:ptyx5
[   13.103738] PM: Adding info for No Bus:ptyx6
[   13.103799] PM: Adding info for No Bus:ptyx7
[   13.103861] PM: Adding info for No Bus:ptyx8
[   13.103923] PM: Adding info for No Bus:ptyx9
[   13.103983] PM: Adding info for No Bus:ptyxa
[   13.104043] PM: Adding info for No Bus:ptyxb
[   13.104105] PM: Adding info for No Bus:ptyxc
[   13.104175] PM: Adding info for No Bus:ptyxd
[   13.104235] PM: Adding info for No Bus:ptyxe
[   13.104296] PM: Adding info for No Bus:ptyxf
[   13.104362] PM: Adding info for No Bus:ptyy0
[   13.104423] PM: Adding info for No Bus:ptyy1
[   13.104484] PM: Adding info for No Bus:ptyy2
[   13.104549] PM: Adding info for No Bus:ptyy3
[   13.104612] PM: Adding info for No Bus:ptyy4
[   13.104676] PM: Adding info for No Bus:ptyy5
[   13.104738] PM: Adding info for No Bus:ptyy6
[   13.104801] PM: Adding info for No Bus:ptyy7
[   13.104863] PM: Adding info for No Bus:ptyy8
[   13.104924] PM: Adding info for No Bus:ptyy9
[   13.104992] PM: Adding info for No Bus:ptyya
[   13.105058] PM: Adding info for No Bus:ptyyb
[   13.105119] PM: Adding info for No Bus:ptyyc
[   13.105181] PM: Adding info for No Bus:ptyyd
[   13.105245] PM: Adding info for No Bus:ptyye
[   13.105307] PM: Adding info for No Bus:ptyyf
[   13.105374] PM: Adding info for No Bus:ptyz0
[   13.105438] PM: Adding info for No Bus:ptyz1
[   13.105504] PM: Adding info for No Bus:ptyz2
[   13.105566] PM: Adding info for No Bus:ptyz3
[   13.105632] PM: Adding info for No Bus:ptyz4
[   13.105696] PM: Adding info for No Bus:ptyz5
[   13.105761] PM: Adding info for No Bus:ptyz6
[   13.105829] PM: Adding info for No Bus:ptyz7
[   13.105894] PM: Adding info for No Bus:ptyz8
[   13.105959] PM: Adding info for No Bus:ptyz9
[   13.106023] PM: Adding info for No Bus:ptyza
[   13.106085] PM: Adding info for No Bus:ptyzb
[   13.106148] PM: Adding info for No Bus:ptyzc
[   13.106219] PM: Adding info for No Bus:ptyzd
[   13.106284] PM: Adding info for No Bus:ptyze
[   13.106346] PM: Adding info for No Bus:ptyzf
[   13.106411] PM: Adding info for No Bus:ptya0
[   13.106475] PM: Adding info for No Bus:ptya1
[   13.106538] PM: Adding info for No Bus:ptya2
[   13.106606] PM: Adding info for No Bus:ptya3
[   13.106674] PM: Adding info for No Bus:ptya4
[   13.106740] PM: Adding info for No Bus:ptya5
[   13.106806] PM: Adding info for No Bus:ptya6
[   13.106873] PM: Adding info for No Bus:ptya7
[   13.106939] PM: Adding info for No Bus:ptya8
[   13.107005] PM: Adding info for No Bus:ptya9
[   13.107073] PM: Adding info for No Bus:ptyaa
[   13.107137] PM: Adding info for No Bus:ptyab
[   13.107203] PM: Adding info for No Bus:ptyac
[   13.107268] PM: Adding info for No Bus:ptyad
[   13.107339] PM: Adding info for No Bus:ptyae
[   13.107404] PM: Adding info for No Bus:ptyaf
[   13.107483] PM: Adding info for No Bus:ptyb0
[   13.107554] PM: Adding info for No Bus:ptyb1
[   13.107621] PM: Adding info for No Bus:ptyb2
[   13.107686] PM: Adding info for No Bus:ptyb3
[   13.107751] PM: Adding info for No Bus:ptyb4
[   13.107821] PM: Adding info for No Bus:ptyb5
[   13.107886] PM: Adding info for No Bus:ptyb6
[   13.107956] PM: Adding info for No Bus:ptyb7
[   13.108022] PM: Adding info for No Bus:ptyb8
[   13.108087] PM: Adding info for No Bus:ptyb9
[   13.108152] PM: Adding info for No Bus:ptyba
[   13.108218] PM: Adding info for No Bus:ptybb
[   13.108288] PM: Adding info for No Bus:ptybc
[   13.108356] PM: Adding info for No Bus:ptybd
[   13.108428] PM: Adding info for No Bus:ptybe
[   13.108494] PM: Adding info for No Bus:ptybf
[   13.108562] PM: Adding info for No Bus:ptyc0
[   13.108629] PM: Adding info for No Bus:ptyc1
[   13.108695] PM: Adding info for No Bus:ptyc2
[   13.108768] PM: Adding info for No Bus:ptyc3
[   13.108840] PM: Adding info for No Bus:ptyc4
[   13.108908] PM: Adding info for No Bus:ptyc5
[   13.108976] PM: Adding info for No Bus:ptyc6
[   13.109043] PM: Adding info for No Bus:ptyc7
[   13.109109] PM: Adding info for No Bus:ptyc8
[   13.109175] PM: Adding info for No Bus:ptyc9
[   13.109242] PM: Adding info for No Bus:ptyca
[   13.109318] PM: Adding info for No Bus:ptycb
[   13.109385] PM: Adding info for No Bus:ptycc
[   13.109454] PM: Adding info for No Bus:ptycd
[   13.109522] PM: Adding info for No Bus:ptyce
[   13.109588] PM: Adding info for No Bus:ptycf
[   13.109658] PM: Adding info for No Bus:ptyd0
[   13.109733] PM: Adding info for No Bus:ptyd1
[   13.109803] PM: Adding info for No Bus:ptyd2
[   13.109871] PM: Adding info for No Bus:ptyd3
[   13.109939] PM: Adding info for No Bus:ptyd4
[   13.110011] PM: Adding info for No Bus:ptyd5
[   13.110079] PM: Adding info for No Bus:ptyd6
[   13.110146] PM: Adding info for No Bus:ptyd7
[   13.110219] PM: Adding info for No Bus:ptyd8
[   13.110288] PM: Adding info for No Bus:ptyd9
[   13.110359] PM: Adding info for No Bus:ptyda
[   13.110427] PM: Adding info for No Bus:ptydb
[   13.110496] PM: Adding info for No Bus:ptydc
[   13.110566] PM: Adding info for No Bus:ptydd
[   13.110639] PM: Adding info for No Bus:ptyde
[   13.110712] PM: Adding info for No Bus:ptydf
[   13.110780] PM: Adding info for No Bus:ptye0
[   13.110850] PM: Adding info for No Bus:ptye1
[   13.110923] PM: Adding info for No Bus:ptye2
[   13.110992] PM: Adding info for No Bus:ptye3
[   13.111063] PM: Adding info for No Bus:ptye4
[   13.111139] PM: Adding info for No Bus:ptye5
[   13.111209] PM: Adding info for No Bus:ptye6
[   13.111281] PM: Adding info for No Bus:ptye7
[   13.111353] PM: Adding info for No Bus:ptye8
[   13.111423] PM: Adding info for No Bus:ptye9
[   13.111492] PM: Adding info for No Bus:ptyea
[   13.111568] PM: Adding info for No Bus:ptyeb
[   13.111637] PM: Adding info for No Bus:ptyec
[   13.111710] PM: Adding info for No Bus:ptyed
[   13.111783] PM: Adding info for No Bus:ptyee
[   13.111852] PM: Adding info for No Bus:ptyef
[   13.111922] PM: Adding info for No Bus:ttyp0
[   13.111989] PM: Adding info for No Bus:ttyp1
[   13.112060] PM: Adding info for No Bus:ttyp2
[   13.112124] PM: Adding info for No Bus:ttyp3
[   13.112191] PM: Adding info for No Bus:ttyp4
[   13.112259] PM: Adding info for No Bus:ttyp5
[   13.112325] PM: Adding info for No Bus:ttyp6
[   13.112391] PM: Adding info for No Bus:ttyp7
[   13.112465] PM: Adding info for No Bus:ttyp8
[   13.112531] PM: Adding info for No Bus:ttyp9
[   13.112598] PM: Adding info for No Bus:ttypa
[   13.112666] PM: Adding info for No Bus:ttypb
[   13.112733] PM: Adding info for No Bus:ttypc
[   13.112801] PM: Adding info for No Bus:ttypd
[   13.112867] PM: Adding info for No Bus:ttype
[   13.112939] PM: Adding info for No Bus:ttypf
[   13.113006] PM: Adding info for No Bus:ttyq0
[   13.113072] PM: Adding info for No Bus:ttyq1
[   13.113144] PM: Adding info for No Bus:ttyq2
[   13.113215] PM: Adding info for No Bus:ttyq3
[   13.113283] PM: Adding info for No Bus:ttyq4
[   13.113356] PM: Adding info for No Bus:ttyq5
[   13.113425] PM: Adding info for No Bus:ttyq6
[   13.113492] PM: Adding info for No Bus:ttyq7
[   13.113558] PM: Adding info for No Bus:ttyq8
[   13.113628] PM: Adding info for No Bus:ttyq9
[   13.113695] PM: Adding info for No Bus:ttyqa
[   13.113762] PM: Adding info for No Bus:ttyqb
[   13.113837] PM: Adding info for No Bus:ttyqc
[   13.113905] PM: Adding info for No Bus:ttyqd
[   13.113974] PM: Adding info for No Bus:ttyqe
[   13.114041] PM: Adding info for No Bus:ttyqf
[   13.114110] PM: Adding info for No Bus:ttyr0
[   13.114178] PM: Adding info for No Bus:ttyr1
[   13.114253] PM: Adding info for No Bus:ttyr2
[   13.114321] PM: Adding info for No Bus:ttyr3
[   13.114388] PM: Adding info for No Bus:ttyr4
[   13.114459] PM: Adding info for No Bus:ttyr5
[   13.114530] PM: Adding info for No Bus:ttyr6
[   13.114601] PM: Adding info for No Bus:ttyr7
[   13.114670] PM: Adding info for No Bus:ttyr8
[   13.114742] PM: Adding info for No Bus:ttyr9
[   13.114810] PM: Adding info for No Bus:ttyra
[   13.114879] PM: Adding info for No Bus:ttyrb
[   13.114947] PM: Adding info for No Bus:ttyrc
[   13.115018] PM: Adding info for No Bus:ttyrd
[   13.115087] PM: Adding info for No Bus:ttyre
[   13.115165] PM: Adding info for No Bus:ttyrf
[   13.115236] PM: Adding info for No Bus:ttys0
[   13.115313] PM: Adding info for No Bus:ttys1
[   13.115382] PM: Adding info for No Bus:ttys2
[   13.115450] PM: Adding info for No Bus:ttys3
[   13.115522] PM: Adding info for No Bus:ttys4
[   13.115596] PM: Adding info for No Bus:ttys5
[   13.115671] PM: Adding info for No Bus:ttys6
[   13.115742] PM: Adding info for No Bus:ttys7
[   13.115811] PM: Adding info for No Bus:ttys8
[   13.115881] PM: Adding info for No Bus:ttys9
[   13.115954] PM: Adding info for No Bus:ttysa
[   13.116024] PM: Adding info for No Bus:ttysb
[   13.116101] PM: Adding info for No Bus:ttysc
[   13.116173] PM: Adding info for No Bus:ttysd
[   13.116244] PM: Adding info for No Bus:ttyse
[   13.116315] PM: Adding info for No Bus:ttysf
[   13.116386] PM: Adding info for No Bus:ttyt0
[   13.116455] PM: Adding info for No Bus:ttyt1
[   13.116525] PM: Adding info for No Bus:ttyt2
[   13.116605] PM: Adding info for No Bus:ttyt3
[   13.116677] PM: Adding info for No Bus:ttyt4
[   13.116749] PM: Adding info for No Bus:ttyt5
[   13.116820] PM: Adding info for No Bus:ttyt6
[   13.116890] PM: Adding info for No Bus:ttyt7
[   13.116962] PM: Adding info for No Bus:ttyt8
[   13.117039] PM: Adding info for No Bus:ttyt9
[   13.117110] PM: Adding info for No Bus:ttyta
[   13.117186] PM: Adding info for No Bus:ttytb
[   13.117258] PM: Adding info for No Bus:ttytc
[   13.117332] PM: Adding info for No Bus:ttytd
[   13.117417] PM: Adding info for No Bus:ttyte
[   13.117491] PM: Adding info for No Bus:ttytf
[   13.117567] PM: Adding info for No Bus:ttyu0
[   13.117642] PM: Adding info for No Bus:ttyu1
[   13.117718] PM: Adding info for No Bus:ttyu2
[   13.117791] PM: Adding info for No Bus:ttyu3
[   13.117862] PM: Adding info for No Bus:ttyu4
[   13.117936] PM: Adding info for No Bus:ttyu5
[   13.118013] PM: Adding info for No Bus:ttyu6
[   13.118084] PM: Adding info for No Bus:ttyu7
[   13.118159] PM: Adding info for No Bus:ttyu8
[   13.118232] PM: Adding info for No Bus:ttyu9
[   13.118307] PM: Adding info for No Bus:ttyua
[   13.118380] PM: Adding info for No Bus:ttyub
[   13.118454] PM: Adding info for No Bus:ttyuc
[   13.118532] PM: Adding info for No Bus:ttyud
[   13.118606] PM: Adding info for No Bus:ttyue
[   13.118681] PM: Adding info for No Bus:ttyuf
[   13.118753] PM: Adding info for No Bus:ttyv0
[   13.118826] PM: Adding info for No Bus:ttyv1
[   13.118902] PM: Adding info for No Bus:ttyv2
[   13.118980] PM: Adding info for No Bus:ttyv3
[   13.119053] PM: Adding info for No Bus:ttyv4
[   13.119128] PM: Adding info for No Bus:ttyv5
[   13.119200] PM: Adding info for No Bus:ttyv6
[   13.119279] PM: Adding info for No Bus:ttyv7
[   13.119353] PM: Adding info for No Bus:ttyv8
[   13.119428] PM: Adding info for No Bus:ttyv9
[   13.119508] PM: Adding info for No Bus:ttyva
[   13.119582] PM: Adding info for No Bus:ttyvb
[   13.119659] PM: Adding info for No Bus:ttyvc
[   13.119740] PM: Adding info for No Bus:ttyvd
[   13.119813] PM: Adding info for No Bus:ttyve
[   13.119887] PM: Adding info for No Bus:ttyvf
[   13.119968] PM: Adding info for No Bus:ttyw0
[   13.120042] PM: Adding info for No Bus:ttyw1
[   13.120115] PM: Adding info for No Bus:ttyw2
[   13.120191] PM: Adding info for No Bus:ttyw3
[   13.120266] PM: Adding info for No Bus:ttyw4
[   13.120346] PM: Adding info for No Bus:ttyw5
[   13.120425] PM: Adding info for No Bus:ttyw6
[   13.120505] PM: Adding info for No Bus:ttyw7
[   13.120582] PM: Adding info for No Bus:ttyw8
[   13.120659] PM: Adding info for No Bus:ttyw9
[   13.120733] PM: Adding info for No Bus:ttywa
[   13.120811] PM: Adding info for No Bus:ttywb
[   13.120887] PM: Adding info for No Bus:ttywc
[   13.120969] PM: Adding info for No Bus:ttywd
[   13.121044] PM: Adding info for No Bus:ttywe
[   13.121121] PM: Adding info for No Bus:ttywf
[   13.121198] PM: Adding info for No Bus:ttyx0
[   13.121273] PM: Adding info for No Bus:ttyx1
[   13.121350] PM: Adding info for No Bus:ttyx2
[   13.121426] PM: Adding info for No Bus:ttyx3
[   13.121512] PM: Adding info for No Bus:ttyx4
[   13.121590] PM: Adding info for No Bus:ttyx5
[   13.121666] PM: Adding info for No Bus:ttyx6
[   13.121744] PM: Adding info for No Bus:ttyx7
[   13.121822] PM: Adding info for No Bus:ttyx8
[   13.121901] PM: Adding info for No Bus:ttyx9
[   13.121984] PM: Adding info for No Bus:ttyxa
[   13.122062] PM: Adding info for No Bus:ttyxb
[   13.122138] PM: Adding info for No Bus:ttyxc
[   13.122215] PM: Adding info for No Bus:ttyxd
[   13.122293] PM: Adding info for No Bus:ttyxe
[   13.122369] PM: Adding info for No Bus:ttyxf
[   13.122445] PM: Adding info for No Bus:ttyy0
[   13.122528] PM: Adding info for No Bus:ttyy1
[   13.122605] PM: Adding info for No Bus:ttyy2
[   13.122684] PM: Adding info for No Bus:ttyy3
[   13.122766] PM: Adding info for No Bus:ttyy4
[   13.122844] PM: Adding info for No Bus:ttyy5
[   13.122929] PM: Adding info for No Bus:ttyy6
[   13.123015] PM: Adding info for No Bus:ttyy7
[   13.123095] PM: Adding info for No Bus:ttyy8
[   13.123172] PM: Adding info for No Bus:ttyy9
[   13.123251] PM: Adding info for No Bus:ttyya
[   13.123328] PM: Adding info for No Bus:ttyyb
[   13.123406] PM: Adding info for No Bus:ttyyc
[   13.123487] PM: Adding info for No Bus:ttyyd
[   13.123571] PM: Adding info for No Bus:ttyye
[   13.123650] PM: Adding info for No Bus:ttyyf
[   13.123734] PM: Adding info for No Bus:ttyz0
[   13.123812] PM: Adding info for No Bus:ttyz1
[   13.123890] PM: Adding info for No Bus:ttyz2
[   13.123969] PM: Adding info for No Bus:ttyz3
[   13.124053] PM: Adding info for No Bus:ttyz4
[   13.124136] PM: Adding info for No Bus:ttyz5
[   13.124216] PM: Adding info for No Bus:ttyz6
[   13.124294] PM: Adding info for No Bus:ttyz7
[   13.124375] PM: Adding info for No Bus:ttyz8
[   13.124454] PM: Adding info for No Bus:ttyz9
[   13.124533] PM: Adding info for No Bus:ttyza
[   13.124618] PM: Adding info for No Bus:ttyzb
[   13.124700] PM: Adding info for No Bus:ttyzc
[   13.124781] PM: Adding info for No Bus:ttyzd
[   13.124859] PM: Adding info for No Bus:ttyze
[   13.124942] PM: Adding info for No Bus:ttyzf
[   13.125022] PM: Adding info for No Bus:ttya0
[   13.125106] PM: Adding info for No Bus:ttya1
[   13.125188] PM: Adding info for No Bus:ttya2
[   13.125271] PM: Adding info for No Bus:ttya3
[   13.125352] PM: Adding info for No Bus:ttya4
[   13.125437] PM: Adding info for No Bus:ttya5
[   13.125517] PM: Adding info for No Bus:ttya6
[   13.125598] PM: Adding info for No Bus:ttya7
[   13.125685] PM: Adding info for No Bus:ttya8
[   13.125765] PM: Adding info for No Bus:ttya9
[   13.125845] PM: Adding info for No Bus:ttyaa
[   13.125927] PM: Adding info for No Bus:ttyab
[   13.126012] PM: Adding info for No Bus:ttyac
[   13.126094] PM: Adding info for No Bus:ttyad
[   13.126181] PM: Adding info for No Bus:ttyae
[   13.126262] PM: Adding info for No Bus:ttyaf
[   13.126345] PM: Adding info for No Bus:ttyb0
[   13.126431] PM: Adding info for No Bus:ttyb1
[   13.126511] PM: Adding info for No Bus:ttyb2
[   13.126593] PM: Adding info for No Bus:ttyb3
[   13.126675] PM: Adding info for No Bus:ttyb4
[   13.126764] PM: Adding info for No Bus:ttyb5
[   13.126848] PM: Adding info for No Bus:ttyb6
[   13.126931] PM: Adding info for No Bus:ttyb7
[   13.127013] PM: Adding info for No Bus:ttyb8
[   13.127094] PM: Adding info for No Bus:ttyb9
[   13.127178] PM: Adding info for No Bus:ttyba
[   13.127267] PM: Adding info for No Bus:ttybb
[   13.127349] PM: Adding info for No Bus:ttybc
[   13.127625] PM: Adding info for No Bus:ttybd
[   13.127710] PM: Adding info for No Bus:ttybe
[   13.127794] PM: Adding info for No Bus:ttybf
[   13.127874] PM: Adding info for No Bus:ttyc0
[   13.127954] PM: Adding info for No Bus:ttyc1
[   13.128040] PM: Adding info for No Bus:ttyc2
[   13.128122] PM: Adding info for No Bus:ttyc3
[   13.128202] PM: Adding info for No Bus:ttyc4
[   13.128286] PM: Adding info for No Bus:ttyc5
[   13.128366] PM: Adding info for No Bus:ttyc6
[   13.128448] PM: Adding info for No Bus:ttyc7
[   13.128535] PM: Adding info for No Bus:ttyc8
[   13.128617] PM: Adding info for No Bus:ttyc9
[   13.128698] PM: Adding info for No Bus:ttyca
[   13.128780] PM: Adding info for No Bus:ttycb
[   13.128864] PM: Adding info for No Bus:ttycc
[   13.128951] PM: Adding info for No Bus:ttycd
[   13.129034] PM: Adding info for No Bus:ttyce
[   13.129123] PM: Adding info for No Bus:ttycf
[   13.129206] PM: Adding info for No Bus:ttyd0
[   13.129290] PM: Adding info for No Bus:ttyd1
[   13.129372] PM: Adding info for No Bus:ttyd2
[   13.129455] PM: Adding info for No Bus:ttyd3
[   13.129538] PM: Adding info for No Bus:ttyd4
[   13.129631] PM: Adding info for No Bus:ttyd5
[   13.129715] PM: Adding info for No Bus:ttyd6
[   13.129799] PM: Adding info for No Bus:ttyd7
[   13.129883] PM: Adding info for No Bus:ttyd8
[   13.129967] PM: Adding info for No Bus:ttyd9
[   13.130052] PM: Adding info for No Bus:ttyda
[   13.130139] PM: Adding info for No Bus:ttydb
[   13.130228] PM: Adding info for No Bus:ttydc
[   13.130313] PM: Adding info for No Bus:ttydd
[   13.130398] PM: Adding info for No Bus:ttyde
[   13.130482] PM: Adding info for No Bus:ttydf
[   13.130567] PM: Adding info for No Bus:ttye0
[   13.130658] PM: Adding info for No Bus:ttye1
[   13.130749] PM: Adding info for No Bus:ttye2
[   13.130834] PM: Adding info for No Bus:ttye3
[   13.130918] PM: Adding info for No Bus:ttye4
[   13.131006] PM: Adding info for No Bus:ttye5
[   13.131092] PM: Adding info for No Bus:ttye6
[   13.131176] PM: Adding info for No Bus:ttye7
[   13.131261] PM: Adding info for No Bus:ttye8
[   13.131355] PM: Adding info for No Bus:ttye9
[   13.131440] PM: Adding info for No Bus:ttyea
[   13.131527] PM: Adding info for No Bus:ttyeb
[   13.131612] PM: Adding info for No Bus:ttyec
[   13.131698] PM: Adding info for No Bus:ttyed
[   13.131784] PM: Adding info for No Bus:ttyee
[   13.131874] PM: Adding info for No Bus:ttyef
[   13.131980] lp: driver loaded but no devices found
[   13.132076] PM: Adding info for No Bus:rtc
[   13.132122] Real Time Clock Driver v1.12ac
[   13.132196] PM: Adding info for No Bus:nvram
[   13.132237] Non-volatile memory driver v1.2
[   13.132305] Linux agpgart interface v0.102 (c) Dave Jones
[   13.132489] agpgart: Detected an Intel 945GM Chipset.
[   13.133619] agpgart: Detected 7932K stolen memory.
[   13.151130] PM: Adding info for No Bus:agpgart
[   13.151212] agpgart: AGP aperture is 256M @ 0xd0000000
[   13.151395] [drm] Initialized drm 1.1.0 20060810
[   13.151464] intelfb: Framebuffer driver for Intel(R) 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM chipsets
[   13.151554] intelfb: Version 0.9.4
[   13.151823] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
[   13.151964] intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory 7932kB
[   13.153998] intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode switching.
[   13.154181] intelfb: Video mode must be programmed at boot time.
[   13.155845] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[   13.155960] PM: Adding info for platform:serial8250
[   13.156223] PM: Adding info for No Bus:ttyS0
[   13.156358] PM: Adding info for No Bus:ttyS1
[   13.156485] PM: Adding info for No Bus:ttyS2
[   13.156612] PM: Adding info for No Bus:ttyS3
[   13.157682] loop: loaded (max 8 devices)
[   13.157752] e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
[   13.157822] e100: Copyright(c) 1999-2006 Intel Corporation
[   13.157996] PM: Adding info for No Bus:lo
[   13.158157] ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
[   13.158229] ipw2100: Copyright(c) 2003-2006 Intel Corporation
[   13.158371] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.0k
[   13.158444] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   13.158573] Linux video capture interface: v2.00
[   13.158687] saa7130/34: v4l2 driver version 0.2.14 loaded
[   13.158889] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[   13.158962] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[   13.159078] ICH7: IDE controller at PCI slot 0000:00:1f.1
[   13.159157] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
[   13.159296] ICH7: chipset revision 2
[   13.159362] ICH7: not 100% native mode: will probe irqs later
[   13.159442]     ide0: BM-DMA at 0x1810-0x1817, BIOS settings: hda:DMA, hdb:pio
[   13.159629] Probing IDE interface ide0...
[   13.180600] Clocksource tsc unstable (delta = -226791774 ns)
[   13.188109] hda: HL-DT-STCD-RW/DVD DRIVE GCC-4246N, ATAPI CD/DVD-ROM drive
[   13.188354] PM: Adding info for No Bus:ide0
[   13.195090] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[   13.195238] PM: Adding info for ide:0.0
[   13.195851] hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
[   13.196251] Uniform CD-ROM driver Revision: 3.20
[   13.198085] ahci 0000:00:1f.2: version 2.1
[   13.198115] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
[   13.211322] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   13.211335] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
[   13.211428] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
[   13.211627] ata1: SATA max UDMA/133 cmd 0xf8844500 ctl 0x00000000 bmdma 0x00000000 irq 20
[   13.211798] ata2: SATA max UDMA/133 cmd 0xf8844580 ctl 0x00000000 bmdma 0x00000000 irq 20
[   13.211961] ata3: SATA max UDMA/133 cmd 0xf8844600 ctl 0x00000000 bmdma 0x00000000 irq 20
[   13.212144] ata4: SATA max UDMA/133 cmd 0xf8844680 ctl 0x00000000 bmdma 0x00000000 irq 20
[   13.212249] scsi0 : ahci
[   13.212335] PM: Adding info for No Bus:host0
[   13.263765] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   13.275332] ata1.00: ATA-7: HTS541080G9SA00, MB4IC60H, max UDMA/100
[   13.275409] ata1.00: 156301488 sectors, multi 16: LBA48 
[   13.278283] ata1.00: configured for UDMA/100
[   13.278367] scsi1 : ahci
[   13.278453] PM: Adding info for No Bus:host1
[   13.282997] ata2: SATA link down (SStatus 0 SControl 0)
[   13.283087] scsi2 : ahci
[   13.283172] PM: Adding info for No Bus:host2
[   13.287592] ata3: SATA link down (SStatus 0 SControl 0)
[   13.287680] scsi3 : ahci
[   13.287764] PM: Adding info for No Bus:host3
[   13.292180] ata4: SATA link down (SStatus 0 SControl 0)
[   13.292290] PM: Adding info for No Bus:target0:0:0
[   13.292418] scsi 0:0:0:0: Direct-Access     ATA      HTS541080G9SA00  MB4I PQ: 0 ANSI: 5
[   13.292514] PM: Adding info for scsi:0:0:0:0
[   13.292695] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   13.292784] sda: Write Protect is off
[   13.293651] sda: Mode Sense: 00 3a 00 00
[   13.293677] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.293825] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[   13.293910] sda: Write Protect is off
[   13.293978] sda: Mode Sense: 00 3a 00 00
[   13.294002] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.294093]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   13.677351] sd 0:0:0:0: Attached scsi disk sda
[   13.677531] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   13.678160] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
[   13.678308] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   13.678314] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   13.678465] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   13.678591] ehci_hcd 0000:00:1d.7: debug port 1
[   13.678664] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   13.678679] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xee444000
[   13.682644] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   13.682766] PM: Adding info for usb:usb1
[   13.682868] PM: Adding info for No Bus:usbdev1.1_ep00
[   13.682923] usb usb1: configuration #1 chosen from 1 choice
[   13.683006] PM: Adding info for usb:1-0:1.0
[   13.683063] hub 1-0:1.0: USB hub found
[   13.683137] hub 1-0:1.0: 8 ports detected
[   13.684895] PM: Adding info for No Bus:usbdev1.1_ep81
[   13.685006] PM: Adding info for No Bus:usbdev1.1
[   13.685098] USB Universal Host Controller Interface driver v3.0
[   13.685314] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
[   13.685457] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   13.685463] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.685594] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   13.685710] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
[   13.685842] PM: Adding info for usb:usb2
[   13.685932] PM: Adding info for No Bus:usbdev2.1_ep00
[   13.685985] usb usb2: configuration #1 chosen from 1 choice
[   13.686068] PM: Adding info for usb:2-0:1.0
[   13.686124] hub 2-0:1.0: USB hub found
[   13.686199] hub 2-0:1.0: 2 ports detected
[   13.694955] PM: Adding info for No Bus:usbdev2.1_ep81
[   13.695056] PM: Adding info for No Bus:usbdev2.1
[   13.695152] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
[   13.695297] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   13.695303] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.695436] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   13.695557] uhci_hcd 0000:00:1d.1: irq 22, io base 0x00001840
[   13.695691] PM: Adding info for usb:usb3
[   13.695784] PM: Adding info for No Bus:usbdev3.1_ep00
[   13.695835] usb usb3: configuration #1 chosen from 1 choice
[   13.695918] PM: Adding info for usb:3-0:1.0
[   13.695974] hub 3-0:1.0: USB hub found
[   13.696048] hub 3-0:1.0: 2 ports detected
[   13.712888] PM: Adding info for No Bus:usbdev3.1_ep81
[   13.712987] PM: Adding info for No Bus:usbdev3.1
[   13.713083] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
[   13.713227] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   13.713233] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   13.713366] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   13.713489] uhci_hcd 0000:00:1d.2: irq 23, io base 0x00001860
[   13.713622] PM: Adding info for usb:usb4
[   13.713717] PM: Adding info for No Bus:usbdev4.1_ep00
[   13.713775] usb usb4: configuration #1 chosen from 1 choice
[   13.713858] PM: Adding info for usb:4-0:1.0
[   13.713916] hub 4-0:1.0: USB hub found
[   13.713990] hub 4-0:1.0: 2 ports detected
[   13.736126] PM: Adding info for No Bus:usbdev4.1_ep81
[   13.736233] PM: Adding info for No Bus:usbdev4.1
[   13.736328] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
[   13.736474] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   13.736479] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   13.736630] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   13.736748] uhci_hcd 0000:00:1d.3: irq 21, io base 0x00001880
[   13.736880] PM: Adding info for usb:usb5
[   13.736974] PM: Adding info for No Bus:usbdev5.1_ep00
[   13.737028] usb usb5: configuration #1 chosen from 1 choice
[   13.737110] PM: Adding info for usb:5-0:1.0
[   13.737168] hub 5-0:1.0: USB hub found
[   13.737242] hub 5-0:1.0: 2 ports detected
[   13.761788] PM: Adding info for No Bus:usbdev5.1_ep81
[   13.761892] PM: Adding info for No Bus:usbdev5.1
[   13.762004] Initializing USB Mass Storage driver...
[   13.825063] usb 5-2: new full speed USB device using uhci_hcd and address 2
[   13.867336] PM: Adding info for usb:5-2
[   13.867469] PM: Adding info for No Bus:usbdev5.2_ep00
[   13.867526] usb 5-2: configuration #1 chosen from 1 choice
[   13.868024] PM: Adding info for usb:5-2:1.0
[   13.868141] PM: Adding info for No Bus:usbdev5.2_ep81
[   13.868207] PM: Adding info for No Bus:usbdev5.2_ep02
[   13.868273] PM: Adding info for No Bus:usbdev5.2_ep83
[   13.868349] PM: Adding info for No Bus:usbdev5.2
[   13.868433] usbcore: registered new interface driver usb-storage
[   13.868508] USB Mass Storage support registered.
[   13.868704] PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[   13.868855] PM: Adding info for platform:i8042
[   13.876701] serio: i8042 KBD port at 0x60,0x64 irq 1
[   13.876775] serio: i8042 AUX port at 0x60,0x64 irq 12
[   13.876879] PM: Adding info for serio:serio0
[   13.876948] PM: Adding info for No Bus:psaux
[   13.877001] PM: Adding info for serio:serio1
[   13.877047] mice: PS/2 mouse device common for all mice
[   13.877319] PM: Adding info for No Bus:i2c-9191
[   13.877447] Advanced Linux Sound Architecture Driver Version 1.0.14rc3 (Tue Mar 06 13:10:00 2007 UTC).
[   13.877548] PM: Adding info for No Bus:timer
[   13.877608] PM: Adding info for No Bus:sequencer
[   13.877655] PM: Adding info for No Bus:sequencer2
[   13.877796] PM: Adding info for No Bus:seq
[   13.877997] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[   13.878148] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   13.880151] input: AT Translated Set 2 keyboard as /class/input/input3
[   13.986993] PM: Adding info for No Bus:pcmC0D1p
[   13.987092] PM: Adding info for No Bus:adsp
[   13.987154] PM: Adding info for No Bus:pcmC0D0p
[   13.987216] PM: Adding info for No Bus:pcmC0D0c
[   13.987275] PM: Adding info for No Bus:dsp
[   13.987338] PM: Adding info for No Bus:audio
[   13.987406] PM: Adding info for No Bus:controlC0
[   13.987469] PM: Adding info for No Bus:mixer
[   13.992479] ALSA device list:
[   13.992551]   #0: HDA Intel at 0xee240000 irq 22
[   13.992660] nf_conntrack version 0.5.0 (7168 buckets, 57344 max)
[   13.992935] ip_tables: (C) 2000-2006 Netfilter Core Team
[   13.993016] TCP cubic registered
[   13.993104] NET: Registered protocol family 1
[   13.993174] NET: Registered protocol family 17
[   13.993246] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   13.993320] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
[   13.993410] ieee80211_crypt: registered algorithm 'NULL'
[   13.993415] ieee80211_crypt: registered algorithm 'WEP'
[   13.993419] ieee80211_crypt: registered algorithm 'CCMP'
[   13.993422] ieee80211_crypt: registered algorithm 'TKIP'
[   13.993431] Starting balanced_irq
[   13.993511] Using IPI No-Shortcut mode
[   13.993717] swsusp: Resume From Partition /dev/sda6
[   13.993721] PM: Checking swsusp image.
[   13.993918] PM: Resume from disk failed.
[   14.017423] EXT3-fs: INFO: recovery required on readonly filesystem.
[   14.017501] EXT3-fs: write access will be enabled during recovery.
[   17.727159] kjournald starting.  Commit interval 5 seconds
[   17.727250] EXT3-fs: recovery complete.
[   17.728176] EXT3-fs: mounted filesystem with ordered data mode.
[   17.728350] VFS: Mounted root (ext3 filesystem) readonly.
[   17.728560] Freeing unused kernel memory: 184k freed
[   17.728683] Write protecting the kernel read-only data: 902k
[   17.970740] PM: Adding info for No Bus:vcs1
[   17.992460] PM: Adding info for No Bus:vcsa1
[   18.179032] PM: Removing info for No Bus:vcs1
[   18.179128] PM: Removing info for No Bus:vcsa1
[   18.179209] PM: Adding info for No Bus:vcs1
[   18.179261] PM: Adding info for No Bus:vcsa1
[   18.179333] PM: Removing info for No Bus:vcs1
[   18.179383] PM: Removing info for No Bus:vcsa1
[   18.225405] PM: Adding info for No Bus:vcs1
[   18.225711] PM: Adding info for No Bus:vcsa1
[   23.400049] PM: Adding info for No Bus:vcs2
[   23.400132] PM: Adding info for No Bus:vcsa2
[   23.400548] PM: Removing info for No Bus:vcs2
[   23.400609] PM: Removing info for No Bus:vcsa2
[   23.401050] PM: Adding info for No Bus:vcs3
[   23.401146] PM: Adding info for No Bus:vcsa3
[   23.402118] PM: Removing info for No Bus:vcs3
[   23.402181] PM: Removing info for No Bus:vcsa3
[   23.402642] PM: Adding info for No Bus:vcs4
[   23.402714] PM: Adding info for No Bus:vcsa4
[   23.403375] PM: Removing info for No Bus:vcs4
[   23.403455] PM: Removing info for No Bus:vcsa4
[   23.411722] PM: Adding info for No Bus:vcs5
[   23.411824] PM: Adding info for No Bus:vcsa5
[   23.412264] PM: Removing info for No Bus:vcs5
[   23.412320] PM: Removing info for No Bus:vcsa5
[   23.412819] PM: Adding info for No Bus:vcs6
[   23.412918] PM: Adding info for No Bus:vcsa6
[   23.413895] PM: Removing info for No Bus:vcs6
[   23.413965] PM: Removing info for No Bus:vcsa6
[   26.832471] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
[   26.832551] Copyright (c) 1999-2006 Intel Corporation.
[   26.832761] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[   26.832976] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   26.913367] e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:41:54:6c:47
[   26.992675] PM: Adding info for No Bus:eth0
[   26.992799] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[   27.310074] Adding 1951824k swap on /dev/sda6.  Priority:-1 extents:1 across:1951824k
[   27.370807] EXT3 FS on sda3, internal journal
[   27.655673] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
[   27.655784] serio: Synaptics pass-through port at isa0060/serio1/input0
[   27.698500] input: SynPS/2 Synaptics TouchPad as /class/input/input4
[   27.702092] PM: Adding info for serio:serio2
[   28.875095] NTFS volume version 3.1.
[   28.875172] NTFS-fs warning (device sda1): load_system_files(): Unsupported volume flags 0x4000 encountered.
[   28.875267] NTFS-fs error (device sda1): load_system_files(): Volume has unsupported flags set.  Mounting read-only.  Run chkdsk and mount in Windows.
[   31.166984] PM: Adding info for No Bus:vcs2
[   31.167020] PM: Adding info for No Bus:vcsa2
[   31.172935] PM: Removing info for No Bus:vcs2
[   31.172964] PM: Removing info for No Bus:vcsa2
[   31.176248] PM: Adding info for No Bus:vcs3
[   31.176274] PM: Adding info for No Bus:vcsa3
[   31.185974] PM: Removing info for No Bus:vcs3
[   31.186001] PM: Removing info for No Bus:vcsa3
[   31.188943] PM: Adding info for No Bus:vcs4
[   31.188971] PM: Adding info for No Bus:vcsa4
[   31.195018] PM: Removing info for No Bus:vcs4
[   31.195045] PM: Removing info for No Bus:vcsa4
[   31.196385] PM: Adding info for No Bus:vcs5
[   31.196413] PM: Adding info for No Bus:vcsa5
[   31.202363] PM: Removing info for No Bus:vcs5
[   31.202392] PM: Removing info for No Bus:vcsa5
[   31.203990] PM: Adding info for No Bus:vcs6
[   31.204018] PM: Adding info for No Bus:vcsa6
[   31.209574] PM: Removing info for No Bus:vcs6
[   31.209602] PM: Removing info for No Bus:vcsa6
[   31.232924] PM: Adding info for No Bus:vcs2
[   31.232957] PM: Adding info for No Bus:vcsa2
[   31.238956] PM: Removing info for No Bus:vcs2
[   31.238986] PM: Removing info for No Bus:vcsa2
[   31.246877] PM: Adding info for No Bus:vcs3
[   31.246907] PM: Adding info for No Bus:vcsa3
[   31.252421] PM: Removing info for No Bus:vcs3
[   31.252450] PM: Removing info for No Bus:vcsa3
[   31.260613] PM: Adding info for No Bus:vcs4
[   31.260642] PM: Adding info for No Bus:vcsa4
[   31.266175] PM: Removing info for No Bus:vcs4
[   31.266204] PM: Removing info for No Bus:vcsa4
[   31.272902] PM: Adding info for No Bus:vcs5
[   31.272932] PM: Adding info for No Bus:vcsa5
[   31.283083] PM: Removing info for No Bus:vcs5
[   31.283111] PM: Removing info for No Bus:vcsa5
[   31.289866] PM: Adding info for No Bus:vcs6
[   31.289896] PM: Adding info for No Bus:vcsa6
[   31.295994] PM: Removing info for No Bus:vcs6
[   31.296024] PM: Removing info for No Bus:vcsa6
[   31.466596] PM: Adding info for No Bus:vcs2
[   31.466629] PM: Adding info for No Bus:vcsa2
[   31.467270] PM: Removing info for No Bus:vcs2
[   31.467295] PM: Removing info for No Bus:vcsa2
[   31.467736] PM: Adding info for No Bus:vcs3
[   31.467760] PM: Adding info for No Bus:vcsa3
[   31.468390] PM: Removing info for No Bus:vcs3
[   31.468414] PM: Removing info for No Bus:vcsa3
[   31.468858] PM: Adding info for No Bus:vcs4
[   31.468882] PM: Adding info for No Bus:vcsa4
[   31.469507] PM: Removing info for No Bus:vcs4
[   31.469529] PM: Removing info for No Bus:vcsa4
[   31.469966] PM: Adding info for No Bus:vcs5
[   31.469988] PM: Adding info for No Bus:vcsa5
[   31.470621] PM: Removing info for No Bus:vcs5
[   31.470644] PM: Removing info for No Bus:vcsa5
[   31.471081] PM: Adding info for No Bus:vcs6
[   31.471101] PM: Adding info for No Bus:vcsa6
[   31.471742] PM: Removing info for No Bus:vcs6
[   31.471768] PM: Removing info for No Bus:vcsa6
[   31.496053] PM: Removing info for No Bus:vcs1
[   31.496128] PM: Removing info for No Bus:vcsa1
[   31.532098] PM: Adding info for No Bus:vcs1
[   31.532132] PM: Adding info for No Bus:vcsa1
[   31.532977] PM: Removing info for No Bus:vcs1
[   31.533006] PM: Removing info for No Bus:vcsa1
[   31.533315] PM: Adding info for No Bus:vcs1
[   31.533335] PM: Adding info for No Bus:vcsa1
[   31.533661] PM: Removing info for No Bus:vcs1
[   31.533681] PM: Removing info for No Bus:vcsa1
[   31.533960] PM: Adding info for No Bus:vcs1
[   31.533980] PM: Adding info for No Bus:vcsa1
[   31.534340] PM: Removing info for No Bus:vcs1
[   31.534360] PM: Removing info for No Bus:vcsa1
[   31.534885] PM: Adding info for No Bus:vcs1
[   31.534905] PM: Adding info for No Bus:vcsa1
[   32.416823] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
[   32.416827]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
[   32.417502] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
[   32.417506]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
[   32.875260] IBM TrackPoint firmware: 0x0e, buttons: 3/3
[   33.137905] input: TPPS/2 IBM TrackPoint as /class/input/input5
[   38.584256] PM: Adding info for No Bus:vcs7
[   38.584286] PM: Adding info for No Bus:vcsa7
[   38.750942] PM: Removing info for No Bus:vcs1
[   38.750976] PM: Removing info for No Bus:vcsa1
[   38.847994] PM: Adding info for No Bus:vcs1
[   38.848020] PM: Adding info for No Bus:vcsa1
[   38.848054] PM: Adding info for No Bus:vcs2
[   38.848072] PM: Adding info for No Bus:vcsa2
[   38.848450] PM: Adding info for No Bus:vcs3
[   38.848469] PM: Adding info for No Bus:vcsa3
[   38.851444] PM: Adding info for No Bus:vcs4
[   38.851472] PM: Adding info for No Bus:vcsa4
[   38.853065] PM: Adding info for No Bus:vcs5
[   38.853088] PM: Adding info for No Bus:vcsa5
[   38.854591] PM: Adding info for No Bus:vcs6
[   38.854611] PM: Adding info for No Bus:vcsa6
[   39.933577] [drm] Initialized i915 1.6.0 20060119 on minor 0
[   55.358317] PM: Preparing system for mem sleep
[   55.359372] Stopping tasks ... done.
[   55.379164] Suspending console(s)
[   55.379239] psmouse serio2: suspend
[   55.408772] psmouse serio1: suspend
[   55.445047] atkbd serio0: suspend
[   55.496382] i8042 i8042: suspend
[   55.496562] usb 5-2:1.0: suspend
[   55.496567] usb 5-2: suspend, may wakeup
[   55.496573] hub 5-0:1.0: suspend
[   55.496577] usb usb5: suspend, may wakeup
[   55.496602] hub 4-0:1.0: suspend
[   55.496606] usb usb4: suspend, may wakeup
[   55.496614] hub 3-0:1.0: suspend
[   55.496618] usb usb3: suspend, may wakeup
[   55.496625] hub 2-0:1.0: suspend
[   55.496629] usb usb2: suspend, may wakeup
[   55.496635] hub 1-0:1.0: suspend
[   55.496639] usb usb1: suspend, may wakeup
[   55.496674] sd 0:0:0:0: suspend
[   55.936052] ide-cdrom 0.0: suspend
[   55.936080] serial8250 serial8250: suspend
[   55.936419] platform vesafb.0: suspend
[   55.936424] pci_express 0000:00:1c.3:pcie03: suspend
[   55.936428] pci_express 0000:00:1c.3:pcie02: suspend
[   55.936432] pci_express 0000:00:1c.3:pcie00: suspend
[   55.936436] pci_express 0000:00:1c.2:pcie03: suspend
[   55.936439] pci_express 0000:00:1c.2:pcie02: suspend
[   55.936443] pci_express 0000:00:1c.2:pcie00: suspend
[   55.936447] pci_express 0000:00:1c.1:pcie03: suspend
[   55.936450] pci_express 0000:00:1c.1:pcie02: suspend
[   55.936454] pci_express 0000:00:1c.1:pcie00: suspend
[   55.936458] pci_express 0000:00:1c.0:pcie03: suspend
[   55.936462] pci_express 0000:00:1c.0:pcie02: suspend
[   55.936466] pci_express 0000:00:1c.0:pcie00: suspend
[   55.936471] platform pcspkr: suspend
[   55.936481] pnp 00:0a: suspend
[   55.936485] i8042 aux 00:09: suspend
[   55.936488] i8042 kbd 00:08: suspend
[   55.936492] pnp 00:07: suspend
[   55.936495] pnp 00:06: suspend
[   55.936498] pnp 00:05: suspend
[   55.936501] pnp 00:04: suspend
[   55.936504] pnp 00:03: suspend
[   55.936507] system 00:02: suspend
[   55.936510] pnp 00:01: suspend
[   55.936513] system 00:00: suspend
[   55.936518] pci 0000:15:00.0: suspend
[   55.936570] pci 0000:03:00.0: suspend
[   55.936799] e1000 0000:02:00.0: suspend
[   55.937811] ACPI: PCI interrupt for device 0000:02:00.0 disabled
[   55.938078] pci 0000:00:1f.3: suspend
[   55.938117] ahci 0000:00:1f.2: suspend
[   55.938276] ACPI: PCI interrupt for device 0000:00:1f.2 disabled
[   55.938602] PIIX_IDE 0000:00:1f.1: suspend
[   55.938636] pci 0000:00:1f.0: suspend
[   55.938683] pci 0000:00:1e.0: suspend
[   55.938719] ehci_hcd 0000:00:1d.7: suspend, may wakeup
[   55.938770] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[   55.939800] uhci_hcd 0000:00:1d.3: suspend
[   55.939837] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
[   55.939842] uhci_hcd 0000:00:1d.2: suspend
[   55.939874] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[   55.939878] uhci_hcd 0000:00:1d.1: suspend
[   55.939911] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[   55.939915] uhci_hcd 0000:00:1d.0: suspend
[   55.939947] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[   55.939951] pcieport-driver 0000:00:1c.3: suspend
[   55.940002] pcieport-driver 0000:00:1c.2: suspend
[   55.940050] pcieport-driver 0000:00:1c.1: suspend
[   55.940100] pcieport-driver 0000:00:1c.0: suspend
[   55.940151] HDA Intel 0000:00:1b.0: suspend
[   55.949178] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
[   55.949537] pci 0000:00:02.1: suspend
[   55.949557] pci 0000:00:02.0: suspend
[   55.949573] agpgart-intel 0000:00:00.0: suspend
[   55.949588] thermal thermal:02: suspend
[   55.949592] thermal thermal:01: suspend
[   55.949595] acpi thermal:00: suspend
[   55.949599] acpi device:22: suspend
[   55.949602] acpi device:21: suspend
[   55.949606] acpi device:20: suspend
[   55.949609] acpi device:1f: suspend
[   55.949612] acpi device:1e: suspend
[   55.949615] acpi device:1d: suspend
[   55.949619] acpi device:1c: suspend
[   55.949623] acpi device:1b: suspend
[   55.949626] acpi device:1a: suspend
[   55.949629] acpi device:19: suspend
[   55.949632] acpi device:18: suspend
[   55.949636] acpi device:17: suspend
[   55.949639] acpi device:16: suspend
[   55.949642] acpi device:15: suspend
[   55.949646] acpi device:14: suspend
[   55.949649] acpi device:13: suspend
[   55.949652] acpi bay:00: suspend
[   55.949656] acpi device:12: suspend
[   55.949659] acpi device:11: suspend
[   55.949662] acpi device:10: suspend
[   55.949666] acpi device:0f: suspend
[   55.949669] acpi device:0e: suspend
[   55.949673] acpi device:0d: suspend
[   55.949676] acpi device:0c: suspend
[   55.949679] acpi device:0b: suspend
[   55.949683] acpi device:0a: suspend
[   55.949686] acpi device:09: suspend
[   55.949689] acpi device:08: suspend
[   55.949693] acpi device:07: suspend
[   55.949696] acpi device:06: suspend
[   55.949700] video video:01: suspend
[   55.949703] acpi device:05: suspend
[   55.949707] acpi device:04: suspend
[   55.949710] acpi device:03: suspend
[   55.949713] acpi device:02: suspend
[   55.949716] video video:00: suspend
[   55.949720] ibm_hotkey IBM0068:00: suspend
[   55.949724] ac ACPI0003:00: suspend
[   55.949728] battery PNP0C0A:00: suspend
[   55.949732] power power_resource:00: suspend
[   55.949735] ec PNP0C09:00: suspend
[   55.949739] acpi IBM0071:00: suspend
[   55.949742] acpi IBM0057:00: suspend
[   55.949746] acpi PNP0303:00: suspend
[   55.949749] acpi PNP0B00:00: suspend
[   55.949752] acpi PNP0C04:00: suspend
[   55.949756] acpi PNP0800:00: suspend
[   55.949759] acpi PNP0200:00: suspend
[   55.949763] acpi PNP0103:00: suspend
[   55.949766] acpi PNP0100:00: suspend
[   55.949769] acpi PNP0000:00: suspend
[   55.949773] acpi PNP0C02:00: suspend
[   55.949776] acpi device:01: suspend
[   55.949779] pci_root PNP0A08:00: suspend
[   55.949783] button PNP0C0E:00: suspend
[   55.949787] button PNP0C0D:00: suspend
[   55.949790] acpi PNP0C01:00: suspend
[   55.949795] pci_link PNP0C0F:07: suspend
[   55.949798] pci_link PNP0C0F:06: suspend
[   55.949802] pci_link PNP0C0F:05: suspend
[   55.949806] pci_link PNP0C0F:04: suspend
[   55.949809] pci_link PNP0C0F:03: suspend
[   55.949812] pci_link PNP0C0F:02: suspend
[   55.949816] pci_link PNP0C0F:01: suspend
[   55.949820] pci_link PNP0C0F:00: suspend
[   55.949823] acpi device:00: suspend
[   55.949827] processor ACPI0007:01: suspend
[   55.949830] processor ACPI0007:00: suspend
[   55.949834] button button_power:00: suspend
[   55.949837] acpi acpi_system:00: suspend
[   55.949843] platform dock.0: suspend
[   55.949847] Disabling non-boot CPUs ...
[   55.951806] Breaking affinity for irq 20
[   56.059979] CPU 1 is now offline
[   56.059984] SMP alternatives: switching to UP code
[   56.060782] CPU1 is down
[   56.060786] PM: Entering mem sleep
[   56.060804] serial8250 serial8250: LATE suspend
[   56.060898] platform vesafb.0: LATE suspend
[   56.060904] platform pcspkr: LATE suspend
[   56.060911] pci 0000:15:00.0: LATE suspend
[   56.060914] pci 0000:03:00.0: LATE suspend
[   56.060917] e1000 0000:02:00.0: LATE suspend
[   56.060920] pci 0000:00:1f.3: LATE suspend
[   56.060923] PIIX_IDE 0000:00:1f.1: LATE suspend
[   56.060927] pci 0000:00:1f.0: LATE suspend
[   56.060930] pci 0000:00:1e.0: LATE suspend
[   56.060934] pcieport-driver 0000:00:1c.3: LATE suspend
[   56.060937] pcieport-driver 0000:00:1c.2: LATE suspend
[   56.060941] pcieport-driver 0000:00:1c.1: LATE suspend
[   56.060944] pcieport-driver 0000:00:1c.0: LATE suspend
[   56.060948] HDA Intel 0000:00:1b.0: LATE suspend
[   56.060951] pci 0000:00:02.1: LATE suspend
[   56.060954] pci 0000:00:02.0: LATE suspend
[   56.060957] agpgart-intel 0000:00:00.0: LATE suspend
[   56.060972] platform dock.0: LATE suspend
[    2.134505] Intel machine check architecture supported.
[    2.134518] Intel machine check reporting enabled on CPU#0.
[    2.134529] Back to C!
[    2.134873] platform dock.0: EARLY resume
[    2.134887] agpgart-intel 0000:00:00.0: EARLY resume
[    2.134892] pci 0000:00:02.0: EARLY resume
[    2.134895] pci 0000:00:02.1: EARLY resume
[    2.134899] HDA Intel 0000:00:1b.0: EARLY resume
[    2.134902] pcieport-driver 0000:00:1c.0: EARLY resume
[    2.134906] pcieport-driver 0000:00:1c.1: EARLY resume
[    2.134910] pcieport-driver 0000:00:1c.2: EARLY resume
[    2.134913] pcieport-driver 0000:00:1c.3: EARLY resume
[    2.134917] uhci_hcd 0000:00:1d.0: EARLY resume
[    2.134920] uhci_hcd 0000:00:1d.1: EARLY resume
[    2.134923] uhci_hcd 0000:00:1d.2: EARLY resume
[    2.134927] uhci_hcd 0000:00:1d.3: EARLY resume
[    2.134930] ehci_hcd 0000:00:1d.7: EARLY resume
[    2.134933] pci 0000:00:1e.0: EARLY resume
[    2.134937] pci 0000:00:1f.0: EARLY resume
[    2.134940] PIIX_IDE 0000:00:1f.1: EARLY resume
[    2.134944] ahci 0000:00:1f.2: EARLY resume
[    2.134947] pci 0000:00:1f.3: EARLY resume
[    2.134950] e1000 0000:02:00.0: EARLY resume
[    2.134953] pci 0000:03:00.0: EARLY resume
[    2.134956] pci 0000:15:00.0: EARLY resume
[    2.134967] platform pcspkr: EARLY resume
[    2.134972] platform vesafb.0: EARLY resume
[    2.135061] serial8250 serial8250: EARLY resume
[    2.135071] i8042 i8042: EARLY resume
[    2.135129] PM: Finishing wakeup.
[    2.135132] Enabling non-boot CPUs ...
[    2.136537] SMP alternatives: switching to SMP code
[    2.136740] Booting processor 1/1 eip 3000
[    2.147701] Initializing CPU#1
[    2.959150] Calibrating delay using timer specific routine.. 20089.12 BogoMIPS (lpj=100445639)
[    2.959161] CPU: After generic identify, caps: bfe9fbff 00000000 00000000 00000000 0000c1a9 00000000 00000000
[    2.959170] monitor/mwait feature present.
[    2.959175] CPU: L1 I cache: 32K, L1 D cache: 32K
[    2.959179] CPU: L2 cache: 2048K
[    2.959183] CPU: Physical Processor ID: 0
[    2.959185] CPU: Processor Core ID: 1
[    2.959189] CPU: After all inits, caps: bfe9fbff 00000000 00000000 00002940 0000c1a9 00000000 00000000
[    2.959198] Intel machine check architecture supported.
[    2.959208] Intel machine check reporting enabled on CPU#1.
[    2.959508] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    2.960293] speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
[    2.960296]  Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
[    2.960336] CPU1 is up
[    3.239195] platform dock.0: resuming
[    3.239200] acpi acpi_system:00: resuming
[    3.239202] button button_power:00: resuming
[    3.239204] processor ACPI0007:00: resuming
[    3.239206] processor ACPI0007:01: resuming
[    3.239208] acpi device:00: resuming
[    3.239210] pci_link PNP0C0F:00: resuming
[    3.239212] pci_link PNP0C0F:01: resuming
[    3.239214] pci_link PNP0C0F:02: resuming
[    3.239216] pci_link PNP0C0F:03: resuming
[    3.239218] pci_link PNP0C0F:04: resuming
[    3.239220] pci_link PNP0C0F:05: resuming
[    3.239222] pci_link PNP0C0F:06: resuming
[    3.239224] pci_link PNP0C0F:07: resuming
[    3.239226] acpi PNP0C01:00: resuming
[    3.239228] button PNP0C0D:00: resuming
[    3.239230] button PNP0C0E:00: resuming
[    3.239232] pci_root PNP0A08:00: resuming
[    3.239234] acpi device:01: resuming
[    3.239236] acpi PNP0C02:00: resuming
[    3.239237] acpi PNP0000:00: resuming
[    3.239239] acpi PNP0100:00: resuming
[    3.239241] acpi PNP0103:00: resuming
[    3.239243] acpi PNP0200:00: resuming
[    3.239246] acpi PNP0800:00: resuming
[    3.239247] acpi PNP0C04:00: resuming
[    3.239249] acpi PNP0B00:00: resuming
[    3.239251] acpi PNP0303:00: resuming
[    3.239253] acpi IBM0057:00: resuming
[    3.239255] acpi IBM0071:00: resuming
[    3.239257] ec PNP0C09:00: resuming
[    3.239259] power power_resource:00: resuming
[    3.239440] battery PNP0C0A:00: resuming
[    3.239617] ac ACPI0003:00: resuming
[    3.239621] ibm_hotkey IBM0068:00: resuming
[    3.239623] video video:00: resuming
[    3.239625] acpi device:02: resuming
[    3.239627] acpi device:03: resuming
[    3.239629] acpi device:04: resuming
[    3.239631] acpi device:05: resuming
[    3.239632] video video:01: resuming
[    3.239634] acpi device:06: resuming
[    3.239636] acpi device:07: resuming
[    3.239638] acpi device:08: resuming
[    3.239639] acpi device:09: resuming
[    3.239641] acpi device:0a: resuming
[    3.239643] acpi device:0b: resuming
[    3.239645] acpi device:0c: resuming
[    3.239646] acpi device:0d: resuming
[    3.239648] acpi device:0e: resuming
[    3.239650] acpi device:0f: resuming
[    3.239652] acpi device:10: resuming
[    3.239654] acpi device:11: resuming
[    3.239656] acpi device:12: resuming
[    3.239657] acpi bay:00: resuming
[    3.239659] acpi device:13: resuming
[    3.239661] acpi device:14: resuming
[    3.239663] acpi device:15: resuming
[    3.239665] acpi device:16: resuming
[    3.239666] acpi device:17: resuming
[    3.239668] acpi device:18: resuming
[    3.239670] acpi device:19: resuming
[    3.239672] acpi device:1a: resuming
[    3.239673] acpi device:1b: resuming
[    3.239675] acpi device:1c: resuming
[    3.239677] acpi device:1d: resuming
[    3.239679] acpi device:1e: resuming
[    3.239681] acpi device:1f: resuming
[    3.239683] acpi device:20: resuming
[    3.239684] acpi device:21: resuming
[    3.239686] acpi device:22: resuming
[    3.239688] acpi thermal:00: resuming
[    3.239690] thermal thermal:01: resuming
[    3.240184] thermal thermal:02: resuming
[    3.240756] agpgart-intel 0000:00:00.0: resuming
[    3.255490] pci 0000:00:02.0: resuming
[    3.255586] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
[    3.255590] pci 0000:00:02.1: resuming
[    3.255598] PM: Writing back config space on device 0000:00:02.1 at offset 1 (was 900000, writing 900003)
[    3.255603] HDA Intel 0000:00:1b.0: resuming
[    3.342657] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100106, writing 100102)
[    3.342673] ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 22
[    3.342680] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    3.836421] pcieport-driver 0000:00:1c.0: resuming
[    3.836453] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 180107, writing 100107)
[    3.836475] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    3.836484] pcieport-driver 0000:00:1c.1: resuming
[    3.836528] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    3.836535] pcieport-driver 0000:00:1c.2: resuming
[    3.836556] PM: Writing back config space on device 0000:00:1c.2 at offset 7 (was 20006050, writing 6050)
[    3.836586] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    3.836592] pcieport-driver 0000:00:1c.3: resuming
[    3.836602] PM: Writing back config space on device 0000:00:1c.3 at offset f (was 40400, writing 4040b)
[    3.836616] PM: Writing back config space on device 0000:00:1c.3 at offset 9 (was 10001, writing e421e421)
[    3.836624] PM: Writing back config space on device 0000:00:1c.3 at offset 8 (was 0, writing ebf0ea00)
[    3.836632] PM: Writing back config space on device 0000:00:1c.3 at offset 7 (was 20000000, writing 8070)
[    3.836643] PM: Writing back config space on device 0000:00:1c.3 at offset 3 (was 810000, writing 810010)
[    3.836652] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100000, writing 100107)
[    3.836674] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    3.836682] uhci_hcd 0000:00:1d.0: resuming
[    3.836688] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
[    3.836696] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    3.836745] usb usb2: root hub lost power or was reset
[    3.836764] uhci_hcd 0000:00:1d.1: resuming
[    3.836769] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 22
[    3.836777] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    3.836834] usb usb3: root hub lost power or was reset
[    3.836849] uhci_hcd 0000:00:1d.2: resuming
[    3.836852] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 23
[    3.836857] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    3.836899] usb usb4: root hub lost power or was reset
[    3.836914] uhci_hcd 0000:00:1d.3: resuming
[    3.836917] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 21
[    3.836922] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    3.836964] usb usb5: root hub lost power or was reset
[    3.836995] ehci_hcd 0000:00:1d.7: resuming
[    3.837808] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 21
[    3.837813] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    3.837868] pci 0000:00:1e.0: resuming
[    3.837893] PM: Writing back config space on device 0000:00:1e.0 at offset 1 (was 100005, writing 100007)
[    3.837911] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    3.837914] pci 0000:00:1f.0: resuming
[    3.837955] PIIX_IDE 0000:00:1f.1: resuming
[    3.837969] PM: Writing back config space on device 0000:00:1f.1 at offset 7 (was 1, writing 375)
[    3.837974] PM: Writing back config space on device 0000:00:1f.1 at offset 6 (was 1, writing 171)
[    3.837978] PM: Writing back config space on device 0000:00:1f.1 at offset 5 (was 1, writing 3f5)
[    3.837983] PM: Writing back config space on device 0000:00:1f.1 at offset 4 (was 1, writing 1f1)
[    3.837995] ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
[    3.837998] ahci 0000:00:1f.2: resuming
[    3.838212] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
[    3.838220] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    3.847115] pci 0000:00:1f.3: resuming
[    3.847151] e1000 0000:02:00.0: resuming
[    3.847598] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[    3.847609] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    3.853394] pci 0000:03:00.0: resuming
[    3.853592] pci 0000:15:00.0: resuming
[    3.853604] PM: Writing back config space on device 0000:15:00.0 at offset f (was 34001ff, writing 3c0010b)
[    3.853610] PM: Writing back config space on device 0000:15:00.0 at offset e (was 0, writing 94fc)
[    3.853616] PM: Writing back config space on device 0000:15:00.0 at offset d (was 0, writing 9400)
[    3.853622] PM: Writing back config space on device 0000:15:00.0 at offset c (was 0, writing 90fc)
[    3.853628] PM: Writing back config space on device 0000:15:00.0 at offset b (was 0, writing 9000)
[    3.853634] PM: Writing back config space on device 0000:15:00.0 at offset a (was 0, writing 53fff000)
[    3.853640] PM: Writing back config space on device 0000:15:00.0 at offset 9 (was 0, writing 50000000)
[    3.853646] PM: Writing back config space on device 0000:15:00.0 at offset 8 (was 0, writing e3fff000)
[    3.853652] PM: Writing back config space on device 0000:15:00.0 at offset 7 (was 0, writing e0000000)
[    3.853658] PM: Writing back config space on device 0000:15:00.0 at offset 6 (was 0, writing b0171615)
[    3.853666] PM: Writing back config space on device 0000:15:00.0 at offset 4 (was 0, writing e4300000)
[    3.853672] PM: Writing back config space on device 0000:15:00.0 at offset 3 (was 20000, writing 2a808)
[    3.853679] PM: Writing back config space on device 0000:15:00.0 at offset 1 (was 2100000, writing 2100007)
[    3.853705] ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
[    3.853713] system 00:00: resuming
[    3.853715] pnp 00:01: resuming
[    3.853716] system 00:02: resuming
[    3.853718] pnp 00:03: resuming
[    3.853720] pnp 00:04: resuming
[    3.853722] pnp 00:05: resuming
[    3.853723] pnp 00:06: resuming
[    3.853725] pnp 00:07: resuming
[    3.853727] i8042 kbd 00:08: resuming
[    3.853729] i8042 aux 00:09: resuming
[    3.853731] pnp 00:0a: resuming
[    3.853738] platform pcspkr: resuming
[    3.853741] pci_express 0000:00:1c.0:pcie00: resuming
[    3.853743] pci_express 0000:00:1c.0:pcie02: resuming
[    3.853745] pci_express 0000:00:1c.0:pcie03: resuming
[    3.853747] pci_express 0000:00:1c.1:pcie00: resuming
[    3.853749] pci_express 0000:00:1c.1:pcie02: resuming
[    3.853751] pci_express 0000:00:1c.1:pcie03: resuming
[    3.853753] pci_express 0000:00:1c.2:pcie00: resuming
[    3.853755] pci_express 0000:00:1c.2:pcie02: resuming
[    3.853757] pci_express 0000:00:1c.2:pcie03: resuming
[    3.853759] pci_express 0000:00:1c.3:pcie00: resuming
[    3.853761] pci_express 0000:00:1c.3:pcie02: resuming
[    3.853763] pci_express 0000:00:1c.3:pcie03: resuming
[    3.853765] platform vesafb.0: resuming
[    3.853990] serial8250 serial8250: resuming
[    3.853996] ide-cdrom 0.0: resuming
[    3.857029] sd 0:0:0:0: resuming
[    3.857036] usb usb1: resuming
[    3.877215] hub 1-0:1.0: resuming
[    3.877220] usb usb2: resuming
[    3.885545] hub 2-0:1.0: resuming
[    3.885549] usb usb3: resuming
[    3.913863] hub 3-0:1.0: resuming
[    3.913867] usb usb4: resuming
[    3.962189] hub 4-0:1.0: resuming
[    3.962194] usb usb5: resuming
[    4.034294] hub 5-0:1.0: resuming
[    4.034299] usb 5-2: resuming
[    4.034304]  usbdev5.2_ep00: PM: resume from 0, parent 5-2 still 2
[    4.034309] usb 5-2:1.0: PM: resume from 2, parent 5-2 still 2
[    4.034312] usb 5-2:1.0: resuming
[    4.034316]  usbdev5.2_ep81: PM: resume from 0, parent 5-2:1.0 still 2
[    4.034320]  usbdev5.2_ep02: PM: resume from 0, parent 5-2:1.0 still 2
[    4.034325]  usbdev5.2_ep83: PM: resume from 0, parent 5-2:1.0 still 2
[    4.034329]  usbdev5.2: PM: resume from 0, parent 5-2 still 2
[    4.034333] i8042 i8042: resuming
[    4.036208] atkbd serio0: resuming
[    4.039572] psmouse serio1: resuming
[    4.055718] ata2: SATA link down (SStatus 0 SControl 0)
[    4.055736] ata3: SATA link down (SStatus 0 SControl 0)
[    4.055750] ata4: SATA link down (SStatus 0 SControl 0)
[    4.241724] psmouse serio2: resuming
[    5.273802] Restarting tasks ... <6>usb 5-2: USB disconnect, address 2
[    5.274002] PM: Removing info for No Bus:usbdev5.2_ep81
[    5.274048] PM: Removing info for No Bus:usbdev5.2_ep02
[    5.274081] PM: Removing info for No Bus:usbdev5.2_ep83
[    5.274115] PM: Removing info for usb:5-2:1.0
[    5.274156] PM: Removing info for No Bus:usbdev5.2
[    5.274192] PM: Removing info for No Bus:usbdev5.2_ep00
[    5.274234] PM: Removing info for usb:5-2
[    5.285419] done.
[    5.953244] ata1: waiting for device to spin up (7 secs)
[    5.994839] usb 5-2: new full speed USB device using uhci_hcd and address 3
[    6.056673] PM: Adding info for usb:5-2
[    6.056753] PM: Adding info for No Bus:usbdev5.3_ep00
[    6.056782] usb 5-2: configuration #1 chosen from 1 choice
[    6.059645] PM: Adding info for usb:5-2:1.0
[    6.059690] PM: Adding info for No Bus:usbdev5.3_ep81
[    6.059713] PM: Adding info for No Bus:usbdev5.3_ep02
[    6.059738] PM: Adding info for No Bus:usbdev5.3_ep83
[    6.059762] PM: Adding info for No Bus:usbdev5.3
[    9.372331] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    9.706492] ata1.00: configured for UDMA/100
[    9.737686] SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
[    9.739158] sda: Write Protect is off
[    9.739225] sda: Mode Sense: 00 3a 00 00
[    9.756091] SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

--BXVAT5kNtrzKuDFl--
