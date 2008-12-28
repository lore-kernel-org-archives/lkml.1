Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYL1PLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYL1PLV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 10:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYL1PLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 10:11:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43685 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbYL1PLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 10:11:06 -0500
Date: Sun, 28 Dec 2008 13:10:26 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: 2.6.24.7-rt25 and 2.6.26.8-rt12
Message-ID: <20081228151026.GB28520@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <srostedt@redhat.com>
References: <1229752520.974.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1229752520.974.37.camel@localhost.localdomain>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 20, 2008 at 12:55:20AM -0500, Steven Rostedt escreveu:
> We are pleased to announce the 2.6.24.7-rt25 and 2.6.26.8-rt12 trees,
> which can be downloaded from the location:
> 
>   http://rt.et.redhat.com/download/
> 
> Information on the RT patch can be found at:
> 
>   http://rt.wiki.kernel.org/index.php/Main_Page
> 
> Changes since 2.6.26.6-rt11

I managed to boot 2.6.26.8-rt12 once, but it oopsed when I started a
market data workload while generating load with a make -j 64 kernel
compile, couldn't get the proper backtrace because I was swamped with
/proc/sys/kernel/hung_task_timeout_secs related messages.

When I tried to reboot to try again after setting
/proc/sys/kernel/hung_task_timeout_secs to zero I got the backtrace
below, will try again and report.

Config file was the one in 2.6.24.7-95.el5rt + answers for new options,
will attach when I get the machine back online.

- Arnaldo

  Booting 'RT Upstream (2.6.26.8-rt12)'                                                                                                                                                                                                                                                   root (hd0,0)                                                                                                                                  Filesystem type is ext2fs, partition type 0x83                                                                                              kernel /vmlinuz-2.6.26.8-rt12 ro root=/dev/myvg/rootvol crashkernel=128M@16M co                                                              nsole=tty0 console=ttyS1,19200n8 idle=poll                                                                                                      [Linux-bzImage, setup=0x3000, size=0x209190]                                                                                              initrd /initrd-2.6.26.8-rt12.img                                                                                                                [Linux-initrd @ 0x37cc0000, 0x32f5b6 bytes]                                                                                                                                                                                                                                            Probing EDD (edd=off to disable)... ok                                                                                                       Initializing cgroup subsys cpuset                                                                                                            Linux version 2.6.26.8-rt12 (root@hs21xm-1) (gcc version 4.1.2 20071124 (Red Hat 4.1.2-42)) #1 SMP PREEMPT RT Fri Dec 26 18:15:04 CST 2008   Command line: ro root=/dev/myvg/rootvol crashkernel=128M@16M console=tty0 console=ttyS1,19200n8 idle=poll                                    BIOS-provided physical RAM map:ver (2.6.26.6-rt11)               !
         
  �
 BIOS-e820: 0000000000000000 - 000000000009d000 (usable)                   �  
 BIOS-e820: 000000000009d000 - 00000000000a0000 (reserved)�����������������
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)ghted.
 BIOS-e820: 0000000000100000 - 00000000affbcdc0 (usable)he
 BIOS-e820: 00000000affbcdc0 - 00000000affd0000 (ACPI data)uments
 BIOS-e820: 00000000affd0000 - 00000000b0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)         
 BIOS-e820: 0000000100000000 - 0000000250000000 (usable)
using polling idle threads.
max_pfn_mapped = 2424832
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
DMI 2.4 present.
ACPI: RSDP 000FDFD0, 0024 (r2 IBM   )
ACPI: XSDT AFFCFF00, 0044 (r1 IBM    SERBLADE     1001 IBM  45444F43)
ACPI: FACP AFFCFE40, 0084 (r2 IBM    SERBLADE     1001 IBM  45444F43)
ACPI: DSDT AFFBCDEB, 2840 (r2 IBM    SERBLADE     1000 INTL 20060707)
ACPI: FACS AFFCBE80, 0040
ACPI: APIC AFFCFD40, 00C8 (r1 IBM    SERBLADE     1001 IBM  45444F43)
ACPI: MCFG AFFCFD00, 003C (r1 IBM    SERBLADE     1001 IBM  45444F43)
ACPI: ERST AFFCBEC0, 0230 (r1 IBM    SERBLADE     1001 IBM  45444F43)
No NUMA configuration found
Faking a node at 0000000000000000-0000000250000000
Bootmem setup node 0 0000000000000000-0000000250000000
  NODE_DATA [0000000000013000 - 0000000000017fff]
  bootmap [0000000000018000 -  0000000000061fff] pages 4a
  early res: 0 [0-fff] BIOS data page
  early res: 1 [6000-7fff] TRAMPOLINE
  early res: 2 [200000-81391f] TEXT DATA BSS
  early res: 3 [37cc0000-37fef5b5] RAMDISK
  early res: 4 [9d000-fffff] BIOS reserved
  early res: 5 [8000-12fff] PGTABLE
