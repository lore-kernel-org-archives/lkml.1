Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZIUAgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZIUAgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 20:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZIUAgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 20:36:20 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:60782 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZIUAgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 20:36:17 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Luca Tettamanti <kronos.it@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] it87 sensors need an ACPI driver (2.6.31)
Date: Sun, 20 Sep 2009 20:35:54 -0400
User-Agent: KMail/1.12.1 (Linux/2.6.31; KDE/4.3.1; i686; ; )
References: <c43b2e150909200120kf87cdc2oabafea8abbf01227@mail.gmail.com>
 <200909201637.52514.gene.heskett@verizon.net>
 <68676e00909201431j43402470g70df5519a963097b@mail.gmail.com>
In-reply-to: <68676e00909201431j43402470g70df5519a963097b@mail.gmail.com>
MIME-version: 1.0
Content-type: Multipart/Mixed; boundary="Boundary-00=_qpstKwsU1BDawVf"
Message-id: <200909202035.54220.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_qpstKwsU1BDawVf
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Sunday 20 September 2009, Luca Tettamanti wrote:
>On Sun, Sep 20, 2009 at 10:37 PM, Gene Heskett <gene.heskett@verizon.net> 
wrote:
>> On Sunday 20 September 2009, Luca Tettamanti wrote:
>>>On Sun, Sep 20, 2009 at 10:20 AM, wixor <wixorpeek@gmail.com> wrote:
>>>> Hello,
>>>> with recent upgrade to 2.6.31 I get
>>>>
>>>> it87: Found IT8712F chip at 0x290, revision 7
>>>> it87: in3 is VCC (+5V)
>>>> it87: in7 is VCCH (+5V Stand-By)
>>>> ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__
>>>> [0x295-0x296]
>>>> ACPI: Device needs an ACPI driver
>>>> FATAL: Error inserting it87
>>>> (/lib/modules/2.6.31/kernel/drivers/hwmon/it87.ko): Device or resource
>>>> busy
>>>
>>>[...]
>>>
>>>> I have also discovered that dsdt contains description of what is
>>>> connected to each it87 input. Maybe it has also some code to access
>>>> the chip? In /proc/acpi I can read only one temperature, while the
>>>> chip measures three temperatures, fan speeds and voltages. This is
>>>> desktop pc with ASUS A8N1-E maniboard, athlon64 and nforce4 chipset.
>>>
>>>Try the asus_atk0110 driver, it handles the ACPI hwmon interface on
>>>Asus motherboards. If it does not work then please send a dump of your
>>>DSDT (/sys/firmware/acpi/tables/DSDT).
>>
>> Jumping in the middle of this, I am another that it87 doesn't work very
>> well for,  ASUS M2N SLI Deluxe board.
>
>Please define "doesn't work well". asus_atk0110 should handle that
>board. In case of troubles enable CONFIG_HWMON_DEBUG_CHIP, load
>asus_atk0110 and post the content of the kernel log.
>
With that CONFIG_HWMON_DEBUG_CHIP enabled, dmesg (attached) looks semi-
kosher, but neither gkrellm nor sensors can show me data until it87 is 
loaded.  I unloaded it87 and reloaded it several times just now.  Something 
funkity someplace...  Is there a new application I need to dl and install?  
Or does Bill need to work on gkrellm?

Thanks Luca.

>Luca
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The NRA is offering FREE Associate memberships to anyone who wants them.
<https://www.nrahq.org/nrabonus/accept-membership.asp>

Friction is a drag.

