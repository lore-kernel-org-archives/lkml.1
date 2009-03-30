Return-Path: <linux-kernel-owner+w=401wt.eu-S1751268AbZC3EEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268AbZC3EEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbZC3EDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:03:54 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:5417 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbZC3EDw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:03:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ntZ6IssG/TDQu0qgYWkh+JVugiu3YKlRQAVpQyYx2wCDHsA6AJssQBNIvLdd2SkWY5
         bk7PQSHjq698VAOn3RCi0xiDG43A3WRz08aBy6KasCHIxr6/rRZK62bGTZ1qKjJl3IcE
         94dHxvzqB86D9mKOPMY8mh2hlC0RNZPE/COXQ=
MIME-Version: 1.0
In-Reply-To: <9b1675090903292018g5e1d20f5yfd76286182cb2276@mail.gmail.com>
References: <9b1675090903291904g7eca965eydb1aa3f852a1b91c@mail.gmail.com>
	 <000301c9b0e1$af531e40$0df95ac0$@com>
	 <9b1675090903291954j26e2380fy74338490343eaa2@mail.gmail.com>
	 <897274600903292015n44005d12l82b0fafd170d6292@mail.gmail.com>
	 <9b1675090903292018g5e1d20f5yfd76286182cb2276@mail.gmail.com>