Reserving 128MB of memory at 16MB for crashkernel (System RAM: 9472MB)
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2424832
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      157
    0:      256 ->   720828
    0:  1048576 ->  2424832
ACPI: PM-Timer IO Port: 0x588
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, version 0, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 13, version 0, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009d000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000affbc000 - 00000000affbd000
PM: Registered nosave memory: 00000000affbd000 - 00000000affd0000
PM: Registered nosave memory: 00000000affd0000 - 00000000b0000000
PM: Registered nosave memory: 00000000b0000000 - 00000000e0000000
PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at b4000000 (gap: b0000000:30000000)
SMP: Allowing 8 CPUs, 0 hotplug CPUs
PERCPU: Allocating 49924 bytes of per cpu data
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2033747
Policy zone: Normal
Kernel command line: ro root=/dev/myvg/rootvol crashkernel=128M@16M console=tty0 console=ttyS1,19200n8 idle=poll
Initializing CPU#0
Preemptible RCU implementation.
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 2333.413 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS1] enabled
Checking aperture...
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0xc000000 - 0x10000000
Memory: 7965148k/9699328k available (2725k kernel code, 422792k reserved, 1527k data, 436k init)
Calibrating delay using timer specific routine.. 4669.21 BogoMIPS (lpj=2334609)
Security Framework initialized
SELinux:  Initializing.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM1)
ACPI: Core revision 20080321
CPU0: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
Using local APIC timer interrupts.
Detected 20.834 MHz APIC timer.
Booting processor 1/4 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4666.92 BogoMIPS (lpj=2333462)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
CPU1: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/1 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4666.91 BogoMIPS (lpj=2333455)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 2/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU2: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/2 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4666.90 BogoMIPS (lpj=2333453)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU3: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Booting processor 4/3 ip 6000
Initializing CPU#4
Calibrating delay using timer specific routine.. 4666.89 BogoMIPS (lpj=2333445)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 4/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU4: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 4, old 0x7040600070406, new 0x7010600070106
CPU4: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#4]: passed.
Booting processor 5/5 ip 6000
Initializing CPU#5
Calibrating delay using timer specific routine.. 4666.92 BogoMIPS (lpj=2333460)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 5/5 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 1
CPU5: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 5, old 0x7040600070406, new 0x7010600070106
CPU5: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#5]: passed.
Booting processor 6/6 ip 6000
Initializing CPU#6
Calibrating delay using timer specific routine.. 4666.91 BogoMIPS (lpj=2333459)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 6/6 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 2
CPU6: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 6, old 0x7040600070406, new 0x7010600070106
CPU6: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#6]: passed.
Booting processor 7/7 ip 6000
Initializing CPU#7
Calibrating delay using timer specific routine.. 4666.93 BogoMIPS (lpj=2333465)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 7/7 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 3
CPU7: Thermal monitoring enabled (TM1)
x86 PAT enabled: cpu 7, old 0x7040600070406, new 0x7010600070106
CPU7: Intel(R) Xeon(R) CPU           E5345  @ 2.33GHz stepping 07
checking TSC synchronization [CPU#0 -> CPU#7]: passed.
Brought up 8 CPUs
Total of 8 processors activated (37337.61 BogoMIPS).
net_namespace: 1384 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 15
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e0ffffff
PCI: Using configuration type 1 for base access
ACPI: Interpreter enabled
ACPI: (supports S0 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:02.0
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:06.0
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:07.0
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Link [LP00] (IRQs *5)
ACPI: PCI Interrupt Link [LP01] (IRQs *5)
ACPI: PCI Interrupt Link [LP02] (IRQs *11)
ACPI: PCI Interrupt Link [LP03] (IRQs *5)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP04] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP05] (IRQs *5)
ACPI: PCI Interrupt Link [LP06] (IRQs *11)
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:01: ioport range 0xc00-0xc1f has been reserved
system 00:01: ioport range 0xc60-0xc67 has been reserved
system 00:0a: ioport range 0xc28-0xc28 has been reserved
system 00:0a: ioport range 0xc2c-0xc2c has been reserved
system 00:0b: ioport range 0x400-0x43f has been reserved
system 00:0b: ioport range 0x440-0x45f has been reserved
system 00:0b: ioport range 0x4d0-0x4d1 has been reserved
system 00:0b: ioport range 0xc60-0xc7f could not be reserved
system 00:0b: ioport range 0xce0-0xcff could not be reserved
system 00:0b: ioport range 0x580-0x5ff has been reserved
system 00:0b: ioport range 0xc30-0xc30 has been reserved
system 00:0b: ioport range 0xc34-0xc34 has been reserved
system 00:0b: ioport range 0xc40-0xc5f has been reserved
system 00:0b: ioport range 0xca8-0xca8 has been reserved
system 00:0b: ioport range 0xcac-0xcac has been reserved
system 00:0b: ioport range 0xcb0-0xcb0 has been reserved
system 00:0b: ioport range 0xcb4-0xcb4 has been reserved
system 00:0b: ioport range 0xcc0-0xcdf has been reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0b: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:0b: iomem range 0xfe000000-0xfe01ffff has been reserved
system 00:0b: iomem range 0xfe020000-0xfe6fffff has been reserved
system 00:0b: iomem range 0xfe700400-0xfebfffff has been reserved
system 00:0b: iomem range 0xfff00000-0xffffffff could not be reserved
PCI: Bridge: 0000:09:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:09:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:07:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:07:00.3
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:02.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: 0xb8000000-0xd6ffffff
  PREFETCH window: 0x00000000b4200000-0x00000000b42fffff
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.0
  IO window: disabled.
  MEM window: 0xda000000-0xdcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: 0xda000000-0xdcffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:05:00.0
  IO window: disabled.
  MEM window: 0xd7000000-0xd9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: disabled.
  MEM window: 0xd7000000-0xd9ffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: 4000-4fff
  MEM window: 0xdd000000-0xdeffffff
  PREFETCH window: 0x00000000b4000000-0x00000000b41fffff
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: 0xf8000000-0xf8ffffff
  PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3261k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1230474884.017:1): initialized
