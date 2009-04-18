Return-Path: <linux-kernel-owner+w=401wt.eu-S1757110AbZDRILn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110AbZDRILn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZDRILY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:11:24 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28614 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbZDRILP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:11:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=wsglCXFb+CU2VPmJGE1kQG06eVANb2Yq/uIXQYV/x0ERPvAjD9Z61pY8mp+qnChVlN
         ZZyatdMbc7DwJbsMbnkjyCnp3WFIwK22xlN2khBf31T5pZfJ7f24TjRXybEObSZve1ZB
         TFdpmQnZCDfl0ybI4yMKQmv3vIRIgEfMFNihw=
Message-ID: <49E98C4C.8090007@tuffmail.co.uk>
Date: Sat, 18 Apr 2009 09:16:12 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13058] First hibernation attempt fails
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <alpine.LFD.2.00.0904170856460.4042@localhost.localdomain> <49E8C06A.5080605@tuffmail.co.uk> <200904172258.58783.rjw@sisk.pl> <alpine.LFD.2.00.0904171408081.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904171408081.4042@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------060307030408060105010404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060307030408060105010404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> On Fri, 17 Apr 2009, Rafael J. Wysocki wrote:
>   
>> Can you please try to reproduce the problem with the appended debug patch
>> applied and send the output of dmesg to me?
>>     
>
> Maybe something like this instead (or in addition to).
>
> It does "show_mem()" when memory shrinking fails. It will show a _lot_ of 
> data.
>
> Untested, but trivial.
>
> 		Linus
> ---
>   

Ok, I applied both your and Rafael's debug patches.  dmesg attached.

After the failed hibernation, I noticed my touchpad wasn't working.  But 
I think that's something else.  I had another go and couldn't reproduce 
that.  It's happened to me once before while testing 2.6.30-; I've also 
had the keyboard stop working at least once.  I'm hoping it's the same 
bug as "20 ACPI interrupts per second on EEEPC" bug.  It could be 
overloading my bug-ridden EC, which also acts as the keyboard controller.

Thanks
Alan

--------------060307030408060105010404
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

