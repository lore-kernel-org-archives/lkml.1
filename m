Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444AbZINOCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbZINOCn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 10:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZINOCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 10:02:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:16403 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044AbZINOCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 10:02:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:subject:from:date:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=UuHRUgHGSYoty3BI4SJWcCMiGnnxBxjG2uj9nC7vtjSy1R8uOsql1tYWKjdU/ayZPF
         UWVPVmWDVXry4+1dH9RTWtsJ9GWk+XNkTeHmvDyJXeaOpgJ19zhBcpbiGJhCH2hyAx6U
         z0u2wwwIdX/AiFox1KZ1YFMdszvHPbFHIzOtY=
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31 ehci problem - mouse dead on scroll
From: Volker Armin Hemmann <volkerarmin@googlemail.com>
Date: Mon, 14 Sep 2009 16:02:32 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909141602.32783.volkerarmin@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

more stuff:
 even without scrolling the mouse locks up several times after boot.

 After the third, fourth fifth rmmod ehci_hcd && modprobe ehci_hcd it works fine 
for the rest of the day - until the next boot.

if there is something else attached to the hub - like a loading mp3 player, 
the mouse does not lock up the bus.



[    0.000000] Linux version 2.6.31r4 (root@energy) (gcc version 4.4.1 (Gentoo 
4.4.1 p1.0) ) #2 SMP Sat Sep 12 11:57:14 CEST 2009                                                             
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
[    0.000000]   #2 [0001000000 - 00015f88c0]    TEXT DATA BSS ==> [0001000000 
- 00015f88c0]   
[    0.000000]   #3 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 
- 0000100000]   
[    0.000000]   #4 [00015f9000 - 00015f9133]              BRK ==> [00015f9000 
- 00015f9133]   
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
[    0.000000] Node 0: aperture @ 221c000000 size 32 MB                                        
[    0.000000] Aperture beyond 4GB. Ignoring.                                                  
[    0.000000] Your BIOS doesn't leave a aperture memory hole                                  
[    0.000000] Please enable the IOMMU option in the BIOS setup                                
[    0.000000] This costs you 64 MB of RAM                                                     
[    0.000000] Mapping aperture over 65536 KB of RAM @ 20000000                                
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 
0000000024000000               
[    0.000000] Memory: 8184476k/9306112k available (3493k kernel code, 919300k 
absent, 201368k reserved, 1750k data, 376k init)                                                               
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1         
[    0.000000] NR_IRQS:4352 nr_irqs:440                                                        
[    0.000000] Fast TSC calibration using PIT                                                  
[    0.000000] Detected 3200.001 MHz processor.                                                
[    0.000608] Console: colour VGA+ 80x25                                                      
[    0.000611] console [tty0] enabled                                                          
[    0.003333] hpet clockevent registered                                                      
[    0.003333]   alloc irq_desc for 24 on node 0                                               
[    0.003333]   alloc kstat_irqs on node 0                                                    
[    0.003333] HPET: 4 timers in total, 1 timers will be used for per-cpu 
timer                
[    0.003338] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 6402.66 BogoMIPS (lpj=10666656)                                                                     
[    0.003420] Mount-cache hash table entries: 256                                             
[    0.003543] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003577] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003612] tseg: 0000000000                                                                
[    0.003618] CPU: Physical Processor ID: 0                                                   
[    0.003651] CPU: Processor Core ID: 0                                                       
[    0.003685] mce: CPU supports 6 MCE banks                                                   
[    0.003723] using C1E aware idle routine                                                    
[    0.003767] ACPI: Core revision 20090521                                                    
[    0.016703] Setting APIC routing to flat                                                    
[    0.017026] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1                            
[    0.051000] CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.053332] Booting processor 1 APIC 0x1 ip 0x6000                                          
[    0.003333] Initializing CPU#1                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666961)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 1                                                       
[    0.003333] mce: CPU supports 6 MCE banks                                                   
[    0.003333] x86 PAT enabled: cpu 1, old 0x7040600070406, new 
0x7010600070106                
[    0.144157] CPU1: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.144504] checking TSC synchronization [CPU#0 -> CPU#1]: passed.                          
[    0.146698] Booting processor 2 APIC 0x2 ip 0x6000                                          
[    0.003333] Initializing CPU#2                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666969)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 2                                                       
[    0.003333] mce: CPU supports 6 MCE banks                                                   
[    0.003333] x86 PAT enabled: cpu 2, old 0x7040600070406, new 
0x7010600070106                
[    0.240811] CPU2: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.241157] checking TSC synchronization [CPU#0 -> CPU#2]: passed.                          
[    0.243371] Booting processor 3 APIC 0x3 ip 0x6000                                          
[    0.003333] Initializing CPU#3                                                              
[    0.003333] Calibrating delay using timer specific routine.. 6402.85 
BogoMIPS (lpj=10666967)
[    0.003333] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 
bytes/line)               
[    0.003333] CPU: L2 Cache: 512K (64 bytes/line)                                             
[    0.003333] CPU: Physical Processor ID: 0                                                   
[    0.003333] CPU: Processor Core ID: 3                                                       
[    0.003333] mce: CPU supports 6 MCE banks                                                   
[    0.003333] x86 PAT enabled: cpu 3, old 0x7040600070406, new 
0x7010600070106                
[    0.337510] CPU3: AMD Phenom(tm) II X4 955 Processor stepping 02                            
[    0.337857] checking TSC synchronization [CPU#0 -> CPU#3]: passed.                          
[    0.340008] Brought up 4 CPUs                                                               
[    0.340041] Total of 4 processors activated (25610.22 BogoMIPS).                            
[    0.340110] CPU0 attaching sched-domain:                                                    
[    0.340112]  domain 0: span 0-3 level MC                                                    
[    0.340113]   groups: 0 1 2 3                                                               
[    0.340117] CPU1 attaching sched-domain:                                                    
[    0.340118]  domain 0: span 0-3 level MC                                                    
[    0.340119]   groups: 1 2 3 0                                                               
[    0.340121] CPU2 attaching sched-domain:                                                    
[    0.340122]  domain 0: span 0-3 level MC                                                    
[    0.340123]   groups: 2 3 0 1                                                               
[    0.340125] CPU3 attaching sched-domain:                                                    
[    0.340126]  domain 0: span 0-3 level MC                                                    
[    0.340127]   groups: 3 0 1 2                                                               
[    0.340391] xor: automatically using best checksumming function: 
generic_sse                
[    0.356667]    generic_sse: 12835.200 MB/sec                                                
[    0.356701] xor: using function: generic_sse (12835.200 MB/sec)                             
[    0.356754] Time: 15:44:26  Date: 09/14/09                                                  
[    0.356802] NET: Registered protocol family 16                                              
[    0.357118] node 0 link 0: io port [1000, ffffff]                                           
[    0.357121] TOM: 00000000c8000000 aka 3200M                                                 
[    0.357154] Fam 10h mmconf [e0000000, efffffff]                                             
[    0.357157] node 0 link 0: mmio [e0000000, efffffff] ==> none                               
[    0.357159] node 0 link 0: mmio [f0000000, ffffffff]                                        
[    0.357161] node 0 link 0: mmio [a0000, bffff]                                              
[    0.357163] node 0 link 0: mmio [c8000000, dfffffff]                                        
[    0.357164] TOM2: 0000000238000000 aka 9088M                                                
[    0.357198] bus: [00,07] on node 0 link 0                                                   
[    0.357199] bus: 00 index 0 io port: [0, ffff]                                              
[    0.357200] bus: 00 index 1 mmio: [f0000000, ffffffff]                                      
[    0.357201] bus: 00 index 2 mmio: [a0000, bffff]                                            
[    0.357202] bus: 00 index 3 mmio: [c8000000, dfffffff]                                      
[    0.357204] bus: 00 index 4 mmio: [238000000, fcffffffff]                                   
[    0.357217] ACPI: bus type pci registered                                                   
[    0.357323] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                
[    0.357358] PCI: Not using MMCONFIG.                                                        
[    0.357391] PCI: Using configuration type 1 for base access                                 
[    0.357425] PCI: Using configuration type 1 for extended access                             
[    0.359424] bio: create slab <bio-0> at 0                                                   
[    0.359890] ACPI: EC: Look up EC in DSDT                                                    
[    0.367274] ACPI: Interpreter enabled                                                       
[    0.367310] ACPI: (supports S0 S1 S3 S4 S5)                                                 
[    0.367909] ACPI: Using IOAPIC for interrupt routing                                        
[    0.367980] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255                
[    0.370685] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources               
[    0.376067] PCI: Using MMCONFIG at e0000000 - efffffff                                      
[    0.381353] ACPI: No dock devices found.                                                    
[    0.381648] ACPI: PCI Root Bridge [PCI0] (0000:00)                                          
[    0.381758] pci 0000:00:00.0: reg 1c 64bit mmio: [0xe0000000-0xffffffff]                    
[    0.381804] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold                           
[    0.381839] pci 0000:00:02.0: PME# disabled                                                 
[    0.381906] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold                           
[    0.381941] pci 0000:00:09.0: PME# disabled                                                 
[    0.382001] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold                           
[    0.382036] pci 0000:00:0a.0: PME# disabled                                                 
[    0.382115] pci 0000:00:11.0: reg 10 io port: [0xa000-0xa007]                               
[    0.382121] pci 0000:00:11.0: reg 14 io port: [0x9000-0x9003]                               
[    0.382127] pci 0000:00:11.0: reg 18 io port: [0x8000-0x8007]                               
[    0.382133] pci 0000:00:11.0: reg 1c io port: [0x7000-0x7003]                               
[    0.382139] pci 0000:00:11.0: reg 20 io port: [0x6000-0x600f]                               
[    0.382145] pci 0000:00:11.0: reg 24 32bit mmio: [0xfddff800-0xfddffbff]                    
[    0.382193] pci 0000:00:12.0: reg 10 32bit mmio: [0xfddfe000-0xfddfefff]                    
[    0.382244] pci 0000:00:12.1: reg 10 32bit mmio: [0xfddfd000-0xfddfdfff]                    
[    0.382312] pci 0000:00:12.2: reg 10 32bit mmio: [0xfddff000-0xfddff0ff]                    
[    0.382362] pci 0000:00:12.2: supports D1 D2                                                
[    0.382363] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot                            
[    0.382399] pci 0000:00:12.2: PME# disabled                                                 
[    0.382461] pci 0000:00:13.0: reg 10 32bit mmio: [0xfddfc000-0xfddfcfff]                    
[    0.382511] pci 0000:00:13.1: reg 10 32bit mmio: [0xfddf7000-0xfddf7fff]                    
[    0.382579] pci 0000:00:13.2: reg 10 32bit mmio: [0xfddf6800-0xfddf68ff]                    
[    0.382629] pci 0000:00:13.2: supports D1 D2                                                
[    0.382630] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot                            
[    0.382666] pci 0000:00:13.2: PME# disabled                                                 
[    0.382808] pci 0000:00:14.1: reg 10 io port: [0x00-0x07]                                   
[    0.382814] pci 0000:00:14.1: reg 14 io port: [0x00-0x03]                                   
[    0.382819] pci 0000:00:14.1: reg 18 io port: [0x00-0x07]                                   
[    0.382825] pci 0000:00:14.1: reg 1c io port: [0x00-0x03]                                   
[    0.382830] pci 0000:00:14.1: reg 20 io port: [0xff00-0xff0f]                               
[    0.382955] pci 0000:00:14.5: reg 10 32bit mmio: [0xfddf5000-0xfddf5fff]                    
[    0.383088] pci 0000:02:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]                    
[    0.383095] pci 0000:02:00.0: reg 18 64bit mmio: [0xfdff0000-0xfdffffff]                    
[    0.383099] pci 0000:02:00.0: reg 20 io port: [0xc000-0xc0ff]                               
[    0.383107] pci 0000:02:00.0: reg 30 32bit mmio: [0xfdfc0000-0xfdfdffff]                    
[    0.383122] pci 0000:02:00.0: supports D1 D2                                                
[    0.383150] pci 0000:02:00.1: reg 10 64bit mmio: [0xfdfec000-0xfdfeffff]                    
[    0.383180] pci 0000:02:00.1: supports D1 D2                                                
[    0.383230] pci 0000:00:02.0: bridge io port: [0xc000-0xcfff]                               
[    0.383232] pci 0000:00:02.0: bridge 32bit mmio: [0xfdf00000-0xfdffffff]                    
[    0.383235] pci 0000:00:02.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]               
[    0.383278] pci 0000:00:09.0: bridge io port: [0xd000-0xdfff]                               
[    0.383280] pci 0000:00:09.0: bridge 32bit mmio: [0xfe000000-0xfebfffff]                    
[    0.383283] pci 0000:00:09.0: bridge 64bit mmio pref: [0xfa000000-0xfcefffff]               
[    0.383313] pci 0000:01:00.0: reg 10 io port: [0xb800-0xb8ff]                               
[    0.383338] pci 0000:01:00.0: reg 18 64bit mmio: [0xcffff000-0xcfffffff]                    
[    0.383348] pci 0000:01:00.0: reg 20 64bit mmio: [0xcffe0000-0xcffeffff]                    
[    0.383354] pci 0000:01:00.0: reg 30 32bit mmio: [0xfdef0000-0xfdefffff]                    
[    0.383381] pci 0000:01:00.0: supports D1 D2                                                
[    0.383382] pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold                     
[    0.383418] pci 0000:01:00.0: PME# disabled                                                 
[    0.383504] pci 0000:00:0a.0: bridge io port: [0xb000-0xbfff]                               
[    0.383506] pci 0000:00:0a.0: bridge 32bit mmio: [0xfde00000-0xfdefffff]                    
[    0.383509] pci 0000:00:0a.0: bridge 64bit mmio pref: [0xcff00000-0xcfffffff]               
[    0.383544] pci 0000:05:06.0: reg 10 32bit mmio: [0xfcfff000-0xfcffffff]                    
[    0.383623] pci 0000:05:08.0: reg 10 io port: [0xe800-0xe83f]                               
[    0.383680] pci 0000:05:08.0: supports D1 D2                                                
[    0.383722] pci 0000:00:14.4: transparent bridge                                            
[    0.383758] pci 0000:00:14.4: bridge io port: [0xe000-0xefff]                               
[    0.383764] pci 0000:00:14.4: bridge 32bit mmio pref: [0xfcf00000-0xfcffffff]               
[    0.383776] pci_bus 0000:00: on NUMA node 0                                                 
[    0.383779] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]                             
[    0.383912] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]                        
[    0.383959] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]                        
[    0.384004] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]                        
[    0.384069] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE9._PRT]                        
[    0.386985] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 *7 10 11 12 14 15)                      
[    0.387213] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 *11 12 14 15)                      
[    0.387440] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 12 14 15)                      
[    0.387666] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 *10 11 12 14 15)                      
[    0.387892] ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, 
disabled.         
[    0.388163] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 *11 12 14 15)                      
[    0.388389] ACPI: PCI Interrupt Link [LNKG] (IRQs *4 10 11 12 14 15)                        
[    0.388601] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 *10 11 12 14 15)                      
[    0.388957] SCSI subsystem initialized                                                      
[    0.389049] libata version 3.00 loaded.                                                     
[    0.389111] usbcore: registered new interface driver usbfs                                  
[    0.389170] usbcore: registered new interface driver hub                                    
[    0.389235] usbcore: registered new device driver usb                                       
[    0.443350] raid6: int64x1   2759 MB/s                                                      
[    0.500018] raid6: int64x2   3868 MB/s                                                      
[    0.556679] raid6: int64x4   2864 MB/s                                                      
[    0.613343] raid6: int64x8   2533 MB/s                                                      
[    0.670008] raid6: sse2x1    3998 MB/s                                                      
[    0.726668] raid6: sse2x2    6801 MB/s                                                      
[    0.783341] raid6: sse2x4    7989 MB/s                                                      
[    0.783375] raid6: using algorithm sse2x4 (7989 MB/s)                                       
[    0.783458] PCI: Using ACPI for IRQ routing                                                 
[    0.783497] pci 0000:00:00.0: BAR 3: address space collision on of device 
[0xe0000000-0xffffffff]                                                                                          
[    0.783551] pci 0000:00:00.0: BAR 3: can't allocate resource                                
[    0.796892] PCI-DMA: Disabling AGP.                                                         
[    0.797008] PCI-DMA: aperture base @ 20000000 size 65536 KB                                 
[    0.797042] PCI-DMA: using GART IOMMU.                                                      
[    0.797076] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture                       
[    0.798882] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 0                                     
[    0.798989] hpet0: 4 comparators, 32-bit 14.318180 MHz counter                              
[    0.803361] hpet: hpet2 irq 24 for MSI                                                      
[    0.813349] Switched to high resolution mode on CPU 0                                       
[    0.814512] Switched to high resolution mode on CPU 2                                       
[    0.814522] Switched to high resolution mode on CPU 1                                       
[    0.814542] Switched to high resolution mode on CPU 3                                       
[    0.823365] pnp: PnP ACPI init                                                              
[    0.823416] ACPI: bus type pnp registered                                                   
[    0.825652] pnp 00:0b: mem resource (0x0-0x9ffff) overlaps 0000:00:00.0 BAR 3 
(0x0-0x1fffffff), disabling                                                                                  
[    0.825707] pnp 00:0b: mem resource (0xc0000-0xcffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                                                                              
[    0.825762] pnp 00:0b: mem resource (0xe0000-0xfffff) overlaps 0000:00:00.0 
BAR 3 (0x0-0x1fffffff), disabling                                                                              
[    0.825816] pnp 00:0b: mem resource (0x100000-0xc7efffff) overlaps 
0000:00:00.0 BAR 3 (0x0-0x1fffffff), disabling                                                                          
[    0.826121] pnp: PnP ACPI: found 12 devices                                                 
[    0.826154] ACPI: ACPI bus type pnp unregistered                                            
[    0.826195] system 00:06: iomem range 0xfec00000-0xfec00fff could not be 
reserved           
[    0.826248] system 00:06: iomem range 0xfee00000-0xfee00fff has been 
reserved               
[    0.826286] system 00:07: ioport range 0x4d0-0x4d1 has been reserved                        
[    0.826321] system 00:07: ioport range 0x40b-0x40b has been reserved                        
[    0.826355] system 00:07: ioport range 0x4d6-0x4d6 has been reserved                        
[    0.826390] system 00:07: ioport range 0xc00-0xc01 has been reserved                        
[    0.826425] system 00:07: ioport range 0xc14-0xc14 has been reserved                        
[    0.826460] system 00:07: ioport range 0xc50-0xc51 has been reserved                        
[    0.826494] system 00:07: ioport range 0xc52-0xc52 has been reserved                        
[    0.826529] system 00:07: ioport range 0xc6c-0xc6c has been reserved                        
[    0.826564] system 00:07: ioport range 0xc6f-0xc6f has been reserved                        
[    0.826598] system 00:07: ioport range 0xcd0-0xcd1 has been reserved                        
[    0.826633] system 00:07: ioport range 0xcd2-0xcd3 has been reserved                        
[    0.826684] system 00:07: ioport range 0xcd4-0xcd5 has been reserved                        
[    0.826719] system 00:07: ioport range 0xcd6-0xcd7 has been reserved                        
[    0.826754] system 00:07: ioport range 0xcd8-0xcdf has been reserved                        
[    0.826788] system 00:07: ioport range 0x800-0x89f has been reserved                        
[    0.826823] system 00:07: ioport range 0xb00-0xb0f has been reserved                        
[    0.826858] system 00:07: ioport range 0xb20-0xb3f has been reserved                        
[    0.826893] system 00:07: ioport range 0x900-0x90f has been reserved                        
[    0.826927] system 00:07: ioport range 0x910-0x91f has been reserved                        
[    0.826962] system 00:07: ioport range 0xfe00-0xfefe has been reserved                      
[    0.826997] system 00:07: iomem range 0xffb80000-0xffbfffff has been reserved               
[    0.827033] system 00:07: iomem range 0xfec10000-0xfec1001f has been 
reserved               
[    0.827069] system 00:09: ioport range 0x290-0x29f has been reserved                        
[    0.827105] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved               
[    0.827142] system 00:0b: iomem range 0xfec00000-0xffffffff could not be 
reserved           
[    0.832032] pci 0000:00:02.0: PCI bridge, secondary bus 0000:02                             
[    0.832067] pci 0000:00:02.0:   IO window: 0xc000-0xcfff                                    
[    0.832103] pci 0000:00:02.0:   MEM window: 0xfdf00000-0xfdffffff                           
[    0.832138] pci 0000:00:02.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff          
[    0.832193] pci 0000:00:09.0: PCI bridge, secondary bus 0000:03                             
[    0.832228] pci 0000:00:09.0:   IO window: 0xd000-0xdfff                                    
[    0.832263] pci 0000:00:09.0:   MEM window: 0xfe000000-0xfebfffff                           
[    0.832298] pci 0000:00:09.0:   PREFETCH window: 
0x000000fa000000-0x000000fcefffff          
[    0.832353] pci 0000:00:0a.0: PCI bridge, secondary bus 0000:01                             
[    0.832387] pci 0000:00:0a.0:   IO window: 0xb000-0xbfff                                    
[    0.832422] pci 0000:00:0a.0:   MEM window: 0xfde00000-0xfdefffff                           
[    0.832457] pci 0000:00:0a.0:   PREFETCH window: 
0x000000cff00000-0x000000cfffffff          
[    0.832512] pci 0000:00:14.4: PCI bridge, secondary bus 0000:05                             
[    0.832547] pci 0000:00:14.4:   IO window: 0xe000-0xefff                                    
[    0.832585] pci 0000:00:14.4:   MEM window: disabled                                        
[    0.832621] pci 0000:00:14.4:   PREFETCH window: 0xfcf00000-0xfcffffff                      
[    0.832662]   alloc irq_desc for 18 on node -1                                              
[    0.832663]   alloc kstat_irqs on node -1                                                   
[    0.832666] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                    
[    0.832703] pci 0000:00:02.0: setting latency timer to 64                                   
[    0.832707]   alloc irq_desc for 17 on node -1                                              
[    0.832708]   alloc kstat_irqs on node -1                                                   
[    0.832710] pci 0000:00:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17                    
[    0.832746] pci 0000:00:09.0: setting latency timer to 64                                   
[    0.832749] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                    
[    0.832784] pci 0000:00:0a.0: setting latency timer to 64                                   
[    0.832791] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]                                  
[    0.832792] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]                  
[    0.832794] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]                                
[    0.832796] pci_bus 0000:02: resource 1 mem: [0xfdf00000-0xfdffffff]                        
[    0.832797] pci_bus 0000:02: resource 2 pref mem [0xd0000000-0xdfffffff]                    
[    0.832799] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]                                
[    0.832800] pci_bus 0000:03: resource 1 mem: [0xfe000000-0xfebfffff]                        
[    0.832802] pci_bus 0000:03: resource 2 pref mem [0xfa000000-0xfcefffff]                    
[    0.832803] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]                                
[    0.832805] pci_bus 0000:01: resource 1 mem: [0xfde00000-0xfdefffff]                        
[    0.832806] pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xcfffffff]                    
[    0.832808] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]                                
[    0.832809] pci_bus 0000:05: resource 2 pref mem [0xfcf00000-0xfcffffff]                    
[    0.832810] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]                                  
[    0.832812] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]                  
[    0.832823] NET: Registered protocol family 2                                               
[    0.832879] IP route cache hash table entries: 262144 (order: 9, 2097152 
bytes)             
[    0.833358] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)           
[    0.834323] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)                    
[    0.834721] TCP: Hash tables configured (established 262144 bind 65536)                     
[    0.834756] TCP reno registered                                                             
[    0.834834] NET: Registered protocol family 1                                               
[    0.836004] Scanning for low memory corruption every 60 seconds                             
[    0.836750] HugeTLB registered 2 MB page size, pre-allocated 0 pages                        
[    0.836881] Loading Reiser4. See www.namesys.com for a description of 
Reiser4.              
[    0.836966] msgmni has been set to 15987                                                    
[    0.837278] alg: No test for stdrng (krng)                                                  
[    0.837322] async_tx: api initialized (sync-only)                                           
[    0.837397] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)            
[    0.837450] io scheduler noop registered                                                    
[    0.837485] io scheduler cfq registered (default)                                           
[    0.837608] pci 0000:02:00.0: Boot video device                                             
[    0.837699]   alloc irq_desc for 25 on node -1                                              
[    0.837700]   alloc kstat_irqs on node -1                                                   
[    0.837706] pcieport-driver 0000:00:02.0: irq 25 for MSI/MSI-X                              
[    0.837711] pcieport-driver 0000:00:02.0: setting latency timer to 64                       
[    0.837801]   alloc irq_desc for 26 on node -1                                              
[    0.837802]   alloc kstat_irqs on node -1                                                   
[    0.837805] pcieport-driver 0000:00:09.0: irq 26 for MSI/MSI-X                              
[    0.837809] pcieport-driver 0000:00:09.0: setting latency timer to 64                       
[    0.837899]   alloc irq_desc for 27 on node -1                                              
[    0.837900]   alloc kstat_irqs on node -1                                                   
[    0.837902] pcieport-driver 0000:00:0a.0: irq 27 for MSI/MSI-X                              
[    0.837906] pcieport-driver 0000:00:0a.0: setting latency timer to 64                       
[    0.838103] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0            
[    0.838156] ACPI: Power Button [PWRF]                                                       
[    0.838246] input: Power Button as 
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1   
[    0.838299] ACPI: Power Button [PWRB]                                                       
[    0.838450] processor LNXCPU:00: registered as cooling_device0                              
[    0.838485] ACPI: Processor [CPU0] (supports 8 throttling states)                           
[    0.838583] processor LNXCPU:01: registered as cooling_device1                              
[    0.838652] processor LNXCPU:02: registered as cooling_device2                              
[    0.838723] processor LNXCPU:03: registered as cooling_device3                              
[    0.842369] Linux agpgart interface v0.103                                                  
[    0.842561] ahci 0000:00:11.0: version 3.0                                                  
[    0.842570]   alloc irq_desc for 22 on node -1                                              
[    0.842571]   alloc kstat_irqs on node -1                                                   
[    0.842575] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22                   
[    0.842724] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode   
[    0.842779] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio 
slum part      
[    0.843317] scsi0 : ahci                                                                    
[    0.843462] scsi1 : ahci                                                                    
[    0.843559] scsi2 : ahci                                                                    
[    0.843653] scsi3 : ahci                                                                    
[    0.843748] scsi4 : ahci                                                                    
[    0.843843] scsi5 : ahci                                                                    
[    0.843972] ata1: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed                    
[    0.844009] ata2: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddff980 irq 
22            
[    0.844063] ata3: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa00 irq 
22            
[    0.844117] ata4: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffa80 irq 
22            
[    0.844171] ata5: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb00 irq 
22            
[    0.844225] ata6: SATA max UDMA/133 abar m1024@0xfddff800 port 0xfddffb80 irq 
22            
[    0.844490] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1                          
[    0.844525] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp                                                                                 
[    0.845074] serio: i8042 KBD port at 0x60,0x64 irq 1                                        
[    0.845226] mice: PS/2 mouse device common for all mice                                     
[    0.845388] rtc_cmos 00:02: RTC can wake from S4                                            
[    0.845455] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0                           
[    0.845510] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs                   
[    0.845566] md: raid1 personality registered for level 1                                    
[    0.845601] md: raid6 personality registered for level 6                                    
[    0.845635] md: raid5 personality registered for level 5                                    
[    0.845669] md: raid4 personality registered for level 4                                    
[    0.845751] cpuidle: using governor ladder                                                  
[    0.846773] usbcore: registered new interface driver hiddev                                 
[    0.846828] usbcore: registered new interface driver usbhid                                 
[    0.846862] usbhid: v2.6:USB HID core driver                                                
[    0.846923] Advanced Linux Sound Architecture Driver Version 1.0.20.                        
[    0.846957] ALSA device list:                                                               
[    0.846991]   No soundcards found.                                                          
[    0.847057] TCP cubic registered                                                            
[    0.847097] NET: Registered protocol family 10                                              
[    0.847220] IPv6 over IPv4 tunneling driver                                                 
[    0.847333] NET: Registered protocol family 17                                              
[    0.847382] powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor 
processors (4 cpu cores) (version 2.20.00)                                                                             
[    0.847458] powernow-k8:    0 : pstate 0 (3200 MHz)                                         
[    0.847492] powernow-k8:    1 : pstate 1 (2500 MHz)                                         
[    0.847526] powernow-k8:    2 : pstate 2 (2100 MHz)                                         
[    0.847559] powernow-k8:    3 : pstate 3 (800 MHz)                                          
[    0.847947] PM: Resume from disk failed.                                                    
[    0.848029]   Magic number: 9:345:740                                                       
[    0.872022] input: AT Translated Set 2 keyboard as 
/devices/platform/i8042/serio0/input/input2                                                                                             
[    1.163786] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.163848] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.163901] ata6: SATA link down (SStatus 0 SControl 300)                                   
[    1.163955] ata5: SATA link down (SStatus 0 SControl 300)                                   
[    1.164009] ata3: SATA link down (SStatus 0 SControl 300)                                   
[    1.170138] ata4.00: ATA-7: SAMSUNG HD753LJ, 1AA01113, max UDMA7                            
[    1.170179] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 31/32)                   
[    1.170227] ata2.00: ATA-7: SAMSUNG HD502IJ, 1AA01110, max UDMA7                            
[    1.170261] ata2.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                    
[    1.176634] ata4.00: configured for UDMA/133                                                
[    1.176695] ata2.00: configured for UDMA/133                                                
[    1.563784] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)                          
[    1.570131] ata1.00: ATA-7: SAMSUNG HD502IJ, 1AA01109, max UDMA7                            
[    1.570167] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)                    
[    1.576588] ata1.00: configured for UDMA/133                                                
[    1.588000] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5    
[    1.588249] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 
GB/465 GiB)           
[    1.588320] sd 0:0:0:0: [sda] Write Protect is off                                          
[    1.588355] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00                                       
[    1.588363] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.588473]  sda:                                                                           
[    1.588511] sd 0:0:0:0: Attached scsi generic sg0 type 0                                    
[    1.588653] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 
PQ: 0 ANSI: 5    
[    1.588820] sd 1:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 
GB/465 GiB)           
[    1.588890] sd 1:0:0:0: [sdb] Write Protect is off                                          
[    1.588925] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00                                       
[    1.588934] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.589041]  sdb:                                                                           
[    1.589124] sd 1:0:0:0: Attached scsi generic sg1 type 0                                    
[    1.589287] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 
PQ: 0 ANSI: 5    
[    1.589455] sd 3:0:0:0: [sdc] 1465149168 512-byte logical blocks: (750 
GB/698 GiB)          
[    1.589508] sd 3:0:0:0: Attached scsi generic sg2 type 0                                    
[    1.589558] sd 3:0:0:0: [sdc] Write Protect is off                                          
[    1.589592] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00                                       
[    1.589600] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA                                                                                        
[    1.589695]  sdc: sdb1 sdb2 sdb3 sdb4 < sda1 sda2 sda3 sda4 < sdb5 sdc1 
sdc2 sdc3 sdc4 < sda5 sdc5 sdb6 >                                                                                  
[    1.610148] sd 1:0:0:0: [sdb] Attached SCSI disk                                            
[    1.614506]  sda6 >                                                                         
[    1.614860] sd 0:0:0:0: [sda] Attached SCSI disk                                            
[    1.615476]  sdc6 sdc7 >                                                                    
[    1.629040] sd 3:0:0:0: [sdc] Attached SCSI disk                                            
[    1.629082] md: Waiting for all devices to be available before autodetect                   
[    1.629117] md: If you don't use raid, use raid=noautodetect                                
[    1.629228] md: Autodetecting RAID arrays.                                                  
[    1.735434] md: Scanned 12 and added 12 devices.                                            
[    1.735469] md: autorun ...                                                                 
[    1.735503] md: considering sdc6 ...                                                        
[    1.735538] md:  adding sdc6 ...                                                            
[    1.735573] md: sdc5 has different UUID to sdc6                                             
[    1.735607] md: sdc3 has different UUID to sdc6                                             
[    1.735642] md: sdc1 has different UUID to sdc6                                             
[    1.735677] md:  adding sda6 ...                                                            
[    1.735712] md: sda5 has different UUID to sdc6                                             
[    1.735746] md: sda3 has different UUID to sdc6                                             
[    1.735781] md: sda1 has different UUID to sdc6                                             
[    1.735816] md:  adding sdb6 ...                                                            
[    1.735850] md: sdb5 has different UUID to sdc6                                             
[    1.735885] md: sdb3 has different UUID to sdc6                                             
[    1.735920] md: sdb1 has different UUID to sdc6                                             
[    1.736052] md: created md3                                                                 
[    1.736085] md: bind<sdb6>                                                                  
[    1.736122] md: bind<sda6>                                                                  
[    1.736158] md: bind<sdc6>                                                                  
[    1.736194] md: running: <sdc6><sda6><sdb6>                                                 
[    1.736328] raid5: device sdc6 operational as raid disk 2                                   
[    1.736363] raid5: device sda6 operational as raid disk 0                                   
[    1.736397] raid5: device sdb6 operational as raid disk 1                                   
[    1.736549] raid5: allocated 3220kB for md3                                                 
[    1.736607] raid5: raid level 5 set md3 active with 3 out of 3 devices, 
algorithm 2         
[    1.736660] RAID5 conf printout:                                                            
[    1.736695]  --- rd:3 wd:3                                                                  
[    1.736728]  disk 0, o:1, dev:sda6                                                          
[    1.736762]  disk 1, o:1, dev:sdb6                                                          
[    1.736795]  disk 2, o:1, dev:sdc6                                                          
[    1.736843] md3: detected capacity change from 0 to 864065421312                            
[    1.736914] md: considering sdc5 ...                                                        
[    1.736950] md:  adding sdc5 ...                                                            
[    1.736984] md: sdc3 has different UUID to sdc5                                             
[    1.737019] md: sdc1 has different UUID to sdc5                                             
[    1.737054] md:  adding sda5 ...                                                            
[    1.737088] md: sda3 has different UUID to sdc5                                             
[    1.737123] md: sda1 has different UUID to sdc5                                             
[    1.737159] md:  adding sdb5 ...                                                            
[    1.737193] md: sdb3 has different UUID to sdc5                                             
[    1.737228] md: sdb1 has different UUID to sdc5                                             
[    1.737326] md: created md2                                                                 
[    1.737360] md: bind<sdb5>                                                                  
[    1.737396] md: bind<sda5>                                                                  
[    1.737432] md: bind<sdc5>                                                                  
[    1.737467] md: running: <sdc5><sda5><sdb5>                                                 
[    1.737598] raid5: device sdc5 operational as raid disk 2                                   
[    1.737627] raid5: device sda5 operational as raid disk 0                                   
[    1.737661] raid5: device sdb5 operational as raid disk 1                                   
[    1.737816] raid5: allocated 3220kB for md2                                                 
[    1.737878] raid5: raid level 5 set md2 active with 3 out of 3 devices, 
algorithm 2         
[    1.737940] RAID5 conf printout:                                                            
[    1.737973]  --- rd:3 wd:3                                                                  
[    1.738006]  disk 0, o:1, dev:sda5                                                          
[    1.738039]  disk 1, o:1, dev:sdb5                                                          
[    1.738072]  disk 2, o:1, dev:sdc5                                                          
[    1.738118] md2: detected capacity change from 0 to 40007499776                             
[    1.738186] md: considering sdc3 ...                                                        
[    1.738222] md:  adding sdc3 ...                                                            
[    1.738256] md: sdc1 has different UUID to sdc3                                             
[    1.738292] md:  adding sda3 ...                                                            
[    1.738326] md: sda1 has different UUID to sdc3                                             
[    1.738361] md:  adding sdb3 ...                                                            
[    1.738395] md: sdb1 has different UUID to sdc3                                             
[    1.738495] md: created md1                                                                 
[    1.738529] md: bind<sdb3>                                                                  
[    1.738565] md: bind<sda3>                                                                  
[    1.738601] md: bind<sdc3>                                                                  
[    1.738637] md: running: <sdc3><sda3><sdb3>                                                 
[    1.738777] raid5: device sdc3 operational as raid disk 2                                   
[    1.738811] raid5: device sda3 operational as raid disk 0                                   
[    1.738845] raid5: device sdb3 operational as raid disk 1                                   
[    1.739004] raid5: allocated 3220kB for md1                                                 
[    1.739053] raid5: raid level 5 set md1 active with 3 out of 3 devices, 
algorithm 2         
[    1.739106] RAID5 conf printout:                                                            
[    1.739139]  --- rd:3 wd:3                                                                  
[    1.739172]  disk 0, o:1, dev:sda3                                                          
[    1.739205]  disk 1, o:1, dev:sdb3                                                          
[    1.739239]  disk 2, o:1, dev:sdc3                                                          
[    1.739287] md1: detected capacity change from 0 to 79998877696                             
[    1.739355] md: considering sdc1 ...                                                        
[    1.739391] md:  adding sdc1 ...                                                            
[    1.739426] md:  adding sda1 ...                                                            
[    1.739461] md:  adding sdb1 ...                                                            
[    1.739494] md: created md0                                                                 
[    1.739527] md: bind<sdb1>                                                                  
[    1.739563] md: bind<sda1>                                                                  
[    1.739599] md: bind<sdc1>                                                                  
[    1.739635] md: running: <sdc1><sda1><sdb1>                                                 
[    1.739812] raid1: raid set md0 active with 3 out of 3 mirrors                              
[    1.739857] md0: detected capacity change from 0 to 65667072                                
[    1.739913] md: ... autorun DONE.                                                           
[    1.739965] md: Loading md3: /dev/sda3                                                      
[    1.740004]  md3: unknown partition table                                                   
[    1.740162] md: couldn't update array info. -22                                             
[    1.740200] md: could not bd_claim sda3.                                                    
[    1.740234] md: md_import_device returned -16                                               
[    1.740270] md: could not bd_claim sdb3.                                                    
[    1.740303] md: md_import_device returned -16                                               
[    1.740339] md: could not bd_claim sdc3.                                                    
[    1.740372] md: md_import_device returned -16                                               
[    1.740407] md: starting md3 failed                                                         
[    1.740480]  md1: unknown partition table                                                   
[    1.778802] reiser4: md1: found disk format 4.0.0.                                          
[    5.781805] VFS: Mounted root (reiser4 filesystem) readonly on device 9:1.                  
[    5.781857] Freeing unused kernel memory: 376k freed                                        
[    8.975188] udev: starting version 145                                                      
[    9.126811]  md0:                                                                           
[    9.128322]  md2: unknown partition table                                                   
[    9.161557]  unknown partition table                                                        
[    9.967391] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded                                 
[    9.967405] r8169 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                  
[    9.967641] r8169 0000:01:00.0: setting latency timer to 64                                 
[    9.967672]   alloc irq_desc for 28 on node -1                                              
[    9.967673]   alloc kstat_irqs on node -1                                                   
[    9.967683] r8169 0000:01:00.0: irq 28 for MSI/MSI-X                                        
[    9.967778] eth0: RTL8168c/8111c at 0xffffc90013002000, 00:19:66:86:ce:12, 
XID 3c4000c0 IRQ 28                                                                                             
[   10.004217] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver                      
[   10.004219] ehci_hcd: block sizes: qh 192 qtd 96 itd 192 sitd 96                            
[   10.004245] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 
17               
[   10.004280] ehci_hcd 0000:00:12.2: EHCI Host Controller                                     
[   10.004294] drivers/usb/core/inode.c: creating file 'devices'                               
[   10.004297] drivers/usb/core/inode.c: creating file '001'                                   
[   10.004330] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus 
number 1            
[   10.004336] ehci_hcd 0000:00:12.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                                         
[   10.004340] ehci_hcd 0000:00:12.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024      
[   10.004361] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze 
workaround           
[   10.004367] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[   10.004379] ehci_hcd 0000:00:12.2: debug port 1                                             
[   10.004384] ehci_hcd 0000:00:12.2: MWI active                                               
[   10.004385] ehci_hcd 0000:00:12.2: supports USB remote wakeup                               
[   10.004399] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfddff000                                
[   10.004402] ehci_hcd 0000:00:12.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[   10.004407] ehci_hcd 0000:00:12.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN    
[   10.014600] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00                               
[   10.014633] usb usb1: default language 0x0409                                               
[   10.014637] usb usb1: udev 1, busnum 1, minor = 0                                           
[   10.014639] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002                   
[   10.014640] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[   10.014642] usb usb1: Product: EHCI Host Controller                                         
[   10.014643] usb usb1: Manufacturer: Linux 2.6.31r4 ehci_hcd                                 
[   10.014644] usb usb1: SerialNumber: 0000:00:12.2                                            
[   10.014671] usb usb1: uevent                                                                
[   10.014680] usb usb1: usb_probe_device                                                      
[   10.014682] usb usb1: configuration #1 chosen from 1 choice                                 
[   10.014687] usb usb1: adding 1-0:1.0 (config #1, interface 0)                               
[   10.014694] usb 1-0:1.0: uevent                                                             
[   10.014701] hub 1-0:1.0: usb_probe_interface                                                
[   10.014702] hub 1-0:1.0: usb_probe_interface - got id                                       
[   10.014704] hub 1-0:1.0: USB hub found                                                      
[   10.014708] hub 1-0:1.0: 6 ports detected                                                   
[   10.014709] hub 1-0:1.0: standalone hub                                                     
[   10.014710] hub 1-0:1.0: no power switching (usb 1.0)                                       
[   10.014711] hub 1-0:1.0: individual port over-current protection                            
[   10.014712] hub 1-0:1.0: power on to power good time: 20ms                                  
[   10.014715] hub 1-0:1.0: local power source is good                                         
[   10.014717] hub 1-0:1.0: trying to enable port power on non-switchable hub                  
[   10.014742] drivers/usb/core/inode.c: creating file '001'                                   
[   10.014760]   alloc irq_desc for 19 on node -1                                              
[   10.014762]   alloc kstat_irqs on node -1                                                   
[   10.014765] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 
19               
[   10.014776] ehci_hcd 0000:00:13.2: EHCI Host Controller                                     
[   10.014779] drivers/usb/core/inode.c: creating file '002'                                   
[   10.014795] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus 
number 2            
[   10.014800] ehci_hcd 0000:00:13.2: reset hcs_params 0x102306 dbg=1 cc=2 
pcc=3 ordered !ppc ports=6                                                                                         
[   10.014803] ehci_hcd 0000:00:13.2: reset hcc_params a072 thresh 7 uframes 
256/512/1024      
[   10.014816] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze 
workaround           
[   10.014822] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[   10.014834] ehci_hcd 0000:00:13.2: debug port 1                                             
[   10.014837] ehci_hcd 0000:00:13.2: MWI active                                               
[   10.014838] ehci_hcd 0000:00:13.2: supports USB remote wakeup                               
[   10.014847] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfddf6800                                
[   10.014850] ehci_hcd 0000:00:13.2: reset command 080002 (park)=0 ithresh=8 
period=1024 Reset HALT                                                                                          
[   10.014856] ehci_hcd 0000:00:13.2: init command 010009 (park)=0 ithresh=1 
period=256 RUN    
[   10.024597] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00                               
[   10.024611] usb usb2: default language 0x0409                                               
[   10.024614] usb usb2: udev 1, busnum 2, minor = 128                                         
[   10.024615] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002                   
[   10.024617] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1              
[   10.024618] usb usb2: Product: EHCI Host Controller                                         
[   10.024619] usb usb2: Manufacturer: Linux 2.6.31r4 ehci_hcd                                 
[   10.024620] usb usb2: SerialNumber: 0000:00:13.2                                            
[   10.024644] usb usb2: uevent                                                                
[   10.024651] usb usb2: usb_probe_device                                                      
[   10.024653] usb usb2: configuration #1 chosen from 1 choice                                 
[   10.024656] usb usb2: adding 2-0:1.0 (config #1, interface 0)                               
[   10.024664] usb 2-0:1.0: uevent                                                             
[   10.024669] hub 2-0:1.0: usb_probe_interface                                                
[   10.024670] hub 2-0:1.0: usb_probe_interface - got id                                       
[   10.024671] hub 2-0:1.0: USB hub found                                                      
[   10.024675] hub 2-0:1.0: 6 ports detected                                                   
[   10.024676] hub 2-0:1.0: standalone hub                                                     
[   10.024677] hub 2-0:1.0: no power switching (usb 1.0)                                       
[   10.024678] hub 2-0:1.0: individual port over-current protection                            
[   10.024679] hub 2-0:1.0: power on to power good time: 20ms                                  
[   10.024681] hub 2-0:1.0: local power source is good                                         
[   10.024683] hub 2-0:1.0: trying to enable port power on non-switchable hub                  
[   10.024706] drivers/usb/core/inode.c: creating file '001'                                   
[   10.037996] Linux video capture interface: v2.00                                            
[   10.047459] bttv: driver version 0.9.18 loaded                                              
[   10.047461] bttv: using 8 buffers with 2080k (520 pages) each for capture                   
[   10.047522] bttv: Bt8xx card found (0).                                                     
[   10.047530]   alloc irq_desc for 21 on node -1                                              
[   10.047531]   alloc kstat_irqs on node -1                                                   
[   10.047535] bttv 0000:05:06.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21                   
[   10.047544] bttv0: Bt848 (rev 18) at 0000:05:06.0, irq: 21, latency: 128, 
mmio: 0xfcfff000  
[   10.047577] bttv0: using: Terratec TerraTV+ Version 1.0 (Bt848)/ Terra 
TValue Version 1.0/ Vobis TV-Boostar [card=25,insmod option]                                                        
[   10.047579] IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs                    
[   10.047611] bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]                       
[   10.114604] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001803 POWER 
sig=j CSC CONNECT   
[   10.114606] hub 1-0:1.0: port 2: status 0501 change 0001                                    
[   10.124614] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000                                  
[   10.214600] hub 1-0:1.0: state 7 ports 6 chg 0004 evt 0000                                  
[   10.214609] hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s                         
[   10.267115] ehci_hcd 0000:00:12.2: port 2 high speed                                        
[   10.267119] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT  
[   10.320436] usb 1-2: new high speed USB device using ehci_hcd and address 2                 
[   10.373786] ehci_hcd 0000:00:12.2: port 2 high speed                                        
[   10.373789] ehci_hcd 0000:00:12.2: GetStatus port 2 status 001005 POWER 
sig=se0 PE CONNECT  
[   10.445269] usb 1-2: default language 0x0409                                                
[   10.445518] usb 1-2: udev 2, busnum 1, minor = 1                                            
[   10.445519] usb 1-2: New USB device found, idVendor=05e3, idProduct=0608                    
[   10.445521] usb 1-2: New USB device strings: Mfr=0, Product=1, 
SerialNumber=0               
[   10.445522] usb 1-2: Product: USB2.0 Hub                                                    
[   10.445559] usb 1-2: uevent                                                                 
[   10.445568] usb 1-2: usb_probe_device                                                       
[   10.445570] usb 1-2: configuration #1 chosen from 1 choice                                  
[   10.445989] usb 1-2: adding 1-2:1.0 (config #1, interface 0)                                
[   10.445999] usb 1-2:1.0: uevent                                                             
[   10.446007] hub 1-2:1.0: usb_probe_interface                                                
[   10.446008] hub 1-2:1.0: usb_probe_interface - got id                                       
[   10.446014] hub 1-2:1.0: USB hub found                                                      
[   10.446266] hub 1-2:1.0: 4 ports detected                                                   
[   10.446267] hub 1-2:1.0: standalone hub                                                     
[   10.446268] hub 1-2:1.0: individual port power switching                                    
[   10.446269] hub 1-2:1.0: individual port over-current protection                            
[   10.446270] hub 1-2:1.0: Single TT                                                          
[   10.446271] hub 1-2:1.0: TT requires at most 32 FS bit times (2664 ns)                      
[   10.446273] hub 1-2:1.0: Port indicators are supported                                      
[   10.446274] hub 1-2:1.0: power on to power good time: 100ms                                 
[   10.446639] hub 1-2:1.0: local power source is good                                         
[   10.446641] hub 1-2:1.0: enabling power on all ports                                        
[   10.447651] drivers/usb/core/inode.c: creating file '002'                                   
[   10.548520] hub 1-2:1.0: port 2: status 0301 change 0001                                    
[   10.549274] hub 1-2:1.0: port 4: status 0101 change 0001                                    
[   10.647923] usb 1-2: link qh256-0001/ffff8800c7800180 start 1 [1/0 us]                      
[   10.647930] hub 1-2:1.0: state 7 ports 4 chg 0014 evt 0000                                  
[   10.648269] hub 1-2:1.0: port 2, status 0301, change 0000, 1.5 Mb/s                         
[   10.715261] usb 1-2.2: new low speed USB device using ehci_hcd and address 
3                
[   10.801883] usb 1-2.2: skipped 1 descriptor after interface                                 
[   10.801885] usb 1-2.2: skipped 1 descriptor after interface                                 
[   10.802380] usb 1-2.2: default language 0x0409                                              
[   10.804628] usb 1-2.2: udev 3, busnum 1, minor = 2                                          
[   10.804629] usb 1-2.2: New USB device found, idVendor=046d, idProduct=c518                  
[   10.804631] usb 1-2.2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0             
[   10.804632] usb 1-2.2: Product: USB Receiver                                                
[   10.804633] usb 1-2.2: Manufacturer: Logitech                                               
[   10.804659] usb 1-2.2: uevent                                                               
[   10.804670] usb 1-2.2: usb_probe_device                                                     
[   10.804671] usb 1-2.2: configuration #1 chosen from 1 choice                                
[   10.812007] usb 1-2.2: adding 1-2.2:1.0 (config #1, interface 0)                            
[   10.812016] usb 1-2.2:1.0: uevent                                                           
[   10.812027] usbhid 1-2.2:1.0: usb_probe_interface                                           
[   10.812029] usbhid 1-2.2:1.0: usb_probe_interface - got id                                  
[   10.812369] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42                               
[   10.815257] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.0/input/input3                                                                         
[   10.815294] generic-usb 0003:046D:C518.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input0                                                     
[   10.815302] usb 1-2.2: adding 1-2.2:1.1 (config #1, interface 1)                            
[   10.815311] usb 1-2.2:1.1: uevent                                                           
[   10.815318] usbhid 1-2.2:1.1: usb_probe_interface                                           
[   10.815319] usbhid 1-2.2:1.1: usb_probe_interface - got id                                  
[   10.815619] usb 1-2: clear tt buffer port 2, a3 ep0 t80008d42                               
[   10.820918] input: Logitech USB Receiver as 
/devices/pci0000:00/0000:00:12.2/usb1/1-2/1-2.2/1-2.2:1.1/input/input4                                                                         
[   10.820924] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[   10.820938] drivers/usb/core/file.c: looking for a minor, starting at 96                    
[   10.820967] generic-usb 0003:046D:C518.0002: input,hiddev96,hidraw1: USB 
HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.2-2.2/input1                                           
[   10.820975] drivers/usb/core/inode.c: creating file '003'                                   
[   10.821266] hub 1-2:1.0: port 4, status 0101, change 0000, 12 Mb/s                          
[   10.845138] usb 1-2.2:1.0: uevent                                                           
[   10.845189] usb 1-2.2: uevent                                                               
[   10.845217] usb 1-2.2:1.0: uevent                                                           
[   10.845270] usb 1-2.2: uevent                                                               
[   10.845751] usb 1-2.2:1.1: uevent                                                           
[   10.845813] usb 1-2.2: uevent                                                               
[   10.845854] usb 1-2.2:1.0: uevent                                                           
[   10.845884] usb 1-2.2:1.0: uevent                                                           
[   10.846526] usb 1-2.2:1.1: uevent                                                           
[   10.888757] usb 1-2.4: new high speed USB device using ehci_hcd and address 
4               
[   11.050025] bttv0: tea5757: read timeout                                                    
[   11.050026] bttv0: tuner type=5                                                             
[   11.069319] bttv0: audio absent, no audio device found!                                     
[   11.083055] TUNER: Unable to find symbol tea5767_autodetection()                            
[   11.083058] tuner 0-0060: chip found @ 0xc0 (bt848 #0 [sw])                                 
[   11.092406] tuner-simple 0-0060: creating new instance                                      
[   11.092408] tuner-simple 0-0060: type set to 5 (Philips PAL_BG (FI1216 and 
compatibles))    
[   11.093212] bttv0: registered device video0                                                 
[   11.093244] bttv0: registered device vbi0                                                   
[   11.382479] reiser4: md2: found disk format 4.0.0.                                          
[   11.850179] usb 1-2.4: default language 0x0409                                              
[   11.851685] usb 1-2.4: udev 4, busnum 1, minor = 3                                          
[   11.851686] usb 1-2.4: New USB device found, idVendor=0781, idProduct=7421                  
[   11.851688] usb 1-2.4: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3             
[   11.851690] usb 1-2.4: Product: Sansa e260                                                  
[   11.851691] usb 1-2.4: Manufacturer: SanDisk                                                
[   11.851692] usb 1-2.4: SerialNumber: 
00000000-00000000-8911b49b-9905e904-00000000           
[   11.851739] usb 1-2.4: uevent                                                               
[   11.851750] usb 1-2.4: usb_probe_device                                                     
[   11.851752] usb 1-2.4: configuration #128 chosen from 1 choice                              
[   11.866061] usb 1-2.4: adding 1-2.4:128.0 (config #128, interface 0)                        
[   11.866075] usb 1-2.4:128.0: uevent                                                         
[   11.866097] drivers/usb/core/inode.c: creating file '004'                                   
[   11.866108] hub 1-2:1.0: state 7 ports 4 chg 0000 evt 0010                                  
[   11.886025] Initializing USB Mass Storage driver...                                         
[   11.886046] usb-storage 1-2.4:128.0: usb_probe_interface                                    
[   11.886049] usb-storage 1-2.4:128.0: usb_probe_interface - got id                           
[   11.886097] scsi6 : SCSI emulation for USB Mass Storage devices                             
[   11.886167] usb-storage: device found at 4                                                  
[   11.886169] usb-storage: waiting for device to settle before scanning                       
[   11.886175] usbcore: registered new interface driver usb-storage                            
[   11.886190] USB Mass Storage support registered.                                            
[   12.337099] hub 2-0:1.0: hub_suspend                                                        
[   12.337104] usb usb2: bus auto-suspend                                                      
[   12.337105] ehci_hcd 0000:00:13.2: suspend root hub                                         
[   13.200175] reiser4: md3: found disk format 4.0.0.                                          
[   16.885258] scsi 6:0:0:0: Direct-Access     SanDisk  Sansa e260            
PQ: 0 ANSI: 0    
[   16.885639] sd 6:0:0:0: Attached scsi generic sg3 type 0                                    
[   16.887625] scsi 6:0:0:1: Direct-Access     SanDisk  Sansa e260            
PQ: 0 ANSI: 0    
[   16.887697] sd 6:0:0:1: Attached scsi generic sg4 type 0                                    
[   16.888632] sd 6:0:0:0: [sdd] 7854080 512-byte logical blocks: (4.02 
GB/3.74 GiB)           
[   16.890693] usb 1-2.4:128.0: uevent                                                         
[   16.890755] usb 1-2.4: uevent                                                               
[   16.891005] sd 6:0:0:0: [sdd] Write Protect is off                                          
[   16.891007] sd 6:0:0:0: [sdd] Mode Sense: 45 00 00 00                                       
[   16.891009] sd 6:0:0:0: [sdd] Assuming drive cache: write through                           
[   16.891540] usb 1-2.4:128.0: uevent                                                         
[   16.892378] sd 6:0:0:1: [sde] Attached SCSI removable disk                                  
[   16.898131] usb-storage: device scan complete                                               
[   16.899128] sd 6:0:0:0: [sdd] Assuming drive cache: write through                           
[   16.899131]  sdd: sdd1 sdd2                                                                 
[   16.910613] usb 1-2.4:128.0: uevent                                                         
[   16.910659] usb 1-2.4: uevent                                                               
[   16.911352] usb 1-2.4:128.0: uevent                                                         
[   16.912379] sd 6:0:0:0: [sdd] Assuming drive cache: write through                           
[   16.912382] sd 6:0:0:0: [sdd] Attached SCSI removable disk                                  
[   54.396254] reiser4: sdc7: found disk format 4.0.0.                                         
[   66.731638] Adding 7815612k swap on /dev/sda2.  Priority:1 extents:1 
across:7815612k        
[   66.741397] Adding 7815612k swap on /dev/sdb2.  Priority:1 extents:1 
across:7815612k        
[   66.806036] Adding 7815612k swap on /dev/sdc2.  Priority:1 extents:1 
across:7815612k        
[   67.523629] w83627ehf: Found W83627EHG chip at 0x290                                        
[   67.918061] r8169: eth0: link up                                                            
[   67.918070] r8169: eth0: link up                                                            
[   70.196495] usb usb1: uevent                                                                
[   70.196601] usb 1-0:1.0: uevent                                                             
[   70.196695] usb 1-2: uevent                                                                 
[   70.196801] usb 1-2.2: uevent                                                               
[   70.196905] usb 1-2.2:1.0: uevent                                                           
[   70.197647] usb 1-2.2:1.1: uevent                                                           
[   70.198329] usb 1-2.4: uevent                                                               
[   70.198436] usb 1-2.4:128.0: uevent                                                         
[   70.200226] usb 1-2:1.0: uevent                                                             
[   70.200604] usb usb2: uevent                                                                
[   70.200746] usb 2-0:1.0: uevent                                                             
[   71.245297]   alloc irq_desc for 23 on node -1                                              
[   71.245303]   alloc kstat_irqs on node -1                                                   
[   71.245317] EMU10K1_Audigy 0000:05:08.0: PCI INT A -> GSI 23 (level, low) -
> IRQ 23         
[   71.252291] Audigy2 value: Special config.                                                  
[   72.518788] fglrx: module license 'Proprietary. (C) 2002 - ATI 
Technologies, Starnberg, GERMANY' taints kernel.                                                                            
[   72.518791] Disabling lock debugging due to kernel taint                                    
[   72.531488] [fglrx] Maximum main memory to use for locked dma buffers: 7760 
MBytes.         
[   72.531563] [fglrx]   vendor: 1002 device: 9501 count: 1                                    
[   72.531738] [fglrx] ioport: bar 4, base 0xc000, size: 0x100                                 
[   72.531748] pci 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18                    
[   72.531752] pci 0000:02:00.0: setting latency timer to 64                                   
[   72.531879] [fglrx] Kernel PAT support is enabled                                           
[   72.531896] [fglrx] module loaded - fglrx 8.66.2 [Sep  1 2009] with 1 
minors                
[   72.705700]   alloc irq_desc for 29 on node -1                                              
[   72.705702]   alloc kstat_irqs on node -1                                                   
[   72.705711] fglrx_pci 0000:02:00.0: irq 29 for MSI/MSI-X                                    
[   72.706037] [fglrx] Firegl kernel thread PID: 3849                                          
[   74.812320] [fglrx] Gart USWC size:1279 M.                                                  
[   74.812322] [fglrx] Gart cacheable size:508 M.                                              
[   74.812325] [fglrx] Reserved FB block: Shared offset:0, size:1000000                        
[   74.812327] [fglrx] Reserved FB block: Unshared offset:fbff000, size:401000                 
[   74.812329] [fglrx] Reserved FB block: Unshared offset:1fffc000, size:4000                  
[   76.077543] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[  211.153993] reiser4[bogofilter(4043)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:                                                                                          
[  211.153997] NOTICE: md3 does not support write barriers, using synchronous 
write instead.   
[  236.764601] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  236.764616] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  236.764624] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  236.764633] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  236.765140] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  236.765146] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  238.553574] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  238.553590] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  238.553597] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  238.553606] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  238.554149] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule                      
[  238.554155] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]                      
[  242.964601] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[  242.964617] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[  242.964624] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[  242.964633] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]                    
[  242.965127] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule                      
[  242.965134] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]                      
[  243.377268] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]                    
[  243.377284] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  243.377292] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  243.377300] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  243.378247] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  243.378256] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  245.597932] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  245.597948] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  245.597956] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  245.597964] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  245.598462] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  245.598468] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  320.868424] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  320.868440] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  320.868448] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  320.868457] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  320.870128] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  320.870137] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  322.196316] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  322.196325] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  322.196328] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  322.196331] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  322.196786] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  322.196789] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  398.107922] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  398.107939] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  398.107947] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  398.107955] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  398.108431] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  398.108437] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  476.898649] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  476.898656] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  476.898658] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  476.898661] usb 1-2.2: unlink qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  476.899121] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800300 schedule
[  476.899123] usb 1-2.2: link qh8-0601/ffff8800c7800300 start 2 [1/2 us]
[  498.181222] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  498.181231] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  498.181233] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  498.181235] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  498.181668] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  498.181670] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  504.747933] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  504.747957] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  504.747965] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  504.747974] usb 1-2.2: unlink qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  504.748522] ehci_hcd 0000:00:12.2: reused qh ffff8800c7800600 schedule
[  504.748529] usb 1-2.2: link qh8-0601/ffff8800c7800600 start 3 [1/2 us]
[  611.820993] reiser4[ktxnmgrd:md1:ru(581)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  611.820997] NOTICE: md1 does not support write barriers, using synchronous 
write instead.
[  670.449593] reiser4[ktxnmgrd:md2:ru(2794)]: disable_write_barrier 
(fs/reiser4/wander.c:235)[zam-1055]:
[  670.449597] NOTICE: md2 does not support write barriers, using synchronous 
write instead.
[  718.057127] usb usb2: usb auto-resume
[  718.057138] ehci_hcd 0000:00:13.2: resume root hub
[  718.084125] hub 2-0:1.0: hub_resume
[  718.084172] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
[  720.327466] hub 2-0:1.0: hub_suspend
[  720.327479] usb usb2: bus auto-suspend
[  720.327485] ehci_hcd 0000:00:13.2: suspend root hub

 lsusb -v

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               2.00                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64                                   
  idVendor           0x1d6b Linux Foundation                  
  idProduct          0x0002 2.0 root hub                      
  bcdDevice            2.06                                   
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd           
  iProduct                2 EHCI Host Controller              
  iSerial                 1 0000:00:13.2                      
  bNumConfigurations      1                                   
  Configuration Descriptor:                                   
    bLength                 9                                 
    bDescriptorType         2                                 
    wTotalLength           25                                 
    bNumInterfaces          1                                 
    bConfigurationValue     1                                 
    iConfiguration          0                                 
    bmAttributes         0xe0                                 
      Self Powered                                            
      Remote Wakeup                                           
    MaxPower                0mA                               
    Interface Descriptor:                                     
      bLength                 9                               
      bDescriptorType         4                               
      bInterfaceNumber        0                               
      bAlternateSetting       0                               
      bNumEndpoints           1                               
      bInterfaceClass         9 Hub                           
      bInterfaceSubClass      0 Unused                        
      bInterfaceProtocol      0 Full speed (or root) hub      
      iInterface              0                               
      Endpoint Descriptor:                                    
        bLength                 7                             
        bDescriptorType         5                             
        bEndpointAddress     0x81  EP 1 IN                    
        bmAttributes            3                             
          Transfer Type            Interrupt                  
          Synch Type               None                       
          Usage Type               Data                       
        wMaxPacketSize     0x0004  1x 4 bytes                 
        bInterval              12                             
