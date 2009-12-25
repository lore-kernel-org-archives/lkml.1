Return-Path: <linux-kernel-owner+w=401wt.eu-S1756397AbZLYRo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbZLYRo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 12:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZLYRo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 12:44:57 -0500
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:48266
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232AbZLYRo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 12:44:56 -0500
X-Trace: 280227461/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.12.31/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.12.31
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: KMail/1.12.2 (Linux/2.6.33-rc1; KDE/4.3.1; x86_64; ; )
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FACaJNEtTQwwf/2dsb2JhbACBSoIgmFiqNYIBjD2DXVYEgWU
X-IronPort-AV: E=Sophos;i="4.47,454,1257120000"; 
   d="scan'208";a="280227461"
X-IP-Direction: IN
From: Tvrtko Ursulin <tvrtko@ursulin.net>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.33-rc1: 6 Processors exceeds NR_CPUS limit of 4
Date: Fri, 25 Dec 2009 17:44:43 +0000
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc1; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LoPNL2Cm9jSyLrP"
Message-Id: <200912251744.43987.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_LoPNL2Cm9jSyLrP
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit


Hi,

Just noticed this message in dmesg. What is this about? Machine is supposed to 
have a dual core CPU "unlocked" to four cores and it works like that without 
any visible problems so far:

processor       : 0                  
vendor_id       : AuthenticAMD       
cpu family      : 16                 
model           : 4                  
model name      : AMD Phenom(tm) II X4 B45 Processor
stepping        : 2                                 
cpu MHz         : 800.000                           
cache size      : 512 KB                            
physical id     : 0                                 
siblings        : 4                                 
core id         : 0                                 
cpu cores       : 4                                 
apicid          : 0                                 
initial apicid  : 0                                 
fpu             : yes                               
fpu_exception   : yes                               
cpuid level     : 5                                 
wp              : yes                               
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni 
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 
misalignsse 3dnowprefetch osvw ibs skinit wdt                                                           
bogomips        : 5999.90                                                                                                              
TLB size        : 1024 4K pages                                                                                                        
clflush size    : 64                                                                                                                   
cache_alignment : 64                                                                                                                   
address sizes   : 48 bits physical, 48 bits virtual                                                                                    
power management: ts ttp tm stc 100mhzsteps hwpstate                                                                                   

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 16          
model           : 4           
model name      : AMD Phenom(tm) II X4 B45 Processor
stepping        : 2                                 
cpu MHz         : 3000.000                          
cache size      : 512 KB                            
physical id     : 0                                 
siblings        : 4                                 
core id         : 1                                 
cpu cores       : 4                                 
apicid          : 1                                 
initial apicid  : 1                                 
fpu             : yes                               
fpu_exception   : yes                               
cpuid level     : 5                                 
wp              : yes                               
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni 
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 
misalignsse 3dnowprefetch osvw ibs skinit wdt                                                           
bogomips        : 6000.37                                                                                                              
TLB size        : 1024 4K pages                                                                                                        
clflush size    : 64                                                                                                                   
cache_alignment : 64                                                                                                                   
address sizes   : 48 bits physical, 48 bits virtual                                                                                    
power management: ts ttp tm stc 100mhzsteps hwpstate                                                                                   

processor       : 2
vendor_id       : AuthenticAMD
cpu family      : 16          
model           : 4           
model name      : AMD Phenom(tm) II X4 B45 Processor
stepping        : 2                                 
cpu MHz         : 800.000                           
cache size      : 512 KB                            
physical id     : 0                                 
siblings        : 4                                 
core id         : 2                                 
cpu cores       : 4                                 
apicid          : 2                                 
initial apicid  : 2                                 
fpu             : yes                               
fpu_exception   : yes                               
cpuid level     : 5                                 
wp              : yes                               
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni 
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 
misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6000.42
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

processor       : 3
vendor_id       : AuthenticAMD
cpu family      : 16
model           : 4
model name      : AMD Phenom(tm) II X4 B45 Processor
stepping        : 2
cpu MHz         : 800.000
cache size      : 512 KB
physical id     : 0
siblings        : 4
core id         : 3
cpu cores       : 4
apicid          : 3
initial apicid  : 3
fpu             : yes
fpu_exception   : yes
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb 
rdtscp lm 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni 
monitor cx16 popcnt lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a 
misalignsse 3dnowprefetch osvw ibs skinit wdt
bogomips        : 6000.37
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

--Boundary-00=_LoPNL2Cm9jSyLrP
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

