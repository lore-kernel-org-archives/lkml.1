Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYEDUaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYEDUaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:30:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbYEDU37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:29:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:28516 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbYEDU35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:29:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VXYsmQaWKQAYMwzFiJgWqSTZHtbzEnr7lF1pSEMKEu3jW+kBLcQmzjfP/kTgVUY/xkFzJs0X0b2Mc3Wi4AFhy7OX1XXWpJR1pXBaEtrOjZaap22IyMS6uWY2h8bHevjGzTHRkKxIKn+3BWau83i41b+zfE4+u3jxbmDqj/TDnhs=
Message-ID: <86802c440805041329u4d6217bv8865df7f7a92071a@mail.gmail.com>
Date: Sun, 4 May 2008 13:29:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: k8-bus_64.c(?) spams dmesg in 2.6.26-rc1
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <481D9DCC.7040000@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <481D9DCC.7040000@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 4, 2008 at 4:28 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Even at KERN_DEBUG, the following dmesg output is both overly excessive
> (overall spew) and overly terse (each line is singularly uninformative to
> anyone but code's author):
..
> 00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev
> a3)
>  00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
>  00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
>  00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
>  00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
>  00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio
> Controller (rev a2)
>  00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
>  00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev
> f3)
>  00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev
> f3)
>  00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
>  00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
>  00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
>  00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> HyperTransport Technology Configuration
>  00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Address Map
>  00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> DRAM Controller
>  00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
>  00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> HyperTransport Technology Configuration
>  00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Address Map
>  00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> DRAM Controller
>  00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> Miscellaneous Control
>  05:05.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000
> Controller (PHY/Link)
>  40:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev
> 12)
>  40:01.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
>  40:02.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev
> 12)
>  40:02.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
>  41:04.0 VGA compatible controller: nVidia Corporation NV17 [GeForce4 MX
> 440] (rev a3)
>  61:04.0 SCSI storage controller: Marvell Technology Group Ltd. 88SX6042
> PCI-X 4-Port SATA-II (rev 02)
>  61:06.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
> Fusion-MPT Dual Ultra320 SCSI (rev 07)
>  61:06.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
> Fusion-MPT Dual Ultra320 SCSI (rev 07)
>  80:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev
> a3)
>  80:01.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev
> a3)
>
> Linux version 2.6.26-rc1-00006-gafa26be (jgarzik@viper.yyz.us) (gcc version
> 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Sun May 4 07:05:17 EDT 2008
>  Command line: ro root=LABEL=/ nogui
>  BIOS-provided physical RAM map:
>   BIOS-e820: 0000000000000000 - 000000000009d400 (usable)
>   BIOS-e820: 000000000009d400 - 00000000000a0000 (reserved)
>   BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
>   BIOS-e820: 0000000000100000 - 000000007fff9300 (usable)
>   BIOS-e820: 000000007fff9300 - 0000000080000000 (reserved)
>   BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
>  Entering add_active_range(0, 0, 157) 0 entries of 3200 used
>  Entering add_active_range(0, 256, 524281) 1 entries of 3200 used
>  max_pfn_mapped = 1048576
>  x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>  init_memory_mapping
>  DMI 2.3 present.
>  ACPI: RSDP 000E8010, 0024 (r2 HP    )
>  ACPI: XSDT 7FFF94FC, 0044 (r1 HP     CPQ0062  20061128             0)
>  ACPI: FACP 7FFF96A4, 010C (r3 HP     VIPER           1             0)
>  ACPI Warning (tbfadt-0230): FADT (revision 3) is longer than ACPI 2.0
> version, truncating length 0x10C to 0xF4 [20080321]
>  ACPI: DSDT 7FFF989A, 14AF (r1 HP         DSDT        1 MSFT  100000E)
>  ACPI: FACS 7FFF9300, 0040
>  ACPI: SSDT 7FFFAD49, 3A95 (r2 HP      PROJECT        1 MSFT  100000E)
>  ACPI: APIC 7FFF97B0, 009E (r1 HP     VIPER           1             0)
>  ACPI: SRAT 7FFF93EC, 0110 (r2 HP     VIPER           1             0)
>  ACPI: DMI detected: Hewlett-Packard
>  SRAT: PXM 0 -> APIC 0 -> Node 0
>  SRAT: PXM 0 -> APIC 1 -> Node 0
>  SRAT: PXM 1 -> APIC 2 -> Node 1
>  SRAT: PXM 1 -> APIC 3 -> Node 1
>  SRAT: Node 0 PXM 0 0-a0000
>  Entering add_active_range(0, 0, 157) 0 entries of 3200 used
>  SRAT: Node 0 PXM 0 e8000-40000000
>  Entering add_active_range(0, 256, 262144) 1 entries of 3200 used
>  SRAT: Node 1 PXM 1 40000000-80000000
>  Entering add_active_range(1, 262144, 524281) 2 entries of 3200 used
>  NUMA: Allocated memnodemap from c000 - 2c040
>  NUMA: Using 15 for the hash shift.
>  Bootmem setup node 0 0000000000000000-0000000040000000
>   NODE_DATA [0000000000001000 - 0000000000004fff]
>   bootmap [000000000002d000 -  0000000000034fff] pages 8
>   early res: 0 [0-fff] BIOS data page
>   early res: 1 [6000-7fff] TRAMPOLINE
>   early res: 2 [200000-6347d3] TEXT DATA BSS
>   early res: 3 [37cb8000-37fefd4e] RAMDISK
>   early res: 4 [9d400-fffff] BIOS reserved
>   early res: 5 [8000-bfff] PGTABLE
>   early res: 6 [c000-2c03f] MEMNODEMAP
>  Bootmem setup node 1 0000000040000000-000000007fff9000
>   NODE_DATA [0000000040000000 - 0000000040003fff]
>   bootmap [0000000040004000 -  000000004000bfff] pages 8
>   [ffffe20000000000-ffffe20000dfffff] PMD ->
> [ffff810001200000-ffff810001ffffff] on node 0
>   [ffffe20000e00000-ffffe20001bfffff] PMD ->
> [ffff810040200000-ffff810040ffffff] on node 1
>  Zone PFN ranges:
>   DMA             0 ->     4096
>   DMA32        4096 ->  1048576
>   Normal    1048576 ->  1048576
>  Movable zone start PFN for each node
>  early_node_map[3] active PFN ranges
>     0:        0 ->      157
>     0:      256 ->   262144
>     1:   262144 ->   524281
>  On node 0 totalpages: 262045
>   DMA zone: 56 pages used for memmap
>   DMA zone: 1215 pages reserved
>   DMA zone: 2726 pages, LIFO batch:0
>   DMA32 zone: 3528 pages used for memmap
>   DMA32 zone: 254520 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
>  On node 1 totalpages: 262137
>   DMA zone: 0 pages used for memmap
>   DMA32 zone: 3583 pages used for memmap
>   DMA32 zone: 258554 pages, LIFO batch:31
>   Normal zone: 0 pages used for memmap
>   Movable zone: 0 pages used for memmap
>  Nvidia board detected. Ignoring ACPI timer override.
>  If you got timer trouble try acpi_use_timer_override
>  ACPI: PM-Timer IO Port: 0xf808
>  ACPI: Local APIC address 0xfee00000
>  ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>  ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>  ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>  ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>  ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>  ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
>  ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
>  ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
>  ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
>  IOAPIC[0]: apic_id 8, version 0, address 0xfec00000, GSI 0-23
>  ACPI: IOAPIC (id[0x09] address[0xfa600000] gsi_base[24])
>  IOAPIC[1]: apic_id 9, version 0, address 0xfa600000, GSI 24-27
>  ACPI: IOAPIC (id[0x0a] address[0xfa601000] gsi_base[28])
>  IOAPIC[2]: apic_id 10, version 0, address 0xfa601000, GSI 28-31
>  ACPI: IOAPIC (id[0x0b] address[0xfa900000] gsi_base[32])
>  IOAPIC[3]: apic_id 11, version 0, address 0xfa900000, GSI 32-55
>  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>  ACPI: IRQ9 used by override.
>  Setting APIC routing to flat
>  Using ACPI (MADT) for SMP configuration information
>  Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
>  SMP: Allowing 4 CPUs, 0 hotplug CPUs
>  PERCPU: Allocating 33552 bytes of per cpu data
>  NR_CPUS: 16, nr_cpu_ids: 4
>  Built 2 zonelists in Node order, mobility grouping on.  Total pages: 515800
>  Policy zone: DMA32
>  Kernel command line: ro root=LABEL=/ nogui
>  Initializing CPU#0
>  PID hash table entries: 4096 (order: 12, 32768 bytes)
>  Extended CMOS year: 2000
>  TSC calibrated against PM_TIMER
>  Marking TSC unstable due to TSCs unsynchronized
>  time.c: Detected 2393.627 MHz processor.
>  spurious 8259A interrupt: IRQ7.
>  Console: colour VGA+ 80x25
>  console [tty0] enabled
>  Checking aperture...
>  Node 0: aperture @ 220000000 size 32 MB
>  Aperture beyond 4GB. Ignoring.
>  No AGP bridge found
>  Memory: 2059968k/2097124k available (2134k kernel code, 36760k reserved,
> 1292k data, 328k init)
>  CPA: page pool initialized 1 of 1 pages preallocated
>  Calibrating delay using timer specific routine.. 4790.20 BogoMIPS
> (lpj=9580407)
>  Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
>  Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>  Mount-cache hash table entries: 256
>  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  CPU: L2 Cache: 1024K (64 bytes/line)
>  CPU 0/0 -> Node 0
>  CPU: Physical Processor ID: 0
>  CPU: Processor Core ID: 0
>  ACPI: Core revision 20080321
>  CPU0: Dual Core AMD Opteron(tm) Processor 280 stepping 02
>  Using local APIC timer interrupts.
>  APIC timer calibration result 12466795
>  Detected 12.466 MHz APIC timer.
>  Booting processor 1/1 ip 6000
>  Initializing CPU#1
>  Calibrating delay using timer specific routine.. 4787.36 BogoMIPS
> (lpj=9574722)
>  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  CPU: L2 Cache: 1024K (64 bytes/line)
>  CPU 1/1 -> Node 0
>  CPU: Physical Processor ID: 0
>  CPU: Processor Core ID: 1
>  x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
>  CPU1: Dual Core AMD Opteron(tm) Processor 280 stepping 02
>  Booting processor 2/2 ip 6000
>  Initializing CPU#2
>  Calibrating delay using timer specific routine.. 4787.32 BogoMIPS
> (lpj=9574649)
>  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  CPU: L2 Cache: 1024K (64 bytes/line)
>  CPU 2/2 -> Node 1
>  CPU: Physical Processor ID: 1
>  CPU: Processor Core ID: 0
>  x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
>  CPU2: Dual Core AMD Opteron(tm) Processor 280 stepping 02
>  Booting processor 3/3 ip 6000
>  Initializing CPU#3
>  Calibrating delay using timer specific routine.. 4787.32 BogoMIPS
> (lpj=9574647)
>  CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
>  CPU: L2 Cache: 1024K (64 bytes/line)
>  CPU 3/3 -> Node 1
>  CPU: Physical Processor ID: 1
>  CPU: Processor Core ID: 1
>  x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
>  CPU3: Dual Core AMD Opteron(tm) Processor 280 stepping 02
>  Brought up 4 CPUs
>  Total of 4 processors activated (19152.21 BogoMIPS).
>  net_namespace: 568 bytes
>  NET: Registered protocol family 16
>  node 0 link 0: io port [2000, 2fff]
>  node 0 link 2: io port [1000, 1fff]
>  node 1 link 0: io port [e000, efff]
>  TOM: 0000000080000000 aka 2048M
>  node 0 link 2: mmio [a0000, bffff]
>  node 1 link 0: mmio [e8000000, efffffff]
>  node 0 link 0: mmio [febf0000, febfffff]
>  node 0 link 2: mmio [f0000000, fa6fffff]
>  node 0 link 0: mmio [fa700000, fa8fffff]
>  node 1 link 0: mmio [fa900000, fa9fffff]
...
>  bus: [00,3f] on node 0 link 0
>  bus: 00 index 0 io port: [2000, dfff]
>  bus: 00 index 1 io port: [0, fff]
>  bus: 00 index 2 io port: [f000, ffff]
>  bus: 00 index 3 mmio: [faa00000, fcffffffff]
>  bus: 00 index 4 mmio: [fa700000, fa8fffff]
>  bus: 00 index 5 mmio: [80000000, e7ffffff]
>  bus: [40,7f] on node 0 link 2
>  bus: 40 index 0 io port: [1000, 1fff]
>  bus: 40 index 1 mmio: [a0000, bffff]
>  bus: 40 index 2 mmio: [f0000000, fa6fffff]
>  bus: [80,ff] on node 1 link 0
>  bus: 80 index 0 io port: [e000, efff]
>  bus: 80 index 1 mmio: [e8000000, efffffff]
>  bus: 80 index 2 mmio: [fa900000, fa9fffff]

good, you have three HT links...

will send patch to disable the print spew...

YH