Hub Descriptor:                                               
  bLength               9                                     
  bDescriptorType      41                                     
  nNbrPorts             6                                     
  wHubCharacteristic 0x000a                                   
    No power switching (usb 1.0)                              
    Per-port overcurrent protection                           
  bPwrOn2PwrGood       10 * 2 milli seconds                   
  bHubContrCurrent      0 milli Ampere                        
  DeviceRemovable    0x00                                     
  PortPwrCtrlMask    0xff                                     
 Hub Port Status:                                             
   Port 1: 0000.0100 power                                    
   Port 2: 0000.0100 power                                    
   Port 3: 0000.0100 power                                    
   Port 4: 0000.0100 power                                    
   Port 5: 0000.0100 power                                    
   Port 6: 0000.0100 power                                    
Device Status:     0x0003                                     
  Self Powered                                                
  Remote Wakeup Enabled                                       

Bus 001 Device 004: ID 0781:7421 SanDisk Corp. Sansa E200 series
Device Descriptor:                                              
  bLength                18                                     
  bDescriptorType         1                                     
  bcdUSB               2.00                                     
  bDeviceClass            0 (Defined at Interface level)        
  bDeviceSubClass         0                                     
  bDeviceProtocol         0                                     
  bMaxPacketSize0        64                                     
  idVendor           0x0781 SanDisk Corp.                       
  idProduct          0x7421 Sansa E200 series                   
  bcdDevice            7.20                                     
  iManufacturer           1 SanDisk                             
  iProduct                2 Sansa e260                          
  iSerial                 3 00000000-00000000-8911b49b-9905e904-00000000
  bNumConfigurations      1                                             
  Configuration Descriptor:                                             
    bLength                 9                                           
    bDescriptorType         2                                           
    wTotalLength           32                                           
    bNumInterfaces          1                                           
    bConfigurationValue   128                                           
    iConfiguration          0                                           
    bmAttributes         0xc0                                           
      Self Powered                                                      
    MaxPower              500mA                                         
    Interface Descriptor:                                               
      bLength                 9                                         
      bDescriptorType         4                                         
      bInterfaceNumber        0                                         
      bAlternateSetting       0                                         
      bNumEndpoints           2                                         
      bInterfaceClass         8 Mass Storage                            
      bInterfaceSubClass      6 SCSI                                    
      bInterfaceProtocol     80 Bulk (Zip)                              
      iInterface              0                                         
      Endpoint Descriptor:                                              
        bLength                 7                                       
        bDescriptorType         5                                       
        bEndpointAddress     0x01  EP 1 OUT                             
        bmAttributes            2                                       
          Transfer Type            Bulk                                 
          Synch Type               None                                 
          Usage Type               Data                                 
        wMaxPacketSize     0x0200  1x 512 bytes                         
        bInterval               0                                       
      Endpoint Descriptor:                                              
        bLength                 7                                       
        bDescriptorType         5                                       
        bEndpointAddress     0x82  EP 2 IN                              
        bmAttributes            2                                       
          Transfer Type            Bulk                                 
          Synch Type               None                                 
          Usage Type               Data                                 
        wMaxPacketSize     0x0200  1x 512 bytes                         
        bInterval               0                                       