[    0.000000] Linux version 2.6.33-rc1 (tvrtko@deuteros) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #3 SMP PREEMPT Tue Dec 22 09:30:16 GMT 2009
[    0.000000] Command line: acpi_enforce_resources=lax pci=check_enable_amd_mmconf root=/dev/disk/by-uuid/78df20fb-791f-4a82-b1d6-4e043aa663d1 resume=/dev/disk/by-uuid/4e4c1c1f-29c3-498a-bd06-13bf77060705 splash=silent quiet vga=0x31a radeon.modeset=0 fbcon=font:SUN8x16
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
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] No AGP bridge found
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
[    0.000000] kernel direct mapping tables up to dff90000 @ 16000-19000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 18000-1a000
[    0.000000] RAMDISK: 3798d000 - 37feffe8
[    0.000000] ACPI: RSDP 00000000000fb4f0 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000dff90100 00054 (v01 112609 XSDT1132 20091126 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000dff90290 000F4 (v03 112609 FACP1132 20091126 MSFT 00000097)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0000000000000000/1 (20091214/tbfadt-557)
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
[    0.000000]   NODE_DATA [0000000000019000 - 000000000001afff]
[    0.000000]   bootmap [000000000001b000 -  000000000003efff] pages 24
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 000177987c]    TEXT DATA BSS ==> [0001000000 - 000177987c]
[    0.000000]   #2 [003798d000 - 0037feffe8]          RAMDISK ==> [003798d000 - 0037feffe8]
[    0.000000]   #3 [000009ec00 - 0000100000]    BIOS reserved ==> [000009ec00 - 0000100000]
[    0.000000]   #4 [000177a000 - 000177a340]              BRK ==> [000177a000 - 000177a340]
[    0.000000]   #5 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #6 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #7 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
[    0.000000]   #8 [0000018000 - 0000019000]          PGTABLE ==> [0000018000 - 0000019000]
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
[    0.000000]   DMA zone: 107 pages reserved
[    0.000000]   DMA zone: 3819 pages, LIFO batch:0
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
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880028200000 s78552 r8192 d23848 u524288
[    0.000000] pcpu-alloc: s78552 r8192 d23848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1032115
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: acpi_enforce_resources=lax pci=check_enable_amd_mmconf root=/dev/disk/by-uuid/78df20fb-791f-4a82-b1d6-4e043aa663d1 resume=/dev/disk/by-uuid/4e4c1c1f-29c3-498a-bd06-13bf77060705 splash=silent quiet vga=0x31a radeon.modeset=0 fbcon=font:SUN8x16
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ ca2000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000024000000
[    0.000000] Memory: 3987660k/4718592k available (3542k kernel code, 525192k absent, 205740k reserved, 3069k data, 428k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Experimental preemptable hierarchical RCU implementation.
[    0.000000] NR_IRQS:384
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2999.955 MHz processor.
[    0.002003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5999.90 BogoMIPS (lpj=2999951)
[    0.002193] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.003312] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003777] Mount-cache hash table entries: 256
[    0.003861] tseg: 0000000000
[    0.003867] CPU: Physical Processor ID: 0
[    0.003868] CPU: Processor Core ID: 0
[    0.003870] mce: CPU supports 6 MCE banks
[    0.003875] using C1E aware idle routine
[    0.003876] Performance Events: AMD PMU driver.
[    0.003879] ... version:                0
[    0.003880] ... bit width:              48
[    0.003880] ... generic registers:      4
[    0.003881] ... value mask:             0000ffffffffffff
[    0.003882] ... max period:             00007fffffffffff
[    0.003883] ... fixed-purpose events:   0
[    0.003884] ... event mask:             000000000000000f
[    0.003893] ACPI: Core revision 20091214
[    0.017034] Setting APIC routing to flat
[    0.017341] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.027674] CPU0: AMD Phenom(tm) II X4 B45 Processor stepping 02
[    0.027999] System has AMD C1E enabled
[    0.027999] Switch to broadcast mode on CPU0
[    0.031012] Booting Node   0, Processors  #1
[    0.103013] Switch to broadcast mode on CPU1
[    0.105006]  #2
[    0.177017] Switch to broadcast mode on CPU2
[    0.179006]  #3 Ok.
[    0.251023] Brought up 4 CPUs
[    0.251025] Total of 4 processors activated (24001.07 BogoMIPS).
[    0.251022] Switch to broadcast mode on CPU3
[    0.256029] tmpfs: No value for mount option 'mode'
[    0.256033] devtmpfs: initialized
[    0.256151] Time:  9:50:47  Date: 12/25/09
[    0.256171] NET: Registered protocol family 16
[    0.256221] node 0 link 0: io port [1000, ffffff]
[    0.256223] TOM: 00000000e0000000 aka 3584M
[    0.256225] Fam 10h mmconf [e0000000, efffffff]
[    0.256226] node 0 link 0: mmio [a0000, bffff]
[    0.256228] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.256230] node 0 link 0: mmio [f0000000, fe7fffff]
[    0.256232] node 0 link 0: mmio [fe800000, fe9fffff]
[    0.256233] node 0 link 0: mmio [fea00000, ffefffff]
[    0.256234] TOM2: 0000000120000000 aka 4608M
[    0.256236] bus: [00, 07] on node 0 link 0
[    0.256237] bus: 00 index 0 io port: [0, ffff]
[    0.256238] bus: 00 index 1 mmio: [a0000, bffff]
[    0.256239] bus: 00 index 2 mmio: [f0000000, ffffffff]
[    0.256241] bus: 00 index 3 mmio: [120000000, fcffffffff]
[    0.256248] ACPI: bus type pci registered
[    0.256272] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.256273] PCI: AMD Family 10h NB with MMCONFIG support
[    0.256276] PCI: not using MMCONFIG
[    0.256277] PCI: Using configuration type 1 for base access
[    0.256278] PCI: Using configuration type 1 for extended access
[    0.256579] bio: create slab <bio-0> at 0
[    0.261406] ACPI: EC: Look up EC in DSDT
[    0.264756] ACPI: Executed 3 blocks of module-level executable AML code
[    0.279651] ACPI: Interpreter enabled
[    0.279654] ACPI: (supports S0 S1 S3 S4 S5)
[    0.279672] ACPI: Using IOAPIC for interrupt routing
[    0.286081] ACPI Warning: Incorrect checksum in table [OEMB] - 69, should be 64 (20091214/tbutils-314)
[    0.286201] ACPI: No dock devices found.
[    0.286333] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.286351] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    0.286596] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    0.286598] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    0.286599] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    0.286601] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff] (ignored)
[    0.286603] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff] (ignored)
[    0.286685] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    0.286687] pci 0000:00:07.0: PME# disabled
[    0.286715] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.286717] pci 0000:00:0a.0: PME# disabled
[    0.286753] pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
[    0.286759] pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
[    0.286764] pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
[    0.286770] pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
[    0.286775] pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
[    0.286781] pci 0000:00:11.0: reg 24: [mem 0xfe7ffc00-0xfe7fffff]
[    0.286826] pci 0000:00:12.0: reg 10: [mem 0xfe7fe000-0xfe7fefff]
[    0.286872] pci 0000:00:12.1: reg 10: [mem 0xfe7fd000-0xfe7fdfff]
[    0.286930] pci 0000:00:12.2: reg 10: [mem 0xfe7ff800-0xfe7ff8ff]
[    0.286976] pci 0000:00:12.2: supports D1 D2
[    0.286977] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.286980] pci 0000:00:12.2: PME# disabled
[    0.287018] pci 0000:00:13.0: reg 10: [mem 0xfe7fc000-0xfe7fcfff]
[    0.287064] pci 0000:00:13.1: reg 10: [mem 0xfe7fb000-0xfe7fbfff]
[    0.287121] pci 0000:00:13.2: reg 10: [mem 0xfe7ff400-0xfe7ff4ff]
[    0.287168] pci 0000:00:13.2: supports D1 D2
[    0.287169] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.287172] pci 0000:00:13.2: PME# disabled
[    0.287266] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.287272] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.287277] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.287283] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.287288] pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
[    0.287341] pci 0000:00:14.2: reg 10: [mem 0xfe7f4000-0xfe7f7fff 64bit]
[    0.287379] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.287383] pci 0000:00:14.2: PME# disabled
[    0.287471] pci 0000:00:14.5: reg 10: [mem 0xfe7fa000-0xfe7fafff]
[    0.287577] pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    0.287580] pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
[    0.287582] pci 0000:01:05.0: reg 18: [mem 0xfe9f0000-0xfe9fffff]
[    0.287587] pci 0000:01:05.0: reg 24: [mem 0xfe800000-0xfe8fffff]
[    0.287596] pci 0000:01:05.0: supports D1 D2
[    0.287608] pci 0000:01:05.1: reg 10: [mem 0xfe9e8000-0xfe9ebfff]
[    0.287623] pci 0000:01:05.1: supports D1 D2
[    0.287657] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.287659] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.287661] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.287664] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.287694] pci 0000:02:00.0: reg 10: [mem 0xfeaff800-0xfeafffff]
[    0.287702] pci 0000:02:00.0: reg 14: [mem 0xfeaff400-0xfeaff47f]
[    0.287722] pci 0000:02:00.0: reg 20: [mem 0xfeaff000-0xfeaff07f]
[    0.287730] pci 0000:02:00.0: reg 24: [mem 0xfeafec00-0xfeafec7f]
[    0.289044] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.289047] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.289071] pci 0000:03:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.289084] pci 0000:03:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.289093] pci 0000:03:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.289099] pci 0000:03:00.0: reg 30: [mem 0xfebf0000-0xfebfffff pref]
[    0.289125] pci 0000:03:00.0: supports D1 D2
[    0.289126] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.289129] pci 0000:03:00.0: PME# disabled
[    0.291042] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.291044] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    0.291046] pci 0000:00:0a.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.291049] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.291102] pci 0000:00:14.4: PCI bridge to [bus 04-04] (subtractive decode)
[    0.291121] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.291271] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.291330] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[    0.291377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.291436] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.296156] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 12 14 15)
[    0.296253] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 *10 11 12 14 15)
[    0.296348] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 *11 12 14 15)
[    0.296442] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)
[    0.296536] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.296630] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.296725] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 12 14 15)
[    0.296818] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
[    0.296882] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.296884] vgaarb: loaded
[    0.296928] SCSI subsystem initialized
[    0.300009] libata version 3.00 loaded.
[    0.300043] usbcore: registered new interface driver usbfs
[    0.300053] usbcore: registered new interface driver hub
[    0.300065] usbcore: registered new device driver usb
[    0.300094] PCI: Using ACPI for IRQ routing
[    0.300096] PCI: pci_cache_line_size set to 64 bytes
[    0.300200] HPET: 4 timers in total, 1 timers will be used for per-cpu timer
[    0.300206] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0
[    0.300209] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.303014] hpet: hpet2 irq 24 for MSI
[    0.306005] Switching to clocksource tsc
[    0.311049] pnp: PnP ACPI init
[    0.311053] ACPI: bus type pnp registered
[    0.315164] pnp: PnP ACPI: found 14 devices
[    0.315166] ACPI: ACPI bus type pnp unregistered
[    0.315174] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.315176] system 00:09: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.315179] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    0.315181] system 00:0a: [io  0x040b] has been reserved
[    0.315182] system 00:0a: [io  0x04d6] has been reserved
[    0.315184] system 00:0a: [io  0x0c00-0x0c01] has been reserved
[    0.315185] system 00:0a: [io  0x0c14] has been reserved
[    0.315187] system 00:0a: [io  0x0c50-0x0c51] has been reserved
[    0.315188] system 00:0a: [io  0x0c52] has been reserved
[    0.315190] system 00:0a: [io  0x0c6c] has been reserved
[    0.315191] system 00:0a: [io  0x0c6f] has been reserved
[    0.315193] system 00:0a: [io  0x0cd0-0x0cd1] has been reserved
[    0.315195] system 00:0a: [io  0x0cd2-0x0cd3] has been reserved
[    0.315196] system 00:0a: [io  0x0cd4-0x0cd5] has been reserved
[    0.315198] system 00:0a: [io  0x0cd6-0x0cd7] has been reserved
[    0.315199] system 00:0a: [io  0x0cd8-0x0cdf] has been reserved
[    0.315201] system 00:0a: [io  0x0b00-0x0b3f] has been reserved
[    0.315202] system 00:0a: [io  0x0800-0x089f] has been reserved
[    0.315204] system 00:0a: [io  0x0b00-0x0b0f] has been reserved
[    0.315206] system 00:0a: [io  0x0b20-0x0b3f] has been reserved
[    0.315208] system 00:0a: [io  0x0900-0x090f] has been reserved
[    0.315209] system 00:0a: [io  0x0910-0x091f] has been reserved
[    0.315211] system 00:0a: [io  0xfe00-0xfefe] has been reserved
[    0.315213] system 00:0a: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.315215] system 00:0a: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.315217] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.315219] system 00:0b: [io  0x0230-0x023f] has been reserved
[    0.315221] system 00:0b: [io  0x0290-0x029f] has been reserved
[    0.315223] system 00:0b: [io  0x0300-0x030f] has been reserved
[    0.315224] system 00:0b: [io  0x0a30-0x0a3f] has been reserved
[    0.315227] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
[    0.315231] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.315233] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.315235] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
[    0.315236] system 00:0d: [mem 0x00100000-0xdfffffff] could not be reserved
[    0.315238] system 00:0d: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.323543] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.323545] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.323548] pci 0000:00:01.0:   bridge window [mem 0xfe800000-0xfe9fffff]
[    0.323550] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.323553] pci 0000:00:07.0: PCI bridge to [bus 02-02]
[    0.323554] pci 0000:00:07.0:   bridge window [io  disabled]
[    0.323556] pci 0000:00:07.0:   bridge window [mem 0xfea00000-0xfeafffff]
[    0.323558] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    0.323561] pci 0000:00:0a.0: PCI bridge to [bus 03-03]
[    0.323562] pci 0000:00:0a.0:   bridge window [io  0xe000-0xefff]
[    0.323565] pci 0000:00:0a.0:   bridge window [mem 0xfeb00000-0xfebfffff]
[    0.323567] pci 0000:00:0a.0:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.323569] pci 0000:00:14.4: PCI bridge to [bus 04-04]
[    0.323570] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.323575] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.323578] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.323591] pci 0000:00:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.323593] pci 0000:00:07.0: setting latency timer to 64
[    0.323597] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.323599] pci 0000:00:0a.0: setting latency timer to 64
[    0.323605] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.323606] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.323608] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.323609] pci_bus 0000:01: resource 1 [mem 0xfe800000-0xfe9fffff]
[    0.323611] pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    0.323613] pci_bus 0000:02: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.323614] pci_bus 0000:03: resource 0 [io  0xe000-0xefff]
[    0.323616] pci_bus 0000:03: resource 1 [mem 0xfeb00000-0xfebfffff]
[    0.323617] pci_bus 0000:03: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.323619] pci_bus 0000:04: resource 3 [io  0x0000-0xffff]
[    0.323620] pci_bus 0000:04: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.323635] NET: Registered protocol family 2
[    0.323717] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.324323] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.326206] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.326464] TCP: Hash tables configured (established 524288 bind 65536)
[    0.326465] TCP reno registered
[    0.326471] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.326496] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.326564] NET: Registered protocol family 1
[    0.442017] pci 0000:01:05.0: Boot video device
[    0.442024] PCI: CLS 64 bytes, default 64
[    0.442057] Unpacking initramfs...
[    0.532378] Freeing initrd memory: 6539k freed
[    0.533831] PCI-DMA: Disabling AGP.
[    0.533897] PCI-DMA: aperture base @ 20000000 size 65536 KB
[    0.533898] PCI-DMA: using GART IOMMU.
[    0.533900] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.536919] Scanning for low memory corruption every 60 seconds
[    0.537178] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.542063] VFS: Disk quotas dquot_6.5.2
[    0.542090] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.542250] msgmni has been set to 7929
[    0.542308] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.542310] io scheduler noop registered
[    0.542311] io scheduler deadline registered
[    0.542342] io scheduler cfq registered (default)
[    0.544013] pcieport 0000:00:07.0: setting latency timer to 64
[    0.544033] pcieport 0000:00:07.0: irq 25 for MSI/MSI-X
[    0.545024] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.545041] pcieport 0000:00:0a.0: irq 26 for MSI/MSI-X
[    0.545195] vesafb: framebuffer at 0xf0000000, mapped to 0xffffc90001100000, using 5120k, total 16384k
[    0.545196] vesafb: mode is 1280x1024x16, linelength=2560, pages=5
[    0.545198] vesafb: scrolling: redraw
[    0.545199] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.552078] Console: switching to colour frame buffer device 160x64
[    0.558482] fb0: VESA VGA frame buffer device
[    0.559223] Non-volatile memory driver v1.3
[    0.559227] Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
[    0.559322] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.559520] 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.559634] ahci 0000:00:11.0: version 3.0
[    0.559649] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.559763] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    0.559765] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    0.560009] scsi0 : ahci
[    0.560056] scsi1 : ahci
[    0.560081] scsi2 : ahci
[    0.560104] scsi3 : ahci
[    0.560128] scsi4 : ahci
[    0.560151] scsi5 : ahci
[    0.560173] ata1: SATA max UDMA/133 irq_stat 0x00000040,  irq 22
[    0.560175] ata2: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffd80 irq 22
[    0.560178] ata3: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe00 irq 22
[    0.560180] ata4: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7ffe80 irq 22
[    0.560182] ata5: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff00 irq 22
[    0.560185] ata6: SATA max UDMA/133 abar m1024@0xfe7ffc00 port 0xfe7fff80 irq 22
[    0.560219] Fixed MDIO Bus: probed
[    0.560223] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.560261] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.560271] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.560289] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.560315] ehci_hcd 0000:00:12.2: debug port 1
[    0.560332] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe7ff800
[    0.566020] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.566034] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.566035] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.566037] usb usb1: Product: EHCI Host Controller
[    0.566038] usb usb1: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    0.566039] usb usb1: SerialNumber: 0000:00:12.2
[    0.566096] hub 1-0:1.0: USB hub found
[    0.566099] hub 1-0:1.0: 6 ports detected
[    0.566153] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.566163] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.566167] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    0.566189] ehci_hcd 0000:00:13.2: debug port 1
[    0.566203] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe7ff400
[    0.572016] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.572023] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.572025] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.572026] usb usb2: Product: EHCI Host Controller
[    0.572027] usb usb2: Manufacturer: Linux 2.6.33-rc1 ehci_hcd
[    0.572028] usb usb2: SerialNumber: 0000:00:13.2
[    0.572067] hub 2-0:1.0: USB hub found
[    0.572069] hub 2-0:1.0: 6 ports detected
[    0.572108] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.572127] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.572135] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.572140] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    0.572158] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe7fe000
[    0.627042] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.627043] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.627044] usb usb3: Product: OHCI Host Controller
[    0.627045] usb usb3: Manufacturer: Linux 2.6.33-rc1 ohci_hcd
[    0.627046] usb usb3: SerialNumber: 0000:00:12.0
[    0.627084] hub 3-0:1.0: USB hub found
[    0.627089] hub 3-0:1.0: 3 ports detected
[    0.627144] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.627151] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    0.627155] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    0.627167] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe7fd000
[    0.682043] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.682044] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.682045] usb usb4: Product: OHCI Host Controller
[    0.682047] usb usb4: Manufacturer: Linux 2.6.33-rc1 ohci_hcd
[    0.682048] usb usb4: SerialNumber: 0000:00:12.1
[    0.682086] hub 4-0:1.0: USB hub found
[    0.682091] hub 4-0:1.0: 3 ports detected
[    0.682147] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.682154] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.682159] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    0.682175] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe7fc000
[    0.737048] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.737049] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.737050] usb usb5: Product: OHCI Host Controller
[    0.737052] usb usb5: Manufacturer: Linux 2.6.33-rc1 ohci_hcd
[    0.737053] usb usb5: SerialNumber: 0000:00:13.0
[    0.737094] hub 5-0:1.0: USB hub found
[    0.737098] hub 5-0:1.0: 3 ports detected
[    0.737153] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.737161] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    0.737166] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    0.737178] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe7fb000
[    0.792049] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.792050] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.792051] usb usb6: Product: OHCI Host Controller
[    0.792053] usb usb6: Manufacturer: Linux 2.6.33-rc1 ohci_hcd
[    0.792054] usb usb6: SerialNumber: 0000:00:13.1
[    0.792096] hub 6-0:1.0: USB hub found
[    0.792101] hub 6-0:1.0: 3 ports detected
[    0.792156] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.792166] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.792170] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    0.792182] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe7fa000
[    0.847050] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.847052] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.847053] usb usb7: Product: OHCI Host Controller
[    0.847054] usb usb7: Manufacturer: Linux 2.6.33-rc1 ohci_hcd
[    0.847055] usb usb7: SerialNumber: 0000:00:14.5
[    0.847093] hub 7-0:1.0: USB hub found
[    0.847097] hub 7-0:1.0: 2 ports detected
[    0.847141] Initializing USB Mass Storage driver...
[    0.847168] usbcore: registered new interface driver usb-storage
[    0.847169] USB Mass Storage support registered.
[    0.847187] usbcore: registered new interface driver libusual
[    0.847193] usbcore: registered new interface driver ums-alauda
[    0.847198] usbcore: registered new interface driver ums-cypress
[    0.847204] usbcore: registered new interface driver ums-datafab
[    0.847209] usbcore: registered new interface driver ums-freecom
[    0.847215] usbcore: registered new interface driver ums-isd200
[    0.847222] usbcore: registered new interface driver ums-jumpshot
[    0.847228] usbcore: registered new interface driver ums-karma
[    0.847233] usbcore: registered new interface driver ums-onetouch
[    0.847239] usbcore: registered new interface driver ums-sddr09
[    0.847245] usbcore: registered new interface driver ums-sddr55
[    0.847250] usbcore: registered new interface driver ums-usbat
[    0.847270] PNP: No PS/2 controller found. Probing ports directly.
[    0.847599] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.847602] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.847635] mice: PS/2 mouse device common for all mice
[    0.847643] Driver 'rtc_cmos' needs updating - please use bus_type methods
[    0.847658] rtc_cmos 00:03: RTC can wake from S4
[    0.847678] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    0.847699] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.847705] cpuidle: using governor ladder
[    0.847707] cpuidle: using governor menu
[    0.847849] usbcore: registered new interface driver hiddev
[    0.847857] usbcore: registered new interface driver usbhid
[    0.847858] usbhid: USB HID core driver
[    0.847980] TCP cubic registered
[    0.848041] NET: Registered protocol family 10
[    0.848246] lo: Disabled Privacy Extensions
[    0.848392] PM: Checking image partition /dev/disk/by-uuid/4e4c1c1f-29c3-498a-bd06-13bf77060705
[    0.865050] ata4: SATA link down (SStatus 0 SControl 300)
[    0.865111] ata6: SATA link down (SStatus 0 SControl 300)
[    0.865134] ata5: SATA link down (SStatus 0 SControl 300)
[    1.005045] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    1.018061] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.018081] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.018926] ata3.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.018929] ata3.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.019793] ata2.00: ATA-8: WDC WD1600BEKT-00F3T0, 11.01A11, max UDMA/133
[    1.019795] ata2.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.020287] ata3.00: configured for UDMA/133
[    1.020688] ata2.00: configured for UDMA/133
[    1.138320] usb 4-2: New USB device found, idVendor=046a, idProduct=0021
[    1.138322] usb 4-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.147447] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input0
[    1.147477] generic-usb 0003:046A:0021.0001: input,hidraw0: USB HID v1.11 Keyboard [HID 046a:0021] on usb-0000:00:12.1-2/input0
[    1.157368] input: HID 046a:0021 as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input1
[    1.157396] generic-usb 0003:046A:0021.0002: input,hidraw1: USB HID v1.11 Device [HID 046a:0021] on usb-0000:00:12.1-2/input1
[    1.372261] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.372937] ata1.00: CFA: LEXAR ATA FLASH CARD, 20081002, max UDMA/66
[    1.372939] ata1.00: 3915072 sectors, multi 0: LBA 
[    1.372945] ata1.00: applying bridge limits
[    1.374238] ata1.00: configured for UDMA/66
[    1.384247] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    1.385293] scsi 0:0:0:0: Direct-Access     ATA      LEXAR ATA FLASH  2008 PQ: 0 ANSI: 5
[    1.385393] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.385482] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600BEKT-0 11.0 PQ: 0 ANSI: 5
[    1.385558] sd 2:0:0:0: [sdc] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.385566] sd 1:0:0:0: [sdb] 312581808 512-byte logical blocks: (160 GB/149 GiB)
[    1.385606] sd 1:0:0:0: [sdb] Write Protect is off
[    1.385607] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.385613] sd 2:0:0:0: [sdc] Write Protect is off
[    1.385614] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.385628] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.385652] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.385675] sd 0:0:0:0: [sda] 3915072 512-byte logical blocks: (2.00 GB/1.86 GiB)
[    1.385741] sd 0:0:0:0: [sda] Write Protect is off
[    1.385742] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.385769]  sdc:
[    1.385791] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    1.385812]  sdb:
[    1.385867]  sda: sda1 sda2
[    1.386347] sd 0:0:0:0: [sda] Attached SCSI removable disk
[    1.445986]  sdb1 sdb2
[    1.446119] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.449326]  sdc1 sdc2
[    1.449429] sd 2:0:0:0: [sdc] Attached SCSI disk
[    1.449434] PM: Resume from disk failed.
[    1.449439] registered taskstats version 1
[    1.449616]   Magic number: 5:656:829
[    1.449665] rtc_cmos 00:03: setting system clock to 2009-12-25 09:50:48 UTC (1261734648)
[    1.449692] Freeing unused kernel memory: 428k freed
[    1.449765] Write protecting the kernel read-only data: 6144k
[    1.449827] Freeing unused kernel memory: 536k freed
[    1.449945] Freeing unused kernel memory: 500k freed
[    1.470316] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.470336] pata_atiixp 0000:00:14.1: setting latency timer to 64
[    1.470379] scsi6 : pata_atiixp
[    1.470413] scsi7 : pata_atiixp
[    1.471446] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[    1.471448] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[    1.537350] usb 4-3: New USB device found, idVendor=046d, idProduct=c521
[    1.537353] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.537354] usb 4-3: Product: USB Receiver
[    1.537356] usb 4-3: Manufacturer: Logitech
[    1.548460] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input2
[    1.548497] generic-usb 0003:046D:C521.0003: input,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    1.560394] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input3
[    1.560440] generic-usb 0003:046D:C521.0004: input,hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
[    1.625681] ata7.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB04, max UDMA/33
[    1.631629] ata7.00: configured for UDMA/33
[    1.633746] scsi 6:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB04 PQ: 0 ANSI: 5
[    1.799270] [drm] Initialized drm 1.1.0 20060810
[    1.809345] udev: starting version 146
[    2.296175] PM: Marking nosave pages: 000000000009e000 - 0000000000100000
[    2.296179] PM: Marking nosave pages: 00000000dff90000 - 0000000100000000
[    2.296517] PM: Marking nosave pages: 0000000020000000 - 0000000024000000
[    2.296704] PM: Basic memory bitmaps created
[    2.308322] PM: Basic memory bitmaps freed
[    2.314395] PM: Starting manual resume from disk
[    2.314397] PM: Resume from partition 8:17
[    2.314398] PM: Checking hibernation image.
[    2.314784] PM: Error -22 checking image file
[    2.314785] PM: Resume from disk failed.
[    2.551721] EXT4-fs (sda2): mounted filesystem with ordered data mode
[    4.041008] udev: starting version 146
[    4.079529] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    4.079546] r8169 0000:03:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    4.079592] r8169 0000:03:00.0: setting latency timer to 64
[    4.079628] r8169 0000:03:00.0: irq 27 for MSI/MSI-X
[    4.079952] eth0: RTL8168d/8111d at 0xffffc9000172c000, 90:e6:ba:10:55:5d, XID 083000c0 IRQ 27
[    4.087352] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    4.087385] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    4.087400] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    4.087417] scsi 6:0:0:0: Attached scsi generic sg3 type 5
[    4.117059] firewire_ohci 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    4.117065] firewire_ohci 0000:02:00.0: setting latency timer to 64
[    4.130029] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    4.130032] Uniform CD-ROM driver Revision: 3.20
[    4.130090] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    4.142840] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[    4.142869] ACPI: Power Button [PWRB]
[    4.142897] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    4.142912] ACPI: Power Button [PWRF]
[    4.143165] input: PC Speaker as /devices/platform/pcspkr/input/input6
[    4.144018] ACPI: I/O resource piix4_smbus [0xb00-0xb07] conflicts with ACPI region SOR1 [0xb00-0xb0f]
[    4.144020] ACPI: This conflict may cause random problems and system instability
[    4.144021] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    4.144027] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[    4.177014] firewire_ohci: Added fw-ohci device 0000:02:00.0, OHCI version 1.10
[    4.225562] kvm: Nested Virtualization enabled
[    4.225564] kvm: Nested Paging enabled
[    4.240235] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.280488] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    4.280514] HDA Intel 0000:01:05.1: irq 28 for MSI/MSI-X
[    4.280526] HDA Intel 0000:01:05.1: setting latency timer to 64
[    4.676074] firewire_core: created device fw0: GUID 001e8c0000a82627, S400
[    5.285006] hda-intel: azx_get_response timeout, switching to polling mode: last cmd=0x000f0000
[    5.378750] Adding 2097144k swap on /dev/sdb1.  Priority:-1 extents:1 across:2097144k 
[    5.380070] Adding 2097144k swap on /dev/sdc1.  Priority:-2 extents:1 across:2097144k 
[    5.705413] device-mapper: uevent: version 1.0.3
[    5.705498] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    5.707929] md: md0 stopped.
[    5.708514] md: bind<sdb2>
[    5.708612] md: bind<sdc2>
[    5.720968] md: raid0 personality registered for level 0
[    5.721098] raid0: looking at sdc2
[    5.721100] raid0:   comparing sdc2(308387392)
[    5.721102]  with sdc2(308387392)
[    5.721103] raid0:   END
[    5.721103] raid0:   ==> UNIQUE
[    5.721104] raid0: 1 zones
[    5.721105] raid0: looking at sdb2
[    5.721106] raid0:   comparing sdb2(308387392)
[    5.721107]  with sdc2(308387392)
[    5.721108] raid0:   EQUAL
[    5.721109] raid0: FINAL 1 zones
[    5.721111] raid0: done.
[    5.721112] raid0 : md_size is 616774784 sectors.
[    5.721113] ******* md0 configuration *********
[    5.721114] zone0=[sdc2/sdb2/]
[    5.721116]         zone offset=0kb device offset=0kb size=308387392kb
[    5.721117] **********************************
[    5.721117] 
[    5.721123] md0: detected capacity change from 0 to 315788689408
[    5.721895]  md0: unknown partition table
[    6.304851] loop: module loaded
[    6.359363] EXT4-fs (dm-3): mounted filesystem with ordered data mode
[    6.371853] EXT4-fs (dm-1): mounted filesystem with ordered data mode
[    6.391693] EXT4-fs (dm-2): mounted filesystem with ordered data mode
[    6.403864] EXT4-fs (dm-0): mounted filesystem with ordered data mode
[    6.508795] fuse init (API version 7.13)
[    7.996627] powernow-k8: Found 1 AMD Phenom(tm) II X4 B45 Processor processors (4 cpu cores) (version 2.20.00)
[    7.996663] powernow-k8:    0 : pstate 0 (3000 MHz)
[    7.996664] powernow-k8:    1 : pstate 1 (2300 MHz)
[    7.996666] powernow-k8:    2 : pstate 2 (1800 MHz)
[    7.996667] powernow-k8:    3 : pstate 3 (800 MHz)
[    8.841894] r8169: eth0: link up
[    8.841908] r8169: eth0: link up
[    9.317368] Slow work thread pool: Starting up
[    9.327200] Slow work thread pool: Ready
[    9.776319] pci 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    9.861810] pci 0000:01:05.0: setting latency timer to 64
[    9.861909] [drm] Initialized radeon 1.31.0 20080528 for 0000:01:05.0 on minor 0
[   10.064010] [drm] Setting GART location based on new memory map
[   10.064423] [drm] Loading RS780 CP Microcode
[   10.064431] platform r600_cp.0: firmware: requesting radeon/RS780_pfp.bin
[   10.084188] platform r600_cp.0: firmware: requesting radeon/RS780_me.bin
[   10.127955] [drm] Resetting GPU
[   10.128016] [drm] writeback test succeeded in 1 usecs
[   12.297991] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[   12.950318] it87: Found IT8712F chip at 0x290, revision 8
[   12.950337] it87: in3 is VCC (+5V)
[   12.950341] it87: in7 is VCCH (+5V Stand-By)
[   12.950383] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region SIOE [0x290-0x2af]
[   12.950388] ACPI: This conflict may cause random problems and system instability
[   12.950392] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.320374] eth0: no IPv6 routers present

--Boundary-00=_LoPNL2Cm9jSyLrP--
