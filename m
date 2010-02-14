Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab0BNXRn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 18:17:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60418 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab0BNXRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 18:17:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Meelis Roos <mroos@ut.ee>
Subject: Re: 2.6.33-rc8 regression: irq11: nobody cared, during yenta registration
Date: Mon, 15 Feb 2010 00:18:21 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc8-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
References: <alpine.SOC.1.00.1002141720120.679@math.ut.ee>
In-Reply-To: <alpine.SOC.1.00.1002141720120.679@math.ut.ee>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002150018.21417.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Meelis Roos wrote:
> Just tried 2.6.33-rcx8 on my laptop (Thinkpad X20 in a dock) that was 
> last running 2.6.33-rc5 without problems. Gor irq11: nobody carec like 
> below. Seems to be repeatabale. lspci also below.

I have created the Bugzilla entry at http://bugzilla.kernel.org/show_bug.cgi?id=15307
for your report.

Peter, Ingo, did we do anything to the interrupt handling between .33-rc5 and .33-rc8?

Thanks,
Rafael


> Linux version 2.6.33-rc8 (mroos@tulp) (gcc version 4.4.3 (Debian 4.4.3-2) ) #1 Sun Feb 14 10:37:28 EET 2010
> BIOS-provided physical RAM map:
>  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
>  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000dd000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 0000000013ff0000 (usable)
>  BIOS-e820: 0000000013ff0000 - 0000000013ffec00 (ACPI data)
>  BIOS-e820: 0000000013ffec00 - 0000000014000000 (ACPI NVS)
>  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
> Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
> DMI 2.3 present.
> last_pfn = 0x13ff0 max_arch_pfn = 0x100000
> MTRR default type: uncachable
> MTRR fixed ranges enabled:
>   00000-9FFFF write-back
>   A0000-BFFFF uncachable
>   C0000-CFFFF write-protect
>   D0000-DFFFF uncachable
>   E0000-FFFFF write-protect
> MTRR variable ranges enabled:
>   0 base 000000000 mask FF0000000 write-back
>   1 base 010000000 mask FFC000000 write-back
>   2 disabled
>   3 disabled
>   4 disabled
>   5 disabled
>   6 disabled
>   7 disabled
> PAT not supported by CPU.
> initial memory mapped : 0 - 01800000
> init_memory_mapping: 0000000000000000-0000000013ff0000
>  0000000000 - 0000400000 page 4k
>  0000400000 - 0013c00000 page 2M
>  0013c00000 - 0013ff0000 page 4k
> kernel direct mapping tables up to 13ff0000 @ 7000-c000
> RAMDISK: 0ec57000 - 0f033f82
> ACPI: RSDP 000f6ec0 00014 (v00 PTLTD )
> ACPI: RSDT 13ff5c49 0002C (v01 PTLTD    RSDT   06040000  LTP 00000000)
> ACPI: FACP 13ffeb65 00074 (v01 IBM    TP-X21   06040000      00000000)
> ACPI: DSDT 13ff5c75 08EF0 (v01 IBM    TP-X21   06040000 MSFT 0100000C)
> ACPI: FACS 13fff000 00040
> ACPI: BOOT 13ffebd9 00027 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
> 319MB LOWMEM available.
>   mapped low ram: 0 - 13ff0000
>   low ram: 0 - 13ff0000
>   node 0 low ram: 00000000 - 13ff0000
>   node 0 bootmap 00008000 - 0000a800
> (8 early reservations) ==> bootmem [0000000000 - 0013ff0000]
>   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
>   #1 [0001000000 - 00013bf0c0]    TEXT DATA BSS ==> [0001000000 - 00013bf0c0]
>   #2 [000ec57000 - 000f033f82]          RAMDISK ==> [000ec57000 - 000f033f82]
>   #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
>   #4 [00013c0000 - 00013c60d9]              BRK ==> [00013c0000 - 00013c60d9]
>   #5 [0000001000 - 0000005000]      ACPI WAKEUP ==> [0000001000 - 0000005000]
>   #6 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
>   #7 [0000008000 - 000000b000]          BOOTMAP ==> [0000008000 - 000000b000]
> Zone PFN ranges:
>   DMA      0x00000000 -> 0x00001000
>   Normal   0x00001000 -> 0x00013ff0
> Movable zone start PFN for each node
> early_node_map[2] active PFN ranges
>     0: 0x00000000 -> 0x0000009f
>     0: 0x00000100 -> 0x00013ff0
> On node 0 totalpages: 81807
> free_area_init_node: node 0, pgdat c1335e60, node_mem_map c13c7000
>   DMA zone: 32 pages used for memmap
>   DMA zone: 0 pages reserved
>   DMA zone: 3967 pages, LIFO batch:0
>   Normal zone: 608 pages used for memmap
>   Normal zone: 77200 pages, LIFO batch:15
> ACPI: PM-Timer IO Port: 0x1008
> PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
> PM: Registered nosave memory: 00000000000a0000 - 00000000000dd000
> PM: Registered nosave memory: 00000000000dd000 - 0000000000100000
> Allocating PCI resources starting at 14000000 (gap: 14000000:ebf80000)
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 81167
> Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-rc8 root=UUID=5a228fa1-6850-44bc-9b37-73af4d751e16 ro resume=/dev/sda2
> PID hash table entries: 2048 (order: 1, 8192 bytes)
> Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
> Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
> Enabling fast FPU save and restore... done.
> Enabling unmasked SIMD FPU exception support... done.
> Initializing CPU#0
> Memory: 316132k/327616k available (2384k kernel code, 10804k reserved, 918k data, 272k init, 0k highmem)
> virtual kernel memory layout:
>     fixmap  : 0xfffe5000 - 0xfffff000   ( 104 kB)
>     vmalloc : 0xd47f0000 - 0xfffe3000   ( 695 MB)
>     lowmem  : 0xc0000000 - 0xd3ff0000   ( 319 MB)
>       .init : 0xc133a000 - 0xc137e000   ( 272 kB)
>       .data : 0xc12540eb - 0xc1339a04   ( 918 kB)
>       .text : 0xc1000000 - 0xc12540eb   (2384 kB)
> Checking if this processor honours the WP bit even in supervisor mode...Ok.
> NR_IRQS:16
> CPU 0 irqstacks, hard=c130e000 soft=c130f000
> Console: colour VGA+ 80x25
> console [tty0] enabled
> Fast TSC calibration using PIT
> Detected 597.475 MHz processor.
> Calibrating delay loop (skipped), value calculated using timer frequency.. 1194.95 BogoMIPS (lpj=5974750)
> Security Framework initialized
> Mount-cache hash table entries: 512
> Performance Events: 
> no APIC, boot with the "lapic" boot parameter to force-enable it.
> no hardware sampling interrupt available.
> p6 PMU driver.
> ... version:                0
> ... bit width:              32
> ... generic registers:      2
> ... value mask:             00000000ffffffff
> ... max period:             000000007fffffff
> ... fixed-purpose events:   0
> ... event mask:             0000000000000003
> CPU: Intel Pentium III (Coppermine) stepping 03
> Checking 'hlt' instruction... OK.
> ACPI: Core revision 20091214
> ACPI: setting ELCR to 0200 (from 0e20)
> NET: Registered protocol family 16
> ACPI: bus type pci registered
> PCI: PCI BIOS revision 2.10 entry at 0xfd94f, last bus=14
> PCI: Using configuration type 1 for base access
> bio: create slab <bio-0> at 0
> ACPI: EC: Look up EC in DSDT
> ACPI: Interpreter enabled
> ACPI: (supports S0 S1 S3 S4 S5)
> ACPI: Using PIC for interrupt routing
> ACPI: EC: GPE = 0x9, I/O: command/status = 0x66, data = 0x62
> ACPI: Power Resource [PSIO] (on)
> ACPI: Power Resource [PSER] (off)
> ACPI: ACPI Dock Station Driver: 2 docks/bays found
> ACPI: PCI Root Bridge [PCI0] (0000:00)
> pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
> pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
> pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000d3fff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x000d4000-0x000d7fff] (ignored)
> pci_root PNP0A03:00: host bridge window [mem 0x14000000-0xffdfffff] (ignored)
> pci 0000:00:00.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
> pci 0000:00:04.0: supports D1 D2
> pci 0000:00:07.1: reg 20: [io  0x1800-0x180f]
> pci 0000:00:07.2: reg 20: [io  0x1820-0x183f]
> pci 0000:00:07.3: quirk: [io  0x1000-0x103f] claimed by PIIX4 ACPI
> pci 0000:00:07.3: quirk: [io  0x1040-0x104f] claimed by PIIX4 SMB
> pci 0000:00:07.3: PIIX4 devres I PIO at 03f0-03f7
> pci 0000:00:07.3: PIIX4 devres J PIO at 002e-002f
> pci 0000:00:08.0: reg 10: [mem 0x50000000-0x50000fff]
> pci 0000:00:08.0: supports D1 D2
> pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:08.0: PME# disabled
> pci 0000:00:08.1: reg 10: [mem 0x50100000-0x50100fff]
> pci 0000:00:08.1: supports D1 D2
> pci 0000:00:08.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:08.1: PME# disabled
> pci 0000:00:0a.0: reg 10: [mem 0xf4010000-0xf4010fff]
> pci 0000:00:0a.0: reg 14: [io  0x1840-0x187f]
> pci 0000:00:0a.0: reg 18: [mem 0xf4020000-0xf403ffff]
> pci 0000:00:0a.0: reg 30: [mem 0x00000000-0x000fffff pref]
> pci 0000:00:0a.0: supports D1 D2
> pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.0: PME# disabled
> pci 0000:00:0a.1: reg 10: [io  0x1810-0x1817]
> pci 0000:00:0a.1: reg 14: [mem 0xf4011000-0xf4011fff]
> pci 0000:00:0a.1: supports D1 D2
> pci 0000:00:0a.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:00:0a.1: PME# disabled
> pci 0000:00:0b.0: reg 10: [mem 0xf4012000-0xf4012fff]
> pci 0000:00:0b.0: reg 14: [mem 0xf4000000-0xf400ffff]
> pci 0000:00:0b.0: supports D1 D2
> pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot
> pci 0000:00:0b.0: PME# disabled
> pci 0000:01:00.0: reg 10: [mem 0xf5000000-0xf5ffffff]
> pci 0000:01:00.0: reg 14: [io  0x2000-0x20ff]
> pci 0000:01:00.0: reg 18: [mem 0xf4100000-0xf4100fff]
> pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
> pci 0000:01:00.0: supports D1 D2
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:01.0:   bridge window [mem 0xf4100000-0xf5ffffff]
> pci 0000:02:00.0: reg 10: [mem 0xf6000000-0xf60007ff]
> pci 0000:02:00.0: reg 14: [io  0x3000-0x307f]
> pci 0000:02:00.0: supports D2
> pci 0000:02:00.0: PME# supported from D2 D3hot D3cold
> pci 0000:02:00.0: PME# disabled
> pci 0000:02:01.0: reg 10: [io  0x30a0-0x30a7]
> pci 0000:02:01.0: reg 14: [io  0x3094-0x3097]
> pci 0000:02:01.0: reg 18: [io  0x3098-0x309f]
> pci 0000:02:01.0: reg 1c: [io  0x3090-0x3093]
> pci 0000:02:01.0: reg 20: [io  0x3080-0x308f]
> pci 0000:02:01.0: supports D1 D2
> pci 0000:02:02.0: reg 10: [mem 0x52000000-0x52000fff]
> pci 0000:02:02.0: supports D1 D2
> pci 0000:02:02.0: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:02:02.0: PME# disabled
> pci 0000:02:02.1: reg 10: [mem 0x53000000-0x53000fff]
> pci 0000:02:02.1: supports D1 D2
> pci 0000:02:02.1: PME# supported from D0 D1 D2 D3hot D3cold
> pci 0000:02:02.1: PME# disabled
> pci 0000:00:04.0: PCI bridge to [bus 02-08] (subtractive decode)
> pci 0000:00:04.0:   bridge window [io  0x0000-0x0fff]
> pci 0000:00:04.0:   bridge window [mem 0x00000000-0x000fffff]
> pci 0000:00:04.0:   bridge window [mem 0x00000000-0x000fffff pref]
> pci_bus 0000:00: on NUMA node 0
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.DOCK._PRT]
> ACPI: PCI Interrupt Link [LNKA] (IRQs 9 *11)
> ACPI: PCI Interrupt Link [LNKB] (IRQs 9 11) *10
> ACPI: PCI Interrupt Link [LNKC] (IRQs *9 11)
> ACPI: PCI Interrupt Link [LNKD] (IRQs 9 11) *5
> vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
> vgaarb: loaded
> PCI: Using ACPI for IRQ routing
> PCI: pci_cache_line_size set to 32 bytes
> pci 0000:00:04.0: can't reserve window [io  0x0000-0x0fff]
> pci 0000:00:04.0: can't reserve window [mem 0x00000000-0x000fffff]
> pci 0000:00:04.0: can't reserve window [mem 0x00000000-0x000fffff pref]
> Switching to clocksource tsc
> pnp: PnP ACPI init
> ACPI: bus type pnp registered
> pnp 00:00: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000c0000-0x000c3fff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000c4000-0x000c7fff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000c8000-0x000cbfff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000cc000-0x000cffff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000d0000-0x000cffff disabled] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000d4000-0x000d3fff disabled] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000d8000-0x000dbfff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000dc000-0x000dffff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000e0000-0x000e3fff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000e4000-0x000e7fff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000e8000-0x000ebfff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000ec000-0x000effff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp 00:00: disabling [mem 0x000f0000-0x000fffff] because it overlaps 0000:00:0a.0 BAR 6 [mem 0x00000000-0x000fffff pref]
> pnp: PnP ACPI: found 13 devices
> ACPI: ACPI bus type pnp unregistered
> system 00:00: [mem 0x00100000-0x13ffffff] could not be reserved
> system 00:00: [mem 0xfff80000-0xffffffff] has been reserved
> system 00:02: [io  0x1000-0x103f] has been reserved
> system 00:02: [io  0x1040-0x104f] has been reserved
> system 00:02: [io  0xfe00-0xfe0f] has been reserved
> pci 0000:00:04.0: BAR 8: assigned [mem 0x14000000-0x1bffffff]
> pci 0000:00:04.0: BAR 9: assigned [mem 0x1c000000-0x23ffffff pref]
> pci 0000:00:08.0: BAR 9: assigned [mem 0x24000000-0x27ffffff pref]
> pci 0000:00:08.0: BAR 10: assigned [mem 0x28000000-0x2bffffff]
> pci 0000:00:08.1: BAR 9: assigned [mem 0x2c000000-0x2fffffff pref]
> pci 0000:00:08.1: BAR 10: assigned [mem 0x30000000-0x33ffffff]
> pci 0000:00:01.0: BAR 9: assigned [mem 0x34000000-0x340fffff pref]
> pci 0000:00:0a.0: BAR 6: assigned [mem 0x34100000-0x341fffff pref]
> pci 0000:00:04.0: BAR 7: assigned [io  0x4000-0x4fff]
> pci 0000:00:08.0: BAR 7: assigned [io  0x1400-0x14ff]
> pci 0000:00:08.0: BAR 8: assigned [io  0x1c00-0x1cff]
> pci 0000:00:08.1: BAR 7: assigned [io  0x3400-0x34ff]
> pci 0000:00:08.1: BAR 8: assigned [io  0x3800-0x38ff]
> pci 0000:01:00.0: BAR 6: assigned [mem 0x34000000-0x3401ffff pref]
> pci 0000:00:01.0: PCI bridge to [bus 01-01]
> pci 0000:00:01.0:   bridge window [io  0x2000-0x2fff]
> pci 0000:00:01.0:   bridge window [mem 0xf4100000-0xf5ffffff]
> pci 0000:00:01.0:   bridge window [mem 0x34000000-0x340fffff pref]
> pci 0000:02:02.0: BAR 9: assigned [mem 0x1c000000-0x1fffffff pref]
> pci 0000:02:02.0: BAR 10: assigned [mem 0x14000000-0x17ffffff]
> pci 0000:02:02.1: BAR 9: assigned [mem 0x20000000-0x23ffffff pref]
> pci 0000:02:02.1: BAR 10: assigned [mem 0x18000000-0x1bffffff]
> pci 0000:02:02.0: BAR 7: assigned [io  0x4000-0x40ff]
> pci 0000:02:02.0: BAR 8: assigned [io  0x4400-0x44ff]
> pci 0000:02:02.1: BAR 7: assigned [io  0x4800-0x48ff]
> pci 0000:02:02.1: BAR 8: assigned [io  0x4c00-0x4cff]
> pci 0000:02:02.0: CardBus bridge to [bus 03-06]
> pci 0000:02:02.0:   bridge window [io  0x4000-0x40ff]
> pci 0000:02:02.0:   bridge window [io  0x4400-0x44ff]
> pci 0000:02:02.0:   bridge window [mem 0x1c000000-0x1fffffff pref]
> pci 0000:02:02.0:   bridge window [mem 0x14000000-0x17ffffff]
> pci 0000:02:02.1: CardBus bridge to [bus 07-07]
> pci 0000:02:02.1:   bridge window [io  0x4800-0x48ff]
> pci 0000:02:02.1:   bridge window [io  0x4c00-0x4cff]
> pci 0000:02:02.1:   bridge window [mem 0x20000000-0x23ffffff pref]
> pci 0000:02:02.1:   bridge window [mem 0x18000000-0x1bffffff]
> pci 0000:00:04.0: PCI bridge to [bus 02-08]
> pci 0000:00:04.0:   bridge window [io  0x4000-0x4fff]
> pci 0000:00:04.0:   bridge window [mem 0x14000000-0x1bffffff]
> pci 0000:00:04.0:   bridge window [mem 0x1c000000-0x23ffffff pref]
> pci 0000:00:08.0: CardBus bridge to [bus 09-0c]
> pci 0000:00:08.0:   bridge window [io  0x1400-0x14ff]
> pci 0000:00:08.0:   bridge window [io  0x1c00-0x1cff]
> pci 0000:00:08.0:   bridge window [mem 0x24000000-0x27ffffff pref]
> pci 0000:00:08.0:   bridge window [mem 0x28000000-0x2bffffff]
> pci 0000:00:08.1: CardBus bridge to [bus 0d-10]
> pci 0000:00:08.1:   bridge window [io  0x3400-0x34ff]
> pci 0000:00:08.1:   bridge window [io  0x3800-0x38ff]
> pci 0000:00:08.1:   bridge window [mem 0x2c000000-0x2fffffff pref]
> pci 0000:00:08.1:   bridge window [mem 0x30000000-0x33ffffff]
> ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 9
> PCI: setting IRQ 9 as level-triggered
> pci 0000:02:02.0: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
> pci 0000:02:02.1: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
> pci 0000:00:08.0: power state changed by ACPI to D0
> ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> PCI: setting IRQ 11 as level-triggered
> pci 0000:00:08.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> pci 0000:00:08.1: power state changed by ACPI to D0
> ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> pci 0000:00:08.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
> pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
> pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
> pci_bus 0000:01: resource 1 [mem 0xf4100000-0xf5ffffff]
> pci_bus 0000:01: resource 2 [mem 0x34000000-0x340fffff pref]
> pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
> pci_bus 0000:02: resource 1 [mem 0x14000000-0x1bffffff]
> pci_bus 0000:02: resource 2 [mem 0x1c000000-0x23ffffff pref]
> pci_bus 0000:02: resource 3 [io  0x0000-0xffff]
> pci_bus 0000:02: resource 4 [mem 0x00000000-0xffffffff]
> pci_bus 0000:03: resource 0 [io  0x4000-0x40ff]
> pci_bus 0000:03: resource 1 [io  0x4400-0x44ff]
> pci_bus 0000:03: resource 2 [mem 0x1c000000-0x1fffffff pref]
> pci_bus 0000:03: resource 3 [mem 0x14000000-0x17ffffff]
> pci_bus 0000:07: resource 0 [io  0x4800-0x48ff]
> pci_bus 0000:07: resource 1 [io  0x4c00-0x4cff]
> pci_bus 0000:07: resource 2 [mem 0x20000000-0x23ffffff pref]
> pci_bus 0000:07: resource 3 [mem 0x18000000-0x1bffffff]
> pci_bus 0000:09: resource 0 [io  0x1400-0x14ff]
> pci_bus 0000:09: resource 1 [io  0x1c00-0x1cff]
> pci_bus 0000:09: resource 2 [mem 0x24000000-0x27ffffff pref]
> pci_bus 0000:09: resource 3 [mem 0x28000000-0x2bffffff]
> pci_bus 0000:0d: resource 0 [io  0x3400-0x34ff]
> pci_bus 0000:0d: resource 1 [io  0x3800-0x38ff]
> pci_bus 0000:0d: resource 2 [mem 0x2c000000-0x2fffffff pref]
> pci_bus 0000:0d: resource 3 [mem 0x30000000-0x33ffffff]
> NET: Registered protocol family 2
> IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
> TCP established hash table entries: 16384 (order: 5, 131072 bytes)
> TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
> TCP: Hash tables configured (established 16384 bind 16384)
> TCP reno registered
> UDP hash table entries: 256 (order: 0, 4096 bytes)
> UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> NET: Registered protocol family 1
> pci 0000:00:00.0: Limiting direct PCI/PCI transfers
> pci 0000:01:00.0: Boot video device
> PCI: CLS 32 bytes, default 32
> Unpacking initramfs...
> Freeing initrd memory: 3955k freed
> Simple Boot Flag at 0x35 set to 0x1
> HugeTLB registered 4 MB page size, pre-allocated 0 pages
> VFS: Disk quotas dquot_6.5.2
> Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
> msgmni has been set to 625
> alg: No test for stdrng (krng)
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
> io scheduler noop registered
> io scheduler deadline registered
> io scheduler cfq registered (default)
> Non-volatile memory driver v1.3
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> serial 00:0b: activated
> 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> serial 0000:00:0a.1: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
> e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> e100 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 9 (level, low) -> IRQ 9
> e100 0000:00:0a.0: PME# disabled
> e100: eth0: e100_probe: addr 0xf4010000, irq 9, MAC addr 00:90:27:96:b1:d0
> console [netcon0] enabled
> netconsole: network logging started
> PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
> serio: i8042 KBD port at 0x60,0x64 irq 1
> serio: i8042 AUX port at 0x60,0x64 irq 12
> mice: PS/2 mouse device common for all mice
> rtc_cmos 00:06: RTC can wake from S4
> rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> rtc0: alarms up to one month, y3k, 242 bytes nvram
> cpuidle: using governor ladder
> cpuidle: using governor menu
> TCP cubic registered
> NET: Registered protocol family 10
> lo: Disabled Privacy Extensions
> NET: Registered protocol family 17
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> rtc_cmos 00:06: setting system clock to 2010-02-14 15:09:23 UTC (1266160163)
> Freeing unused kernel memory: 272k freed
> Write protecting the kernel text: 2388k
> Write protecting the kernel read-only data: 728k
> thermal LNXTHERM:01: registered as thermal_zone0
> ACPI: Thermal Zone [THM0] (48 C)
> Linux agpgart interface v0.103
> SCSI subsystem initialized
> Floppy drive(s): fd0 is 1.44M
> agpgart-intel 0000:00:00.0: Intel 440BX Chipset
> agpgart-intel 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
> ohci1394 0000:02:00.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> uhci_hcd: USB Universal Host Controller Interface driver
> libata version 3.00 loaded.
> ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> uhci_hcd 0000:00:07.2: PCI INT D -> Link[LNKD] -> GSI 11 (level, low) -> IRQ 11
> uhci_hcd 0000:00:07.2: UHCI Host Controller
> uhci_hcd 0000:00:07.2: new USB bus registered, assigned bus number 1
> uhci_hcd 0000:00:07.2: irq 11, io base 0x00001820
> usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
> usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> usb usb1: Product: UHCI Host Controller
> usb usb1: Manufacturer: Linux 2.6.33-rc8 uhci_hcd
> usb usb1: SerialNumber: 0000:00:07.2
> hub 1-0:1.0: USB hub found
> hub 1-0:1.0: 2 ports detected
> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[11]  MMIO=[f6000000-f60007ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
> pata_cmd64x 0000:02:01.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
> scsi0 : pata_cmd64x
> scsi1 : pata_cmd64x
> ata1: PATA max UDMA/66 cmd 0x30a0 ctl 0x3094 bmdma 0x3080 irq 11
> ata2: PATA max UDMA/66 cmd 0x3098 ctl 0x3090 bmdma 0x3088 irq 11
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> ata_piix 0000:00:07.1: version 2.13
> scsi2 : ata_piix
> scsi3 : ata_piix
> ata3: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x1800 irq 14
> ata4: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x1808 irq 15
> pata_cmd64x: active 10 recovery 10 setup 3.
> pata_cmd64x: active 10 recovery 10 setup 3.
> ata3.00: ATA-5: IC25N020ATCS04-0, CA2OA71A, max UDMA/100
> ata3.00: 39070080 sectors, multi 16: LBA 
> ata3.00: configured for UDMA/33
> usb 1-1: new full speed USB device using uhci_hcd and address 2
> scsi 2:0:0:0: Direct-Access     ATA      IC25N020ATCS04-0 CA2O PQ: 0 ANSI: 5
> sd 2:0:0:0: [sda] 39070080 512-byte logical blocks: (20.0 GB/18.6 GiB)
> sd 2:0:0:0: [sda] Write Protect is off
> sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sda: sda1 sda2
> sd 2:0:0:0: [sda] Attached SCSI disk
> usb 1-1: New USB device found, idVendor=0451, idProduct=2036
> usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
> usb 1-1: Product: General Purpose USB Hub
> hub 1-1:1.0: USB hub found
> hub 1-1:1.0: 2 ports detected
> usb 1-1.1: new full speed USB device using uhci_hcd and address 3
> usb 1-1.1: New USB device found, idVendor=03eb, idProduct=3312
> usb 1-1.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> hub 1-1.1:1.0: USB hub found
> hub 1-1.1:1.0: 4 ports detected
> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011060000004434]
> floppy0: no floppy controllers found
> Floppy drive(s): fd0 is 1.44M
> floppy0: no floppy controllers found
> PM: Starting manual resume from disk
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs (sda1): mounted filesystem with writeback data mode
> udev: starting version 150
> input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
> Marking TSC unstable due to TSC halts in idle
> Switching to clocksource acpi_pm
> ACPI: Lid Switch [LID]
> input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
> ACPI: Sleep Button [SLPB]
> input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
> ACPI: Power Button [PWRF]
> ACPI: AC Adapter [AC] (on-line)
> ACPI: Battery Slot [BAT0] (battery present)
> Floppy drive(s): fd0 is 1.44M
> parport_pc 00:0c: activated
> parport_pc 00:0c: reported by Plug and Play ACPI
> parport0: PC-style at 0x3bc (0x7bc), irq 7, dma 1 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
> yenta_cardbus 0000:00:08.0: CardBus bridge found [1014:0185]
> yenta_cardbus 0000:00:08.0: ISA IRQ mask 0x0438, PCI irq 11
> yenta_cardbus 0000:00:08.0: Socket status: 30000006
> yenta_cardbus 0000:00:08.1: CardBus bridge found [1014:0185]
> yenta_cardbus 0000:00:08.1: ISA IRQ mask 0x0438, PCI irq 11
> yenta_cardbus 0000:00:08.1: Socket status: 30000006
> IBM TrackPoint firmware: 0x0e, buttons: 3/3
> input: TPPS/2 IBM TrackPoint as /devices/platform/i8042/serio1/input/input4
> yenta_cardbus 0000:02:02.0: CardBus bridge found [1014:0148]
> yenta_cardbus 0000:02:02.0: Using INTVAL to route CSC interrupts to PCI
> yenta_cardbus 0000:02:02.0: Routing CardBus interrupts to PCI
> yenta_cardbus 0000:02:02.0: TI: mfunc 0x00001002, devctl 0x66
> irq 11: nobody cared (try booting with the "irqpoll" option)
> Pid: 689, comm: modprobe Not tainted 2.6.33-rc8 #1
> Call Trace:
>  [<c12518be>] ? printk+0x18/0x1a
>  [<c104b7d7>] __report_bad_irq+0x27/0x90
>  [<c104b999>] note_interrupt+0x159/0x190
>  [<c103bf66>] ? clockevents_program_event+0x86/0x140
>  [<c104c0bb>] handle_level_irq+0x8b/0xc0
>  [<c100480e>] handle_irq+0x7e/0x90
>  [<c100442a>] do_IRQ+0x3a/0xa0
>  [<c103c7b7>] ? tick_program_event+0x17/0x20
>  [<c1034087>] ? hrtimer_interrupt+0x177/0x280
>  [<c104c030>] ? handle_level_irq+0x0/0xc0
>  [<c10031f0>] common_interrupt+0x30/0x38
>  [<c104c030>] ? handle_level_irq+0x0/0xc0
>  [<c104a7e7>] ? handle_IRQ_event+0x17/0xd0
>  [<c104c030>] ? handle_level_irq+0x0/0xc0
>  [<c104c07a>] handle_level_irq+0x4a/0xc0
>  <IRQ>  [<c100442a>] ? do_IRQ+0x3a/0xa0
>  [<c104ae0c>] ? __enable_irq+0x7c/0x90
>  [<c10031f0>] ? common_interrupt+0x30/0x38
>  [<d4c08083>] ? yenta_probe_cb_irq+0x93/0x120 [yenta_socket]
>  [<d4c0839a>] ? ti12xx_override+0x28a/0x760 [yenta_socket]
>  [<d4c08e5c>] ? yenta_probe+0x345/0x75a [yenta_socket]
>  [<c111641e>] ? local_pci_probe+0xe/0x10
>  [<c11170d0>] ? pci_device_probe+0x60/0x80
>  [<c1179861>] ? driver_probe_device+0x81/0x180
>  [<c11163fb>] ? pci_match_device+0x9b/0xb0
>  [<c11799e9>] ? __driver_attach+0x89/0x90
>  [<c1179108>] ? bus_for_each_dev+0x48/0x70
>  [<c11796f9>] ? driver_attach+0x19/0x20
>  [<c1179960>] ? __driver_attach+0x0/0x90
>  [<c1178b2f>] ? bus_add_driver+0x19f/0x260
>  [<c1116420>] ? pci_device_shutdown+0x0/0x20
>  [<c1116420>] ? pci_device_shutdown+0x0/0x20
>  [<c1179c85>] ? driver_register+0x65/0x120
>  [<c11172c9>] ? __pci_register_driver+0x39/0xb0
>  [<d4c0d017>] ? yenta_socket_init+0x17/0x19 [yenta_socket]
>  [<c100111d>] ? do_one_initcall+0x2d/0x180
>  [<d4c0d000>] ? yenta_socket_init+0x0/0x19 [yenta_socket]
>  [<c104472f>] ? sys_init_module+0xaf/0x210
>  [<c1002cd7>] ? sysenter_do_call+0x12/0x26
> handlers:
> [<d4969940>] (usb_hcd_irq+0x0/0x60 [usbcore])
> [<d484a090>] (ohci_irq_handler+0x0/0x850 [ohci1394])
> [<d491bac0>] (ata_sff_interrupt+0x0/0xe0 [libata])
> [<d4c08930>] (yenta_interrupt+0x0/0xd0 [yenta_socket])
> [<d4c08930>] (yenta_interrupt+0x0/0xd0 [yenta_socket])
> Disabling IRQ #11
> yenta_cardbus 0000:02:02.0: ISA IRQ mask 0x0438, PCI irq 9
> yenta_cardbus 0000:02:02.0: Socket status: 30000006
> yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
> yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge Memory window: 0x14000000 - 0x1bffffff
> yenta_cardbus 0000:02:02.0: pcmcia: parent PCI bridge Memory window: 0x1c000000 - 0x23ffffff
> yenta_cardbus 0000:02:02.1: CardBus bridge found [1014:0148]
> yenta_cardbus 0000:02:02.1: Using INTVAL to route CSC interrupts to PCI
> yenta_cardbus 0000:02:02.1: Routing CardBus interrupts to PCI
> yenta_cardbus 0000:02:02.1: TI: mfunc 0x00001002, devctl 0x66
> floppy0: no floppy controllers found
> yenta_cardbus 0000:02:02.1: ISA IRQ mask 0x0438, PCI irq 9
> yenta_cardbus 0000:02:02.1: Socket status: 30000006
> yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge I/O window: 0x4000 - 0x4fff
> yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge Memory window: 0x14000000 - 0x1bffffff
> yenta_cardbus 0000:02:02.1: pcmcia: parent PCI bridge Memory window: 0x1c000000 - 0x23ffffff
> thinkpad_acpi: ThinkPad ACPI Extras v0.24
> thinkpad_acpi: http://ibm-acpi.sf.net/
> thinkpad_acpi: ThinkPad BIOS IZET9BWW (2.23 ), EC unknown
> thinkpad_acpi: WARNING: Outdated ThinkPad BIOS/EC firmware
> thinkpad_acpi: WARNING: This firmware may be missing critical bug fixes and/or important features
> Registered led device: tpacpi::thinklight
> Registered led device: tpacpi::power
> Registered led device: tpacpi::standby
> thinkpad_acpi: Console audio control enabled, mode: monitor (read only)
> input: ThinkPad Extra Buttons as /devices/platform/thinkpad_acpi/input/input5
> CS4281 0000:00:0b.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> IRQ 11
> gameport: CS4281 Gameport is pci0000:00:0b.0/gameport0, speed 2294kHz
> Adding 680392k swap on /dev/sda2.  Priority:-1 extents:1 across:680392k 
> EXT3-fs (sda1): using internal journal
> fuse init (API version 7.13)
> e100 0000:00:0a.0: firmware: using built-in firmware e100/d101s_ucode.bin
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> e100: eth0 NIC Link is Up 100 Mbps Full Duplex
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> input: ACPI Virtual Keyboard Device as /devices/virtual/input/input6
> thinkpad_acpi: asked for hotkey mask 0x0006080c, but firmware forced it to 0x0000080c
> input: /usr/sbin/thinkpad-keys as /devices/virtual/input/input7
> ADDRCONF(NETDEV_UP): eth0: link is not ready
> e100: eth0 NIC Link is Up 100 Mbps Full Duplex
> ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> Bluetooth: Core ver 2.15
> NET: Registered protocol family 31
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: L2CAP ver 2.14
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: RFCOMM TTY layer initialized
> Bluetooth: RFCOMM socket layer initialized
> Bluetooth: RFCOMM ver 1.11
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bridge firewalling registered
> Bluetooth: SCO (Voice Link) ver 0.6
> Bluetooth: SCO socket layer initialized
> lp0: using parport0 (interrupt-driven).
> 
> 00:00.0 Host bridge [0600]: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge [8086:7190] (rev 03)
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
> 	Latency: 64
> 	Region 0: Memory at f8000000 (32-bit, prefetchable) [size=64M]
> 	Capabilities: <access denied>
> 	Kernel driver in use: agpgart-intel
> 
> 00:01.0 PCI bridge [0604]: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP bridge [8086:7191] (rev 03) (prog-if 00 [Normal decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 128
> 	Bus: primary=00, secondary=01, subordinate=01, sec-latency=64
> 	I/O behind bridge: 00002000-00002fff
> 	Memory behind bridge: f4100000-f5ffffff
> 	Prefetchable memory behind bridge: 34000000-340fffff
> 	Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 
> 00:04.0 PCI bridge [0604]: Texas Instruments PCI2032 PCI Docking Bridge [104c:ac22] (prog-if 01 [Subtractive decode])
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64, Cache Line Size: 32 bytes
> 	Bus: primary=00, secondary=02, subordinate=08, sec-latency=68
> 	I/O behind bridge: 00004000-00004fff
> 	Memory behind bridge: 14000000-1bffffff
> 	Prefetchable memory behind bridge: 1c000000-23ffffff
> 	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
> 	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> 		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> 	Capabilities: <access denied>
> 
> 00:07.0 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ISA [8086:7110] (rev 02)
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0
> 
> 00:07.1 IDE interface [0101]: Intel Corporation 82371AB/EB/MB PIIX4 IDE [8086:7111] (rev 01) (prog-if 80 [Master])
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64
> 	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
> 	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
> 	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
> 	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
> 	Region 4: I/O ports at 1800 [size=16]
> 	Kernel driver in use: ata_piix
> 
> 00:07.2 USB Controller [0c03]: Intel Corporation 82371AB/EB/MB PIIX4 USB [8086:7112] (rev 01) (prog-if 00 [UHCI])
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64
> 	Interrupt: pin D routed to IRQ 11
> 	Region 4: I/O ports at 1820 [size=32]
> 	Kernel driver in use: uhci_hcd
> 
> 00:07.3 Bridge [0680]: Intel Corporation 82371AB/EB/MB PIIX4 ACPI [8086:7113] (rev 03)
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin ? routed to IRQ 9
> 
> 00:08.0 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev 80)
> 	Subsystem: IBM ThinkPad A/T/X Series [1014:0185]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 168
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at 50000000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=00, secondary=09, subordinate=0c, sec-latency=176
> 	Memory window 0: 24000000-27fff000 (prefetchable)
> 	Memory window 1: 28000000-2bfff000
> 	I/O window 0: 00001400-000014ff
> 	I/O window 1: 00001c00-00001cff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 
> 00:08.1 CardBus bridge [0607]: Ricoh Co Ltd RL5c476 II [1180:0476] (rev 80)
> 	Subsystem: IBM ThinkPad A/T/X Series [1014:0185]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 168
> 	Interrupt: pin B routed to IRQ 11
> 	Region 0: Memory at 50100000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=00, secondary=0d, subordinate=10, sec-latency=176
> 	Memory window 0: 2c000000-2ffff000 (prefetchable)
> 	Memory window 1: 30000000-33fff000
> 	I/O window 0: 00003400-000034ff
> 	I/O window 1: 00003800-000038ff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 
> 00:0a.0 Ethernet controller [0200]: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 [8086:1229] (rev 09)
> 	Subsystem: Intel Corporation EtherExpress PRO/100+ MiniPCI [8086:2408]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 66 (2000ns min, 14000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 9
> 	Region 0: Memory at f4010000 (32-bit, non-prefetchable) [size=4K]
> 	Region 1: I/O ports at 1840 [size=64]
> 	Region 2: Memory at f4020000 (32-bit, non-prefetchable) [size=128K]
> 	[virtual] Expansion ROM at 34100000 [disabled] [size=1M]
> 	Capabilities: <access denied>
> 	Kernel driver in use: e100
> 
> 00:0a.1 Serial controller [0700]: Xircom Mini-PCI V.90 56k Modem [115d:000c] (prog-if 02 [16550])
> 	Subsystem: Intel Corporation Device [8086:2408]
> 	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Interrupt: pin A routed to IRQ 9
> 	Region 0: I/O ports at 1810 [size=8]
> 	Region 1: Memory at f4011000 (32-bit, non-prefetchable) [size=4K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: serial
> 
> 00:0b.0 Multimedia audio controller [0401]: Cirrus Logic Crystal CS4281 PCI Audio [1013:6005] (rev 01)
> 	Subsystem: IBM Device [1014:0183]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (1000ns min, 6000ns max)
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at f4012000 (32-bit, non-prefetchable) [size=4K]
> 	Region 1: Memory at f4000000 (32-bit, non-prefetchable) [size=64K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: CS4281
> 
> 01:00.0 VGA compatible controller [0300]: ATI Technologies Inc Rage Mobility P/M AGP 2x [1002:4c4d] (rev 64) (prog-if 00 [VGA controller])
> 	Subsystem: IBM Device [1014:0182]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping+ SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 66 (2000ns min), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
> 	Region 1: I/O ports at 2000 [size=256]
> 	Region 2: Memory at f4100000 (32-bit, non-prefetchable) [size=4K]
> 	[virtual] Expansion ROM at 34000000 [disabled] [size=128K]
> 	Capabilities: <access denied>
> 
> 02:00.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller [1106:3044] (rev 46) (prog-if 10 [OHCI])
> 	Subsystem: VIA Technologies, Inc. VT6306/7/8 [Fire II(M)] IEEE 1394 OHCI Controller [1106:3044]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (8000ns max), Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=2K]
> 	Region 1: I/O ports at 3000 [size=128]
> 	Capabilities: <access denied>
> 	Kernel driver in use: ohci1394
> 
> 02:01.0 IDE interface [0101]: Silicon Image, Inc. PCI0648 [1095:0648] (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
> 	Subsystem: Silicon Image, Inc. PCI0648 [1095:0648]
> 	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 64 (500ns min, 1000ns max)
> 	Interrupt: pin A routed to IRQ 11
> 	Region 0: I/O ports at 30a0 [size=8]
> 	Region 1: I/O ports at 3094 [size=4]
> 	Region 2: I/O ports at 3098 [size=8]
> 	Region 3: I/O ports at 3090 [size=4]
> 	Region 4: I/O ports at 3080 [size=16]
> 	Capabilities: <access denied>
> 	Kernel driver in use: pata_cmd64x
> 
> 02:02.0 CardBus bridge [0607]: Texas Instruments PCI1420 PC card Cardbus Controller [104c:ac51]
> 	Subsystem: IBM ThinkPad A20m [1014:0148]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 168, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 9
> 	Region 0: Memory at 52000000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=02, secondary=03, subordinate=06, sec-latency=176
> 	Memory window 0: 1c000000-1ffff000 (prefetchable)
> 	Memory window 1: 14000000-17fff000
> 	I/O window 0: 00004000-000040ff
> 	I/O window 1: 00004400-000044ff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 
> 02:02.1 CardBus bridge [0607]: Texas Instruments PCI1420 PC card Cardbus Controller [104c:ac51]
> 	Subsystem: IBM ThinkPad A20m [1014:0148]
> 	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 168, Cache Line Size: 32 bytes
> 	Interrupt: pin A routed to IRQ 9
> 	Region 0: Memory at 53000000 (32-bit, non-prefetchable) [size=4K]
> 	Bus: primary=02, secondary=07, subordinate=07, sec-latency=176
> 	Memory window 0: 20000000-23fff000 (prefetchable)
> 	Memory window 1: 18000000-1bfff000
> 	I/O window 0: 00004800-000048ff
> 	I/O window 1: 00004c00-00004cff
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
> 	16-bit legacy interface ports at 0001
> 	Kernel driver in use: yenta_cardbus
> 
> 
> 

