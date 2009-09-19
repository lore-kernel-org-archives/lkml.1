Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZISULW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZISULW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 16:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZISULV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 16:11:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:55619 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZISULS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 16:11:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=oH0Nt6GDVRSLfhws2DQhvLlZ4PkStfogdzDiSkcv/Kpu67+qNlqUI1pUIYlN/8okUG
         FKlsMeGrJKqNs4sYL/dHLY8yeYGgOTiVKazUMbzLcuHUDgN526bDUoFWQo89H02W4h4H
         jxxk+A4sGTgxWaSgnpAmTMzqP0t3S6jxSOF7c=
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: amd64 + mtrr: only 3.1gb of 8gb are covered, kernel 2.6.30 and earlier.
Date: Sat, 19 Sep 2009 22:11:12 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31r4; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200908211814.56800.volkerarmin@googlemail.com> <200908270313.32528.volkerarmin@googlemail.com> <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
In-Reply-To: <86802c440908270013k4b8c75b1h6bac33a623ded5e7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909192211.12226.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just want to say:

no change with 2.6.31.


[    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gentoo 
4.4.1 p1.0) ) #9 SMP Wed Sep 16 15:10:44 CEST 2009
[    0.000000] Command line: root=/dev/md1 md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 
nmi_watchdog=0 mtrr_spare_reg_nr=1                 
[    0.000000] KERNEL supported cpus:                                                                                            
[    0.000000]   AMD AuthenticAMD                                                                                                
[    0.000000] BIOS-provided physical RAM map:                                                                                   
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)                                                          
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)                                                        
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)                                                        
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7eb0000 (usable)                                                          
[    0.000000]  BIOS-e820: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)                                                       
[    0.000000]  BIOS-e820: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)                                                        
[    0.000000]  BIOS-e820: 00000000c7ef0000 - 00000000c7f00000 (reserved)                                                        
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)                                                        
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)                                                          
[    0.000000] DMI present.                                                                                                      
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.                                                   
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) 
==> (reserved)                                    
[    0.000000] last_pfn = 0x238000 max_arch_pfn = 0x400000000                                                                    
[    0.000000] MTRR default type: uncachable                                                                                     
[    0.000000] MTRR fixed ranges enabled:                                                                                        
[    0.000000]   00000-9FFFF write-back                                                                                          
[    0.000000]   A0000-EFFFF uncachable                                                                                          
[    0.000000]   F0000-FFFFF write-protect                                                                                       
[    0.000000] MTRR variable ranges enabled:                                                                                     
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back                                                                
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back                                                                
[    0.000000]   2 base 0000C0000000 mask FFFFF8000000 write-back                                                                
[    0.000000]   3 disabled                                                                                                      
[    0.000000]   4 disabled                                                                                                      
[    0.000000]   5 disabled                                                                                                      
[    0.000000]   6 disabled                                                                                                      
[    0.000000]   7 disabled                                                                                                      
[    0.000000] TOM2: 0000000238000000 aka 9088M                                                                                  
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 
0x7010600070106                                                  
[    0.000000] e820 update range: 00000000c8000000 - 0000000100000000 (usable) 
==> (reserved)                                    
[    0.000000] last_pfn = 0xc7eb0 max_arch_pfn = 0x400000000                                                                     
[    0.000000] Scanning 0 areas for low memory corruption                                                                        
[    0.000000] modified physical RAM map:                                                                                        
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)                                                         
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)                                                           
[    0.000000]  modified: 000000000009fc00 - 00000000000a0000 (reserved)                                                         
[    0.000000]  modified: 00000000000e6000 - 0000000000100000 (reserved)                                                         
[    0.000000]  modified: 0000000000100000 - 00000000c7eb0000 (usable)                                                           
[    0.000000]  modified: 00000000c7eb0000 - 00000000c7ec0000 (ACPI data)                                                        
[    0.000000]  modified: 00000000c7ec0000 - 00000000c7ef0000 (ACPI NVS)                                                         
[    0.000000]  modified: 00000000c7ef0000 - 00000000c7f00000 (reserved)                                                         
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)                                                         
[    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)                                                           
[    0.000000] initial memory mapped : 0 - 20000000                                                                              
[    0.000000] Using GB pages for direct mapping                                                                                 
[    0.000000] init_memory_mapping: 0000000000000000-00000000c7eb0000                                                            
[    0.000000]  0000000000 - 00c0000000 page 1G                                                                                  
[    0.000000]  00c0000000 - 00c7e00000 page 2M                                                                                  
[    0.000000]  00c7e00000 - 00c7eb0000 page 4k                                                                                  
[    0.000000] kernel direct mapping tables up to c7eb0000 @ 10000-13000                                                         
[    0.000000] init_memory_mapping: 0000000100000000-0000000238000000                                                            
[    0.000000]  0100000000 - 0200000000 page 1G                                                                                  
[    0.000000]  0200000000 - 0238000000 page 2M                                                                                  
[    0.000000] kernel direct mapping tables up to 238000000 @ 12000-14000                                                        
[    0.000000] ACPI: RSDP 00000000000fa7c0 00014 (v00 ACPIAM)                                                                    
[    0.000000] ACPI: RSDT 00000000c7eb0000 00040 (v01 050609 RSDT2000 20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: FACP 00000000c7eb0200 00084 (v02 A M I  OEMFACP  12000601 
MSFT 00000097)                                    
[    0.000000] ACPI: DSDT 00000000c7eb0440 08512 (v01  AS140 AS140121 00000121 
INTL 20051117)                                    
[    0.000000] ACPI: FACS 00000000c7ec0000 00040                                                                                 
[    0.000000] ACPI: APIC 00000000c7eb0390 0006C (v01 050609 APIC2000 20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: MCFG 00000000c7eb0400 0003C (v01 050609 OEMMCFG  20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: OEMB 00000000c7ec0040 00071 (v01 050609 OEMB2000 20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: AAFT 00000000c7eb8960 00027 (v01 050609 OEMAAFT  20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: HPET 00000000c7eb8990 00038 (v01 050609 OEMHPET  20090506 
MSFT 00000097)                                    
[    0.000000] ACPI: SSDT 00000000c7eb89d0 0088C (v01 A M I  POWERNOW 00000001 
AMD  00000001)                                    
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                               
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0238000000]                                                      
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]                                     
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]                                     
[    0.000000]   #2 [0001000000 - 00015f68c0]    TEXT DATA BSS ==> [0001000000 
- 00015f68c0]                                     
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 
- 0000100000]                                     
[    0.000000]   #4 [00015f7000 - 00015f7133]              BRK ==> [00015f7000 
- 00015f7133]                                     
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 
- 0000012000]                                     
[    0.000000]   #6 [0000012000 - 0000013000]          PGTABLE ==> [0000012000 
- 0000013000]                                     
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880028600000-
ffff88002f7fffff] on node 0                         
[    0.000000] Zone PFN ranges:                                                                                                  
[    0.000000]   DMA      0x00000010 -> 0x00001000                                                                               
[    0.000000]   DMA32    0x00001000 -> 0x00100000                                                                               
[    0.000000]   Normal   0x00100000 -> 0x00238000                                                                               
[    0.000000] Movable zone start PFN for each node                                                                              
[    0.000000] early_node_map[3] active PFN ranges                                                                               
[    0.000000]     0: 0x00000010 -> 0x0000009f                                                                                   
[    0.000000]     0: 0x00000100 -> 0x000c7eb0                                                                                   
[    0.000000]     0: 0x00100000 -> 0x00238000                                                                                   
[    0.000000] On node 0 totalpages: 2096703                                                                                     
[    0.000000]   DMA zone: 56 pages used for memmap                                                                              
[    0.000000]   DMA zone: 102 pages reserved                                                                                    
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0                                                                              
[    0.000000]   DMA32 zone: 14280 pages used for memmap                                                                         
[    0.000000]   DMA32 zone: 800488 pages, LIFO batch:31                                                                         
[    0.000000]   Normal zone: 17472 pages used for memmap                                                                        
[    0.000000]   Normal zone: 1260480 pages, LIFO batch:31                                                                       
[    0.000000] ACPI: PM-Timer IO Port: 0x808                                                                                     
[    0.000000] ACPI: Local APIC address 0xfee00000                                                                               
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)                                                                
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)                                                                
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)                                                                
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)                                                                
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])                                                           
[    0.000000] IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23                                                    
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)                                                          
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)                                                        
[    0.000000] ACPI: IRQ0 used by override.                                                                                      
[    0.000000] ACPI: IRQ2 used by override.                                                                                      
[    0.000000] ACPI: IRQ9 used by override.                                                                                      
[    0.000000] Using ACPI (MADT) for SMP configuration information                                                               
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000                                                                            
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs                                                                              
[    0.000000] nr_irqs_gsi: 24                                                                                                   
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 
00000000000a0000                                                 
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e6000                                                 
[    0.000000] PM: Registered nosave memory: 00000000000e6000 - 
0000000000100000                                                 
[    0.000000] PM: Registered nosave memory: 00000000c7eb0000 - 
00000000c7ec0000                                                 
[    0.000000] PM: Registered nosave memory: 00000000c7ec0000 - 
00000000c7ef0000                                                 
[    0.000000] PM: Registered nosave memory: 00000000c7ef0000 - 
00000000c7f00000                                                 
[    0.000000] PM: Registered nosave memory: 00000000c7f00000 - 
00000000fff00000                                                 
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 
0000000100000000                                                 
[    0.000000] Allocating PCI resources starting at c7f00000 (gap: 
c7f00000:38000000)                                            
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1                                                            
[    0.000000] PERCPU: Embedded 25 pages at ffff880028034000, static data 71904 
bytes                                            
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total 
pages: 2064793                                      
[    0.000000] Kernel command line: root=/dev/md1 
md=3,/dev/sda3,/dev/sdb3,/dev/sdc3 nmi_watchdog=0 mtrr_spare_reg_nr=1          
[    0.000000] md: Will configure md3 (super-block) from 
/dev/sda3,/dev/sdb3,/dev/sdc3, below.                                   
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)                                                             
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 
bytes)                                               
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 
bytes)                                                 
[    0.000000] Initializing CPU#0                                                                                                
[    0.000000] Checking aperture...                                                                                              
[    0.000000] No AGP bridge found                                                                                               
[    0.000000] Node 0: aperture @ 200000000 size 32 MB                                                                           
[    0.000000] Aperture beyond 4GB. Ignoring.                                                                                    
[    0.000000] Your BIOS doesn't leave a aperture memory hole                                                                    
[    0.000000] Please enable the IOMMU option in the BIOS setup                                                                  
[    0.000000] This costs you 64 MB of RAM                                                                                       
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000                                                                  
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 
0000000024000000                                                 
[    0.000000] Memory: 8184476k/9306112k available (3489k kernel code, 919300k 
absent, 201360k reserved, 1745k data, 376k init)  
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1                                           
[    0.000000] NR_IRQS:4352 nr_irqs:440                                                                                          
[    0.000000] Fast TSC calibration using PIT                                                                                    
[    0.000000] Detected 3200.248 MHz processor.                                                                                  
[    0.000613] Console: colour VGA+ 80x25                                                                                        
[    0.000615] console [tty0] enabled                                                                                            
[    0.003333] hpet clockevent registered                                                                                        
[    0.003333]   alloc irq_desc for 24 on node 0                                                                                 
[    0.003333]   alloc kstat_irqs on node 0                                                                                      
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu 
timer                                                  
[    0.003338] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6403.17 BogoMIPS (lpj=10667480)        
[    0.003420] Mount-cache hash table entries: 256                                                                               
[    0.003542] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)                                                 
[    0.003577] CPU: L2 Cache: 512K (64 bytes/line)                                                                               
[    0.003612] tseg: 0000000000                                                                                                  
[    0.003617] CPU: Physical Processor ID: 0                                                                                     
[    0.003651] CPU: Processor Core ID: 0                                                                                         
[    0.003685] mce: CPU supports 6 MCE banks                                                                                     
[    0.003725] using C1E aware idle routine                                                                                      
[    0.003769] ACPI: Core revision 20090521                                                                                      
[    0.016708] Setting APIC routing to flat                                                                                      
[    0.017031] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                                                              
[    0.050991] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02                                                              
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000                                                                            
[    0.003333] Initializing CPU#1                                                                                                
[    0.003333] Calibrating delay using timer specific routine.. 6402.86 
BogoMIPS (lpj=10666976)                                  
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)                                                 
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                                                               
[    0.003333] CPU: Physical Processor ID: 0                                                                                     
[    0.003333] CPU: Processor Core ID: 1                                                                                         
[    0.003333] mce: CPU supports 6 MCE banks                                                                                     
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106                                                  
[    0.144164] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02                                                              
[    0.144513] checking TSC synchronization [CPU#0 -> CPU#1]: passed.                                                            
[    0.146698] Booting processor 2 APIC 0x2 ip 0x6000                                                                            
[    0.003333] Initializing CPU#2                                                                                                
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666966)                                  
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)                                                 
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                                                               
[    0.003333] CPU: Physical Processor ID: 0                                                                                     
[    0.003333] CPU: Processor Core ID: 2                                                                                         
[    0.003333] mce: CPU supports 6 MCE banks                                                                                     
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106                                                  
[    0.240840] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02                                                              
[    0.241187] checking TSC synchronization [CPU#0 -> CPU#2]: passed.                                                            
[    0.243371] Booting processor 3 APIC 0x3 ip 0x6000                                                                            
[    0.003333] Initializing CPU#3                                                                                                
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666969)                                  
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)                                                 
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                                                               
[    0.003333] CPU: Physical Processor ID: 0                                                                                     
[    0.003333] CPU: Processor Core ID: 3                                                                                         
[    0.003333] mce: CPU supports 6 MCE banks                                                                                     
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106                                                  
[    0.337520] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02                                                              
[    0.337868] checking TSC synchronization [CPU#0 -> CPU#3]: passed.                                                            
[    0.340008] Brought up 4 CPUs                                                                                                 
[    0.340042] Total of 4 processors activated (25611.74 BogoMIPS).                                                              
[    0.340111] CPU0 attaching sched-domain:                                                                                      
[    0.340112]  domain 0: span 0-3 level MC                                                                                      
[    0.340114]   groups: 0 1 2 3                                                                                                 
[    0.340117] CPU1 attaching sched-domain:                                                                                      
[    0.340118]  domain 0: span 0-3 level MC                                                                                      
[    0.340119]   groups: 1 2 3 0                                                                                                 
[    0.340122] CPU2 attaching sched-domain:                                                                                      
[    0.340123]  domain 0: span 0-3 level MC                                                                                      
[    0.340124]   groups: 2 3 0 1                                                                                                 
[    0.340126] CPU3 attaching sched-domain:                                                                                      
[    0.340127]  domain 0: span 0-3 level MC                                                                                      
[    0.340128]   groups: 3 0 1 2                                                                                                 
[    0.340392] xor: automatically using best checksumming function: 
generic_sse                                                  
[    0.356667]    generic_sse: 12835.200 MB/sec                                                                                  
[    0.356701] xor: using function: generic_sse (12835.200 MB/sec)                                                               
[    0.356754] Time: 10:44:48  Date: 09/18/09                                                                                    
[    0.356803] NET: Registered protocol family 16                                                                                
[    0.357121] node 0 link 0: io port [1000, ffffff]                                                                             
[    0.357123] TOM: 00000000c8000000 aka 3200M                                                                                   
[    0.357157] Fam 10h mmconf [e0000000, efffffff]                                                                               
[    0.357159] node 0 link 0: mmio [e0000000, efffffff] ==> none                                                                 
[    0.357161] node 0 link 0: mmio [f0000000, ffffffff]                                                                          
[    0.357163] node 0 link 0: mmio [a0000, bffff]                                                                                
[    0.357165] node 0 link 0: mmio [c8000000, dfffffff]                                                                          
[    0.357166] TOM2: 0000000238000000 aka 9088M                                                                                  
[    0.357200] bus: [00,07] on node 0 link 0                                                                                     
[    0.357201] bus: 00 index 0 io port: [0, ffff]                                                                                
[    0.357203] bus: 00 index 1 mmio: [f0000000, ffffffff]                                                                        
[    0.357204] bus: 00 index 2 mmio: [a0000, bffff]                                                                              
[    0.357205] bus: 00 index 3 mmio: [c8000000, dfffffff]                                                                        
[    0.357206] bus: 00 index 4 mmio: [238000000, fcffffffff]                                                                     
[    0.357219] ACPI: bus type pci registered                                                                                     
[    0.357325] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                                                  
[    0.357360] PCI: Not using MMCONFIG.                                                                                          
[    0.357394] PCI: Using configuration type 1 for base access                                                                   
[    0.357428] PCI: Using configuration type 1 for extended access                                                               
[    0.359473] bio: create slab <bio-0> at 0                                                                                     
[    0.359916] ACPI: EC: Look up EC in DSDT                                                                                      
[    0.367314] ACPI: Interpreter enabled                                                                                         
[    0.367350] ACPI: (supports S0 S1 S3 S4 S5)                                                                                   
[    0.367940] ACPI: Using IOAPIC for interrupt routing                                                                          
[    0.368011] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                                                  
[    0.370718] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources                                                 
[    0.375825] PCI: Using MMCONFIG at e0000000 - efffffff                                                                        
[    0.381085] ACPI: No dock devices found.                                                                                      
[    0.381379] ACPI: PCI Root Bridge [PCI0] (0000:00)                                                                            
[    0.381460] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]                                                      
[    0.381506] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold                                                             
[    0.381541] pci 0000:00:02.0: PME# disabled                                                                                   
[    0.381609] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold                                                             
[    0.381644] pci 0000:00:09.0: PME# disabled                                                                                   
[    0.381704] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold                                                             
[    0.381739] pci 0000:00:0a.0: PME# disabled                                                                                   
[    0.381818] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]                                                                 
[    0.381824] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]                                                                 
[    0.381830] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]                                                                 
[    0.381836] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]                                                                 
[    0.381842] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]                                                                 
[    0.381848] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]                                                      
[    0.381897] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]                                                      
[    0.381948] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]                                                      
[    0.382016] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]                                                      
[    0.382065] pci 0000:00:12.2: supports D1 D2                                                                                  
[    0.382067] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot                                                              
[    0.382103] pci 0000:00:12.2: PME# disabled                                                                                   
[    0.382165] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]                                                      
[    0.382216] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]                                                      
[    0.382284] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]                                                      
[    0.382334] pci 0000:00:13.2: supports D1 D2                                                                                  
[    0.382335] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot                                                              
[    0.382371] pci 0000:00:13.2: PME# disabled                                                                                   
[    0.382514] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]                                                                     
[    0.382519] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]                                                                     
[    0.382525] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]                                                                     
[    0.382531] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]                                                                     
[    0.382536] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]                                                                 
[    0.382660] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]                                                      
[    0.382794] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]                                                      
[    0.382801] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]                                                      
[    0.382806] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]                                                                 
[    0.382813] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]                                                      
[    0.382829] pci 0000:02:00.0: supports D1 D2                                                                                  
[    0.382857] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]                                                      
[    0.382887] pci 0000:02:00.1: supports D1 D2                                                                                  
[    0.382937] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]                                                                 
[    0.382939] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]                                                      
[    0.382943] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]                                                 
[    0.382985] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]                                                                 
[    0.382987] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]                                                      
[    0.382990] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]                                                 
[    0.383021] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]                                                                 
[    0.383034] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]                                                      
[    0.383044] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]                                                      
[    0.383049] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]                                                      
[    0.383076] pci 0000:01:00.0: supports D1 D2                                                                                  
[    0.383077] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold                                                       
[    0.383114] pci 0000:01:00.0: PME# disabled                                                                                   
[    0.383200] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]                                                                 
[    0.383202] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]                                                      
[    0.383205] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]                                                 
[    0.383240] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]                                                      
[    0.383319] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]                                                                 
[    0.383389] pci 0000:05:08.0: supports D1 D2                                                                                  
[    0.383430] pci 0000:00:14.4: transparent bridge                                                                              
[    0.383467] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]                                                                 
[    0.383473] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]                                                 
[    0.383485] pci_bus 0000:00: on NUMA node 0                                                                                   
[    0.383488] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                                                               
[    0.383621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]                                                          
[    0.383666] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]                                                          
[    0.383711] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]                                                          
[    0.383777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]                                                          
[    0.386697] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)                                                        
[    0.386926] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)                                                        
[    0.387154] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)                                                        
[    0.387381] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)                                                        
[    0.387608] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, 
disabled.                                           
[    0.387881] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)                                                        
[    0.388107] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)                                                          
[    0.388320] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)                                                        
[    0.388679] SCSI subsystem initialized                                                                                        
[    0.388772] libata version 3.00 loaded.                                                                                       
[    0.388832] usbcore: registered new interface driver usbfs                                                                    
[    0.388888] usbcore: registered new interface driver hub                                                                      
[    0.388953] usbcore: registered new device driver usb                                                                         
[    0.443342] raid6: int64x1   2760 MB/s                                                                                        
[    0.500009] raid6: int64x2   3863 MB/s                                                                                        
[    0.556675] raid6: int64x4   2862 MB/s                                                                                        
[    0.613335] raid6: int64x8   2538 MB/s                                                                                        
[    0.670015] raid6: sse2x1    4072 MB/s                                                                                        
[    0.726676] raid6: sse2x2    6741 MB/s                                                                                        
[    0.783334] raid6: sse2x4    7986 MB/s                                                                                        
[    0.783368] raid6: using algorithm sse2x4 (7986 MB/s)                                                                         
[    0.783454] PCI: Using ACPI for IRQ routing                                                                                   
[    0.783492] pci 0000:00:00.0: BAR 3: address space collision on of device 
[0xe0000000-0xffffffff]                             
[    0.783546] pci 0000:00:00.0: BAR 3: can't allocate resource                                                                  
[    0.796894] PCI-DMA: Disabling AGP.                                                                                           
[    0.797013] PCI-DMA: aperture base @ 20000000 size 65536 KB                                                                   
[    0.797048] PCI-DMA: using GART IOMMU.                                                                                        
[    0.797082] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture                                                         
[    0.798879] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0                                                                       
[    0.798988] hpet0: 4 comparators, 32-bit 14.318180 MHz counter                                                                
[    0.803361] hpet: hpet2 irq 24 for MSI                                                                                        
[    0.813349] Switched to high resolution mode on CPU 0                                                                         
[    0.814536] Switched to high resolution mode on CPU 1                                                                         
[    0.814545] Switched to high resolution mode on CPU 2                                                                         
[    0.814560] Switched to high resolution mode on CPU 3                                                                         
[    0.823365] pnp: PnP ACPI init                                                                                                
[    0.823416] ACPI: bus type pnp registered                                                                                     
[    0.825645] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 
(0x0-0x1fffffff), disabling                     
[    0.825701] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                 
[    0.825755] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                 
[    0.825810] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling             
[    0.826118] pnp: PnP ACPI: found 12 devices                                                                                   
[    0.826152] ACPI: ACPI bus type pnp unregistered                                                                              
[    0.826192] system 00:06: iomem range 0xfec00000-0xfec00fff could not be 
reserved                                             
[    0.826246] system 00:06: iomem range 0xfee00000-0xfee00fff has been 
reserved                                                 
[    0.826283] system 00:07: ioport range 0x4d0-0x4d1 has been reserved                                                          
[    0.826318] system 00:07: ioport range 0x40b-0x40b has been reserved                                                          
[    0.826353] system 00:07: ioport range 0x4d6-0x4d6 has been reserved                                                          
[    0.826388] system 00:07: ioport range 0xc00-0xc01 has been reserved                                                          
[    0.826423] system 00:07: ioport range 0xc14-0xc14 has been reserved                                                          
[    0.826458] system 00:07: ioport range 0xc50-0xc51 has been reserved                                                          
[    0.826492] system 00:07: ioport range 0xc52-0xc52 has been reserved                                                          
[    0.826527] system 00:07: ioport range 0xc6c-0xc6c has been reserved                                                          
[    0.826562] system 00:07: ioport range 0xc6f-0xc6f has been reserved                                                          
[    0.826597] system 00:07: ioport range 0xcd0-0xcd1 has been reserved                                                          
[    0.826632] system 00:07: ioport range 0xcd2-0xcd3 has been reserved                                                          
[    0.826683] system 00:07: ioport range 0xcd4-0xcd5 has been reserved                                                          
[    0.826718] system 00:07: ioport range 0xcd6-0xcd7 has been reserved                                                          
[    0.826753] system 00:07: ioport range 0xcd8-0xcdf has been reserved                                                          
[    0.826787] system 00:07: ioport range 0x800-0x89f has been reserved                                                          
[    0.826822] system 00:07: ioport range 0xb00-0xb0f has been reserved                                                          
[    0.826857] system 00:07: ioport range 0xb20-0xb3f has been reserved                                                          
[    0.826892] system 00:07: ioport range 0x900-0x90f has been reserved                                                          
[    0.826927] system 00:07: ioport range 0x910-0x91f has been reserved                                                          
[    0.826962] system 00:07: ioport range 0xfe00-0xfefe has been reserved                                                        
[    0.826997] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved                                                 
[    0.827033] system 00:07: iomem range 0xfec10000-0xfec1001f has been 
reserved                                                 
[    0.827069] system 00:09: ioport range 0x290-0x29f has been reserved                                                          
[    0.827105] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved                                                 
[    0.827142] system 00:0b: iomem range 0xfec00000-0xffffffff could not be 
reserved                                             
[    0.832030] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02                                                               
[    0.832065] pci 0000:00:02.0:   IO window: 0xc000-0xcfff                                                                      
[    0.832101] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff                                                             
[    0.832136] pci 0000:00:02.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff                                            
[    0.832191] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03                                                               
[    0.832226] pci 0000:00:09.0:   IO window: 0xd000-0xdfff                                                                      
[    0.832262] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff                                                             
[    0.832297] pci 0000:00:09.0:   PREFETCH window: 
0x000000fa000000-0x000000fcefffff                                            
[    0.832352] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01                                                               
[    0.832386] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff                                                                      
[    0.832422] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff                                                             
[    0.832457] pci 0000:00:0a.0:   PREFETCH window: 
0x000000cff00000-0x000000cfffffff                                            
[    0.832512] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05                                                               
[    0.832548] pci 0000:00:14.4:   IO window: 0xe000-0xefff                                                                      
[    0.832585] pci 0000:00:14.4:   MEM window: disabled                                                                          
[    0.832621] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff                                                        
[    0.832662]   alloc irq_desc for 18 on node -1                                                                                
[    0.832664]   alloc kstat_irqs on node -1                                                                                     
[    0.832667] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                                                      
[    0.832704] pci 0000:00:02.0: setting latency timer to 64                                                                     
[    0.832707]   alloc irq_desc for 17 on node -1                                                                                
[    0.832708]   alloc kstat_irqs on node -1                                                                                     
[    0.832710] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                                                      
[    0.832746] pci 0000:00:09.0: setting latency timer to 64                                                                     
[    0.832749] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                                                      
[    0.832784] pci 0000:00:0a.0: setting latency timer to 64                                                                     
[    0.832791] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                                                    
[    0.832793] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                                                    
[    0.832794] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]                                                                  
[    0.832796] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]                                                          
[    0.832797] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]                                                      
[    0.832799] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]                                                                  
[    0.832800] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]                                                          
[    0.832801] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]                                                      
[    0.832803] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]                                                                  
[    0.832804] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]                                                          
[    0.832805] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]                                                      
[    0.832807] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]                                                                  
[    0.832808] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]                                                      
[    0.832810] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]                                                                    
[    0.832811] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]                                                    
[    0.832821] NET: Registered protocol family 2                                                                                 
[    0.832877] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)                                               
[    0.833358] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)                                             
[    0.834343] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                                                      
[    0.834743] TCP: Hash tables configured (established 262144 bind 65536)                                                       
[    0.834779] TCP reno registered                                                                                               
[    0.834857] NET: Registered protocol family 1                                                                                 
[    0.836019] Scanning for low memory corruption every 60 seconds                                                               
[    0.836741] HugeTLB registered 2 MB page size, pre-allocated 0 pages                                                          
[    0.836874] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.                                                
[    0.836960] msgmni has been set to 15987                                                                                      
[    0.837274] alg: No test for stdrng (krng)                                                                                    
[    0.837317] async_tx: api initialized (sync-only)                                                                             
[    0.837391] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)                                              
[    0.837445] io scheduler noop registered                                                                                      
[    0.837480] io scheduler cfq registered (default)                                                                             
[    0.837602] pci 0000:02:00.0: Boot video device                                                                               
[    0.837694]   alloc irq_desc for 25 on node -1                                                                                
[    0.837695]   alloc kstat_irqs on node -1                                                                                     
[    0.837701] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X                                                                
[    0.837705] pcieport-driver 0000:00:02.0: setting latency timer to 64                                                         
[    0.837795]   alloc irq_desc for 26 on node -1                                                                                
[    0.837796]   alloc kstat_irqs on node -1                                                                                     
[    0.837799] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X                                                                
[    0.837803] pcieport-driver 0000:00:09.0: setting latency timer to 64                                                         
[    0.837891]   alloc irq_desc for 27 on node -1                                                                                
[    0.837892]   alloc kstat_irqs on node -1                                                                                     
[    0.837895] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X                                                                
[    0.837899] pcieport-driver 0000:00:0a.0: setting latency timer to 64                                                         
[    0.838094] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0                                              
[    0.838148] ACPI: Power Button [PWRF]                                                                                         
[    0.838239] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1                                     
[    0.838292] ACPI: Power Button [PWRB]                                                                                         
[    0.838444] processor LNXCPU:00: registered as cooling_device0                                                                
[    0.838479] ACPI: Processor [CPU0] (supports 8 throttling states)                                                             
[    0.838576] processor LNXCPU:01: registered as cooling_device1                                                                
[    0.838646] processor LNXCPU:02: registered as cooling_device2                                                                
[    0.838718] processor LNXCPU:03: registered as cooling_device3                                                                
[    0.842368] Linux agpgart interface v0.103                                                                                    
[    0.842561] ahci 0000:00:11.0: version 3.0                                                                                    
[    0.842570]   alloc irq_desc for 22 on node -1                                                                                
[    0.842571]   alloc kstat_irqs on node -1                                                                                     
[    0.842575] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                                                     
[    0.842723] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode                                     
[    0.842778] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio 
slum part                                        
[    0.843318] scsi0 : ahci                                                                                                      
[    0.843461] scsi1 : ahci                                                                                                      
[    0.843559] scsi2 : ahci                                                                                                      
[    0.843654] scsi3 : ahci                                                                                                      
[    0.843748] scsi4 : ahci                                                                                                      
[    0.843845] scsi5 : ahci                                                                                                      
[    0.843973] ata1: SATA max UDMA/133 irq_stat 0x00400000 irq 22, PHY RDY 
changed                                               
[    0.844028] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 
22                                              
[    0.844082] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 
22                                              
[    0.844137] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 
22                                              
[    0.844191] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 
22                                              
[    0.844245] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 
22                                              
[    0.844491] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1                                                            
[    0.844526] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp                    
[    0.845071] serio: i8042 KBD port at 0x60,0x64 irq 1                                                                          
[    0.845197] mice: PS/2 mouse device common for all mice                                                                       
[    0.845347] rtc_cmos 00:02: RTC can wake from S4                                                                              
[    0.845413] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0                                                             
[    0.845469] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs                                                     
[    0.845523] md: raid1 personality registered for level 1                                                                      
[    0.845558] md: raid6 personality registered for level 6                                                                      
[    0.845592] md: raid5 personality registered for level 5                                                                      
[    0.845626] md: raid4 personality registered for level 4                                                                      
[    0.846205] cpuidle: using governor ladder                                                                                    
[    0.846648] usbcore: registered new interface driver hiddev                                                                   
[    0.846718] usbcore: registered new interface driver usbhid                                                                   
[    0.846753] usbhid: v2.6:USB HID core driver                                                                                  
[    0.846813] Advanced Linux Sound Architecture Driver Version 1.0.20.                                                          
[    0.846847] ALSA device list:                                                                                                 
[    0.846880]   No soundcards found.                                                                                            
[    0.846948] TCP cubic registered                                                                                              
[    0.846987] NET: Registered protocol family 10                                                                                
[    0.847118] IPv6 over IPv4 tunneling driver                                                                                   
[    0.847252] NET: Registered protocol family 17                                                                                
[    0.847307] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor 
processors (4 cpu cores) (version 2.20.00)                
[    0.847386] powernow-k8:    0 : pstate 0 (3200 MHz)                                                                           
[    0.847420] powernow-k8:    1 : pstate 1 (2500 MHz)                                                                           
[    0.847454] powernow-k8:    2 : pstate 2 (2100 MHz)                                                                           
[    0.847488] powernow-k8:    3 : pstate 3 (800 MHz)                                                                            
[    0.847871] PM: Resume from disk failed.                                                                                      
[    0.847960]   Magic number: 9:115:730                                                                                         
[    0.874152] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input2                                
[    1.163786] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                            
[    1.163845] ata5: SATA link down (SStatus 0 SControl 300)                                                                     
[    1.163902] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                            
[    1.163955] ata3: SATA link down (SStatus 0 SControl 300)                                                                     
[    1.164197] ata6: SATA link down (SStatus 0 SControl 300)                                                                     
[    1.170136] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7                                                              
[    1.170177] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)                                                     
[    1.170247] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7                                                              
[    1.170286] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                                                      
[    1.176655] ata4.00: configured for UDMA/133                                                                                  
[    1.176712] ata2.00: configured for UDMA/133                                                                                  
[    1.563785] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                                                            
[    1.570130] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7                                                              
[    1.570166] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                                                      
[    1.576582] ata1.00: configured for UDMA/133                                                                                  
[    1.587994] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5                                      
[    1.588218] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)                                             
[    1.588234] sd 0:0:0:0: Attached scsi generic sg0 type 0                                                                      
[    1.588326] sd 0:0:0:0: [sda] Write Protect is off                                                                            
[    1.588331] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5                                      
[    1.588414] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                                                         
[    1.588425] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                           
[    1.588446] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 
GB/465 GiB)                                             
[    1.588464] sd 1:0:0:0: [sdb] Write Protect is off                                                                            
[    1.588466] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00                                                                         
[    1.588475] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                           
[    1.588498] sd 1:0:0:0: Attached scsi generic sg1 type 0                                                                      
[    1.588541]  sdb:                                                                                                             
[    1.588565] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 
PQ: 0 ANSI: 5                                      
[    1.588659] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 
GB/698 GiB)                                            
[    1.588675] sd 3:0:0:0: [sdc] Write Protect is off                                                                            
[    1.588676] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00                                                                         
[    1.588684] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                           
[    1.588703] sd 3:0:0:0: Attached scsi generic sg2 type 0                                                                      
[    1.588728]  sdc:                                                                                                             
[    1.588982]  sda: sdb1 sdb2 sdb3 sdb4 < sdc1 sdc2 sdc3 sdc4 < sda1 sda2 
sda3 sda4 < sdb5 sdc5 sda5 sdc6 sdb6 >                
[    1.611001] sd 1:0:0:0: [sdb] Attached SCSI disk                                                                              
[    1.617040]  sda6 >                                                                                                           
[    1.617377] sd 0:0:0:0: [sda] Attached SCSI disk                                                                              
[    1.623396]  sdc7 >                                                                                                           
[    1.623757] sd 3:0:0:0: [sdc] Attached SCSI disk                                                                              
[    1.623798] md: Waiting for all devices to be available before autodetect                                                     
[    1.623833] md: If you don't use raid, use raid=noautodetect                                                                  
[    1.623947] md: Autodetecting RAID arrays.                                                                                    
[    1.721863] md: Scanned 12 and added 12 devices.                                                                              
[    1.721898] md: autorun ...                                                                                                   
[    1.721932] md: considering sdc6 ...                                                                                          
[    1.721968] md:  adding sdc6 ...                                                                                              
[    1.722002] md: sdc5 has different UUID to sdc6                                                                               
[    1.722037] md: sdc3 has different UUID to sdc6                                                                               
[    1.722072] md: sdc1 has different UUID to sdc6                                                                               
[    1.722107] md:  adding sda6 ...                                                                                              
[    1.722142] md: sda5 has different UUID to sdc6                                                                               
[    1.722177] md: sda3 has different UUID to sdc6                                                                               
[    1.722211] md: sda1 has different UUID to sdc6                                                                               
[    1.722247] md:  adding sdb6 ...                                                                                              
[    1.722281] md: sdb5 has different UUID to sdc6                                                                               
[    1.722316] md: sdb3 has different UUID to sdc6                                                                               
[    1.722351] md: sdb1 has different UUID to sdc6                                                                               
[    1.722482] md: created md3                                                                                                   
[    1.722516] md: bind<sdb6>                                                                                                    
[    1.722554] md: bind<sda6>                                                                                                    
[    1.722590] md: bind<sdc6>                                                                                                    
[    1.722626] md: running: <sdc6><sda6><sdb6>                                                                                   
[    1.722767] raid5: device sdc6 operational as raid disk 2                                                                     
[    1.722801] raid5: device sda6 operational as raid disk 0                                                                     
[    1.722835] raid5: device sdb6 operational as raid disk 1                                                                     
[    1.722989] raid5: allocated 3220kB for md3                                                                                   
[    1.723036] raid5: raid level 5 set md3 active with 3 out of 3 devices, 
algorithm 2                                           
[    1.723089] RAID5 conf printout:                                                                                              
[    1.723122]  --- rd:3 wd:3                                                                                                    
[    1.723156]  disk 0, o:1, dev:sda6                                                                                            
[    1.723189]  disk 1, o:1, dev:sdb6                                                                                            
[    1.723222]  disk 2, o:1, dev:sdc6                                                                                            
[    1.723269] md3: detected capacity change from 0 to 864065421312                                                              
[    1.723326] md: considering sdc5 ...                                                                                          
[    1.723364] md:  adding sdc5 ...                                                                                              
[    1.723398] md: sdc3 has different UUID to sdc5                                                                               
[    1.723433] md: sdc1 has different UUID to sdc5                                                                               
[    1.723468] md:  adding sda5 ...                                                                                              
[    1.723503] md: sda3 has different UUID to sdc5                                                                               
[    1.723538] md: sda1 has different UUID to sdc5                                                                               
[    1.723573] md:  adding sdb5 ...                                                                                              
[    1.723608] md: sdb3 has different UUID to sdc5                                                                               
[    1.723643] md: sdb1 has different UUID to sdc5                                                                               
[    1.723740] md: created md2                                                                                                   
[    1.723773] md: bind<sdb5>                                                                                                    
[    1.723810] md: bind<sda5>                                                                                                    
[    1.723847] md: bind<sdc5>                                                                                                    
[    1.723883] md: running: <sdc5><sda5><sdb5>                                                                                   
[    1.724022] raid5: device sdc5 operational as raid disk 2                                                                     
[    1.724052] raid5: device sda5 operational as raid disk 0                                                                     
[    1.724086] raid5: device sdb5 operational as raid disk 1                                                                     
[    1.724241] raid5: allocated 3220kB for md2                                                                                   
[    1.724292] raid5: raid level 5 set md2 active with 3 out of 3 devices, 
algorithm 2                                           
[    1.724341] RAID5 conf printout:                                                                                              
[    1.724374]  --- rd:3 wd:3                                                                                                    
[    1.724407]  disk 0, o:1, dev:sda5                                                                                            
[    1.724441]  disk 1, o:1, dev:sdb5                                                                                            
[    1.724474]  disk 2, o:1, dev:sdc5                                                                                            
[    1.724518] md2: detected capacity change from 0 to 40007499776                                                               
[    1.724587] md: considering sdc3 ...                                                                                          
[    1.724623] md:  adding sdc3 ...                                                                                              
[    1.724657] md: sdc1 has different UUID to sdc3                                                                               
[    1.724693] md:  adding sda3 ...                                                                                              
[    1.724728] md: sda1 has different UUID to sdc3                                                                               
[    1.724763] md:  adding sdb3 ...                                                                                              
[    1.724798] md: sdb1 has different UUID to sdc3                                                                               
[    1.724896] md: created md1                                                                                                   
[    1.724929] md: bind<sdb3>                                                                                                    
[    1.724969] md: bind<sda3>                                                                                                    
[    1.725005] md: bind<sdc3>                                                                                                    
[    1.725041] md: running: <sdc3><sda3><sdb3>                                                                                   
[    1.725177] raid5: device sdc3 operational as raid disk 2                                                                     
[    1.725211] raid5: device sda3 operational as raid disk 0                                                                     
[    1.725245] raid5: device sdb3 operational as raid disk 1                                                                     
[    1.725401] raid5: allocated 3220kB for md1                                                                                   
[    1.725447] raid5: raid level 5 set md1 active with 3 out of 3 devices, 
algorithm 2                                           
[    1.725500] RAID5 conf printout:                                                                                              
[    1.725533]  --- rd:3 wd:3                                                                                                    
[    1.725566]  disk 0, o:1, dev:sda3                                                                                            
[    1.725600]  disk 1, o:1, dev:sdb3                                                                                            
[    1.725633]  disk 2, o:1, dev:sdc3                                                                                            
[    1.725680] md1: detected capacity change from 0 to 79998877696                                                               
[    1.725736] md: considering sdc1 ...                                                                                          
[    1.725772] md:  adding sdc1 ...                                                                                              
[    1.725807] md:  adding sda1 ...                                                                                              
[    1.725842] md:  adding sdb1 ...                                                                                              
[    1.725875] md: created md0                                                                                                   
[    1.725908] md: bind<sdb1>                                                                                                    
[    1.725946] md: bind<sda1>                                                                                                    
[    1.725983] md: bind<sdc1>                                                                                                    
[    1.726019] md: running: <sdc1><sda1><sdb1>                                                                                   
[    1.726187] raid1: raid set md0 active with 3 out of 3 mirrors                                                                
[    1.726230] md0: detected capacity change from 0 to 65667072                                                                  
[    1.726284] md: ... autorun DONE.                                                                                             
[    1.726336] md: Loading md3: /dev/sda3                                                                                        
[    1.726374]  md3: unknown partition table                                                                                     
[    1.726532] md: couldn't update array info. -22                                                                               
[    1.726570] md: could not bd_claim sda3.                                                                                      
[    1.726604] md: md_import_device returned -16                                                                                 
[    1.726639] md: could not bd_claim sdb3.                                                                                      
[    1.726674] md: md_import_device returned -16                                                                                 
[    1.726712] md: could not bd_claim sdc3.                                                                                      
[    1.726745] md: md_import_device returned -16                                                                                 
[    1.726780] md: starting md3 failed                                                                                           
[    1.726850]  md1: unknown partition table                                                                                     
[    1.763064] reiser4: md1: found disk format 4.0.0.                                                                            
[    5.786843] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.                                                    
[    5.786894] Freeing unused kernel memory: 376k freed                                                                          
[    8.951848] udev: starting version 145                                                                                        
[    9.185756]  md0:                                                                                                             
[    9.185888]  md2: unknown partition table                                                                                     
[    9.205084]  unknown partition table                                                                                          
[   10.449026] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                                                   
[   10.449040] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                                                    
[   10.449287] r8169 0000:01:00.0: setting latency timer to 64                                                                   
[   10.449317]   alloc irq_desc for 28 on node -1                                                                                
[   10.449319]   alloc kstat_irqs on node -1                                                                                     
[   10.449329] r8169 0000:01:00.0: irq 28 for MSI/MSI-X                                                                          
[   10.449435] eth0: RTL8168c/8111c at 0xffffc90012fa8000, 00:19:66:86:ce:12, 
XID 3c4000c0 IRQ 28                                
[   10.467952] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                                                        
[   10.467954] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96                                                              
[   10.467983] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17                                                 
[   10.468015] ehci_hcd 0000:00:12.2: EHCI Host Controller                                                                       
[   10.468183] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1                                              
[   10.468190] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                            
[   10.468193] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024                                        
[   10.468215] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround                                             
[   10.468221] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                             
[   10.468234] ehci_hcd 0000:00:12.2: debug port 1                                                                               
[   10.468238] ehci_hcd 0000:00:12.2: MWI active                                                                                 
[   10.468239] ehci_hcd 0000:00:12.2: supports USB remote wakeup                                                                 
[   10.468252] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000                                                                  
[   10.468255] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                             
[   10.468261] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN                                      
[   10.477924] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00                                                                 
[   10.477953] usb usb1: default language 0x0409                                                                                 
[   10.477957] usb usb1: udev 1, busnum 1, minor = 0                                                                             
[   10.477958] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                                                     
[   10.477959] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                
[   10.477961] usb usb1: Product: EHCI Host Controller                                                                           
[   10.477962] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd                                                                   
[   10.477963] usb usb1: SerialNumber: 0000:00:12.2                                                                              
[   10.477991] usb usb1: uevent                                                                                                  
[   10.478347] usb usb1: usb_probe_device                                                                                        
[   10.478349] usb usb1: configuration #1 chosen from 1 choice                                                                   
[   10.478355] usb usb1: adding 1-0:1.0 (config #1, interface 0)                                                                 
[   10.478364] usb 1-0:1.0: uevent                                                                                               
[   10.478392] hub 1-0:1.0: usb_probe_interface                                                                                  
[   10.478393] hub 1-0:1.0: usb_probe_interface - got id                                                                         
[   10.478395] hub 1-0:1.0: USB hub found                                                                                        
[   10.478401] hub 1-0:1.0: 6 ports detected                                                                                     
[   10.478402] hub 1-0:1.0: standalone hub                                                                                       
[   10.478403] hub 1-0:1.0: no power switching (usb 1.0)                                                                         
[   10.478404] hub 1-0:1.0: individual port over-current protection                                                              
[   10.478405] hub 1-0:1.0: power on to power good time: 20ms                                                                    
[   10.478408] hub 1-0:1.0: local power source is good                                                                           
[   10.478410] hub 1-0:1.0: trying to enable port power on non-switchable hub                                                    
[   10.478452]   alloc irq_desc for 19 on node -1                                                                                
[   10.478453]   alloc kstat_irqs on node -1                                                                                     
[   10.478458] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19                                                 
[   10.478479] ehci_hcd 0000:00:13.2: EHCI Host Controller                                                                       
[   10.478518] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2                                              
[   10.478524] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                            
[   10.478527] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024                                        
[   10.478541] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround                                             
[   10.478547] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                             
[   10.478559] ehci_hcd 0000:00:13.2: debug port 1                                                                               
[   10.478562] ehci_hcd 0000:00:13.2: MWI active                                                                                 
[   10.478563] ehci_hcd 0000:00:13.2: supports USB remote wakeup                                                                 
[   10.478574] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800                                                                  
[   10.478577] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                             
[   10.478582] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN                                      
[   10.488887] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00                                                                 
[   10.488909] usb usb2: default language 0x0409                                                                                 
[   10.488912] usb usb2: udev 1, busnum 2, minor = 128                                                                           
[   10.488913] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                                                     
[   10.488915] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1                                                
[   10.488916] usb usb2: Product: EHCI Host Controller                                                                           
[   10.488917] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd                                                                   
[   10.488918] usb usb2: SerialNumber: 0000:00:13.2                                                                              
[   10.488948] usb usb2: uevent                                                                                                  
[   10.488986] usb usb2: usb_probe_device                                                                                        
[   10.488988] usb usb2: configuration #1 chosen from 1 choice                                                                   
[   10.488993] usb usb2: adding 2-0:1.0 (config #1, interface 0)                                                                 
[   10.489001] usb 2-0:1.0: uevent                                                                                               
[   10.489020] hub 2-0:1.0: usb_probe_interface                                                                                  
[   10.489021] hub 2-0:1.0: usb_probe_interface - got id                                                                         
[   10.489023] hub 2-0:1.0: USB hub found                                                                                        
[   10.489028] hub 2-0:1.0: 6 ports detected                                                                                     
[   10.489029] hub 2-0:1.0: standalone hub                                                                                       
[   10.489030] hub 2-0:1.0: no power switching (usb 1.0)                                                                         
[   10.489032] hub 2-0:1.0: individual port over-current protection                                                              
[   10.489033] hub 2-0:1.0: power on to power good time: 20ms                                                                    
[   10.489035] hub 2-0:1.0: local power source is good                                                                           
[   10.489037] hub 2-0:1.0: trying to enable port power on non-switchable hub                                                    
[   10.528716] Linux video capture interface: v2.00                                                                              
[   10.541378] bttv: driver version 0.9.18 loaded                                                                                
[   10.541379] bttv: using 8 buffers with 2080k (520 pages) each for capture                                                     
[   10.541441] bttv: Bt8xx card found (0).                                                                                       
[   10.541449]   alloc irq_desc for 21 on node -1                                                                                
[   10.541451]   alloc kstat_irqs on node -1                                                                                     
[   10.541456] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21                                                     
[   10.541465] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, 
mmio: 0xfcfff000                                    
[   10.541511] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra 
TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]
[   10.541513] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs                                                           
[   10.541548] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]                                                              
[   10.577936] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER 
sig=j CSC CONNECT                                          
[   10.577939] hub 1-0:1.0: port 2: status 0501 change 0001                                                                           
[   10.587948] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000                                                                         
[   10.677940] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000                                                                         
[   10.677949] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s                                                                
[   10.730446] ehci_hcd 0000:00:12.2: port 2 high speed                                                                               
[   10.730450] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT                                         
[   10.783768] usb 1-2: new high speed USB device using ehci_hcd and address 2                                                        
[   10.837110] ehci_hcd 0000:00:12.2: port 2 high speed                                                                               
[   10.837113] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT                                         
[   10.908580] usb 1-2: default language 0x0409                                                                                       
[   10.908829] usb 1-2: udev 2, busnum 1, minor = 1                                                                                   
[   10.908830] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608                                                           
[   10.908832] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0                                                      
[   10.908833] usb 1-2: Product: USB2.0 Hub                                                                                           
[   10.908871] usb 1-2: uevent                                                                                                        
[   10.908881] usb 1-2: usb_probe_device                                                                                              
[   10.908883] usb 1-2: configuration #1 chosen from 1 choice                                                                         
[   10.909295] usb 1-2: adding 1-2:1.0 (config #1, interface 0)                                                                       
[   10.909305] usb 1-2:1.0: uevent                                                                                                    
[   10.909313] hub 1-2:1.0: usb_probe_interface                                                                                       
[   10.909314] hub 1-2:1.0: usb_probe_interface - got id                                                                              
[   10.909315] hub 1-2:1.0: USB hub found                                                                                             
[   10.909576] hub 1-2:1.0: 4 ports detected                                                                                          
[   10.909578] hub 1-2:1.0: standalone hub                                                                                            
[   10.909579] hub 1-2:1.0: individual port power switching                                                                           
[   10.909580] hub 1-2:1.0: individual port over-current protection                                                                   
[   10.909581] hub 1-2:1.0: Single TT                                                                                                 
[   10.909582] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)                                                             
[   10.909584] hub 1-2:1.0: Port indicators are supported                                                                             
[   10.909585] hub 1-2:1.0: power on to power good time: 100ms                                                                        
[   10.909951] hub 1-2:1.0: local power source is good                                                                                
[   10.909952] hub 1-2:1.0: enabling power on all ports                                                                               
[   11.010944] hub 1-2:1.0: port 2: status 0301 change 0001                                                                           
[   11.110432] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]                                                             
[   11.110442] hub 1-2:1.0: state 7 ports 4 chg 0004 evt 0000                                                                         
[   11.110681] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s                                                                
[   11.177677] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3                                                       
[   11.264416] usb 1-2.2: skipped 1 descriptor after interface                                                                        
[   11.264418] usb 1-2.2: skipped 1 descriptor after interface                                                                        
[   11.264913] usb 1-2.2: default language 0x0409                                                                                     
[   11.267162] usb 1-2.2: udev 3, busnum 1, minor = 2                                                                                 
[   11.267164] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518                                                         
[   11.267165] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0                                                    
[   11.267166] usb 1-2.2: Product: USB Receiver                                                                                       
[   11.267167] usb 1-2.2: Manufacturer: Logitech                                                                                      
[   11.267194] usb 1-2.2: uevent                                                                                                      
[   11.267201] usb 1-2.2: usb_probe_device                                                                                            
[   11.267203] usb 1-2.2: configuration #1 chosen from 1 choice                                                                       
[   11.274538] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)                                                                   
[   11.274551] usb 1-2.2:1.0: uevent                                                                                                  
[   11.274561] usbhid 1-2.2:1.0: usb_probe_interface                                                                                  
[   11.274562] usbhid 1-2.2:1.0: usb_probe_interface - got id                                                                         
[   11.274905] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42                                                                      
[   11.277797] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3                 
[   11.277835] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0
[   11.277844] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)                                                                      
[   11.277852] usb 1-2.2:1.1: uevent                                                                                                     
[   11.277859] usbhid 1-2.2:1.1: usb_probe_interface                                                                                     
[   11.277860] usbhid 1-2.2:1.1: usb_probe_interface - got id                                                                            
[   11.278154] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42                                                                         
[   11.283458] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4                    
[   11.283468] usb 1-2.2: link qh8-0e01/ffff8800c7800300 start 2 [1/2 us]                                                                
[   11.283485] drivers/usb/core/file.c: looking for a minor, starting at 96                                                              
[   11.283516] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1
[   11.283531] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0004                                                                                      
[   11.309746] usb 1-2.2:1.0: uevent                                                                                                               
[   11.309808] usb 1-2.2: uevent                                                                                                                   
[   11.309823] usb 1-2.2:1.0: uevent                                                                                                               
[   11.309882] usb 1-2.2: uevent                                                                                                                   
[   11.310370] usb 1-2.2:1.1: uevent                                                                                                               
[   11.310439] usb 1-2.2: uevent                                                                                                                   
[   11.310459] usb 1-2.2:1.0: uevent                                                                                                               
[   11.311117] usb 1-2.2:1.1: uevent                                                                                                               
[   11.320348] usb 1-2.2:1.0: uevent                                                                                                               
[   11.546696] bttv0: tea5757: read timeout                                                                                                        
[   11.546698] bttv0: tuner type=5                                                                                                                 
[   11.558212] bttv0: audio absent, no audio device found!                                                                                         
[   11.570726] TUNER: Unable to find symbol tea5767_autodetection()                                                                                
[   11.570729] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])                                                                                     
[   11.573402] tuner-simple 0-0060: creating new instance                                                                                          
[   11.573405] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))                                                        
[   11.574211] bttv0: registered device video0                                                                                                     
[   11.574239] bttv0: registered device vbi0                                                                                                       
[   11.867533] reiser4: md2: found disk format 4.0.0.                                                                                              
[   13.337099] hub 2-0:1.0: hub_suspend                                                                                                            
[   13.337105] usb usb2: bus auto-suspend                                                                                                          
[   13.337107] ehci_hcd 0000:00:13.2: suspend root hub                                                                                             
[   13.670061] reiser4: md3: found disk format 4.0.0.                                                                                              
[   54.876174] reiser4: sdc7: found disk format 4.0.0.                                                                                             
[   67.268208] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 
across:7815612k                                                            
[   67.280636] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 
across:7815612k                                                            
[   67.316664] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 
across:7815612k                                                            
[   67.883788] w83627ehf: Found W83627EHG chip at 0x290                                                                                            
[   68.285889] r8169: eth0: link up                                                                                                                
[   68.285899] r8169: eth0: link up                                                                                                                
[   70.114598] usb usb1: uevent                                                                                                                    
[   70.114699] usb 1-0:1.0: uevent                                                                                                                 
[   70.114788] usb 1-2: uevent                                                                                                                     
[   70.114889] usb 1-2.2: uevent                                                                                                                   
[   70.114988] usb 1-2.2:1.0: uevent                                                                                                               
[   70.115702] usb 1-2.2:1.1: uevent                                                                                                               
[   70.116378] usb 1-2:1.0: uevent                                                                                                                 
[   70.116751] usb usb2: uevent                                                                                                                    
[   70.116849] usb 2-0:1.0: uevent                                                                                                                 
[   71.277145]   alloc irq_desc for 23 on node -1                                                                                                  
[   71.277151]   alloc kstat_irqs on node -1                                                                                                       
[   71.277165] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -
> IRQ 23                                                             
[   71.284131] Audigy2 value: Special config.                                                                                                      
[   72.553971] fglrx: module license 'Proprietary. (C) 2002 - ATI 
Technologies, Starnberg, GERMANY' taints kernel.                                 
[   72.553980] Disabling lock debugging due to kernel taint                                                                                        
[   72.603989] [fglrx] Maximum main memory to use for locked dma buffers: 7760 
MBytes.                                                             
[   72.604281] [fglrx]   vendor: 1002 device: 9501 count: 1                                                                                        
[   72.605042] [fglrx] ioport: bar 4, base 0xc000, size: 0x100                                                                                     
[   72.605065] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                                                                        
[   72.605074] pci 0000:02:00.0: setting latency timer to 64                                                                                       
[   72.605605] [fglrx] Kernel PAT support is enabled                                                                                               
[   72.605644] [fglrx] module loaded - fglrx 8.67.2 [Sep 15 2009] with 1 
minors                                                                    
[   72.762362]   alloc irq_desc for 29 on node -1                                                                                                  
[   72.762364]   alloc kstat_irqs on node -1                                                                                                       
[   72.762372] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X                                                                                        
[   72.762753] [fglrx] Firegl kernel thread PID: 3876                                                                                              
[   74.920122] [fglrx] Gart USWC size:1279 M.                                                                                                      
[   74.920125] [fglrx] Gart cacheable size:508 M.                                                                                                  
[   74.920128] [fglrx] Reserved FB block: Shared offset:0, size:1000000                                                                            
[   74.920129] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000                                                                     
[   74.920131] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000                                                                      
[   76.137549] usb 1-2.2: link qh8-0e01/ffff8800c78003c0 start 3 [1/2 us]                                                                          
[  189.317763] reiser4[bogofilter(4078)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:                                               
[  189.317767] NOTICE: md3 does not support write barriers, using synchronous 
write instead.     

 cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  128MB, count=1: write-back

Glück Auf
Volker
