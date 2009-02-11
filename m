Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbZBKUDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbZBKUDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 15:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZBKUDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 15:03:04 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:27504 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbZBKUDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 15:03:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=DgNYEGQxheTEC9rqD5Ql+A8EqmZ+ZjtqO1IxxttYG4z+QqNXC3Tp2H9vNVrgzxyil1
         32IOQLa2rGV4yrmEgsT0WK7b2Z0ZvJFgB7Jrtl84sH33gFIJaQ289eF7RappjSKtwifV
         KSKMEun6aDeb4JXheJCnhM64sNbcv+aClbKC8=
MIME-Version: 1.0
Date: Wed, 11 Feb 2009 16:02:59 -0400
Message-ID: <e63fe7530902111202t164fcfcerf421bf2e242f8957@mail.gmail.com>
Subject: kernels 2.6.29.rc3 2.1 3.1 4.1 5.1 6.1 7.1 and rc4 8.1 Is ACPI broken 
	???????
From: rob koendering <susegebr@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all   new to this list

I have acpi troublw with the rc3 and rc4  2.6.29  kernels
The acpi tables in bios are nor read wel
and interupt handling is out of control


With the 2.6.27 kernels i never had this following type of errors
intalled the bios again to make sure the acpi tables are alright



from dmesg

last_map_addr: cfef0000 end: cfef0000
init_memory_mapping: 0000000100000000-0000000230000000
 0100000000 - 0230000000 page 2M
kernel direct mapping tables up to 230000000 @ 14000-1e000
last_map_addr: 230000000 end: 230000000
RAMDISK: 37989000 - 37fef987
ACPI: RSDP 000F7CA0, 0024 (r2 Nvidia)
ACPI: XSDT CFEF30C0, 004C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: FACP CFEFB680, 00F4 (r3 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI Warning (tbfadt-0568): 32/64X length mismatch in Pm1aEventBlock:
32/8 [20081204]
ACPI Warning (tbfadt-0568): 32/64X length mismatch in
Pm1aControlBlock: 16/8 [20081204]
ACPI Warning (tbfadt-0568): 32/64X length mismatch in PmTimerBlock:
32/8 [20081204]
ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe0Block: 64/8
[20081204]
ACPI Warning (tbfadt-0568): 32/64X length mismatch in Gpe1Block: 128/8
[20081204]
ACPI Warning (tbfadt-0412): Invalid length for Pm1aEventBlock: 8,
using default 32 [20081204]
ACPI Warning (tbfadt-0412): Invalid length for Pm1aControlBlock: 8,
using default 16 [20081204]
ACPI Warning (tbfadt-0412): Invalid length for PmTimerBlock: 8, using
default 32 [20081204]
FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
ACPI: DSDT CFEF3240, 83FB (r1 NVIDIA AWRDACPI     1000 MSFT  3000000)
ACPI: FACS CFEF0000, 0040
ACPI: HPET CFEFB8C0, 0038 (r1 Nvidia ASUSACPI 42302E31 AWRD       98)
ACPI: MCFG CFEFB940, 003C (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: APIC CFEFB7C0, 0098 (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: SSDT CFEFC1C0, 087B (r1 Nvidia ASUSACPI 42302E31 AWRD        0)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000230000000
Bootmem setup node 0 0000000000000000-0000000230000000
 NODE_DATA [0000000000019000 - 0000000000030fff]
 bootmap [0000000000031000 -  0000000000076fff] pages 46
(7 early reservations) ==> bootmem [0000000000 - 0230000000]
 #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
 #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
 #2 [0000200000 - 0000aed830]    TEXT DATA BSS ==> [0000200000 -
0000aed830]
 #3 [0037989000 - 0037fef987]          RAMDISK ==> [0037989000 -
0037fef987]
 #4 [000009c000 - 0000100000]    BIOS reserved ==> [000009c000 -
0000100000]
 #5 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 -
0000014000]
 #6 [0000014000 - 0000019000]          PGTABLE ==> [0000014000 -
0000019000]
found SMP MP-table at [ffff8800000f6160] 000f6160
 [ffffe20000000000-ffffe20007bfffff] PMD ->
[ffff880001200000-ffff8800083fffff] on node 0
Zone PFN ranges:
 DMA      0x00000010 -> 0x00001000
 DMA32    0x00001000 -> 0x00100000
 Normal   0x00100000 -> 0x00230000
Movable zone start PFN for each node
early_n

Initializing the cpus on a Intel(R) Core(TM)2 Quad CPU    Q6600  @
2.40GHz stepping 0b

Initializing CPU#0
Experimental hierarchical RCU implementation.
Experimental hierarchical RCU init done.
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
Fast TSC calibration using PIT
Detected 2400.086 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff880008484000 -
ffff88000c484000
software IO TLB at phys 0x8484000 - 0xc484000
Memory: 8187972k/9175040k available (3041k kernel code, 787984k
absent, 199084k reserved, 3451k data, 884k init)
hpet clockevent registered
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4800.17 BogoMIPS (lpj=9600344)
kdb version 4.4 by Keith Owens, Scott Lurndal. Copyright SGI, All
Rights Reserved
Security Framework initialized
SELinux:  Disabled at boot.
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys net_cls
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 0/0x0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20081204
ACPI: Checking initramfs for custom DSDT
ACPI: setting ELCR to 0ea0 (from 0ca0)
Setting APIC routing to flat
ExtINT not setup in hardware but reported by MP table
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Booting processor 1 APIC 0x1 ip 0x6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4799.94 BogoMIPS
(lpj=9599891)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 1/0x1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2 APIC 0x3 ip 0x6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4800.00 BogoMIPS
(lpj=9600002)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 2/0x3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#1 -> CPU#2]: passed.
Booting processor 3 APIC 0x2 ip 0x6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4799.98 BogoMIPS
(lpj=9599960)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
[ds] using Core 2/Atom configuration
CPU 3/0x2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#2 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19200.09 BogoMIPS).
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
 groups: 0 1
 domain 1: span 0-3 level CPU
  groups: 0-1 2-3
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
 groups: 1 0
 domain 1: span 0-3 level CPU
  groups: 0-1 2-3
CPU2 attaching sched-domain:
 domain 0: span 2-3 level MC
 groups: 2 3
 domain 1: span 0-3 level CPU
  groups: 2-3 0-1
CPU3 attaching sched-domain:
 domain 0: span 2-3 level MC
 groups: 3 2
 domain 1: span 0-3 level CPU
  groups: 2-3 0-1

the lines : [ds] using Core 2/Atom configuration

this is not a atom cpu

so i took out   "perfmon"  and  ck804xrom.ko     fom lib/modules

boot parameters are  pnpacpi=no pci=noacpi  acpi_irq_balance

in this way the kernel gives more or less the same info in Gkrellm  as a 2.6.27

with out the boot parameters half the irq are routed to cpu 0
irq 14  15  16  17  18  19  20  21

2 not used pcie's  irq 24  and irq25 are alwayes on cpu 0

alloc irq_desc for 24 on cpu 0 node 0
alloc kstat_irqs on cpu 0 node 0

alloc irq_desc for 25 on cpu 0 node 0
alloc kstat_irqs on cpu 0 node 0



-- 
Robert Koendering
Willemstad
Curacao
