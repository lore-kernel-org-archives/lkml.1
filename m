Return-Path: <linux-kernel-owner+w=401wt.eu-S1030879AbXEOLh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030879AbXEOLh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757119AbXEOLhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:37:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:16790 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbXEOLhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:37:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=G510Z1Kmx75VoNkigkGuu5ypegejm8Ia0+CWeMQY0tLsQzT0bg8YebNJEjHdQ/sp4yfFHB1497BaF5C87BFAHiKshZt3vSA9pXkW/vwDA6hr3oV4PIPA4PEdWsuO9u1bPqm+pTcbvHlggNl5rtMcdthTDrxUMdCD3MEzoMOUlfU=
Message-ID: <46499B50.8000506@gmail.com>
Date: Tue, 15 May 2007 13:36:48 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: casper@aksakovo.net
CC: linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: web server performance problem on 2.6.21.1
References: <1440.192.168.1.1.1178914110.squirrel@mail.aksakovo.net>
In-Reply-To: <1440.192.168.1.1.1178914110.squirrel@mail.aksakovo.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed the thread to fit the content better, cc'ing lkml and quoting
the whole message for lkml readers.

The HSM violation during boot is probably from smartd/smartctl.  Please
update or disable them.  I can't tell much from the info you provided
why the slowdown occurs or even whether it actually is a bug.  What do
you mean by 'frozen'?  Please report the result of 'vmstat 10' while
such problem occurs.  Does the kernel complain anything during or after
such events?