Device Qualifier (for other device speed):                              
  bLength                10                                             
  bDescriptorType         6                                             
  bcdUSB               2.00                                             
  bDeviceClass          255 Vendor Specific Class                       
  bDeviceSubClass       255 Vendor Specific Subclass                    
  bDeviceProtocol       255 Vendor Specific Protocol                    
  bMaxPacketSize0        64                                             
  bNumConfigurations      1                                             
Device Status:     0x0001                                               
  Self Powered                                                          

Bus 001 Device 003: ID 046d:c518 Logitech, Inc. MX610 Laser Cordless Mouse
Device Descriptor:                                                        
  bLength                18                                               
  bDescriptorType         1                                               
  bcdUSB               2.00                                               
  bDeviceClass            0 (Defined at Interface level)                  
  bDeviceSubClass         0                                               
  bDeviceProtocol         0                                               
  bMaxPacketSize0         8                                               
  idVendor           0x046d Logitech, Inc.                                
  idProduct          0xc518 MX610 Laser Cordless Mouse                    
  bcdDevice           42.03                                               
  iManufacturer           1 Logitech                                      
  iProduct                2 USB Receiver                                  
  iSerial                 0                                               
  bNumConfigurations      1                                               
  Configuration Descriptor:                                               
    bLength                 9                                             
    bDescriptorType         2                                             
    wTotalLength           59                                             
    bNumInterfaces          2                                             
    bConfigurationValue     1                                             
    iConfiguration          4 RR42.03_B0039                               
    bmAttributes         0xa0                                             
      (Bus Powered)                                                       
      Remote Wakeup                                                       
    MaxPower               98mA                                           
    Interface Descriptor:                                                 
      bLength                 9                                           
      bDescriptorType         4                                           
      bInterfaceNumber        0                                           
      bAlternateSetting       0                                           
      bNumEndpoints           1                                           
      bInterfaceClass         3 Human Interface Device                    
      bInterfaceSubClass      1 Boot Interface Subclass                   
      bInterfaceProtocol      2 Mouse                                     
      iInterface              0                                           
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 43 00                        
      Endpoint Descriptor:                                                
        bLength                 7                                         
        bDescriptorType         5                                         
        bEndpointAddress     0x81  EP 1 IN                                
        bmAttributes            3                                         
          Transfer Type            Interrupt                              
          Synch Type               None                                   
          Usage Type               Data                                   
        wMaxPacketSize     0x0008  1x 8 bytes                             
        bInterval              10                                         
    Interface Descriptor:                                                 
      bLength                 9                                           
      bDescriptorType         4                                           
      bInterfaceNumber        1                                           
      bAlternateSetting       0                                           
      bNumEndpoints           1                                           
      bInterfaceClass         3 Human Interface Device                    
      bInterfaceSubClass      0 No Subclass                               
      bInterfaceProtocol      0 None                                      
      iInterface              0                                           
      ** UNRECOGNIZED:  09 21 11 01 00 01 22 4f 00                        
      Endpoint Descriptor:                                                
        bLength                 7                                         
        bDescriptorType         5                                         
        bEndpointAddress     0x82  EP 2 IN                                
        bmAttributes            3                                         
          Transfer Type            Interrupt                              
          Synch Type               None                                   
          Usage Type               Data                                   
        wMaxPacketSize     0x0008  1x 8 bytes                             
        bInterval              10                                         
Device Status:     0x0000                                                 
  (Bus Powered)                                                           

Bus 001 Device 002: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
Device Descriptor:                                                     
  bLength                18                                            
  bDescriptorType         1                                            
  bcdUSB               2.00                                            
  bDeviceClass            9 Hub                                        
  bDeviceSubClass         0 Unused                                     
  bDeviceProtocol         1 Single TT                                  
  bMaxPacketSize0        64                                            
  idVendor           0x05e3 Genesys Logic, Inc.                        
  idProduct          0x0608 USB-2.0 4-Port HUB                         
  bcdDevice            7.02                                            
  iManufacturer           0                                            
  iProduct                1 USB2.0 Hub                                 
  iSerial                 0                                            
  bNumConfigurations      1                                            
  Configuration Descriptor:                                            
    bLength                 9                                          
    bDescriptorType         2                                          
    wTotalLength           25                                          
    bNumInterfaces          1                                          
    bConfigurationValue     1                                          
    iConfiguration          0                                          
    bmAttributes         0xe0                                          
      Self Powered                                                     
      Remote Wakeup                                                    
    MaxPower              100mA                                        
    Interface Descriptor:                                              
      bLength                 9                                        
      bDescriptorType         4                                        
      bInterfaceNumber        0                                        
      bAlternateSetting       0                                        
      bNumEndpoints           1                                        
      bInterfaceClass         9 Hub                                    
      bInterfaceSubClass      0 Unused                                 
      bInterfaceProtocol      0 Full speed (or root) hub               
      iInterface              0                                        
      Endpoint Descriptor:                                             
        bLength                 7                                      
        bDescriptorType         5                                      
        bEndpointAddress     0x81  EP 1 IN                             
        bmAttributes            3                                      
          Transfer Type            Interrupt                           
          Synch Type               None                                
          Usage Type               Data                                
        wMaxPacketSize     0x0001  1x 1 bytes                          
        bInterval              12                                      
Hub Descriptor:                                                        
  bLength               9                                              
  bDescriptorType      41                                              
  nNbrPorts             4                                              
  wHubCharacteristic 0x00e9                                            
    Per-port power switching                                           
    Per-port overcurrent protection                                    
    TT think time 32 FS bits                                           
    Port indicators                                                    
  bPwrOn2PwrGood       50 * 2 milli seconds                            
  bHubContrCurrent    100 milli Ampere                                 
  DeviceRemovable    0x00                                              
  PortPwrCtrlMask    0xff                                              
 Hub Port Status:                                                      
   Port 1: 0000.0100 power                                             
   Port 2: 0000.0303 lowspeed power enable connect                     
   Port 3: 0000.0100 power                                             
   Port 4: 0000.0503 highspeed power enable connect                    
Device Qualifier (for other device speed):                             
  bLength                10                                            
  bDescriptorType         6                                            
  bcdUSB               2.00                                            
  bDeviceClass            9 Hub                                        
  bDeviceSubClass         0 Unused                                     
  bDeviceProtocol         0 Full speed (or root) hub                   
  bMaxPacketSize0        64                                            
  bNumConfigurations      1                                            
Device Status:     0x0003                                              
  Self Powered                                                         
  Remote Wakeup Enabled                                                

Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Device Descriptor:                                            
  bLength                18                                   
  bDescriptorType         1                                   
  bcdUSB               2.00                                   
  bDeviceClass            9 Hub                               
  bDeviceSubClass         0 Unused                            
  bDeviceProtocol         0 Full speed (or root) hub          
  bMaxPacketSize0        64
  idVendor           0x1d6b Linux Foundation
  idProduct          0x0002 2.0 root hub
  bcdDevice            2.06
  iManufacturer           3 Linux 2.6.31r4 ehci_hcd
  iProduct                2 EHCI Host Controller
  iSerial                 1 0000:00:12.2
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           25
    bNumInterfaces          1
    bConfigurationValue     1
    iConfiguration          0
    bmAttributes         0xe0
      Self Powered
      Remote Wakeup
    MaxPower                0mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         9 Hub
      bInterfaceSubClass      0 Unused
      bInterfaceProtocol      0 Full speed (or root) hub
      iInterface              0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0004  1x 4 bytes
        bInterval              12
Hub Descriptor:
  bLength               9
  bDescriptorType      41
  nNbrPorts             6
  wHubCharacteristic 0x000a
    No power switching (usb 1.0)
    Per-port overcurrent protection
  bPwrOn2PwrGood       10 * 2 milli seconds
  bHubContrCurrent      0 milli Ampere
  DeviceRemovable    0x00
  PortPwrCtrlMask    0xff
 Hub Port Status:
   Port 1: 0000.0100 power
   Port 2: 0000.0503 highspeed power enable connect
   Port 3: 0000.0100 power
   Port 4: 0000.0100 power
   Port 5: 0000.0100 power
   Port 6: 0000.0100 power
Device Status:     0x0003
  Self Powered
  Remote Wakeup Enabled

Glück Auf,
Volker
