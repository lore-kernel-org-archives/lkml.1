Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZLMRTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZLMRTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbZLMRTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:19:16 -0500
Received: from mk-outboundfilter-3.mail.uk.tiscali.com ([212.74.114.23]:1933
	"HELO mk-outboundfilter-3.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751506AbZLMRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:19:14 -0500
X-Trace: 311997670/mk-outboundfilter-1.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoEAA6xJEtTQwwf/2dsb2JhbACBSsNEjGCEKwSBYg
X-IronPort-AV: E=Sophos;i="4.47,391,1257120000"; 
   d="scan'208";a="311997670"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: Are these MTRR settings correct?
Date: Sun, 13 Dec 2009 17:19:01 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.32; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912130807.44905.tvrtko@ursulin.net> <200912130826.48302.tvrtko@ursulin.net> <86802c440912130125y4215ca49l9b1bd49bde07f558@mail.gmail.com>
In-Reply-To: <86802c440912130125y4215ca49l9b1bd49bde07f558@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912131719.01388.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 Dec 2009 09:25:33 Yinghai Lu wrote:
> On Sun, Dec 13, 2009 at 12:26 AM, Tvrtko Ursulin <tvrtko@ursulin.net> wrote:
> > reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
> > reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
> > reg02: base=0x0c0000000 ( 3072MB), size=  256MB, count=1: write-back
> > reg03: base=0x0f0000000 ( 3840MB), size=  128MB, count=1: write-combining
> >
> > Still looks like from 3328MB to 3840MB is of status unknown?
> >
> > dmesg in that case:
> >
> > [    0.000000] Linux version 2.6.32 (tvrtko@deuteros) (gcc version 4.4.1
> > [gcc-4_4-branch revision 150839] (SUSE Linux) ) #2 SMP PREEMPT Sat Dec 12
> > 20:44:59 GMT 2009
> > [    0.000000] Command line:
> > root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1"
> > resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" splash=silent quiet
> > vga=0x31a 3
> > [    0.000000] KERNEL supported cpus:
> > [    0.000000]   Intel GenuineIntel
> > [    0.000000]   AMD AuthenticAMD
> > [    0.000000]   Centaur CentaurHauls
> > [    0.000000] BIOS-provided physical RAM map:
> > [    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
> > [    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
> > [    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
> > [    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff90000 (usable)
> > [    0.000000]  BIOS-e820: 00000000cff90000 - 00000000cffa8000 (ACPI
> > data) [    0.000000]  BIOS-e820: 00000000cffa8000 - 00000000cffd0000
> > (ACPI NVS) [    0.000000]  BIOS-e820: 00000000cffd0000 - 00000000d0000000
> > (reserved) [    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000
> > (reserved) [    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000
> > (usable) [    0.000000] DMI present.
> > [    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working
> > around it. [    0.000000] e820 update range: 0000000000000000 -
> > 0000000000010000 (usable) ==> (reserved) [    0.000000] last_pfn =
> > 0x130000 max_arch_pfn = 0x400000000
> > [    0.000000] MTRR default type: uncachable
> > [    0.000000] MTRR fixed ranges enabled:
> > [    0.000000]   00000-9FFFF write-back
> > [    0.000000]   A0000-EFFFF uncachable
> > [    0.000000]   F0000-FFFFF write-protect
> > [    0.000000] MTRR variable ranges enabled:
> > [    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
> > [    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
> > [    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
> > [    0.000000]   3 disabled
> > [    0.000000]   4 disabled
> > [    0.000000]   5 disabled
> > [    0.000000]   6 disabled
> > [    0.000000]   7 disabled
> > [    0.000000] TOM2: 0000000130000000 aka 4864M
> 
> that [d0000000, e0000000) is to mmio space.
> 
> your var mtrrs is covering [0, d0000000)
> 
> and AMD K8 Rev F, will auto cover your [4G, TOM2) aka [4G, 4G+3*256M) to WB
>  ... ...

I read this as everything is OK and nothing to worry about, correct?
 
> > [    0.251043] node 0 link 0: io port [1000, ffffff]
> > [    0.251045] TOM: 00000000d0000000 aka 3328M
> > [    0.251046] Fam 10h mmconf [e0000000, efffffff]
> > [    0.251048] node 0 link 0: mmio [a0000, bffff]
> > [    0.251050] node 0 link 0: mmio [d0000000, dfffffff]
> > [    0.251051] node 0 link 0: mmio [e0000000, efffffff] ==> none
> > [    0.251053] node 0 link 0: mmio [f0000000, fe7fffff]
> > [    0.251055] node 0 link 0: mmio [fe800000, fe9fffff]
> > [    0.251056] node 0 link 0: mmio [fea00000, ffefffff]
> > [    0.251058] TOM2: 0000000130000000 aka 4864M
> > [    0.251059] bus: [00,07] on node 0 link 0
> > [    0.251060] bus: 00 index 0 io port: [0, ffff]
> > [    0.251062] bus: 00 index 1 mmio: [a0000, bffff]
> > [    0.251063] bus: 00 index 2 mmio: [d0000000, dfffffff]
> > [    0.251064] bus: 00 index 3 mmio: [f0000000, ffffffff]
> > [    0.251065] bus: 00 index 4 mmio: [130000000, fcffffffff]
> > [    0.251072] ACPI: bus type pci registered
> > [    0.251107] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0
> > - 255 [    0.251109] PCI: Not using MMCONFIG.
> > [    0.251110] PCI: Using configuration type 1 for base access
> > [    0.251111] PCI: Using configuration type 1 for extended access
> 
> only concern that is your BIOS doesn't have [e000000, F0000000)
> reserved in e820 or acpi etc.
> 
> you could try to use "pci=check_enable_amd_mmconf" in boot command
> line to enable it.

This produced some differences in kernel output but I don't know if they are for better or worse. I will paste it the latest output here.

[    0.000000] Linux version 2.6.32 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #2 SMP PREEMPT Sat 
Dec 12 20:44:59 GMT 2009
[    0.000000] Command line: pci=check_enable_amd_mmconf root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" 
resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" splash=silent quiet vga=0x31a
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dff90000 (usable)
[    0.000000]  BIOS-e820: 00000000dff90000 - 00000000dffa8000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dffa8000 - 00000000dffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dffd0000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000e0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdff90 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009ec00 (usable)
[    0.000000]  modified: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dff90000 (usable)
[    0.000000]  modified: 00000000dff90000 - 00000000dffa8000 (ACPI data)
[    0.000000]  modified: 00000000dffa8000 - 00000000dffd0000 (ACPI NVS)
[    0.000000]  modified: 00000000dffd0000 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000dff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dff90000 page 4k
[    0.000000] kernel direct mapping tables up to dff90000 @ 10000-13000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 12000-14000
[    0.000000] RAMDISK: 379ea000 - 37fef00a
[    0.000000] ACPI: RSDP 00000000000fb4f0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dff90100 00054 (v01 112609 XSDT1132 20091126 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dff90290 000F4 (v03 112609 FACP1132 20091126 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20090903/tbfadt-557)
[    0.000000] ACPI: DSDT 00000000dff90450 0D100 (v01  A1391 A1391001 00000001 INTL 20060113)
[    0.000000] ACPI: FACS 00000000dffa8000 00040
[    0.000000] ACPI: APIC 00000000dff90390 0007C (v01 112609 APIC1132 20091126 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000dff90410 0003C (v01 112609 OEMMCFG  20091126 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000dffa8040 00072 (v01 112609 OEMB1132 20091126 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000dff9f450 00038 (v01 112609 OEMHPET  20091126 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000dff9f490 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000000013000 - 0000000000014fff]
[    0.000000]   bootmap [0000000000015000 -  0000000000038fff] pages 24
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 000166476c]    TEXT DATA BSS ==> [0001000000 - 000166476c]
[    0.000000]   #3 [00379ea000 - 0037fef00a]          RAMDISK ==> [00379ea000 - 0037fef00a]
[    0.000000]   #4 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #5 [0001665000 - 0001665340]              BRK ==> [0001665000 - 0001665340]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 - 0000013000]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000dff90
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048350
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 103 pages reserved
[    0.000000]   DMA zone: 3823 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 899016 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] 6 Processors exceeds NR_CPUS limit of 4
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dff90000 - 00000000dffa8000
[    0.000000] PM: Registered nosave memory: 00000000dffa8000 - 00000000dffd0000
[    0.000000] PM: Registered nosave memory: 00000000dffd0000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000ff700000
[    0.000000] PM: Registered nosave memory: 00000000ff700000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:1f700000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff880028200000 s72856 r8192 d21352 u524288
[    0.000000] pcpu-alloc: s72856 r8192 d21352 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032119
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: pci=check_enable_amd_mmconf root=UUID="78df20fb-791f-4a82-b1d6-4e043aa663d1" 
resume=UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7" splash=silent quiet vga=0x31a
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ 20000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 4055132k/4718592k available (3519k kernel code, 525192k absent, 138268k reserved, 1987k data, 416k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3013.207 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6026.40 BogoMIPS (lpj=3013203)
[    0.003148] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004161] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004637] Mount-cache hash table entries: 256
[    0.004719] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004720] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004721] CPU 0/0x0 -> Node 0
[    0.004723] tseg: 0000000000
[    0.004729] CPU: Physical Processor ID: 0
[    0.004730] CPU: Processor Core ID: 0
[    0.004731] mce: CPU supports 6 MCE banks
[    0.004737] using C1E aware idle routine
[    0.004745] ACPI: Core revision 20090903
[    0.018033] Setting APIC routing to flat
[    0.018331] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.028368] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.028995] Booting processor 1 APIC 0x1 ip 0x6000
[    0.002999] Initializing CPU#1
[    0.002999] Calibrating delay using timer specific routine.. 6026.84 BogoMIPS (lpj=3013424)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 1/0x1 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 1
[    0.099093] CPU1: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.099098] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.100006] System has AMD C1E enabled
[    0.100014] Switch to broadcast mode on CPU0
[    0.100000] Switch to broadcast mode on CPU1
[    0.101991] Booting processor 2 APIC 0x2 ip 0x6000
[    0.002999] Initializing CPU#2
[    0.002999] Calibrating delay using timer specific routine.. 6026.80 BogoMIPS (lpj=3013404)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 2/0x2 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 2
[    0.173047] CPU2: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.173052] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.173991] Switch to broadcast mode on CPU2
[    0.175980] Booting processor 3 APIC 0x3 ip 0x6000
[    0.002999] Initializing CPU#3
[    0.002999] Calibrating delay using timer specific routine.. 6026.79 BogoMIPS (lpj=3013399)
[    0.002999] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.002999] CPU: L2 Cache: 512K (64 bytes/line)
[    0.002999] CPU 3/0x3 -> Node 0
[    0.002999] CPU: Physical Processor ID: 0
[    0.002999] CPU: Processor Core ID: 3
[    0.247040] CPU3: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.247045] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.247985] Brought up 4 CPUs
[    0.247987] Total of 4 processors activated (24106.86 BogoMIPS).
[    0.247985] Switch to broadcast mode on CPU3
[    0.248981] devtmpfs: initialized
[    0.249118] Time: 17:11:29  Date: 12/13/09
[    0.249983] NET: Registered protocol family 16
[    0.250038] node 0 link 0: io port [1000, ffffff]
[    0.250040] TOM: 00000000e0000000 aka 3584M
[    0.250041] Fam 10h mmconf [e0000000, efffffff]
[    0.250043] node 0 link 0: mmio [a0000, bffff]
[    0.250045] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.250047] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.250048] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.250050] node 0 link 0: mmio [fea00000, ffefffff]
[    0.250051] TOM2: 0000000120000000 aka 4608M
[    0.250053] bus: [00,07] on node 0 link 0
[    0.250054] bus: 00 index 0 io port: [0, ffff]
[    0.250055] bus: 00 index 1 mmio: [a0000, bffff]
[    0.250057] bus: 00 index 2 mmio: [f0000000, ffffffff]
[    0.250058] bus: 00 index 3 mmio: [120000000, fcffffffff]
[    0.250065] ACPI: bus type pci registered
[    0.250088] PCI: Found AMD Family 10h NB with MMCONFIG support.
[    0.250091] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.250092] PCI: Not using MMCONFIG.
[    0.250094] PCI: Using configuration type 1 for base access
[    0.250095] PCI: Using configuration type 1 for extended access
[    0.250402] bio: create slab <bio-0> at 0
[    0.251177] ACPI: EC: Look up EC in DSDT
[    0.253491] ACPI Error (psargs-0359): [ECEN] Namespace lookup failure, AE_NOT_FOUND
[    0.253495] ACPI Error (psparse-0537): Method parse/execution failed [\] (Node ffffffff81656ab0), AE_NOT_FOUND
[    0.253600] ACPI: Executed 3 blocks of module-level executable AML code
[    0.270570] ACPI: Interpreter enabled
[    0.270574] ACPI: (supports S0 S1 S3 S4 S5)
[    0.270594] ACPI: Using IOAPIC for interrupt routing
[    0.276918] ACPI Warning: Incorrect checksum in table [OEMB] - 69, should be 64 (20090903/tbutils-314)
[    0.277018] ACPI: No dock devices found.
[    0.277155] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.277258] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.277260] pci 0000:00:07.0: PME# disabled
[    0.277288] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.277290] pci 0000:00:0a.0: PME# disabled
[    0.277333] pci 0000:00:11.0: reg 10 io port: [0xc000-0xc007]
[    0.277339] pci 0000:00:11.0: reg 14 io port: [0xb000-0xb003]
[    0.277344] pci 0000:00:11.0: reg 18 io port: [0xa000-0xa007]
[    0.277350] pci 0000:00:11.0: reg 1c io port: [0x9000-0x9003]
[    0.277355] pci 0000:00:11.0: reg 20 io port: [0x8000-0x800f]
[    0.277361] pci 0000:00:11.0: reg 24 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.277407] pci 0000:00:12.0: reg 10 32bit mmio: [0xfe7fe000-0xfe7fefff]
[    0.277456] pci 0000:00:12.1: reg 10 32bit mmio: [0xfe7fd000-0xfe7fdfff]
[    0.277519] pci 0000:00:12.2: reg 10 32bit mmio: [0xfe7ff800-0xfe7ff8ff]
[    0.277566] pci 0000:00:12.2: supports D1 D2
[    0.277567] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.277570] pci 0000:00:12.2: PME# disabled
[    0.277598] pci 0000:00:13.0: reg 10 32bit mmio: [0xfe7fc000-0xfe7fcfff]
[    0.277645] pci 0000:00:13.1: reg 10 32bit mmio: [0xfe7fb000-0xfe7fbfff]
[    0.277709] pci 0000:00:13.2: reg 10 32bit mmio: [0xfe7ff400-0xfe7ff4ff]
[    0.277755] pci 0000:00:13.2: supports D1 D2
[    0.277757] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.277760] pci 0000:00:13.2: PME# disabled
[    0.277864] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
[    0.277869] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
[    0.277875] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
[    0.277880] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
[    0.277886] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]
[    0.277944] pci 0000:00:14.2: reg 10 64bit mmio: [0xfe7f4000-0xfe7f7fff]
[    0.277987] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.277991] pci 0000:00:14.2: PME# disabled
[    0.278083] pci 0000:00:14.5: reg 10 32bit mmio: [0xfe7fa000-0xfe7fafff]
[    0.278190] pci 0000:01:05.0: reg 10 32bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.278193] pci 0000:01:05.0: reg 14 io port: [0xd000-0xd0ff]
[    0.278196] pci 0000:01:05.0: reg 18 32bit mmio: [0xfe9f0000-0xfe9fffff]
[    0.278201] pci 0000:01:05.0: reg 24 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.278210] pci 0000:01:05.0: supports D1 D2
[    0.278223] pci 0000:01:05.1: reg 10 32bit mmio: [0xfe9e8000-0xfe9ebfff]
[    0.278238] pci 0000:01:05.1: supports D1 D2
[    0.278276] pci 0000:00:01.0: bridge io port: [0xd000-0xdfff]
[    0.278278] pci 0000:00:01.0: bridge 32bit mmio: [0xfe800000-0xfe9fffff]
[    0.278281] pci 0000:00:01.0: bridge 64bit mmio pref: [0xf0000000-0xf7ffffff]
[    0.278318] pci 0000:02:00.0: reg 10 32bit mmio: [0xfeaff800-0xfeafffff]
[    0.278326] pci 0000:02:00.0: reg 14 32bit mmio: [0xfeaff400-0xfeaff47f]
[    0.278346] pci 0000:02:00.0: reg 20 32bit mmio: [0xfeaff000-0xfeaff07f]
[    0.278354] pci 0000:02:00.0: reg 24 32bit mmio: [0xfeafec00-0xfeafec7f]
[    0.281027] pci 0000:00:07.0: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.281057] pci 0000:03:00.0: reg 10 io port: [0xe800-0xe8ff]
[    0.281070] pci 0000:03:00.0: reg 18 64bit mmio pref: [0xfdfff000-0xfdffffff]
[    0.281079] pci 0000:03:00.0: reg 20 64bit mmio pref: [0xfdff8000-0xfdffbfff]
[    0.281085] pci 0000:03:00.0: reg 30 32bit mmio pref: [0xfebf0000-0xfebfffff]
[    0.281111] pci 0000:03:00.0: supports D1 D2
[    0.281112] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.281115] pci 0000:03:00.0: PME# disabled
[    0.284022] pci 0000:00:0a.0: bridge io port: [0xe000-0xefff]
[    0.284024] pci 0000:00:0a.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.284026] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.284079] pci 0000:00:14.4: transparent bridge
[    0.284098] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.284246] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.284302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.284347] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.284404] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.288183] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.288276] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.288367] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.288458] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.288548] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.288639] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.288730] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.288821] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.288891] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.288893] vgaarb: loaded
[    0.288942] SCSI subsystem initialized
[    0.296959] libata version 3.00 loaded.
[    0.296979] usbcore: registered new interface driver usbfs
[    0.296979] usbcore: registered new interface driver hub
[    0.296981] usbcore: registered new device driver usb
[    0.296981] PCI: Using ACPI for IRQ routing
[    0.297086] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.297089] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.299973] hpet: hpet2 irq 24 for MSI
[    0.301959] Switching to clocksource tsc
[    0.304055] pnp: PnP ACPI init
[    0.304064] ACPI: bus type pnp registered
[    0.308365] pnp: PnP ACPI: found 14 devices
[    0.308366] ACPI: ACPI bus type pnp unregistered
[    0.308378] system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.308380] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.308384] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[    0.308386] system 00:0a: ioport range 0x40b-0x40b has been reserved
[    0.308387] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[    0.308389] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[    0.308391] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[    0.308392] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[    0.308394] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[    0.308395] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[    0.308397] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[    0.308399] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[    0.308400] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[    0.308402] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[    0.308403] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[    0.308405] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[    0.308407] system 00:0a: ioport range 0xb00-0xb3f has been reserved
[    0.308408] system 00:0a: ioport range 0x800-0x89f has been reserved
[    0.308410] system 00:0a: ioport range 0xb00-0xb0f has been reserved
[    0.308412] system 00:0a: ioport range 0xb20-0xb3f has been reserved
[    0.308414] system 00:0a: ioport range 0x900-0x90f has been reserved
[    0.308415] system 00:0a: ioport range 0x910-0x91f has been reserved
[    0.308417] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[    0.308419] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[    0.308421] system 00:0a: iomem range 0xfec10000-0xfec1001f has been reserved
[    0.308423] system 00:0a: iomem range 0xfed40000-0xfed44fff has been reserved
[    0.308426] system 00:0b: ioport range 0x230-0x23f has been reserved
[    0.308428] system 00:0b: ioport range 0x290-0x29f has been reserved
[    0.308429] system 00:0b: ioport range 0x300-0x30f has been reserved
[    0.308431] system 00:0b: ioport range 0xa30-0xa3f has been reserved
[    0.308434] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.308437] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.308438] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.308440] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.308442] system 00:0d: iomem range 0x100000-0xdfffffff could not be reserved
[    0.308444] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.313146] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.313148] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    0.313151] pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe9fffff
[    0.313153] pci 0000:00:01.0:   PREFETCH window: 0x000000f0000000-0x000000f7ffffff
[    0.313156] pci 0000:00:07.0: PCI bridge, secondary bus 0000:02
[    0.313157] pci 0000:00:07.0:   IO window: disabled
[    0.313159] pci 0000:00:07.0:   MEM window: 0xfea00000-0xfeafffff
[    0.313161] pci 0000:00:07.0:   PREFETCH window: disabled
[    0.313163] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:03
[    0.313165] pci 0000:00:0a.0:   IO window: 0xe000-0xefff
[    0.313167] pci 0000:00:0a.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.313169] pci 0000:00:0a.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.313171] pci 0000:00:14.4: PCI bridge, secondary bus 0000:04
[    0.313172] pci 0000:00:14.4:   IO window: disabled
[    0.313176] pci 0000:00:14.4:   MEM window: disabled
[    0.313179] pci 0000:00:14.4:   PREFETCH window: disabled
[    0.313190] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.313193] pci 0000:00:07.0: setting latency timer to 64
[    0.313197] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.313199] pci 0000:00:0a.0: setting latency timer to 64
[    0.313205] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.313207] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.313209] pci_bus 0000:01: resource 0 io:  [0xd000-0xdfff]
[    0.313210] pci_bus 0000:01: resource 1 mem: [0xfe800000-0xfe9fffff]
[    0.313212] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf7ffffff]
[    0.313214] pci_bus 0000:02: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.313215] pci_bus 0000:03: resource 0 io:  [0xe000-0xefff]
[    0.313217] pci_bus 0000:03: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.313218] pci_bus 0000:03: resource 2 pref mem [0xfdf00000-0xfdffffff]
[    0.313220] pci_bus 0000:04: resource 3 io:  [0x00-0xffff]
[    0.313221] pci_bus 0000:04: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.313241] NET: Registered protocol family 2
[    0.313336] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.313997] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.315875] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.316127] TCP: Hash tables configured (established 524288 bind 65536)
[    0.316129] TCP reno registered
[    0.316182] NET: Registered protocol family 1
[    0.444925] pci 0000:01:05.0: Boot video device
[    0.444959] Unpacking initramfs...
[    0.529726] Freeing initrd memory: 6164k freed
[    0.531061] PCI-DMA: Disabling AGP.
[    0.531131] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.531132] PCI-DMA: using GART IOMMU.
[    0.531134] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.532967] Scanning for low memory corruption every 60 seconds
[    0.533252] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.534022] VFS: Disk quotas dquot_6.5.2
[    0.534053] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.534218] msgmni has been set to 7932
[    0.534284] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.534286] io scheduler noop registered
[    0.534287] io scheduler anticipatory registered
[    0.534288] io scheduler deadline registered
[    0.534307] io scheduler cfq registered (default)
[    0.534421] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    0.534426] pcieport 0000:00:07.0: setting latency timer to 64
[    0.534512] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.534516] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.534669] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90001080000, using 5120k, total 16384k
[    0.534671] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.534672] vesafb: scrolling: redraw
[    0.534674] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.541540] Console: switching to colour frame buffer device 160x64
[    0.547939] fb0: VESA VGA frame buffer device
[    0.548615] Non-volatile memory driver v1.3
[    0.548618] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.548723] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.548896] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.549010] ahci 0000:00:11.0: version 3.0
[    0.549026] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.549137] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.549140] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.549385] scsi0 : ahci
[    0.549446] scsi1 : ahci
[    0.549475] scsi2 : ahci
[    0.549504] scsi3 : ahci
[    0.549533] scsi4 : ahci
[    0.549563] scsi5 : ahci
[    0.549585] ata1: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd00 irq 22
[    0.549588] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    0.549591] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    0.549593] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    0.549595] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00 irq 22
[    0.549598] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80 irq 22
[    0.549659] Fixed MDIO Bus: probed
[    0.549664] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.550931] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.550948] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.550964] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.550992] ehci_hcd 0000:00:12.2: debug port 1
[    0.551007] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.557253] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.557267] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.557268] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.557270] usb usb1: Product: EHCI Host Controller
[    0.557272] usb usb1: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.557273] usb usb1: SerialNumber: 0000:00:12.2
[    0.557314] usb usb1: configuration #1 chosen from 1 choice
[    0.557330] hub 1-0:1.0: USB hub found
[    0.557334] hub 1-0:1.0: 6 ports detected
[    0.557397] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.557405] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.557411] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.557433] ehci_hcd 0000:00:13.2: debug port 1
[    0.557447] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.563259] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.563265] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.563267] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.563269] usb usb2: Product: EHCI Host Controller
[    0.563270] usb usb2: Manufacturer: Linux 2.6.32 ehci_hcd
[    0.563271] usb usb2: SerialNumber: 0000:00:13.2
[    0.563298] usb usb2: configuration #1 chosen from 1 choice
[    0.563312] hub 2-0:1.0: USB hub found
[    0.563315] hub 2-0:1.0: 6 ports detected
[    0.563354] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.563377] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.563385] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.563390] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.563407] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.618285] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.618286] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.618288] usb usb3: Product: OHCI Host Controller
[    0.618289] usb usb3: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.618290] usb usb3: SerialNumber: 0000:00:12.0
[    0.618318] usb usb3: configuration #1 chosen from 1 choice
[    0.618330] hub 3-0:1.0: USB hub found
[    0.618337] hub 3-0:1.0: 3 ports detected
[    0.618427] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.618434] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.618439] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.618451] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.673283] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.673285] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.673286] usb usb4: Product: OHCI Host Controller
[    0.673287] usb usb4: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.673289] usb usb4: SerialNumber: 0000:00:12.1
[    0.673317] usb usb4: configuration #1 chosen from 1 choice
[    0.673329] hub 4-0:1.0: USB hub found
[    0.673335] hub 4-0:1.0: 3 ports detected
[    0.673422] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.673431] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.673436] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.673452] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.728281] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.728283] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.728284] usb usb5: Product: OHCI Host Controller
[    0.728286] usb usb5: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.728287] usb usb5: SerialNumber: 0000:00:13.0
[    0.728315] usb usb5: configuration #1 chosen from 1 choice
[    0.728327] hub 5-0:1.0: USB hub found
[    0.728333] hub 5-0:1.0: 3 ports detected
[    0.728421] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.728427] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.728432] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.728445] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.783280] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.783282] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.783283] usb usb6: Product: OHCI Host Controller
[    0.783285] usb usb6: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.783286] usb usb6: SerialNumber: 0000:00:13.1
[    0.783315] usb usb6: configuration #1 chosen from 1 choice
[    0.783327] hub 6-0:1.0: USB hub found
[    0.783333] hub 6-0:1.0: 3 ports detected
[    0.783424] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.783431] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.783437] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.783449] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    0.838289] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.838291] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.838292] usb usb7: Product: OHCI Host Controller
[    0.838293] usb usb7: Manufacturer: Linux 2.6.32 ohci_hcd
[    0.838294] usb usb7: SerialNumber: 0000:00:14.5
[    0.838320] usb usb7: configuration #1 chosen from 1 choice
[    0.838333] hub 7-0:1.0: USB hub found
[    0.838339] hub 7-0:1.0: 2 ports detected
[    0.838385] Initializing USB Mass Storage driver...
[    0.838409] usbcore: registered new interface driver usb-storage
[    0.838410] USB Mass Storage support registered.
[    0.838428] usbcore: registered new interface driver libusual
[    0.838433] usbcore: registered new interface driver ums-alauda
[    0.838439] usbcore: registered new interface driver ums-cypress
[    0.838447] usbcore: registered new interface driver ums-datafab
[    0.838453] usbcore: registered new interface driver ums-freecom
[    0.838458] usbcore: registered new interface driver ums-isd200
[    0.838463] usbcore: registered new interface driver ums-jumpshot
[    0.838469] usbcore: registered new interface driver ums-karma
[    0.838475] usbcore: registered new interface driver ums-onetouch
[    0.838480] usbcore: registered new interface driver ums-sddr09
[    0.838486] usbcore: registered new interface driver ums-sddr55
[    0.838491] usbcore: registered new interface driver ums-usbat
[    0.838514] PNP: No PS/2 controller found. Probing ports directly.
[    0.838841] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.838845] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.838886] mice: PS/2 mouse device common for all mice
[    0.838897] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.838914] rtc_cmos 00:03: RTC can wake from S4
[    0.838933] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.838954] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.838963] cpuidle: using governor ladder
[    0.838964] cpuidle: using governor menu
[    0.839100] usbcore: registered new interface driver hiddev
[    0.839106] usbcore: registered new interface driver usbhid
[    0.839108] usbhid: v2.6:USB HID core driver
[    0.839282] TCP cubic registered
[    0.839346] NET: Registered protocol family 10
[    0.839605] lo: Disabled Privacy Extensions
[    0.839820] PM: Checking image partition UUID="fc2d8cd0-fed3-4196-b346-83de887dfcf7"
[    0.854311] ata5: SATA link down (SStatus 0 SControl 300)
[    0.854840] ata1: SATA link down (SStatus 0 SControl 300)
[    0.854870] ata4: SATA link down (SStatus 0 SControl 300)
[    0.854879] ata6: SATA link down (SStatus 0 SControl 300)
[    0.860950] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    0.980721] usb 1-3: New USB device found, idVendor=05e3, idProduct=0606
[    0.980722] usb 1-3: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    0.980724] usb 1-3: Product: USB2.0 Hub
[    0.980754] usb 1-3: configuration #1 chosen from 1 choice
[    0.981218] hub 1-3:1.0: USB hub found
[    0.981727] hub 1-3:1.0: 4 ports detected
[    1.007296] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.007965] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.009249] ata2.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.009251] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.009604] ata3.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.009606] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.011322] ata2.00: configured for UDMA/133
[    1.011668] ata3.00: configured for UDMA/133
[    1.023018] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.023109] sd 1:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.023129] sd 1:0:0:0: [sda] Write Protect is off
[    1.023131] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.023144] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.023163] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.023226]  sda:
[    1.023231] sd 2:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.023256] sd 2:0:0:0: [sdb] Write Protect is off
[    1.023257] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.023267] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.023329]  sdb: sda1 sda2
[    1.088412] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.088778]  sdb1 sdb2
[    1.088875] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.088877] PM: Resume from disk failed.
[    1.088881] registered taskstats version 1
[    1.089130]   Magic number: 5:433:188
[    1.089146] acpi device:1a: hash matches
[    1.089178] rtc_cmos 00:03: setting system clock to 2009-12-13 17:11:30 UTC (1260724290)
[    1.089203] Freeing unused kernel memory: 416k freed
[    1.089278] Write protecting the kernel read-only data: 5040k
[    1.109960] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.109979] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.110039] scsi6 : pata_atiixp
[    1.110078] scsi7 : pata_atiixp
[    1.111098] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.111099] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.265681] ata7.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
[    1.271628] ata7.00: configured for UDMA/33
[    1.278080] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
[    1.300251] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.433847] processor LNXCPU:00: registered as cooling_device0
[    1.434198] processor LNXCPU:01: registered as cooling_device1
[    1.434542] processor LNXCPU:02: registered as cooling_device2
[    1.434878] processor LNXCPU:03: registered as cooling_device3
[    1.438264] udev: starting version 146
[    1.444353] usb 4-2: New USB device found, idVendor=046a, idProduct=0021
[    1.444356] usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.444430] usb 4-2: configuration #1 chosen from 1 choice
[    1.453511] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input0
[    1.453559] generic-usb 0003:046A:0021.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-2/input0
[    1.463431] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input1
[    1.463483] generic-usb 0003:046A:0021.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-2/input1
[    1.690244] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.843386] usb 4-3: New USB device found, idVendor=046d, idProduct=c521
[    1.843389] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.843390] usb 4-3: Product: USB Receiver
[    1.843392] usb 4-3: Manufacturer: Logitech
[    1.843448] usb 4-3: configuration #1 chosen from 1 choice
[    1.855718] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
[    1.855769] generic-usb 0003:046D:C521.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    1.867648] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
[    1.867705] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on 
usb-0000:00:12.1-3/input1
[    1.932239] usb 1-3.1: new high speed USB device using ehci_hcd and address 5
[    2.011921] usb 1-3.1: New USB device found, idVendor=058f, idProduct=6362
[    2.011923] usb 1-3.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.011925] usb 1-3.1: Product: Mass Storage Device
[    2.011926] usb 1-3.1: Manufacturer: Generic
[    2.011927] usb 1-3.1: SerialNumber: 058F312D81B
[    2.011974] usb 1-3.1: configuration #1 chosen from 1 choice
[    2.012532] scsi8 : SCSI emulation for USB Mass Storage devices
[    2.012610] usb-storage: device found at 5
[    2.012611] usb-storage: waiting for device to settle before scanning
[    7.012642] usb-storage: device scan complete
[    7.013714] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    7.014778] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    7.015869] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[    7.016921] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    7.411372] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[    7.412120] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    7.413595] sd 8:0:0:2: [sde] Attached SCSI removable disk
[    7.416362] sd 8:0:0:1: [sdd] 3915072 512-byte logical blocks: (2.00 GB/1.86 GiB)
[    7.421646] sd 8:0:0:1: [sdd] Write Protect is off
[    7.421648] sd 8:0:0:1: [sdd] Mode Sense: 03 00 00 00
[    7.421649] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.429651] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.429703]  sdd: sdd1 sdd2
[    7.434840] sd 8:0:0:1: [sdd] Assuming drive cache: write through
[    7.434893] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[    8.227063] EXT4-fs (sdd2): mounted filesystem with ordered data mode
[   11.873641] udev: starting version 146
[   12.058971] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   12.058986] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.059045] r8169 0000:03:00.0: setting latency timer to 64
[   12.059081] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[   12.059435] eth0: RTL8168d/8111d at 0xffffc900016ca000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 27
[   12.071690] sd 1:0:0:0: Attached scsi generic sg0 type 0
[   12.071713] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   12.071730] scsi 6:0:0:0: Attached scsi generic sg2 type 5
[   12.071748] sd 8:0:0:0: Attached scsi generic sg3 type 0
[   12.071764] sd 8:0:0:1: Attached scsi generic sg4 type 0
[   12.071779] sd 8:0:0:2: Attached scsi generic sg5 type 0
[   12.071795] sd 8:0:0:3: Attached scsi generic sg6 type 0
[   12.318038] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[   12.318068] ACPI: Power Button [PWRB]
[   12.318100] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[   12.318115] ACPI: Power Button [PWRF]
[   12.369307] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[   12.369386] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   12.657607] input: PC Speaker as /devices/platform/pcspkr/input/input6
[   12.851305] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.851311] firewire_ohci 0000:02:00.0: setting latency timer to 64
[   12.867360] sr0: scsi3-mmc drive: 94x/94x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.867362] Uniform CD-ROM driver Revision: 3.20
[   12.867428] sr 6:0:0:0: Attached scsi CD-ROM sr0
[   12.911233] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI version 1.10
[   13.001396] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.054485] ALSA sound/pci/hda/hda_codec.c:3881: autoconfig: line_outs=4 (0x1c/0x19/0x22/0x23/0x0)
[   13.054488] ALSA sound/pci/hda/hda_codec.c:3885:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[   13.054491] ALSA sound/pci/hda/hda_codec.c:3889:    hp_outs=1 (0x1d/0x0/0x0/0x0/0x0)
[   13.054493] ALSA sound/pci/hda/hda_codec.c:3890:    mono: mono_out=0x0
[   13.054494] ALSA sound/pci/hda/hda_codec.c:3893:    dig-out=0x20/0x21
[   13.054496] ALSA sound/pci/hda/hda_codec.c:3901:    inputs: mic=0x1a, fmic=0x1e, line=0x1b, fline=0x0, cd=0x0, aux=0x0
[   13.057591] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.057609] HDA Intel 0000:01:05.1: setting latency timer to 64
[   13.351096] Adding 2097144k swap on /dev/sda1.  Priority:-1 extents:1 across:2097144k 
[   13.356677] Adding 2097144k swap on /dev/sdb1.  Priority:-2 extents:1 across:2097144k 
[   13.410307] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[   14.635963] device-mapper: uevent: version 1.0.3
[   14.636058] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   14.650134] md: md0 stopped.
[   14.650765] md: bind<sdb2>
[   14.650865] md: bind<sda2>
[   14.658964] md: raid0 personality registered for level 0
[   14.659109] raid0: looking at sda2
[   14.659110] raid0:   comparing sda2(308387392)
[   14.659111]  with sda2(308387392)
[   14.659112] raid0:   END
[   14.659113] raid0:   ==> UNIQUE
[   14.659114] raid0: 1 zones
[   14.659115] raid0: looking at sdb2
[   14.659116] raid0:   comparing sdb2(308387392)
[   14.659117]  with sda2(308387392)
[   14.659118] raid0:   EQUAL
[   14.659119] raid0: FINAL 1 zones
[   14.659120] raid0: done.
[   14.659121] raid0 : md_size is 616774784 sectors.
[   14.659122] ******* md0 configuration *********
[   14.659123] zone0=[sda2/sdb2/]
[   14.659126]         zone offset=0kb device offset=0kb size=308387392kb
[   14.659143] **********************************
[   14.659144] 
[   14.659149] md0: detected capacity change from 0 to 315788689408
[   14.659760]  md0: unknown partition table
[   16.203674] loop: module loaded
[   16.413378] EXT4-fs (dm-3): mounted filesystem with ordered data mode
[   16.421834] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[   16.445411] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[   16.453738] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[   16.587404] fuse init (API version 7.13)
[   19.297783] r8169: eth0: link up
[   19.297788] r8169: eth0: link up
[   19.803071] Slow work thread pool: Starting up
[   19.803117] Slow work thread pool: Ready
[   19.904979] [drm] Initialized drm 1.1.0 20060810
[   20.270196] [drm] radeon defaulting to userspace modesetting.
[   20.270597] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   20.270600] pci 0000:01:05.0: setting latency timer to 64
[   20.270727] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
[   20.275273] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor processors (4 cpu cores) (version 2.20.00)
[   20.275308] powernow-k8:    0 : pstate 0 (3000 MHz)
[   20.275309] powernow-k8:    1 : pstate 1 (2300 MHz)
[   20.275310] powernow-k8:    2 : pstate 2 (1800 MHz)
[   20.275312] powernow-k8:    3 : pstate 3 (800 MHz)
[   20.414690] [drm] Setting GART location based on new memory map
[   20.414799] [drm] Loading RS780 CP Microcode
[   20.414801] platform r600_cp.0: firmware: requesting radeon/RS780_pfp.bin
[   20.452330] platform r600_cp.0: firmware: requesting radeon/RS780_me.bin
[   20.506542] [drm] Resetting GPU
[   20.506602] [drm] writeback test succeeded in 1 usecs
[   22.915987] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   23.593031] it87: Found IT8712F chip at 0x290, revision 8
[   23.593044] it87: in3 is VCC (+5V)
[   23.593047] it87: in7 is VCCH (+5V Stand-By)
[   23.593603] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SIOE [0x290-0x2af]
[   23.593618] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   29.536321] eth0: no IPv6 routers present
[   32.369960] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold

