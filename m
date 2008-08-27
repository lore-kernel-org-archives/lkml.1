Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYH0BG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYH0BG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 21:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYH0BGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 21:06:46 -0400
Received: from smtp101.rog.mail.re2.yahoo.com ([206.190.36.79]:35383 "HELO
	smtp101.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752386AbYH0BGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 21:06:44 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Aug 2008 21:06:43 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Organization:To:Subject:Date:User-Agent:MIME-Version:Content-Type:Message-Id;
  b=0mfVrtEkDOo0t6T6ePkgq0Fy6HQ8CtrVO1KqdQCZSVg2aAOR0DaAlrzIw8LUvcRgLHfoz7onMwv6JYbnUENnQab9CKvZKWCJjFWazeeM4rJ/JaUlvOUEZ37bRaHjejjIjT89zy7oUwdSxaBR4Ek43nydOcBj3VmlsZxiTroVyn4=  ;
X-YMail-OSG: Xs.HsxgVM1nsm0sMAo2Gpd_mB02F_dor9IG2cbAsgpwtOWMU2I8zU1DyI_nB_PZGxw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
Organization: sh0n.net
To: linux-kernel@vger.kernel.org
Subject: [2.6.27-rc2.git1] (Fedora snapshot) Realtek gigE network driver showing bogus packet drops
Date: Tue, 26 Aug 2008 20:59:56 -0400
User-Agent: KMail/1.10.0 (Linux/2.6.27-0.244.rc2.git1.fc10.i686; KDE/4.1.62; i686; svn-848490; 2008-08-17)
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NcKtIxEA2EWaS3E"
Message-Id: <200808262059.57667.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NcKtIxEA2EWaS3E
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This may or may not be due to a Fedora patch.

Motherboard: ASRock 4Core1600Twins-P35

Ifconfig:
eth0      Link encap:Ethernet  HWaddr 00:19:66:XX:XX:XX
          inet addr:192.168.XX.XX  Bcast:192.168.XX.XX  Mask:255.255.255.0                       
          inet6 addr: fe80::219:66ff:fe64:1c68/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:609519 errors:0 dropped:424695074957 overruns:0 frame:0
          TX packets:307400 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:869139403 (828.8 MiB)  TX bytes:20560737 (19.6 MiB)
          Interrupt:17

The dropped count increments even with no traffic. The machine has not been suspended/resumed. Anyone else noticed this?

Interrupt information:

           CPU0       CPU1       CPU2       CPU3
  0:         53          1          0          0   IO-APIC-edge      timer
  1:        119         51         17          8   IO-APIC-edge      i8042
  8:          1          0          0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0   IO-APIC-fasteoi   acpi
 12:         27         28         28         29   IO-APIC-edge      i8042
 16:        657        515       5440       3747   IO-APIC-fasteoi uhci_hcd:usb3, pata_jmicron
 17:          6       4693          4     912071   IO-APIC-fasteoi   HDA Intel, eth0
 18:          0          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb8
 19:     119224     237091       2558       2247   IO-APIC-fasteoi   uhci_hcd:usb5, uhci_hcd:usb7, ahci
 21:          0          0          0          0   IO-APIC-fasteoi   uhci_hcd:usb4
 22:        955         53        795         97   IO-APIC-fasteoi   HDA Intel, eth1
 23:          1          1          0          0   IO-APIC-fasteoi   ehci_hcd:usb2, uhci_hcd:usb6
NMI:          0          0          0          0   Non-maskable interrupts
LOC:     882410     796648     341746     271431   Local timer interrupts
RES:       3924       4203        924       1254   Rescheduling interrupts
CAL:       4496       4541       1431       1798   function call interrupts
TLB:      11834      12648       1758       3854   TLB shootdowns
TRM:          0          0          0          0   Thermal event interrupts
THR:          0          0          0          0   Threshold APIC interrupts
SPU:          0          0          0          0   Spurious interrupts

Relevant IOport info:

a000-afff : PCI Bus 0000:01
  a800-a8ff : 0000:01:00.0
    a800-a8ff : r8169

Memory range:
cdf00000-cdffffff : PCI Bus 0000:01
  cdfe0000-cdfeffff : 0000:01:00.0
    cdfe0000-cdfeffff : r8169
  cdfff000-cdffffff : 0000:01:00.0
    cdfff000-cdffffff : r8169

01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)                                                                       
        Subsystem: ASRock Incorporation Device 8168                                              
        Flags: bus master, fast devsel, latency 0, IRQ 17                                        
        I/O ports at a800 [size=256]                                                             
        Memory at cdfff000 (64-bit, prefetchable) [size=4K]                                      
        Memory at cdfe0000 (64-bit, prefetchable) [size=64K]                                     
        Expansion ROM at fdef0000 [disabled] [size=64K]                                          
        Capabilities: [40] Power Management version 3                                            
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=0/1 Enable-          
        Capabilities: [70] Express Endpoint, MSI 01                                              
        Capabilities: [b0] MSI-X: Enable- Mask- TabSize=2                                        
        Capabilities: [d0] Vital Product Data <?>                                                
        Capabilities: [100] Advanced Error Reporting <?>                                         
        Capabilities: [140] Virtual Channel <?>                                                  
        Capabilities: [160] Device Serial Number 00-e0-4c-68-12-34-56-78                         
        Kernel driver in use: r8169                                                              
        Kernel modules: r8169        

dmesg attached (these things are growing bigger and bigger :-)

--Boundary-00=_NcKtIxEA2EWaS3E
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27-0.244.rc2.git1.fc10.x86_64 (mockbuild@x86-7) (gcc version 4.3.1 20080801 (Red Hat 4.3.1-6) (GCC) ) #1 SMP Fri Aug 8 13:14:06 EDT 2008
Command line: ro root=/dev/VolGroup00/LogVol00
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 0000000000099c00 (usable)
 BIOS-e820: 0000000000099c00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffb0000 (usable)
 BIOS-e820: 00000000bffb0000 - 00000000bffc0000 (ACPI data)
 BIOS-e820: 00000000bffc0000 - 00000000bfff0000 (ACPI NVS)
 BIOS-e820: 00000000bfff0000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
last_pfn = 0xbffb0 max_arch_pfn = 0x3ffffffff
init_memory_mapping
 0000000000 - 00bfe00000 page 2M
 00bfe00000 - 00bffb0000 page 4k
kernel direct mapping tables up to bffb0000 @ 8000-d000
last_map_addr: bffb0000 end: bffb0000
init_memory_mapping
 0100000000 - 0140000000 page 2M
kernel direct mapping tables up to 140000000 @ b000-11000
last_map_addr: 140000000 end: 140000000
RAMDISK: 37ca6000 - 37fefe7a
DMI present.
ACPI: RSDP 000FA150, 0014 (r0 ACPIAM)
ACPI: RSDT BFFB0000, 003C (r1 062608 RSDT2004 20080626 MSFT       97)
ACPI: FACP BFFB0200, 0084 (r1 A_M_I  OEMFACP  12000601 MSFT       97)
ACPI: DSDT BFFB0440, 57CC (r1  ASR74 ASR74132      132 INTL 20051117)
ACPI: FACS BFFC0000, 0040
ACPI: APIC BFFB0390, 006C (r1 062608 APIC2004 20080626 MSFT       97)
ACPI: MCFG BFFB0400, 003C (r1 062608 OEMMCFG  20080626 MSFT       97)
ACPI: OEMB BFFC0040, 0071 (r1 062608 OEMB2004 20080626 MSFT       97)
ACPI: HPET BFFB5C10, 0038 (r1 062608 OEMHPET  20080626 MSFT       97)
ACPI: SSDT BFFC1300, 0A7C (r1 DpgPmm    CpuPm       12 INTL 20051117)
No NUMA configuration found
Faking a node at 0000000000000000-0000000140000000
Bootmem setup node 0 0000000000000000-0000000140000000
  NODE_DATA [000000000000c000 - 0000000000020fff]
  bootmap [0000000000021000 -  0000000000048fff] pages 28
(7 early reservations) ==> bootmem [0000000000 - 0140000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000ed8688]    TEXT DATA BSS ==> [0000200000 - 0000ed8688]
  #3 [0037ca6000 - 0037fefe7a]          RAMDISK ==> [0037ca6000 - 0037fefe7a]
  #4 [0000099c00 - 0000100000]    BIOS reserved ==> [0000099c00 - 0000100000]
  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
  #6 [000000b000 - 000000c000]          PGTABLE ==> [000000b000 - 000000c000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
found SMP MP-table at [ffff8800000ff780] 000ff780
 [ffffe20000000000-ffffe200077fffff] PMD -> [ffff880028200000-ffff88002e1fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00140000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000000 -> 0x00000099
    0: 0x00000100 -> 0x000bffb0
    0: 0x00100000 -> 0x00140000
On node 0 totalpages: 1048393
  DMA zone: 498 pages, LIFO batch:0
  DMA32 zone: 757776 pages, LIFO batch:31
  Normal zone: 256000 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0xffffffff base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 0000000000099000 - 000000000009a000
PM: Registered nosave memory: 000000000009a000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
PM: Registered nosave memory: 00000000bffb0000 - 00000000bffc0000
PM: Registered nosave memory: 00000000bffc0000 - 00000000bfff0000
PM: Registered nosave memory: 00000000bfff0000 - 00000000c0000000
PM: Registered nosave memory: 00000000c0000000 - 00000000fee00000
PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
PM: Registered nosave memory: 00000000fee01000 - 00000000ffb80000
PM: Registered nosave memory: 00000000ffb80000 - 0000000100000000
Allocating PCI resources starting at c4000000 (gap: c0000000:3ee00000)
PERCPU: Allocating 450624 bytes of per cpu data
NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1014274
Policy zone: Normal
Kernel command line: ro root=/dev/VolGroup00/LogVol00
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Detected 2400.075 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1840 kB
 per task-struct memory footprint: 3456 bytes
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0x20000000 - 0x24000000
Memory: 4010396k/5242880k available (3153k kernel code, 183176k reserved, 1809k data, 1596k init)
CPA: page pool initialized 64 of 64 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 4800.15 BogoMIPS (lpj=2400075)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Using local APIC timer interrupts.
APIC timer calibration result 16667196
Detected 16.667 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.15 BogoMIPS (lpj=2400077)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
lockdep: fixing up alternatives.
Booting processor 2/2 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4800.17 BogoMIPS (lpj=2400088)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 2/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
lockdep: fixing up alternatives.
Booting processor 3/3 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4800.18 BogoMIPS (lpj=2400090)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19200.66 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=96 bytes
sizeof(inode)=1088 bytes
sizeof(dentry)=256 bytes
sizeof(ext3inode)=1488 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=9544 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-3 level NODE
    groups: 0-3
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-3 level CPU
   groups: 0-1 2-3
   domain 2: span 0-3 level NODE
    groups: 0-3
CPU2 attaching sched-domain:
 domain 0: span 2-3 level MC
  groups: 2 3
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-3 level NODE
    groups: 0-3
CPU3 attaching sched-domain:
 domain 0: span 2-3 level MC
  groups: 3 2
  domain 1: span 0-3 level CPU
   groups: 2-3 0-1
   domain 2: span 0-3 level NODE
    groups: 0-3
khelper used greatest stack depth: 4944 bytes left
net_namespace: 1680 bytes
Booting paravirtualized kernel on bare hardware
Time: 23:53:40  Date: 08/26/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: Not using MMCONFIG.
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
PCI: Using MMCONFIG at e0000000 - efffffff
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:05:00.0: supports D1
pci 0000:05:00.0: supports D2
pci 0000:05:00.1: supports D1
pci 0000:05:00.1: supports D2
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.4. It can be enabled forcedly with 'pcie_aspm=force'
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:01:00.0: PME# disabled
pci 0000:06:01.0: supports D1
pci 0000:06:01.0: supports D2
pci 0000:06:01.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:01.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 8F, should be 8B [20080609]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 1
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
ACPI: RTC can wake from S4
system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
system 00:01: iomem range 0xfed90000-0xfed93fff has been reserved
system 00:09: ioport range 0x280-0x28f has been reserved
system 00:09: ioport range 0x290-0x29f has been reserved
system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
system 00:0a: ioport range 0x800-0x87f has been reserved
system 00:0a: ioport range 0x480-0x4bf has been reserved
system 00:0a: ioport range 0x900-0x90f has been reserved
system 00:0a: iomem range 0xfed1c000-0xfed1ffff has been reserved
system 00:0a: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:0d: iomem range 0xffc00000-0xfff7ffff could not be reserved
system 00:0e: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0e: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
system 00:10: iomem range 0x0-0x9ffff could not be reserved
system 00:10: iomem range 0xc0000-0xcffff has been reserved
system 00:10: iomem range 0xe0000-0xfffff could not be reserved
system 00:10: iomem range 0x100000-0xbfffffff could not be reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:05
pci 0000:00:01.0:   IO window: 0xd000-0xdfff
pci 0000:00:01.0:   MEM window: 0xfe800000-0xfe8fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.0:   IO window: 0xc000-0xcfff
pci 0000:00:1c.0:   MEM window: 0xfe000000-0xfe7fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000ce000000-0x000000cfffffff
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.4:   IO window: 0xb000-0xbfff
pci 0000:00:1c.4:   MEM window: 0xfdf00000-0xfdffffff
pci 0000:00:1c.4:   PREFETCH window: 0x000000c4000000-0x000000c40fffff
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.5:   IO window: 0xa000-0xafff
pci 0000:00:1c.5:   MEM window: 0xfde00000-0xfdefffff
pci 0000:00:1c.5:   PREFETCH window: 0x000000cdf00000-0x000000cdffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
pci 0000:00:1e.0:   IO window: 0xe000-0xefff
pci 0000:00:1e.0:   MEM window: 0xfe900000-0xfebfffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000c4100000-0x000000c41fffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
debug: unmapping init memory ffff880037ca6000..ffff880037ff0000
audit: initializing netlink socket (disabled)
type=2000 audit(1219794820.138:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 7832
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f30
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1a.2: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x0f30
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0030
pci 0000:00:1d.2: Performing full reset
pci 0000:05:00.0: Boot video device
pci 0000:06:01.0: Firmware left e100 interrupts enabled; disabling
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pci_express 0000:00:1c.4:pcie03: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
pci_express 0000:00:1c.5:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT BFFC00C0, 0277 (r1 DpgPmm  P001Ist       11 INTL 20051117)
processor ACPI0007:00: registered as cooling_device0
ACPI: SSDT BFFC0550, 0277 (r1 DpgPmm  P002Ist       12 INTL 20051117)
processor ACPI0007:01: registered as cooling_device1
ACPI: SSDT BFFC09E0, 0277 (r1 DpgPmm  P003Ist       12 INTL 20051117)
processor ACPI0007:02: registered as cooling_device2
ACPI: SSDT BFFC0E70, 0277 (r1 DpgPmm  P004Ist       12 INTL 20051117)
processor ACPI0007:03: registered as cooling_device3
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input2
Driver 'sd' needs updating - please use bus_type methods
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 4:746:909
debug: unmapping init memory ffffffff81529000..ffffffff816b8000
Write protecting the kernel read-only data: 1420k
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfddffc00
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfddff800
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 4: status 0501 change 0001
hub 2-0:1.0: state 7 ports 6 chg 0010 evt 0000
drivers/usb/core/inode.c: creating file '001'
hub 2-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
modprobe used greatest stack depth: 3480 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: supports USB remote wakeup
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 4 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003801 POWER OWNER sig=j CONNECT
hub 2-0:1.0: port 4 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 003002 POWER OWNER sig=se0 CSC
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0010
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: supports USB remote wakeup
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: detected 2 ports
uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.2: Performing full reset
uhci_hcd 0000:00:1a.2: supports USB remote wakeup
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009c00
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '006'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
usb usb6: default language 0x0409
usb usb6: uevent
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
usb 6-0:1.0: uevent
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
drivers/usb/core/inode.c: creating file '001'
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '007'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
usb usb7: default language 0x0409
usb usb7: uevent
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
usb 7-0:1.0: uevent
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.1: port 2 portsc 009b,00
hub 7-0:1.0: port 2: status 0101 change 0003
hub 7-0:1.0: state 7 ports 2 chg 0004 evt 0000
drivers/usb/core/inode.c: creating file '001'
hub 7-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '008'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
usb usb8: default language 0x0409
usb usb8: uevent
usb usb8: usb_probe_device
usb usb8: configuration #1 chosen from 1 choice
usb usb8: adding 8-0:1.0 (config #1, interface 0)
usb 8-0:1.0: uevent
hub 8-0:1.0: usb_probe_interface
hub 8-0:1.0: usb_probe_interface - got id
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
hub 8-0:1.0: standalone hub
hub 8-0:1.0: no power switching (usb 1.0)
hub 8-0:1.0: individual port over-current protection
hub 8-0:1.0: power on to power good time: 2ms
hub 8-0:1.0: local power source is good
hub 8-0:1.0: trying to enable port power on non-switchable hub
usb 7-2: new full speed USB device using uhci_hcd and address 2
drivers/usb/core/inode.c: creating file '001'
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.27-0.244.rc2.git1.fc10.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfddfe800 port 0xfddfe900 irq 19
ata2: SATA max UDMA/133 abar m2048@0xfddfe800 port 0xfddfe980 irq 19
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xfddfe800 port 0xfddfeb00 irq 19
ata6: SATA max UDMA/133 abar m2048@0xfddfe800 port 0xfddfeb80 irq 19
usb 7-2: ep0 maxpacket = 8
usb 7-2: default language 0x0409
usb 7-2: uevent
usb 7-2: usb_probe_device
usb 7-2: configuration #1 chosen from 1 choice
usb 7-2: adding 7-2:1.0 (config #1, interface 0)
usb 7-2:1.0: uevent
drivers/usb/core/inode.c: creating file '002'
usb 7-2: New USB device found, idVendor=057b, idProduct=0000
usb 7-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 7-2: Product: FlashBuster-U
usb 7-2: Manufacturer: Y-E DATA
hub 8-0:1.0: state 7 ports 2 chg 0000 evt 0000
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: ST3500320AS, SD15, max UDMA/133
ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
usb usb3: suspend_rh (auto-stop)
ata2: SATA link down (SStatus 0 SControl 300)
usb usb4: suspend_rh (auto-stop)
usb usb5: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
ata5: SATA link down (SStatus 0 SControl 300)
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
usb usb8: suspend_rh (auto-stop)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      ST3500320AS      SD15 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
modprobe used greatest stack depth: 1896 bytes left
hub 2-0:1.0: hub_suspend
usb usb2: bus auto-suspend
ehci_hcd 0000:00:1d.7: suspend root hub
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 8-0:1.0: hub_suspend
usb usb8: bus auto-suspend
usb usb8: suspend_rh
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1219794826.024:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 172315 rules.
SELinux: 8192 avtab hash slots, 172315 rules.
SELinux:  8 users, 12 roles, 2301 types, 116 bools, 1 sens, 1024 cats
SELinux:  72 classes, 172315 rules
SELinux:  permission open in class dir not defined in policy
SELinux:  permission open in class file not defined in policy
SELinux:  permission open in class chr_file not defined in policy
SELinux:  permission open in class blk_file not defined in policy
SELinux:  permission open in class fifo_file not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1219794826.612:3): policy loaded auid=4294967295 ses=4294967295
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb6: uevent
usb 6-0:1.0: uevent
usb usb7: uevent
usb 7-0:1.0: uevent
usb 7-2: uevent
usb 7-2:1.0: uevent
usb usb8: uevent
usb 8-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
pata_jmicron 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_jmicron 0000:02:00.0: setting latency timer to 64
scsi6 : pata_jmicron
scsi7 : pata_jmicron
ata7: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 16
ata8: PATA max UDMA/100 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 16
Initializing USB Mass Storage driver...
usb-storage 7-2:1.0: usb_probe_interface
usb-storage 7-2:1.0: usb_probe_interface - got id
scsi8 : SCSI emulation for USB Mass Storage devices
ata7.00: ATAPI: PIONEER DVD-RW  DVR-111D, 1.29, max UDMA/66
ata7.01: ATAPI: YAMAHA  CRW2100E, 1.0N, max UDMA/25
iTCO_vendor_support: vendor-support=0
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ata7.00: configured for UDMA/66
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH9 TCO device (Version=2, TCOBASE=0x0860)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ata7.01: configured for UDMA/25
input: PC Speaker as /devices/platform/pcspkr/input/input5
scsi 6:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.29 PQ: 0 ANSI: 5
scsi 6:0:0:0: Attached scsi generic sg1 type 5
scsi 6:0:1:0: CD-ROM            YAMAHA   CRW2100E         1.0N PQ: 0 ANSI: 2
scsi 6:0:1:0: Attached scsi generic sg2 type 5
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:01:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:01:00.0: setting latency timer to 64
r8169 0000:01:00.0: no MSI. Back to INTx.
eth0: RTL8168c/8111c at 0xffffc20000650000, 00:19:66:64:1c:68, XID 3c2000c0 IRQ 17
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
e100 0000:06:01.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
PCSP: CONFIG_DEBUG_PAGEALLOC is enabled, which may make the sound noisy.
e100: 0000:06:01.0: e100_probe: Error clearing wake event
e100: eth1: e100_probe: addr 0xfebff000, irq 22, MAC addr 00:d0:b7:4e:f0:7d
Error: Driver 'pcspkr' is already registered, aborting...
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
ALSA sound/pci/hda/hda_intel.c:2073: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:754: codec_mask = 0x1
hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=4 (0x14/0x15/0x16/0x17/0x0)
ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0x18, fmic=0x0, line=0x1a, fline=0x0, cd=0x1c, aux=0x0
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Mono Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Line-Out Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Mono Playback Switch, skipped
HDA Intel 0000:05:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:05:00.1: setting latency timer to 64
ALSA sound/pci/hda/hda_intel.c:2073: chipset global capabilities = 0x1001
ALSA sound/pci/hda/hda_intel.c:754: codec_mask = 0x1
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
sr1: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
sr 6:0:1:0: Attached scsi CD-ROM sr1
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2031608k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:2031608k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--Boundary-00=_NcKtIxEA2EWaS3E--