krcupreemptd setsched 0
  prio = 98
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 15563
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: ACPI0007:02 is registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: ACPI0007:03 is registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
ACPI: ACPI0007:04 is registered as cooling_device4
ACPI: Processor [CPU4] (supports 8 throttling states)
ACPI: ACPI0007:05 is registered as cooling_device5
ACPI: Processor [CPU5] (supports 8 throttling states)
ACPI: ACPI0007:06 is registered as cooling_device6
ACPI: Processor [CPU6] (supports 8 throttling states)
ACPI: ACPI0007:07 is registered as cooling_device7
ACPI: Processor [CPU7] (supports 8 throttling states)
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
erial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:03: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
usbcore: registered new interface driver libusual
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 436k freed
Write protecting the kernel read-only data: 3904k
Red Hat nash version 5.1.19.6 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Setting up hotplug.
Creating block dACPI: PCI Interrupt 0000:00:1d.7[D] -> evice nodes.
LoGSI 23 (level, low) -> IRQ 23
ading ehci-hcd.kehci_hcd 0000:00:1d.7: EHCI Host Controller
o module
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 5 ports detected
Loading ohci-hcdUSB Universal Host Controller Interface driver v3.0
.ko module
LoadACPI: PCI Interrupt 0000:00:1d.0[A] -> ing uhci-hcd.ko GSI 18 (level, low) -> IRQ 18
module
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 18, io base 0x00002200
usb usb2: configuration #1 chosen from 1 choice
usb 1-3: new high speed USB device using ehci_hcd and address 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 1-3: configuration #1 chosen from 1 choice
hub 1-3:1.0: USB hub found
hub 1-3:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00002600
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 19 (level, low) -> IRQ 19
Loading mbcache.uhci_hcd 0000:00:1d.2: UHCI Host Controller
ko module
Loadiuhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
ng jbd.ko moduleuhci_hcd 0000:00:1d.2: irq 19, io base 0x00002800

Loading ext3.kusb usb4: configuration #1 chosen from 1 choice
o module
Loadinhub 4-0:1.0: USB hub found
g scsi_mod.ko mohub 4-0:1.0: 2 ports detected
dule
Loading sdSCSI subsystem initialized
_mod.ko module
Driver 'sd' needs updating - please use bus_type methods
Loading mptbase.Fusion MPT base driver 3.04.06
ko module
LoadiCopyright (c) 1999-2007 LSI Corporation
ng scsi_transporFusion MPT SAS Host driver 3.04.06
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16