Martin Diakov wrote:
> Hi there.
> First i want to excuse for my bad english.
> Second excuse is that i bother you by email.
> 
> First:
> I have one big problem.
> I have one intel server board S3000AH with ICH7 and 2x160GB WD SATAII
> connected and CPU Intel Xeon 3050 2 cores.
> Second:
> On that machine i have installed slackware 11.0 and i have apache, php,
> mysql.
> I am hosting my own web site and i have many problems when i reach 400
> users online and my pc is dieing.
> CPU utilizatcion is up to 100% and mu linux box is frozen and when the
> users leave my linux is back online.
> I am using at the moment Kernel 2.6.21.1
> Now i will paste my dmesg and lspci -vv and i will search help from you if
> have time and wish to help me.
> Thansk alot from now.
> 
> Linux version 2.6.21.1 (root@www) (gcc version 4.1.2) #4 SMP Tue May 1
> 02:11:58 EEST 2007
> BIOS-provided physical RAM map:
> sanitize start
> sanitize end
> copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
> 000000000009fc00 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 000000000009fc00 size: 0000000000060400 end:
> 0000000000100000 type: 2
> copy_e820_map() start: 0000000000100000 size: 000000007fb0e000 end:
> 000000007fc0e000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 000000007fc0e000 size: 0000000000051000 end:
> 000000007fc5f000 type: 2
> copy_e820_map() start: 000000007fc5f000 size: 000000000007e000 end:
> 000000007fcdd000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 000000007fcdd000 size: 0000000000202000 end:
> 000000007fedf000 type: 4
> copy_e820_map() start: 000000007fedf000 size: 0000000000013000 end:
> 000000007fef2000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 000000007fef2000 size: 000000000000d000 end:
> 000000007feff000 type: 3
> copy_e820_map() start: 000000007feff000 size: 0000000000001000 end:
> 000000007ff00000 type: 1
> copy_e820_map() type is E820_RAM
> copy_e820_map() start: 00000000fffc0000 size: 0000000000010000 end:
> 00000000fffd0000 type: 2
>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>  BIOS-e820: 000000000009fc00 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 000000007fc0e000 (usable)
>  BIOS-e820: 000000007fc0e000 - 000000007fc5f000 (reserved)
>  BIOS-e820: 000000007fc5f000 - 000000007fcdd000 (usable)
>  BIOS-e820: 000000007fcdd000 - 000000007fedf000 (ACPI NVS)
>  BIOS-e820: 000000007fedf000 - 000000007fef2000 (usable)
>  BIOS-e820: 000000007fef2000 - 000000007feff000 (ACPI data)
>  BIOS-e820: 000000007feff000 - 000000007ff00000 (usable)
>  BIOS-e820: 00000000fffc0000 - 00000000fffd0000 (reserved)
> 1151MB HIGHMEM available.
> 896MB LOWMEM available.
> found SMP MP-table at 000fd950
> Entering add_active_range(0, 0, 524032) 0 entries of 256 used
> Zone PFN ranges:
>   DMA             0 ->     4096
>   Normal       4096 ->   229376
>   HighMem    229376 ->   524032
> early_node_map[1] active PFN ranges
>     0:        0 ->   524032
> On node 0 totalpages: 524032
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 4064 pages, LIFO batch:0
>   Normal zone: 1760 pages used for memmap
>   Normal zone: 223520 pages, LIFO batch:31
>   HighMem zone: 2302 pages used for memmap
>   HighMem zone: 292354 pages, LIFO batch:31
> DMI 2.4 present.
> ACPI: RSDP 000F0350, 0024 (r2 INTEL )
> ACPI: XSDT 7FEFE120, 004C (r1 INTEL   S3000AH        0 INTL  1000013)
> ACPI: FACP 7FEFB000, 00F4 (r3 INTEL   S3000AH        0 MSFT  1000013)
> ACPI: DSDT 7FEF6000, 4922 (r1 INTEL   S3000AH        0 MSFT  1000013)
> ACPI: FACS 7FE6D000, 0040
> ACPI: APIC 7FEF5000, 0078 (r1 INTEL   S3000AH        0 MSFT  1000013)
> ACPI: WDDT 7FEF4000, 0040 (r1 INTEL   S3000AH        0 MSFT  1000013)
> ACPI: MCFG 7FEF3000, 003C (r1 INTEL   S3000AH        0 MSFT  1000013)
> ACPI: ASF! 7FEF2000, 009F (r32 INTEL   S3000AH        1 MSFT  1000013)
> ACPI: PM-Timer IO Port: 0x408
> ACPI: Local APIC address 0xfee00000
> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> Processor #0 6:15 APIC version 20
> ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> Processor #1 6:15 APIC version 20
> ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
> ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
> ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
> ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
> ACPI: IOAPIC (id[0x05] address[0xfec00000] gsi_base[0])
> IOAPIC[0]: apic_id 5, version 32, address 0xfec00000, GSI 0-23
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> ACPI: IRQ0 used by override.
> ACPI: IRQ2 used by override.
> ACPI: IRQ9 used by override.
> Enabling APIC mode:  Flat.  Using 1 I/O APICs
> Using ACPI (MADT) for SMP configuration information
> Allocating PCI resources starting at 80000000 (gap: 7ff00000:800c0000)
> Built 1 zonelists.  Total pages: 519938
> Kernel command line: auto BOOT_IMAGE=linux_casper ro root=801 panic=10
> mapped APIC to ffffd000 (fee00000)
> mapped IOAPIC to ffffc000 (fec00000)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> PID hash table entries: 4096 (order: 12, 16384 bytes)
> Detected 2133.547 MHz processor.
> Console: colour VGA+ 80x25
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 2071856k/2096128k available (1806k kernel code, 20656k reserved,
> 897k data, 200k init, 1176192k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfff9d000 - 0xfffff000   ( 392 kB)
>     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
>     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
>     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
>       .init : 0xc03aa000 - 0xc03dc000   ( 200 kB)
>       .data : 0xc02c3871 - 0xc03a3fd4   ( 897 kB)
>       .text : 0xc0100000 - 0xc02c3871   (1806 kB)
> Checking if this processor honours the WP bit even in supervisor mode... Ok.
> Calibrating delay using timer specific routine.. 4270.09 BogoMIPS
> (lpj=8540185)
> Mount-cache hash table entries: 512
> CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
> 0000e3bd 00000000 00000001
> monitor/mwait feature present.
> using mwait in idle threads.
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 0
> CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd
> 00000000 00000001
> Compat vDSO mapped to ffffe000.
> Checking 'hlt' instruction... OK.
> Freeing SMP alternatives: 13k freed
> ACPI: Core revision 20070126
> CPU0: Intel(R) Xeon(R) CPU            3050  @ 2.13GHz stepping 06
> Booting processor 1/1 eip 2000
> Initializing CPU#1
> Calibrating delay using timer specific routine.. 4267.14 BogoMIPS
> (lpj=8534287)
> CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
> 0000e3bd 00000000 00000001
> monitor/mwait feature present.
> CPU: L1 I cache: 32K, L1 D cache: 32K
> CPU: L2 cache: 2048K
> CPU: Physical Processor ID: 0
> CPU: Processor Core ID: 1
> CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd
> 00000000 00000001
> CPU1: Intel(R) Xeon(R) CPU            3050  @ 2.13GHz stepping 06
> Total of 2 processors activated (8537.23 BogoMIPS).
> ENABLING IO-APIC IRQs
> ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> Brought up 2 CPUs
> migration_cost=42
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
> PCI: Not using MMCONFIG.
> PCI: Using configuration type 1
> Setting up standard PCI resources
> ACPI: Interpreter enabled
> ACPI: Using IOAPIC for interrupt routing
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> PCI: Probing PCI hardware (bus 00)
> PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
> PCI quirk: region 0500-053f claimed by ICH6 GPIO
> Boot video device is 0000:04:04.0
> PCI: Transparent bridge - 0000:00:1e.0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *9 10 11 12)
> ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
> ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
> ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
> ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
> Linux Plug and Play Support v0.97 (c) Adam Belay
> pnp: PnP ACPI init
> pnp: PnP ACPI: found 10 devices
> SCSI subsystem initialized
> libata version 2.20 loaded.
> PCI: Using ACPI for IRQ routing
> PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a
> report
> pnp: 00:01: ioport range 0x779-0x780 has been reserved
> pnp: 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
> pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
> pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
> pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
> pnp: 00:06: ioport range 0x500-0x53f has been reserved
> pnp: 00:06: ioport range 0x400-0x47f has been reserved
> pnp: 00:06: ioport range 0x680-0x6ff has been reserved
> Time: tsc clocksource has been installed.
> PCI: Bridge: 0000:00:1c.0
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.4
>   IO window: disabled.
>   MEM window: disabled.
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1c.5
>   IO window: 2000-2fff
>   MEM window: 88100000-881fffff
>   PREFETCH window: disabled.
> PCI: Bridge: 0000:00:1e.0
>   IO window: 1000-1fff
>   MEM window: 88000000-880fffff
>   PREFETCH window: 80000000-87ffffff
> ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:00:1c.4 to 64
> ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:00:1c.5 to 64
> PCI: Setting latency timer of device 0000:00:1e.0 to 64
> NET: Registered protocol family 2
> IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
> TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
> TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
> TCP: Hash tables configured (established 131072 bind 65536)
> TCP reno registered
> apm: BIOS not found.
> highmem bounce pool size: 64 pages
> Total HugeTLB memory allocated, 0
> VFS: Disk quotas dquot_6.5.1
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> io scheduler noop registered
> io scheduler anticipatory registered (default)
> io scheduler deadline registered
> io scheduler cfq registered
> 0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
> PCI: Setting latency timer of device 0000:00:1c.0 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.0:pcie00]
> Allocate Port Service[0000:00:1c.0:pcie02]
> PCI: Setting latency timer of device 0000:00:1c.4 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.4:pcie00]
> Allocate Port Service[0000:00:1c.4:pcie02]
> PCI: Setting latency timer of device 0000:00:1c.5 to 64
> assign_interrupt_mode Found MSI capability
> Allocate Port Service[0000:00:1c.5:pcie00]
> Allocate Port Service[0000:00:1c.5:pcie02]
> input: Power Button (FF) as /class/input/input0
> ACPI: Power Button (FF) [PWRF]
> input: Sleep Button (CM) as /class/input/input1
> ACPI: Sleep Button (CM) [SLPB]
> Real Time Clock Driver v1.12ac
> intel_rng: Firmware space is locked read-only. If you can't or
> intel_rng: don't want to disable this in firmware setup, and if
> intel_rng: you are certain that your system has a functional
> intel_rng: RNG, try using the 'no_fwh_detect' option.
> Linux agpgart interface v0.102 (c) Dave Jones
> [drm] Initialized drm 1.1.0 20060810
> ACPI: PCI Interrupt 0000:04:04.0[A] -> GSI 18 (level, low) -> IRQ 18
> [drm] Initialized radeon 1.25.0 20060524 on minor 0
> Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is
> 60 seconds).
> Hangcheck: Using get_cycles().
> Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
> Copyright (c) 1999-2006 Intel Corporation.
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 16
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> e1000: 0000:03:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1)
> 00:15:17:13:2e:64
> e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 17 (level, low) -> IRQ 16
> e1000: 0000:04:05.0: e1000_probe: (PCI:33MHz:32-bit) 00:15:17:13:2e:65
> e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
> ata_piix 0000:00:1f.2: version 2.10ac1
> ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> ata1: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000130a0 irq 14
> ata2: SATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x000130a8 irq 15
> scsi0 : ata_piix
> ata1.00: ATA-7: WDC WD1600AAJS-00PSA0, 05.06H05, max UDMA/133
> ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata1.00: configured for UDMA/133
> scsi1 : ata_piix
> ata2.00: ATA-7: WDC WD1600AAJS-00PSA0, 05.06H05, max UDMA/133
> ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata2.00: configured for UDMA/133
> scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-0 05.0 PQ: 0 ANSI: 5
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
> sda: Write Protect is off
> sda: Mode Sense: 00 3a 00 00
> SCSI device sda: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sda: sda1 sda2
> sd 0:0:0:0: Attached scsi disk sda
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600AAJS-0 05.0 PQ: 0 ANSI: 5
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdb: sdb1 sdb2
> sd 1:0:0:0: Attached scsi disk sdb
> sd 1:0:0:0: Attached scsi generic sg1 type 0
> PNP: No PS/2 controller found. Probing ports directly.
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> input: PC Speaker as /class/input/input2
> oprofile: using NMI interrupt.
> NET: Registered protocol family 1
> NET: Registered protocol family 17
> p4-clockmod: Warning: EST-capable CPU detected. The acpi-cpufreq module
> offers voltage scaling in addition of frequency scaling. You should use
> that instead of p4-clockmod, if possible.
> PCORE - MSR_FSB_FREQ undefined value<4>p4-clockmod: Warning: EST-capable
> CPU detected. The acpi-cpufreq module offers voltage scaling in addition
> of frequency scaling. You should use that instead of p4-clockmod, if
> possible.
> PCORE - MSR_FSB_FREQ undefined value<6>Starting balanced_irq
> Using IPI Shortcut mode
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> VFS: Mounted root (ext3 filesystem) readonly.
> Freeing unused kernel memory: 200k freed
> Adding 2097136k swap on /dev/sda2.  Priority:-1 extents:1 across:2097136k
> Adding 2097136k swap on /dev/sdb2.  Priority:-2 extents:1 across:2097136k
> EXT3 FS on sda1, internal journal
> e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow
> Control: RX
> e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata2.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 123392 in
>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM violation)
> ata2: soft resetting port
> ata2.00: configured for UDMA/133
> ata2: EH complete
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
> sdb: Write Protect is off
> sdb: Mode Sense: 00 3a 00 00
> SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> 
> 
> Now is the lspci -vv
> 00:00.0 Host bridge: Intel Corporation E7230 Memory Controller Hub
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ >SERR- <PERR-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
> Port 1 (rev 01) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>         Capabilities: [40] Express Root Port (Slot+) IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>                 Device: Latency L0s unlimited, L1 unlimited
>                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s L1, Port 1
>                 Link: Latency L0s <1us, L1 <4us
>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x0
>                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
>                 Slot: Number 1, PowerLimit 25.000000
>                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>                 Slot: AttnInd Unknown, PwrInd Unknown, Power-
>                 Root: Correctable- Non-Fatal- Fatal- PME-
>         Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
> Enable+
>                 Address: fee0300c  Data: 41b9
>         Capabilities: [90] #0d [0000]
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
> Express Port 5 (rev 01) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>         Capabilities: [40] Express Root Port (Slot+) IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>                 Device: Latency L0s unlimited, L1 unlimited
>                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 5
>                 Link: Latency L0s <1us, L1 <4us
>                 Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x0
>                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
>                 Slot: Number 5, PowerLimit 10.000000
>                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>                 Slot: AttnInd Unknown, PwrInd Unknown, Power-
>                 Root: Correctable- Non-Fatal- Fatal- PME-
>         Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
> Enable+
>                 Address: fee0300c  Data: 41c1
>         Capabilities: [90] #0d [0000]
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
> Express Port 6 (rev 01) (prog-if 00 [Normal decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: 88100000-881fffff
>         Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- <SERR- <PERR-
>         BridgeCtl: Parity+ SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
>         Capabilities: [40] Express Root Port (Slot+) IRQ 0
>                 Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
>                 Device: Latency L0s unlimited, L1 unlimited
>                 Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
>                 Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
>                 Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 6
>                 Link: Latency L0s <256ns, L1 <4us
>                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x1
>                 Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
>                 Slot: Number 6, PowerLimit 10.000000
>                 Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
>                 Slot: AttnInd Unknown, PwrInd Unknown, Power-
>                 Root: Correctable- Non-Fatal- Fatal- PME-
>         Capabilities: [80] Message Signalled Interrupts: 64bit- Queue=0/0
> Enable+
>                 Address: fee0300c  Data: 41c9
>         Capabilities: [90] #0d [0000]
>         Capabilities: [a0] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #1
> (rev 01) (prog-if 00 [UHCI])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 10
>         Region 4: I/O ports at 3080 [size=32]
> 
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #2
> (rev 01) (prog-if 00 [UHCI])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 11
>         Region 4: I/O ports at 3060 [size=32]
> 
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #3
> (rev 01) (prog-if 00 [UHCI])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin C routed to IRQ 11
>         Region 4: I/O ports at 3040 [size=32]
> 
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI #4
> (rev 01) (prog-if 00 [UHCI])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin D routed to IRQ 11
>         Region 4: I/O ports at 3020 [size=32]
> 
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
> Controller (rev 01) (prog-if 20 [EHCI])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin A routed to IRQ 10
>         Region 0: Memory at 88200400 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>         Capabilities: [58] Debug port
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1) (prog-if
> 01 [Subtractive decode])
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
>         I/O behind bridge: 00001000-00001fff
>         Memory behind bridge: 88000000-880fffff
>         Prefetchable memory behind bridge: 0000000080000000-0000000087f00000
>         Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort+ <SERR- <PERR-
>         BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
>         Capabilities: [50] #0d [0000]
> 
> 00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC
> Interface Bridge (rev 01)
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Capabilities: [e0] Vendor Specific Information
> 
> 00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family)
> Serial ATA Storage Controller IDE (rev 01) (prog-if 8a [Master SecP PriP])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0
>         Interrupt: pin B routed to IRQ 19
>         Region 0: I/O ports at 01f0 [size=8]
>         Region 1: I/O ports at 03f4 [size=1]
>         Region 2: I/O ports at 0170 [size=8]
>         Region 3: I/O ports at 0374 [size=1]
>         Region 4: I/O ports at 30a0 [size=16]
>         Region 5: Memory at 88200000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [70] Power Management version 2
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
> (rev 01)
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin B routed to IRQ 11
>         Region 4: I/O ports at 3000 [size=32]
> 
> 03:00.0 Ethernet controller: Intel Corporation 82573V Gigabit Ethernet
> Controller (Copper) (rev 03)
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 220
>         Region 0: Memory at 88100000 (32-bit, non-prefetchable) [size=128K]
>         Region 2: I/O ports at 2000 [size=32]
>         Capabilities: [c8] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/0
> Enable+
>                 Address: 00000000fee0200c  Data: 41e1
>         Capabilities: [e0] Express Endpoint IRQ 0
>                 Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
>                 Device: Latency L0s <512ns, L1 <64us
>                 Device: AtnBtn- AtnInd- PwrInd-
>                 Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
>                 Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
>                 Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
>                 Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
>                 Link: Latency L0s <128ns, L1 <64us
>                 Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
>                 Link: Speed 2.5Gb/s, Width x1
> 
> 04:04.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
> (prog-if 00 [VGA])
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping+ SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (2000ns min), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 18
>         Region 0: Memory at 80000000 (32-bit, prefetchable) [size=128M]
>         Region 1: I/O ports at 1000 [size=256]
>         Region 2: Memory at 88040000 (32-bit, non-prefetchable) [size=64K]
>         Expansion ROM at fffe0000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 2
>                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> 04:05.0 Ethernet controller: Intel Corporation 82541GI/PI Gigabit Ethernet
> Controller (rev 05)
>         Subsystem: Intel Corporation Unknown device 348f
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr+ Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32 (63750ns min), Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 16
>         Region 0: Memory at 88020000 (32-bit, non-prefetchable) [size=128K]
>         Region 1: Memory at 88000000 (32-bit, non-prefetchable) [size=128K]
>         Region 2: I/O ports at 1100 [size=64]
>         Expansion ROM at 88060000 [disabled] [size=128K]
>         Capabilities: [dc] Power Management version 2
>                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
> PME(D0+,D1-,D2-,D3hot+,D3cold+)
>                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
>         Capabilities: [e4] PCI-X non-bridge device
>                 Command: DPERE- ERO+ RBC=512 OST=1
>                 Status: Dev=00:00.0 64bit- 133MHz- SCD- USC- DC=simple
> DMMRBC=2048 DMOST=1 DMCRS=8 RSCEM- 266MHz- 533MHz-
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
tejun