[    0.000000] Linux version 2.6.30-rc2eeepc (alan@alan-desktop) (gcc version 4.2.4 (Ubuntu 4.2.4-1ubuntu3)) #240 Sat Apr 18 08:47:04 BST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f780000 (usable)
[    0.000000]  BIOS-e820: 000000001f780000 - 000000001f790000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f790000 - 000000001f7d0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7d0000 - 000000001f7de000 (reserved)
[    0.000000]  BIOS-e820: 000000001f7e0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x1f780 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FE0000000 write-back
[    0.000000]   1 base 01F800000 mask FFF800000 uncachable
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] init_memory_mapping: 0000000000000000-000000001f780000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 001f600000 page 2M
[    0.000000]  001f600000 - 001f780000 page 4k
[    0.000000] kernel direct mapping tables up to 1f780000 @ 10000-16000
[    0.000000] RAMDISK: 17724000 - 179df533
[    0.000000] ACPI: RSDP 000fbe50 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 1f780000 00034 (v01 A M I  OEMRSDT  03000911 MSFT 00000097)
[    0.000000] ACPI: FACP 1f780200 00081 (v01 A M I  OEMFACP  03000911 MSFT 00000097)
[    0.000000] ACPI: DSDT 1f780400 06069 (v01  A0797 A0797000 00000000 INTL 20060113)
[    0.000000] ACPI: FACS 1f790000 00040
[    0.000000] ACPI: APIC 1f780390 00068 (v01 A M I  OEMAPIC  03000911 MSFT 00000097)
[    0.000000] ACPI: OEMB 1f790040 00046 (v01 A M I  AMI_OEM  03000911 MSFT 00000097)
[    0.000000] ACPI: MCFG 1f786470 0003C (v01 A M I  OEMMCFG  03000911 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f780000
[    0.000000]   low ram: 0 - 1f780000
[    0.000000]   node 0 low ram: 00000000 - 1f780000
[    0.000000]   node 0 bootmap 00012000 - 00015ef0
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 001f780000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000100000 - 00008ec0ac]    TEXT DATA BSS ==> [0000100000 - 00008ec0ac]
[    0.000000]   #2 [0017724000 - 00179df533]          RAMDISK ==> [0017724000 - 00179df533]
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
[    0.000000]   #4 [00008ed000 - 00008f41f4]              BRK ==> [00008ed000 - 00008f41f4]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000016000]          BOOTMAP ==> [0000012000 - 0000016000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f780
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f780
[    0.000000] On node 0 totalpages: 128783
[    0.000000] free_area_init_node: node 0, pgdat c043836c, node_mem_map c1000200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 975 pages used for memmap
[    0.000000]   Normal zone: 123825 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 1f800000:df600000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127776
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.30-rc2eeepc root=/dev/sda2 ro root=/dev/sda2 rootfstype=ext4 resume=/dev/sda2 resume_offset=9732
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] NR_IRQS:288
[    0.000000] PID hash table entries: 2048 (order: 11, 8192 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 630.041 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.003333] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.003333] ... MAX_LOCK_DEPTH:          48
[    0.003333] ... MAX_LOCKDEP_KEYS:        8191
[    0.003333] ... CLASSHASH_SIZE:          4096
[    0.003333] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.003333] ... MAX_LOCKDEP_CHAINS:      16384
[    0.003333] ... CHAINHASH_SIZE:          8192
[    0.003333]  memory used by lock dependency info: 2847 kB
[    0.003333]  per task-struct memory footprint: 1152 bytes
[    0.003333] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.003333] Memory: 499536k/515584k available (2045k kernel code, 15424k reserved, 1290k data, 248k init, 0k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
[    0.003333]     vmalloc : 0xdff80000 - 0xfffa8000   ( 512 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xdf780000   ( 503 MB)
[    0.003333]       .init : 0xc0446000 - 0xc0484000   ( 248 kB)
[    0.003333]       .data : 0xc02ff503 - 0xc04420a8   (1290 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02ff503   (2045 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.003383] Calibrating delay loop (skipped), value calculated using timer frequency.. 1260.58 BogoMIPS (lpj=2100136)
[    0.003680] Mount-cache hash table entries: 512
[    0.006328] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.006474] CPU: L2 cache: 512K
[    0.006681] [ds] using Pentium M configuration
[    0.006778] [ds] pebs not available
[    0.006874] Intel machine check architecture supported.
[    0.006978] Intel machine check reporting enabled on CPU#0.
[    0.007093] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.007298] Checking 'hlt' instruction... OK.
[    0.020678] ACPI: Core revision 20090320
[    0.054619] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.089999] PM: Adding info for No Bus:platform
[    0.089999] net_namespace: 1136 bytes
[    0.091819] NET: Registered protocol family 16
[    0.092936] PM: Adding info for No Bus:vtcon0
[    0.093174] ACPI: bus type pci registered
[    0.093492] PM: Adding info for No Bus:id
[    0.093715] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.093827] PCI: Not using MMCONFIG.
[    0.094216] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.094321] PCI: Using configuration type 1 for base access
[    0.097919] PM: Adding info for No Bus:default
[    0.098189] bio: create slab <bio-0> at 0
[    0.120455] ACPI: EC: Look up EC in DSDT
[    0.157798] ACPI: Interpreter enabled
[    0.157918] ACPI: (supports S0 S1 S3 S4 S5)
[    0.158404] ACPI: Using IOAPIC for interrupt routing
[    0.158727] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.168936] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.169048] PCI: Using MMCONFIG for extended config space
[    0.169477] PM: Adding info for acpi:LNXSYSTM:00
[    0.169626] PM: Adding info for acpi:LNXPWRBN:00
[    0.169822] PM: Adding info for acpi:ACPI_CPU:00
[    0.170102] PM: Adding info for acpi:device:00
[    0.170883] PM: Adding info for acpi:PNP0A08:00
[    0.171147] PM: Adding info for acpi:PNP0C01:00
[    0.172036] PM: Adding info for acpi:device:01
[    0.172887] PM: Adding info for acpi:device:02
[    0.173746] PM: Adding info for acpi:device:03
[    0.174591] PM: Adding info for acpi:device:04
[    0.175430] PM: Adding info for acpi:device:05
[    0.175645] PM: Adding info for acpi:device:06
[    0.175889] PM: Adding info for acpi:PNP0000:00
[    0.176126] PM: Adding info for acpi:PNP0200:00
[    0.176365] PM: Adding info for acpi:PNP0100:00
[    0.176595] PM: Adding info for acpi:PNP0B00:00
[    0.177248] PM: Adding info for acpi:PNP0303:00
[    0.177887] PM: Adding info for acpi:SYN0A00:00
[    0.178138] PM: Adding info for acpi:PNP0800:00
[    0.178369] PM: Adding info for acpi:PNP0C04:00
[    0.178642] PM: Adding info for acpi:PNP0C09:00
[    0.179538] PM: Adding info for acpi:PNP0C02:00
[    0.180313] PM: Adding info for acpi:PNP0C02:01
[    0.180635] PM: Adding info for acpi:PNP0C02:02
[    0.181419] PM: Adding info for acpi:PNP0C0A:00
[    0.181728] PM: Adding info for acpi:ACPI0003:00
[    0.181973] PM: Adding info for acpi:device:07
[    0.182314] PM: Adding info for acpi:device:08
[    0.182516] PM: Adding info for acpi:device:09
[    0.182729] PM: Adding info for acpi:device:0a
[    0.182938] PM: Adding info for acpi:device:0b
[    0.183138] PM: Adding info for acpi:device:0c
[    0.183359] PM: Adding info for acpi:device:0d
[    0.184311] PM: Adding info for acpi:device:0e
[    0.185157] PM: Adding info for acpi:device:0f
[    0.186004] PM: Adding info for acpi:device:10
[    0.186868] PM: Adding info for acpi:device:11
[    0.187718] PM: Adding info for acpi:device:12
[    0.188563] PM: Adding info for acpi:device:13
[    0.188768] PM: Adding info for acpi:device:14
[    0.188975] PM: Adding info for acpi:device:15
[    0.189218] PM: Adding info for acpi:device:16
[    0.189482] PM: Adding info for acpi:device:17
[    0.189692] PM: Adding info for acpi:device:18
[    0.189901] PM: Adding info for acpi:device:19
[    0.190214] PM: Adding info for acpi:PNP0C02:03
[    0.190461] PM: Adding info for acpi:PNP0C01:01
[    0.190717] PM: Adding info for acpi:ASUS010:00
[    0.191022] PM: Adding info for acpi:PNP0C0D:00
[    0.191261] PM: Adding info for acpi:PNP0C0E:00
[    0.191524] PM: Adding info for acpi:PNP0C0C:00
[    0.192134] PM: Adding info for acpi:PNP0C0F:00
[    0.192742] PM: Adding info for acpi:PNP0C0F:01
[    0.193381] PM: Adding info for acpi:PNP0C0F:02
[    0.193995] PM: Adding info for acpi:PNP0C0F:03
[    0.194603] PM: Adding info for acpi:PNP0C0F:04
[    0.195217] PM: Adding info for acpi:PNP0C0F:05
[    0.195822] PM: Adding info for acpi:PNP0C0F:06
[    0.196441] PM: Adding info for acpi:PNP0C0F:07
[    0.196750] PM: Adding info for acpi:LNXTHERM:00
[    0.196918] PM: Adding info for acpi:LNXTHERM:01
[    0.198033] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.198143] ACPI: EC: driver started in poll mode
[    0.199451] ACPI: No dock devices found.
[    0.199837] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.200126] PM: Adding info for No Bus:pci0000:00
[    0.200185] PM: Adding info for No Bus:0000:00
[    0.200727] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.200750] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.200771] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.200792] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.200940] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.201254] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.201385] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.201498] pci 0000:00:1b.0: PME# disabled
[    0.201765] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.201875] pci 0000:00:1c.0: PME# disabled
[    0.202149] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.202258] pci 0000:00:1c.1: PME# disabled
[    0.202530] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.202640] pci 0000:00:1c.2: PME# disabled
[    0.202874] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.203025] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.203171] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.203357] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.203514] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.203656] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.203766] pci 0000:00:1d.7: PME# disabled
[    0.204179] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.204200] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.204345] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.204456] pci 0000:00:1f.0: LPC Generic IO decode 1 PIO at 0380-03ff
[    0.204654] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.204676] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.204697] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.204718] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.204739] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.204818] pci 0000:00:1f.2: PME# supported from D3hot
[    0.204923] pci 0000:00:1f.2: PME# disabled
[    0.205133] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.205489] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.205568] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.205660] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.205769] pci 0000:03:00.0: PME# disabled
[    0.205986] pci 0000:03:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.206602] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.206781] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.206803] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.206953] pci 0000:00:1e.0: transparent bridge
[    0.207127] pci_bus 0000:00: on NUMA node 0
[    0.207163] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.207966] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.208205] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.208423] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.210386] PM: Adding info for pci:0000:00:00.0
[    0.211916] PM: Adding info for pci:0000:00:02.0
[    0.213433] PM: Adding info for pci:0000:00:02.1
[    0.214949] PM: Adding info for pci:0000:00:1b.0
[    0.216467] PM: Adding info for pci:0000:00:1c.0
[    0.218010] PM: Adding info for pci:0000:00:1c.1
[    0.219556] PM: Adding info for pci:0000:00:1c.2
[    0.221113] PM: Adding info for pci:0000:00:1d.0
[    0.222645] PM: Adding info for pci:0000:00:1d.1
[    0.224187] PM: Adding info for pci:0000:00:1d.2
[    0.225707] PM: Adding info for pci:0000:00:1d.3
[    0.227255] PM: Adding info for pci:0000:00:1d.7
[    0.228776] PM: Adding info for pci:0000:00:1e.0
[    0.230327] PM: Adding info for pci:0000:00:1f.0
[    0.231851] PM: Adding info for pci:0000:00:1f.2
[    0.233389] PM: Adding info for pci:0000:00:1f.3
[    0.233495] PM: Adding info for No Bus:0000:04
[    0.233670] PM: Adding info for pci:0000:03:00.0
[    0.233766] PM: Adding info for No Bus:0000:03
[    0.233860] PM: Adding info for No Bus:0000:01
[    0.233954] PM: Adding info for No Bus:0000:05
[    0.234819] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.236014] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.237213] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.238398] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.239594] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.240922] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.242230] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.243558] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.245027] SCSI subsystem initialized
[    0.261558] libata version 3.00 loaded.
[    0.262173] PCI: Using ACPI for IRQ routing
[    0.263385] PM: Adding info for No Bus:lo
[    0.264418] hpet clockevent registered
[    0.264428] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.264545] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.264828] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.271687] pnp: PnP ACPI init
[    0.271877] PM: Adding info for No Bus:pnp0
[    0.271893] ACPI: bus type pnp registered
[    0.272885] PM: Adding info for pnp:00:00
[    0.273212] PM: Adding info for pnp:00:01
[    0.273611] PM: Adding info for pnp:00:02
[    0.273858] PM: Adding info for pnp:00:03
[    0.274294] PM: Adding info for pnp:00:04
[    0.274900] PM: Adding info for pnp:00:05
[    0.275125] PM: Adding info for pnp:00:06
[    0.275354] PM: Adding info for pnp:00:07
[    0.276366] PM: Adding info for pnp:00:08
[    0.277396] PM: Adding info for pnp:00:09
[    0.277961] PM: Adding info for pnp:00:0a
[    0.278869] PM: Adding info for pnp:00:0b
[    0.280118] PM: Adding info for pnp:00:0c
[    0.281660] pnp: PnP ACPI: found 13 devices
[    0.281760] ACPI: ACPI bus type pnp unregistered
[    0.281908] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.282081] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.282191] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.284081] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.284193] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.284303] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.284415] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.284532] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.284697] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.284809] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.284941] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.285082] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.285216] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.285327] system 00:0c: iomem range 0xc0000-0xcffff could not be reserved
[    0.285439] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.285552] system 00:0c: iomem range 0x100000-0x1f7fffff could not be reserved
[    0.285848] PM: Adding info for No Bus:mem
[    0.286031] PM: Adding info for No Bus:kmem
[    0.286113] PM: Adding info for No Bus:null
[    0.286192] PM: Adding info for No Bus:port
[    0.286272] PM: Adding info for No Bus:zero
[    0.286353] PM: Adding info for No Bus:full
[    0.286432] PM: Adding info for No Bus:random
[    0.286515] PM: Adding info for No Bus:urandom
[    0.286596] PM: Adding info for No Bus:kmsg
[    0.322170] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.322276] pci 0000:00:1c.0:   IO window: disabled
[    0.322384] pci 0000:00:1c.0:   MEM window: disabled
[    0.322488] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.322601] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.322703] pci 0000:00:1c.1:   IO window: disabled
[    0.322811] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.322920] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.323032] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.323135] pci 0000:00:1c.2:   IO window: disabled
[    0.323242] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.323365] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.323516] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.323620] pci 0000:00:1e.0:   IO window: disabled
[    0.323727] pci 0000:00:1e.0:   MEM window: disabled
[    0.323831] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.323975] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.324093] pci 0000:00:1c.0: setting latency timer to 64
[    0.324122] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.324234] pci 0000:00:1c.1: setting latency timer to 64
[    0.324265] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.324377] pci 0000:00:1c.2: setting latency timer to 64
[    0.324401] pci 0000:00:1e.0: setting latency timer to 64
[    0.324417] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.324428] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.324440] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    0.324449] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    0.324459] pci_bus 0000:04: resource 2 mem: [0x0-0x0]
[    0.324468] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.324478] pci_bus 0000:03: resource 0 mem: [0x0-0x0]
[    0.324488] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.324498] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.324508] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.324518] pci_bus 0000:01: resource 0 mem: [0x0-0x0]
[    0.324528] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.324538] pci_bus 0000:01: resource 2 mem: [0xf0000000-0xf6ffffff]
[    0.324548] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.324558] pci_bus 0000:05: resource 0 mem: [0x0-0x0]
[    0.324568] pci_bus 0000:05: resource 1 mem: [0x0-0x0]
[    0.324577] pci_bus 0000:05: resource 2 mem: [0x0-0x0]
[    0.324587] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.324597] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.324808] NET: Registered protocol family 2
[    0.325624] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.328069] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    0.328653] TCP bind hash table entries: 16384 (order: 7, 524288 bytes)
[    0.334218] TCP: Hash tables configured (established 16384 bind 16384)
[    0.334466] TCP reno registered
[    0.335018] NET: Registered protocol family 1
[    0.335898] checking if image is initramfs...
[    0.619267] rootfs image is initramfs; unpacking...
[    0.619490] Freeing initrd memory: 2797k freed
[    0.625139] PM: Adding info for platform:pcspkr
[    0.625980] PM: Adding info for No Bus:snapshot
[    0.626432] audit: initializing netlink socket (disabled)
[    0.626714] type=2000 audit(1240041427.623:1): initialized
[    0.669232] msgmni has been set to 981
[    0.681678] alg: No test for stdrng (krng)
[    0.681904] io scheduler noop registered
[    0.682001] io scheduler anticipatory registered
[    0.682098] io scheduler deadline registered
[    0.682290] io scheduler cfq registered (default)
[    0.682435] pci 0000:00:02.0: Boot video device
[    0.683544] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.683588] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.683665] PM: Adding info for pci_express:0000:00:1c.0:pcie01
[    0.683764] PM: Adding info for pci_express:0000:00:1c.0:pcie04
[    0.683853] PM: Adding info for pci_express:0000:00:1c.0:pcie08
[    0.684182] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.684223] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.684286] PM: Adding info for pci_express:0000:00:1c.1:pcie01
[    0.684376] PM: Adding info for pci_express:0000:00:1c.1:pcie04
[    0.684465] PM: Adding info for pci_express:0000:00:1c.1:pcie08
[    0.684788] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.684828] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.684901] PM: Adding info for pci_express:0000:00:1c.2:pcie01
[    0.685002] PM: Adding info for pci_express:0000:00:1c.2:pcie04
[    0.685092] PM: Adding info for pci_express:0000:00:1c.2:pcie08
[    0.685625] PM: Adding info for No Bus:tty
[    0.685804] PM: Adding info for No Bus:console
[    0.685893] PM: Adding info for No Bus:tty0
[    0.686028] PM: Adding info for No Bus:vcs
[    0.686199] PM: Adding info for No Bus:vcsa
[    0.686340] PM: Adding info for No Bus:tty1
[    0.686422] PM: Adding info for No Bus:tty2
[    0.686503] PM: Adding info for No Bus:tty3
[    0.686591] PM: Adding info for No Bus:tty4
[    0.686708] PM: Adding info for No Bus:tty5
[    0.686790] PM: Adding info for No Bus:tty6
[    0.686872] PM: Adding info for No Bus:tty7
[    0.686952] PM: Adding info for No Bus:tty8
[    0.687033] PM: Adding info for No Bus:tty9
[    0.687115] PM: Adding info for No Bus:tty10
[    0.687197] PM: Adding info for No Bus:tty11
[    0.687279] PM: Adding info for No Bus:tty12
[    0.687362] PM: Adding info for No Bus:tty13
[    0.687445] PM: Adding info for No Bus:tty14
[    0.687532] PM: Adding info for No Bus:tty15
[    0.687621] PM: Adding info for No Bus:tty16
[    0.687705] PM: Adding info for No Bus:tty17
[    0.687788] PM: Adding info for No Bus:tty18
[    0.687871] PM: Adding info for No Bus:tty19
[    0.687956] PM: Adding info for No Bus:tty20
[    0.688040] PM: Adding info for No Bus:tty21
[    0.688125] PM: Adding info for No Bus:tty22
[    0.688210] PM: Adding info for No Bus:tty23
[    0.688294] PM: Adding info for No Bus:tty24
[    0.688379] PM: Adding info for No Bus:tty25
[    0.688464] PM: Adding info for No Bus:tty26
[    0.688551] PM: Adding info for No Bus:tty27
[    0.688643] PM: Adding info for No Bus:tty28
[    0.688730] PM: Adding info for No Bus:tty29
[    0.688814] PM: Adding info for No Bus:tty30
[    0.688910] PM: Adding info for No Bus:tty31
[    0.688997] PM: Adding info for No Bus:tty32
[    0.689083] PM: Adding info for No Bus:tty33
[    0.689168] PM: Adding info for No Bus:tty34
[    0.689257] PM: Adding info for No Bus:tty35
[    0.689346] PM: Adding info for No Bus:tty36
[    0.689432] PM: Adding info for No Bus:tty37
[    0.689521] PM: Adding info for No Bus:tty38
[    0.689610] PM: Adding info for No Bus:tty39
[    0.689702] PM: Adding info for No Bus:tty40
[    0.689789] PM: Adding info for No Bus:tty41
[    0.689875] PM: Adding info for No Bus:tty42
[    0.689979] PM: Adding info for No Bus:tty43
[    0.690073] PM: Adding info for No Bus:tty44
[    0.690161] PM: Adding info for No Bus:tty45
[    0.690249] PM: Adding info for No Bus:tty46
[    0.690340] PM: Adding info for No Bus:tty47
[    0.690427] PM: Adding info for No Bus:tty48
[    0.690514] PM: Adding info for No Bus:tty49
[    0.690601] PM: Adding info for No Bus:tty50
[    0.690699] PM: Adding info for No Bus:tty51
[    0.690795] PM: Adding info for No Bus:tty52
[    0.690884] PM: Adding info for No Bus:tty53
[    0.690972] PM: Adding info for No Bus:tty54
[    0.691062] PM: Adding info for No Bus:tty55
[    0.691151] PM: Adding info for No Bus:tty56
[    0.691241] PM: Adding info for No Bus:tty57
[    0.691329] PM: Adding info for No Bus:tty58
[    0.691419] PM: Adding info for No Bus:tty59
[    0.691509] PM: Adding info for No Bus:tty60
[    0.691598] PM: Adding info for No Bus:tty61
[    0.691690] PM: Adding info for No Bus:tty62
[    0.691783] PM: Adding info for No Bus:tty63
[    0.692242] PM: Adding info for No Bus:ptmx
[    0.692376] PM: Adding info for No Bus:hpet
[    0.692860] PM: Adding info for No Bus:ram0
[    0.693080] PM: Adding info for No Bus:1:0
[    0.693328] PM: Adding info for No Bus:ram1
[    0.693504] PM: Adding info for No Bus:1:1
[    0.693673] PM: Adding info for No Bus:ram2
[    0.693776] PM: Adding info for No Bus:1:2
[    0.693931] PM: Adding info for No Bus:ram3
[    0.694031] PM: Adding info for No Bus:1:3
[    0.694179] PM: Adding info for No Bus:ram4
[    0.694279] PM: Adding info for No Bus:1:4
[    0.694428] PM: Adding info for No Bus:ram5
[    0.694528] PM: Adding info for No Bus:1:5
[    0.694683] PM: Adding info for No Bus:ram6
[    0.694786] PM: Adding info for No Bus:1:6
[    0.694934] PM: Adding info for No Bus:ram7
[    0.695034] PM: Adding info for No Bus:1:7
[    0.695254] PM: Adding info for No Bus:ram8
[    0.695356] PM: Adding info for No Bus:1:8
[    0.695516] PM: Adding info for No Bus:ram9
[    0.695624] PM: Adding info for No Bus:1:9
[    0.695776] PM: Adding info for No Bus:ram10
[    0.695879] PM: Adding info for No Bus:1:10
[    0.696029] PM: Adding info for No Bus:ram11
[    0.696132] PM: Adding info for No Bus:1:11
[    0.696281] PM: Adding info for No Bus:ram12
[    0.696382] PM: Adding info for No Bus:1:12
[    0.696539] PM: Adding info for No Bus:ram13
[    0.696663] PM: Adding info for No Bus:1:13
[    0.696819] PM: Adding info for No Bus:ram14
[    0.696922] PM: Adding info for No Bus:1:14
[    0.697131] PM: Adding info for No Bus:ram15
[    0.697235] PM: Adding info for No Bus:1:15
[    0.697306] brd: module loaded
[    0.697483] Driver 'sd' needs updating - please use bus_type methods
[    0.697721] ahci 0000:00:1f.2: version 3.0
[    0.697830] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.698002] ahci 0000:00:1f.2: PCI INT B disabled
[    0.698120] ahci: probe of 0000:00:1f.2 failed with error -22
[    0.698392] ata_piix 0000:00:1f.2: version 2.12
[    0.698417] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.698534] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    0.698996] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.730030] scsi0 : ata_piix
[    0.730680] PM: Adding info for No Bus:host0
[    0.730811] PM: Adding info for No Bus:host0
[    0.731401] scsi1 : ata_piix
[    0.731533] PM: Adding info for No Bus:host1
[    0.731652] PM: Adding info for No Bus:host1
[    0.731718] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    0.731827] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    0.732397] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    0.732844] PM: Adding info for platform:i8042
[    0.744856] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.745179] PM: Adding info for No Bus:mice
[    0.745381] PM: Adding info for No Bus:psaux
[    0.745425] mice: PS/2 mouse device common for all mice
[    0.745683] rtc_cmos 00:03: RTC can wake from S4
[    0.746094] PM: Adding info for No Bus:rtc0
[    0.746297] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.746455] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    0.746645] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    0.746861] PM: Adding info for platform:iTCO_wdt
[    0.747067] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x0860)
[    0.747329] PM: Adding info for No Bus:watchdog
[    0.747373] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    0.747486] iTCO_vendor_support: vendor-support=0
[    0.747634] cpuidle: using governor ladder
[    0.747730] cpuidle: using governor menu
[    0.748124] Advanced Linux Sound Architecture Driver Version 1.0.19.
[    0.748229] ALSA device list:
[    0.748317]   No soundcards found.
[    0.750861] TCP cubic registered
[    0.750960] Using IPI Shortcut mode
[    0.751178] PM: Adding info for No Bus:cpu_dma_latency
[    0.751285] PM: Adding info for No Bus:network_latency
[    0.751430] PM: Adding info for No Bus:network_throughput
[    0.751877] PM: Adding info for serio:serio0
[    0.766668] Switched to NOHz mode on CPU #0
[    0.785428] PM: Adding info for No Bus:input0
[    0.785904] input: AT Translated Set 2 keyboard as /class/input/input0
[    1.077108] ata2.00: CFA: SILICONMOTION SM223AC, , max UDMA/66
[    1.077218] ata2.00: 7815024 sectors, multi 0: LBA 
[    1.090333] ata2.00: configured for UDMA/66
[    1.091809] scsi 1:0:0:0: Direct-Access     ATA      SILICONMOTION SM n/a  PQ: 0 ANSI: 5
[    1.092182] PM: Adding info for No Bus:target1:0:0
[    1.092455] PM: Adding info for scsi:1:0:0:0
[    1.093328] PM: Adding info for No Bus:1:0:0:0
[    1.093676] PM: Adding info for No Bus:1:0:0:0
[    1.094012] sd 1:0:0:0: [sda] 7815024 512-byte hardware sectors: (4.00 GB/3.72 GiB)
[    1.094233] sd 1:0:0:0: [sda] Write Protect is off
[    1.094335] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.094481] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.094751] PM: Adding info for No Bus:sda
[    1.095712]  sda: sda1 sda2
[    1.097080] PM: Adding info for No Bus:sda1
[    1.097597] PM: Adding info for No Bus:sda2
[    1.098014] PM: Adding info for No Bus:8:0
[    1.098101] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.098628] PM: Resume from partition /dev/sda2
[    1.098635] PM: Checking hibernation image.
[    1.100964] PM: Resume from disk failed.
[    1.101675] rtc_cmos 00:03: setting system clock to 2009-04-18 07:57:09 UTC (1240041429)
[    1.101828] BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
[    1.102623] Freeing unused kernel memory: 248k freed
[    1.354542] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    1.366312] PM: Adding info for No Bus:thermal_zone0
[    1.374534] thermal LNXTHERM:01: registered as thermal_zone0
[    1.374695] ACPI: Thermal Zone [TZ00] (32 C)
[    2.907760] PM: Starting manual resume from disk
[    2.907929] PM: Resume from partition 8:2
[    2.907936] PM: Checking hibernation image.
[    2.909243] PM: Resume from disk failed.
[    2.933167] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[    2.933184] PM: Basic memory bitmaps created
[    2.959910] PM: Basic memory bitmaps freed
[    2.983990] EXT4-fs: delayed allocation enabled
[    2.984099] EXT4-fs: file extents enabled
[    2.984438] EXT4-fs: mballoc enabled
[    2.984810] EXT4-fs: mounted filesystem sda2 without journal
[    3.756901] udev: starting version 140
[    3.757127] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[    4.367545] PM: Adding info for No Bus:event0
[    4.931001] PM: Adding info for No Bus:input1
[    4.931103] input: Power Button (FF) as /class/input/input1
[    4.931455] PM: Adding info for No Bus:event1
[    4.931506] ACPI: Power Button (FF) [PWRF]
[    4.931906] PM: Adding info for No Bus:input2
[    4.931998] input: Lid Switch as /class/input/input2
[    4.932204] PM: Adding info for No Bus:event2
[    4.972490] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    4.973043] PM: Adding info for No Bus:cooling_device0
[    4.973110] processor ACPI_CPU:00: registered as cooling_device0
[    4.973236] ACPI: Processor [CPU1] (supports 8 throttling states)
[    4.974976] ACPI: Lid Switch [LID]
[    4.975331] PM: Adding info for No Bus:input3
[    4.975435] input: Sleep Button (CM) as /class/input/input3
[    4.975672] PM: Adding info for No Bus:event3
[    4.975724] ACPI: Sleep Button (CM) [SLPB]
[    4.976022] PM: Adding info for No Bus:input4
[    4.976111] input: Power Button (CM) as /class/input/input4
[    4.976329] PM: Adding info for No Bus:event4
[    4.976378] ACPI: Power Button (CM) [PWRB]
[    4.978561] PM: Adding info for No Bus:AC0
[    4.979193] ACPI: AC Adapter [AC0] (on-line)
[    4.985710] ACPI: Battery Slot [BAT0] (battery absent)
[    5.004861] eeepc: Eee PC Hotkey Driver
[    5.069203] eeepc: Hotkey init flags 0x41
[    5.070976] eeepc: Get control methods supported: 0x101711
[    5.071300] PM: Adding info for No Bus:input5
[    5.071416] input: Asus EeePC extra buttons as /class/input/input5
[    5.071662] PM: Adding info for No Bus:event5
[    5.074524] PM: Adding info for No Bus:rfkill0
[    5.075359] PM: Adding info for No Bus:eeepc
[    5.132746] Linux agpgart interface v0.103
[    5.151614] PM: Adding info for No Bus:hwmon0
[    5.151977] PM: Adding info for platform:eeepc
[    5.153770] PM: Adding info for No Bus:acpi_video0
[    5.154276] PM: Adding info for No Bus:acpi_video1
[    5.154446] PM: Adding info for No Bus:acpi_video2
[    5.154876] PM: Adding info for No Bus:input6
[    5.154985] input: Video Bus as /class/input/input6
[    5.155248] PM: Adding info for No Bus:event6
[    5.155302] ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
[    5.223386] PM: Adding info for No Bus:timer
[    5.233463] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    5.233573] Copyright (c) 2007 Atheros Corporation.
[    5.233791] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.233921] atl2 0000:03:00.0: setting latency timer to 64
[    5.305094] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    5.305772] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    5.310942] PM: Adding info for No Bus:agpgart
[    5.311077] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    5.319675] intel_rng: FWH not detected
[    5.411157] PM: Adding info for No Bus:eth0
[    5.523056] usbcore: registered new interface driver usbfs
[    5.523545] usbcore: registered new interface driver hub
[    5.523849] usbcore: registered new device driver usb
[    5.530701] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.530935] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.531122] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.531136] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.532185] PM: Adding info for No Bus:usb_host1
[    5.534328] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    5.538507] ehci_hcd 0000:00:1d.7: debug port 1
[    5.538619] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    5.538676] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    5.546610] PM: Adding info for No Bus:input7
[    5.546771] input: PC Speaker as /class/input/input7
[    5.547022] PM: Adding info for No Bus:event7
[    5.550078] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.551704] PM: Adding info for usb:usb1
[    5.552178] usb usb1: configuration #1 chosen from 1 choice
[    5.552926] PM: Adding info for usb:1-0:1.0
[    5.553232] hub 1-0:1.0: USB hub found
[    5.553602] hub 1-0:1.0: 8 ports detected
[    5.555191] PM: Adding info for No Bus:usbdev1.1_ep81
[    5.555871] PM: Adding info for No Bus:usbdev1.1_ep00
[    5.647899] uhci_hcd: USB Universal Host Controller Interface driver
[    5.648189] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    5.648326] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.648340] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.648543] PM: Adding info for No Bus:usb_host2
[    5.648859] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    5.649061] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    5.649595] PM: Adding info for usb:usb2
[    5.649718] usb usb2: configuration #1 chosen from 1 choice
[    5.651724] PM: Adding info for usb:2-0:1.0
[    5.651801] hub 2-0:1.0: USB hub found
[    5.652197] hub 2-0:1.0: 2 ports detected
[    5.652608] PM: Adding info for No Bus:usbdev2.1_ep81
[    5.652841] PM: Adding info for No Bus:usbdev2.1_ep00
[    5.652974] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.653101] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.653113] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.653303] PM: Adding info for No Bus:usb_host3
[    5.653810] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    5.654041] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    5.654534] PM: Adding info for usb:usb3
[    5.654653] usb usb3: configuration #1 chosen from 1 choice
[    5.654880] PM: Adding info for usb:3-0:1.0
[    5.654951] hub 3-0:1.0: USB hub found
[    5.655074] hub 3-0:1.0: 2 ports detected
[    5.655364] PM: Adding info for No Bus:usbdev3.1_ep81
[    5.655576] PM: Adding info for No Bus:usbdev3.1_ep00
[    5.655707] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    5.655833] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.655845] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.656038] PM: Adding info for No Bus:usb_host4
[    5.656106] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    5.656322] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    5.656829] PM: Adding info for usb:usb4
[    5.656953] usb usb4: configuration #1 chosen from 1 choice
[    5.657185] PM: Adding info for usb:4-0:1.0
[    5.657257] hub 4-0:1.0: USB hub found
[    5.657380] hub 4-0:1.0: 2 ports detected
[    5.657667] PM: Adding info for No Bus:usbdev4.1_ep81
[    5.657884] PM: Adding info for No Bus:usbdev4.1_ep00
[    5.658007] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    5.658134] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.658146] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.658338] PM: Adding info for No Bus:usb_host5
[    5.658405] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.658616] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    5.659096] PM: Adding info for usb:usb5
[    5.659222] usb usb5: configuration #1 chosen from 1 choice
[    5.659443] PM: Adding info for usb:5-0:1.0
[    5.659521] hub 5-0:1.0: USB hub found
[    5.659642] hub 5-0:1.0: 2 ports detected
[    5.659926] PM: Adding info for No Bus:usbdev5.1_ep81
[    5.660167] PM: Adding info for No Bus:usbdev5.1_ep00
[    5.695102] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    5.696043] PM: Adding info for No Bus:i2c-0
[    5.850185] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.850463] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.886850] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    6.012032] PM: Adding info for usb:1-5
[    6.012250] usb 1-5: configuration #1 chosen from 1 choice
[    6.013122] PM: Adding info for usb:1-5:1.0
[    6.013417] PM: Adding info for No Bus:usbdev1.2_ep01
[    6.013598] PM: Adding info for No Bus:usbdev1.2_ep82
[    6.013816] PM: Adding info for No Bus:usbdev1.2_ep00
[    6.130124] usb 1-8: new high speed USB device using ehci_hcd and address 3
[    6.251446] PM: Adding info for No Bus:pcmC0D0p
[    6.251926] PM: Adding info for No Bus:pcmC0D0c
[    6.253233] PM: Adding info for No Bus:dsp
[    6.253995] PM: Adding info for No Bus:audio
[    6.254687] PM: Adding info for No Bus:hwC0D0
[    6.254874] PM: Adding info for No Bus:controlC0
[    6.255245] PM: Adding info for No Bus:mixer
[    6.259028] PM: Adding info for usb:1-8
[    6.259171] usb 1-8: configuration #1 chosen from 1 choice
[    6.259540] PM: Adding info for usb:1-8:1.0
[    6.259746] PM: Adding info for No Bus:usbdev1.3_ep81
[    6.259907] PM: Adding info for usb:1-8:1.1
[    6.260184] PM: Adding info for No Bus:usbdev1.3_ep82
[    6.260408] PM: Adding info for No Bus:usbdev1.3_ep00
[    6.386655] usual_tables: module license 'unspecified' taints kernel.
[    6.386816] Disabling lockdep due to kernel taint
[    6.439651] Linux video capture interface: v2.00
[    6.446770] Marking TSC unstable due to TSC halts in idle
[    6.456417] uvcvideo: Found UVC 1.00 device <unnamed> (eb1a:2761)
[    6.614887] PM: Adding info for No Bus:video0
[    6.615051] usbcore: registered new interface driver uvcvideo
[    6.615165] USB Video Class driver (v0.1.0)
[    6.763383] Clocksource tsc unstable (delta = -96153146 ns)
[    6.853199] PM: Adding info for No Bus:vcs2
[    6.853297] PM: Adding info for No Bus:vcsa2
[    6.861768] PM: Adding info for No Bus:vcs3
[    6.861864] PM: Adding info for No Bus:vcsa3
[    6.868203] PM: Adding info for No Bus:vcs4
[    6.868299] PM: Adding info for No Bus:vcsa4
[    6.870832] PM: Adding info for No Bus:vcs5
[    6.870920] PM: Adding info for No Bus:vcsa5
[    6.875213] PM: Adding info for No Bus:vcs6
[    6.875298] PM: Adding info for No Bus:vcsa6
[    7.854286] EXT4 FS on sda2, no journal
[    8.280115] Adding 524280k swap on /swapfile.  Priority:-1 extents:1683 across:3168868k 
[    9.510557] NET: Registered protocol family 10
[    9.512717] lo: Disabled Privacy Extensions
[   12.962439] PM: Adding info for No Bus:vcs7
[   12.962543] PM: Adding info for No Bus:vcsa7
[   15.819409] [drm] Initialized drm 1.1.0 20060810
[   16.163239] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   16.163261] pci 0000:00:02.0: setting latency timer to 64
[   16.169550] PM: Adding info for No Bus:card0
[   16.170451] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[   16.170513] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   17.740069] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[   17.740537] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.945294] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   17.945411] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   18.075778] NET: Registered protocol family 17
[   27.973369] eth0: no IPv6 routers present
[   57.549665] PM: Adding info for No Bus:vcs63
[   57.549769] PM: Adding info for No Bus:vcsa63
[   57.551117] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[   60.580288] PM: Marking nosave pages: 000000000009f000 - 0000000000100000
[   60.580304] PM: Basic memory bitmaps created
[   60.580627] PM: Adding info for No Bus:vcs8
[   60.580727] PM: Adding info for No Bus:vcsa8
[   61.125471] Syncing filesystems ... done.
[   61.132711] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   61.134847] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   61.135207] PM: Shrinking memory...  <6>before: sc.nr_reclaimed = 0
[   61.180993] pass = 0, prio = 12, sc.nr_reclaimed = 0
[   61.181004] pass = 0, prio = 11, sc.nr_reclaimed = 0
[   61.181014] pass = 0, prio = 10, sc.nr_reclaimed = 0
[   61.181024] pass = 0, prio = 9, sc.nr_reclaimed = 0
[   61.181033] pass = 0, prio = 8, sc.nr_reclaimed = 0
[   61.181043] pass = 0, prio = 7, sc.nr_reclaimed = 0
[   61.186509] pass = 0, prio = 6, sc.nr_reclaimed = 0
[   61.186525] pass = 0, prio = 5, sc.nr_reclaimed = 0
[   61.186534] pass = 0, prio = 4, sc.nr_reclaimed = 0
[   61.186544] pass = 0, prio = 3, sc.nr_reclaimed = 0
[   61.333383] pass = 0, prio = 2, sc.nr_reclaimed = 7746
[   61.436711] pass = 0, prio = 1, sc.nr_reclaimed = 1957
[   61.556712] pass = 0, prio = 0, sc.nr_reclaimed = 4528
[   61.556729] pass = 1, prio = 12, sc.nr_reclaimed = 0
[   61.556739] pass = 1, prio = 11, sc.nr_reclaimed = 0
[   61.556749] pass = 1, prio = 10, sc.nr_reclaimed = 0
[   61.556759] pass = 1, prio = 9, sc.nr_reclaimed = 0
[   61.556768] pass = 1, prio = 8, sc.nr_reclaimed = 0
[   61.556778] pass = 1, prio = 7, sc.nr_reclaimed = 0
[   61.556787] pass = 1, prio = 6, sc.nr_reclaimed = 0
[   61.556797] pass = 1, prio = 5, sc.nr_reclaimed = 0
[   61.556806] pass = 1, prio = 4, sc.nr_reclaimed = 0
[   61.556816] pass = 1, prio = 3, sc.nr_reclaimed = 0
[   61.556825] pass = 1, prio = 2, sc.nr_reclaimed = 0
[   61.556835] pass = 1, prio = 1, sc.nr_reclaimed = 0
[   61.595841] pass = 1, prio = 0, sc.nr_reclaimed = 0
[   61.595854] pass = 2, prio = 12, sc.nr_reclaimed = 0
[   61.595864] pass = 2, prio = 11, sc.nr_reclaimed = 0
[   61.595873] pass = 2, prio = 10, sc.nr_reclaimed = 0
[   61.595883] pass = 2, prio = 9, sc.nr_reclaimed = 0
[   61.710044] pass = 2, prio = 8, sc.nr_reclaimed = 2895
[   61.710062] pass = 2, prio = 7, sc.nr_reclaimed = 0
[   61.710072] pass = 2, prio = 6, sc.nr_reclaimed = 0
[   61.710081] pass = 2, prio = 5, sc.nr_reclaimed = 0
[   61.710091] pass = 2, prio = 4, sc.nr_reclaimed = 0
[   61.710100] pass = 2, prio = 3, sc.nr_reclaimed = 0
[   61.710110] pass = 2, prio = 2, sc.nr_reclaimed = 0
[   61.710119] pass = 2, prio = 1, sc.nr_reclaimed = 0
[   61.823378] pass = 2, prio = 0, sc.nr_reclaimed = 1802
[   61.823396] pass = 3, prio = 12, sc.nr_reclaimed = 0
[   61.823406] pass = 3, prio = 11, sc.nr_reclaimed = 0
[   61.823416] pass = 3, prio = 10, sc.nr_reclaimed = 0
[   61.823425] pass = 3, prio = 9, sc.nr_reclaimed = 0
[   61.823435] pass = 3, prio = 8, sc.nr_reclaimed = 0
[   61.823444] pass = 3, prio = 7, sc.nr_reclaimed = 0
[   61.823454] pass = 3, prio = 6, sc.nr_reclaimed = 0
[   61.823464] pass = 3, prio = 5, sc.nr_reclaimed = 0
[   61.823473] pass = 3, prio = 4, sc.nr_reclaimed = 0
[   61.823483] pass = 3, prio = 3, sc.nr_reclaimed = 0
[   61.823492] pass = 3, prio = 2, sc.nr_reclaimed = 0
[   61.823502] pass = 3, prio = 1, sc.nr_reclaimed = 0
[   62.586707] pass = 3, prio = 0, sc.nr_reclaimed = 2716
[   62.608037] pass = 4, prio = 12, sc.nr_reclaimed = 3070
[   62.634644] pass = 4, prio = 11, sc.nr_reclaimed = 5048
[   62.638782] pass = 4, prio = 10, sc.nr_reclaimed = 192
[   62.740052] pass = 4, prio = 9, sc.nr_reclaimed = 0
[   62.843385] pass = 4, prio = 8, sc.nr_reclaimed = 640
[   62.946726] pass = 4, prio = 7, sc.nr_reclaimed = 640
[   63.046711] pass = 4, prio = 6, sc.nr_reclaimed = 640
[   63.146717] pass = 4, prio = 5, sc.nr_reclaimed = 608
[   63.246712] pass = 4, prio = 4, sc.nr_reclaimed = 600
[   63.346704] pass = 4, prio = 3, sc.nr_reclaimed = 128
[   63.446698] pass = 4, prio = 2, sc.nr_reclaimed = 0
[   63.546705] pass = 4, prio = 1, sc.nr_reclaimed = 0
[   63.646698] pass = 4, prio = 0, sc.nr_reclaimed = 0
[   63.646708] after: sc.nr_reclaimed = 0
[   63.646715] shrink_all_memory(10000) failed
[   63.646722] Mem-Info:
[   63.646729] DMA per-cpu:
[   63.646738] CPU    0: hi:    0, btch:   1 usd:   0
[   63.646745] Normal per-cpu:
[   63.646753] CPU    0: hi:  186, btch:  31 usd: 182
[   63.646769] Active_anon:0 active_file:0 inactive_anon:0
[   63.646773]  inactive_file:22 unevictable:1098 dirty:0 writeback:0 unstable:0
[   63.646779]  free:91278 slab:1984 mapped:953 pagetables:529 bounce:0
[   63.646796] DMA free:8008kB min:88kB low:108kB high:132kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB present:15804kB pages_scanned:0 all_unreclaimable? no
[   63.646809] lowmem_reserve[]: 0 483 483
[   63.646833] Normal free:357104kB min:2764kB low:3452kB high:4144kB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:88kB unevictable:4392kB present:495300kB pages_scanned:176 all_unreclaimable? no
[   63.646847] lowmem_reserve[]: 0 0 0
[   63.646862] DMA: 2*4kB 6*8kB 3*16kB 3*32kB 2*64kB 2*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 1*4096kB = 8008kB
[   63.646906] Normal: 298*4kB 269*8kB 214*16kB 154*32kB 119*64kB 75*128kB 66*256kB 44*512kB 26*1024kB 14*2048kB 57*4096kB = 357104kB
[   63.646951] 972 total pagecache pages
[   63.646958] 0 pages in swap cache
[   63.646966] Swap cache stats: add 6615, delete 6615, find 0/0
[   63.646974] Free swap  = 497820kB
[   63.646980] Total swap = 524280kB
[   63.652111] 128880 pages RAM
[   63.652119] 3192 pages reserved
[   63.652126] 37178 pages shared
[   63.652132] 4437 pages non-shared
[   63.652177] Restarting tasks ... done.
[   63.671646] PM: Basic memory bitmaps freed
[   64.521472] PM: Removing info for No Bus:vcs63
[   64.521642] PM: Removing info for No Bus:vcsa63
[   65.267700] atl2 0000:03:00.0: irq 27 for MSI/MSI-X
[   65.268233] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   65.270982] atl2: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   65.271111] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   75.913359] eth0: no IPv6 routers present


--------------060307030408060105010404--