Date: Sun, 29 Mar 2009 21:03:49 -0700
Message-ID: <dd18b0c30903292103i460e9227ya1550fff2f1dba85@mail.gmail.com>
Subject: Re: 2.6.29 on MacBook 2,1 fails to reboot
From: Justin Mattock <justinmattock@gmail.com>
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: "Morten P.D. Stevens" <mstevens@win-professional.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 8:18 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> I recall it working on 2.6.28, but i didn't have vanilla sources
> installed.  I used 2.6.28 gentoo sources.  I'm just compiling 2.6.28
> as we speak, as I figured you'd ask.  I've marked 2.6.29 as bad with
> "git bisect".  I'll let you know when I've narrowed it down for you.
> Can't wait to try "git bisect" *big smile*.
>
> On Sun, Mar 29, 2009 at 9:15 PM, Morten P.D. Stevens
> <mstevens@win-professional.com> wrote:
>> Hi,
>>
>> at first view your dmesg should be okay.
>>
>> does it reboot with 2.6.28 or lower?
>>
>> Morten
>>
>> 2009/3/30 Trenton Adams <trenton.d.adams@gmail.com>
>>>
>>> Oops, gmail doesn't reply to all by default.
>>>
>>> On Sun, Mar 29, 2009 at 8:46 PM, Morten P.D. Stevens
>>> <mstevens@win-professional.com> wrote:
>>> > Hi,
>>> >
>>> >> System information below.  If you need more info, let me know.
>>> >
>>> > Please post your dmesg output.
>>>
>>> tdamac linux # dmesg
>>> Linux version 2.6.29 (root@tdamac) (gcc version 4.1.2 (Gentoo 4.1.2
>>> p1.3)) #3 SMP Sun Mar 29 19:07:55 MDT 2009
>>> Command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys dolvm
>>> KERNEL supported cpus:
>>>  Intel GenuineIntel
>>>  AMD AuthenticAMD
>>>  Centaur CentaurHauls
>>> BIOS-provided physical RAM map:
>>>  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
>>>  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
>>>  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
>>>  BIOS-e820: 0000000000100000 - 000000007e08c000 (usable)
>>>  BIOS-e820: 000000007e08c000 - 000000007e28d000 (ACPI NVS)
>>>  BIOS-e820: 000000007e28d000 - 000000007eebe000 (ACPI data)
>>>  BIOS-e820: 000000007eebe000 - 000000007eeef000 (ACPI NVS)
>>>  BIOS-e820: 000000007eeef000 - 000000007ef00000 (ACPI data)
>>>  BIOS-e820: 000000007ef00000 - 0000000080000000 (reserved)
>>>  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
>>>  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
>>>  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
>>>  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
>>>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>>  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
>>> DMI 2.4 present.
>>> last_pfn = 0x7e08c max_arch_pfn = 0x100000000
>>> init_memory_mapping: 0000000000000000-000000007e08c000
>>>  0000000000 - 007e000000 page 2M
>>>  007e000000 - 007e08c000 page 4k
>>> kernel direct mapping tables up to 7e08c000 @ 8000-c000
>>> last_map_addr: 7e08c000 end: 7e08c000
>>> RAMDISK: 37edf000 - 37fef088
>>> ACPI: RSDP 000FE020, 0024 (r2 APPLE )
>>> ACPI: XSDT 7EEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
>>> ACPI: FACP 7EEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
>>> FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
>>> ACPI: DSDT 7EEF0000, 41E4 (r1 APPLE   MacBook    20001 INTL 20050309)
>>> ACPI: FACS 7EEC0000, 0040
>>> ACPI: HPET 7EEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
>>> ACPI: APIC 7EEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
>>> ACPI: MCFG 7EEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
>>> ACPI: ASF! 7EEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
>>> ACPI: SBST 7EEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
>>> ACPI: ECDT 7EEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
>>> ACPI: SSDT 7EEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
>>> ACPI: SSDT 7EEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
>>> ACPI: SSDT 7EEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
>>> ACPI: Local APIC address 0xfee00000
>>> (6 early reservations) ==> bootmem [0000000000 - 007e08c000]
>>>  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
>>> 0000001000]
>>>  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
>>> 0000008000]
>>>  #2 [0000200000 - 0000a43b8c]    TEXT DATA BSS ==> [0000200000 -
>>> 0000a43b8c]
>>>  #3 [0037edf000 - 0037fef088]          RAMDISK ==> [0037edf000 -
>>> 0037fef088]
>>>  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 -
>>> 0000100000]
>>>  #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 -
>>> 000000a000]
>>>  [ffffe20000000000-ffffe20001bfffff] PMD ->
>>> [ffff880001200000-ffff880002dfffff] on node 0
>>> Zone PFN ranges:
>>>  DMA      0x00000000 -> 0x00001000
>>>  DMA32    0x00001000 -> 0x00100000
>>>  Normal   0x00100000 -> 0x00100000
>>> Movable zone start PFN for each node
>>> early_node_map[2] active PFN ranges
>>>    0: 0x00000000 -> 0x0000009f
>>>    0: 0x00000100 -> 0x0007e08c
>>> On node 0 totalpages: 516139
>>>  DMA zone: 56 pages used for memmap
>>>  DMA zone: 2216 pages reserved
>>>  DMA zone: 1727 pages, LIFO batch:0
>>>  DMA32 zone: 7002 pages used for memmap
>>>  DMA32 zone: 505138 pages, LIFO batch:31
>>> ACPI: PM-Timer IO Port: 0x408
>>> ACPI: Local APIC address 0xfee00000
>>> ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
>>> ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
>>> ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>>> ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>>> ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
>>> IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
>>> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>> ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>>> ACPI: IRQ0 used by override.
>>> ACPI: IRQ2 used by override.
>>> ACPI: IRQ9 used by override.
>>> Using ACPI (MADT) for SMP configuration information
>>> ACPI: HPET id: 0x8086a201 base: 0xfed00000
>>> SMP: Allowing 2 CPUs, 0 hotplug CPUs
>>> nr_irqs_gsi: 24
>>> Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
>>> NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
>>> PERCPU: Allocating 53248 bytes of per cpu data
>>> Built 1 zonelists in Zone order, mobility grouping on.  Total pages:
>>> 506865
>>> Kernel command line: root=/dev/ram0 init=/linuxrc real_root=/dev/s/sys
>>> dolvm
>>> Initializing CPU#0
>>> PID hash table entries: 4096 (order: 12, 32768 bytes)
>>> Extended CMOS year: 2000
>>> Fast TSC calibration failed
>>> TSC: Unable to calibrate against PIT
>>> TSC: using PMTIMER reference calibration
>>> Detected 2161.212 MHz processor.
>>> Console: colour VGA+ 80x25
>>> console [tty0] enabled
>>> Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
>>> Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
>>> Checking aperture...
>>> No AGP bridge found
>>> Memory: 2022216k/2064944k available (4392k kernel code, 388k absent,
>>> 41684k reserved, 2619k data, 372k init)
>>> SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
>>> hpet clockevent registered
>>> HPET: 3 timers in total, 0 timers will be used for per-cpu timer
>>> Calibrating delay loop (skipped), value calculated using timer
>>> frequency.. 4322.42 BogoMIPS (lpj=8644848)
>>> Mount-cache hash table entries: 256
>>> CPU: L1 I cache: 32K, L1 D cache: 32K
>>> CPU: L2 cache: 4096K
>>> [ds] using Core 2/Atom configuration
>>> CPU: Physical Processor ID: 0
>>> CPU: Processor Core ID: 0
>>> CPU0: Thermal monitoring enabled (TM2)
>>> using mwait in idle threads.
>>> ACPI: Core revision 20081204
>>> Setting APIC routing to flat
>>> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>> CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
>>> Booting processor 1 APIC 0x1 ip 0x6000
>>> Initializing CPU#1
>>> Calibrating delay using timer specific routine.. 4322.44 BogoMIPS
>>> (lpj=8644898)
>>> CPU: L1 I cache: 32K, L1 D cache: 32K
>>> CPU: L2 cache: 4096K
>>> [ds] using Core 2/Atom configuration
>>> CPU: Physical Processor ID: 0
>>> CPU: Processor Core ID: 1
>>> CPU1: Thermal monitoring enabled (TM2)
>>> CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
>>> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
>>> Brought up 2 CPUs
>>> Total of 2 processors activated (8644.87 BogoMIPS).
>>> net_namespace: 1784 bytes
>>> NET: Registered protocol family 16
>>> ACPI: bus type pci registered
>>> PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
>>> PCI: MCFG area at f0000000 reserved in E820
>>> PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
>>> PCI: Using MMCONFIG at f0000000 - f3ffffff
>>> PCI: Using configuration type 1 for base access
>>> bio: create slab <bio-0> at 0
>>> ACPI: EC: EC description table is found, configuring boot EC
>>> ACPI: EC: non-query interrupt received, switching to interrupt mode
>>> ACPI: BIOS _OSI(Linux) query ignored
>>> ACPI: Interpreter enabled
>>> ACPI: (supports S0 S3 S5)
>>> ACPI: Using IOAPIC for interrupt routing
>>> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
>>> ACPI: EC: driver started in interrupt mode
>>> ACPI: No dock devices found.
>>> ACPI: PCI Root Bridge [PCI0] (0000:00)
>>> pci 0000:00:02.0: reg 10 32bit mmio: [0x90380000-0x903fffff]
>>> pci 0000:00:02.0: reg 14 io port: [0x20e0-0x20e7]
>>> pci 0000:00:02.0: reg 18 32bit mmio: [0x80000000-0x8fffffff]
>>> pci 0000:00:02.0: reg 1c 32bit mmio: [0x90400000-0x9043ffff]
>>> pci 0000:00:02.1: reg 10 32bit mmio: [0x90300000-0x9037ffff]
>>> pci 0000:00:07.0: reg 10 32bit mmio: [0x90444000-0x90444fff]
>>> pci 0000:00:1b.0: reg 10 64bit mmio: [0x90440000-0x90443fff]
>>> pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1b.0: PME# disabled
>>> pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.0: PME# disabled
>>> pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1c.1: PME# disabled
>>> pci 0000:00:1d.0: reg 20 io port: [0x2080-0x209f]
>>> pci 0000:00:1d.1: reg 20 io port: [0x2060-0x207f]
>>> pci 0000:00:1d.2: reg 20 io port: [0x2040-0x205f]
>>> pci 0000:00:1d.3: reg 20 io port: [0x2020-0x203f]
>>> pci 0000:00:1d.7: reg 10 32bit mmio: [0x90445400-0x904457ff]
>>> pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
>>> pci 0000:00:1d.7: PME# disabled
>>> pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
>>> pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
>>> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 000f)
>>> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 1640 (mask 000f)
>>> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0300 (mask 001f)
>>> pci 0000:00:1f.1: reg 10 io port: [0x20d8-0x20df]
>>> pci 0000:00:1f.1: reg 14 io port: [0x20f4-0x20f7]
>>> pci 0000:00:1f.1: reg 18 io port: [0x20d0-0x20d7]
>>> pci 0000:00:1f.1: reg 1c io port: [0x20f0-0x20f3]
>>> pci 0000:00:1f.1: reg 20 io port: [0x20b0-0x20bf]
>>> pci 0000:00:1f.2: reg 10 io port: [0x20c8-0x20cf]
>>> pci 0000:00:1f.2: reg 14 io port: [0x20ec-0x20ef]
>>> pci 0000:00:1f.2: reg 18 io port: [0x20c0-0x20c7]
>>> pci 0000:00:1f.2: reg 1c io port: [0x20e8-0x20eb]
>>> pci 0000:00:1f.2: reg 20 io port: [0x20a0-0x20af]
>>> pci 0000:00:1f.2: reg 24 32bit mmio: [0x90445000-0x904453ff]
>>> pci 0000:00:1f.2: PME# supported from D3hot
>>> pci 0000:00:1f.2: PME# disabled
>>> pci 0000:00:1f.3: reg 20 io port: [0xefa0-0xefbf]
>>> pci 0000:01:00.0: reg 10 64bit mmio: [0x90200000-0x90203fff]
>>> pci 0000:01:00.0: reg 18 io port: [0x1000-0x10ff]
>>> pci 0000:01:00.0: reg 30 32bit mmio: [0xfffe0000-0xffffffff]
>>> pci 0000:01:00.0: supports D1 D2
>>> pci 0000:01:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>>> pci 0000:01:00.0: PME# disabled
>>> pci 0000:00:1c.0: bridge io port: [0x1000-0x1fff]
>>> pci 0000:00:1c.0: bridge 32bit mmio: [0x90200000-0x902fffff]
>>> pci 0000:02:00.0: reg 10 64bit mmio: [0x90100000-0x9010ffff]
>>> pci 0000:02:00.0: supports D1
>>> pci 0000:02:00.0: PME# supported from D0 D1 D3hot
>>> pci 0000:02:00.0: PME# disabled
>>> pci 0000:00:1c.1: bridge 32bit mmio: [0x90100000-0x901fffff]
>>> pci 0000:03:03.0: reg 10 32bit mmio: [0x90000000-0x90000fff]
>>> pci 0000:03:03.0: supports D1 D2
>>> pci 0000:03:03.0: PME# supported from D0 D1 D2 D3hot
>>> pci 0000:03:03.0: PME# disabled
>>> pci 0000:00:1e.0: transparent bridge
>>> pci 0000:00:1e.0: bridge 32bit mmio: [0x90000000-0x900fffff]
>>> pci_bus 0000:00: on NUMA node 0
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
>>> ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
>>> ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
>>> ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
>>> ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
>>> ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
>>> ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0,
>>> disabled.
>>> ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0,
>>> disabled.
>>> ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
>>> ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
>>> SCSI subsystem initialized
>>> libata version 3.00 loaded.
>>> usbcore: registered new interface driver usbfs
>>> usbcore: registered new interface driver hub
>>> usbcore: registered new device driver usb
>>> PCI: Using ACPI for IRQ routing
>>> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
>>> hpet0: 3 comparators, 64-bit 14.318180 MHz counter
>>> pnp: PnP ACPI init
>>> ACPI: bus type pnp registered
>>> pnp 00:07: io resource (0x1640-0x164f) overlaps 0000:00:1c.0 BAR 7
>>> (0x1000-0x1fff), disabling
>>> pnp: PnP ACPI: found 9 devices
>>> ACPI: ACPI bus type pnp unregistered
>>> system 00:01: iomem range 0xf0000000-0xf3ffffff has been reserved
>>> system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
>>> system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
>>> system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
>>> system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
>>> system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
>>> system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
>>> system 00:07: ioport range 0x680-0x6ef has been reserved
>>> system 00:07: ioport range 0x800-0x80f has been reserved
>>> system 00:07: ioport range 0x810-0x817 has been reserved
>>> system 00:07: ioport range 0x400-0x47f has been reserved
>>> system 00:07: ioport range 0x500-0x53f has been reserved
>>> pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
>>> pci 0000:00:1c.0:   IO window: 0x1000-0x1fff
>>> pci 0000:00:1c.0:   MEM window: 0x90200000-0x902fffff
>>> pci 0000:00:1c.0:   PREFETCH window: 0x00000090500000-0x000000905fffff
>>> pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
>>> pci 0000:00:1c.1:   IO window: disabled
>>> pci 0000:00:1c.1:   MEM window: 0x90100000-0x901fffff
>>> pci 0000:00:1c.1:   PREFETCH window: disabled
>>> pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
>>> pci 0000:00:1e.0:   IO window: disabled
>>> pci 0000:00:1e.0:   MEM window: 0x90000000-0x900fffff
>>> pci 0000:00:1e.0:   PREFETCH window: disabled
>>> pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
>>> pci 0000:00:1c.0: setting latency timer to 64
>>> pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
>>> pci 0000:00:1c.1: setting latency timer to 64
>>> pci 0000:00:1e.0: power state changed by ACPI to D0
>>> pci 0000:00:1e.0: setting latency timer to 64
>>> pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
>>> pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
>>> pci_bus 0000:01: resource 0 io:  [0x1000-0x1fff]
>>> pci_bus 0000:01: resource 1 mem: [0x90200000-0x902fffff]
>>> pci_bus 0000:01: resource 2 mem: [0x90500000-0x905fffff]
>>> pci_bus 0000:01: resource 3 mem: [0x0-0x0]
>>> pci_bus 0000:02: resource 0 mem: [0x0-0x0]
>>> pci_bus 0000:02: resource 1 mem: [0x90100000-0x901fffff]
>>> pci_bus 0000:02: resource 2 mem: [0x0-0x0]
>>> pci_bus 0000:02: resource 3 mem: [0x0-0x0]
>>> pci_bus 0000:03: resource 0 mem: [0x0-0x0]
>>> pci_bus 0000:03: resource 1 mem: [0x90000000-0x900fffff]
>>> pci_bus 0000:03: resource 2 mem: [0x0-0x0]
>>> pci_bus 0000:03: resource 3 io:  [0x00-0xffff]
>>> pci_bus 0000:03: resource 4 mem: [0x000000-0xffffffffffffffff]
>>> NET: Registered protocol family 2
>>> IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
>>> TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
>>> TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
>>> TCP: Hash tables configured (established 262144 bind 65536)
>>> TCP reno registered
>>> NET: Registered protocol family 1
>>> checking if image is initramfs... it is
>>> Freeing initrd memory: 1088k freed
>>> Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>>> HugeTLB registered 2 MB page size, pre-allocated 0 pages
>>> Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
>>> msgmni has been set to 3953
>>> alg: No test for stdrng (krng)
>>> io scheduler noop registered
>>> io scheduler anticipatory registered
>>> io scheduler deadline registered
>>> io scheduler cfq registered (default)
>>> pci 0000:00:02.0: Boot video device
>>> ACPI: AC Adapter [ADP1] (on-line)
>>> Switched to high resolution mode on CPU 1
>>> Switched to high resolution mode on CPU 0
>>> ACPI: Battery Slot [BAT0] (battery present)
>>> input: Power Button (FF) as /class/input/input0
>>> ACPI: Power Button (FF) [PWRF]
>>> input: Lid Switch as /class/input/input1
>>> ACPI: Lid Switch [LID0]
>>> input: Power Button (CM) as /class/input/input2
>>> ACPI: Power Button (CM) [PWRB]
>>> input: Sleep Button (CM) as /class/input/input3
>>> ACPI: Sleep Button (CM) [SLPB]
>>> ACPI: SSDT 7EEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
>>> ACPI: SSDT 7EEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
>>> Monitor-Mwait will be used to enter C-1 state
>>> Monitor-Mwait will be used to enter C-2 state
>>> Monitor-Mwait will be used to enter C-3 state
>>> ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
>>> processor ACPI_CPU:00: registered as cooling_device0
>>> ACPI: Processor [CPU0] (supports 8 throttling states)
>>> ACPI: SSDT 7EEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
>>> ACPI: SSDT 7EEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
>>> ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
>>> processor ACPI_CPU:01: registered as cooling_device1
>>> ACPI: Processor [CPU1] (supports 8 throttling states)
>>> Real Time Clock Driver v1.12b
>>> intel_rng: FWH not detected
>>> Linux agpgart interface v0.103
>>> agpgart-intel 0000:00:00.0: Intel 945GM Chipset
>>> agpgart-intel 0000:00:00.0: detected 16124K stolen memory
>>> agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x80000000
>>> intelfb: Framebuffer driver for Intel(R)
>>> 830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/945GME/965G/965GM
>>> chipsets
>>> intelfb: Version 0.9.6
>>> intelfb 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> intelfb: 00:02.0: Intel(R) 945GM, aperture size 256MB, stolen memory
>>> 16124kB
>>> intelfb: Non-CRT device is enabled ( LVDS port ).  Disabling mode
>>> switching.
>>> intelfb: Video mode must be programmed at boot time.
>>> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>>> floppy0: no floppy controllers found
>>> brd: module loaded
>>> loop: module loaded
>>> Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
>>> Copyright (c) 1999-2006 Intel Corporation.
>>> e100: Intel(R) PRO/100 Network Driver, 3.5.23-k6-NAPI
>>> e100: Copyright(c) 1999-2006 Intel Corporation
>>> sky2 driver version 1.22
>>> sky2 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> sky2 0000:01:00.0: setting latency timer to 64
>>> sky2 0000:01:00.0: Yukon-2 EC chip revision 2
>>> sky2 0000:01:00.0: Marvell Yukon 88E8053 Gigabit Ethernet Controller
>>>  Part Number: Yukon 88E8053
>>>  Engineering Level: Rev. 2.2
>>>  Manufacturer: Marvell
>>> sky2 0000:01:00.0: irq 24 for MSI/MSI-X
>>> sky2 eth0: addr 00:19:e3:43:1c:a3
>>> console [netcon0] enabled
>>> netconsole: network logging started
>>> Linux video capture interface: v2.00
>>> usbcore: registered new interface driver uvcvideo
>>> USB Video Class driver (v0.1.0)
>>> Uniform Multi-Platform E-IDE driver
>>> piix 0000:00:1f.1: IDE controller (0x8086:0x27df rev 0x02)
>>> pci 0000:00:1f.1: power state changed by ACPI to D0
>>> pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
>>> piix 0000:00:1f.1: not 100% native mode: will probe irqs later
>>>    ide0: BM-DMA at 0x20b0-0x20b7
>>>    ide1: BM-DMA at 0x20b8-0x20bf
>>> Probing IDE interface ide0...
>>> hda: HL-DT-ST DVDRW GSA-S10N, ATAPI CD/DVD-ROM drive
>>> hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
>>> hda: UDMA/33 mode selected
>>> Probing IDE interface ide1...
>>> ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
>>> ide1 at 0x170-0x177,0x376 on irq 15
>>> ide_generic: please use "probe_mask=0x3f" module parameter for probing
>>> all legacy ISA IDE ports
>>> ide-gd driver 1.18
>>> ide-cd driver 5.00
>>> ide-cd: hda: ATAPI 24X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
>>> Uniform CD-ROM driver Revision: 3.20
>>> 3ware Storage Controller device driver for Linux v1.26.02.002.
>>> Driver 'sd' needs updating - please use bus_type methods
>>> Driver 'sr' needs updating - please use bus_type methods
>>> ata_piix 0000:00:1f.2: version 2.12
>>> ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>> ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
>>> ata_piix 0000:00:1f.2: setting latency timer to 64
>>> scsi0 : ata_piix
>>> scsi1 : ata_piix
>>> ata1: SATA max UDMA/133 cmd 0x20c8 ctl 0x20ec bmdma 0x20a0 irq 19
>>> ata2: SATA max UDMA/133 cmd 0x20c0 ctl 0x20e8 bmdma 0x20a8 irq 19
>>> ata1.01: ATA-7: ST9160821AS, 3.CAE, max UDMA/133
>>> ata1.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
>>> ata1.01: configured for UDMA/133
>>> isa bounce pool size: 16 pages
>>> scsi 0:0:1:0: Direct-Access     ATA      ST9160821AS      3.CA PQ: 0 ANSI:
>>> 5
>>> sd 0:0:1:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
>>> sd 0:0:1:0: [sda] Write Protect is off
>>> sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
>>> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>>> support DPO or FUA
>>> sd 0:0:1:0: [sda] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
>>> sd 0:0:1:0: [sda] Write Protect is off
>>> sd 0:0:1:0: [sda] Mode Sense: 00 3a 00 00
>>> sd 0:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't
>>> support DPO or FUA
>>>  sda: sda1 sda2 sda3 sda4
>>> sd 0:0:1:0: [sda] Attached SCSI disk
>>> sd 0:0:1:0: Attached scsi generic sg0 type 0
>>> Fusion MPT base driver 3.04.07
>>> Copyright (c) 1999-2008 LSI Corporation
>>> Fusion MPT SPI Host driver 3.04.07
>>> ohci1394 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
>>> ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]
>>> MMIO=[90000000-900007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
>>> ieee1394: raw1394: /dev/raw1394 device initialized
>>> ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>> ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
>>> ehci_hcd 0000:00:1d.7: setting latency timer to 64
>>> ehci_hcd 0000:00:1d.7: EHCI Host Controller
>>> ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
>>> ehci_hcd 0000:00:1d.7: debug port 1
>>> ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
>>> ehci_hcd 0000:00:1d.7: irq 21, io mem 0x90445400
>>> ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
>>> usb usb1: configuration #1 chosen from 1 choice
>>> hub 1-0:1.0: USB hub found
>>> hub 1-0:1.0: 8 ports detected
>>> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> uhci_hcd: USB Universal Host Controller Interface driver
>>> uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
>>> uhci_hcd 0000:00:1d.0: setting latency timer to 64
>>> uhci_hcd 0000:00:1d.0: UHCI Host Controller
>>> uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
>>> uhci_hcd 0000:00:1d.0: irq 21, io base 0x00002080
>>> usb usb2: configuration #1 chosen from 1 choice
>>> hub 2-0:1.0: USB hub found
>>> hub 2-0:1.0: 2 ports detected
>>> uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
>>> uhci_hcd 0000:00:1d.1: setting latency timer to 64
>>> uhci_hcd 0000:00:1d.1: UHCI Host Controller
>>> uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
>>> uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002060
>>> usb usb3: configuration #1 chosen from 1 choice
>>> hub 3-0:1.0: USB hub found
>>> hub 3-0:1.0: 2 ports detected
>>> uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
>>> uhci_hcd 0000:00:1d.2: setting latency timer to 64
>>> uhci_hcd 0000:00:1d.2: UHCI Host Controller
>>> uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
>>> uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002040
>>> usb usb4: configuration #1 chosen from 1 choice
>>> hub 4-0:1.0: USB hub found
>>> hub 4-0:1.0: 2 ports detected
>>> uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
>>> uhci_hcd 0000:00:1d.3: setting latency timer to 64
>>> uhci_hcd 0000:00:1d.3: UHCI Host Controller
>>> uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
>>> uhci_hcd 0000:00:1d.3: irq 16, io base 0x00002020
>>> usb usb5: configuration #1 chosen from 1 choice
>>> hub 5-0:1.0: USB hub found
>>> hub 5-0:1.0: 2 ports detected
>>> usbcore: registered new interface driver usblp
>>> Initializing USB Mass Storage driver...
>>> usbcore: registered new interface driver usb-storage
>>> USB Mass Storage support registered.
>>> PNP: No PS/2 controller found. Probing ports directly.
>>> i8042.c: No controller found.
>>> mice: PS/2 mouse device common for all mice
>>> device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised:
>>> dm-devel@redhat.com
>>> cpuidle: using governor ladder
>>> cpuidle: using governor menu
>>> Marking TSC unstable due to TSC halts in idle
>>> usbcore: registered new interface driver usbhid
>>> usbhid: v2.6:USB HID core driver
>>> oprofile: using NMI interrupt.
>>> Netfilter messages via NETLINK v0.30.
>>> nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
>>> CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
>>> nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
>>> sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
>>> xt_time: kernel timezone is -0000
>>> ip_tables: (C) 2000-2006 Netfilter Core Team
>>> arp_tables: (C) 2002 David S. Miller
>>> TCP cubic registered
>>> NET: Registered protocol family 10
>>> IPv6 over IPv4 tunneling driver
>>> NET: Registered protocol family 17
>>> RPC: Registered udp transport module.
>>> RPC: Registered tcp transport module.
>>> registered taskstats version 1
>>> Freeing unused kernel memory: 372k freed
>>> usb 1-1: new high speed USB device using ehci_hcd and address 2
>>> usb 1-1: configuration #1 chosen from 1 choice
>>> scsi2 : SCSI emulation for USB Mass Storage devices
>>> usb-storage: device found at 2
>>> usb-storage: waiting for device to settle before scanning
>>> usb 1-3: new high speed USB device using ehci_hcd and address 4
>>> usb 1-3: configuration #1 chosen from 1 choice
>>> hub 1-3:1.0: USB hub found
>>> hub 1-3:1.0: 2 ports detected
>>> Clocksource tsc unstable (delta = -265511863 ns)
>>> usb 1-4: new high speed USB device using ehci_hcd and address 5
>>> usb 1-4: configuration #1 chosen from 1 choice
>>> ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001cb3fffe8ab416]
>>> usb 2-2: new full speed USB device using uhci_hcd and address 2
>>> usb 2-2: configuration #1 chosen from 1 choice
>>> input: Apple Computer Apple Internal Keyboard / Trackpad as
>>> /class/input/input4
>>> apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard [Apple
>>> Computer Apple Internal Keyboard / Trackpad] on
>>> usb-0000:00:1d.0-2/input0
>>> input: Apple Computer Apple Internal Keyboard / Trackpad as
>>> /class/input/input5
>>> apple 0003:05AC:021A.0002: input: USB HID v1.11 Device [Apple Computer
>>> Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2/input2
>>> usb 4-2: new full speed USB device using uhci_hcd and address 2
>>> usb 4-2: configuration #1 chosen from 1 choice
>>> generic-usb 0003:05AC:8240.0003: claimed by neither input, hiddev nor
>>> hidraw
>>> usb 5-1: new full speed USB device using uhci_hcd and address 2
>>> usb 5-1: configuration #1 chosen from 1 choice
>>> input: HID 05ac:1000 as /class/input/input6
>>> generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 Keyboard [HID
>>> 05ac:1000] on usb-0000:00:1d.3-1/input0
>>> input: HID 05ac:1000 as /class/input/input7
>>> generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 Mouse [HID
>>> 05ac:1000] on usb-0000:00:1d.3-1/input1
>>> usb 1-3.1: new high speed USB device using ehci_hcd and address 8
>>> usb 1-3.1: configuration #1 chosen from 1 choice
>>> hub 1-3.1:1.0: USB hub found
>>> hub 1-3.1:1.0: 4 ports detected
>>> usb 1-3.2: new low speed USB device using ehci_hcd and address 9
>>> usb 1-3.2: configuration #1 chosen from 1 choice
>>> input: Logitech USB Mouse as /class/input/input8
>>> generic-usb 0003:046D:C00C.0006: input: USB HID v1.10 Mouse [Logitech
>>> USB Mouse] on usb-0000:00:1d.7-3.2/input0
>>> usb 1-3.1.1: new high speed USB device using ehci_hcd and address 10
>>> usb 1-3.1.1: configuration #1 chosen from 1 choice
>>> scsi3 : SCSI emulation for USB Mass Storage devices
>>> usb-storage: device found at 10
>>> usb-storage: waiting for device to settle before scanning
>>> usb 1-3.1.3: new high speed USB device using ehci_hcd and address 11
>>> usb 1-3.1.3: configuration #1 chosen from 1 choice
>>> hub 1-3.1.3:1.0: USB hub found
>>> hub 1-3.1.3:1.0: 3 ports detected
>>> usb 1-3.1.4: new high speed USB device using ehci_hcd and address 12
>>> usb 1-3.1.4: configuration #1 chosen from 1 choice
>>> scsi4 : SCSI emulation for USB Mass Storage devices
>>> usb-storage: device found at 12
>>> usb-storage: waiting for device to settle before scanning
>>> usb 1-3.1.3.1: new low speed USB device using ehci_hcd and address 13
>>> usb 1-3.1.3.1: configuration #1 chosen from 1 choice
>>> input: No brand KVM as /class/input/input9
>>> generic-usb 0003:10D5:5552.0007: input: USB HID v1.10 Keyboard [No
>>> brand KVM] on usb-0000:00:1d.7-3.1.3.1/input0
>>> input: No brand KVM as /class/input/input10
>>> generic-usb 0003:10D5:5552.0008: input: USB HID v1.10 Mouse [No brand
>>> KVM] on usb-0000:00:1d.7-3.1.3.1/input1
>>> scsi 2:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI:
>>> 4
>>> sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
>>> sd 2:0:0:0: [sdb] Write Protect is off
>>> sd 2:0:0:0: [sdb] Mode Sense: 10 00 00 00
>>> sd 2:0:0:0: [sdb] Assuming drive cache: write through
>>> sd 2:0:0:0: [sdb] 625142448 512-byte hardware sectors: (320 GB/298 GiB)
>>> sd 2:0:0:0: [sdb] Write Protect is off
>>> sd 2:0:0:0: [sdb] Mode Sense: 10 00 00 00
>>> sd 2:0:0:0: [sdb] Assuming drive cache: write through
>>>  sdb: sdb1 < sdb5 sdb6 >
>>> sd 2:0:0:0: [sdb] Attached SCSI disk
>>> sd 2:0:0:0: Attached scsi generic sg1 type 0
>>> usb-storage: device scan complete
>>> kjournald starting.  Commit interval 5 seconds
>>> EXT3-fs: mounted filesystem with ordered data mode.
>>> udev: renamed network interface eth0 to eth1
>>> scsi 3:0:0:0: Direct-Access     Generic  Flash HS-CF      4.44 PQ: 0 ANSI:
>>> 0
>>> sd 3:0:0:0: [sdc] Attached SCSI removable disk
>>> sd 3:0:0:0: Attached scsi generic sg2 type 0
>>> usb-storage: device scan complete
>>> applesmc: Apple MacBook (v2) detected:
>>> applesmc:  - Model with accelerometer
>>> applesmc:  - Model without light sensors and backlight
>>> applesmc:  - Model with 10 temperature sensors
>>> applesmc: device has already been initialized (0xe0, 0xf8).
>>> applesmc: device successfully initialized.
>>> applesmc: 1 fans found.
>>> input: applesmc as /class/input/input11
>>> applesmc: driver successfully loaded.
>>> input: PC Speaker as /class/input/input12
>>> scsi 4:0:0:0: Direct-Access     Maxtor 6 L200R0           BAH4 PQ: 0 ANSI:
>>> 0
>>> sd 4:0:0:0: [sdd] 398297087 512-byte hardware sectors: (203 GB/189 GiB)
>>> sd 4:0:0:0: [sdd] Write Protect is off
>>> sd 4:0:0:0: [sdd] Mode Sense: 03 00 00 00
>>> sd 4:0:0:0: [sdd] Assuming drive cache: write through
>>> sd 4:0:0:0: [sdd] 398297087 512-byte hardware sectors: (203 GB/189 GiB)
>>> sd 4:0:0:0: [sdd] Write Protect is off
>>> sd 4:0:0:0: [sdd] Mode Sense: 03 00 00 00
>>> sd 4:0:0:0: [sdd] Assuming drive cache: write through
>>>  sdd: sdd1
>>> sd 4:0:0:0: [sdd] Attached SCSI disk
>>> sd 4:0:0:0: Attached scsi generic sg3 type 0
>>> usb-storage: device scan complete
>>> appletouch: Geyser mode initialized.
>>> input: appletouch as /class/input/input13
>>> usbcore: registered new interface driver appletouch
>>> HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
>>> HDA Intel 0000:00:1b.0: setting latency timer to 64
>>> hda_codec: STAC922x, Apple subsys_id=106b2200
>>> input: HDA Intel Line In at Ext Left Jack as /class/input/input14
>>> input: HDA Intel Mic at Ext Left Jack as /class/input/input15
>>> input: HDA Intel HP Out at Ext Left Jack as /class/input/input16
>>> EXT3 FS on dm-2, internal journal
>>> fuse init (API version 7.11)
>>> usbcore: registered new interface driver usbserial
>>> USB Serial support registered for generic
>>> usbcore: registered new interface driver usbserial_generic
>>> usbserial: USB Serial Driver core
>>> USB Serial support registered for pl2303
>>> usbcore: registered new interface driver pl2303
>>> pl2303: Prolific PL2303 USB to serial adaptor driver
>>> EXT4-fs: barriers enabled
>>> kjournald2 starting: pid 4443, dev dm-0:8, commit interval 5 seconds
>>> EXT4 FS on dm-0, internal journal on dm-0:8
>>> EXT4-fs: delayed allocation enabled
>>> EXT4-fs: mballoc enabled
>>> EXT4-fs: mounted filesystem dm-0 with ordered data mode
>>> EXT4-fs: barriers enabled
>>> kjournald2 starting: pid 4444, dev dm-4:8, commit interval 5 seconds
>>> EXT4 FS on dm-4, internal journal on dm-4:8
>>> EXT4-fs: delayed allocation enabled
>>> EXT4-fs: mballoc enabled
>>> EXT4-fs: mounted filesystem dm-4 with ordered data mode
>>> EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
>>> Adding 1048568k swap on /dev/mapper/s-swap.  Priority:-1 extents:1
>>> across:1048568k
>>> sky2 eth1: enabling interface
>>> ADDRCONF(NETDEV_UP): eth1: link is not ready
>>> sky2 eth1: Link is up at 1000 Mbps, full duplex, flow control both
>>> ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
>>> eth1: no IPv6 routers present
>>> [drm] Initialized drm 1.1.0 20060810
>>> pci 0000:00:02.0: setting latency timer to 64
>>> [drm] Initialized i915 1.6.0 20080730 on minor 0
>>> JBD: barrier-based sync failed on dm-0:8 - disabling barriers
>>> CE: hpet increasing min_delta_ns to 15000 nsec
>>> ACPI: EC: GPE storm detected, transactions will use polling mode
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I see ACPI: EC: GPE storm detected, transactions will use polling mode
which might cause stuck-age(try booting without the battery), as for
the kernel itself I had no issue with all the way up to
2.6.29-rc8-00302-ge2fad3f
(a few hours before the initial release of 2.6.29)
if you need my .config let me know(although its not pretty).

-- 
Justin P. Mattock