--Boundary-00=_qpstKwsU1BDawVf
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.31 (root@coyote.coyote.den) (gcc version 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC) ) #2 SMP PREEMPT Sun Sep 20 20:09:46 EDT 2009
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
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFE0000000 write-back
[    0.000000]   3 base 0000DFF00000 mask FFFFFFF00000 uncachable
[    0.000000]   4 base 000100000000 mask FFFFE0000000 write-back
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000120000000 aka 4608M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000dfee0000 (usable)
[    0.000000]  modified: 00000000dfee0000 - 00000000dfee3000 (ACPI NVS)
[    0.000000]  modified: 00000000dfee3000 - 00000000dfef0000 (ACPI data)
[    0.000000]  modified: 00000000dfef0000 - 00000000dff00000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 01a00000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 10000-16000
[    0.000000] RAMDISK: 37c92000 - 37fefbe2
[    0.000000] Allocated new RAMDISK: 00100000 - 0045dbe2
[    0.000000] Move RAMDISK from 0000000037c92000 - 0000000037fefbe1 to 00100000 - 0045dbe1
[    0.000000] ACPI: RSDP 000f7db0 00024 (v02 Nvidia)
[    0.000000] ACPI: XSDT dfee3100 00044 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: FACP dfeeadc0 000F4 (v03 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: DSDT dfee3280 07ACE (v01 NVIDIA AWRDACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS dfee0000 00040
[    0.000000] ACPI: HPET dfeeb000 00038 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000098)
[    0.000000] ACPI: MCFG dfeeb080 0003C (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: APIC dfeeaf00 00098 (v01 Nvidia ASUSACPI 42302E31 AWRD 00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 3718MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00012000 - 00018f40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 00015329cc]    TEXT DATA BSS ==> [0001000000 - 00015329cc]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 - 0000100000]
[    0.000000]   #5 [0001533000 - 0001540155]              BRK ==> [0001533000 - 0001540155]
[    0.000000]   #6 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 - 0000012000]
[    0.000000]   #7 [0000100000 - 000045dbe2]      NEW RAMDISK ==> [0000100000 - 000045dbe2]
[    0.000000]   #8 [0000012000 - 0000019000]          BOOTMAP ==> [0000012000 - 0000019000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000dfee0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048175
[    0.000000] free_area_init_node: node 0, pgdat c1478e00, node_mem_map c1541200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 1748 pages used for memmap
[    0.000000]   Normal zone: 221994 pages, LIFO batch:31
[    0.000000]   HighMem zone: 7437 pages used for memmap
[    0.000000]   HighMem zone: 813013 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfefff000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at dff00000 (gap: dff00000:10100000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 14 pages at c3951000, static data 35908 bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1038958
[    0.000000] Kernel command line: ro root=LABEL=/ nomodeset memory_corruption_check=1 acpi_enforce_resources=no
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000379fe:00120000)
[    0.000000] Memory: 4145092k/4718592k available (3260k kernel code, 46780k reserved, 1332k data, 416k init, 3281800k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc147d000 - 0xc14e5000   ( 416 kB)
[    0.000000]       .data : 0xc132f010 - 0xc147c388   (1332 kB)
[    0.000000]       .text : 0xc1000000 - 0xc132f010   (3260 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] CPU 0 irqstacks, hard=c3951000 soft=c3952000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2210.434 MHz processor.
[    0.000010] spurious 8259A interrupt: IRQ7.
[    0.000985] Console: colour VGA+ 80x25
[    0.000987] console [tty0] enabled
[    0.003333] hpet clockevent registered
[    0.003333] Calibrating delay loop (skipped), value calculated using timer frequency.. 4422.07 BogoMIPS (lpj=7368113)
[    0.003333] Security Framework initialized
[    0.003333] Mount-cache hash table entries: 512
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 0
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] using C1E aware idle routine
[    0.003333] Performance Counters: AMD PMU driver.
[    0.003333] ... version:                 0
[    0.003333] ... bit width:               48
[    0.003333] ... generic counters:        4
[    0.003333] ... value mask:              0000ffffffffffff
[    0.003333] ... max period:              00007fffffffffff
[    0.003333] ... fixed-purpose counters:  0
[    0.003333] ... counter mask:            000000000000000f
[    0.003333] Checking 'hlt' instruction... OK.
[    0.013632] Freeing SMP alternatives: 12k freed
[    0.013698] ACPI: Core revision 20090521
[    0.027195] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.060425] CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.063332] CPU 1 irqstacks, hard=c3961000 soft=c3962000
[    0.063332] Booting processor 1 APIC 0x1 ip 0x6000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 4422.72 BogoMIPS (lpj=7367559)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.153981] CPU1: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.154566] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.156762] CPU 2 irqstacks, hard=c3971000 soft=c3972000
[    0.156765] Booting processor 2 APIC 0x2 ip 0x6000
[    0.003333] Initializing CPU#2
[    0.003333] Calibrating delay using timer specific routine.. 4422.59 BogoMIPS (lpj=7367358)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 2
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.250665] CPU2: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.251252] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.253424] CPU 3 irqstacks, hard=c3981000 soft=c3982000
[    0.253427] Booting processor 3 APIC 0x3 ip 0x6000
[    0.003333] Initializing CPU#3
[    0.003333] Calibrating delay using timer specific routine.. 4422.62 BogoMIPS (lpj=7367396)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 3
[    0.003333] mce: CPU supports 6 MCE banks
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.347328] CPU3: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.348681] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.350040] Brought up 4 CPUs
[    0.350100] Total of 4 processors activated (17689.01 BogoMIPS).
[    0.350237] CPU0 attaching sched-domain:
[    0.350240]  domain 0: span 0-3 level CPU
[    0.350242]   groups: 0 1 2 3
[    0.350248] CPU1 attaching sched-domain:
[    0.350250]  domain 0: span 0-3 level CPU
[    0.350252]   groups: 1 2 3 0
[    0.350256] CPU2 attaching sched-domain:
[    0.350258]  domain 0: span 0-3 level CPU
[    0.350260]   groups: 2 3 0 1
[    0.350264] CPU3 attaching sched-domain:
[    0.350266]  domain 0: span 0-3 level CPU
[    0.350268]   groups: 3 0 1 2
[    0.350982] NET: Registered protocol family 16
[    0.353620] ACPI: bus type pci registered
[    0.353783] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
[    0.353848] PCI: MCFG area at f0000000 reserved in E820
[    0.353909] PCI: Using MMCONFIG for extended config space
[    0.353973] PCI: Using configuration type 1 for base access
[    0.357107] bio: create slab <bio-0> at 0
[    0.358229] ACPI: EC: Look up EC in DSDT
[    0.368294] ACPI: Interpreter enabled
[    0.368357] ACPI: (supports S0 S5)
[    0.368468] ACPI: Using IOAPIC for interrupt routing
[    0.379726] ACPI: No dock devices found.
[    0.379894] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.380198] pci 0000:00:01.1: reg 10 io port: [0xfc00-0xfc3f]
[    0.380209] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
[    0.380214] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
[    0.380234] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.380300] pci 0000:00:01.1: PME# disabled
[    0.380382] pci 0000:00:02.0: reg 10 32bit mmio: [0xfe02f000-0xfe02ffff]
[    0.380401] pci 0000:00:02.0: supports D1 D2
[    0.380403] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.380460] pci 0000:00:02.0: PME# disabled
[    0.380544] pci 0000:00:02.1: reg 10 32bit mmio: [0xfe02e000-0xfe02e0ff]
[    0.380563] pci 0000:00:02.1: supports D1 D2
[    0.380565] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.380622] pci 0000:00:02.1: PME# disabled
[    0.380714] pci 0000:00:04.0: reg 20 io port: [0xf000-0xf00f]
[    0.380740] pci 0000:00:05.0: reg 10 io port: [0x9f0-0x9f7]
[    0.380743] pci 0000:00:05.0: reg 14 io port: [0xbf0-0xbf3]
[    0.380747] pci 0000:00:05.0: reg 18 io port: [0x970-0x977]
[    0.380750] pci 0000:00:05.0: reg 1c io port: [0xb70-0xb73]
[    0.380754] pci 0000:00:05.0: reg 20 io port: [0xdc00-0xdc0f]
[    0.380758] pci 0000:00:05.0: reg 24 32bit mmio: [0xfe02d000-0xfe02dfff]
[    0.380787] pci 0000:00:05.1: reg 10 io port: [0x9e0-0x9e7]
[    0.380790] pci 0000:00:05.1: reg 14 io port: [0xbe0-0xbe3]
[    0.380794] pci 0000:00:05.1: reg 18 io port: [0x960-0x967]
[    0.380797] pci 0000:00:05.1: reg 1c io port: [0xb60-0xb63]
[    0.380801] pci 0000:00:05.1: reg 20 io port: [0xc800-0xc80f]
[    0.380805] pci 0000:00:05.1: reg 24 32bit mmio: [0xfe02c000-0xfe02cfff]
[    0.380833] pci 0000:00:05.2: reg 10 io port: [0xc400-0xc407]
[    0.380837] pci 0000:00:05.2: reg 14 io port: [0xc000-0xc003]
[    0.380840] pci 0000:00:05.2: reg 18 io port: [0xbc00-0xbc07]
[    0.380844] pci 0000:00:05.2: reg 1c io port: [0xb800-0xb803]
[    0.380847] pci 0000:00:05.2: reg 20 io port: [0xb400-0xb40f]
[    0.380851] pci 0000:00:05.2: reg 24 32bit mmio: [0xfe02b000-0xfe02bfff]
[    0.380905] pci 0000:00:06.1: reg 10 32bit mmio: [0xfe020000-0xfe023fff]
[    0.380927] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.380983] pci 0000:00:06.1: PME# disabled
[    0.381079] pci 0000:00:08.0: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
[    0.381082] pci 0000:00:08.0: reg 14 io port: [0xb000-0xb007]
[    0.381086] pci 0000:00:08.0: reg 18 32bit mmio: [0xfe029000-0xfe0290ff]
[    0.381090] pci 0000:00:08.0: reg 1c 32bit mmio: [0xfe028000-0xfe02800f]
[    0.381110] pci 0000:00:08.0: supports D1 D2
[    0.381112] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381170] pci 0000:00:08.0: PME# disabled
[    0.381263] pci 0000:00:09.0: reg 10 32bit mmio: [0xfe027000-0xfe027fff]
[    0.381267] pci 0000:00:09.0: reg 14 io port: [0xac00-0xac07]
[    0.381271] pci 0000:00:09.0: reg 18 32bit mmio: [0xfe026000-0xfe0260ff]
[    0.381275] pci 0000:00:09.0: reg 1c 32bit mmio: [0xfe025000-0xfe02500f]
[    0.381295] pci 0000:00:09.0: supports D1 D2
[    0.381297] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381354] pci 0000:00:09.0: PME# disabled
[    0.381446] pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381502] pci 0000:00:0e.0: PME# disabled
[    0.381597] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.381653] pci 0000:00:0f.0: PME# disabled
[    0.381817] pci 0000:01:06.0: reg 10 32bit mmio: [0xfcfe0000-0xfcfeffff]
[    0.381822] pci 0000:01:06.0: reg 14 32bit mmio: [0xfcfd0000-0xfcfdffff]
[    0.381870] pci 0000:01:07.0: reg 10 io port: [0x9c00-0x9c3f]
[    0.381896] pci 0000:01:07.0: supports D1 D2
[    0.381918] pci 0000:01:08.0: reg 10 32bit mmio: [0xfb000000-0xfbffffff]
[    0.381963] pci 0000:01:08.2: reg 10 32bit mmio: [0xfa000000-0xfaffffff]
[    0.382011] pci 0000:01:0b.0: reg 10 32bit mmio: [0xfcfff000-0xfcfff7ff]
[    0.382016] pci 0000:01:0b.0: reg 14 32bit mmio: [0xfcff8000-0xfcffbfff]
[    0.382042] pci 0000:01:0b.0: supports D1 D2
[    0.382044] pci 0000:01:0b.0: PME# supported from D0 D1 D2 D3hot
[    0.382101] pci 0000:01:0b.0: PME# disabled
[    0.382173] pci 0000:00:06.0: transparent bridge
[    0.382237] pci 0000:00:06.0: bridge io port: [0x9000-0x9fff]
[    0.382240] pci 0000:00:06.0: bridge 32bit mmio: [0xfa000000-0xfcffffff]
[    0.382271] pci 0000:00:0e.0: bridge io port: [0x7000-0x8fff]
[    0.382274] pci 0000:00:0e.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]
[    0.382298] pci 0000:03:00.0: reg 10 64bit mmio: [0xe0000000-0xefffffff]
[    0.382305] pci 0000:03:00.0: reg 18 64bit mmio: [0xfdde0000-0xfddeffff]
[    0.382310] pci 0000:03:00.0: reg 20 io port: [0x6c00-0x6cff]
[    0.382317] pci 0000:03:00.0: reg 30 32bit mmio: [0xfddc0000-0xfdddffff]
[    0.382332] pci 0000:03:00.0: supports D1 D2
[    0.382358] pci 0000:03:00.1: reg 10 64bit mmio: [0xfddfc000-0xfddfffff]
[    0.382385] pci 0000:03:00.1: supports D1 D2
[    0.382419] pci 0000:00:0f.0: bridge io port: [0x6000-0x6fff]
[    0.382422] pci 0000:00:0f.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
[    0.382426] pci 0000:00:0f.0: bridge 64bit mmio pref: [0xe0000000-0xefffffff]
[    0.382432] pci_bus 0000:00: on NUMA node 0
[    0.382437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.382728] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.434005] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 *11 14 15)
[    0.434409] ACPI: PCI Interrupt Link [LNK2] (IRQs *5 7 9 10 11 14 15)
[    0.434805] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.435270] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.435740] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.436204] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 *10 11 14 15)
[    0.436605] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 *11 14 15)
[    0.436998] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.437465] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.437932] ACPI: PCI Interrupt Link [LUBA] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.438402] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 *10 11 14 15)
[    0.438799] ACPI: PCI Interrupt Link [LMC1] (IRQs 5 7 9 *10 11 14 15)
[    0.439202] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    0.439600] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.440087] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.440556] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.441025] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.441492] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 *10 11 14 15)
[    0.441896] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 10 *11 14 15)
[    0.442296] ACPI: PCI Interrupt Link [LSA2] (IRQs *5 7 9 10 11 14 15)
[    0.442742] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0
[    0.443082] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.443428] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.443779] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.444130] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.444491] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
[    0.444821] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.445155] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.445512] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
[    0.445918] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.446315] ACPI: PCI Interrupt Link [AMC1] (IRQs 20 21 22 23) *0
[    0.446710] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.447122] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.447519] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
[    0.447936] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
[    0.448352] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.448764] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.449177] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.449578] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.449969] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.450524] SCSI subsystem initialized
[    0.450686] libata version 3.00 loaded.
[    0.450777] usbcore: registered new interface driver usbfs
[    0.450909] usbcore: registered new interface driver hub
[    0.451025] usbcore: registered new device driver usb
[    0.451234] PCI: Using ACPI for IRQ routing
[    0.480006] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
[    0.480115] hpet0: at MMIO 0xfefff000, IRQs 2, 8, 31
[    0.480257] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.501368] Switched to high resolution mode on CPU 1
[    0.501374] Switched to high resolution mode on CPU 2
[    0.502149] Switched to high resolution mode on CPU 3
[    0.503325] Switched to high resolution mode on CPU 0
[    0.506684] pnp: PnP ACPI init
[    0.506750] ACPI: bus type pnp registered
[    0.512403] pnp: PnP ACPI: found 13 devices
[    0.512464] ACPI: ACPI bus type pnp unregistered
[    0.512532] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.512588] system 00:01: ioport range 0x1080-0x10ff has been reserved
[    0.512652] system 00:01: ioport range 0x1400-0x147f has been reserved
[    0.512717] system 00:01: ioport range 0x1480-0x14ff has been reserved
[    0.512780] system 00:01: ioport range 0x1800-0x187f has been reserved
[    0.512847] system 00:01: ioport range 0x1880-0x18ff has been reserved
[    0.512912] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.512975] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.513031] system 00:02: ioport range 0x290-0x297 has been reserved
[    0.513094] system 00:0b: iomem range 0xf0000000-0xf3ffffff has been reserved
[    0.513161] system 00:0c: iomem range 0xcf000-0xcffff has been reserved
[    0.513227] system 00:0c: iomem range 0xf0000-0xf7fff could not be reserved
[    0.513283] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.513352] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.513409] system 00:0c: iomem range 0xfefff000-0xfefff0ff has been reserved
[    0.513478] system 00:0c: iomem range 0xdfee0000-0xdfefffff could not be reserved
[    0.513564] system 00:0c: iomem range 0xffff0000-0xffffffff has been reserved
[    0.513625] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.513686] system 00:0c: iomem range 0x100000-0xdfedffff could not be reserved
[    0.513776] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.513866] system 00:0c: iomem range 0xfee00000-0xfeefffff has been reserved
[    0.513935] system 00:0c: iomem range 0xfefff000-0xfeffffff could not be reserved
[    0.514022] system 00:0c: iomem range 0xfff80000-0xfff80fff has been reserved
[    0.514093] system 00:0c: iomem range 0xfff90000-0xfffbffff has been reserved
[    0.514157] system 00:0c: iomem range 0xfffed000-0xfffeffff has been reserved
[    0.549209] pci 0000:00:06.0: PCI bridge, secondary bus 0000:01
[    0.549272] pci 0000:00:06.0:   IO window: 0x9000-0x9fff
[    0.549337] pci 0000:00:06.0:   MEM window: 0xfa000000-0xfcffffff
[    0.549400] pci 0000:00:06.0:   PREFETCH window: disabled
[    0.549465] pci 0000:00:0e.0: PCI bridge, secondary bus 0000:02
[    0.549521] pci 0000:00:0e.0:   IO window: 0x7000-0x8fff
[    0.549583] pci 0000:00:0e.0:   MEM window: 0xfde00000-0xfdefffff
[    0.549649] pci 0000:00:0e.0:   PREFETCH window: disabled
[    0.549711] pci 0000:00:0f.0: PCI bridge, secondary bus 0000:03
[    0.549774] pci 0000:00:0f.0:   IO window: 0x6000-0x6fff
[    0.549839] pci 0000:00:0f.0:   MEM window: 0xfdd00000-0xfddfffff
[    0.549903] pci 0000:00:0f.0:   PREFETCH window: 0x000000e0000000-0x000000efffffff
[    0.550009] pci 0000:00:06.0: setting latency timer to 64
[    0.550014] pci 0000:00:0e.0: setting latency timer to 64
[    0.550018] pci 0000:00:0f.0: setting latency timer to 64
[    0.550021] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.550024] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.550027] pci_bus 0000:01: resource 0 io:  [0x9000-0x9fff]
[    0.550029] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfcffffff]
[    0.550032] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.550034] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.550037] pci_bus 0000:02: resource 0 io:  [0x7000-0x8fff]
[    0.550039] pci_bus 0000:02: resource 1 mem: [0xfde00000-0xfdefffff]
[    0.550042] pci_bus 0000:03: resource 0 io:  [0x6000-0x6fff]
[    0.550044] pci_bus 0000:03: resource 1 mem: [0xfdd00000-0xfddfffff]
[    0.550047] pci_bus 0000:03: resource 2 pref mem [0xe0000000-0xefffffff]
[    0.550109] NET: Registered protocol family 2
[    0.550267] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.550635] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.551073] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.551337] TCP: Hash tables configured (established 131072 bind 65536)
[    0.551403] TCP reno registered
[    0.551547] NET: Registered protocol family 1
[    0.551664] Unpacking initramfs...
[    0.638043] Freeing initrd memory: 3446k freed
[    0.641166] microcode: CPU0: patch_level=0x1000065
[    0.641230] microcode: CPU1: patch_level=0x1000065
[    0.641295] microcode: CPU2: patch_level=0x1000065
[    0.641360] microcode: CPU3: patch_level=0x1000065
[    0.641459] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.641552] Scanning for low memory corruption every 60 seconds
[    0.641814] audit: initializing netlink socket (disabled)
[    0.641890] type=2000 audit(1253492300.640:1): initialized
[    0.642364] highmem bounce pool size: 64 pages
[    0.642428] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.642791] msgmni has been set to 1694
[    0.643121] alg: No test for stdrng (krng)
[    0.643235] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.643330] io scheduler noop registered
[    0.643419] io scheduler cfq registered (default)
[    0.656282] pci 0000:03:00.0: Boot video device
[    0.656417] pcieport-driver 0000:00:0e.0: setting latency timer to 64
[    0.656496] pcieport-driver 0000:00:0f.0: setting latency timer to 64
[    0.656852] fan PNP0C0B:00: registered as cooling_device0
[    0.656915] ACPI: Fan [FAN] (on)
[    0.657096] processor LNXCPU:00: registered as cooling_device1
[    0.657219] processor LNXCPU:01: registered as cooling_device2
[    0.657337] processor LNXCPU:02: registered as cooling_device3
[    0.657464] processor LNXCPU:03: registered as cooling_device4
[    0.657937] ACPI Warning: \_TZ_.THRM._PSL: Return Package type mismatch at index 0 - found [NULL Object Descriptor], expected Reference 20090521 nspredef-946
[    0.658089] ACPI: Expecting a [Reference] package element, found type 0
[    0.658924] ACPI: Invalid passive threshold
[    0.659377] thermal LNXTHERM:01: registered as thermal_zone0
[    0.659444] ACPI: Thermal Zone [THRM] (40 C)
[    0.662627] Non-volatile memory driver v1.3
[    0.662689] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.662867] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.663303] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.663644] Floppy drive(s): fd0 is 1.44M
[    0.683603] FDC 0 is a post-1991 82077
[    0.685392] loop: module loaded
[    0.685544] nbd: registered device at major 43
[    0.687252] sata_nv 0000:00:05.0: version 3.5
[    0.687590] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 23
[    0.687661] sata_nv 0000:00:05.0: PCI INT A -> Link[APSI] -> GSI 23 (level, low) -> IRQ 23
[    0.687756] sata_nv 0000:00:05.0: Using SWNCQ mode
[    0.688396] sata_nv 0000:00:05.0: setting latency timer to 64
[    0.688516] scsi0 : sata_nv
[    0.688696] scsi1 : sata_nv
[    0.688954] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xdc00 irq 23
[    0.689019] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xdc08 irq 23
[    0.689448] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 22
[    0.689518] sata_nv 0000:00:05.1: PCI INT B -> Link[APSJ] -> GSI 22 (level, low) -> IRQ 22
[    0.689613] sata_nv 0000:00:05.1: Using SWNCQ mode
[    0.690265] sata_nv 0000:00:05.1: setting latency timer to 64
[    0.690382] scsi2 : sata_nv
[    0.690532] scsi3 : sata_nv
[    0.690793] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc800 irq 22
[    0.690849] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc808 irq 22
[    0.691282] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 21
[    0.691352] sata_nv 0000:00:05.2: PCI INT C -> Link[ASA2] -> GSI 21 (level, low) -> IRQ 21
[    0.691447] sata_nv 0000:00:05.2: Using SWNCQ mode
[    0.692086] sata_nv 0000:00:05.2: setting latency timer to 64
[    0.692211] scsi4 : sata_nv
[    0.692359] scsi5 : sata_nv
[    0.692611] ata5: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb400 irq 21
[    0.692675] ata6: SATA max UDMA/133 cmd 0xbc00 ctl 0xb800 bmdma 0xb408 irq 21
[    0.692830] pata_amd 0000:00:04.0: version 0.4.1
[    0.692860] pata_amd 0000:00:04.0: setting latency timer to 64
[    0.703229] ata5: SATA link down (SStatus 0 SControl 300)
[    0.703237] scsi6 : pata_amd
[    0.703319] scsi7 : pata_amd
[    0.703974] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.704033] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    0.704347] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    0.704755] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 20
[    0.704827] forcedeth 0000:00:08.0: PCI INT A -> Link[APCH] -> GSI 20 (level, low) -> IRQ 20
[    0.704922] forcedeth 0000:00:08.0: setting latency timer to 64
[    0.704948] nv_probe: set workaround bit for reversed mac addr
[    0.840877] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    0.844205] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.848159] ata1.00: ATA-8: ST3500320AS, SD1A, max UDMA/133
[    0.848217] ata1.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.861762] ata1.00: configured for UDMA/133
[    0.861923] scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD1A PQ: 0 ANSI: 5
[    0.875165] ata3.00: ATA-8: ST31000333AS, CC3H, max UDMA/133
[    0.875220] ata3.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    0.881104] ata7.00: ATAPI: HP DVD Writer 1040d, EH24, max UDMA/66
[    0.881185] ata7: nv_mode_filter: 0x1f39f&0x1f01f->0x1f01f, BIOS=0x1f000 (0xc5000000) ACPI=0x1f01f (30:600:0x13)
[    0.881188] ata7.00: limited to UDMA/33 due to 40-wire cable
[    0.911057] ata7.00: configured for UDMA/33
[    0.932151] ata3.00: configured for UDMA/133
[    1.014206] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.021139] ata2.00: ATA-7: Hitachi HDT725040VLA360, V5COA7EA, max UDMA/133
[    1.021197] ata2.00: 781422768 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.034905] ata2.00: configured for UDMA/133
[    1.035055] scsi 1:0:0:0: Direct-Access     ATA      Hitachi HDT72504 V5CO PQ: 0 ANSI: 5
[    1.035426] scsi 2:0:0:0: Direct-Access     ATA      ST31000333AS     CC3H PQ: 0 ANSI: 5
[    1.187125] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.194283] ata4.00: ATA-8: ST31000340AS, SD1A, max UDMA/133
[    1.194347] ata4.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32)
[    1.208459] ata4.00: configured for UDMA/133
[    1.208572] scsi 3:0:0:0: Direct-Access     ATA      ST31000340AS     SD1A PQ: 0 ANSI: 5
[    1.219164] ata6: SATA link down (SStatus 0 SControl 300)
[    1.220349] scsi 6:0:0:0: CD-ROM            HP       DVD Writer 1040d EH24 PQ: 0 ANSI: 5
[    1.220600] ata8: port disabled. ignoring.
[    1.223830] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1f:c6:62:fc:bb
[    1.223925] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[    1.224337] ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 23
[    1.224401] forcedeth 0000:00:09.0: PCI INT A -> Link[AMC1] -> GSI 23 (level, low) -> IRQ 23
[    1.224487] forcedeth 0000:00:09.0: setting latency timer to 64
[    1.224514] nv_probe: set workaround bit for reversed mac addr
[    1.743786] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x5043 @ 1, addr 00:1f:c6:63:07:97
[    1.743878] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[    1.744007] usbmon: debugfs is not available
[    1.744107] usbcore: registered new interface driver libusual
[    1.744321] PNP: No PS/2 controller found. Probing ports directly.
[    1.744782] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.744841] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.744947] mice: PS/2 mouse device common for all mice
[    1.745124] cpuidle: using governor ladder
[    1.746259] usbcore: registered new interface driver hiddev
[    1.746357] usbcore: registered new interface driver usbhid
[    1.746420] usbhid: v2.6:USB HID core driver
[    1.746874] TCP cubic registered
[    1.746936] Initializing XFRM netlink socket
[    1.747007] NET: Registered protocol family 17
[    1.747075] Using IPI Shortcut mode
[    1.747470] Freeing unused kernel memory: 416k freed
[    1.894606] end_request: I/O error, dev fd0, sector 0
[    2.153655] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.154104] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[    2.154170] ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 22 (level, low) -> IRQ 22
[    2.154274] ehci_hcd 0000:00:02.1: setting latency timer to 64
[    2.154277] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    2.154361] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    2.154472] ehci_hcd 0000:00:02.1: debug port 1
[    2.154536] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[    2.154543] ehci_hcd 0000:00:02.1: irq 22, io mem 0xfe02e000
[    2.163768] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    2.163851] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.163915] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.164007] usb usb1: Product: EHCI Host Controller
[    2.164070] usb usb1: Manufacturer: Linux 2.6.31 ehci_hcd
[    2.164133] usb usb1: SerialNumber: 0000:00:02.1
[    2.164273] usb usb1: configuration #1 chosen from 1 choice
[    2.164379] hub 1-0:1.0: USB hub found
[    2.164446] hub 1-0:1.0: 10 ports detected
[    2.166693] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.167127] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 21
[    2.167196] ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 21 (level, low) -> IRQ 21
[    2.167305] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    2.167308] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.167382] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    2.167492] ohci_hcd 0000:00:02.0: irq 21, io mem 0xfe02f000
[    2.222464] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    2.222522] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.222614] usb usb2: Product: OHCI Host Controller
[    2.222677] usb usb2: Manufacturer: Linux 2.6.31 ohci_hcd
[    2.222738] usb usb2: SerialNumber: 0000:00:02.0
[    2.222881] usb usb2: configuration #1 chosen from 1 choice
[    2.222988] hub 2-0:1.0: USB hub found
[    2.223054] hub 2-0:1.0: 10 ports detected
[    2.225239] uhci_hcd: USB Universal Host Controller Interface driver
[    2.247939] end_request: I/O error, dev fd0, sector 0
[    2.260505] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.260535] sd 1:0:0:0: [sdb] 781422768 512-byte logical blocks: (400 GB/372 GiB)
[    2.260569] sd 1:0:0:0: [sdb] Write Protect is off
[    2.260571] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.260587] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.260687]  sdb:
[    2.260809] sd 3:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.260820] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    2.260839] sd 3:0:0:0: [sdd] Write Protect is off
[    2.260842] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.260860] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.260869] sd 2:0:0:0: [sdc] Write Protect is off
[    2.260872] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.260888] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.260959]  sdd:
[    2.261049]  sdc:
[    2.261491] sd 0:0:0:0: [sda] Write Protect is off
[    2.261494] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.261511] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.261615]  sda: sdc1
[    2.263732] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.267712]  sdb1 sdb2
[    2.267998] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.268766]  sda1 sda2 sda3
[    2.268925]  sdd1 sdd2 <
[    2.269001] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.279423]  sdd5 sdd6 sdd7 sdd8 sdd9 sdd10 >
[    2.324658] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.683768] usb 1-10: new high speed USB device using ehci_hcd and address 4
[    2.807918] usb 1-10: New USB device found, idVendor=0409, idProduct=0059
[    2.807975] usb 1-10: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.808119] usb 1-10: configuration #1 chosen from 1 choice
[    2.808318] hub 1-10:1.0: USB hub found
[    2.808418] hub 1-10:1.0: 4 ports detected
[    3.047098] usb 2-4: new full speed USB device using ohci_hcd and address 2
[    3.206345] usb 2-4: New USB device found, idVendor=04b8, idProduct=0005
[    3.206402] usb 2-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    3.206458] usb 2-4: Product: USB Printer
[    3.206511] usb 2-4: Manufacturer: EPSON
[    3.206568] usb 2-4: SerialNumber: RL0200301161041200
[    3.206681] usb 2-4: configuration #1 chosen from 1 choice
[    3.447098] usb 2-5: new full speed USB device using ohci_hcd and address 3
[    3.591303] usb 2-5: New USB device found, idVendor=0451, idProduct=2046
[    3.591359] usb 2-5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.591463] usb 2-5: configuration #1 chosen from 1 choice
[    3.594331] hub 2-5:1.0: USB hub found
[    3.597303] hub 2-5:1.0: 4 ports detected
[    3.694568] usb 1-10.1: new low speed USB device using ehci_hcd and address 5
[    3.887939] end_request: I/O error, dev fd0, sector 0
[    3.903295] usb 1-10.1: New USB device found, idVendor=050d, idProduct=0751
[    3.903352] usb 1-10.1: New USB device strings: Mfr=4, Product=20, SerialNumber=0
[    3.903437] usb 1-10.1: Product: Belkin UPS
[    3.903490] usb 1-10.1: Manufacturer: Belkin 
[    3.903614] usb 1-10.1: configuration #1 chosen from 1 choice
[    4.137939] end_request: I/O error, dev fd0, sector 0
[    4.269661] kjournald starting.  Commit interval 5 seconds
[    4.269668] EXT3-fs: mounted filesystem with writeback data mode.
[    4.594415] generic-usb 0003:050D:0751.0001: hiddev0,hidraw0: USB HID v1.11 Device [Belkin  Belkin UPS] on usb-0000:00:02.1-10.1/input0
[    4.675467] usb 1-10.2: new full speed USB device using ehci_hcd and address 6
[    4.780197] usb 1-10.2: New USB device found, idVendor=0403, idProduct=6001
[    4.780254] usb 1-10.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.780339] usb 1-10.2: Product: USB FAST SERIAL ADAPTER
[    4.780393] usb 1-10.2: Manufacturer: FTDI
[    4.780448] usb 1-10.2: SerialNumber: FTOOS09N
[    4.780565] usb 1-10.2: configuration #1 chosen from 1 choice
[    4.865445] usb 1-10.3: new full speed USB device using ehci_hcd and address 7
[    4.962173] usb 1-10.3: New USB device found, idVendor=03eb, idProduct=3301
[    4.962232] usb 1-10.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    4.962317] usb 1-10.3: Product: Standard USB Hub
[    4.962426] usb 1-10.3: configuration #1 chosen from 1 choice
[    4.963058] hub 1-10.3:1.0: USB hub found
[    4.963295] hub 1-10.3:1.0: 4 ports detected
[    5.045419] usb 1-10.4: new high speed USB device using ehci_hcd and address 8
[    5.141653] usb 1-10.4: New USB device found, idVendor=0409, idProduct=0059
[    5.141710] usb 1-10.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.141849] usb 1-10.4: configuration #1 chosen from 1 choice
[    5.142049] hub 1-10.4:1.0: USB hub found
[    5.142150] hub 1-10.4:1.0: 4 ports detected
[    5.216119] usb 2-5.1: new full speed USB device using ohci_hcd and address 4
[    5.312112] usb 2-5.1: New USB device found, idVendor=0e5e, idProduct=6622
[    5.312171] usb 2-5.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.312313] usb 2-5.1: configuration #1 chosen from 1 choice
[    5.386102] usb 2-5.2: new full speed USB device using ohci_hcd and address 5
[    5.479089] usb 2-5.2: not running at top speed; connect to a high speed hub
[    5.494087] usb 2-5.2: New USB device found, idVendor=05e3, idProduct=070e
[    5.494143] usb 2-5.2: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[    5.494232] usb 2-5.2: Product: USB Storage
[    5.494286] usb 2-5.2: SerialNumber: 000000009317
[    5.494407] usb 2-5.2: configuration #1 chosen from 1 choice
[    5.569082] usb 2-5.4: new low speed USB device using ohci_hcd and address 6
[    5.673067] usb 2-5.4: New USB device found, idVendor=046d, idProduct=c517
[    5.673152] usb 2-5.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    5.673245] usb 2-5.4: Product: USB Receiver
[    5.673307] usb 2-5.4: Manufacturer: Logitech
[    5.673425] usb 2-5.4: configuration #1 chosen from 1 choice
[    5.683268] input: Logitech USB Receiver as /class/input/input0
[    5.683360] logitech 0003:046D:C517.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:02.0-5.4/input0
[    5.693064] logitech 0003:046D:C517.0003: fixing up Logitech keyboard report descriptor
[    5.693675] input: Logitech USB Receiver as /class/input/input1
[    5.693795] logitech 0003:046D:C517.0003: input,hiddev1,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:02.0-5.4/input1
[    5.762337] usb 1-10.3.4: new full speed USB device using ehci_hcd and address 9
[    5.858570] usb 1-10.3.4: not running at top speed; connect to a high speed hub
[    5.858822] usb 1-10.3.4: New USB device found, idVendor=0409, idProduct=005a
[    5.858824] usb 1-10.3.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    5.858889] usb 1-10.3.4: configuration #1 chosen from 1 choice
[    5.858968] hub 1-10.3.4:1.0: USB hub found
[    5.859070] hub 1-10.3.4:1.0: 4 ports detected
[    5.925568] Initializing USB Mass Storage driver...
[    5.925687] scsi8 : SCSI emulation for USB Mass Storage devices
[    5.925745] usb-storage: device found at 5
[    5.925747] usb-storage: waiting for device to settle before scanning
[    5.925765] usbcore: registered new interface driver usb-storage
[    5.925768] USB Mass Storage support registered.
[    5.942321] usb 1-10.4.4: new full speed USB device using ehci_hcd and address 10
[    6.039426] usb 1-10.4.4: New USB device found, idVendor=04b8, idProduct=010f
[    6.039430] usb 1-10.4.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    6.039433] usb 1-10.4.4: Product: EPSON Scanner 010F
[    6.039435] usb 1-10.4.4: Manufacturer: EPSON
[    6.039506] usb 1-10.4.4: configuration #1 chosen from 1 choice
[    6.138296] usb 1-10.3.4.2: new full speed USB device using ehci_hcd and address 11
[    6.240905] usb 1-10.3.4.2: New USB device found, idVendor=0403, idProduct=6001
[    6.240909] usb 1-10.3.4.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    6.240912] usb 1-10.3.4.2: Product: USB HS SERIAL CONVERTER
[    6.240914] usb 1-10.3.4.2: Manufacturer: FTDI
[    6.240915] usb 1-10.3.4.2: SerialNumber: FTDHG43V
[    6.240993] usb 1-10.3.4.2: configuration #1 chosen from 1 choice
[    6.396856] udevd version 127 started
[    6.632240] input: Power Button as /class/input/input2
[    6.632246] ACPI: Power Button [PWRF]
[    6.632297] input: Power Button as /class/input/input3
[    6.632300] ACPI: Power Button [PWRB]
[    6.742981] ATK0110 ATK0110:00: adding...
[    6.743010] ATK0110 ATK0110:00: board ID = M2N-SLI 
[    6.743014] ATK0110 ATK0110:00: Using old hwmon interface
[    6.743087] ATK0110 ATK0110:00: voltage: 0x6020000 Vcore Voltage [850-1600] enabled
[    6.743093] ATK0110 ATK0110:00: voltage: 0x6020001  +3.3 Voltage [3000-3600] enabled
[    6.743097] ATK0110 ATK0110:00: voltage: 0x6020002  +5.0 Voltage [4500-5500] enabled
[    6.743101] ATK0110 ATK0110:00: voltage: 0x6020003 +12.0 Voltage [11200-13200] enabled
[    6.743459] ATK0110 ATK0110:00: temperature: 0x6030000 CPU Temperature [900-1250] enabled
[    6.743464] ATK0110 ATK0110:00: temperature: 0x6030001 MB Temperature [450-900] enabled
[    6.743532] ATK0110 ATK0110:00: fan: 0x6040000 CPU FAN Speed [0-1800] enabled
[    6.743536] ATK0110 ATK0110:00: fan: 0x6040001 CHASSIS FAN Speed [0-1800] enabled
[    6.743540] ATK0110 ATK0110:00: fan: 0x6040002 POWER FAN Speed [0-1800] enabled
[    6.743545] ATK0110 ATK0110:00: fan: 0x6040021 CHASSIS4 FAN FAN Speed [0-1800] enabled
[    6.743549] ATK0110 ATK0110:00: fan: 0x6040022 CHASSIS2 FAN FAN Speed [0-1800] enabled
[    6.743554] ATK0110 ATK0110:00: fan: 0x6040023 CHASSIS3 FAN FAN Speed [0-1800] enabled
[    6.743557] ATK0110 ATK0110:00: registering hwmon device
[    6.743585] ATK0110 ATK0110:00: populating sysfs directory
[    6.749995] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x1c00
[    6.750031] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x1c40
[    6.799006] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    6.799011] Uniform CD-ROM driver Revision: 3.20
[    6.799080] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    6.801118] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.801142] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    6.801165] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.801188] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    6.801210] sr 6:0:0:0: Attached scsi generic sg4 type 5
[    6.806994] usblp2: USB Bidirectional printer dev 2 if 0 alt 0 proto 2 vid 0x04B8 pid 0x0005
[    6.807022] usbcore: registered new interface driver usblp
[    6.828032] input: PC Speaker as /class/input/input4
[    6.919895] rtc_cmos 00:05: RTC can wake from S4
[    6.919951] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    6.919987] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    6.970101] usbcore: registered new interface driver usbserial
[    6.970115] USB Serial support registered for generic
[    6.970158] usbcore: registered new interface driver usbserial_generic
[    6.970160] usbserial: USB Serial Driver core
[    7.055771] ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
[    7.055783] firewire_ohci 0000:01:0b.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
[    7.074339] Bluetooth: Core ver 2.15
[    7.074499] NET: Registered protocol family 31
[    7.074501] Bluetooth: HCI device and connection manager initialized
[    7.074505] Bluetooth: HCI socket layer initialized
[    7.095240] USB Serial support registered for FTDI USB Serial Device
[    7.095299] ftdi_sio 1-10.2:1.0: FTDI USB Serial Device converter detected
[    7.095321] usb 1-10.2: Detected FT232RL
[    7.095323] usb 1-10.2: Number of endpoints 2
[    7.095326] usb 1-10.2: Endpoint 1 MaxPacketSize 64
[    7.095328] usb 1-10.2: Endpoint 2 MaxPacketSize 64
[    7.095329] usb 1-10.2: Setting MaxPacketSize 64
[    7.095512] usb 1-10.2: FTDI USB Serial Device converter now attached to ttyUSB0
[    7.095592] ftdi_sio 1-10.3.4.2:1.0: FTDI USB Serial Device converter detected
[    7.095609] usb 1-10.3.4.2: Detected FT232BM
[    7.095611] usb 1-10.3.4.2: Number of endpoints 2
[    7.095613] usb 1-10.3.4.2: Endpoint 1 MaxPacketSize 64
[    7.095615] usb 1-10.3.4.2: Endpoint 2 MaxPacketSize 64
[    7.095617] usb 1-10.3.4.2: Setting MaxPacketSize 64
[    7.096211] usb 1-10.3.4.2: FTDI USB Serial Device converter now attached to ttyUSB1
[    7.096223] usbcore: registered new interface driver ftdi_sio
[    7.096225] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[    7.121268] firewire_ohci: Added fw-ohci device 0000:01:0b.0, OHCI version 1.10
[    7.133275] Bluetooth: Generic Bluetooth USB driver ver 0.5
[    7.133367] usbcore: registered new interface driver btusb
[    7.204725] Linux video capture interface: v2.00
[    7.621335] firewire_core: created device fw0: GUID 001e8c00012f990c, S400
[    7.717523] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.7 loaded
[    7.717928] cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected], frontend(s): 1
[    7.717931] cx88[0]: TV tuner type 60, Radio tuner type -1
[    7.732175] cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
[    7.803763] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 20
[    7.803769] HDA Intel 0000:00:06.1: PCI INT B -> Link[AAZA] -> GSI 20 (level, low) -> IRQ 20
[    7.803807] HDA Intel 0000:00:06.1: setting latency timer to 64
[    7.868382] tuner 2-0043: chip found @ 0x86 (cx88[0])
[    7.871179] tda9887 2-0043: creating new instance
[    7.871182] tda9887 2-0043: tda988[5/6/7] found
[    7.873950] tuner 2-0061: chip found @ 0xc2 (cx88[0])
[    7.921274] tuner-simple 2-0061: creating new instance
[    7.921277] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[    7.924680] input: cx88 IR (pcHDTV HD3000 HDTV) as /class/input/input5
[    7.924938] cx88[0]/2: cx2388x 8802 Driver Manager
[    7.925302] ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
[    7.925313] cx88-mpeg driver manager 0000:01:08.2: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[    7.925320] cx88[0]/2: found at 0000:01:08.2, rev: 5, irq: 18, latency: 32, mmio: 0xfa000000
[    7.925325] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    7.925731] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    7.925743] EMU10K1_Audigy 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    7.927986] Audigy2 value: Special config.
[    7.943084] cx8800 0000:01:08.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
[    7.943093] cx88[0]/0: found at 0000:01:08.0, rev: 5, irq: 18, latency: 32, mmio: 0xfb000000
[    7.943104] IRQ 18/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    7.943164] cx88[0]/0: registered device video0 [v4l2]
[    7.943185] cx88[0]/0: registered device vbi0
[    7.943206] cx88[0]/0: registered device radio0
[    7.977048] cx88/2: cx2388x dvb driver version 0.0.7 loaded
[    7.977052] cx88/2: registering cx8802 driver, type: dvb access: shared
[    7.977056] cx88[0]/2: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22]
[    7.977058] cx88[0]/2: cx2388x based DVB/ATSC card
[    7.977060] cx8802_alloc_frontends() allocating 1 frontend(s)
[    7.982264] tuner-simple 2-0061: attaching existing instance
[    7.982268] tuner-simple 2-0061: type set to 60 (Thomson DTT 761X (ATSC/NTSC))
[    7.983031] DVB: registering new adapter (cx88[0])
[    7.983035] DVB: registering adapter 0 frontend 0 (Oren OR51132 VSB/QAM Frontend)...
[    8.558414] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[    8.558426] HDA Intel 0000:03:00.1: PCI INT B -> Link[APC7] -> GSI 16 (level, low) -> IRQ 16
[    8.558476] HDA Intel 0000:03:00.1: setting latency timer to 64
[   10.654695] EXT3 FS on sda3, internal journal
[   10.782439] kjournald starting.  Commit interval 5 seconds
[   10.782774] EXT3 FS on sda1, internal journal
[   10.782779] EXT3-fs: mounted filesystem with writeback data mode.
[   10.795533] EXT4-fs (sdc1): barriers enabled
[   10.802773] kjournald2 starting: pid 1756, dev sdc1:8, commit interval 5 seconds
[   10.803191] EXT4-fs (sdc1): internal journal on sdc1:8
[   10.803195] EXT4-fs (sdc1): delayed allocation enabled
[   10.804645] EXT4-fs: mballoc enabled
[   10.804660] EXT4-fs (sdc1): mounted filesystem with ordered data mode
[   10.925511] usb-storage: device scan complete
[   10.932505] scsi 8:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9317 PQ: 0 ANSI: 0
[   10.939492] scsi 8:0:0:1: Direct-Access     Generic  STORAGE DEVICE   9317 PQ: 0 ANSI: 0
[   10.946490] scsi 8:0:0:2: Direct-Access     Generic  STORAGE DEVICE   9317 PQ: 0 ANSI: 0
[   10.953494] scsi 8:0:0:3: Direct-Access     Generic  STORAGE DEVICE   9317 PQ: 0 ANSI: 0
[   10.953902] sd 8:0:0:0: Attached scsi generic sg5 type 0
[   10.954000] sd 8:0:0:1: Attached scsi generic sg6 type 0
[   10.954098] sd 8:0:0:2: Attached scsi generic sg7 type 0
[   10.954202] sd 8:0:0:3: Attached scsi generic sg8 type 0
[   11.066474] sd 8:0:0:3: [sdh] Attached SCSI removable disk
[   11.088476] sd 8:0:0:0: [sde] Attached SCSI removable disk
[   11.121471] sd 8:0:0:1: [sdf] Attached SCSI removable disk
[   11.132462] sd 8:0:0:2: [sdg] Attached SCSI removable disk
[   11.652055] Adding 4192956k swap on /dev/sda2.  Priority:-1 extents:1 across:4192956k 

--Boundary-00=_qpstKwsU1BDawVf--