Loading mptscsimptbase: ioc0: Initiating bringup
h.ko module
Loading mptsas.ko module
ioc0: LSISAS1064E B1: Capabilities={Initiator}
mptbase: ioc0: PCI-MSI enabled
scsi0 : ioc0: LSISAS1064E B1, FwRev=01160000h, Ports=1, MaxQ=286, IRQ=2294
scsi 0:0:0:0: Direct-Access     IBM-ESXS MBB2073RC        SB01 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 143374000 512-byte hardware sectors (73407 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
Loading dock.ko No dock devices found.
module
Loading libata.kACPI: PCI Interrupt 0000:00:1f.2[B] -> o module
LoadinGSI 23 (level, low) -> IRQ 23
g ata_piix.ko moata_piix 0000:00:1f.2: MAP [dule
 P0 P2 IDE IDE ]
scsi1 : ata_piix
scsi2 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x2a00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2a08 irq 15
Loading usb-storInitializing USB Mass Storage driver...
age.ko module
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
Waiting for driver initialization.
Loading dm-mod.kdevice-mapper: uevent: version 1.0.3
o module
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
Loading dm-log.ko module
Loading dm-mirror.ko module
Loading dm-zero.ko module
Loading dm-snapshot.ko module
Waiting for driver initialization.
Scanning and configuring dmraid supported devices
Scanning logical volumes
  Reading all physical volumes.  This may take a while...
  Found volume group "myvg" using metadata type lvm2
Activating logical volumes
  1 loEXT3-fs: INFO: recovery required on readonly filesystem.
gical volume(s) EXT3-fs: write access will be enabled during recovery.
in volume group "myvg" now active
Trying to resume from LABEL=SWAP-sda3
No suspend signature on swap, not resuming.
Creating root device.
Mounting root filesystem.
kjournald starting.  Commit interval 5 seconds
Setting up otherEXT3-fs: recovery complete.
 filesystems.
SEXT3-fs: mounted filesystem with ordered data mode.
etting up new root fs
no fstab.sys, mounting internal defaults
Switching to new root and running i------------[ cut here ]------------
kernel BUG at /root/acme/linux-2.6.26.8-rt12/kernel/sched_rt.c:793!
invalid opcode: 0000 [1] PREEMPT SMP 
CPU 2 
Modules linked in: dm_snapshot dm_zero dm_mirror dm_log dm_mod usb_storage ata_piix libata dock mptsas mptscsih scsi_transport_sas mptbase sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd
Pid: 591, comm: IRQ-3 Not tainted 2.6.26.8-rt12 #1
RIP: 0010:[<ffffffff8102a86d>]  [<ffffffff8102a86d>] pick_next_rt_entity+0x1f/0x41
RSP: 0018:ffff81024f197da8  EFLAGS: 00010002
RAX: 0000000000000064 RBX: ffff8100090b8180 RCX: 0000000000000001
RDX: 0101010101010101 RSI: ffff8100090b8258 RDI: ffff8100090b8180
RBP: ffff81024f197da8 R08: ffff81024f197dd8 R09: 0000000000000000
R10: ffff810087b70000 R11: 0000000000000002 R12: ffff81024f1442c0
R13: ffff8100090b8180 R14: 0000000000000001 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff81024f0f2c40(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000441b40 CR3: 0000000000201000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process IRQ-3 (pid: 591, threadinfo ffff81024d1aa000, task ffff81024d1c6380)
Stack:  ffff81024f197dd8 ffffffff81036052 ffff81024f1442c0 ffff8100090b8180
 0000000000000001 0000000000000002 ffff81024f197e38 ffffffff81033200
 ffff8100090b8f48 00000000815727b0 000000000000001e 00000008090b9180
Call Trace:
 <IRQ>  [<ffffffff81036052>] check_preempt_curr_rt+0x3e/0x81
 [<ffffffff81033200>] try_to_wake_up+0x203/0x258
 [<ffffffff810332cf>] wake_up_process+0x12/0x14
 [<ffffffff8103de82>] wakeup_softirqd+0x2d/0x2f
 [<ffffffff8103eac8>] raise_softirq+0x38/0x48
 [<ffffffff81042692>] run_local_timers+0x13/0x1a
 [<ffffffff81042b25>] update_process_times+0x35/0x5a
 [<ffffffff810563f1>] tick_sched_timer+0x81/0xac
 [<ffffffff81056370>] ? tick_sched_timer+0x0/0xac
 [<ffffffff8104fa10>] __run_hrtimer+0x57/0x98
 [<ffffffff810506f9>] hrtimer_interrupt+0x1b8/0x22c
 [<ffffffff8103e49f>] ? irq_exit+0x8a/0x9b
 [<ffffffff8101c379>] smp_apic_timer_interrupt+0x88/0xa6
 [<ffffffff8100d0c2>] apic_timer_interrupt+0x72/0x80
 <EOI>  [<ffffffff811b6fec>] ? serial_out+0xab/0xad
 [<ffffffff811b78fd>] ? transmit_chars+0x75/0xf0
 [<ffffffff811b9b4c>] ? serial8250_interrupt+0x7d/0xee
 [<ffffffff81077f33>] ? handle_IRQ_event+0x5b/0xfb
 [<ffffffff81078da9>] ? do_irqd+0x14a/0x2c5
 [<ffffffff81078c5f>] ? do_irqd+0x0/0x2c5
 [<ffffffff81078c5f>] ? do_irqd+0x0/0x2c5
 [<ffffffff8104cf4f>] ? kthread+0x49/0x76
 [<ffffffff8100d2f8>] ? child_rip+0xa/0x12
 [<ffffffff8104cf06>] ? kthread+0x0/0x76
 [<ffffffff8100d2ee>] ? child_rip+0x0/0x12


Code: 63 7e 04 0f 0b eb fe c9 48 89 f0 c3 48 8b 06 55 48 89 e5 48 85 c0 74 06 48 0f bc c0 eb 08 48 0f bc 46 08 83 c0 40 83 f8 63 7e 04 <0f> 0b eb fe 48 63 c8 48 c1 e1 04 48 8d 54 31 10 48 8b 02 48 39 
RIP  [<ffffffff8102a86d>] pick_next_rt_entity+0x1f/0x41
 RSP <ffff81024f197da8>
Kernel panic - not syncing: Aiee, killing interrupt handler!
Pid: 591, comm: IRQ-3 Tainted: G      D   2.6.26.8-rt12 #1

Call Trace:
 <IRQ>  [<ffffffff81038ef3>] panic+0xaf/0x167
 [<ffffffff81039c3e>] ? printk+0x67/0x69
 [<ffffffff810514b6>] ? blocking_notifier_call_chain+0xf/0x11
 [<ffffffff8103c4e9>] do_exit+0x78/0x760
 [<ffffffff811a9b02>] ? do_unblank_screen+0xf/0x10b
 [<ffffffff812a360d>] oops_begin+0x0/0x7c
 [<ffffffff8100de81>] die+0x5d/0x66
 [<ffffffff812a38a1>] do_trap+0x110/0x11f
 [<ffffffff8100e411>] do_invalid_op+0xa0/0xa9
 [<ffffffff8102a86d>] ? pick_next_rt_entity+0x1f/0x41
 [<ffffffff812a2fb3>] ? __spin_unlock_irqrestore+0x37/0x39
 [<ffffffff812a31e9>] error_exit+0x0/0x60
 [<ffffffff8102a86d>] ? pick_next_rt_entity+0x1f/0x41
 [<ffffffff810326b5>] ? activate_task+0xa5/0xb2
 [<ffffffff81036052>] ? check_preempt_curr_rt+0x3e/0x81
 [<ffffffff81033200>] ? try_to_wake_up+0x203/0x258
 [<ffffffff810332cf>] ? wake_up_process+0x12/0x14
 [<ffffffff8103de82>] ? wakeup_softirqd+0x2d/0x2f
 [<ffffffff8103eac8>] ? raise_softirq+0x38/0x48
 [<ffffffff81042692>] ? run_local_timers+0x13/0x1a
 [<ffffffff81042b25>] ? update_process_times+0x35/0x5a
 [<ffffffff810563f1>] ? tick_sched_timer+0x81/0xac
 [<ffffffff81056370>] ? tick_sched_timer+0x0/0xac
 [<ffffffff8104fa10>] ? __run_hrtimer+0x5fffff81078da9>] ? do_irqd+0x14a/0x2c5
 [<ffffffff81078c5f>] ? do_irqd+0x0/0x2c5
 [<ffffffff81078c5f>] ? do_irqd+0x0/0x2c5
 [<ffffffff8104cf4f>] ? kthread+0x49/0x76
 [<ffffffff8100d2f8>] ? child_rip+0xa/0x12
 [<ffffffff8104cf06>] ? kthread+0x0/0x76
 [<ffffffff8100d2ee>] ? child_rip+0x0/0x12
