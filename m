Return-Path: <linux-kernel-owner+w=401wt.eu-S1760477AbYBKTeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760477AbYBKTeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbYBKTd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:33:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:43342 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612AbYBKTdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:33:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=Q3jvLjTGglOTfD1ecUX7GmjO5ffr+D7vstgbVP6QkVV9IQtx7KN8xoBAj6brVZhJuBfnUZA3R5/GPeTc87rKZut4JsbG65y8LkpTVjVpGxbv+gxA4muHnpQNFYAdmXS2/KxVsGA96Xpd6rZaSqaYABAz+YV7rTIorCuSfWqXQ38=
Message-ID: <47B0A3E0.4050908@gmail.com>
Date: Mon, 11 Feb 2008 17:37:04 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
CC: Calvin Walton <calvin.walton@gmail.com>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
References: <47AFDC4D.4070400@gmail.com> <1202708864.5206.0.camel@zem> <924EFEDD5F540B4284297C4DC59F3DEE8608D3@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE8608D3@orsmsx423.amr.corp.intel.com>
Content-Type: multipart/mixed;
 boundary="------------040309060100050903030900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040309060100050903030900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Pallipadi, Venkatesh wrote:
>> -----Original Message-----
>> From: Calvin Walton [mailto:calvin.walton@gmail.com] 
>> Sent: Sunday, February 10, 2008 9:48 PM
>> To: Carlos R. Mafra
>> Cc: linux-kernel@vger.kernel.org; Pallipadi, Venkatesh
>> Subject: Re: [2.6.25-rc1 regression] Suspend to RAM (bisected)
>>
>> On Mon, 2008-02-11 at 03:25 -0200, Carlos R. Mafra wrote: 
>>> Hi,
>>>
>>> I want to report that suspend to RAM stopped working on my Sony Vaio 
>>> VGN-FZ240E in 2.6.25-rc1 and that I could bisect the problem down
>>> to:
>>>
>>> commit bc71bec91f9875ef825d12104acf3bf4ca215fa4
>>> Author: venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com>
>>> Date:   Thu Jan 31 17:35:04 2008 -0800
>>>
>>>     ACPI: enable MWAIT for C1 idle
>> I normally hate to throw in a 'me-too', but I'm also seeing a
>> suspend-to-ram regression on my Thinkpad R61i that I've managed to
>> bisect down to the same patch series.
>>
> 
> Carlos, Calvin,
> 
> Can you send me the output of acpidump and full dmesg to me. Looks like
> it is a platform issue due to which we cannot use C1 mwait idle during
> suspend resume, something similar to issue we had with using C2/C3 state
> during idle.

Full dmesg and acpidump outputs are attached.
 
> Thanks,
> Venki 

Thank you for looking at it,
Carlos
 


--------------040309060100050903030900
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Linux version 2.6.25-rc1 (mafra@Pilar) (gcc version 4.2.2 20070909 (prerelease) (4.2.2-0.RC.1mdv2008.0)) #19 SMP Mon Feb 11 09:30:23 BRST 2008
Command line: BOOT_IMAGE=2.6.25-rc1 root=/dev/sda6 resume=/dev/sda8 splash=silent vga=0x0364
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6e0000 (ACPI data)
 BIOS-e820: 000000007f6e0000 - 000000007f6e3000 (ACPI NVS)
 BIOS-e820: 000000007f6e3000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 521936) 1 entries of 256 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000F8060, 0024 (r2 PTLTD )
ACPI: XSDT 7F6D7E0E, 008C (r1   Sony     VAIO 20070704 PTL         0)
ACPI: FACP 7F6DFC04, 00F4 (r3   Sony     VAIO 20070704 PTL         1)
ACPI: DSDT 7F6D9217, 6979 (r2   Sony     VAIO 20070704 PTL  20050624)
ACPI: FACS 7F6E2FC0, 0040
ACPI: APIC 7F6DFCF8, 0068 (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: HPET 7F6DFD60, 0038 (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: MCFG 7F6DFD98, 003C (r1   Sony     VAIO 20070704 PTL        5A)
ACPI: SLIC 7F6DFDD4, 0176 (r1   Sony     VAIO 20070704 PTL   1000000)
ACPI: TMOR 7F6DFF4A, 0026 (r1   Sony     VAIO 20070704 PTL         3)
ACPI: APIC 7F6DFF70, 0068 (r1   Sony     VAIO 20070704 PTL         0)
ACPI: BOOT 7F6DFFD8, 0028 (r1   Sony     VAIO 20070704 PTL         1)
ACPI: SSDT 7F6D90FA, 011D (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8FD7, 0123 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8482, 0287 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D83CE, 00B4 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D7E9A, 0534 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: DMI detected: Sony
Entering add_active_range(0, 0, 159) 0 entries of 256 used
Entering add_active_range(0, 256, 521936) 1 entries of 256 used
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-65f4cf] TEXT DATA BSS
early res: 3 [37f82000-37fef0c9] RAMDISK
early res: 4 [9f800-a07ff] EBDA
early res: 5 [8000-bfff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   521936
On node 0 totalpages: 521839
  DMA zone: 56 pages used for memmap
  DMA zone: 1129 pages reserved
  DMA zone: 2814 pages, LIFO batch:0
  DMA32 zone: 7079 pages used for memmap
  DMA32 zone: 510761 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000dc000
PM: Registered nosave memory: 00000000000dc000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 32736 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 513575
Kernel command line: BOOT_IMAGE=2.6.25-rc1 root=/dev/sda6 resume=/dev/sda8 splash=silent vga=0x0364
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 1994.983 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
------------------------
| Locking API testsuite:
----------------------------------------------------------------------------
                                 | spin |wlock |rlock |mutex | wsem | rsem |
  --------------------------------------------------------------------------
                     A-A deadlock:failed|failed|  ok  |failed|failed|failed|
                 A-B-B-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-B-C-C-A deadlock:failed|failed|  ok  |failed|failed|failed|
             A-B-C-A-B-C deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-B-C-C-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-D-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
         A-B-C-D-B-C-D-A deadlock:failed|failed|  ok  |failed|failed|failed|
                    double unlock:failed|failed|failed|failed|failed|failed|
                  initialize held:failed|failed|failed|failed|failed|failed|
                 bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
  --------------------------------------------------------------------------
              recursive read-lock:             |  ok  |             |failed|
           recursive read-lock #2:             |  ok  |             |failed|
            mixed read-write-lock:             |failed|             |failed|
            mixed write-read-lock:             |failed|             |failed|
  --------------------------------------------------------------------------
     hard-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/12:failed|failed|  ok  |
     hard-irqs-on + irq-safe-A/21:failed|failed|  ok  |
     soft-irqs-on + irq-safe-A/21:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/12:failed|failed|  ok  |
       sirq-safe-A => hirqs-on/21:failed|failed|  ok  |
         hard-safe-A + irqs-on/12:failed|failed|  ok  |
         soft-safe-A + irqs-on/12:failed|failed|  ok  |
         hard-safe-A + irqs-on/21:failed|failed|  ok  |
         soft-safe-A + irqs-on/21:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #1/321:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/123:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/132:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/213:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/231:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/312:failed|failed|  ok  |
    hard-safe-A + unsafe-B #2/321:failed|failed|  ok  |
    soft-safe-A + unsafe-B #2/321:failed|failed|  ok  |
      hard-irq lock-inversion/123:failed|failed|  ok  |
      soft-irq lock-inversion/123:failed|failed|  ok  |
      hard-irq lock-inversion/132:failed|failed|  ok  |
      soft-irq lock-inversion/132:failed|failed|  ok  |
      hard-irq lock-inversion/213:failed|failed|  ok  |
      soft-irq lock-inversion/213:failed|failed|  ok  |
      hard-irq lock-inversion/231:failed|failed|  ok  |
      soft-irq lock-inversion/231:failed|failed|  ok  |
      hard-irq lock-inversion/312:failed|failed|  ok  |
      soft-irq lock-inversion/312:failed|failed|  ok  |
      hard-irq lock-inversion/321:failed|failed|  ok  |
      soft-irq lock-inversion/321:failed|failed|  ok  |
      hard-irq read-recursion/123:  ok  |
      soft-irq read-recursion/123:  ok  |
      hard-irq read-recursion/132:  ok  |
      soft-irq read-recursion/132:  ok  |
      hard-irq read-recursion/213:  ok  |
      soft-irq read-recursion/213:  ok  |
      hard-irq read-recursion/231:  ok  |
      soft-irq read-recursion/231:  ok  |
      hard-irq read-recursion/312:  ok  |
      soft-irq read-recursion/312:  ok  |
      hard-irq read-recursion/321:  ok  |
      soft-irq read-recursion/321:  ok  |
--------------------------------------------------------
145 out of 218 testcases failed, as expected. |
----------------------------------------------------
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Memory: 2049776k/2087744k available (2441k kernel code, 36936k reserved, 1182k data, 244k init)
CPA: page pool initialized 32 of 32 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 3994.42 BogoMIPS (lpj=7988852)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12468662
Detected 12.468 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3989.99 BogoMIPS (lpj=7979984)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     T7250  @ 2.00GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 3
  groups: 1 2
CPU1 attaching sched-domain:
 domain 0: span 3
  groups: 2 1
net_namespace: 304 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
hpet0: 3 64-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:01: iomem range 0xfed40000-0xfed44fff could not be reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
system 00:06: ioport range 0x680-0x69f has been reserved
system 00:06: ioport range 0x800-0x80f has been reserved
system 00:06: ioport range 0x1000-0x107f has been reserved
system 00:06: ioport range 0x1180-0x11bf has been reserved
system 00:06: ioport range 0x1640-0x164f has been reserved
system 00:06: ioport range 0xfe00-0xfe7f has been reserved
system 00:06: ioport range 0xfe80-0xfeff has been reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: 0xf6000000-0xf7ffffff
  PREFETCH window: 0x00000000f0000000-0x00000000f1ffffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: 0xf8000000-0xf9ffffff
  PREFETCH window: 0x00000000f2000000-0x00000000f3ffffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: 0xfa000000-0xfbffffff
  PREFETCH window: 0x00000000f4000000-0x00000000f5ffffff
PCI: Bridge: 0000:00:1c.4
  IO window: 5000-5fff
  MEM window: 0xfc200000-0xfc2fffff
  PREFETCH window: disabled.
PCI: Bus 10, cardbus bridge: 0000:09:03.0
  IO window: 0x00001400-0x000014ff
  IO window: 0x00006000-0x000060ff
  PREFETCH window: 0x8c000000-0x8fffffff
  MEM window: 0x90000000-0x93ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xfc300000-0xfc3fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:09:03.0[A] -> GSI 16 (level, low) -> IRQ 16
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 436k freed
Simple Boot Flag at 0x36 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20000080000, using 4000k, total 7616k
vesafb: mode is 1280x800x16, linelength=2560, pages=2
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 160x50
fb0: VESA VGA frame buffer device
ACPI: AC Adapter [ADP1] (on-line)
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
ACPI: Battery Slot [BAT0] (battery present)
input: Lid Switch as /class/input/input0
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /class/input/input1
ACPI: Power Button (CM) [PWRB]
ACPI: SSDT 7F6D8C52, 02A1 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8709, 04B7 (r1   Sony     VAIO 20070704 PTL  20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6D8EF3, 00E4 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: SSDT 7F6D8BC0, 0092 (r1   Sony     VAIO 20070704 PTL  20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [TZ00] (55 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [TZ01] (55 C)
hpet_resources: 0xfed00000 is busy
Generic RTC Driver v1.07
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
brd: module loaded
sony-laptop: Sony Notebook Control Driver v0.6.
input: Sony Vaio Keys as /class/input/input2
input: Sony Vaio Jogdial as /class/input/input3
sony-laptop: detected Sony Vaio FZ Series
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input4
input: PS/2 Mouse as /class/input/input5
input: AlpsPS/2 ALPS GlidePoint as /class/input/input6
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
Marking TSC unstable due to TSC halts in idle
Time: hpet clocksource has been installed.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 15
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 244k freed
SCSI subsystem initialized
libata version 3.00 loaded.
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
Clocksource tsc unstable (delta = -1013352280 ns)
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 abar m2048@0xfc604000 port 0xfc604100 irq 19
ata2: DUMMY
ata3: DUMMY
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: FUJITSU MHX2250BT, 0041000B, max UDMA/100
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHX2250B 0041 PQ: 0 ANSI: 5
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata4.00: ATAPI: SONY    DVD RW AW-G540A, 1.W0, max UDMA/33
ata4.00: configured for UDMA/33
scsi 3:0:0:0: CD-ROM            SONY     DVD RW AW-G540A  1.W0 PQ: 0 ANSI: 5
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 3:0:0:0: Attached scsi generic sg1 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
ACPI: PCI Interrupt 0000:09:03.1[B] -> GSI 17 (level, low) -> IRQ 17
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[fc302000-fc3027ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:08:00.0 to 64
sky2 0000:08:00.0: v1.21 addr 0xfc200000 irq 16 Yukon-FE (0xb7) rev 1
sky2 eth0: addr 00:1a:80:4a:7f:37
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 19 (level, low) -> IRQ 19
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfc604800
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
USB Universal Host Controller Interface driver v3.0
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23k
iwl4965: Copyright(c) 2003-2007 Intel Corporation
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfc604c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-rc1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-rc1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: New USB device found, idVendor=05ca, idProduct=183b
usb 1-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25-rc1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25-rc1 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018a0
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.25-rc1 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:06:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
iwl4965: Tunable channels: 11 802.11bg, 13 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI interrupt for device 0000:06:00.0 disabled
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0800460302903fd0]
Non-volatile memory driver v1.2
ACPI: PCI Interrupt 0000:09:03.2[C] -> GSI 18 (level, low) -> IRQ 18
ACPI: device:08 is registered as cooling_device2
input: Video Bus as /class/input/input7
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
EXT3 FS on sda6, internal journal
Adding 4281280k swap on /dev/sda8.  Priority:-1 extents:1 across:4281280k
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
loop: module loaded
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NET: Registered protocol family 17
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PM: Writing back config space on device 0000:06:00.0 at offset 1 (was 40100102, writing 40100106)
wlan0: Initial auth_alg=0
wlan0: authenticate with AP 00:19:5b:dc:82:ba
wlan0: RX authentication from 00:19:5b:dc:82:ba (alg=0 transaction=2 status=0)
wlan0: authenticated
wlan0: associate with AP 00:19:5b:dc:82:ba
wlan0: RX AssocResp from 00:19:5b:dc:82:ba (capab=0x431 status=0 aid=2)
wlan0: associated
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0

--------------040309060100050903030900
Content-Type: text/plain;
 name="acpidump.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpidump.txt"

DSDT @ 0x7f6d9217
  0000: 44 53 44 54 79 69 00 00 02 f8 53 6f 6e 79 00 00  DSDTyi....Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 5b 80 53 4d 49 30 00 0c 38 2b 6e 7f  $.. [.SMI0..8+n.
  0030: 0c 15 04 00 00 5b 81 17 53 4d 49 30 00 42 43 4d  .....[..SMI0.BCM
  0040: 44 08 44 49 44 5f 20 49 4e 46 4f 80 00 01 5b 81  D.DID_ INFO...[.
  0050: 0d 53 4d 49 30 00 00 28 49 4e 46 42 08 5b 81 0d  .SMI0..(INFB.[..
  0060: 53 4d 49 30 00 00 28 49 4e 46 44 20 5b 81 0e 53  SMI0..(INFD [..S
  0070: 4d 49 30 00 00 28 49 4e 44 44 40 04 5b 81 0f 53  MI0..(INDD@.[..S
  0080: 4d 49 30 00 00 28 53 58 42 46 80 08 02 5b 81 12  MI0..(SXBF...[..
  0090: 53 4d 49 30 00 00 28 49 4e 46 31 08 49 4e 46 32  SMI0..(INF1.INF2
  00a0: 08 5b 80 53 4d 49 31 01 0c 00 fe 00 00 0c 02 00  .[.SMI1.........
  00b0: 00 00 5b 81 0b 53 4d 49 31 00 53 4d 49 43 08 5b  ..[..SMI1.SMIC.[
  00c0: 01 4d 50 48 53 00 14 20 50 48 53 30 01 70 68 42  .MPHS.. PHS0.phB
  00d0: 43 4d 44 70 00 53 4d 49 43 a2 07 93 42 43 4d 44  CMDp.SMIC...BCMD
  00e0: 68 70 00 42 43 4d 44 14 27 50 48 53 5f 09 5b 23  hp.BCMD.'PHS_.[#
  00f0: 4d 50 48 53 ff ff 70 00 44 49 44 5f 50 48 53 30  MPHS..p.DID_PHS0
  0100: 68 70 49 4e 46 44 60 5b 27 4d 50 48 53 a4 60 14  hpINFD`['MPHS.`.
  0110: 2d 50 48 53 44 0a 5b 23 4d 50 48 53 ff ff 70 00  -PHSD.[#MPHS..p.
  0120: 44 49 44 5f 70 69 49 4e 46 44 50 48 53 30 68 70  DID_piINFDPHS0hp
  0130: 49 4e 46 44 60 5b 27 4d 50 48 53 a4 60 14 2d 50  INFD`['MPHS.`.-P
  0140: 48 44 44 0a 5b 23 4d 50 48 53 ff ff 70 00 44 49  HDD.[#MPHS..p.DI
  0150: 44 5f 70 69 49 4e 44 44 50 48 53 30 68 70 49 4e  D_piINDDPHS0hpIN
  0160: 44 44 60 5b 27 4d 50 48 53 a4 60 14 33 50 48 53  DD`['MPHS.`.3PHS
  0170: 57 0b 5b 23 4d 50 48 53 ff ff 70 00 44 49 44 5f  W.[#MPHS..p.DID_
  0180: 70 69 49 4e 46 31 70 6a 49 4e 46 32 50 48 53 30  piINF1pjINF2PHS0
  0190: 68 70 49 4e 46 42 60 5b 27 4d 50 48 53 a4 60 14  hpINFB`['MPHS.`.
  01a0: 2d 50 48 53 42 0a 5b 23 4d 50 48 53 ff ff 70 00  -PHSB.[#MPHS..p.
  01b0: 44 49 44 5f 70 69 49 4e 46 42 50 48 53 30 68 70  DID_piINFBPHS0hp
  01c0: 49 4e 46 42 60 5b 27 4d 50 48 53 a4 60 5b 01 4d  INFB`['MPHS.`[.M
  01d0: 55 54 58 00 5b 80 50 52 54 30 01 0a 80 0a 04 5b  UTX.[.PRT0.....[
  01e0: 81 0b 50 52 54 30 13 50 38 30 48 20 14 4e 07 50  ..PRT0.P80H .N.P
  01f0: 38 58 48 0a a0 17 93 68 00 70 7d 7b 50 38 30 44  8XH....h.p}{P80D
  0200: 0c 00 ff ff ff 00 69 00 50 38 30 44 a0 1b 93 68  ......i.P80D...h
  0210: 01 70 7d 7b 50 38 30 44 0c ff 00 ff ff 00 79 69  .p}{P80D......yi
  0220: 0a 08 00 00 50 38 30 44 a0 1c 93 68 0a 02 70 7d  ....P80D...h..p}
  0230: 7b 50 38 30 44 0c ff ff 00 ff 00 79 69 0a 10 00  {P80D......yi...
  0240: 00 50 38 30 44 a0 1c 93 68 0a 03 70 7d 7b 50 38  .P80D...h..p}{P8
  0250: 30 44 0c ff ff ff 00 00 79 69 0a 18 00 00 50 38  0D......yi....P8
  0260: 30 44 70 50 38 30 44 50 38 30 48 14 0c 5f 50 49  0DpP80DP80H.._PI
  0270: 43 01 70 68 47 50 49 43 14 4c 04 5f 50 54 53 01  C.phGPIC.L._PTS.
  0280: 72 68 0a 4d 60 44 42 47 43 60 0a 80 42 43 45 4e  rh.M`DBGC`..BCEN
  0290: 70 00 50 38 30 44 50 38 58 48 00 68 70 68 50 52  p.P80DP8XH.hphPR
  02a0: 4d 30 70 0a 51 53 4d 49 46 70 00 54 52 50 30 54  M0p.QSMIFp.TRP0T
  02b0: 52 41 50 0a 50 72 68 0a 4d 60 44 42 47 43 60 0a  RAP.Prh.M`DBGC`.
  02c0: 81 42 43 45 4e 14 4c 1c 5f 57 41 4b 01 7d 68 0a  .BCEN.L._WAK.}h.
  02d0: 50 60 44 42 47 43 60 0a 80 42 43 45 4e 50 38 58  P`DBGC`..BCENP8X
  02e0: 48 01 0a ab 70 68 50 52 4d 30 70 0a 52 53 4d 49  H...phPRM0p.RSMI
  02f0: 46 70 00 54 52 50 30 a0 30 91 93 68 0a 03 93 68  Fp.TRP0.0..h...h
  0300: 0a 04 a0 25 7b 43 46 47 44 0c 00 00 00 01 00 a0  ...%{CFGD.......
  0310: 18 90 7b 43 46 47 44 0a f0 00 93 4f 53 59 53 0b  ..{CFGD....OSYS.
  0320: d1 07 54 52 41 50 0a 3d a0 18 93 52 50 31 44 00  ..TRAP.=...RP1D.
  0330: 86 5c 2f 03 5f 53 42 5f 50 43 49 30 52 50 30 31  .\/._SB_PCI0RP01
  0340: 00 a0 18 93 52 50 32 44 00 86 5c 2f 03 5f 53 42  ....RP2D..\/._SB
  0350: 5f 50 43 49 30 52 50 30 32 00 a0 18 93 52 50 33  _PCI0RP02....RP3
  0360: 44 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 52 50  D..\/._SB_PCI0RP
  0370: 30 33 00 a0 18 93 52 50 35 44 00 86 5c 2f 03 5f  03....RP5D..\/._
  0380: 53 42 5f 50 43 49 30 52 50 30 35 00 a0 0d 93 68  SB_PCI0RP05....h
  0390: 0a 03 a0 07 93 00 41 43 54 54 a0 20 5f 4f 53 49  ......ACTT. _OSI
  03a0: 0d 57 69 6e 64 6f 77 73 20 32 30 30 36 00 70 44  .Windows 2006.pD
  03b0: 45 54 43 60 50 48 53 42 0a e1 60 70 5c 2f 05 5f  ETC`PHSB..`p\/._
  03c0: 53 42 5f 50 43 49 30 4c 50 43 42 45 43 5f 5f 52  SB_PCI0LPCBEC__R
  03d0: 50 57 52 50 57 52 53 70 5c 2f 05 5f 53 42 5f 50  PWRPWRSp\/._SB_P
  03e0: 43 49 30 4c 50 43 42 45 43 5f 5f 52 53 43 4c 42  CI0LPCBEC__RSCLB
  03f0: 30 53 43 70 5c 2f 05 5f 53 42 5f 50 43 49 30 4c  0SCp\/._SB_PCI0L
  0400: 50 43 42 45 43 5f 5f 42 41 54 50 42 4e 55 4d 86  PCBEC__BATPBNUM.
  0410: 5c 2e 5f 53 42 5f 42 41 54 30 0a 80 86 5c 2e 5f  \._SB_BAT0...\._
  0420: 53 42 5f 42 41 54 30 0a 81 a0 29 93 68 0a 04 70  SB_BAT0...).h..p
  0430: 43 4d 37 32 60 70 00 43 4d 37 32 a0 17 92 93 7b  CM72`p.CM72....{
  0440: 60 0a 84 60 0a 84 86 5c 2e 5f 53 42 5f 50 57 52  `..`...\._SB_PWR
  0450: 42 0a 02 a1 17 a0 15 7b 50 4d 53 54 01 00 86 5c  B......{PMST...\
  0460: 2e 5f 53 42 5f 50 57 52 42 0a 02 5c 2e 5f 50 52  ._SB_PWRB..\._PR
  0470: 5f 52 50 50 43 50 38 58 48 00 0a cd 7d 68 0a 50  _RPPCP8XH...}h.P
  0480: 60 44 42 47 43 60 0a 81 42 43 45 4e a4 12 04 02  `DBGC`..BCEN....
  0490: 00 00 14 1e 47 45 54 42 0b 77 68 0a 08 60 77 69  ....GETB.wh..`wi
  04a0: 0a 08 61 5b 13 6a 60 61 54 42 46 33 a4 54 42 46  ..a[.j`aTBF3.TBF
  04b0: 33 14 42 09 50 4e 4f 54 08 a0 4a 06 4d 50 45 4e  3.B.PNOT..J.MPEN
  04c0: a0 31 7b 50 44 43 30 0a 08 00 86 5c 2e 5f 50 52  .1{PDC0....\._PR
  04d0: 5f 43 50 55 30 0a 80 a0 1a 7b 50 44 43 30 0a 10  _CPU0....{PDC0..
  04e0: 00 5b 22 0a 64 86 5c 2e 5f 50 52 5f 43 50 55 30  .[".d.\._PR_CPU0
  04f0: 0a 81 a0 31 7b 50 44 43 31 0a 08 00 86 5c 2e 5f  ...1{PDC1....\._
  0500: 50 52 5f 43 50 55 31 0a 80 a0 1a 7b 50 44 43 31  PR_CPU1....{PDC1
  0510: 0a 10 00 5b 22 0a 64 86 5c 2e 5f 50 52 5f 43 50  ...[".d.\._PR_CP
  0520: 55 31 0a 81 a1 1f 86 5c 2e 5f 50 52 5f 43 50 55  U1.....\._PR_CPU
  0530: 30 0a 80 5b 22 0a 64 86 5c 2e 5f 50 52 5f 43 50  0..[".d.\._PR_CP
  0540: 55 30 0a 81 14 17 54 52 41 50 09 70 68 53 4d 49  U0....TRAP.phSMI
  0550: 46 70 00 54 52 50 30 a4 53 4d 49 46 10 4c 0c 5f  Fp.TRP0.SMIF.L._
  0560: 53 42 5f 14 45 0c 5f 49 4e 49 00 70 0b d0 07 4f  SB_.E._INI.p...O
  0570: 53 59 53 a0 44 09 5b 12 5f 4f 53 49 60 a0 12 5f  SYS.D.[._OSI`.._
  0580: 4f 53 49 0d 4c 69 6e 75 78 00 70 01 4c 49 4e 58  OSI.Linux.p.LINX
  0590: a0 1b 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32  .._OSI.Windows 2
  05a0: 30 30 31 00 70 0b d1 07 4f 53 59 53 a0 1f 5f 4f  001.p...OSYS.._O
  05b0: 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30 31 20  SI.Windows 2001 
  05c0: 53 50 31 00 70 0b d1 07 4f 53 59 53 a0 1f 5f 4f  SP1.p...OSYS.._O
  05d0: 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30 31 20  SI.Windows 2001 
  05e0: 53 50 32 00 70 0b d2 07 4f 53 59 53 a0 1b 5f 4f  SP2.p...OSYS.._O
  05f0: 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30 36 00  SI.Windows 2006.
  0600: 70 0b d6 07 4f 53 59 53 a0 14 90 4d 50 45 4e 93  p...OSYS...MPEN.
  0610: 4f 53 59 53 0b d1 07 54 52 41 50 0a 3d 54 52 41  OSYS...TRAP.=TRA
  0620: 50 0a 2b 54 52 41 50 0a 32 5b 80 47 4e 56 53 00  P.+TRAP.2[.GNVS.
  0630: 0c 37 2a 6e 7f 0b 00 01 5b 81 40 1f 47 4e 56 53  .7*n....[.@.GNVS
  0640: 10 4f 53 59 53 10 53 4d 49 46 08 50 52 4d 30 08  .OSYS.SMIF.PRM0.
  0650: 50 52 4d 31 08 53 43 49 46 08 50 52 4d 32 10 4c  PRM1.SCIF.PRM2.L
  0660: 43 4b 46 08 50 52 4d 34 10 50 38 30 44 20 4c 49  CKF.PRM4.P80D LI
  0670: 44 53 08 50 57 52 53 08 44 42 47 53 08 4c 49 4e  DS.PWRS.DBGS.LIN
  0680: 58 08 00 08 41 43 54 31 08 41 43 54 54 08 50 53  X...ACT1.ACTT.PS
  0690: 56 54 08 54 43 31 56 08 54 43 32 56 08 54 53 50  VT.TC1V.TC2V.TSP
  06a0: 56 08 43 52 54 54 08 44 54 53 45 08 44 54 53 31  V.CRTT.DTSE.DTS1
  06b0: 08 44 54 53 32 08 42 4e 55 4d 08 42 30 53 43 08  .DTS2.BNUM.B0SC.
  06c0: 42 31 53 43 08 42 32 53 43 08 42 30 53 53 08 42  B1SC.B2SC.B0SS.B
  06d0: 31 53 53 08 42 32 53 53 08 4c 42 53 54 08 54 42  1SS.B2SS.LBST.TB
  06e0: 53 54 08 00 08 41 50 49 43 08 4d 50 45 4e 08 50  ST...APIC.MPEN.P
  06f0: 43 50 30 08 50 43 50 31 08 50 50 43 4d 08 00 28  CP0.PCP1.PPCM..(
  0700: 00 40 05 49 47 44 53 08 54 4c 53 54 08 43 41 44  .@.IGDS.TLST.CAD
  0710: 4c 08 50 41 44 4c 08 43 53 54 45 10 4e 53 54 45  L.PADL.CSTE.NSTE
  0720: 10 53 53 54 45 10 4e 44 49 44 08 44 49 44 31 20  .SSTE.NDID.DID1 
  0730: 44 49 44 32 20 44 49 44 33 20 44 49 44 34 20 44  DID2 DID3 DID4 D
  0740: 49 44 35 20 00 48 04 50 4e 49 44 08 00 10 42 4c  ID5 .H.PNID...BL
  0750: 43 53 08 42 52 54 4c 08 41 4c 53 45 08 41 4c 41  CS.BRTL.ALSE.ALA
  0760: 46 08 4c 4c 4f 57 08 4c 48 49 48 08 00 08 45 4d  F.LLOW.LHIH...EM
  0770: 41 45 08 45 4d 41 50 10 45 4d 41 4c 10 00 08 4d  AE.EMAP.EMAL...M
  0780: 45 46 45 08 00 18 54 50 4d 50 08 54 50 4d 45 08  EFE...TPMP.TPME.
  0790: 00 40 04 47 54 46 30 40 07 49 44 45 4d 08 00 28  .@.GTF0@.IDEM..(
  07a0: 53 59 49 44 08 42 43 45 4e 08 00 40 09 41 53 4c  SYID.BCEN..@.ASL
  07b0: 42 20 49 42 54 54 08 49 50 41 54 08 49 54 56 46  B IBTT.IPAT.ITVF
  07c0: 08 49 54 56 4d 08 49 50 53 43 08 49 42 4c 43 08  .ITVM.IPSC.IBLC.
  07d0: 49 42 49 41 08 49 53 53 43 08 49 34 30 39 08 49  IBIA.ISSC.I409.I
  07e0: 35 30 39 08 49 36 30 39 08 49 37 30 39 08 49 44  509.I609.I709.ID
  07f0: 4d 4d 08 49 44 4d 53 08 49 46 31 45 08 48 56 43  MM.IDMS.IF1E.HVC
  0800: 4f 08 4e 58 44 31 20 4e 58 44 32 20 4e 58 44 33  O.NXD1 NXD2 NXD3
  0810: 20 4e 58 44 34 20 4e 58 44 35 20 4e 58 44 36 20   NXD4 NXD5 NXD6 
  0820: 4e 58 44 37 20 4e 58 44 38 20 08 44 53 45 4e 01  NXD7 NXD8 .DSEN.
  0830: 08 45 43 4f 4e 00 08 47 50 49 43 00 08 43 54 59  .ECON..GPIC..CTY
  0840: 50 00 08 4c 30 31 43 00 08 56 46 4e 30 00 08 56  P..L01C..VFN0..V
  0850: 46 4e 31 00 08 41 4f 44 56 00 08 43 41 44 44 00  FN1..AODV..CADD.
  0860: 08 50 41 44 44 00 10 45 54 5f 47 50 45 14 44 24  .PADD..ET_GPE.D$
  0870: 5f 4c 30 31 00 72 4c 30 31 43 01 4c 30 31 43 50  _L01.rL01C.L01CP
  0880: 38 58 48 00 01 50 38 58 48 01 4c 30 31 43 a0 48  8XH..P8XH.L01C.H
  0890: 08 90 93 52 50 31 44 00 5c 2f 04 5f 53 42 5f 50  ...RP1D.\/._SB_P
  08a0: 43 49 30 52 50 30 31 48 50 53 58 5b 22 0a 64 a0  CI0RP01HPSX[".d.
  08b0: 40 05 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30  @.\/._SB_PCI0RP0
  08c0: 31 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43  1PDCXp.\/._SB_PC
  08d0: 49 30 52 50 30 31 50 44 43 58 70 01 5c 2f 04 5f  I0RP01PDCXp.\/._
  08e0: 53 42 5f 50 43 49 30 52 50 30 31 48 50 53 58 86  SB_PCI0RP01HPSX.
  08f0: 5c 2f 03 5f 53 42 5f 50 43 49 30 52 50 30 31 00  \/._SB_PCI0RP01.
  0900: a1 16 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 52  ..p.\/._SB_PCI0R
  0910: 50 30 31 48 50 53 58 a0 48 08 90 93 52 50 32 44  P01HPSX.H...RP2D
  0920: 00 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30 32  .\/._SB_PCI0RP02
  0930: 48 50 53 58 5b 22 0a 64 a0 40 05 5c 2f 04 5f 53  HPSX[".d.@.\/._S
  0940: 42 5f 50 43 49 30 52 50 30 32 50 44 43 58 70 01  B_PCI0RP02PDCXp.
  0950: 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30 32 50  \/._SB_PCI0RP02P
  0960: 44 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30  DCXp.\/._SB_PCI0
  0970: 52 50 30 32 48 50 53 58 86 5c 2f 03 5f 53 42 5f  RP02HPSX.\/._SB_
  0980: 50 43 49 30 52 50 30 32 00 a1 16 70 01 5c 2f 04  PCI0RP02...p.\/.
  0990: 5f 53 42 5f 50 43 49 30 52 50 30 32 48 50 53 58  _SB_PCI0RP02HPSX
  09a0: a0 48 08 90 93 52 50 33 44 00 5c 2f 04 5f 53 42  .H...RP3D.\/._SB
  09b0: 5f 50 43 49 30 52 50 30 33 48 50 53 58 5b 22 0a  _PCI0RP03HPSX[".
  09c0: 64 a0 40 05 5c 2f 04 5f 53 42 5f 50 43 49 30 52  d.@.\/._SB_PCI0R
  09d0: 50 30 33 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f  P03PDCXp.\/._SB_
  09e0: 50 43 49 30 52 50 30 33 50 44 43 58 70 01 5c 2f  PCI0RP03PDCXp.\/
  09f0: 04 5f 53 42 5f 50 43 49 30 52 50 30 33 48 50 53  ._SB_PCI0RP03HPS
  0a00: 58 86 5c 2f 03 5f 53 42 5f 50 43 49 30 52 50 30  X.\/._SB_PCI0RP0
  0a10: 33 00 a1 16 70 01 5c 2f 04 5f 53 42 5f 50 43 49  3...p.\/._SB_PCI
  0a20: 30 52 50 30 33 48 50 53 58 a0 48 08 90 93 52 50  0RP03HPSX.H...RP
  0a30: 35 44 00 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50  5D.\/._SB_PCI0RP
  0a40: 30 35 48 50 53 58 5b 22 0a 64 a0 40 05 5c 2f 04  05HPSX[".d.@.\/.
  0a50: 5f 53 42 5f 50 43 49 30 52 50 30 35 50 44 43 58  _SB_PCI0RP05PDCX
  0a60: 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30  p.\/._SB_PCI0RP0
  0a70: 35 50 44 43 58 70 01 5c 2f 04 5f 53 42 5f 50 43  5PDCXp.\/._SB_PC
  0a80: 49 30 52 50 30 35 48 50 53 58 86 5c 2f 03 5f 53  I0RP05HPSX.\/._S
  0a90: 42 5f 50 43 49 30 52 50 30 35 00 a1 16 70 01 5c  B_PCI0RP05...p.\
  0aa0: 2f 04 5f 53 42 5f 50 43 49 30 52 50 30 35 48 50  /._SB_PCI0RP05HP
  0ab0: 53 58 14 0c 5f 4c 30 32 00 70 00 47 50 45 43 14  SX.._L02.p.GPEC.
  0ac0: 18 5f 4c 30 33 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L03..\/._SB_PC
  0ad0: 49 30 55 53 42 31 0a 02 14 18 5f 4c 30 34 00 86  I0USB1...._L04..
  0ae0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 32 0a  \/._SB_PCI0USB2.
  0af0: 02 14 18 5f 4c 30 35 00 86 5c 2f 03 5f 53 42 5f  ..._L05..\/._SB_
  0b00: 50 43 49 30 55 53 42 35 0a 02 14 36 5f 4c 30 36  PCI0USB5...6_L06
  0b10: 00 a0 27 5c 2f 04 5f 53 42 5f 50 43 49 30 47 46  ..'\/._SB_PCI0GF
  0b20: 58 30 47 53 53 45 5c 2f 04 5f 53 42 5f 50 43 49  X0GSSE\/._SB_PCI
  0b30: 30 47 46 58 30 47 53 43 49 a1 07 70 01 53 43 49  0GFX0GSCI..p.SCI
  0b40: 53 14 4f 14 5f 4c 30 39 00 a0 41 05 5c 2f 04 5f  S.O._L09..A.\/._
  0b50: 53 42 5f 50 43 49 30 52 50 30 31 50 53 50 58 70  SB_PCI0RP01PSPXp
  0b60: 01 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30 31  .\/._SB_PCI0RP01
  0b70: 50 53 50 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49  PSPXp.\/._SB_PCI
  0b80: 30 52 50 30 31 50 4d 53 58 86 5c 2f 03 5f 53 42  0RP01PMSX.\/._SB
  0b90: 5f 50 43 49 30 52 50 30 31 0a 02 a0 41 05 5c 2f  _PCI0RP01...A.\/
  0ba0: 04 5f 53 42 5f 50 43 49 30 52 50 30 32 50 53 50  ._SB_PCI0RP02PSP
  0bb0: 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50  Xp.\/._SB_PCI0RP
  0bc0: 30 32 50 53 50 58 70 01 5c 2f 04 5f 53 42 5f 50  02PSPXp.\/._SB_P
  0bd0: 43 49 30 52 50 30 32 50 4d 53 58 86 5c 2f 03 5f  CI0RP02PMSX.\/._
  0be0: 53 42 5f 50 43 49 30 52 50 30 32 0a 02 a0 41 05  SB_PCI0RP02...A.
  0bf0: 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30 33 50  \/._SB_PCI0RP03P
  0c00: 53 50 58 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30  SPXp.\/._SB_PCI0
  0c10: 52 50 30 33 50 53 50 58 70 01 5c 2f 04 5f 53 42  RP03PSPXp.\/._SB
  0c20: 5f 50 43 49 30 52 50 30 33 50 4d 53 58 86 5c 2f  _PCI0RP03PMSX.\/
  0c30: 03 5f 53 42 5f 50 43 49 30 52 50 30 33 0a 02 a0  ._SB_PCI0RP03...
  0c40: 41 05 5c 2f 04 5f 53 42 5f 50 43 49 30 52 50 30  A.\/._SB_PCI0RP0
  0c50: 35 50 53 50 58 70 01 5c 2f 04 5f 53 42 5f 50 43  5PSPXp.\/._SB_PC
  0c60: 49 30 52 50 30 35 50 53 50 58 70 01 5c 2f 04 5f  I0RP05PSPXp.\/._
  0c70: 53 42 5f 50 43 49 30 52 50 30 35 50 4d 53 58 86  SB_PCI0RP05PMSX.
  0c80: 5c 2f 03 5f 53 42 5f 50 43 49 30 52 50 30 35 0a  \/._SB_PCI0RP05.
  0c90: 02 14 18 5f 4c 30 42 00 86 5c 2f 03 5f 53 42 5f  ..._L0B..\/._SB_
  0ca0: 50 43 49 30 50 43 49 42 0a 02 14 18 5f 4c 30 43  PCI0PCIB...._L0C
  0cb0: 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42  ..\/._SB_PCI0USB
  0cc0: 33 0a 02 14 4b 0b 5f 4c 30 44 00 a0 3b 5c 2f 04  3...K._L0D..;\/.
  0cd0: 5f 53 42 5f 50 43 49 30 45 48 43 31 50 4d 45 53  _SB_PCI0EHC1PMES
  0ce0: 70 01 5c 2f 04 5f 53 42 5f 50 43 49 30 45 48 43  p.\/._SB_PCI0EHC
  0cf0: 31 50 4d 45 53 86 5c 2f 03 5f 53 42 5f 50 43 49  1PMES.\/._SB_PCI
  0d00: 30 45 48 43 31 0a 02 a0 3b 5c 2f 04 5f 53 42 5f  0EHC1...;\/._SB_
  0d10: 50 43 49 30 45 48 43 32 50 4d 45 53 70 01 5c 2f  PCI0EHC2PMESp.\/
  0d20: 04 5f 53 42 5f 50 43 49 30 45 48 43 32 50 4d 45  ._SB_PCI0EHC2PME
  0d30: 53 86 5c 2f 03 5f 53 42 5f 50 43 49 30 45 48 43  S.\/._SB_PCI0EHC
  0d40: 32 0a 02 a0 3b 5c 2f 04 5f 53 42 5f 50 43 49 30  2...;\/._SB_PCI0
  0d50: 48 44 45 46 50 4d 45 53 70 01 5c 2f 04 5f 53 42  HDEFPMESp.\/._SB
  0d60: 5f 50 43 49 30 48 44 45 46 50 4d 45 53 86 5c 2f  _PCI0HDEFPMES.\/
  0d70: 03 5f 53 42 5f 50 43 49 30 48 44 45 46 0a 02 14  ._SB_PCI0HDEF...
  0d80: 18 5f 4c 30 45 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L0E..\/._SB_PC
  0d90: 49 30 55 53 42 34 0a 02 14 13 5f 4c 31 45 00 86  I0USB4...._L1E..
  0da0: 5c 2e 5f 53 42 5f 50 57 52 42 0a 02 10 46 0b 5f  \._SB_PWRB...F._
  0db0: 50 52 5f 5b 83 0b 43 50 55 30 00 10 10 00 00 06  PR_[..CPU0......
  0dc0: 5b 83 0b 43 50 55 31 01 10 10 00 00 06 14 45 09  [..CPU1.......E.
  0dd0: 52 50 50 43 00 a0 4d 08 93 4f 53 59 53 0b d2 07  RPPC..M..OSYS...
  0de0: a0 42 08 7b 43 46 47 44 01 00 a0 42 04 94 5e 2e  .B.{CFGD...B..^.
  0df0: 43 50 55 30 5f 50 50 43 00 74 5e 2e 43 50 55 30  CPU0_PPC.t^.CPU0
  0e00: 5f 50 50 43 01 5e 2e 43 50 55 30 5f 50 50 43 50  _PPC.^.CPU0_PPCP
  0e10: 4e 4f 54 72 5e 2e 43 50 55 30 5f 50 50 43 01 5e  NOTr^.CPU0_PPC.^
  0e20: 2e 43 50 55 30 5f 50 50 43 50 4e 4f 54 a1 35 72  .CPU0_PPCPNOT.5r
  0e30: 5e 2e 43 50 55 30 5f 50 50 43 01 5e 2e 43 50 55  ^.CPU0_PPC.^.CPU
  0e40: 30 5f 50 50 43 50 4e 4f 54 74 5e 2e 43 50 55 30  0_PPCPNOTt^.CPU0
  0e50: 5f 50 50 43 01 5e 2e 43 50 55 30 5f 50 50 43 50  _PPC.^.CPU0_PPCP
  0e60: 4e 4f 54 10 4d 18 5f 54 5a 5f 5b 85 44 05 54 5a  NOT.M._TZ_[.D.TZ
  0e70: 30 30 14 0a 5f 43 52 54 08 a4 0b a2 0f 14 42 04  00.._CRT......B.
  0e80: 5f 54 4d 50 08 a0 36 45 43 4f 4e 70 5c 2f 05 5f  _TMP..6ECONp\/._
  0e90: 53 42 5f 50 43 49 30 4c 50 43 42 45 43 5f 5f 54  SB_PCI0LPCBEC__T
  0ea0: 53 31 52 60 a0 0c 7b 60 0a 80 00 74 60 0b 00 01  S1R`..{`...t`...
  0eb0: 60 a4 72 0b ac 0a 77 60 0a 0a 00 00 a4 0b b8 0b  `.r...w`........
  0ec0: 5b 85 4f 12 54 5a 30 31 14 14 5f 41 43 30 08 a4  [.O.TZ01.._AC0..
  0ed0: 72 0b ac 0a 77 41 43 54 54 0a 0a 00 00 14 14 5f  r...wACTT......_
  0ee0: 41 43 31 08 a4 72 0b ac 0a 77 41 43 54 31 0a 0a  AC1..r...wACT1..
  0ef0: 00 00 14 14 5f 43 52 54 08 a4 72 0b ac 0a 77 43  ...._CRT..r...wC
  0f00: 52 54 54 0a 0a 00 00 14 0c 5f 53 43 50 09 70 68  RTT......_SCP.ph
  0f10: 43 54 59 50 14 40 07 5f 54 4d 50 08 a0 2d 44 54  CTYP.@._TMP..-DT
  0f20: 53 45 a0 19 92 95 44 54 53 31 44 54 53 32 a4 72  SE....DTS1DTS2.r
  0f30: 0b ac 0a 77 44 54 53 31 0a 0a 00 00 a4 72 0b ac  ...wDTS1.....r..
  0f40: 0a 77 44 54 53 32 0a 0a 00 00 a0 36 45 43 4f 4e  .wDTS2.....6ECON
  0f50: 70 5c 2f 05 5f 53 42 5f 50 43 49 30 4c 50 43 42  p\/._SB_PCI0LPCB
  0f60: 45 43 5f 5f 54 53 31 52 60 a0 0c 7b 60 0a 80 00  EC__TS1R`..{`...
  0f70: 74 60 0b 00 01 60 a4 72 0b ac 0a 77 60 0a 0a 00  t`...`.r...w`...
  0f80: 00 a4 0b b8 0b 14 32 5f 50 53 4c 08 a0 1d 4d 50  ......2_PSL...MP
  0f90: 45 4e a4 12 16 02 5c 2e 5f 50 52 5f 43 50 55 30  EN....\._PR_CPU0
  0fa0: 5c 2e 5f 50 52 5f 43 50 55 31 a4 12 0c 01 5c 2e  \._PR_CPU1....\.
  0fb0: 5f 50 52 5f 43 50 55 30 14 14 5f 50 53 56 08 a4  _PR_CPU0.._PSV..
  0fc0: 72 0b ac 0a 77 50 53 56 54 0a 0a 00 00 14 0b 5f  r...wPSVT......_
  0fd0: 54 43 31 08 a4 54 43 31 56 14 0b 5f 54 43 32 08  TC1..TC1V.._TC2.
  0fe0: a4 54 43 32 56 14 0b 5f 54 53 50 08 a4 54 53 50  .TC2V.._TSP..TSP
  0ff0: 56 10 87 98 05 5f 53 42 5f 5b 82 4e 05 41 44 50  V...._SB_[.N.ADP
  1000: 31 08 5f 48 49 44 0d 41 43 50 49 30 30 30 33 00  1._HID.ACPI0003.
  1010: 14 3c 5f 50 53 52 00 a0 12 93 45 43 4f 4e 00 7b  .<_PSR....ECON.{
  1020: 50 48 53 42 0a d4 00 0a 80 60 a1 17 70 5e 5e 2f  PHSB.....`..p^^/
  1030: 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 52 50 57  .PCI0LPCBEC__RPW
  1040: 52 60 a0 06 93 60 00 a4 00 a1 03 a4 01 14 0b 5f  R`...`........._
  1050: 50 43 4c 00 a4 5f 53 42 5f 5b 82 42 38 42 41 54  PCL.._SB_[.B8BAT
  1060: 30 08 5f 48 49 44 0c 41 d0 0c 0a 08 5f 55 49 44  0._HID.A...._UID
  1070: 00 14 47 05 5f 53 54 41 00 44 42 47 43 0a b0 0a  ..G._STA.DBGC...
  1080: 80 42 43 45 4e 5b 22 0a 05 a0 0a 93 45 43 4f 4e  .BCEN[".....ECON
  1090: 00 70 00 61 a1 17 70 5e 5e 2f 04 50 43 49 30 4c  .p.a..p^^/.PCI0L
  10a0: 50 43 42 45 43 5f 5f 42 41 54 50 61 a0 08 93 61  PCBEC__BATPa...a
  10b0: 00 70 0a 0f 60 a1 05 70 0a 1f 60 44 42 47 43 0a  .p..`..p..`DBGC.
  10c0: b0 0a 81 42 43 45 4e a4 60 14 4c 16 5f 42 49 46  ...BCEN.`.L._BIF
  10d0: 00 08 4d 55 4c 56 00 44 42 47 43 0a b1 0a 80 42  ..MULV.DBGC....B
  10e0: 43 45 4e 08 42 41 54 49 12 2f 0d 00 0b 10 27 0b  CEN.BATI./....'.
  10f0: 10 27 00 0c ff ff ff ff 0b e8 03 0b 90 01 0a 64  .'.............d
  1100: 0a 64 0d 00 0d 00 0d 4c 69 4f 6e 00 0d 53 6f 6e  .d.....LiOn..Son
  1110: 79 20 43 6f 72 70 2e 00 70 01 4d 55 4c 56 5b 22  y Corp..p.MULV["
  1120: 0a 05 a0 07 93 45 43 4f 4e 00 a1 4a 0f 7b 5e 5e  .....ECON..J.{^^
  1130: 2f 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 4f 4d  /.PCI0LPCBEC__OM
  1140: 46 48 0a 80 60 a0 12 60 70 00 88 42 41 54 49 00  FH..`..`p..BATI.
  1150: 00 70 0a 0a 4d 55 4c 56 a1 0a 70 01 88 42 41 54  .p..MULV..p..BAT
  1160: 49 00 00 70 5e 5e 2f 04 50 43 49 30 4c 50 43 42  I..p^^/.PCI0LPCB
  1170: 45 43 5f 5f 42 44 43 48 60 7d 79 60 0a 08 00 5e  EC__BDCH`}y`...^
  1180: 5e 2f 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 42  ^/.PCI0LPCBEC__B
  1190: 44 43 4c 60 70 77 60 4d 55 4c 56 00 88 42 41 54  DCL`pw`MULV..BAT
  11a0: 49 01 00 70 5e 5e 2f 04 50 43 49 30 4c 50 43 42  I..p^^/.PCI0LPCB
  11b0: 45 43 5f 5f 46 43 43 48 60 7d 79 60 0a 08 00 5e  EC__FCCH`}y`...^
  11c0: 5e 2f 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 46  ^/.PCI0LPCBEC__F
  11d0: 43 43 4c 60 70 77 60 4d 55 4c 56 00 88 42 41 54  CCL`pw`MULV..BAT
  11e0: 49 0a 02 00 70 5e 5e 2f 04 50 43 49 30 4c 50 43  I...p^^/.PCI0LPC
  11f0: 42 45 43 5f 5f 42 41 56 48 60 7d 79 60 0a 08 00  BEC__BAVH`}y`...
  1200: 5e 5e 2f 04 50 43 49 30 4c 50 43 42 45 43 5f 5f  ^^/.PCI0LPCBEC__
  1210: 42 41 56 4c 60 70 77 60 4d 55 4c 56 00 88 42 41  BAVL`pw`MULV..BA
  1220: 54 49 0a 04 00 44 42 47 43 0a b1 0a 81 42 43 45  TI...DBGC....BCE
  1230: 4e a4 42 41 54 49 14 4a 19 5f 42 53 54 00 44 42  N.BATI.J._BST.DB
  1240: 47 43 0a b2 0a 80 42 43 45 4e 08 50 4b 47 30 12  GC....BCEN.PKG0.
  1250: 13 04 0a 02 0c ff ff ff ff 0c ff ff ff ff 0c ff  ................
  1260: ff ff ff 5b 22 0a 05 a0 07 93 45 43 4f 4e 00 a1  ...[".....ECON..
  1270: 40 15 a0 49 04 93 5e 5e 2f 04 50 43 49 30 4c 50  @..I..^^/.PCI0LP
  1280: 43 42 45 43 5f 5f 43 48 47 45 01 70 5e 5e 2f 04  CBEC__CHGE.p^^/.
  1290: 50 43 49 30 4c 50 43 42 45 43 5f 5f 52 53 43 4c  PCI0LPCBEC__RSCL
  12a0: 60 a0 0e 93 60 0a 64 70 00 88 50 4b 47 30 00 00  `...`.dp..PKG0..
  12b0: a1 0b 70 0a 02 88 50 4b 47 30 00 00 a1 0a 70 01  ..p...PKG0....p.
  12c0: 88 50 4b 47 30 00 00 08 4d 55 4c 56 00 7b 5e 5e  .PKG0...MULV.{^^
  12d0: 2f 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 4f 4d  /.PCI0LPCBEC__OM
  12e0: 46 48 0a 80 60 a0 09 60 70 0a 0a 4d 55 4c 56 a1  FH..`..`p..MULV.
  12f0: 07 70 01 4d 55 4c 56 70 5e 5e 2f 04 50 43 49 30  .p.MULVp^^/.PCI0
  1300: 4c 50 43 42 45 43 5f 5f 42 52 43 48 60 7d 79 60  LPCBEC__BRCH`}y`
  1310: 0a 08 00 5e 5e 2f 04 50 43 49 30 4c 50 43 42 45  ...^^/.PCI0LPCBE
  1320: 43 5f 5f 42 52 43 4c 60 70 77 60 4d 55 4c 56 00  C__BRCL`pw`MULV.
  1330: 88 50 4b 47 30 0a 02 00 70 5e 5e 2f 04 50 43 49  .PKG0...p^^/.PCI
  1340: 30 4c 50 43 42 45 43 5f 5f 42 41 43 48 60 7d 79  0LPCBEC__BACH`}y
  1350: 60 0a 08 00 5e 5e 2f 04 50 43 49 30 4c 50 43 42  `...^^/.PCI0LPCB
  1360: 45 43 5f 5f 42 41 43 4c 60 a0 12 90 60 0b 00 80  EC__BACL`...`...
  1370: 72 80 60 00 01 60 7b 60 0b ff ff 60 70 5e 5e 2f  r.`..`{`...`p^^/
  1380: 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 42 41 56  .PCI0LPCBEC__BAV
  1390: 48 61 7d 79 61 0a 08 00 5e 5e 2f 04 50 43 49 30  Ha}ya...^^/.PCI0
  13a0: 4c 50 43 42 45 43 5f 5f 42 41 56 4c 61 78 61 0b  LPCBEC__BAVLaxa.
  13b0: e8 03 00 61 70 77 60 61 00 88 50 4b 47 30 01 00  ...apw`a..PKG0..
  13c0: 44 42 47 43 0a b2 0a 81 42 43 45 4e a4 50 4b 47  DBGC....BCEN.PKG
  13d0: 30 14 0b 5f 50 43 4c 00 a4 5f 53 42 5f 5b 82 49  0.._PCL.._SB_[.I
  13e0: 04 4c 49 44 30 08 5f 48 49 44 0c 41 d0 0c 0d 14  .LID0._HID.A....
  13f0: 38 5f 4c 49 44 00 a0 1b 45 43 4f 4e 70 5e 5e 2f  8_LID...ECONp^^/
  1400: 04 50 43 49 30 4c 50 43 42 45 43 5f 5f 4c 53 54  .PCI0LPCBEC__LST
  1410: 45 60 a1 0c 7b 50 48 53 42 0a d4 00 0a 20 60 a0  E`..{PHSB.... `.
  1420: 04 60 a4 00 a1 03 a4 01 5b 82 1b 50 57 52 42 08  .`......[..PWRB.
  1430: 5f 48 49 44 0c 41 d0 0c 0c 08 5f 50 52 57 12 06  _HID.A...._PRW..
  1440: 02 0a 1e 0a 04 5b 01 50 4c 4f 4b 00 14 32 4e 43  .....[.PLOK..2NC
  1450: 50 55 00 5b 23 50 4c 4f 4b ff ff 86 5c 2e 5f 50  PU.[#PLOK...\._P
  1460: 52 5f 43 50 55 30 0a 80 5b 22 0a 64 86 5c 2e 5f  R_CPU0..[".d.\._
  1470: 50 52 5f 43 50 55 30 0a 81 5b 27 50 4c 4f 4b 5b  PR_CPU0..['PLOK[
  1480: 82 88 4f 05 50 43 49 30 14 28 5f 49 4e 49 00 70  ..O.PCI0.(_INI.p
  1490: 00 5e 2f 03 4c 50 43 42 53 4e 43 5f 58 45 43 52  .^/.LPCBSNC_XECR
  14a0: 70 00 5e 2f 03 4c 50 43 42 53 4e 43 5f 53 4e 42  p.^/.LPCBSNC_SNB
  14b0: 46 14 09 5f 53 33 44 00 a4 0a 02 14 09 5f 53 34  F.._S3D......_S4
  14c0: 44 00 a4 0a 02 08 5f 48 49 44 0c 41 d0 0a 08 08  D....._HID.A....
  14d0: 5f 43 49 44 0c 41 d0 0a 03 08 53 55 50 50 00 08  _CID.A....SUPP..
  14e0: 43 54 52 4c 00 5b 82 43 0e 4d 43 48 43 08 5f 41  CTRL.[.C.MCHC._A
  14f0: 44 52 00 5b 80 48 42 55 53 02 0a 40 0a c0 5b 81  DR.[.HBUS..@..[.
  1500: 4a 0c 48 42 55 53 03 45 50 45 4e 01 00 0b 45 50  J.HBUS.EPEN...EP
  1510: 42 52 14 00 20 4d 48 45 4e 01 00 0d 4d 48 42 52  BR.. MHEN...MHBR
  1520: 12 00 40 0a 50 58 45 4e 01 50 58 53 5a 02 00 17  ..@.PXEN.PXSZ...
  1530: 50 58 42 52 06 00 20 44 49 45 4e 01 00 0b 44 49  PXBR.. DIEN...DI
  1540: 42 52 14 00 20 49 50 45 4e 01 00 0b 49 50 42 52  BR.. IPEN...IPBR
  1550: 14 00 40 0e 00 04 50 4d 30 48 02 00 02 50 4d 31  ..@...PM0H...PM1
  1560: 4c 02 00 02 50 4d 31 48 02 00 02 50 4d 32 4c 02  L...PM1H...PM2L.
  1570: 00 02 50 4d 32 48 02 00 02 50 4d 33 4c 02 00 02  ..PM2H...PM3L...
  1580: 50 4d 33 48 02 00 02 50 4d 34 4c 02 00 02 50 4d  PM3H...PM4L...PM
  1590: 34 48 02 00 02 50 4d 35 4c 02 00 02 50 4d 35 48  4H...PM5L...PM5H
  15a0: 02 00 02 50 4d 36 4c 02 00 02 50 4d 36 48 02 00  ...PM6L...PM6H..
  15b0: 02 00 07 48 45 4e 41 01 00 40 05 54 55 55 44 10  ...HENA..@.TUUD.
  15c0: 00 40 06 00 04 54 4c 55 44 0c 08 42 55 46 30 11  .@...TLUD..BUF0.
  15d0: 4d 20 0b 08 02 88 0d 00 02 0c 00 00 00 00 00 ff  M ..............
  15e0: 00 00 00 00 01 87 17 00 01 0c 03 00 00 00 00 00  ................
  15f0: 00 00 00 f7 0c 00 00 00 00 00 00 f8 0c 00 00 47  ...............G
  1600: 01 f8 0c f8 0c 01 08 87 17 00 01 0c 03 00 00 00  ................
  1610: 00 00 0d 00 00 ff ff 00 00 00 00 00 00 00 f3 00  ................
  1620: 00 87 17 00 00 0c 03 00 00 00 00 00 00 0a 00 ff  ................
  1630: ff 0b 00 00 00 00 00 00 00 02 00 87 17 00 00 0c  ................
  1640: 03 00 00 00 00 00 00 0c 00 ff 3f 0c 00 00 00 00  ..........?.....
  1650: 00 00 40 00 00 87 17 00 00 0c 03 00 00 00 00 00  ..@.............
  1660: 40 0c 00 ff 7f 0c 00 00 00 00 00 00 40 00 00 87  @...........@...
  1670: 17 00 00 0c 03 00 00 00 00 00 80 0c 00 ff bf 0c  ................
  1680: 00 00 00 00 00 00 40 00 00 87 17 00 00 0c 03 00  ......@.........
  1690: 00 00 00 00 c0 0c 00 ff ff 0c 00 00 00 00 00 00  ................
  16a0: 40 00 00 87 17 00 00 0c 03 00 00 00 00 00 00 0d  @...............
  16b0: 00 ff 3f 0d 00 00 00 00 00 00 40 00 00 87 17 00  ..?.......@.....
  16c0: 00 0c 03 00 00 00 00 00 40 0d 00 ff 7f 0d 00 00  ........@.......
  16d0: 00 00 00 00 40 00 00 87 17 00 00 0c 03 00 00 00  ....@...........
  16e0: 00 00 80 0d 00 ff bf 0d 00 00 00 00 00 00 40 00  ..............@.
  16f0: 00 87 17 00 00 0c 03 00 00 00 00 00 c0 0d 00 ff  ................
  1700: ff 0d 00 00 00 00 00 00 40 00 00 87 17 00 00 0c  ........@.......
  1710: 03 00 00 00 00 00 00 0e 00 ff 3f 0e 00 00 00 00  ..........?.....
  1720: 00 00 40 00 00 87 17 00 00 0c 03 00 00 00 00 00  ..@.............
  1730: 40 0e 00 ff 7f 0e 00 00 00 00 00 00 40 00 00 87  @...........@...
  1740: 17 00 00 0c 03 00 00 00 00 00 80 0e 00 ff bf 0e  ................
  1750: 00 00 00 00 00 00 40 00 00 87 17 00 00 0c 03 00  ......@.........
  1760: 00 00 00 00 c0 0e 00 ff ff 0e 00 00 00 00 00 00  ................
  1770: 40 00 00 87 17 00 00 0c 03 00 00 00 00 00 00 0f  @...............
  1780: 00 ff ff 0f 00 00 00 00 00 00 00 01 00 87 17 00  ................
  1790: 00 0c 03 00 00 00 00 00 00 00 00 ff ff ff df 00  ................
  17a0: 00 00 00 00 00 00 00 87 17 00 00 0c 03 00 00 00  ................
  17b0: 00 00 00 00 f0 ff ff bf fe 00 00 00 00 00 00 c0  ................
  17c0: 0e 87 17 00 00 0c 03 00 00 00 00 00 00 d4 fe ff  ................
  17d0: 4f d4 fe 00 00 00 00 00 00 00 00 79 00 14 4b 3d  O..........y..K=
  17e0: 5f 43 52 53 08 a0 1c 5e 2e 4d 43 48 43 50 4d 31  _CRS...^.MCHCPM1
  17f0: 4c 8a 42 55 46 30 0a 7c 43 30 4c 4e 70 00 43 30  L.BUF0.|C0LNp.C0
  1800: 4c 4e a0 1f 93 5e 2e 4d 43 48 43 50 4d 31 4c 01  LN...^.MCHCPM1L.
  1810: 8d 42 55 46 30 0b 58 03 43 30 52 57 70 00 43 30  .BUF0.X.C0RWp.C0
  1820: 52 57 a0 1c 5e 2e 4d 43 48 43 50 4d 31 48 8a 42  RW..^.MCHCPM1H.B
  1830: 55 46 30 0a 96 43 34 4c 4e 70 00 43 34 4c 4e a0  UF0..C4LNp.C4LN.
  1840: 1f 93 5e 2e 4d 43 48 43 50 4d 31 48 01 8d 42 55  ..^.MCHCPM1H..BU
  1850: 46 30 0b 28 04 43 34 52 57 70 00 43 34 52 57 a0  F0.(.C4RWp.C4RW.
  1860: 1c 5e 2e 4d 43 48 43 50 4d 32 4c 8a 42 55 46 30  .^.MCHCPM2L.BUF0
  1870: 0a b0 43 38 4c 4e 70 00 43 38 4c 4e a0 1f 93 5e  ..C8LNp.C8LN...^
  1880: 2e 4d 43 48 43 50 4d 32 4c 01 8d 42 55 46 30 0b  .MCHCPM2L..BUF0.
  1890: f8 04 43 38 52 57 70 00 43 38 52 57 a0 1c 5e 2e  ..C8RWp.C8RW..^.
  18a0: 4d 43 48 43 50 4d 32 48 8a 42 55 46 30 0a ca 43  MCHCPM2H.BUF0..C
  18b0: 43 4c 4e 70 00 43 43 4c 4e a0 1f 93 5e 2e 4d 43  CLNp.CCLN...^.MC
  18c0: 48 43 50 4d 32 48 01 8d 42 55 46 30 0b c8 05 43  HCPM2H..BUF0...C
  18d0: 43 52 57 70 00 43 43 52 57 a0 1c 5e 2e 4d 43 48  CRWp.CCRW..^.MCH
  18e0: 43 50 4d 33 4c 8a 42 55 46 30 0a e4 44 30 4c 4e  CPM3L.BUF0..D0LN
  18f0: 70 00 44 30 4c 4e a0 1f 93 5e 2e 4d 43 48 43 50  p.D0LN...^.MCHCP
  1900: 4d 33 4c 01 8d 42 55 46 30 0b 98 06 44 30 52 57  M3L..BUF0...D0RW
  1910: 70 00 44 30 52 57 a0 1c 5e 2e 4d 43 48 43 50 4d  p.D0RW..^.MCHCPM
  1920: 33 48 8a 42 55 46 30 0a fe 44 34 4c 4e 70 00 44  3H.BUF0..D4LNp.D
  1930: 34 4c 4e a0 1f 93 5e 2e 4d 43 48 43 50 4d 33 48  4LN...^.MCHCPM3H
  1940: 01 8d 42 55 46 30 0b 68 07 44 34 52 57 70 00 44  ..BUF0.h.D4RWp.D
  1950: 34 52 57 a0 1d 5e 2e 4d 43 48 43 50 4d 34 4c 8a  4RW..^.MCHCPM4L.
  1960: 42 55 46 30 0b 18 01 44 38 4c 4e 70 00 44 38 4c  BUF0...D8LNp.D8L
  1970: 4e a0 1f 93 5e 2e 4d 43 48 43 50 4d 34 4c 01 8d  N...^.MCHCPM4L..
  1980: 42 55 46 30 0b 38 08 44 38 52 57 70 00 44 38 52  BUF0.8.D8RWp.D8R
  1990: 57 a0 1d 5e 2e 4d 43 48 43 50 4d 34 48 8a 42 55  W..^.MCHCPM4H.BU
  19a0: 46 30 0b 32 01 44 43 4c 4e 70 00 44 43 4c 4e a0  F0.2.DCLNp.DCLN.
  19b0: 1f 93 5e 2e 4d 43 48 43 50 4d 34 48 01 8d 42 55  ..^.MCHCPM4H..BU
  19c0: 46 30 0b 08 09 44 43 52 57 70 00 44 43 52 57 a0  F0...DCRWp.DCRW.
  19d0: 1d 5e 2e 4d 43 48 43 50 4d 35 4c 8a 42 55 46 30  .^.MCHCPM5L.BUF0
  19e0: 0b 4c 01 45 30 4c 4e 70 00 45 30 4c 4e a0 1f 93  .L.E0LNp.E0LN...
  19f0: 5e 2e 4d 43 48 43 50 4d 35 4c 01 8d 42 55 46 30  ^.MCHCPM5L..BUF0
  1a00: 0b d8 09 45 30 52 57 70 00 45 30 52 57 a0 1d 5e  ...E0RWp.E0RW..^
  1a10: 2e 4d 43 48 43 50 4d 35 48 8a 42 55 46 30 0b 66  .MCHCPM5H.BUF0.f
  1a20: 01 45 34 4c 4e 70 00 45 34 4c 4e a0 1f 93 5e 2e  .E4LNp.E4LN...^.
  1a30: 4d 43 48 43 50 4d 35 48 01 8d 42 55 46 30 0b a8  MCHCPM5H..BUF0..
  1a40: 0a 45 34 52 57 70 00 45 34 52 57 a0 1d 5e 2e 4d  .E4RWp.E4RW..^.M
  1a50: 43 48 43 50 4d 36 4c 8a 42 55 46 30 0b 80 01 45  CHCPM6L.BUF0...E
  1a60: 38 4c 4e 70 00 45 38 4c 4e a0 1f 93 5e 2e 4d 43  8LNp.E8LN...^.MC
  1a70: 48 43 50 4d 36 4c 01 8d 42 55 46 30 0b 78 0b 45  HCPM6L..BUF0.x.E
  1a80: 38 52 57 70 00 45 38 52 57 a0 1d 5e 2e 4d 43 48  8RWp.E8RW..^.MCH
  1a90: 43 50 4d 36 48 8a 42 55 46 30 0b 9a 01 45 43 4c  CPM6H.BUF0...ECL
  1aa0: 4e 70 00 45 43 4c 4e a0 1f 93 5e 2e 4d 43 48 43  Np.ECLN...^.MCHC
  1ab0: 50 4d 36 48 01 8d 42 55 46 30 0b 48 0c 45 43 52  PM6H..BUF0.H.ECR
  1ac0: 57 70 00 45 43 52 57 a0 1d 5e 2e 4d 43 48 43 50  Wp.ECRW..^.MCHCP
  1ad0: 4d 30 48 8a 42 55 46 30 0b b4 01 46 30 4c 4e 70  M0H.BUF0...F0LNp
  1ae0: 00 46 30 4c 4e a0 1f 93 5e 2e 4d 43 48 43 50 4d  .F0LN...^.MCHCPM
  1af0: 30 48 01 8d 42 55 46 30 0b 18 0d 46 30 52 57 70  0H..BUF0...F0RWp
  1b00: 00 46 30 52 57 8a 42 55 46 30 0b c2 01 4d 31 4d  .F0RW.BUF0...M1M
  1b10: 4e 8a 42 55 46 30 0b c6 01 4d 31 4d 58 8a 42 55  N.BUF0...M1MX.BU
  1b20: 46 30 0b ce 01 4d 31 4c 4e 8a 42 55 46 30 0b dc  F0...M1LN.BUF0..
  1b30: 01 4d 32 4d 4e 8a 42 55 46 30 0b e0 01 4d 32 4d  .M2MN.BUF0...M2M
  1b40: 58 8a 42 55 46 30 0b e8 01 4d 32 4c 4e 79 5e 2e  X.BUF0...M2LNy^.
  1b50: 4d 43 48 43 50 58 42 52 0a 1a 4d 31 4d 58 7a 0c  MCHCPXBR..M1MXz.
  1b60: 00 00 00 10 5e 2e 4d 43 48 43 50 58 53 5a 60 72  ....^.MCHCPXSZ`r
  1b70: 4d 31 4d 58 60 4d 32 4d 4e 72 74 4d 32 4d 58 4d  M1MX`M2MNrtM2MXM
  1b80: 32 4d 4e 00 01 4d 32 4c 4e 74 4d 31 4d 58 01 4d  2MN..M2LNtM1MX.M
  1b90: 31 4d 58 79 5e 2e 4d 43 48 43 54 4c 55 44 0a 14  1MXy^.MCHCTLUD..
  1ba0: 4d 31 4d 4e 72 74 4d 31 4d 58 4d 31 4d 4e 00 01  M1MNrtM1MXM1MN..
  1bb0: 4d 31 4c 4e a4 42 55 46 30 14 47 28 5f 50 52 54  M1LN.BUF0.G(_PRT
  1bc0: 00 a0 45 0f 47 50 49 43 a4 12 4d 0e 13 12 0b 04  ..E.GPIC..M.....
  1bd0: 0c ff ff 01 00 00 00 0a 10 12 0b 04 0c ff ff 02  ................
  1be0: 00 00 00 0a 10 12 0b 04 0c ff ff 07 00 00 00 0a  ................
  1bf0: 10 12 0b 04 0c ff ff 19 00 00 00 0a 14 12 0b 04  ................
  1c00: 0c ff ff 1a 00 00 00 0a 10 12 0b 04 0c ff ff 1a  ................
  1c10: 00 01 00 0a 15 12 0c 04 0c ff ff 1a 00 0a 02 00  ................
  1c20: 0a 12 12 0b 04 0c ff ff 1b 00 00 00 0a 16 12 0b  ................
  1c30: 04 0c ff ff 1c 00 00 00 0a 11 12 0b 04 0c ff ff  ................
  1c40: 1c 00 01 00 0a 10 12 0c 04 0c ff ff 1c 00 0a 02  ................
  1c50: 00 0a 12 12 0c 04 0c ff ff 1c 00 0a 03 00 0a 13  ................
  1c60: 12 0b 04 0c ff ff 1d 00 00 00 0a 17 12 0b 04 0c  ................
  1c70: ff ff 1d 00 01 00 0a 13 12 0c 04 0c ff ff 1d 00  ................
  1c80: 0a 02 00 0a 12 12 0b 04 0c ff ff 1f 00 00 00 0a  ................
  1c90: 13 12 0b 04 0c ff ff 1f 00 01 00 0a 13 12 0c 04  ................
  1ca0: 0c ff ff 1f 00 0a 02 00 0a 13 12 0c 04 0c ff ff  ................
  1cb0: 1f 00 0a 03 00 0a 10 a1 49 18 a4 12 45 18 13 12  ........I...E...
  1cc0: 13 04 0c ff ff 01 00 00 5e 2e 4c 50 43 42 4c 4e  ........^.LPCBLN
  1cd0: 4b 41 00 12 13 04 0c ff ff 02 00 00 5e 2e 4c 50  KA..........^.LP
  1ce0: 43 42 4c 4e 4b 41 00 12 13 04 0c ff ff 07 00 00  CBLNKA..........
  1cf0: 5e 2e 4c 50 43 42 4c 4e 4b 41 00 12 13 04 0c ff  ^.LPCBLNKA......
  1d00: ff 19 00 00 5e 2e 4c 50 43 42 4c 4e 4b 45 00 12  ....^.LPCBLNKE..
  1d10: 13 04 0c ff ff 1a 00 00 5e 2e 4c 50 43 42 4c 4e  ........^.LPCBLN
  1d20: 4b 41 00 12 13 04 0c ff ff 1a 00 01 5e 2e 4c 50  KA..........^.LP
  1d30: 43 42 4c 4e 4b 46 00 12 14 04 0c ff ff 1a 00 0a  CBLNKF..........
  1d40: 02 5e 2e 4c 50 43 42 4c 4e 4b 43 00 12 13 04 0c  .^.LPCBLNKC.....
  1d50: ff ff 1b 00 00 5e 2e 4c 50 43 42 4c 4e 4b 47 00  .....^.LPCBLNKG.
  1d60: 12 13 04 0c ff ff 1c 00 00 5e 2e 4c 50 43 42 4c  .........^.LPCBL
  1d70: 4e 4b 42 00 12 13 04 0c ff ff 1c 00 01 5e 2e 4c  NKB..........^.L
  1d80: 50 43 42 4c 4e 4b 41 00 12 14 04 0c ff ff 1c 00  PCBLNKA.........
  1d90: 0a 02 5e 2e 4c 50 43 42 4c 4e 4b 43 00 12 14 04  ..^.LPCBLNKC....
  1da0: 0c ff ff 1c 00 0a 03 5e 2e 4c 50 43 42 4c 4e 4b  .......^.LPCBLNK
  1db0: 44 00 12 13 04 0c ff ff 1d 00 00 5e 2e 4c 50 43  D..........^.LPC
  1dc0: 42 4c 4e 4b 48 00 12 13 04 0c ff ff 1d 00 01 5e  BLNKH..........^
  1dd0: 2e 4c 50 43 42 4c 4e 4b 44 00 12 14 04 0c ff ff  .LPCBLNKD.......
  1de0: 1d 00 0a 02 5e 2e 4c 50 43 42 4c 4e 4b 43 00 12  ....^.LPCBLNKC..
  1df0: 13 04 0c ff ff 1f 00 00 5e 2e 4c 50 43 42 4c 4e  ........^.LPCBLN
  1e00: 4b 44 00 12 13 04 0c ff ff 1f 00 01 5e 2e 4c 50  KD..........^.LP
  1e10: 43 42 4c 4e 4b 44 00 12 14 04 0c ff ff 1f 00 0a  CBLNKD..........
  1e20: 02 5e 2e 4c 50 43 42 4c 4e 4b 44 00 12 14 04 0c  .^.LPCBLNKD.....
  1e30: ff ff 1f 00 0a 03 5e 2e 4c 50 43 42 4c 4e 4b 41  ......^.LPCBLNKA
  1e40: 00 14 4c 11 5f 4f 53 43 04 44 42 47 43 0a 6c 0a  ..L._OSC.DBGC.l.
  1e50: 80 42 43 45 4e 8a 6b 00 50 53 54 53 8a 6b 0a 04  .BCEN.k.PSTS.k..
  1e60: 50 53 55 50 8a 6b 0a 08 50 43 4e 54 70 50 53 55  PSUP.k..PCNTpPSU
  1e70: 50 53 55 50 50 70 50 43 4e 54 43 54 52 4c 08 55  PSUPPpPCNTCTRL.U
  1e80: 49 44 31 11 13 0a 10 5b 4d db 33 f7 1f 1c 40 96  ID1....[M.3...@.
  1e90: 57 74 41 c0 3d d7 66 a0 4b 0a 93 68 11 13 0a 10  WtA.=.f.K..h....
  1ea0: 5b 4d db 33 f7 1f 1c 40 96 57 74 41 c0 3d d7 66  [M.3...@.WtA.=.f
  1eb0: 7b 43 54 52 4c 0a 1d 43 54 52 4c a0 15 92 93 7b  {CTRL..CTRL....{
  1ec0: 53 55 50 50 0a 16 00 0a 16 7b 43 54 52 4c 0a 1e  SUPP.....{CTRL..
  1ed0: 00 a0 27 80 7b 50 53 54 53 01 00 00 a0 08 7b 43  ..'.{PSTS.....{C
  1ee0: 54 52 4c 01 00 a0 09 7b 43 54 52 4c 0a 04 00 a0  TRL....{CTRL....
  1ef0: 09 7b 43 54 52 4c 0a 10 00 a0 1e 92 93 69 01 7d  .{CTRL.......i.}
  1f00: 50 53 54 53 0a 08 50 53 54 53 44 42 47 43 0a 6c  PSTS..PSTSDBGC.l
  1f10: 0a 81 42 43 45 4e a4 6b a0 16 92 93 50 43 4e 54  ..BCEN.k....PCNT
  1f20: 43 54 52 4c 7d 50 53 54 53 0a 10 50 53 54 53 70  CTRL}PSTS..PSTSp
  1f30: 00 50 43 4e 54 44 42 47 43 0a 6c 0a 82 42 43 45  .PCNTDBGC.l..BCE
  1f40: 4e a4 6b a1 1a 7d 50 53 54 53 0a 04 50 53 54 53  N.k..}PSTS..PSTS
  1f50: 44 42 47 43 0a 6c 0a 83 42 43 45 4e a4 6b 5b 82  DBGC.l..BCEN.k[.
  1f60: 40 14 50 44 52 43 08 5f 48 49 44 0c 41 d0 0c 02  @.PDRC._HID.A...
  1f70: 08 5f 55 49 44 01 08 42 55 46 30 11 46 06 0a 62  ._UID..BUF0.F..b
  1f80: 86 09 00 01 00 00 00 00 00 40 00 00 86 09 00 01  .........@......
  1f90: 00 00 00 00 00 40 00 00 86 09 00 01 00 00 00 00  .....@..........
  1fa0: 00 10 00 00 86 09 00 01 00 00 00 00 00 10 00 00  ................
  1fb0: 86 09 00 01 00 00 00 00 00 00 00 00 86 09 00 01  ................
  1fc0: 00 00 d2 fe 00 00 02 00 86 09 00 01 00 00 d4 fe  ................
  1fd0: 00 50 00 00 86 09 00 01 00 50 d4 fe 00 b0 04 00  .P.......P......
  1fe0: 79 00 14 4d 0b 5f 43 52 53 08 8a 42 55 46 30 0a  y..M._CRS..BUF0.
  1ff0: 04 52 42 52 30 79 5e 5e 2e 4c 50 43 42 52 43 42  .RBR0y^^.LPCBRCB
  2000: 41 0a 0e 52 42 52 30 8a 42 55 46 30 0a 10 4d 42  A..RBR0.BUF0..MB
  2010: 52 30 79 5e 5e 2e 4d 43 48 43 4d 48 42 52 0a 0e  R0y^^.MCHCMHBR..
  2020: 4d 42 52 30 8a 42 55 46 30 0a 1c 44 42 52 30 79  MBR0.BUF0..DBR0y
  2030: 5e 5e 2e 4d 43 48 43 44 49 42 52 0a 0c 44 42 52  ^^.MCHCDIBR..DBR
  2040: 30 8a 42 55 46 30 0a 28 45 42 52 30 79 5e 5e 2e  0.BUF0.(EBR0y^^.
  2050: 4d 43 48 43 45 50 42 52 0a 0c 45 42 52 30 8a 42  MCHCEPBR..EBR0.B
  2060: 55 46 30 0a 34 58 42 52 30 79 5e 5e 2e 4d 43 48  UF0.4XBR0y^^.MCH
  2070: 43 50 58 42 52 0a 1a 58 42 52 30 8a 42 55 46 30  CPXBR..XBR0.BUF0
  2080: 0a 38 58 53 5a 30 7a 0c 00 00 00 10 5e 5e 2e 4d  .8XSZ0z.....^^.M
  2090: 43 48 43 50 58 53 5a 58 53 5a 30 a4 42 55 46 30  CHCPXSZXSZ0.BUF0
  20a0: 5b 82 4d 2c 50 45 47 50 08 5f 41 44 52 0c 00 00  [.M,PEGP._ADR...
  20b0: 01 00 14 41 09 5f 50 52 54 00 a0 33 47 50 49 43  ...A._PRT..3GPIC
  20c0: a4 12 2c 04 12 09 04 0b ff ff 00 00 0a 10 12 09  ..,.............
  20d0: 04 0b ff ff 01 00 0a 11 12 0a 04 0b ff ff 0a 02  ................
  20e0: 00 0a 12 12 0a 04 0b ff ff 0a 03 00 0a 13 a1 45  ...............E
  20f0: 05 a4 12 41 05 04 12 12 04 0b ff ff 00 5e 5e 2e  ...A.........^^.
  2100: 4c 50 43 42 4c 4e 4b 41 00 12 12 04 0b ff ff 01  LPCBLNKA........
  2110: 5e 5e 2e 4c 50 43 42 4c 4e 4b 42 00 12 13 04 0b  ^^.LPCBLNKB.....
  2120: ff ff 0a 02 5e 5e 2e 4c 50 43 42 4c 4e 4b 43 00  ....^^.LPCBLNKC.
  2130: 12 13 04 0b ff ff 0a 03 5e 5e 2e 4c 50 43 42 4c  ........^^.LPCBL
  2140: 4e 4b 44 00 5b 82 49 22 4e 47 46 58 14 13 5f 41  NKD.[.I"NGFX.._A
  2150: 44 52 08 44 42 47 43 0a 62 00 42 43 45 4e a4 00  DR.DBGC.b.BCEN..
  2160: 5b 80 4e 56 46 58 02 00 0a 10 5b 81 0b 4e 56 46  [.NVFX....[..NVF
  2170: 58 00 4e 56 49 44 10 5b 82 0d 4c 43 44 5f 08 5f  X.NVID.[..LCD_._
  2180: 41 44 52 0b 18 01 08 45 52 52 30 11 07 0a 04 00  ADR....ERR0.....
  2190: 00 00 00 08 45 52 52 31 11 07 0a 04 01 00 00 80  ....ERR1........
  21a0: 08 56 45 52 31 11 07 0a 04 01 00 00 00 08 42 48  .VER1.........BH
  21b0: 57 31 11 0f 0a 0c 00 00 64 00 c8 00 00 00 00 00  W1......d.......
  21c0: e8 03 08 42 43 4c 31 11 0e 0a 0b 64 64 14 18 1d  ...BCL1....dd...
  21d0: 24 2c 35 3f 4c 64 08 4f 44 49 44 11 13 0a 10 10  $,5?Ld.ODID.....
  21e0: 01 00 00 00 01 01 00 00 02 01 00 20 01 00 00 14  ........... ....
  21f0: 4f 17 4e 56 49 46 03 44 42 47 43 0a 6f 68 42 43  O.NVIF.DBGC.ohBC
  2200: 45 4e a0 10 93 68 01 73 45 52 52 30 56 45 52 31  EN...h.sERR0VER1
  2210: 60 a4 60 a1 46 15 a0 43 13 93 68 0a 09 08 5f 54  `.`.F..C..h..._T
  2220: 5f 30 00 70 99 69 00 5f 54 5f 30 a0 0f 93 5f 54  _0.p.i._T_0..._T
  2230: 5f 30 00 70 45 52 52 30 61 a4 61 a1 4e 10 a0 49  _0.pERR0a.a.N..I
  2240: 07 93 5f 54 5f 30 01 08 5f 54 5f 31 00 70 99 50  .._T_0.._T_1.p.P
  2250: 4e 49 44 00 5f 54 5f 31 a0 11 93 5f 54 5f 31 01  NID._T_1..._T_1.
  2260: 73 45 52 52 30 42 48 57 31 61 a1 4b 04 a0 12 93  sERR0BHW1a.K....
  2270: 5f 54 5f 31 0a 02 73 45 52 52 30 42 48 57 31 61  _T_1..sERR0BHW1a
  2280: a1 35 a0 12 93 5f 54 5f 31 0a 04 73 45 52 52 30  .5..._T_1..sERR0
  2290: 42 48 57 31 61 a1 20 a0 12 93 5f 54 5f 31 0a 05  BHW1a. ..._T_1..
  22a0: 73 45 52 52 30 42 48 57 31 61 a1 0b 73 45 52 52  sERR0BHW1a..sERR
  22b0: 30 42 48 57 31 61 a4 61 a1 41 09 a0 10 93 5f 54  0BHW1a.a.A...._T
  22c0: 5f 30 0a 02 70 45 52 52 30 61 a4 61 a1 4d 07 a0  _0..pERR0a.a.M..
  22d0: 4a 07 93 5f 54 5f 30 0a 03 08 5f 54 5f 32 00 70  J.._T_0..._T_2.p
  22e0: 99 50 4e 49 44 00 5f 54 5f 32 a0 11 93 5f 54 5f  .PNID._T_2..._T_
  22f0: 32 01 73 45 52 52 30 42 43 4c 31 61 a1 4b 04 a0  2.sERR0BCL1a.K..
  2300: 12 93 5f 54 5f 32 0a 02 73 45 52 52 30 42 43 4c  .._T_2..sERR0BCL
  2310: 31 61 a1 35 a0 12 93 5f 54 5f 32 0a 04 73 45 52  1a.5..._T_2..sER
  2320: 52 30 42 43 4c 31 61 a1 20 a0 12 93 5f 54 5f 32  R0BCL1a. ..._T_2
  2330: 0a 05 73 45 52 52 30 42 43 4c 31 61 a1 0b 73 45  ..sERR0BCL1a..sE
  2340: 52 52 30 42 43 4c 31 61 a4 61 a1 1f a0 1d 93 68  RR0BCL1a.a.....h
  2350: 0a 0b a0 10 93 69 01 73 45 52 52 30 4f 44 49 44  .....i.sERR0ODID
  2360: 60 a4 60 a1 06 a4 45 52 52 31 a4 45 52 52 31 5b  `.`...ERR1.ERR1[
  2370: 82 4d e7 47 46 58 30 14 17 5f 41 44 52 08 44 42  .M.GFX0.._ADR.DB
  2380: 47 43 0a 63 00 42 43 45 4e a4 0c 00 00 02 00 5b  GC.c.BCEN......[
  2390: 80 49 47 46 58 02 0a f0 0a 10 5b 81 0d 49 47 46  .IGFX.....[..IGF
  23a0: 58 00 00 20 42 52 45 47 08 14 10 5f 44 4f 53 01  X.. BREG..._DOS.
  23b0: 70 7b 68 0a 03 00 44 53 45 4e 14 4c 1d 5f 44 4f  p{h...DSEN.L._DO
  23c0: 44 00 a0 2c 93 4e 44 49 44 01 08 54 4d 50 31 12  D..,.NDID..TMP1.
  23d0: 07 01 0c ff ff ff ff 70 7d 0c 00 00 01 00 44 49  .......p}.....DI
  23e0: 44 31 00 88 54 4d 50 31 00 00 a4 54 4d 50 31 a0  D1..TMP1...TMP1.
  23f0: 46 04 93 4e 44 49 44 0a 02 08 54 4d 50 32 12 0c  F..NDID...TMP2..
  2400: 02 0c ff ff ff ff 0c ff ff ff ff 70 7d 0c 00 00  ...........p}...
  2410: 01 00 44 49 44 31 00 88 54 4d 50 32 00 00 70 7d  ..DID1..TMP2..p}
  2420: 0c 00 00 01 00 44 49 44 32 00 88 54 4d 50 32 01  .....DID2..TMP2.
  2430: 00 a4 54 4d 50 32 a0 4f 05 93 4e 44 49 44 0a 03  ..TMP2.O..NDID..
  2440: 08 54 4d 50 33 12 11 03 0c ff ff ff ff 0c ff ff  .TMP3...........
  2450: ff ff 0c ff ff ff ff 70 7d 0c 00 00 01 00 44 49  .......p}.....DI
  2460: 44 31 00 88 54 4d 50 33 00 00 70 7d 0c 00 00 01  D1..TMP3..p}....
  2470: 00 44 49 44 32 00 88 54 4d 50 33 01 00 70 7d 0c  .DID2..TMP3..p}.
  2480: 00 00 01 00 44 49 44 33 00 88 54 4d 50 33 0a 02  ....DID3..TMP3..
  2490: 00 a4 54 4d 50 33 a0 48 07 93 4e 44 49 44 0a 04  ..TMP3.H..NDID..
  24a0: 08 54 4d 50 34 12 16 04 0c ff ff ff ff 0c ff ff  .TMP4...........
  24b0: ff ff 0c ff ff ff ff 0c ff ff ff ff 70 7d 0c 00  ............p}..
  24c0: 00 01 00 44 49 44 31 00 88 54 4d 50 34 00 00 70  ...DID1..TMP4..p
  24d0: 7d 0c 00 00 01 00 44 49 44 32 00 88 54 4d 50 34  }.....DID2..TMP4
  24e0: 01 00 70 7d 0c 00 00 01 00 44 49 44 33 00 88 54  ..p}.....DID3..T
  24f0: 4d 50 34 0a 02 00 70 7d 0c 00 00 01 00 44 49 44  MP4...p}.....DID
  2500: 34 00 88 54 4d 50 34 0a 03 00 a4 54 4d 50 34 08  4..TMP4....TMP4.
  2510: 54 4d 50 35 12 1b 05 0c ff ff ff ff 0c ff ff ff  TMP5............
  2520: ff 0c ff ff ff ff 0c ff ff ff ff 0c ff ff ff ff  ................
  2530: 70 7d 0c 00 00 01 00 44 49 44 31 00 88 54 4d 50  p}.....DID1..TMP
  2540: 35 00 00 70 7d 0c 00 00 01 00 44 49 44 32 00 88  5..p}.....DID2..
  2550: 54 4d 50 35 01 00 70 7d 0c 00 00 01 00 44 49 44  TMP5..p}.....DID
  2560: 33 00 88 54 4d 50 35 0a 02 00 70 7d 0c 00 00 01  3..TMP5...p}....
  2570: 00 44 49 44 34 00 88 54 4d 50 35 0a 03 00 70 7d  .DID4..TMP5...p}
  2580: 0c 00 00 01 00 44 49 44 35 00 88 54 4d 50 35 0a  .....DID5..TMP5.
  2590: 04 00 a4 54 4d 50 35 5b 82 46 06 44 44 30 31 14  ...TMP5[.F.DD01.
  25a0: 10 5f 41 44 52 08 a4 7b 0b ff ff 44 49 44 31 00  ._ADR..{...DID1.
  25b0: 14 1a 5f 44 43 53 00 54 52 41 50 01 a0 0b 7b 43  .._DCS.TRAP...{C
  25c0: 53 54 45 01 00 a4 0a 1f a4 0a 1d 14 13 5f 44 47  STE.........._DG
  25d0: 53 00 a0 0a 7b 4e 53 54 45 01 00 a4 01 a4 00 14  S...{NSTE.......
  25e0: 1f 5f 44 53 53 01 a0 18 93 7b 68 0c 00 00 00 c0  ._DSS....{h.....
  25f0: 00 0c 00 00 00 c0 70 4e 53 54 45 43 53 54 45 5b  ......pNSTECSTE[
  2600: 82 48 06 44 44 30 32 14 10 5f 41 44 52 08 a4 7b  .H.DD02.._ADR..{
  2610: 0b ff ff 44 49 44 32 00 14 1b 5f 44 43 53 00 54  ...DID2..._DCS.T
  2620: 52 41 50 01 a0 0c 7b 43 53 54 45 0a 02 00 a4 0a  RAP...{CSTE.....
  2630: 1f a4 0a 1d 14 14 5f 44 47 53 00 a0 0b 7b 4e 53  ......_DGS...{NS
  2640: 54 45 0a 02 00 a4 01 a4 00 14 1f 5f 44 53 53 01  TE........._DSS.
  2650: a0 18 93 7b 68 0c 00 00 00 c0 00 0c 00 00 00 c0  ...{h...........
  2660: 70 4e 53 54 45 43 53 54 45 5b 82 48 06 44 44 30  pNSTECSTE[.H.DD0
  2670: 33 14 10 5f 41 44 52 08 a4 7b 0b ff ff 44 49 44  3.._ADR..{...DID
  2680: 33 00 14 1b 5f 44 43 53 00 54 52 41 50 01 a0 0c  3..._DCS.TRAP...
  2690: 7b 43 53 54 45 0a 04 00 a4 0a 1f a4 0a 1d 14 14  {CSTE...........
  26a0: 5f 44 47 53 00 a0 0b 7b 4e 53 54 45 0a 04 00 a4  _DGS...{NSTE....
  26b0: 01 a4 00 14 1f 5f 44 53 53 01 a0 18 93 7b 68 0c  ....._DSS....{h.
  26c0: 00 00 00 c0 00 0c 00 00 00 c0 70 4e 53 54 45 43  ..........pNSTEC
  26d0: 53 54 45 5b 82 4a 13 44 44 30 34 08 52 54 4c 31  STE[.J.DD04.RTL1
  26e0: 11 0c 0a 09 14 18 1d 24 2c 35 3f 4c 64 08 49 43  .......$,5?Ld.IC
  26f0: 4c 31 12 18 0b 0a 64 0a 64 0a 04 0a 10 0a 1c 0a  L1....d.d.......
  2700: 28 0a 34 0a 40 0a 4c 0a 58 0a 64 14 10 5f 41 44  (.4.@.L.X.d.._AD
  2710: 52 08 a4 7b 0b ff ff 44 49 44 34 00 14 1b 5f 44  R..{...DID4..._D
  2720: 43 53 00 54 52 41 50 01 a0 0c 7b 43 53 54 45 0a  CS.TRAP...{CSTE.
  2730: 08 00 a4 0a 1f a4 0a 1d 14 14 5f 44 47 53 00 a0  .........._DGS..
  2740: 0b 7b 4e 53 54 45 0a 08 00 a4 01 a4 00 14 1f 5f  .{NSTE........._
  2750: 44 53 53 01 a0 18 93 7b 68 0c 00 00 00 c0 00 0c  DSS....{h.......
  2760: 00 00 00 c0 70 4e 53 54 45 43 53 54 45 14 0b 5f  ....pNSTECSTE.._
  2770: 42 43 4c 00 a4 49 43 4c 31 14 45 09 5f 42 43 4d  BCL..ICL1.E._BCM
  2780: 01 78 74 68 0a 04 00 0a 0c 00 60 08 5f 54 5f 30  .xth......`._T_0
  2790: 00 70 99 50 4e 49 44 00 5f 54 5f 30 a0 11 93 5f  .p.PNID._T_0..._
  27a0: 54 5f 30 01 70 83 88 52 54 4c 31 60 00 60 a1 4b  T_0.p..RTL1`.`.K
  27b0: 04 a0 12 93 5f 54 5f 30 0a 02 70 83 88 52 54 4c  ...._T_0..p..RTL
  27c0: 31 60 00 60 a1 35 a0 12 93 5f 54 5f 30 0a 04 70  1`.`.5..._T_0..p
  27d0: 83 88 52 54 4c 31 60 00 60 a1 20 a0 12 93 5f 54  ..RTL1`.`. ..._T
  27e0: 5f 30 0a 05 70 83 88 52 54 4c 31 60 00 60 a1 0b  _0..p..RTL1`.`..
  27f0: 70 83 88 52 54 4c 31 60 00 60 70 60 42 52 54 4c  p..RTL1`.`p`BRTL
  2800: 70 60 43 42 4c 56 41 49 4e 54 01 42 52 54 4c 5b  p`CBLVAINT.BRTL[
  2810: 82 48 06 44 44 30 35 14 10 5f 41 44 52 08 a4 7b  .H.DD05.._ADR..{
  2820: 0b ff ff 44 49 44 35 00 14 1b 5f 44 43 53 00 54  ...DID5..._DCS.T
  2830: 52 41 50 01 a0 0c 7b 43 53 54 45 0a 10 00 a4 0a  RAP...{CSTE.....
  2840: 1f a4 0a 1d 14 14 5f 44 47 53 00 a0 0b 7b 4e 53  ......_DGS...{NS
  2850: 54 45 0a 10 00 a4 01 a4 00 14 1f 5f 44 53 53 01  TE........._DSS.
  2860: a0 18 93 7b 68 0c 00 00 00 c0 00 0c 00 00 00 c0  ...{h...........
  2870: 70 4e 53 54 45 43 53 54 45 10 24 5e 5e 50 43 49  pNSTECSTE.$^^PCI
  2880: 30 5b 80 4d 43 48 50 02 0a 40 0a c0 5b 81 10 4d  0[.MCHP..@..[..M
  2890: 43 48 50 00 00 40 30 54 41 53 4d 0a 00 06 5b 80  CHP..@0TASM...[.
  28a0: 49 47 44 50 02 0a 40 0a c0 5b 81 45 05 49 47 44  IGDP..@..[.E.IGD
  28b0: 50 00 00 40 09 00 01 47 49 56 44 01 00 02 47 55  P..@...GIVD...GU
  28c0: 4d 41 03 00 09 00 04 47 4d 46 4e 01 00 1b 00 40  MA.....GMFN....@
  28d0: 46 41 53 4c 45 08 00 18 47 53 53 45 01 47 53 53  FASLE...GSSE.GSS
  28e0: 42 0e 47 53 45 53 01 00 30 00 08 43 44 56 4c 05  B.GSES..0..CDVL.
  28f0: 00 03 00 18 4c 42 50 43 08 00 30 41 53 4c 53 20  ....LBPC..0ASLS 
  2900: 5b 80 49 47 44 4d 00 41 53 4c 42 0b 00 20 5b 81  [.IGDM.ASLB.. [.
  2910: 43 17 49 47 44 4d 00 53 49 47 4e 40 08 53 49 5a  C.IGDM.SIGN@.SIZ
  2920: 45 20 4f 56 45 52 20 53 56 45 52 40 10 56 56 45  E OVER SVER@.VVE
  2930: 52 40 08 47 56 45 52 40 08 4d 42 4f 58 20 00 40  R@.GVER@.MBOX .@
  2940: 52 44 52 44 59 20 43 53 54 53 20 43 45 56 54 20  RDRDY CSTS CEVT 
  2950: 00 40 0a 44 49 44 4c 20 44 44 4c 32 20 44 44 4c  .@.DIDL DDL2 DDL
  2960: 33 20 44 44 4c 34 20 44 44 4c 35 20 44 44 4c 36  3 DDL4 DDL5 DDL6
  2970: 20 44 44 4c 37 20 44 44 4c 38 20 43 50 44 4c 20   DDL7 DDL8 CPDL 
  2980: 43 50 4c 32 20 43 50 4c 33 20 43 50 4c 34 20 43  CPL2 CPL3 CPL4 C
  2990: 50 4c 35 20 43 50 4c 36 20 43 50 4c 37 20 43 50  PL5 CPL6 CPL7 CP
  29a0: 4c 38 20 43 41 44 4c 20 43 41 4c 32 20 43 41 4c  L8 CADL CAL2 CAL
  29b0: 33 20 43 41 4c 34 20 43 41 4c 35 20 43 41 4c 36  3 CAL4 CAL5 CAL6
  29c0: 20 43 41 4c 37 20 43 41 4c 38 20 4e 41 44 4c 20   CAL7 CAL8 NADL 
  29d0: 4e 44 4c 32 20 4e 44 4c 33 20 4e 44 4c 34 20 4e  NDL2 NDL3 NDL4 N
  29e0: 44 4c 35 20 4e 44 4c 36 20 4e 44 4c 37 20 4e 44  DL5 NDL6 NDL7 ND
  29f0: 4c 38 20 41 53 4c 50 20 54 49 44 58 20 43 48 50  L8 ASLP TIDX CHP
  2a00: 44 20 43 4c 49 44 20 43 44 43 4b 20 53 58 53 57  D CLID CDCK SXSW
  2a10: 20 45 56 54 53 20 43 4e 4f 54 20 4e 52 44 59 20   EVTS CNOT NRDY 
  2a20: 00 40 1e 53 43 49 45 01 47 45 46 43 04 47 58 46  .@.SCIE.GEFC.GXF
  2a30: 43 03 47 45 53 46 08 00 10 50 41 52 4d 20 44 53  C.GESF...PARM DS
  2a40: 4c 50 20 00 40 7a 41 52 44 59 20 41 53 4c 43 20  LP .@zARDY ASLC 
  2a50: 54 43 48 45 20 41 4c 53 49 20 42 43 4c 50 20 50  TCHE ALSI BCLP P
  2a60: 46 49 54 20 43 42 4c 56 20 42 43 4c 4d 40 14 43  FIT CBLV BCLM@.C
  2a70: 50 46 4d 20 45 50 46 4d 20 00 40 5a 47 56 44 31  PFM EPFM .@ZGVD1
  2a80: 80 00 0e 08 44 42 54 42 12 32 15 00 0a 07 0a 38  ....DBTB.2.....8
  2a90: 0b c0 01 0b 00 0e 0a 3f 0b c7 01 0b 07 0e 0b f8  .......?........
  2aa0: 01 0b 38 0e 0b c0 0f 00 00 00 00 00 0b 00 70 0b  ..8...........p.
  2ab0: 07 70 0b 38 70 0b c0 71 0b 00 7e 08 43 44 43 54  .p.8p..q..~.CDCT
  2ac0: 12 23 03 12 0a 03 0a c8 0b 40 01 0b 90 01 12 0a  .#.......@......
  2ad0: 03 0a c8 0b 4d 01 0b 90 01 12 0a 03 0a de 0b 4d  ....M..........M
  2ae0: 01 0b 7d 01 08 53 55 43 43 01 08 4e 56 4c 44 0a  ..}..SUCC..NVLD.
  2af0: 02 08 43 52 49 54 0a 04 08 4e 43 52 54 0a 06 14  ..CRIT...NCRT...
  2b00: 4a 4c 47 53 43 49 08 14 45 1f 47 42 44 41 08 a0  JLGSCI..E.GBDA..
  2b10: 1a 93 47 45 53 46 00 70 0b 79 02 50 41 52 4d 70  ..GESF.p.y.PARMp
  2b20: 00 47 45 53 46 a4 53 55 43 43 a0 1a 93 47 45 53  .GESF.SUCC...GES
  2b30: 46 01 70 0b 40 02 50 41 52 4d 70 00 47 45 53 46  F.p.@.PARMp.GESF
  2b40: a4 53 55 43 43 a0 47 04 93 47 45 53 46 0a 04 7b  .SUCC.G..GESF..{
  2b50: 50 41 52 4d 0c 00 00 ff ef 50 41 52 4d 7b 50 41  PARM.....PARM{PA
  2b60: 52 4d 79 83 88 44 42 54 42 49 42 54 54 00 0a 10  RMy..DBTBIBTT...
  2b70: 00 50 41 52 4d 7d 49 42 54 54 50 41 52 4d 50 41  .PARM}IBTTPARMPA
  2b80: 52 4d 70 00 47 45 53 46 a4 53 55 43 43 a0 4b 07  RMp.GESF.SUCC.K.
  2b90: 93 47 45 53 46 0a 05 70 49 50 53 43 50 41 52 4d  .GESF..pIPSCPARM
  2ba0: 7d 50 41 52 4d 79 49 50 41 54 0a 08 00 50 41 52  }PARMyIPAT...PAR
  2bb0: 4d 72 50 41 52 4d 0b 00 01 50 41 52 4d 7d 50 41  MrPARM...PARM}PA
  2bc0: 52 4d 79 4c 49 44 53 0a 10 00 50 41 52 4d 72 50  RMyLIDS...PARMrP
  2bd0: 41 52 4d 0c 00 00 01 00 50 41 52 4d 7d 50 41 52  ARM.....PARM}PAR
  2be0: 4d 79 49 42 4c 43 0a 12 00 50 41 52 4d 7d 50 41  MyIBLC...PARM}PA
  2bf0: 52 4d 79 49 42 49 41 0a 14 00 50 41 52 4d 70 00  RMyIBIA...PARMp.
  2c00: 47 45 53 46 a4 53 55 43 43 a0 2d 93 47 45 53 46  GESF.SUCC.-.GESF
  2c10: 0a 06 70 49 54 56 46 50 41 52 4d 7d 50 41 52 4d  ..pITVFPARM}PARM
  2c20: 79 49 54 56 4d 0a 04 00 50 41 52 4d 70 00 47 45  yITVM...PARMp.GE
  2c30: 53 46 a4 53 55 43 43 a0 4f 08 93 47 45 53 46 0a  SF.SUCC.O..GESF.
  2c40: 07 70 47 49 56 44 50 41 52 4d 7f 50 41 52 4d 01  .pGIVDPARM.PARM.
  2c50: 50 41 52 4d 7d 50 41 52 4d 79 47 4d 46 4e 01 00  PARM}PARMyGMFN..
  2c60: 50 41 52 4d 7d 50 41 52 4d 0b 00 10 50 41 52 4d  PARM}PARM...PARM
  2c70: a0 16 49 44 4d 4d 7d 50 41 52 4d 79 49 44 4d 53  ..IDMM}PARMyIDMS
  2c80: 0a 11 00 50 41 52 4d a1 12 7d 50 41 52 4d 79 49  ...PARM..}PARMyI
  2c90: 44 4d 53 0a 0d 00 50 41 52 4d 7d 79 83 88 83 88  DMS...PARM}y....
  2ca0: 43 44 43 54 48 56 43 4f 00 74 43 44 56 4c 01 00  CDCTHVCO.tCDVL..
  2cb0: 00 0a 15 00 50 41 52 4d 50 41 52 4d 70 01 47 45  ....PARMPARMp.GE
  2cc0: 53 46 a4 53 55 43 43 a0 2a 93 47 45 53 46 0a 0a  SF.SUCC.*.GESF..
  2cd0: 70 00 50 41 52 4d a0 10 49 53 53 43 7d 50 41 52  p.PARM..ISSC}PAR
  2ce0: 4d 0a 03 50 41 52 4d 70 00 47 45 53 46 a4 53 55  M..PARMp.GESF.SU
  2cf0: 43 43 70 00 47 45 53 46 a4 43 52 49 54 14 4e 28  CCp.GESF.CRIT.N(
  2d00: 53 42 43 42 08 a0 20 93 47 45 53 46 00 70 00 50  SBCB.. .GESF.p.P
  2d10: 41 52 4d 70 0b fd f7 50 41 52 4d 70 00 47 45 53  ARMp...PARMp.GES
  2d20: 46 a4 53 55 43 43 a0 18 93 47 45 53 46 01 70 00  F.SUCC...GESF.p.
  2d30: 47 45 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0  GESFp.PARM.SUCC.
  2d40: 19 93 47 45 53 46 0a 03 70 00 47 45 53 46 70 00  ..GESF..p.GESFp.
  2d50: 50 41 52 4d a4 53 55 43 43 a0 19 93 47 45 53 46  PARM.SUCC...GESF
  2d60: 0a 04 70 00 47 45 53 46 70 00 50 41 52 4d a4 53  ..p.GESFp.PARM.S
  2d70: 55 43 43 a0 19 93 47 45 53 46 0a 05 70 00 47 45  UCC...GESF..p.GE
  2d80: 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0 37 93  SFp.PARM.SUCC.7.
  2d90: 47 45 53 46 0a 06 70 7b 50 41 52 4d 0a 0f 00 49  GESF..p{PARM...I
  2da0: 54 56 46 70 7a 7b 50 41 52 4d 0a f0 00 0a 04 00  TVFpz{PARM......
  2db0: 49 54 56 4d 70 00 47 45 53 46 70 00 50 41 52 4d  ITVMp.GESFp.PARM
  2dc0: a4 53 55 43 43 a0 19 93 47 45 53 46 0a 07 70 00  .SUCC...GESF..p.
  2dd0: 47 45 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0  GESFp.PARM.SUCC.
  2de0: 19 93 47 45 53 46 0a 08 70 00 47 45 53 46 70 00  ..GESF..p.GESFp.
  2df0: 50 41 52 4d a4 53 55 43 43 a0 24 93 47 45 53 46  PARM.SUCC.$.GESF
  2e00: 0a 09 7b 50 41 52 4d 0a ff 49 42 54 54 70 00 47  ..{PARM..IBTTp.G
  2e10: 45 53 46 70 00 50 41 52 4d a4 53 55 43 43 a0 46  ESFp.PARM.SUCC.F
  2e20: 05 93 47 45 53 46 0a 0a 7b 50 41 52 4d 0a ff 49  ..GESF..{PARM..I
  2e30: 50 53 43 a0 21 7b 7a 50 41 52 4d 0a 08 00 0a ff  PSC.!{zPARM.....
  2e40: 00 7b 7a 50 41 52 4d 0a 08 00 0a ff 49 50 41 54  .{zPARM.....IPAT
  2e50: 76 49 50 41 54 7b 7a 50 41 52 4d 0a 14 00 0a 07  vIPAT{zPARM.....
  2e60: 49 42 49 41 70 00 47 45 53 46 70 00 50 41 52 4d  IBIAp.GESFp.PARM
  2e70: a4 53 55 43 43 a0 40 06 93 47 45 53 46 0a 0b 7b  .SUCC.@..GESF..{
  2e80: 7a 50 41 52 4d 01 00 01 49 46 31 45 a0 21 7b 50  zPARM...IF1E.!{P
  2e90: 41 52 4d 0c 00 e0 01 00 00 7b 7a 50 41 52 4d 0a  ARM......{zPARM.
  2ea0: 0d 00 0a 0f 49 44 4d 53 70 00 49 44 4d 4d a1 16  ....IDMSp.IDMM..
  2eb0: 7b 7a 50 41 52 4d 0a 11 00 0a 0f 49 44 4d 53 70  {zPARM.....IDMSp
  2ec0: 01 49 44 4d 4d 70 00 47 45 53 46 70 00 50 41 52  .IDMMp.GESFp.PAR
  2ed0: 4d a4 53 55 43 43 a0 19 93 47 45 53 46 0a 10 70  M.SUCC...GESF..p
  2ee0: 00 47 45 53 46 70 00 50 41 52 4d a4 53 55 43 43  .GESFp.PARM.SUCC
  2ef0: a0 2c 93 47 45 53 46 0a 11 70 79 4c 49 44 53 0a  .,.GESF..pyLIDS.
  2f00: 08 00 50 41 52 4d 72 50 41 52 4d 0b 00 01 50 41  ..PARMrPARM...PA
  2f10: 52 4d 70 00 47 45 53 46 a4 53 55 43 43 a0 49 04  RMp.GESF.SUCC.I.
  2f20: 93 47 45 53 46 0a 12 a0 26 7b 50 41 52 4d 01 00  .GESF...&{PARM..
  2f30: a0 10 93 7a 50 41 52 4d 01 00 01 70 01 49 53 53  ...zPARM...p.ISS
  2f40: 43 a1 0c 70 00 47 45 53 46 a4 43 52 49 54 a1 07  C..p.GESF.CRIT..
  2f50: 70 00 49 53 53 43 70 00 47 45 53 46 70 00 50 41  p.ISSCp.GESFp.PA
  2f60: 52 4d a4 53 55 43 43 a0 19 93 47 45 53 46 0a 13  RM.SUCC...GESF..
  2f70: 70 00 47 45 53 46 70 00 50 41 52 4d a4 53 55 43  p.GESFp.PARM.SUC
  2f80: 43 70 00 47 45 53 46 a4 53 55 43 43 a0 11 93 47  Cp.GESF.SUCC...G
  2f90: 45 46 43 0a 04 70 47 42 44 41 47 58 46 43 a0 11  EFC..pGBDAGXFC..
  2fa0: 93 47 45 46 43 0a 06 70 53 42 43 42 47 58 46 43  .GEFC..pSBCBGXFC
  2fb0: 70 00 47 45 46 43 70 01 53 43 49 53 70 00 47 53  p.GEFCp.SCISp.GS
  2fc0: 53 45 70 00 53 43 49 45 a4 00 14 19 50 44 52 44  SEp.SCIE....PDRD
  2fd0: 00 a0 0c 92 44 52 44 59 5b 22 41 53 4c 50 a4 92  ....DRDY["ASLP..
  2fe0: 44 52 44 59 14 1d 50 53 54 53 00 a0 0e 94 43 53  DRDY..PSTS....CS
  2ff0: 54 53 0a 02 5b 22 41 53 4c 50 a4 93 43 53 54 53  TS..["ASLP..CSTS
  3000: 0a 03 14 47 06 47 4e 4f 54 02 a0 07 50 44 52 44  ...G.GNOT...PDRD
  3010: a4 01 a0 07 50 53 54 53 a4 01 70 68 43 45 56 54  ....PSTS..phCEVT
  3020: 70 0a 03 43 53 54 53 a0 2c 90 93 43 48 50 44 00  p..CSTS.,..CHPD.
  3030: 93 69 00 a0 18 91 94 4f 53 59 53 0b d0 07 95 4f  .i.....OSYS....O
  3040: 53 59 53 0b d6 07 86 50 43 49 30 69 a1 07 86 47  SYS....PCI0i...G
  3050: 46 58 30 69 86 47 46 58 30 0a 80 a0 0c 92 50 53  FX0i.GFX0.....PS
  3060: 54 53 70 00 43 45 56 54 a4 00 14 13 47 48 44 53  TSp.CEVT....GHDS
  3070: 01 70 68 54 49 44 58 a4 47 4e 4f 54 01 00 14 14  .phTIDX.GNOT....
  3080: 47 4c 49 44 01 70 68 43 4c 49 44 a4 47 4e 4f 54  GLID.phCLID.GNOT
  3090: 0a 02 00 14 15 47 44 43 4b 01 70 68 43 44 43 4b  .....GDCK.phCDCK
  30a0: a4 47 4e 4f 54 0a 04 0a 80 14 19 50 41 52 44 00  .GNOT......PARD.
  30b0: a0 0c 92 41 52 44 59 5b 22 41 53 4c 50 a4 92 41  ...ARDY["ASLP..A
  30c0: 52 44 59 14 4a 12 41 49 4e 54 02 a0 0e 92 7b 54  RDY.J.AINT....{T
  30d0: 43 48 45 79 01 68 00 00 a4 01 a0 07 50 41 52 44  CHEy.h......PARD
  30e0: a4 01 a0 40 0c 93 68 0a 02 a0 47 09 43 50 46 4d  ...@..h...G.CPFM
  30f0: 7b 43 50 46 4d 0a 0f 60 7b 45 50 46 4d 0a 0f 61  {CPFM..`{EPFM..a
  3100: a0 2a 93 60 01 a0 0d 7b 61 0a 06 00 70 0a 06 50  .*.`...{a...p..P
  3110: 46 49 54 a1 17 a0 0d 7b 61 0a 08 00 70 0a 08 50  FIT....{a...p..P
  3120: 46 49 54 a1 07 70 01 50 46 49 54 a0 2a 93 60 0a  FIT..p.PFIT.*.`.
  3130: 06 a0 0d 7b 61 0a 08 00 70 0a 08 50 46 49 54 a1  ...{a...p..PFIT.
  3140: 16 a0 0b 7b 61 01 00 70 01 50 46 49 54 a1 08 70  ...{a..p.PFIT..p
  3150: 0a 06 50 46 49 54 a0 2a 93 60 0a 08 a0 0b 7b 61  ..PFIT.*.`....{a
  3160: 01 00 70 01 50 46 49 54 a1 18 a0 0d 7b 61 0a 06  ..p.PFIT....{a..
  3170: 00 70 0a 06 50 46 49 54 a1 08 70 0a 08 50 46 49  .p..PFIT..p..PFI
  3180: 54 a1 0c 7f 50 46 49 54 0a 07 50 46 49 54 7d 50  T...PFIT..PFIT}P
  3190: 46 49 54 0c 00 00 00 80 50 46 49 54 70 0a 04 41  FIT.....PFITp..A
  31a0: 53 4c 43 a1 42 04 a0 28 93 68 01 70 78 77 69 0a  SLC.B..(.h.pxwi.
  31b0: ff 00 0a 64 00 00 42 43 4c 50 7d 42 43 4c 50 0c  ...d..BCLP}BCLP.
  31c0: 00 00 00 80 42 43 4c 50 70 0a 02 41 53 4c 43 a1  ....BCLPp..ASLC.
  31d0: 16 a0 10 93 68 00 70 69 41 4c 53 49 70 01 41 53  ....h.piALSIp.AS
  31e0: 4c 43 a1 03 a4 01 70 00 4c 42 50 43 a4 00 10 45  LC....p.LBPC...E
  31f0: 1f 5c 00 14 44 05 42 52 54 57 09 70 68 61 a0 20  .\..D.BRTW.pha. 
  3200: 93 41 4c 53 45 0a 02 70 78 77 41 4c 41 46 68 00  .ALSE..pxwALAFh.
  3210: 0a 64 00 00 61 a0 09 94 61 0a 64 70 0a 64 61 70  .d..a...a.dp.dap
  3220: 78 77 0a ff 61 00 0a 64 00 00 60 70 60 50 52 4d  xw..a..d..`p`PRM
  3230: 30 70 68 42 52 54 4c a0 10 93 54 52 41 50 0a 12  0phBRTL...TRAP..
  3240: 00 50 38 58 48 0a 02 60 14 45 0a 48 4b 44 53 09  .P8XH..`.E.HKDS.
  3250: a0 45 07 93 00 7b 0a 03 44 53 45 4e 00 a0 48 06  .E...{..DSEN..H.
  3260: 93 54 52 41 50 68 00 a0 4c 04 92 93 43 41 44 4c  .TRAPh..L...CADL
  3270: 50 41 44 4c 70 43 41 44 4c 50 41 44 4c a0 1e 91  PADLpCADLPADL...
  3280: 94 4f 53 59 53 0b d0 07 95 4f 53 59 53 0b d6 07  .OSYS....OSYS...
  3290: 86 5c 2e 5f 53 42 5f 50 43 49 30 00 a1 12 86 5c  .\._SB_PCI0....\
  32a0: 2f 03 5f 53 42 5f 50 43 49 30 47 46 58 30 00 5b  /._SB_PCI0GFX0.[
  32b0: 22 0b ee 02 86 5c 2f 03 5f 53 42 5f 50 43 49 30  "....\/._SB_PCI0
  32c0: 47 46 58 30 0a 80 a0 27 93 01 7b 0a 03 44 53 45  GFX0...'..{..DSE
  32d0: 4e 00 a0 1b 93 54 52 41 50 75 68 00 86 5c 2f 03  N....TRAPuh..\/.
  32e0: 5f 53 42 5f 50 43 49 30 47 46 58 30 0a 81 14 39  _SB_PCI0GFX0...9
  32f0: 4c 53 44 53 09 a0 08 68 48 4b 44 53 0a 0c a1 07  LSDS...hHKDS....
  3300: 48 4b 44 53 0a 0e a0 21 92 93 7b 0a 03 44 53 45  HKDS...!..{..DSE
  3310: 4e 00 01 5b 22 0a 32 a2 10 93 7b 0a 03 44 53 45  N..[".2...{..DSE
  3320: 4e 00 0a 02 5b 22 0a 32 14 4b 0b 42 52 54 4e 09  N...[".2.K.BRTN.
  3330: a0 23 93 7b 44 49 44 31 0b 00 0f 00 0b 00 04 86  .#.{DID1........
  3340: 5c 2f 04 5f 53 42 5f 50 43 49 30 47 46 58 30 44  \/._SB_PCI0GFX0D
  3350: 44 30 31 68 a0 23 93 7b 44 49 44 32 0b 00 0f 00  D01h.#.{DID2....
  3360: 0b 00 04 86 5c 2f 04 5f 53 42 5f 50 43 49 30 47  ....\/._SB_PCI0G
  3370: 46 58 30 44 44 30 32 68 a0 23 93 7b 44 49 44 33  FX0DD02h.#.{DID3
  3380: 0b 00 0f 00 0b 00 04 86 5c 2f 04 5f 53 42 5f 50  ........\/._SB_P
  3390: 43 49 30 47 46 58 30 44 44 30 33 68 a0 23 93 7b  CI0GFX0DD03h.#.{
  33a0: 44 49 44 34 0b 00 0f 00 0b 00 04 86 5c 2f 04 5f  DID4........\/._
  33b0: 53 42 5f 50 43 49 30 47 46 58 30 44 44 30 34 68  SB_PCI0GFX0DD04h
  33c0: a0 23 93 7b 44 49 44 35 0b 00 0f 00 0b 00 04 86  .#.{DID5........
  33d0: 5c 2f 04 5f 53 42 5f 50 43 49 30 47 46 58 30 44  \/._SB_PCI0GFX0D
  33e0: 44 30 35 68 10 48 40 5c 00 5b 80 49 4f 5f 54 01  D05h.H@\.[.IO_T.
  33f0: 0b 00 08 0a 10 5b 81 0e 49 4f 5f 54 01 00 40 04  .....[..IO_T..@.
  3400: 54 52 50 30 08 5b 80 50 4d 49 4f 01 0b 00 10 0a  TRP0.[.PMIO.....
  3410: 80 5b 81 23 50 4d 49 4f 01 00 08 50 4d 53 54 08  .[.#PMIO...PMST.
  3420: 00 40 20 00 01 47 50 45 43 01 00 4e 10 00 09 53  .@ ..GPEC..N...S
  3430: 43 49 53 01 00 06 5b 80 47 50 49 4f 01 0b 80 11  CIS...[.GPIO....
  3440: 0a 3c 5b 81 48 0c 47 50 49 4f 01 47 55 30 30 08  .<[.H.GPIO.GU00.
  3450: 47 55 30 31 08 47 55 30 32 08 47 55 30 33 08 47  GU01.GU02.GU03.G
  3460: 49 4f 30 08 47 49 4f 31 08 47 49 4f 32 08 47 49  IO0.GIO1.GIO2.GI
  3470: 4f 33 08 00 20 00 02 47 50 30 32 01 00 05 00 04  O3.. ..GP02.....
  3480: 47 50 31 32 01 00 03 00 05 47 50 32 31 01 00 02  GP12.....GP21...
  3490: 00 03 47 50 32 37 01 47 50 32 38 01 00 03 00 40  ..GP27.GP28....@
  34a0: 04 47 42 30 30 08 47 42 30 31 08 47 42 30 32 08  .GB00.GB01.GB02.
  34b0: 47 42 30 33 08 00 40 08 47 49 56 30 08 47 49 56  GB03..@.GIV0.GIV
  34c0: 31 08 47 49 56 32 08 47 49 56 33 08 47 55 30 34  1.GIV2.GIV3.GU04
  34d0: 08 47 55 30 35 08 47 55 30 36 08 47 55 30 37 08  .GU05.GU06.GU07.
  34e0: 47 49 4f 34 08 47 49 4f 35 08 47 49 4f 36 08 47  GIO4.GIO5.GIO6.G
  34f0: 49 4f 37 08 00 05 47 50 33 37 01 00 02 47 4c 30  IO7...GP37...GL0
  3500: 35 08 47 4c 30 36 08 47 4c 30 37 08 5b 80 52 43  5.GL06.GL07.[.RC
  3510: 52 42 00 0c 00 c0 d1 fe 0b 00 40 5b 81 48 05 52  RB........@[.H.R
  3520: 43 52 42 13 00 80 00 08 00 80 00 10 00 80 02 02  CRB.............
  3530: 48 50 41 53 02 00 05 48 50 41 45 01 00 48 09 00  HPAS...HPAE..H..
  3540: 01 50 41 54 44 01 53 41 54 44 01 53 4d 42 44 01  .PATD.SATD.SMBD.
  3550: 48 44 41 44 01 00 0b 52 50 31 44 01 52 50 32 44  HDAD...RP1D.RP2D
  3560: 01 52 50 33 44 01 52 50 34 44 01 52 50 35 44 01  .RP3D.RP4D.RP5D.
  3570: 52 50 36 44 01 5b 80 58 43 4d 53 01 0a 72 0a 02  RP6D.[.XCMS..r..
  3580: 5b 81 10 58 43 4d 53 01 58 49 4e 44 08 58 44 41  [..XCMS.XIND.XDA
  3590: 54 08 5b 86 2f 58 49 4e 44 58 44 41 54 01 00 40  T.[./XINDXDAT..@
  35a0: 36 43 4d 36 43 08 43 4d 36 44 08 43 4d 36 45 08  6CM6C.CM6D.CM6E.
  35b0: 43 4d 36 46 08 00 10 43 4d 37 32 08 00 18 44 45  CM6F...CM72...DE
  35c0: 54 43 08 08 42 46 45 52 00 5b 01 52 57 43 4d 00  TC..BFER.[.RWCM.
  35d0: 14 48 04 44 42 47 43 03 5b 23 52 57 43 4d ff ff  .H.DBGC.[#RWCM..
  35e0: a0 32 93 6a 0a 02 70 43 4d 36 44 42 46 45 52 a0  .2.j..pCM6DBFER.
  35f0: 1a 92 93 68 42 46 45 52 70 42 46 45 52 43 4d 36  ...hBFERpBFERCM6
  3600: 45 5b 22 01 70 68 43 4d 36 44 5b 22 01 70 69 43  E[".phCM6D[".piC
  3610: 4d 36 46 5b 27 52 57 43 4d 08 5f 53 30 5f 12 05  M6F['RWCM._S0_..
  3620: 03 00 00 00 08 5f 53 33 5f 12 07 03 0a 05 0a 05  ....._S3_.......
  3630: 00 08 5f 53 34 5f 12 07 03 0a 06 0a 06 00 08 5f  .._S4_........._
  3640: 53 35 5f 12 07 03 0a 07 0a 07 00 14 45 04 47 45  S5_.........E.GE
  3650: 54 50 09 a0 0e 93 7b 68 0a 09 00 00 a4 0c ff ff  TP....{h........
  3660: ff ff a0 0d 93 7b 68 0a 09 00 0a 08 a4 0b 84 03  .....{h.........
  3670: 7a 7b 68 0b 00 03 00 0a 08 60 7a 7b 68 0b 00 30  z{h......`z{h..0
  3680: 00 0a 0c 61 a4 77 0a 1e 74 0a 09 72 60 61 00 00  ...a.w..t..r`a..
  3690: 00 14 30 47 44 4d 41 0d a0 23 68 a0 07 90 69 6c  ..0GDMA..#h...il
  36a0: a4 0a 14 a0 0e 90 6a 6c a4 77 74 0a 04 6b 00 0a  ......jl.wt..k..
  36b0: 0f 00 a4 77 74 0a 04 6b 00 0a 1e 00 a4 0c ff ff  ...wt..k........
  36c0: ff ff 14 1f 47 45 54 54 09 a4 77 0a 1e 74 0a 09  ....GETT..w..t..
  36d0: 72 7b 7a 68 0a 02 00 0a 03 00 7b 68 0a 03 00 00  r{zh......{h....
  36e0: 00 00 14 44 06 47 45 54 46 0b 08 54 4d 50 46 00  ...D.GETF..TMPF.
  36f0: a0 0c 68 7d 54 4d 50 46 01 54 4d 50 46 a0 11 7b  ..h}TMPF.TMPF..{
  3700: 6a 0a 02 00 7d 54 4d 50 46 0a 02 54 4d 50 46 a0  j...}TMPF..TMPF.
  3710: 0d 69 7d 54 4d 50 46 0a 04 54 4d 50 46 a0 11 7b  .i}TMPF..TMPF..{
  3720: 6a 0a 20 00 7d 54 4d 50 46 0a 08 54 4d 50 46 a0  j. .}TMPF..TMPF.
  3730: 12 7b 6a 0b 00 40 00 7d 54 4d 50 46 0a 10 54 4d  .{j..@.}TMPF..TM
  3740: 50 46 a4 54 4d 50 46 14 3d 53 45 54 50 0b a0 08  PF.TMPF.=SETP...
  3750: 94 68 0a f0 a4 0a 08 a1 2d a0 27 7b 69 0a 02 00  .h......-.'{i...
  3760: a0 10 90 92 94 68 0a 78 7b 6a 0a 02 00 a4 0b 01  .....h.x{j......
  3770: 23 a0 0f 90 92 94 68 0a b4 7b 6a 01 00 a4 0b 01  #.....h..{j.....
  3780: 21 a4 0b 01 10 14 37 53 44 4d 41 09 a0 08 92 94  !.....7SDMA.....
  3790: 68 0a 14 a4 01 a0 09 92 94 68 0a 1e a4 0a 02 a0  h........h......
  37a0: 08 92 94 68 0a 2d a4 01 a0 09 92 94 68 0a 3c a4  ...h.-......h.<.
  37b0: 0a 02 a0 08 92 94 68 0a 5a a4 01 a4 00 14 2f 53  ......h.Z...../S
  37c0: 45 54 54 0b a0 25 7b 69 0a 02 00 a0 0f 90 92 94  ETT..%{i........
  37d0: 68 0a 78 7b 6a 0a 02 00 a4 0a 0b a0 0e 90 92 94  h.x{j...........
  37e0: 68 0a b4 7b 6a 01 00 a4 0a 09 a4 0a 04 5b 82 4d  h..{j........[.M
  37f0: 04 48 44 45 46 14 17 5f 41 44 52 08 44 42 47 43  .HDEF.._ADR.DBGC
  3800: 0a 64 00 42 43 45 4e a4 0c 00 00 1b 00 5b 80 48  .d.BCEN......[.H
  3810: 44 41 52 02 0a 4c 0a 10 5b 81 22 48 44 41 52 02  DAR..L..[."HDAR.
  3820: 44 43 4b 41 01 00 07 44 43 4b 4d 01 00 06 44 43  DCKA...DCKM...DC
  3830: 4b 53 01 00 30 00 0f 50 4d 45 53 01 5b 82 4b 11  KS..0..PMES.[.K.
  3840: 52 50 30 31 14 17 5f 41 44 52 08 44 42 47 43 0a  RP01.._ADR.DBGC.
  3850: 65 00 42 43 45 4e a4 0c 00 00 1c 00 5b 80 50 58  e.BCEN......[.PX
  3860: 43 53 02 0a 40 0a c0 5b 81 45 04 50 58 43 53 40  CS..@..[.E.PXCS@
  3870: 00 40 09 00 0d 4c 41 53 58 01 00 32 41 42 50 58  .@...LASX..2ABPX
  3880: 01 00 02 50 44 43 58 01 00 02 50 44 53 58 01 00  ...PDCX...PDSX..
  3890: 01 4c 53 43 58 01 00 27 00 10 50 53 50 58 01 00  .LSCX..'..PSPX..
  38a0: 4f 3c 00 1e 48 50 53 58 01 50 4d 53 58 01 5b 82  O<..HPSX.PMSX.[.
  38b0: 17 50 58 53 58 08 5f 41 44 52 00 08 5f 50 52 57  .PXSX._ADR.._PRW
  38c0: 12 06 02 0a 09 0a 03 14 41 09 5f 50 52 54 00 a0  ........A._PRT..
  38d0: 33 47 50 49 43 a4 12 2c 04 12 09 04 0b ff ff 00  3GPIC..,........
  38e0: 00 0a 10 12 09 04 0b ff ff 01 00 0a 11 12 0a 04  ................
  38f0: 0b ff ff 0a 02 00 0a 12 12 0a 04 0b ff ff 0a 03  ................
  3900: 00 0a 13 a1 45 05 a4 12 41 05 04 12 12 04 0b ff  ....E...A.......
  3910: ff 00 5e 5e 2e 4c 50 43 42 4c 4e 4b 41 00 12 12  ..^^.LPCBLNKA...
  3920: 04 0b ff ff 01 5e 5e 2e 4c 50 43 42 4c 4e 4b 42  .....^^.LPCBLNKB
  3930: 00 12 13 04 0b ff ff 0a 02 5e 5e 2e 4c 50 43 42  .........^^.LPCB
  3940: 4c 4e 4b 43 00 12 13 04 0b ff ff 0a 03 5e 5e 2e  LNKC.........^^.
  3950: 4c 50 43 42 4c 4e 4b 44 00 5b 82 47 13 52 50 30  LPCBLNKD.[.G.RP0
  3960: 32 14 17 5f 41 44 52 08 44 42 47 43 0a 65 01 42  2.._ADR.DBGC.e.B
  3970: 43 45 4e a4 0c 01 00 1c 00 5b 80 50 58 43 53 02  CEN......[.PXCS.
  3980: 0a 40 0a c0 5b 81 45 04 50 58 43 53 40 00 40 09  .@..[.E.PXCS@.@.
  3990: 00 0d 4c 41 53 58 01 00 32 41 42 50 58 01 00 02  ..LASX..2ABPX...
  39a0: 50 44 43 58 01 00 02 50 44 53 58 01 00 01 4c 53  PDCX...PDSX...LS
  39b0: 43 58 01 00 27 00 10 50 53 50 58 01 00 4f 3c 00  CX..'..PSPX..O<.
  39c0: 1e 48 50 53 58 01 50 4d 53 58 01 5b 82 17 50 58  .HPSX.PMSX.[..PX
  39d0: 53 58 08 5f 41 44 52 00 08 5f 50 52 57 12 06 02  SX._ADR.._PRW...
  39e0: 0a 09 0a 03 14 10 5f 48 50 50 00 a4 12 08 04 0a  ......_HPP......
  39f0: 10 0a 40 01 00 08 2e 50 58 53 58 5f 52 4d 56 01  ..@....PXSX_RMV.
  3a00: 14 41 09 5f 50 52 54 00 a0 33 47 50 49 43 a4 12  .A._PRT..3GPIC..
  3a10: 2c 04 12 09 04 0b ff ff 00 00 0a 11 12 09 04 0b  ,...............
  3a20: ff ff 01 00 0a 12 12 0a 04 0b ff ff 0a 02 00 0a  ................
  3a30: 13 12 0a 04 0b ff ff 0a 03 00 0a 10 a1 45 05 a4  .............E..
  3a40: 12 41 05 04 12 12 04 0b ff ff 00 5e 5e 2e 4c 50  .A.........^^.LP
  3a50: 43 42 4c 4e 4b 42 00 12 12 04 0b ff ff 01 5e 5e  CBLNKB........^^
  3a60: 2e 4c 50 43 42 4c 4e 4b 43 00 12 13 04 0b ff ff  .LPCBLNKC.......
  3a70: 0a 02 5e 5e 2e 4c 50 43 42 4c 4e 4b 44 00 12 13  ..^^.LPCBLNKD...
  3a80: 04 0b ff ff 0a 03 5e 5e 2e 4c 50 43 42 4c 4e 4b  ......^^.LPCBLNK
  3a90: 41 00 5b 82 4c 11 52 50 30 33 14 18 5f 41 44 52  A.[.L.RP03.._ADR
  3aa0: 08 44 42 47 43 0a 65 0a 02 42 43 45 4e a4 0c 02  .DBGC.e..BCEN...
  3ab0: 00 1c 00 5b 80 50 58 43 53 02 0a 40 0a c0 5b 81  ...[.PXCS..@..[.
  3ac0: 45 04 50 58 43 53 40 00 40 09 00 0d 4c 41 53 58  E.PXCS@.@...LASX
  3ad0: 01 00 32 41 42 50 58 01 00 02 50 44 43 58 01 00  ..2ABPX...PDCX..
  3ae0: 02 50 44 53 58 01 00 01 4c 53 43 58 01 00 27 00  .PDSX...LSCX..'.
  3af0: 10 50 53 50 58 01 00 4f 3c 00 1e 48 50 53 58 01  .PSPX..O<..HPSX.
  3b00: 50 4d 53 58 01 5b 82 17 50 58 53 58 08 5f 41 44  PMSX.[..PXSX._AD
  3b10: 52 00 08 5f 50 52 57 12 06 02 0a 09 0a 03 14 41  R.._PRW........A
  3b20: 09 5f 50 52 54 00 a0 33 47 50 49 43 a4 12 2c 04  ._PRT..3GPIC..,.
  3b30: 12 09 04 0b ff ff 00 00 0a 12 12 09 04 0b ff ff  ................
  3b40: 01 00 0a 13 12 0a 04 0b ff ff 0a 02 00 0a 10 12  ................
  3b50: 0a 04 0b ff ff 0a 03 00 0a 11 a1 45 05 a4 12 41  ...........E...A
  3b60: 05 04 12 12 04 0b ff ff 00 5e 5e 2e 4c 50 43 42  .........^^.LPCB
  3b70: 4c 4e 4b 43 00 12 12 04 0b ff ff 01 5e 5e 2e 4c  LNKC........^^.L
  3b80: 50 43 42 4c 4e 4b 44 00 12 13 04 0b ff ff 0a 02  PCBLNKD.........
  3b90: 5e 5e 2e 4c 50 43 42 4c 4e 4b 41 00 12 13 04 0b  ^^.LPCBLNKA.....
  3ba0: ff ff 0a 03 5e 5e 2e 4c 50 43 42 4c 4e 4b 42 00  ....^^.LPCBLNKB.
  3bb0: 5b 82 4c 11 52 50 30 35 14 18 5f 41 44 52 08 44  [.L.RP05.._ADR.D
  3bc0: 42 47 43 0a 65 0a 04 42 43 45 4e a4 0c 04 00 1c  BGC.e..BCEN.....
  3bd0: 00 5b 80 50 58 43 53 02 0a 40 0a c0 5b 81 45 04  .[.PXCS..@..[.E.
  3be0: 50 58 43 53 40 00 40 09 00 0d 4c 41 53 58 01 00  PXCS@.@...LASX..
  3bf0: 32 41 42 50 58 01 00 02 50 44 43 58 01 00 02 50  2ABPX...PDCX...P
  3c00: 44 53 58 01 00 01 4c 53 43 58 01 00 27 00 10 50  DSX...LSCX..'..P
  3c10: 53 50 58 01 00 4f 3c 00 1e 48 50 53 58 01 50 4d  SPX..O<..HPSX.PM
  3c20: 53 58 01 5b 82 17 50 58 53 58 08 5f 41 44 52 00  SX.[..PXSX._ADR.
  3c30: 08 5f 50 52 57 12 06 02 0a 09 0a 03 14 41 09 5f  ._PRW........A._
  3c40: 50 52 54 00 a0 33 47 50 49 43 a4 12 2c 04 12 09  PRT..3GPIC..,...
  3c50: 04 0b ff ff 00 00 0a 10 12 09 04 0b ff ff 01 00  ................
  3c60: 0a 11 12 0a 04 0b ff ff 0a 02 00 0a 12 12 0a 04  ................
  3c70: 0b ff ff 0a 03 00 0a 13 a1 45 05 a4 12 41 05 04  .........E...A..
  3c80: 12 12 04 0b ff ff 00 5e 5e 2e 4c 50 43 42 4c 4e  .......^^.LPCBLN
  3c90: 4b 41 00 12 12 04 0b ff ff 01 5e 5e 2e 4c 50 43  KA........^^.LPC
  3ca0: 42 4c 4e 4b 42 00 12 13 04 0b ff ff 0a 02 5e 5e  BLNKB.........^^
  3cb0: 2e 4c 50 43 42 4c 4e 4b 43 00 12 13 04 0b ff ff  .LPCBLNKC.......
  3cc0: 0a 03 5e 5e 2e 4c 50 43 42 4c 4e 4b 44 00 5b 82  ..^^.LPCBLNKD.[.
  3cd0: 4f 06 55 53 42 31 14 17 5f 41 44 52 08 44 42 47  O.USB1.._ADR.DBG
  3ce0: 43 0a 66 01 42 43 45 4e a4 0c 00 00 1d 00 5b 80  C.f.BCEN......[.
  3cf0: 55 31 43 53 02 0a c4 0a 04 5b 81 0b 55 31 43 53  U1CS.....[..U1CS
  3d00: 03 55 31 45 4e 02 08 5f 50 52 57 12 06 02 0a 03  .U1EN.._PRW.....
  3d10: 0a 03 14 18 5f 50 53 57 01 a0 09 68 70 0a 03 55  ...._PSW...hp..U
  3d20: 31 45 4e a1 07 70 00 55 31 45 4e 14 09 5f 53 33  1EN..p.U1EN.._S3
  3d30: 44 00 a4 0a 02 14 09 5f 53 34 44 00 a4 0a 02 5b  D......_S4D....[
  3d40: 82 40 07 55 53 42 32 14 18 5f 41 44 52 08 44 42  .@.USB2.._ADR.DB
  3d50: 47 43 0a 66 0a 02 42 43 45 4e a4 0c 01 00 1d 00  GC.f..BCEN......
  3d60: 5b 80 55 32 43 53 02 0a c4 0a 04 5b 81 0b 55 32  [.U2CS.....[..U2
  3d70: 43 53 03 55 32 45 4e 02 08 5f 50 52 57 12 06 02  CS.U2EN.._PRW...
  3d80: 0a 04 0a 03 14 18 5f 50 53 57 01 a0 09 68 70 0a  ......_PSW...hp.
  3d90: 03 55 32 45 4e a1 07 70 00 55 32 45 4e 14 09 5f  .U2EN..p.U2EN.._
  3da0: 53 33 44 00 a4 0a 02 14 09 5f 53 34 44 00 a4 0a  S3D......_S4D...
  3db0: 02 5b 82 40 07 55 53 42 33 14 18 5f 41 44 52 08  .[.@.USB3.._ADR.
  3dc0: 44 42 47 43 0a 66 0a 03 42 43 45 4e a4 0c 02 00  DBGC.f..BCEN....
  3dd0: 1d 00 5b 80 55 32 43 53 02 0a c4 0a 04 5b 81 0b  ..[.U2CS.....[..
  3de0: 55 32 43 53 03 55 33 45 4e 02 08 5f 50 52 57 12  U2CS.U3EN.._PRW.
  3df0: 06 02 0a 0c 0a 03 14 18 5f 50 53 57 01 a0 09 68  ........_PSW...h
  3e00: 70 0a 03 55 33 45 4e a1 07 70 00 55 33 45 4e 14  p..U3EN..p.U3EN.
  3e10: 09 5f 53 33 44 00 a4 0a 02 14 09 5f 53 34 44 00  ._S3D......_S4D.
  3e20: a4 0a 02 5b 82 40 07 55 53 42 34 14 18 5f 41 44  ...[.@.USB4.._AD
  3e30: 52 08 44 42 47 43 0a 66 0a 04 42 43 45 4e a4 0c  R.DBGC.f..BCEN..
  3e40: 00 00 1a 00 5b 80 55 34 43 53 02 0a c4 0a 04 5b  ....[.U4CS.....[
  3e50: 81 0b 55 34 43 53 03 55 34 45 4e 02 08 5f 50 52  ..U4CS.U4EN.._PR
  3e60: 57 12 06 02 0a 0e 0a 03 14 18 5f 50 53 57 01 a0  W........._PSW..
  3e70: 09 68 70 0a 03 55 34 45 4e a1 07 70 00 55 34 45  .hp..U4EN..p.U4E
  3e80: 4e 14 09 5f 53 33 44 00 a4 0a 02 14 09 5f 53 34  N.._S3D......_S4
  3e90: 44 00 a4 0a 02 5b 82 40 07 55 53 42 35 14 18 5f  D....[.@.USB5.._
  3ea0: 41 44 52 08 44 42 47 43 0a 66 0a 05 42 43 45 4e  ADR.DBGC.f..BCEN
  3eb0: a4 0c 01 00 1a 00 5b 80 55 35 43 53 02 0a c4 0a  ......[.U5CS....
  3ec0: 04 5b 81 0b 55 35 43 53 03 55 35 45 4e 02 08 5f  .[..U5CS.U5EN.._
  3ed0: 50 52 57 12 06 02 0a 05 0a 03 14 18 5f 50 53 57  PRW........._PSW
  3ee0: 01 a0 09 68 70 0a 03 55 35 45 4e a1 07 70 00 55  ...hp..U5EN..p.U
  3ef0: 35 45 4e 14 09 5f 53 33 44 00 a4 0a 02 14 09 5f  5EN.._S3D......_
  3f00: 53 34 44 00 a4 0a 02 5b 82 49 0b 45 48 43 31 14  S4D....[.I.EHC1.
  3f10: 17 5f 41 44 52 08 44 42 47 43 0a 67 01 42 43 45  ._ADR.DBGC.g.BCE
  3f20: 4e a4 0c 07 00 1d 00 5b 80 55 37 43 53 02 0a 54  N......[.U7CS..T
  3f30: 0a 04 5b 81 0d 55 37 43 53 03 00 0f 50 4d 45 53  ..[..U7CS...PMES
  3f40: 01 5b 82 4f 05 48 55 42 37 08 5f 41 44 52 00 5b  .[.O.HUB7._ADR.[
  3f50: 82 0b 50 52 54 31 08 5f 41 44 52 01 5b 82 0c 50  ..PRT1._ADR.[..P
  3f60: 52 54 32 08 5f 41 44 52 0a 02 5b 82 0c 50 52 54  RT2._ADR..[..PRT
  3f70: 33 08 5f 41 44 52 0a 03 5b 82 0c 50 52 54 34 08  3._ADR..[..PRT4.
  3f80: 5f 41 44 52 0a 04 5b 82 0c 50 52 54 35 08 5f 41  _ADR..[..PRT5._A
  3f90: 44 52 0a 05 5b 82 0c 50 52 54 36 08 5f 41 44 52  DR..[..PRT6._ADR
  3fa0: 0a 06 08 5f 50 52 57 12 06 02 0a 0d 0a 03 14 09  ..._PRW.........
  3fb0: 5f 53 33 44 00 a4 0a 02 14 09 5f 53 34 44 00 a4  _S3D......_S4D..
  3fc0: 0a 02 5b 82 4e 09 45 48 43 32 14 18 5f 41 44 52  ..[.N.EHC2.._ADR
  3fd0: 08 44 42 47 43 0a 67 0a 02 42 43 45 4e a4 0c 07  .DBGC.g..BCEN...
  3fe0: 00 1a 00 5b 80 55 46 43 53 02 0a 54 0a 04 5b 81  ...[.UFCS..T..[.
  3ff0: 0d 55 46 43 53 03 00 0f 50 4d 45 53 01 5b 82 43  .UFCS...PMES.[.C
  4000: 04 48 55 42 37 08 5f 41 44 52 00 5b 82 0b 50 52  .HUB7._ADR.[..PR
  4010: 54 31 08 5f 41 44 52 01 5b 82 0c 50 52 54 32 08  T1._ADR.[..PRT2.
  4020: 5f 41 44 52 0a 02 5b 82 0c 50 52 54 33 08 5f 41  _ADR..[..PRT3._A
  4030: 44 52 0a 03 5b 82 0c 50 52 54 34 08 5f 41 44 52  DR..[..PRT4._ADR
  4040: 0a 04 08 5f 50 52 57 12 06 02 0a 0d 0a 03 14 09  ..._PRW.........
  4050: 5f 53 33 44 00 a4 0a 02 14 09 5f 53 34 44 00 a4  _S3D......_S4D..
  4060: 0a 02 5b 82 43 2e 50 43 49 42 14 17 5f 41 44 52  ..[.C.PCIB.._ADR
  4070: 08 44 42 47 43 0a 68 00 42 43 45 4e a4 0c 00 00  .DBGC.h.BCEN....
  4080: 1e 00 5b 82 19 43 41 52 44 08 5f 41 44 52 0c 00  ..[..CARD._ADR..
  4090: 00 03 00 14 09 5f 53 54 41 00 a4 0a 0b 14 49 2a  ....._STA.....I*
  40a0: 5f 50 52 54 00 a0 47 22 00 a0 4b 0c 47 50 49 43  _PRT..G"..K.GPIC
  40b0: a4 12 43 0c 10 12 09 04 0b ff ff 00 00 0a 15 12  ..C.............
  40c0: 09 04 0b ff ff 01 00 0a 16 12 0a 04 0b ff ff 0a  ................
  40d0: 02 00 0a 17 12 0a 04 0b ff ff 0a 03 00 0a 14 12  ................
  40e0: 0b 04 0c ff ff 01 00 00 00 0a 16 12 0b 04 0c ff  ................
  40f0: ff 01 00 01 00 0a 15 12 0c 04 0c ff ff 01 00 0a  ................
  4100: 02 00 0a 14 12 0c 04 0c ff ff 01 00 0a 03 00 0a  ................
  4110: 17 12 0b 04 0c ff ff 02 00 00 00 0a 12 12 0b 04  ................
  4120: 0c ff ff 02 00 01 00 0a 13 12 0c 04 0c ff ff 02  ................
  4130: 00 0a 02 00 0a 11 12 0c 04 0c ff ff 02 00 0a 03  ................
  4140: 00 0a 10 12 0b 04 0c ff ff 05 00 00 00 0a 11 12  ................
  4150: 0b 04 0c ff ff 05 00 01 00 0a 14 12 0c 04 0c ff  ................
  4160: ff 05 00 0a 02 00 0a 16 12 0c 04 0c ff ff 05 00  ................
  4170: 0a 03 00 0a 15 a1 47 15 a4 12 43 15 10 12 12 04  ......G...C.....
  4180: 0b ff ff 00 5e 5e 2e 4c 50 43 42 4c 4e 4b 46 00  ....^^.LPCBLNKF.
  4190: 12 12 04 0b ff ff 01 5e 5e 2e 4c 50 43 42 4c 4e  .......^^.LPCBLN
  41a0: 4b 47 00 12 13 04 0b ff ff 0a 02 5e 5e 2e 4c 50  KG.........^^.LP
  41b0: 43 42 4c 4e 4b 48 00 12 13 04 0b ff ff 0a 03 5e  CBLNKH.........^
  41c0: 5e 2e 4c 50 43 42 4c 4e 4b 45 00 12 14 04 0c ff  ^.LPCBLNKE......
  41d0: ff 01 00 00 5e 5e 2e 4c 50 43 42 4c 4e 4b 47 00  ....^^.LPCBLNKG.
  41e0: 12 14 04 0c ff ff 01 00 01 5e 5e 2e 4c 50 43 42  .........^^.LPCB
  41f0: 4c 4e 4b 46 00 12 15 04 0c ff ff 01 00 0a 02 5e  LNKF...........^
  4200: 5e 2e 4c 50 43 42 4c 4e 4b 45 00 12 15 04 0c ff  ^.LPCBLNKE......
  4210: ff 01 00 0a 03 5e 5e 2e 4c 50 43 42 4c 4e 4b 48  .....^^.LPCBLNKH
  4220: 00 12 14 04 0c ff ff 02 00 00 5e 5e 2e 4c 50 43  ..........^^.LPC
  4230: 42 4c 4e 4b 43 00 12 14 04 0c ff ff 02 00 01 5e  BLNKC..........^
  4240: 5e 2e 4c 50 43 42 4c 4e 4b 44 00 12 15 04 0c ff  ^.LPCBLNKD......
  4250: ff 02 00 0a 02 5e 5e 2e 4c 50 43 42 4c 4e 4b 42  .....^^.LPCBLNKB
  4260: 00 12 15 04 0c ff ff 02 00 0a 03 5e 5e 2e 4c 50  ...........^^.LP
  4270: 43 42 4c 4e 4b 41 00 12 14 04 0c ff ff 05 00 00  CBLNKA..........
  4280: 5e 5e 2e 4c 50 43 42 4c 4e 4b 42 00 12 14 04 0c  ^^.LPCBLNKB.....
  4290: ff ff 05 00 01 5e 5e 2e 4c 50 43 42 4c 4e 4b 45  .....^^.LPCBLNKE
  42a0: 00 12 15 04 0c ff ff 05 00 0a 02 5e 5e 2e 4c 50  ...........^^.LP
  42b0: 43 42 4c 4e 4b 47 00 12 15 04 0c ff ff 05 00 0a  CBLNKG..........
  42c0: 03 5e 5e 2e 4c 50 43 42 4c 4e 4b 46 00 a1 49 07  .^^.LPCBLNKF..I.
  42d0: a0 2e 47 50 49 43 a4 12 27 03 12 0b 04 0c ff ff  ..GPIC..'.......
  42e0: 03 00 00 00 0a 10 12 0b 04 0c ff ff 03 00 01 00  ................
  42f0: 0a 11 12 0c 04 0c ff ff 03 00 0a 02 00 0a 12 a1  ................
  4300: 47 04 a4 12 43 04 03 12 14 04 0c ff ff 03 00 00  G...C...........
  4310: 5e 5e 2e 4c 50 43 42 4c 4e 4b 41 00 12 14 04 0c  ^^.LPCBLNKA.....
  4320: ff ff 03 00 01 5e 5e 2e 4c 50 43 42 4c 4e 4b 42  .....^^.LPCBLNKB
  4330: 00 12 15 04 0c ff ff 03 00 0a 02 5e 5e 2e 4c 50  ...........^^.LP
  4340: 43 42 4c 4e 4b 43 00 5b 82 8f eb 01 4c 50 43 42  CBLNKC.[....LPCB
  4350: 08 5f 41 44 52 0c 00 00 1f 00 5b 80 4c 50 43 30  ._ADR.....[.LPC0
  4360: 02 0a 40 0a c0 5b 81 40 05 4c 50 43 30 00 00 40  ..@..[.@.LPC0..@
  4370: 10 50 41 52 43 08 50 42 52 43 08 50 43 52 43 08  .PARC.PBRC.PCRC.
  4380: 50 44 52 43 08 00 20 50 45 52 43 08 50 46 52 43  PDRC.. PERC.PFRC
  4390: 08 50 47 52 43 08 50 48 52 43 08 00 40 0a 49 4f  .PGRC.PHRC..@.IO
  43a0: 44 30 08 49 4f 44 31 08 00 40 37 52 41 45 4e 01  D0.IOD1..@7RAEN.
  43b0: 00 0d 52 43 42 41 12 5b 82 41 0a 4c 4e 4b 41 08  ..RCBA.[.A.LNKA.
  43c0: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 01 14  _HID.A...._UID..
  43d0: 0d 5f 44 49 53 08 70 0a 80 50 41 52 43 08 5f 50  ._DIS.p..PARC._P
  43e0: 52 53 11 09 0a 06 23 fa d4 18 79 00 14 38 5f 43  RS....#...y..8_C
  43f0: 52 53 08 08 52 54 4c 41 11 09 0a 06 23 00 00 18  RS..RTLA....#...
  4400: 79 00 8b 52 54 4c 41 01 49 52 51 30 70 00 49 52  y..RTLA.IRQ0p.IR
  4410: 51 30 79 01 7b 50 41 52 43 0a 0f 00 49 52 51 30  Q0y.{PARC...IRQ0
  4420: a4 52 54 4c 41 14 1b 5f 53 52 53 09 8b 68 01 49  .RTLA.._SRS..h.I
  4430: 52 51 30 82 49 52 51 30 60 76 60 70 60 50 41 52  RQ0.IRQ0`v`p`PAR
  4440: 43 14 18 5f 53 54 41 08 a0 0c 7b 50 41 52 43 0a  C.._STA...{PARC.
  4450: 80 00 a4 0a 09 a1 04 a4 0a 0b 5b 82 42 0a 4c 4e  ..........[.B.LN
  4460: 4b 42 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49  KB._HID.A...._UI
  4470: 44 0a 02 14 0d 5f 44 49 53 08 70 0a 80 50 42 52  D...._DIS.p..PBR
  4480: 43 08 5f 50 52 53 11 09 0a 06 23 fa d8 18 79 00  C._PRS....#...y.
  4490: 14 38 5f 43 52 53 08 08 52 54 4c 42 11 09 0a 06  .8_CRS..RTLB....
  44a0: 23 00 00 18 79 00 8b 52 54 4c 42 01 49 52 51 30  #...y..RTLB.IRQ0
  44b0: 70 00 49 52 51 30 79 01 7b 50 42 52 43 0a 0f 00  p.IRQ0y.{PBRC...
  44c0: 49 52 51 30 a4 52 54 4c 42 14 1b 5f 53 52 53 09  IRQ0.RTLB.._SRS.
  44d0: 8b 68 01 49 52 51 30 82 49 52 51 30 60 76 60 70  .h.IRQ0.IRQ0`v`p
  44e0: 60 50 42 52 43 14 18 5f 53 54 41 08 a0 0c 7b 50  `PBRC.._STA...{P
  44f0: 42 52 43 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 5b 82  BRC...........[.
  4500: 42 0a 4c 4e 4b 43 08 5f 48 49 44 0c 41 d0 0c 0f  B.LNKC._HID.A...
  4510: 08 5f 55 49 44 0a 03 14 0d 5f 44 49 53 08 70 0a  ._UID...._DIS.p.
  4520: 80 50 43 52 43 08 5f 50 52 53 11 09 0a 06 23 fa  .PCRC._PRS....#.
  4530: d4 18 79 00 14 38 5f 43 52 53 08 08 52 54 4c 43  ..y..8_CRS..RTLC
  4540: 11 09 0a 06 23 00 00 18 79 00 8b 52 54 4c 43 01  ....#...y..RTLC.
  4550: 49 52 51 30 70 00 49 52 51 30 79 01 7b 50 43 52  IRQ0p.IRQ0y.{PCR
  4560: 43 0a 0f 00 49 52 51 30 a4 52 54 4c 43 14 1b 5f  C...IRQ0.RTLC.._
  4570: 53 52 53 09 8b 68 01 49 52 51 30 82 49 52 51 30  SRS..h.IRQ0.IRQ0
  4580: 60 76 60 70 60 50 43 52 43 14 18 5f 53 54 41 08  `v`p`PCRC.._STA.
  4590: a0 0c 7b 50 43 52 43 0a 80 00 a4 0a 09 a1 04 a4  ..{PCRC.........
  45a0: 0a 0b 5b 82 42 0a 4c 4e 4b 44 08 5f 48 49 44 0c  ..[.B.LNKD._HID.
  45b0: 41 d0 0c 0f 08 5f 55 49 44 0a 04 14 0d 5f 44 49  A...._UID...._DI
  45c0: 53 08 70 0a 80 50 44 52 43 08 5f 50 52 53 11 09  S.p..PDRC._PRS..
  45d0: 0a 06 23 fa d8 18 79 00 14 38 5f 43 52 53 08 08  ..#...y..8_CRS..
  45e0: 52 54 4c 44 11 09 0a 06 23 00 00 18 79 00 8b 52  RTLD....#...y..R
  45f0: 54 4c 44 01 49 52 51 30 70 00 49 52 51 30 79 01  TLD.IRQ0p.IRQ0y.
  4600: 7b 50 44 52 43 0a 0f 00 49 52 51 30 a4 52 54 4c  {PDRC...IRQ0.RTL
  4610: 44 14 1b 5f 53 52 53 09 8b 68 01 49 52 51 30 82  D.._SRS..h.IRQ0.
  4620: 49 52 51 30 60 76 60 70 60 50 44 52 43 14 18 5f  IRQ0`v`p`PDRC.._
  4630: 53 54 41 08 a0 0c 7b 50 44 52 43 0a 80 00 a4 0a  STA...{PDRC.....
  4640: 09 a1 04 a4 0a 0b 5b 82 42 0a 4c 4e 4b 45 08 5f  ......[.B.LNKE._
  4650: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 05 14  HID.A...._UID...
  4660: 0d 5f 44 49 53 08 70 0a 80 50 45 52 43 08 5f 50  ._DIS.p..PERC._P
  4670: 52 53 11 09 0a 06 23 fa d4 18 79 00 14 38 5f 43  RS....#...y..8_C
  4680: 52 53 08 08 52 54 4c 45 11 09 0a 06 23 00 00 18  RS..RTLE....#...
  4690: 79 00 8b 52 54 4c 45 01 49 52 51 30 70 00 49 52  y..RTLE.IRQ0p.IR
  46a0: 51 30 79 01 7b 50 45 52 43 0a 0f 00 49 52 51 30  Q0y.{PERC...IRQ0
  46b0: a4 52 54 4c 45 14 1b 5f 53 52 53 09 8b 68 01 49  .RTLE.._SRS..h.I
  46c0: 52 51 30 82 49 52 51 30 60 76 60 70 60 50 45 52  RQ0.IRQ0`v`p`PER
  46d0: 43 14 18 5f 53 54 41 08 a0 0c 7b 50 45 52 43 0a  C.._STA...{PERC.
  46e0: 80 00 a4 0a 09 a1 04 a4 0a 0b 5b 82 42 0a 4c 4e  ..........[.B.LN
  46f0: 4b 46 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49  KF._HID.A...._UI
  4700: 44 0a 06 14 0d 5f 44 49 53 08 70 0a 80 50 46 52  D...._DIS.p..PFR
  4710: 43 08 5f 50 52 53 11 09 0a 06 23 fa d8 18 79 00  C._PRS....#...y.
  4720: 14 38 5f 43 52 53 08 08 52 54 4c 46 11 09 0a 06  .8_CRS..RTLF....
  4730: 23 00 00 18 79 00 8b 52 54 4c 46 01 49 52 51 30  #...y..RTLF.IRQ0
  4740: 70 00 49 52 51 30 79 01 7b 50 46 52 43 0a 0f 00  p.IRQ0y.{PFRC...
  4750: 49 52 51 30 a4 52 54 4c 46 14 1b 5f 53 52 53 09  IRQ0.RTLF.._SRS.
  4760: 8b 68 01 49 52 51 30 82 49 52 51 30 60 76 60 70  .h.IRQ0.IRQ0`v`p
  4770: 60 50 46 52 43 14 18 5f 53 54 41 08 a0 0c 7b 50  `PFRC.._STA...{P
  4780: 46 52 43 0a 80 00 a4 0a 09 a1 04 a4 0a 0b 5b 82  FRC...........[.
  4790: 42 0a 4c 4e 4b 47 08 5f 48 49 44 0c 41 d0 0c 0f  B.LNKG._HID.A...
  47a0: 08 5f 55 49 44 0a 07 14 0d 5f 44 49 53 08 70 0a  ._UID...._DIS.p.
  47b0: 80 50 47 52 43 08 5f 50 52 53 11 09 0a 06 23 fa  .PGRC._PRS....#.
  47c0: d4 18 79 00 14 38 5f 43 52 53 08 08 52 54 4c 47  ..y..8_CRS..RTLG
  47d0: 11 09 0a 06 23 00 00 18 79 00 8b 52 54 4c 47 01  ....#...y..RTLG.
  47e0: 49 52 51 30 70 00 49 52 51 30 79 01 7b 50 47 52  IRQ0p.IRQ0y.{PGR
  47f0: 43 0a 0f 00 49 52 51 30 a4 52 54 4c 47 14 1b 5f  C...IRQ0.RTLG.._
  4800: 53 52 53 09 8b 68 01 49 52 51 30 82 49 52 51 30  SRS..h.IRQ0.IRQ0
  4810: 60 76 60 70 60 50 47 52 43 14 18 5f 53 54 41 08  `v`p`PGRC.._STA.
  4820: a0 0c 7b 50 47 52 43 0a 80 00 a4 0a 09 a1 04 a4  ..{PGRC.........
  4830: 0a 0b 5b 82 42 0a 4c 4e 4b 48 08 5f 48 49 44 0c  ..[.B.LNKH._HID.
  4840: 41 d0 0c 0f 08 5f 55 49 44 0a 08 14 0d 5f 44 49  A...._UID...._DI
  4850: 53 08 70 0a 80 50 48 52 43 08 5f 50 52 53 11 09  S.p..PHRC._PRS..
  4860: 0a 06 23 fa d8 18 79 00 14 38 5f 43 52 53 08 08  ..#...y..8_CRS..
  4870: 52 54 4c 48 11 09 0a 06 23 00 00 18 79 00 8b 52  RTLH....#...y..R
  4880: 54 4c 48 01 49 52 51 30 70 00 49 52 51 30 79 01  TLH.IRQ0p.IRQ0y.
  4890: 7b 50 48 52 43 0a 0f 00 49 52 51 30 a4 52 54 4c  {PHRC...IRQ0.RTL
  48a0: 48 14 1b 5f 53 52 53 09 8b 68 01 49 52 51 30 82  H.._SRS..h.IRQ0.
  48b0: 49 52 51 30 60 76 60 70 60 50 48 52 43 14 18 5f  IRQ0`v`p`PHRC.._
  48c0: 53 54 41 08 a0 0c 7b 50 48 52 43 0a 80 00 a4 0a  STA...{PHRC.....
  48d0: 09 a1 04 a4 0a 0b 5b 82 41 7e 45 43 5f 5f 08 5f  ......[.A~EC__._
  48e0: 48 49 44 0c 41 d0 0c 09 14 26 5f 43 52 53 00 08  HID.A....&_CRS..
  48f0: 42 46 46 52 11 15 0a 12 47 01 62 00 62 00 00 01  BFFR....G.b.b...
  4900: 47 01 66 00 66 00 00 01 79 00 a4 42 46 46 52 5b  G.f.f...y..BFFR[
  4910: 80 45 43 46 32 03 00 0a ff 5b 81 49 18 45 43 46  .ECF2....[.I.ECF
  4920: 32 11 00 03 50 52 43 50 01 00 01 4c 53 54 45 01  2...PRCP...LSTE.
  4930: 42 41 54 50 01 52 50 57 52 01 00 04 43 48 47 45  BATP.RPWR...CHGE
  4940: 01 4c 56 44 53 01 00 01 41 55 41 4d 01 45 4e 52  .LVDS...AUAM.ENR
  4950: 30 08 45 4e 52 31 08 45 53 52 30 08 45 53 52 31  0.ENR1.ESR0.ESR1
  4960: 08 42 53 54 53 08 57 4b 53 52 08 00 48 08 49 53  .BSTS.WKSR..H.IS
  4970: 49 44 08 00 30 42 54 50 4c 08 42 54 50 48 08 42  ID..0BTPL.BTPH.B
  4980: 53 4e 4c 08 42 53 4e 48 08 42 44 43 4c 08 42 44  SNL.BSNH.BDCL.BD
  4990: 43 48 08 42 44 56 4c 08 42 44 56 48 08 42 41 56  CH.BDVL.BDVH.BAV
  49a0: 4c 08 42 41 56 48 08 42 41 43 4c 08 42 41 43 48  L.BAVH.BACL.BACH
  49b0: 08 52 53 43 4c 08 52 53 43 48 08 42 52 43 4c 08  .RSCL.RSCH.BRCL.
  49c0: 42 52 43 48 08 46 43 43 4c 08 46 43 43 48 08 00  BRCH.FCCL.FCCH..
  49d0: 04 46 44 43 48 01 46 55 43 48 01 44 43 48 47 01  .FDCH.FUCH.DCHG.
  49e0: 42 54 49 54 01 42 53 54 48 08 4f 4d 46 4c 08 4f  BTIT.BSTH.OMFL.O
  49f0: 4d 46 48 08 49 42 4d 46 08 41 53 53 52 08 00 40  MFH.IBMF.ASSR..@
  4a00: 04 54 53 31 52 08 54 53 31 4c 08 54 53 32 52 08  .TS1R.TS1L.TS2R.
  4a10: 54 53 32 4c 08 54 53 33 52 08 54 53 33 4c 08 46  TS2L.TS3R.TS3L.F
  4a20: 31 46 4c 08 46 31 46 48 08 46 32 46 4c 08 46 32  1FL.F1FH.F2FL.F2
  4a30: 46 48 08 54 31 55 31 08 54 31 55 32 08 54 31 55  FH.T1U1.T1U2.T1U
  4a40: 33 08 54 31 55 34 08 54 31 55 35 08 54 31 55 36  3.T1U4.T1U5.T1U6
  4a50: 08 54 31 55 37 08 54 31 44 31 08 54 31 44 32 08  .T1U7.T1D1.T1D2.
  4a60: 54 31 44 33 08 54 31 4c 31 08 54 32 52 31 08 54  T1D3.T1L1.T2R1.T
  4a70: 32 55 31 08 54 33 4c 31 08 54 33 4c 32 08 00 38  2U1.T3L1.T3L2..8
  4a80: 53 4d 42 4e 08 53 50 54 52 08 53 53 54 53 08 53  SMBN.SPTR.SSTS.S
  4a90: 41 44 52 08 53 43 4d 44 08 53 42 46 52 40 10 53  ADR.SCMD.SBFR@.S
  4aa0: 43 4e 54 08 14 3c 5f 52 45 47 02 a0 35 90 93 68  CNT..<_REG..5..h
  4ab0: 0a 03 93 69 01 70 42 41 54 50 42 4e 55 4d 70 52  ...i.pBATPBNUMpR
  4ac0: 53 43 4c 42 30 53 43 70 52 50 57 52 50 57 52 53  SCLB0SCpRPWRPWRS
  4ad0: 86 42 41 54 30 0a 81 50 4e 4f 54 70 69 45 43 4f  .BAT0..PNOTpiECO
  4ae0: 4e 08 5f 47 50 45 0a 17 14 28 5f 51 32 31 00 50  N._GPE...(_Q21.P
  4af0: 38 58 48 00 0a 21 70 52 50 57 52 50 57 52 53 86  8XH..!pRPWRPWRS.
  4b00: 41 44 50 31 0a 81 86 42 41 54 30 0a 80 50 4e 4f  ADP1...BAT0..PNO
  4b10: 54 14 28 5f 51 32 32 00 50 38 58 48 00 0a 22 70  T.(_Q22.P8XH.."p
  4b20: 52 50 57 52 50 57 52 53 86 41 44 50 31 0a 81 86  RPWRPWRS.ADP1...
  4b30: 42 41 54 30 0a 80 50 4e 4f 54 14 26 5f 51 32 33  BAT0..PNOT.&_Q23
  4b40: 00 50 38 58 48 00 0a 23 70 52 53 43 4c 42 30 53  .P8XH..#pRSCLB0S
  4b50: 43 70 42 41 54 50 42 4e 55 4d 86 42 41 54 30 0a  CpBATPBNUM.BAT0.
  4b60: 81 14 26 5f 51 32 34 00 50 38 58 48 00 0a 24 70  ..&_Q24.P8XH..$p
  4b70: 52 53 43 4c 42 30 53 43 70 42 41 54 50 42 4e 55  RSCLB0SCpBATPBNU
  4b80: 4d 86 42 41 54 30 0a 81 14 1d 5f 51 32 35 00 50  M.BAT0...._Q25.P
  4b90: 38 58 48 00 0a 25 70 52 53 43 4c 42 30 53 43 86  8XH..%pRSCLB0SC.
  4ba0: 42 41 54 30 0a 80 14 14 5f 51 32 36 00 50 38 58  BAT0...._Q26.P8X
  4bb0: 48 00 0a 26 86 53 4e 43 5f 0a 90 14 14 5f 51 32  H..&.SNC_...._Q2
  4bc0: 37 00 50 38 58 48 00 0a 27 86 53 4e 43 5f 0a 90  7.P8XH..'.SNC_..
  4bd0: 14 4b 05 5f 51 32 38 00 50 38 58 48 00 0a 28 a0  .K._Q28.P8XH..(.
  4be0: 43 04 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32  C._OSI.Windows 2
  4bf0: 30 30 36 00 a0 1d 93 5e 5e 5e 2f 03 50 45 47 50  006....^^^/.PEGP
  4c00: 4e 47 46 58 4e 56 49 44 0b ff ff 86 47 46 58 30  NGFXNVID....GFX0
  4c10: 0a 81 a1 10 86 5e 5e 5e 2e 50 45 47 50 4e 47 46  .....^^^.PEGPNGF
  4c20: 58 0a 81 a1 08 86 53 4e 43 5f 0a 91 14 14 5f 51  X.....SNC_...._Q
  4c30: 32 39 00 50 38 58 48 00 0a 29 86 4c 49 44 30 0a  29.P8XH..).LID0.
  4c40: 80 14 14 5f 51 32 41 00 50 38 58 48 00 0a 2a 86  ..._Q2A.P8XH..*.
  4c50: 4c 49 44 30 0a 80 14 14 5f 51 32 42 00 50 38 58  LID0...._Q2B.P8X
  4c60: 48 00 0a 2b 86 53 4e 43 5f 0a 94 14 14 5f 51 32  H..+.SNC_...._Q2
  4c70: 43 00 50 38 58 48 00 0a 2c 86 53 4e 43 5f 0a 94  C.P8XH..,.SNC_..
  4c80: 14 14 5f 51 33 32 00 50 38 58 48 00 0a 32 86 50  .._Q32.P8XH..2.P
  4c90: 57 52 42 0a 80 14 2d 5f 51 33 34 00 50 38 58 48  WRB...-_Q34.P8XH
  4ca0: 00 0a 34 86 5c 2e 5f 54 5a 5f 54 5a 30 30 0a 80  ..4.\._TZ_TZ00..
  4cb0: a0 12 4d 50 45 4e 86 5c 2e 5f 54 5a 5f 54 5a 30  ..MPEN.\._TZ_TZ0
  4cc0: 31 0a 80 08 48 46 31 50 0a 81 08 48 46 31 52 01  1...HF1P...HF1R.
  4cd0: 08 48 46 35 50 0a 85 08 48 46 35 52 0a 05 08 48  .HF5P...HF5R...H
  4ce0: 46 36 50 0a 86 08 48 46 36 52 0a 06 08 48 46 37  F6P...HF6R...HF7
  4cf0: 50 0a 87 08 48 46 37 52 0a 07 08 48 46 38 50 0a  P...HF7R...HF8P.
  4d00: 88 08 48 46 38 52 0a 08 08 48 46 39 50 0a 89 08  ..HF8R...HF9P...
  4d10: 48 46 39 52 0a 09 08 48 46 41 50 0a 8a 08 48 46  HF9R...HFAP...HF
  4d20: 41 52 0a 0a 08 48 46 42 50 0a 8b 08 48 46 42 52  AR...HFBP...HFBR
  4d30: 0a 0b 08 48 46 43 50 0a 8c 08 48 46 43 52 0a 0c  ...HFCP...HFCR..
  4d40: 08 48 46 44 50 0a 8d 08 48 46 44 52 0a 0d 08 48  .HFDP...HFDR...H
  4d50: 53 31 50 0a 90 08 48 53 31 52 0a 10 08 48 53 32  S1P...HS1R...HS2
  4d60: 50 0a 91 08 48 53 32 52 0a 11 08 48 55 50 50 0a  P...HS2R...HUPP.
  4d70: 95 08 48 55 50 52 0a 15 08 48 44 57 50 0a 96 08  ..HUPR...HDWP...
  4d80: 48 44 57 52 0a 16 08 48 4d 55 50 0a 97 08 48 4d  HDWR...HMUP...HM
  4d90: 55 52 0a 17 08 48 54 52 50 0a 99 08 48 54 52 52  UR...HTRP...HTRR
  4da0: 0a 19 08 48 43 55 50 0a 9a 08 48 43 55 52 0a 1a  ...HCUP...HCUR..
  4db0: 08 48 43 44 50 0a 9b 08 48 43 44 52 0a 1b 08 48  .HCDP...HCDR...H
  4dc0: 45 4a 50 0a 9f 08 48 45 4a 52 0a 1f 08 48 41 56  EJP...HEJR...HAV
  4dd0: 50 0a a1 08 48 41 56 52 0a 21 14 1c 5f 51 35 30  P...HAVR.!.._Q50
  4de0: 00 50 38 58 48 00 0a 50 53 45 43 52 48 46 31 50  .P8XH..PSECRHF1P
  4df0: 86 53 4e 43 5f 0a 92 14 1c 5f 51 35 31 00 50 38  .SNC_...._Q51.P8
  4e00: 58 48 00 0a 51 53 45 43 52 48 46 31 52 86 53 4e  XH..QSECRHF1R.SN
  4e10: 43 5f 0a 92 14 1c 5f 51 35 38 00 50 38 58 48 00  C_...._Q58.P8XH.
  4e20: 0a 58 53 45 43 52 48 46 35 50 86 53 4e 43 5f 0a  .XSECRHF5P.SNC_.
  4e30: 92 14 1c 5f 51 35 39 00 50 38 58 48 00 0a 59 53  ..._Q59.P8XH..YS
  4e40: 45 43 52 48 46 35 52 86 53 4e 43 5f 0a 92 14 1c  ECRHF5R.SNC_....
  4e50: 5f 51 35 41 00 50 38 58 48 00 0a 5a 53 45 43 52  _Q5A.P8XH..ZSECR
  4e60: 48 46 36 50 86 53 4e 43 5f 0a 92 14 1c 5f 51 35  HF6P.SNC_...._Q5
  4e70: 42 00 50 38 58 48 00 0a 5b 53 45 43 52 48 46 36  B.P8XH..[SECRHF6
  4e80: 52 86 53 4e 43 5f 0a 92 14 1c 5f 51 35 43 00 50  R.SNC_...._Q5C.P
  4e90: 38 58 48 00 0a 5c 53 45 43 52 48 46 37 50 86 53  8XH..\SECRHF7P.S
  4ea0: 4e 43 5f 0a 92 14 1c 5f 51 35 44 00 50 38 58 48  NC_...._Q5D.P8XH
  4eb0: 00 0a 5d 53 45 43 52 48 46 37 52 86 53 4e 43 5f  ..]SECRHF7R.SNC_
  4ec0: 0a 92 14 1c 5f 51 35 45 00 50 38 58 48 00 0a 5e  ...._Q5E.P8XH..^
  4ed0: 53 45 43 52 48 46 38 50 86 53 4e 43 5f 0a 92 14  SECRHF8P.SNC_...
  4ee0: 1c 5f 51 35 46 00 50 38 58 48 00 0a 5f 53 45 43  ._Q5F.P8XH.._SEC
  4ef0: 52 48 46 38 52 86 53 4e 43 5f 0a 92 14 1c 5f 51  RHF8R.SNC_...._Q
  4f00: 36 30 00 50 38 58 48 00 0a 60 53 45 43 52 48 46  60.P8XH..`SECRHF
  4f10: 39 50 86 53 4e 43 5f 0a 92 14 1c 5f 51 36 31 00  9P.SNC_...._Q61.
  4f20: 50 38 58 48 00 0a 61 53 45 43 52 48 46 39 52 86  P8XH..aSECRHF9R.
  4f30: 53 4e 43 5f 0a 92 14 1c 5f 51 36 32 00 50 38 58  SNC_...._Q62.P8X
  4f40: 48 00 0a 62 53 45 43 52 48 46 41 50 86 53 4e 43  H..bSECRHFAP.SNC
  4f50: 5f 0a 92 14 1c 5f 51 36 33 00 50 38 58 48 00 0a  _...._Q63.P8XH..
  4f60: 63 53 45 43 52 48 46 41 52 86 53 4e 43 5f 0a 92  cSECRHFAR.SNC_..
  4f70: 14 1c 5f 51 36 34 00 50 38 58 48 00 0a 64 53 45  .._Q64.P8XH..dSE
  4f80: 43 52 48 46 42 50 86 53 4e 43 5f 0a 92 14 1c 5f  CRHFBP.SNC_...._
  4f90: 51 36 35 00 50 38 58 48 00 0a 65 53 45 43 52 48  Q65.P8XH..eSECRH
  4fa0: 46 42 52 86 53 4e 43 5f 0a 92 14 1c 5f 51 36 36  FBR.SNC_...._Q66
  4fb0: 00 50 38 58 48 00 0a 66 53 45 43 52 48 46 43 50  .P8XH..fSECRHFCP
  4fc0: 86 53 4e 43 5f 0a 92 14 1c 5f 51 36 37 00 50 38  .SNC_...._Q67.P8
  4fd0: 58 48 00 0a 67 53 45 43 52 48 46 43 52 86 53 4e  XH..gSECRHFCR.SN
  4fe0: 43 5f 0a 92 14 1c 5f 51 36 38 00 50 38 58 48 00  C_...._Q68.P8XH.
  4ff0: 0a 68 53 45 43 52 48 46 44 50 86 53 4e 43 5f 0a  .hSECRHFDP.SNC_.
  5000: 92 14 1c 5f 51 36 39 00 50 38 58 48 00 0a 69 53  ..._Q69.P8XH..iS
  5010: 45 43 52 48 46 44 52 86 53 4e 43 5f 0a 92 14 1c  ECRHFDR.SNC_....
  5020: 5f 51 37 45 00 50 38 58 48 00 0a 7e 53 45 43 52  _Q7E.P8XH..~SECR
  5030: 48 41 56 50 86 53 4e 43 5f 0a 92 14 1c 5f 51 37  HAVP.SNC_...._Q7
  5040: 46 00 50 38 58 48 00 0a 7f 53 45 43 52 48 41 56  F.P8XH...SECRHAV
  5050: 52 86 53 4e 43 5f 0a 92 14 1c 5f 51 38 32 00 50  R.SNC_...._Q82.P
  5060: 38 58 48 00 0a 82 53 45 43 52 48 53 31 50 86 53  8XH...SECRHS1P.S
  5070: 4e 43 5f 0a 92 14 1c 5f 51 38 33 00 50 38 58 48  NC_...._Q83.P8XH
  5080: 00 0a 83 53 45 43 52 48 53 31 52 86 53 4e 43 5f  ...SECRHS1R.SNC_
  5090: 0a 92 14 13 53 45 43 52 01 70 68 5e 5e 2e 53 4e  ....SECR.ph^^.SN
  50a0: 43 5f 58 45 43 52 14 12 47 45 43 52 00 a4 5e 5e  C_XECR..GECR..^^
  50b0: 2e 53 4e 43 5f 58 45 43 52 5b 82 3d 44 4d 41 43  .SNC_XECR[.=DMAC
  50c0: 08 5f 48 49 44 0c 41 d0 02 00 08 5f 43 52 53 11  ._HID.A...._CRS.
  50d0: 28 0a 25 47 01 00 00 00 00 01 20 47 01 81 00 81  (.%G...... G....
  50e0: 00 01 11 47 01 93 00 93 00 01 0d 47 01 c0 00 c0  ...G.......G....
  50f0: 00 01 20 2a 10 01 79 00 5b 82 26 46 57 48 44 08  .. *..y.[.&FWHD.
  5100: 5f 48 49 44 0c 25 d4 08 00 08 5f 43 52 53 11 11  _HID.%...._CRS..
  5110: 0a 0e 86 09 00 00 00 00 00 ff 00 00 00 01 79 00  ..............y.
  5120: 5b 82 40 0b 48 50 45 54 08 5f 48 49 44 0c 41 d0  [.@.HPET._HID.A.
  5130: 01 03 08 5f 43 49 44 0c 41 d0 0c 01 08 42 55 46  ..._CID.A....BUF
  5140: 30 11 11 0a 0e 86 09 00 00 00 00 d0 fe 00 04 00  0...............
  5150: 00 79 00 14 27 5f 53 54 41 00 a0 13 92 95 4f 53  .y..'_STA.....OS
  5160: 59 53 0b d1 07 a0 08 48 50 41 45 a4 0a 0f a1 0a  YS.....HPAE.....
  5170: a0 08 48 50 41 45 a4 0a 0b a4 00 14 46 05 5f 43  ..HPAE......F._C
  5180: 52 53 08 a0 49 04 48 50 41 45 8a 42 55 46 30 0a  RS..I.HPAE.BUF0.
  5190: 04 48 50 54 30 a0 11 93 48 50 41 53 01 70 0c 00  .HPT0...HPAS.p..
  51a0: 10 d0 fe 48 50 54 30 a0 12 93 48 50 41 53 0a 02  ...HPT0...HPAS..
  51b0: 70 0c 00 20 d0 fe 48 50 54 30 a0 12 93 48 50 41  p.. ..HPT0...HPA
  51c0: 53 0a 03 70 0c 00 30 d0 fe 48 50 54 30 a4 42 55  S..p..0..HPT0.BU
  51d0: 46 30 5b 82 45 0a 49 50 49 43 08 5f 48 49 44 0b  F0[.E.IPIC._HID.
  51e0: 41 d0 08 5f 43 52 53 11 41 09 0a 8d 47 01 20 00  A.._CRS.A...G. .
  51f0: 20 00 01 02 47 01 24 00 24 00 01 02 47 01 28 00   ...G.$.$...G.(.
  5200: 28 00 01 02 47 01 2c 00 2c 00 01 02 47 01 30 00  (...G.,.,...G.0.
  5210: 30 00 01 02 47 01 34 00 34 00 01 02 47 01 38 00  0...G.4.4...G.8.
  5220: 38 00 01 02 47 01 3c 00 3c 00 01 02 47 01 a0 00  8...G.<.<...G...
  5230: a0 00 01 02 47 01 a4 00 a4 00 01 02 47 01 a8 00  ....G.......G...
  5240: a8 00 01 02 47 01 ac 00 ac 00 01 02 47 01 b0 00  ....G.......G...
  5250: b0 00 01 02 47 01 b4 00 b4 00 01 02 47 01 b8 00  ....G.......G...
  5260: b8 00 01 02 47 01 bc 00 bc 00 01 02 47 01 d0 04  ....G.......G...
  5270: d0 04 01 02 22 04 00 79 00 5b 82 25 4d 41 54 48  ...."..y.[.%MATH
  5280: 08 5f 48 49 44 0c 41 d0 0c 04 08 5f 43 52 53 11  ._HID.A...._CRS.
  5290: 10 0a 0d 47 01 f0 00 f0 00 01 01 22 00 20 79 00  ...G.......". y.
  52a0: 5b 82 43 0a 4c 44 52 43 08 5f 48 49 44 0c 41 d0  [.C.LDRC._HID.A.
  52b0: 0c 02 08 5f 55 49 44 0a 02 08 5f 43 52 53 11 46  ..._UID..._CRS.F
  52c0: 08 0a 82 47 01 2e 00 2e 00 01 02 47 01 4e 00 4e  ...G.......G.N.N
  52d0: 00 01 02 47 01 61 00 61 00 01 01 47 01 63 00 63  ...G.a.a...G.c.c
  52e0: 00 01 01 47 01 65 00 65 00 01 01 47 01 67 00 67  ...G.e.e...G.g.g
  52f0: 00 01 01 47 01 80 00 80 00 01 01 47 01 92 00 92  ...G.......G....
  5300: 00 01 01 47 01 b2 00 b2 00 01 02 47 01 80 06 80  ...G.......G....
  5310: 06 01 20 47 01 00 08 00 08 01 10 47 01 00 10 00  .. G.......G....
  5320: 10 01 80 47 01 80 11 80 11 01 40 47 01 40 16 40  ...G......@G.@.@
  5330: 16 01 10 47 01 00 fe 00 fe 01 80 47 01 80 fe 80  ...G.......G....
  5340: fe 01 80 79 00 5b 82 25 52 54 43 5f 08 5f 48 49  ...y.[.%RTC_._HI
  5350: 44 0c 41 d0 0b 00 08 5f 43 52 53 11 10 0a 0d 47  D.A...._CRS....G
  5360: 01 70 00 70 00 01 08 22 00 01 79 00 5b 82 2d 54  .p.p..."..y.[.-T
  5370: 49 4d 52 08 5f 48 49 44 0c 41 d0 01 00 08 5f 43  IMR._HID.A...._C
  5380: 52 53 11 18 0a 15 47 01 40 00 40 00 01 04 47 01  RS....G.@.@...G.
  5390: 50 00 50 00 10 04 22 01 00 79 00 5b 82 41 e1 53  P.P..."..y.[.A.S
  53a0: 4e 43 5f 08 5f 48 49 44 0c 4d d9 50 01 14 42 06  NC_._HID.M.P..B.
  53b0: 5f 49 4e 49 00 a0 4a 05 5f 4f 53 49 0d 57 69 6e  _INI..J._OSI.Win
  53c0: 64 6f 77 73 20 32 30 30 36 00 7b 45 4e 4d 4b 0b  dows 2006.{ENMK.
  53d0: bf ff 45 4e 4d 4b 7b 53 4e 49 41 0b fd ff 53 4e  ..ENMK{SNIA...SN
  53e0: 49 41 7d 53 4e 49 41 0a 40 53 4e 49 41 a0 09 7b  IA}SNIA.@SNIA..{
  53f0: 53 59 49 44 0a 80 00 a1 0b 70 0c 00 01 4a 37 53  SYID.....p...J7S
  5400: 4e 49 34 70 44 45 54 43 60 50 48 53 42 0a e1 60  NI4pDETC`PHSB..`
  5410: 14 44 04 50 57 41 4b 00 5b 23 50 4c 4f 4b ff ff  .D.PWAK.[#PLOK..
  5420: 44 42 47 43 0a f3 0a 80 42 43 45 4e 5b 22 0a 64  DBGC....BCEN[".d
  5430: 86 5c 2e 5f 50 52 5f 43 50 55 30 0a 80 5b 22 0a  .\._PR_CPU0..[".
  5440: 64 44 42 47 43 0a f3 0a 81 42 43 45 4e 5b 27 50  dDBGC....BCEN['P
  5450: 4c 4f 4b a4 00 14 2d 47 57 44 50 00 44 42 47 43  LOK...-GWDP.DBGC
  5460: 0a f2 0a 80 42 43 45 4e 44 42 47 43 0a f2 0a 81  ....BCENDBGC....
  5470: 42 43 45 4e a4 7a 7b 50 48 53 5f 0a dd 0a 40 00  BCEN.z{PHS_...@.
  5480: 0a 06 00 08 45 56 53 30 0a 07 08 45 56 53 31 00  ....EVS0...EVS1.
  5490: 08 45 56 53 32 00 5b 01 4d 53 4e 45 00 14 44 0f  .EVS2.[.MSNE..D.
  54a0: 47 53 4e 45 01 44 42 47 43 0a f1 0a 80 42 43 45  GSNE.DBGC....BCE
  54b0: 4e 70 7a 7b 68 0c 00 00 00 ff 00 0a 18 00 61 70  Npz{h.........ap
  54c0: 7a 7b 68 0c 00 00 ff 00 00 0a 10 00 62 70 7b 68  z{h.........bp{h
  54d0: 0b ff ff 00 63 5b 23 4d 53 4e 45 ff ff 70 00 60  ....c[#MSNE..p.`
  54e0: a0 46 04 93 61 00 a0 15 93 62 00 70 7b 68 0c 00  .F..a....b.p{h..
  54f0: 00 ff ff 00 60 70 7d 60 0a 07 00 60 a0 14 93 62  ....`p}`...`...b
  5500: 01 70 7b 68 0c 00 00 ff ff 00 60 70 7d 60 00 00  .p{h......`p}`..
  5510: 60 a0 15 93 62 0a 02 70 7b 68 0c 00 00 ff ff 00  `...b..p{h......
  5520: 60 70 7d 60 00 00 60 a1 46 05 a0 4e 04 93 61 01  `p}`..`.F..N..a.
  5530: a0 17 93 62 00 70 7b 68 0c 00 00 ff ff 00 60 70  ...b.p{h......`p
  5540: 7d 60 45 56 53 30 00 60 a0 17 93 62 01 70 7b 68  }`EVS0.`...b.p{h
  5550: 0c 00 00 ff ff 00 60 70 7d 60 45 56 53 31 00 60  ......`p}`EVS1.`
  5560: a0 18 93 62 0a 02 70 7b 68 0c 00 00 ff ff 00 60  ...b..p{h......`
  5570: 70 7d 60 45 56 53 32 00 60 a1 04 70 ff 60 5b 27  p}`EVS2.`..p.`['
  5580: 4d 53 4e 45 44 42 47 43 0a f1 0a 81 42 43 45 4e  MSNEDBGC....BCEN
  5590: a4 60 14 4f 0c 53 53 4e 45 01 44 42 47 43 0a f4  .`.O.SSNE.DBGC..
  55a0: 0a 80 42 43 45 4e 70 7a 7b 68 0c 00 00 00 ff 00  ..BCENpz{h......
  55b0: 0a 18 00 61 70 7a 7b 68 0c 00 00 ff 00 00 0a 10  ...apz{h........
  55c0: 00 62 70 7b 68 0b ff ff 00 63 5b 23 4d 53 4e 45  .bp{h....c[#MSNE
  55d0: ff ff 70 00 60 a0 38 93 61 00 a0 10 93 62 00 70  ..p.`.8.a....b.p
  55e0: 7d 68 45 56 53 30 00 45 56 53 30 a0 10 93 62 01  }hEVS0.EVS0...b.
  55f0: 70 7d 68 45 56 53 31 00 45 56 53 31 a0 11 93 62  p}hEVS1.EVS1...b
  5600: 0a 02 70 7d 68 45 56 53 32 00 45 56 53 32 a1 41  ..p}hEVS2.EVS2.A
  5610: 04 a0 3e 93 61 01 a0 12 93 62 00 70 7b 45 56 53  ..>.a....b.p{EVS
  5620: 30 80 68 00 00 45 56 53 30 a0 12 93 62 01 70 7b  0.h..EVS0...b.p{
  5630: 45 56 53 31 80 68 00 00 45 56 53 31 a0 13 93 62  EVS1.h..EVS1...b
  5640: 0a 02 70 7b 45 56 53 32 80 68 00 00 45 56 53 32  ..p{EVS2.h..EVS2
  5650: 44 42 47 43 0a f4 0a 81 42 43 45 4e 5b 27 4d 53  DBGC....BCEN['MS
  5660: 4e 45 14 41 04 43 53 58 42 01 5b 23 4d 50 48 53  NE.A.CSXB.[#MPHS
  5670: ff ff 44 42 47 43 0a f5 0a 80 42 43 45 4e 70 68  ..DBGC....BCENph
  5680: 53 58 42 46 50 48 53 30 0a cc 70 53 58 42 46 60  SXBFPHS0..pSXBF`
  5690: 44 42 47 43 0a f5 0a 81 42 43 45 4e 5b 27 4d 50  DBGC....BCEN['MP
  56a0: 48 53 a4 60 14 41 08 53 4f 44 56 01 44 42 47 43  HS.`.A.SODV.DBGC
  56b0: 0a f6 0a 80 42 43 45 4e a0 0a 92 93 44 53 45 4e  ....BCEN....DSEN
  56c0: 00 a4 ff 70 68 41 4f 44 56 a0 12 92 7b 41 4f 44  ...phAODV...{AOD
  56d0: 56 43 41 44 44 00 70 01 41 4f 44 56 a0 25 92 93  VCADD.p.AODV.%..
  56e0: 43 41 44 44 50 41 44 44 70 43 41 44 44 50 41 44  CADDPADDpCADDPAD
  56f0: 44 86 50 43 49 30 00 86 50 45 47 50 00 5b 22 0b  D.PCI0..PEGP.[".
  5700: ee 02 86 47 46 58 30 0a 80 86 5e 5e 5e 2e 50 45  ...GFX0...^^^.PE
  5710: 47 50 4e 47 46 58 0a 80 44 42 47 43 0a f6 0a 81  GPNGFX..DBGC....
  5720: 42 43 45 4e a4 00 14 1a 47 44 44 49 00 70 50 48  BCEN....GDDI.pPH
  5730: 53 5f 0a c5 60 70 7b 60 0a 0f 00 43 41 44 44 a4  S_..`p{`...CADD.
  5740: 60 14 10 53 54 43 53 01 a0 04 93 68 00 a0 04 93  `..STCS....h....
  5750: 68 01 5b 01 4d 49 44 42 00 14 4b 04 52 42 4d 46  h.[.MIDB..K.RBMF
  5760: 09 5b 23 4d 49 44 42 ff ff 44 42 47 43 0a f7 0a  .[#MIDB..DBGC...
  5770: 80 42 43 45 4e 7b 68 0c 00 00 01 00 60 70 50 48  .BCEN{h.....`pPH
  5780: 53 44 0a dc 60 60 a0 0a 93 60 0a 02 5b 22 0b 88  SD..``...`..["..
  5790: 13 44 42 47 43 0a f7 0a 81 42 43 45 4e 5b 27 4d  .DBGC....BCEN['M
  57a0: 49 44 42 a4 60 14 08 52 53 42 49 09 a4 00 14 2e  IDB.`..RSBI.....
  57b0: 43 42 4d 46 09 5b 23 4d 49 44 42 ff ff 7d 7b 68  CBMF.[#MIDB..}{h
  57c0: 0c ff ff 01 00 00 0c 00 00 00 02 60 70 50 48 53  ...........`pPHS
  57d0: 44 0a dc 60 60 5b 27 4d 49 44 42 a4 00 14 20 45  D..``['MIDB... E
  57e0: 41 57 4b 09 5b 23 4d 49 44 42 ff ff 50 48 53 42  AWK.[#MIDB..PHSB
  57f0: 0a d3 00 80 68 60 5b 27 4d 49 44 42 a4 60 08 53  ....h`['MIDB.`.S
  5800: 4e 49 30 0c 53 6e 63 53 08 53 4e 49 31 0c 75 70  NI0.SncS.SNI1.up
  5810: 70 6f 08 53 4e 49 32 0c 72 74 65 64 08 53 4e 49  po.SNI2.rted.SNI
  5820: 33 0b 00 01 08 53 4e 49 34 0c 00 00 4a 37 08 53  3....SNI4...J7.S
  5830: 4e 49 41 0b b7 40 08 53 4e 44 4b 0b 00 20 08 53  NIA..@.SNDK.. .S
  5840: 4e 4e 30 0b 01 01 08 53 4e 4e 31 0b 02 01 08 53  NN0....SNN1....S
  5850: 4e 4e 32 0b 00 01 08 58 45 43 52 00 08 53 4e 4e  NN2....XECR..SNN
  5860: 34 0b 0f 01 08 53 4e 4e 35 0b 06 01 08 53 4e 4e  4....SNN5....SNN
  5870: 36 0b 13 01 08 53 4e 4e 37 0b 0a 01 08 4c 42 53  6....SNN7....LBS
  5880: 52 00 08 53 4e 4e 44 0b 0d 01 08 53 4e 4e 45 0b  R..SNND....SNNE.
  5890: 05 01 08 49 49 52 5f 0a 02 08 45 4e 4d 4b 0b e8  ...IIR_...ENMK..
  58a0: ff 08 45 4e 43 52 00 08 45 53 52 5f 00 14 4a 07  ..ENCR..ESR_..J.
  58b0: 53 4e 30 30 01 70 7b 68 0a ff 00 61 a0 09 93 61  SN00.p{h...a...a
  58c0: 00 a4 53 4e 49 30 a1 41 06 a0 09 93 61 01 a4 53  ..SNI0.A....a..S
  58d0: 4e 49 31 a1 44 05 a0 0a 93 61 0a 02 a4 53 4e 49  NI1.D....a...SNI
  58e0: 32 a1 46 04 a0 0a 93 61 0a 03 a4 53 4e 49 33 a1  2.F....a...SNI3.
  58f0: 38 a0 0a 93 61 0a 04 a4 53 4e 49 34 a1 2b a0 0d  8...a...SNI4.+..
  5900: 93 61 0a 10 70 53 4e 41 56 62 a4 62 a1 1b a0 15  .a..pSNAVb.b....
  5910: 90 92 95 61 0a 20 92 94 61 0a 2f 70 53 4e 47 4e  ...a. ..a./pSNGN
  5920: 61 62 a4 62 a1 03 a4 00 14 27 53 4e 30 31 00 70  ab.b.....'SN01.p
  5930: 50 48 53 5f 0a d6 61 7b 61 80 45 4e 4d 4b 00 61  PHS_..a{a.ENMK.a
  5940: 7b 45 4e 43 52 45 4e 4d 4b 62 7d 61 62 61 a4 61  {ENCRENMKb}aba.a
  5950: 5b 01 53 4e 4d 30 00 14 43 05 53 4e 30 32 01 70  [.SNM0..C.SN02.p
  5960: 68 61 a0 48 04 92 93 61 00 5b 23 53 4e 4d 30 ff  ha.H...a.[#SNM0.
  5970: ff 7b 61 80 45 4e 4d 4b 00 62 a0 0c 92 93 62 00  .{a.ENMK.b....b.
  5980: 50 48 53 44 0a d7 62 7b 61 45 4e 4d 4b 62 a0 16  PHSD..b{aENMKb..
  5990: 92 93 62 00 7b 45 4e 43 52 45 4e 4d 4b 63 7d 63  ..b.{ENCRENMKc}c
  59a0: 62 45 4e 43 52 5b 27 53 4e 4d 30 14 45 05 53 4e  bENCR['SNM0.E.SN
  59b0: 30 33 01 70 68 61 a0 4a 04 92 93 61 00 5b 23 53  03.pha.J...a.[#S
  59c0: 4e 4d 30 ff ff 7b 61 80 45 4e 4d 4b 00 62 a0 0c  NM0..{a.ENMK.b..
  59d0: 92 93 62 00 50 48 53 44 0a d8 61 7b 61 45 4e 4d  ..b.PHSD..a{aENM
  59e0: 4b 62 a0 18 92 93 62 00 7b 45 4e 43 52 45 4e 4d  Kb....b.{ENCRENM
  59f0: 4b 63 7b 63 80 62 00 45 4e 43 52 5b 27 53 4e 4d  Kc{c.b.ENCR['SNM
  5a00: 30 14 2c 53 4e 30 34 00 70 5e 5e 2e 45 43 5f 5f  0.,SN04.p^^.EC__
  5a10: 45 53 52 30 61 7b 61 80 45 4e 4d 4b 00 61 7b 45  ESR0a{a.ENMK.a{E
  5a20: 53 52 5f 45 4e 4d 4b 62 7d 61 62 61 a4 61 14 46  SR_ENMKb}aba.a.F
  5a30: 04 53 4e 30 35 01 70 68 61 a0 3b 92 93 61 00 7b  .SN05.pha.;..a.{
  5a40: 61 80 45 4e 4d 4b 00 62 a0 0c 92 93 62 00 50 48  a.ENMK.b....b.PH
  5a50: 53 44 0a da 61 7b 61 45 4e 4d 4b 62 a0 18 92 93  SD..a{aENMKb....
  5a60: 62 00 7b 45 53 52 5f 45 4e 4d 4b 63 7b 63 80 62  b.{ESR_ENMKc{c.b
  5a70: 00 45 53 52 5f 5b 01 53 4e 4d 31 00 08 53 4e 42  .ESR_[.SNM1..SNB
  5a80: 46 11 04 0b 10 04 5b 13 53 4e 42 46 00 0a 20 53  F.....[.SNBF.. S
  5a90: 4e 42 44 5b 13 53 4e 42 46 0a 20 0a 20 53 4e 44  NBD[.SNBF. . SND
  5aa0: 31 5b 13 53 4e 42 46 0a 40 0a 08 53 4e 42 38 5b  1[.SNBF.@..SNB8[
  5ab0: 13 53 4e 42 46 0a 10 0a 40 53 4e 44 38 14 11 53  .SNBF...@SND8..S
  5ac0: 4e 30 36 01 70 68 53 4e 42 46 a4 53 4e 43 4d 14  N06.phSNBF.SNCM.
  5ad0: 42 10 53 4e 43 4d 00 5b 23 53 4e 4d 31 ff ff 70  B.SNCM.[#SNM1..p
  5ae0: 83 88 53 4e 42 46 00 00 60 7b 60 0a 0f 60 44 42  ..SNBF..`{`..`DB
  5af0: 47 43 0a f0 60 42 43 45 4e a0 0c 93 60 00 53 4e  GC..`BCEN...`.SN
  5b00: 46 30 53 4e 42 46 a1 40 0c a0 22 93 60 01 a0 13  F0SNBF.@..".`...
  5b10: 5f 4f 53 49 0d 57 69 6e 64 6f 77 73 20 32 30 30  _OSI.Windows 200
  5b20: 36 00 a1 09 53 4e 46 31 53 4e 42 46 a1 4a 09 a0  6...SNF1SNBF.J..
  5b30: 0d 93 60 0a 02 53 4e 46 32 53 4e 42 46 a1 49 08  ..`..SNF2SNBF.I.
  5b40: a0 0d 93 60 0a 03 53 4e 46 33 53 4e 42 46 a1 48  ...`..SNF3SNBF.H
  5b50: 07 a0 0d 93 60 0a 04 53 4e 46 34 53 4e 42 46 a1  ....`..SNF4SNBF.
  5b60: 47 06 a0 0d 93 60 0a 05 53 4e 46 35 53 4e 42 46  G....`..SNF5SNBF
  5b70: a1 46 05 a0 21 93 60 0a 06 a0 1b 5f 4f 53 49 0d  .F..!.`...._OSI.
  5b80: 57 69 6e 64 6f 77 73 20 32 30 30 36 00 53 4e 46  Windows 2006.SNF
  5b90: 36 53 4e 42 46 a1 31 a0 0d 93 60 0a 07 53 4e 46  6SNBF.1...`..SNF
  5ba0: 37 53 4e 42 46 a1 21 a0 0d 93 60 0a 0c 53 4e 46  7SNBF.!...`..SNF
  5bb0: 43 53 4e 42 46 a1 11 a0 0d 93 60 0a 0e 53 4e 46  CSNBF.....`..SNF
  5bc0: 45 53 4e 42 46 a1 01 5b 27 53 4e 4d 31 a4 53 4e  ESNBF..['SNM1.SN
  5bd0: 42 46 14 18 53 4e 30 37 01 70 68 60 70 60 53 4e  BF..SN07.ph`p`SN
  5be0: 42 44 53 4e 43 4d a4 53 4e 42 44 14 44 04 53 4e  BDSNCM.SNBD.D.SN
  5bf0: 46 30 01 70 83 88 53 4e 42 46 01 00 60 a0 0e 93  F0.p..SNBF..`...
  5c00: 60 00 70 01 61 50 48 53 42 0a d0 61 a1 12 a0 0e  `.p.aPHSB..a....
  5c10: 93 60 01 70 01 61 50 48 53 42 0a d1 61 a1 01 44  .`.p.aPHSB..a..D
  5c20: 42 47 43 0a 70 0a 81 42 43 45 4e a4 53 4e 42 46  BGC.p..BCEN.SNBF
  5c30: 14 46 04 53 4e 46 31 01 70 83 88 53 4e 42 46 01  .F.SNF1.p..SNBF.
  5c40: 00 60 a0 0f 93 60 00 70 0a 02 61 50 48 53 42 0a  .`...`.p..aPHSB.
  5c50: d0 61 a1 13 a0 0f 93 60 01 70 0a 02 61 50 48 53  .a.....`.p..aPHS
  5c60: 42 0a d1 61 a1 01 44 42 47 43 0a 71 0a 81 42 43  B..a..DBGC.q..BC
  5c70: 45 4e a4 53 4e 42 46 14 4f 05 53 4e 46 32 01 70  EN.SNBF.O.SNF2.p
  5c80: 83 88 53 4e 42 46 01 00 60 a0 0f 93 60 00 70 0a  ..SNBF..`...`.p.
  5c90: 04 61 50 48 53 42 0a d0 61 a1 31 a0 0f 93 60 01  .aPHSB..a.1...`.
  5ca0: 70 0a 04 61 50 48 53 42 0a d1 61 a1 1f a0 1b 93  p..aPHSB..a.....
  5cb0: 60 0a 02 70 5e 5e 2e 45 43 5f 5f 47 45 43 52 61  `..p^^.EC__GECRa
  5cc0: 70 61 88 53 4e 42 46 00 00 a1 01 44 42 47 43 0a  pa.SNBF....DBGC.
  5cd0: 72 0a 81 42 43 45 4e 14 4e 05 53 4e 46 33 01 70  r..BCEN.N.SNF3.p
  5ce0: 83 88 53 4e 42 46 01 00 60 a0 1d 93 60 00 70 50  ..SNBF..`...`.pP
  5cf0: 48 53 5f 0a db 61 7b 61 01 61 7f 61 01 61 70 61  HS_..a{a.a.a.apa
  5d00: 88 53 4e 42 46 00 00 a1 22 a0 1e 93 60 01 70 83  .SNBF..."...`.p.
  5d10: 88 53 4e 42 46 0a 02 00 61 7b 61 01 61 7f 61 01  .SNBF...a{a.a.a.
  5d20: 61 50 48 53 42 0a ce 61 a1 01 44 42 47 43 0a 73  aPHSB..a..DBGC.s
  5d30: 0a 81 42 43 45 4e 14 4f 0d 53 4e 46 34 01 70 83  ..BCEN.O.SNF4.p.
  5d40: 88 53 4e 42 46 01 00 60 a0 18 93 60 00 70 50 48  .SNBF..`...`.pPH
  5d50: 53 5f 0a dd 61 70 7b 61 01 00 88 53 4e 42 46 00  S_..ap{a...SNBF.
  5d60: 00 a1 43 0a a0 1d 93 60 01 70 50 48 53 5f 0a dd  ..C....`.pPHS_..
  5d70: 61 7a 7b 61 0a 06 00 01 61 70 61 88 53 4e 42 46  az{a....apa.SNBF
  5d80: 00 00 a1 42 08 a0 1c 93 60 0a 02 70 83 88 53 4e  ...B....`..p..SN
  5d90: 42 46 0a 02 00 61 7b 61 0a 03 61 50 48 53 44 0a  BF...a{a..aPHSD.
  5da0: de 61 a1 42 06 a0 1f 93 60 0a 03 70 50 48 53 5f  .a.B....`..pPHS_
  5db0: 0a dd 61 7a 7b 61 0a 30 00 0a 04 61 70 61 88 53  ..az{a.0...apa.S
  5dc0: 4e 42 46 00 00 a1 3f a0 1c 93 60 0a 04 70 83 88  NBF...?...`..p..
  5dd0: 53 4e 42 46 0a 02 00 61 7b 61 0a 03 61 50 48 53  SNBF...a{a..aPHS
  5de0: 44 0a df 61 a1 20 a0 1c 93 60 0a 07 7a 7b 70 53  D..a. ...`..z{pS
  5df0: 4e 30 34 61 0a 10 00 0a 04 61 70 61 88 53 4e 42  N04a.....apa.SNB
  5e00: 46 00 00 a1 01 44 42 47 43 0a 74 0a 81 42 43 45  F....DBGC.t..BCE
  5e10: 4e a4 53 4e 42 46 14 49 04 53 4e 46 35 01 70 83  N.SNBF.I.SNF5.p.
  5e20: 88 53 4e 42 46 01 00 60 a0 29 93 60 00 70 5e 5e  .SNBF..`.).`.p^^
  5e30: 2e 45 43 5f 5f 49 53 49 44 61 a0 09 93 61 0a 02  .EC__ISIDa...a..
  5e40: 70 0a 04 61 a1 04 70 00 61 70 61 88 53 4e 42 46  p..a..p.apa.SNBF
  5e50: 00 00 a1 01 44 42 47 43 0a 75 0a 81 42 43 45 4e  ....DBGC.u..BCEN
  5e60: 14 4f 06 53 4e 46 36 01 70 83 88 53 4e 42 46 01  .O.SNF6.p..SNBF.
  5e70: 00 60 a0 0d 93 60 00 70 01 88 53 4e 42 46 00 00  .`...`.p..SNBF..
  5e80: a0 10 93 60 01 70 44 45 54 43 88 53 4e 42 46 00  ...`.pDETC.SNBF.
  5e90: 00 a0 2d 93 60 0a 02 70 83 88 53 4e 42 46 0a 02  ..-.`..p..SNBF..
  5ea0: 00 60 a0 0f 92 93 44 45 54 43 60 50 48 53 42 0a  .`....DETC`PHSB.
  5eb0: e0 60 70 44 45 54 43 60 50 48 53 42 0a e1 60 44  .`pDETC`PHSB..`D
  5ec0: 42 47 43 0a 76 0a 81 42 43 45 4e a4 53 4e 42 46  BGC.v..BCEN.SNBF
  5ed0: 14 42 04 53 4e 46 37 01 70 83 88 53 4e 42 46 01  .B.SNF7.p..SNBF.
  5ee0: 00 60 a0 30 93 60 00 5b 23 4d 50 48 53 ff ff 70  .`.0.`.[#MPHS..p
  5ef0: 53 4e 44 38 61 70 50 48 44 44 0a e2 61 53 4e 44  SND8apPHDD..aSND
  5f00: 38 44 42 47 43 0a 77 0a 81 42 43 45 4e 5b 27 4d  8DBGC.w..BCEN['M
  5f10: 50 48 53 14 46 06 53 4e 46 43 01 70 83 88 53 4e  PHS.F.SNFC.p..SN
  5f20: 42 46 01 00 60 a0 1d 93 60 00 80 47 50 32 31 61  BF..`...`..GP21a
  5f30: 7b 61 01 61 70 61 4c 42 53 52 70 61 88 53 4e 42  {a.apaLBSRpa.SNB
  5f40: 46 00 00 a1 2a a0 26 93 60 01 70 83 88 53 4e 42  F...*.&.`.p..SNB
  5f50: 46 0a 02 00 62 7b 62 01 62 70 62 4c 42 53 52 80  F...b{b.bpbLBSR.
  5f60: 62 61 7b 61 01 61 70 61 47 50 32 31 a1 01 44 42  ba{a.apaGP21..DB
  5f70: 47 43 0a 7c 0a 81 42 43 45 4e 14 43 05 53 4e 46  GC.|..BCEN.C.SNF
  5f80: 44 01 70 83 88 53 4e 42 46 01 00 60 a0 17 93 60  D.p..SNBF..`...`
  5f90: 00 70 47 50 30 32 61 7b 61 01 61 70 61 88 53 4e  .pGP02a{a.apa.SN
  5fa0: 42 46 00 00 a1 1d a0 19 93 60 01 70 83 88 53 4e  BF.......`.p..SN
  5fb0: 42 46 0a 02 00 62 7b 62 01 62 70 62 47 50 30 32  BF...b{b.bpbGP02
  5fc0: a1 01 44 42 47 43 0a 7d 0a 81 42 43 45 4e 14 44  ..DBGC.}..BCEN.D
  5fd0: 07 53 4e 46 45 01 70 83 88 53 4e 42 46 01 00 60  .SNFE.p..SNBF..`
  5fe0: a0 28 93 60 00 70 50 48 53 5f 0a c7 61 7b 61 0a  .(.`.pPHS_..a{a.
  5ff0: ff 61 a0 08 93 61 0a fe 70 01 61 a1 04 70 00 61  .a...a..p.a..p.a
  6000: 70 61 88 53 4e 42 46 00 00 a1 2d a0 29 93 60 01  pa.SNBF...-.).`.
  6010: 70 83 88 53 4e 42 46 0a 02 00 62 7b 62 01 62 a0  p..SNBF...b{b.b.
  6020: 08 93 62 00 70 0a a0 63 a1 05 70 0a a1 63 50 48  ..b.p..c..p..cPH
  6030: 53 42 0a c8 63 a1 01 44 42 47 43 0a 7e 0a 81 42  SB..c..DBGC.~..B
  6040: 43 45 4e 14 4a 09 53 4e 46 46 01 70 83 88 53 4e  CEN.J.SNFF.p..SN
  6050: 42 46 01 00 60 a0 24 93 60 00 70 50 48 53 44 0a  BF..`.$.`.pPHSD.
  6060: c9 0a ff 61 a0 0a 93 61 00 70 00 53 4e 42 44 a1  ...a...a.p.SNBD.
  6070: 0a 70 49 49 52 5f 53 4e 42 44 a1 47 05 a0 42 05  .pIIR_SNBD.G..B.
  6080: 93 60 01 70 83 88 53 4e 42 46 0a 02 00 62 a0 41  .`.p..SNBF...b.A
  6090: 04 93 62 01 5b 23 4d 50 48 53 ff ff 70 50 48 53  ..b.[#MPHS..pPHS
  60a0: 44 0a c9 00 61 70 61 53 4e 42 44 70 50 48 53 44  D...apaSNBDpPHSD
  60b0: 0a c9 01 61 70 61 53 4e 44 31 70 50 48 53 44 0a  ...apaSND1pPHSD.
  60c0: c9 0a 02 61 70 61 53 4e 42 38 5b 27 4d 50 48 53  ...apaSNB8['MPHS
  60d0: a1 01 44 42 47 43 0a 7f 0a 81 42 43 45 4e 14 27  ..DBGC....BCEN.'
  60e0: 53 4e 41 56 00 70 50 48 53 5f 0a d2 60 a0 08 60  SNAV.pPHS_..`..`
  60f0: 70 53 4e 49 41 61 a1 0d 7b 53 4e 49 41 80 53 4e  pSNIAa..{SNIA.SN
  6100: 44 4b 00 61 a4 61 14 47 0a 53 4e 47 4e 01 70 7b  DK.a.a.G.SNGN.p{
  6110: 68 0a 0f 00 61 a0 09 93 61 00 a4 53 4e 4e 30 a1  h...a...a..SNN0.
  6120: 4e 08 a0 1f 93 61 01 a0 15 5f 4f 53 49 0d 57 69  N....a..._OSI.Wi
  6130: 6e 64 6f 77 73 20 32 30 30 36 00 a4 00 a4 53 4e  ndows 2006....SN
  6140: 4e 31 a1 4b 06 a0 0a 93 61 0a 02 a4 53 4e 4e 32  N1.K....a...SNN2
  6150: a1 4d 05 a0 0a 93 61 0a 04 a4 53 4e 4e 34 a1 4f  .M....a...SNN4.O
  6160: 04 a0 0a 93 61 0a 05 a4 53 4e 4e 35 a1 41 04 a0  ....a...SNN5.A..
  6170: 20 93 61 0a 06 a0 18 5f 4f 53 49 0d 57 69 6e 64   .a...._OSI.Wind
  6180: 6f 77 73 20 32 30 30 36 00 a4 53 4e 4e 36 a4 00  ows 2006..SNN6..
  6190: a1 1d a0 0a 93 61 0a 07 a4 53 4e 4e 37 a1 10 a0  .....a...SNN7...
  61a0: 0a 93 61 0a 0e a4 53 4e 4e 45 a1 03 a4 00 5b 82  ..a...SNNE....[.
  61b0: 2e 50 53 32 4b 08 5f 48 49 44 0c 41 d0 03 03 08  .PS2K._HID.A....
  61c0: 5f 43 52 53 11 19 0a 16 47 01 60 00 60 00 01 01  _CRS....G.`.`...
  61d0: 47 01 64 00 64 00 01 01 23 02 00 01 79 00 5b 82  G.d.d...#...y.[.
  61e0: 28 50 53 32 4d 08 5f 48 49 44 0c 4d d9 90 01 08  (PS2M._HID.M....
  61f0: 5f 43 49 44 0c 41 d0 0f 13 08 5f 43 52 53 11 09  _CID.A...._CRS..
  6200: 0a 06 23 00 10 01 79 00 5b 82 4a 6b 50 41 54 41  ..#...y.[.JkPATA
  6210: 14 17 5f 41 44 52 08 44 42 47 43 0a 69 01 42 43  .._ADR.DBGC.i.BC
  6220: 45 4e a4 0c 01 00 1f 00 5b 80 50 41 43 53 02 0a  EN......[.PACS..
  6230: 40 0a c0 5b 81 49 04 50 41 43 53 03 50 52 49 54  @..[.I.PACS.PRIT
  6240: 10 00 10 50 53 49 54 04 00 1c 53 59 4e 43 04 00  ...PSIT...SYNC..
  6250: 0c 53 44 54 30 02 00 02 53 44 54 31 02 00 4a 04  .SDT0...SDT1..J.
  6260: 49 43 52 30 04 49 43 52 31 04 49 43 52 32 04 49  ICR0.ICR1.ICR2.I
  6270: 43 52 33 04 49 43 52 34 04 49 43 52 35 04 5b 82  CR3.ICR4.ICR5.[.
  6280: 44 64 50 52 49 44 08 5f 41 44 52 00 14 40 17 5f  DdPRID._ADR..@._
  6290: 47 54 4d 00 08 50 42 55 46 11 17 0a 14 00 00 00  GTM..PBUF.......
  62a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  62b0: 00 8a 50 42 55 46 00 50 49 4f 30 8a 50 42 55 46  ..PBUF.PIO0.PBUF
  62c0: 0a 04 44 4d 41 30 8a 50 42 55 46 0a 08 50 49 4f  ..DMA0.PBUF..PIO
  62d0: 31 8a 50 42 55 46 0a 0c 44 4d 41 31 8a 50 42 55  1.PBUF..DMA1.PBU
  62e0: 46 0a 10 46 4c 41 47 70 47 45 54 50 50 52 49 54  F..FLAGpGETPPRIT
  62f0: 50 49 4f 30 70 47 44 4d 41 7b 53 59 4e 43 01 00  PIO0pGDMA{SYNC..
  6300: 7b 49 43 52 33 01 00 7b 49 43 52 30 01 00 53 44  {ICR3..{ICR0..SD
  6310: 54 30 7b 49 43 52 31 01 00 44 4d 41 30 a0 14 93  T0{ICR1..DMA0...
  6320: 44 4d 41 30 0c ff ff ff ff 70 50 49 4f 30 44 4d  DMA0.....pPIO0DM
  6330: 41 30 a0 2e 7b 50 52 49 54 0b 00 40 00 a0 14 93  A0..{PRIT..@....
  6340: 7b 50 52 49 54 0a 90 00 0a 80 70 0b 84 03 50 49  {PRIT.....p...PI
  6350: 4f 31 a1 0e 70 47 45 54 54 50 53 49 54 50 49 4f  O1..pGETTPSITPIO
  6360: 31 a1 0b 70 0c ff ff ff ff 50 49 4f 31 70 47 44  1..p.....PIO1pGD
  6370: 4d 41 7b 53 59 4e 43 0a 02 00 7b 49 43 52 33 0a  MA{SYNC...{ICR3.
  6380: 02 00 7b 49 43 52 30 0a 02 00 53 44 54 31 7b 49  ..{ICR0...SDT1{I
  6390: 43 52 31 0a 02 00 44 4d 41 31 a0 14 93 44 4d 41  CR1...DMA1...DMA
  63a0: 31 0c ff ff ff ff 70 50 49 4f 31 44 4d 41 31 70  1.....pPIO1DMA1p
  63b0: 47 45 54 46 7b 53 59 4e 43 01 00 7b 53 59 4e 43  GETF{SYNC..{SYNC
  63c0: 0a 02 00 50 52 49 54 46 4c 41 47 a0 2c 7b 93 50  ...PRITFLAG.,{.P
  63d0: 49 4f 30 0c ff ff ff ff 93 44 4d 41 30 0c ff ff  IO0......DMA0...
  63e0: ff ff 00 70 0a 78 50 49 4f 30 70 0a 14 44 4d 41  ...p.xPIO0p..DMA
  63f0: 30 70 0a 03 46 4c 41 47 a4 50 42 55 46 14 4c 2a  0p..FLAG.PBUF.L*
  6400: 5f 53 54 4d 03 8a 68 00 50 49 4f 30 8a 68 0a 04  _STM..h.PIO0.h..
  6410: 44 4d 41 30 8a 68 0a 08 50 49 4f 31 8a 68 0a 0c  DMA0.h..PIO1.h..
  6420: 44 4d 41 31 8a 68 0a 10 46 4c 41 47 a0 41 12 93  DMA1.h..FLAG.A..
  6430: 87 69 0b 00 02 7b 50 52 49 54 0b f0 c0 50 52 49  .i...{PRIT...PRI
  6440: 54 7b 53 59 4e 43 0a 02 53 59 4e 43 70 00 53 44  T{SYNC..SYNCp.SD
  6450: 54 30 7b 49 43 52 30 0a 02 49 43 52 30 7b 49 43  T0{ICR0..ICR0{IC
  6460: 52 31 0a 02 49 43 52 31 7b 49 43 52 33 0a 02 49  R1..ICR1{ICR3..I
  6470: 43 52 33 7b 49 43 52 35 0a 02 49 43 52 35 8b 69  CR3{ICR5..ICR5.i
  6480: 0a 62 57 34 39 30 8b 69 0a 6a 57 35 33 30 8b 69  .bW490.i.jW530.i
  6490: 0a 7e 57 36 33 30 8b 69 0a 80 57 36 34 30 8b 69  .~W630.i..W640.i
  64a0: 0a b0 57 38 38 30 8b 69 0a ba 57 39 33 30 7d 50  ..W880.i..W930}P
  64b0: 52 49 54 0b 04 80 50 52 49 54 a0 1e 90 7b 46 4c  RIT...PRIT...{FL
  64c0: 41 47 0a 02 00 7b 57 34 39 30 0b 00 08 00 7d 50  AG...{W490....}P
  64d0: 52 49 54 0a 02 50 52 49 54 7d 50 52 49 54 53 45  RIT..PRIT}PRITSE
  64e0: 54 50 50 49 4f 30 57 35 33 30 57 36 34 30 50 52  TPPIO0W530W640PR
  64f0: 49 54 a0 4b 05 7b 46 4c 41 47 01 00 7d 53 59 4e  IT.K.{FLAG..}SYN
  6500: 43 01 53 59 4e 43 70 53 44 4d 41 44 4d 41 30 53  C.SYNCpSDMADMA0S
  6510: 44 54 30 a0 12 95 44 4d 41 30 0a 1e 7d 49 43 52  DT0...DMA0..}ICR
  6520: 33 01 49 43 52 33 a0 12 95 44 4d 41 30 0a 3c 7d  3.ICR3...DMA0.<}
  6530: 49 43 52 30 01 49 43 52 30 a0 14 7b 57 39 33 30  ICR0.ICR0..{W930
  6540: 0b 00 20 00 7d 49 43 52 31 01 49 43 52 31 a0 4b  .. .}ICR1.ICR1.K
  6550: 15 93 87 6a 0b 00 02 7b 50 52 49 54 0b 0f bf 50  ...j...{PRIT...P
  6560: 52 49 54 70 00 50 53 49 54 7b 53 59 4e 43 01 53  RITp.PSIT{SYNC.S
  6570: 59 4e 43 70 00 53 44 54 31 7b 49 43 52 30 01 49  YNCp.SDT1{ICR0.I
  6580: 43 52 30 7b 49 43 52 31 01 49 43 52 31 7b 49 43  CR0{ICR1.ICR1{IC
  6590: 52 33 01 49 43 52 33 7b 49 43 52 35 01 49 43 52  R3.ICR3{ICR5.ICR
  65a0: 35 8b 6a 0a 62 57 34 39 31 8b 6a 0a 6a 57 35 33  5.j.bW491.j.jW53
  65b0: 31 8b 6a 0a 7e 57 36 33 31 8b 6a 0a 80 57 36 34  1.j.~W631.j..W64
  65c0: 31 8b 6a 0a b0 57 38 38 31 8b 6a 0a ba 57 39 33  1.j..W881.j..W93
  65d0: 31 7d 50 52 49 54 0b 40 80 50 52 49 54 a0 1e 90  1}PRIT.@.PRIT...
  65e0: 7b 46 4c 41 47 0a 08 00 7b 57 34 39 31 0b 00 08  {FLAG...{W491...
  65f0: 00 7d 50 52 49 54 0a 20 50 52 49 54 a0 4c 04 7b  .}PRIT. PRIT.L.{
  6600: 46 4c 41 47 0a 10 00 7d 50 52 49 54 0b 00 40 50  FLAG...}PRIT..@P
  6610: 52 49 54 a0 13 94 50 49 4f 31 0a f0 7d 50 52 49  RIT...PIO1..}PRI
  6620: 54 0a 80 50 52 49 54 a1 21 7d 50 52 49 54 0a 10  T..PRIT.!}PRIT..
  6630: 50 52 49 54 70 53 45 54 54 50 49 4f 31 57 35 33  PRITpSETTPIO1W53
  6640: 31 57 36 34 31 50 53 49 54 a0 40 06 7b 46 4c 41  1W641PSIT.@.{FLA
  6650: 47 0a 04 00 7d 53 59 4e 43 0a 02 53 59 4e 43 70  G...}SYNC..SYNCp
  6660: 53 44 4d 41 44 4d 41 31 53 44 54 31 a0 13 95 44  SDMADMA1SDT1...D
  6670: 4d 41 31 0a 1e 7d 49 43 52 33 0a 02 49 43 52 33  MA1..}ICR3..ICR3
  6680: a0 13 95 44 4d 41 31 0a 3c 7d 49 43 52 30 0a 02  ...DMA1.<}ICR0..
  6690: 49 43 52 30 a0 15 7b 57 39 33 31 0b 00 20 00 7d  ICR0..{W931.. .}
  66a0: 49 43 52 31 0a 02 49 43 52 31 5b 82 40 11 50 5f  ICR1..ICR1[.@.P_
  66b0: 44 30 08 5f 41 44 52 00 14 08 5f 52 4d 56 00 a4  D0._ADR..._RMV..
  66c0: 00 14 4a 0f 5f 47 54 46 00 08 50 49 42 30 11 11  ..J._GTF..PIB0..
  66d0: 0a 0e 03 00 00 00 00 a0 ef 03 00 00 00 00 a0 ef  ................
  66e0: 8c 50 49 42 30 01 50 4d 44 30 8c 50 49 42 30 0a  .PIB0.PMD0.PIB0.
  66f0: 08 44 4d 44 30 a0 40 06 7b 50 52 49 54 0a 02 00  .DMD0.@.{PRIT...
  6700: a0 13 93 7b 50 52 49 54 0a 09 00 0a 08 70 0a 08  ...{PRIT.....p..
  6710: 50 4d 44 30 a1 41 04 70 0a 0a 50 4d 44 30 7a 7b  PMD0.A.p..PMD0z{
  6720: 50 52 49 54 0b 00 03 00 0a 08 60 7a 7b 50 52 49  PRIT......`z{PRI
  6730: 54 0b 00 30 00 0a 0c 61 72 60 61 62 a0 0c 93 0a  T..0...ar`ab....
  6740: 03 62 70 0a 0b 50 4d 44 30 a0 0c 93 0a 05 62 70  .bp..PMD0.....bp
  6750: 0a 0c 50 4d 44 30 a1 07 70 01 50 4d 44 30 a0 43  ..PMD0..p.PMD0.C
  6760: 04 7b 53 59 4e 43 01 00 70 7d 53 44 54 30 0a 40  .{SYNC..p}SDT0.@
  6770: 00 44 4d 44 30 a0 2c 7b 49 43 52 31 01 00 a0 13  .DMD0.,{ICR1....
  6780: 7b 49 43 52 30 01 00 72 44 4d 44 30 0a 02 44 4d  {ICR0..rDMD0..DM
  6790: 44 30 a0 0f 7b 49 43 52 33 01 00 70 0a 45 44 4d  D0..{ICR3..p.EDM
  67a0: 44 30 a1 14 7d 74 7b 50 4d 44 30 0a 07 00 0a 02  D0..}t{PMD0.....
  67b0: 00 0a 20 44 4d 44 30 a4 50 49 42 30 5b 82 46 10  .. DMD0.PIB0[.F.
  67c0: 50 5f 44 31 08 5f 41 44 52 01 14 49 0f 5f 47 54  P_D1._ADR..I._GT
  67d0: 46 00 08 50 49 42 31 11 11 0a 0e 03 00 00 00 00  F..PIB1.........
  67e0: b0 ef 03 00 00 00 00 b0 ef 8c 50 49 42 31 01 50  ..........PIB1.P
  67f0: 4d 44 31 8c 50 49 42 31 0a 08 44 4d 44 31 a0 4b  MD1.PIB1..DMD1.K
  6800: 05 7b 50 52 49 54 0a 20 00 a0 13 93 7b 50 52 49  .{PRIT. ....{PRI
  6810: 54 0a 90 00 0a 80 70 0a 08 50 4d 44 31 a1 3c 72  T.....p..PMD1.<r
  6820: 7b 50 53 49 54 0a 03 00 7a 7b 50 53 49 54 0a 0c  {PSIT...z{PSIT..
  6830: 00 0a 02 00 60 a0 0c 93 0a 05 60 70 0a 0c 50 4d  ....`.....`p..PM
  6840: 44 31 a1 17 a0 0c 93 0a 03 60 70 0a 0b 50 4d 44  D1.......`p..PMD
  6850: 31 a1 08 70 0a 0a 50 4d 44 31 a1 07 70 01 50 4d  1..p..PMD1..p.PM
  6860: 44 31 a0 47 04 7b 53 59 4e 43 0a 02 00 70 7d 53  D1.G.{SYNC...p}S
  6870: 44 54 31 0a 40 00 44 4d 44 31 a0 2f 7b 49 43 52  DT1.@.DMD1./{ICR
  6880: 31 0a 02 00 a0 14 7b 49 43 52 30 0a 02 00 72 44  1.....{ICR0...rD
  6890: 4d 44 31 0a 02 44 4d 44 31 a0 10 7b 49 43 52 33  MD1..DMD1..{ICR3
  68a0: 0a 02 00 70 0a 45 44 4d 44 31 a1 14 7d 74 7b 50  ...p.EDMD1..}t{P
  68b0: 4d 44 31 0a 07 00 0a 02 00 0a 20 44 4d 44 31 a4  MD1....... DMD1.
  68c0: 50 49 42 31 5b 82 43 09 53 41 54 41 14 18 5f 41  PIB1[.C.SATA.._A
  68d0: 44 52 08 44 42 47 43 0a 69 0a 02 42 43 45 4e a4  DR.DBGC.i..BCEN.
  68e0: 0c 02 00 1f 00 5b 80 53 41 43 53 02 0a 40 0a c0  .....[.SACS..@..
  68f0: 5b 81 47 06 53 41 43 53 03 50 52 49 54 10 53 45  [.G.SACS.PRIT.SE
  6900: 43 54 10 50 53 49 54 04 53 53 49 54 04 00 18 53  CT.PSIT.SSIT...S
  6910: 59 4e 43 04 00 0c 53 44 54 30 02 00 02 53 44 54  YNC...SDT0...SDT
  6920: 31 02 00 02 53 44 54 32 02 00 02 53 44 54 33 02  1...SDT2...SDT3.
  6930: 00 42 04 49 43 52 30 04 49 43 52 31 04 49 43 52  .B.ICR0.ICR1.ICR
  6940: 32 04 49 43 52 33 04 49 43 52 34 04 49 43 52 35  2.ICR3.ICR4.ICR5
  6950: 04 00 48 1c 4d 41 50 56 02 5b 82 1e 53 42 55 53  ..H.MAPV.[..SBUS
  6960: 14 18 5f 41 44 52 08 44 42 47 43 0a 69 0a 03 42  .._ADR.DBGC.i..B
  6970: 43 45 4e a4 0c 03 00 1f 00                       CEN......

FACS @ 0x7f6e2fc0
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x7f6dfc04
  0000: 46 41 43 50 f4 00 00 00 03 ba 53 6f 6e 79 00 00  FACP......Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 01 00 00 00 c0 2f 6e 7f 17 92 6d 7f 00 02 09 00  ...../n...m.....
  0030: b2 00 00 00 f0 f1 00 80 00 10 00 00 00 00 00 00  ................
  0040: 04 10 00 00 00 00 00 00 20 10 00 00 08 10 00 00  ........ .......
  0050: 28 10 00 00 00 00 00 00 04 02 01 04 08 00 00 85  (...............
  0060: 01 00 23 00 00 00 00 00 01 03 0d 00 32 12 00 00  ..#.........2...
  0070: b5 04 00 00 01 08 00 00 64 00 00 00 00 00 00 00  ........d.......
  0080: fe 00 00 00 c0 2f 6e 7f 00 00 00 00 17 92 6d 7f  ...../n.......m.
  0090: 00 00 00 00 01 20 00 00 00 10 00 00 00 00 00 00  ..... ..........
  00a0: 00 00 00 00 00 00 00 00 00 00 00 00 01 10 00 00  ................
  00b0: 04 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  00c0: 00 00 00 00 01 08 00 00 20 10 00 00 00 00 00 00  ........ .......
  00d0: 01 20 00 00 08 10 00 00 00 00 00 00 01 40 00 00  . ...........@..
  00e0: 28 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00  (...............
  00f0: 00 00 00 00                                      ....

APIC @ 0x7f6dfcf8
  0000: 41 50 49 43 68 00 00 00 01 ed 53 6f 6e 79 00 00  APICh.....Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 5a 00 00 00 00 00 e0 fe 01 00 00 00 00 08 00 00  Z...............
  0030: 01 00 00 00 00 08 01 01 01 00 00 00 01 0c 01 00  ................
  0040: 00 00 c0 fe 00 00 00 00 02 0a 00 00 02 00 00 00  ................
  0050: 00 00 02 0a 00 09 09 00 00 00 0d 00 04 06 00 05  ................
  0060: 00 01 04 06 01 05 00 01                          ........

HPET @ 0x7f6dfd60
  0000: 48 50 45 54 38 00 00 00 01 2b 53 6f 6e 79 00 00  HPET8....+Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 5a 00 00 00 01 a2 86 80 00 00 00 00 00 00 d0 fe  Z...............
  0030: 00 00 00 00 00 80 00 00                          ........

MCFG @ 0x7f6dfd98
  0000: 4d 43 46 47 3c 00 00 00 01 53 53 6f 6e 79 00 00  MCFG<....SSony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 5a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e0  Z...............
  0030: 00 00 00 00 00 00 00 ff 00 00 00 00              ............

SLIC @ 0x7f6dfdd4
  0000: 53 4c 49 43 76 01 00 00 01 31 53 6f 6e 79 00 00  SLICv....1Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 00 00 00 01 00 00 00 00 9c 00 00 00 06 02 00 00  ................
  0030: 00 24 00 00 52 53 41 31 00 04 00 00 01 00 01 00  .$..RSA1........
  0040: 4b eb 56 ed 28 72 08 42 dd 9b 0f ec 9e 7d 7d 34  K.V.(r.B.....}}4
  0050: f6 c3 26 63 4d 87 e7 51 c5 ec ae fd de 28 f1 65  ..&cM..Q.....(.e
  0060: 85 c0 79 af 71 e7 ac a9 06 09 cc 7a a6 85 6d fd  ..y.q......z..m.
  0070: e0 f8 61 60 ff c1 54 19 e9 7a fb 78 0e c6 72 5e  ..a`..T..z.x..r^
  0080: cb bf e6 75 6e 1e 8a fc db 8d f8 d1 01 e9 c1 bf  ...un...........
  0090: 6f e9 95 31 5a f5 4e d7 16 b7 6a 46 0c 84 a5 ae  o..1Z.N...jF....
  00a0: d6 ad 3b 4e 55 24 94 9a 7d 33 55 ae 88 38 1b 9e  ..;NU$..}3U..8..
  00b0: 13 a0 9d 24 fb 4e fe ac a0 ec 02 42 a4 24 bd c8  ...$.N.....B.$..
  00c0: 01 00 00 00 b6 00 00 00 00 00 02 00 53 6f 6e 79  ............Sony
  00d0: 00 00 56 41 49 4f 00 00 00 00 57 49 4e 44 4f 57  ..VAIO....WINDOW
  00e0: 53 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00  S ..............
  00f0: 00 00 00 00 00 00 95 86 66 d6 b7 c4 ea 89 9c 1e  ........f.......
  0100: e6 27 c8 0a 65 fe d0 9e e1 2c c7 33 2b 3d 49 3c  .'..e....,.3+=I<
  0110: 2e 05 c2 7e f9 55 01 81 80 8d 3e 2f d2 63 61 93  ...~.U....>/.ca.
  0120: 17 67 f5 17 e4 39 a3 ef 07 7d fc 9b a1 aa 62 cb  .g...9...}....b.
  0130: db 16 79 50 f2 c2 85 f2 46 0a 28 ab 97 95 4b 7d  ..yP....F.(...K}
  0140: c6 0f fe 73 82 cc dc 7c f2 a3 82 35 ba eb ca 33  ...s...|...5...3
  0150: 9c 87 2a 6c fb 6a be aa 19 9b 06 a2 01 c2 86 a3  ..*l.j..........
  0160: f6 30 ca 5d f2 f2 12 6f 00 5e 82 08 f9 6b 4a 48  .0.]...o.^...kJH
  0170: 6f e2 56 7c ad 2a                                o.V|.*

TMOR @ 0x7f6dff4a
  0000: 54 4d 4f 52 26 00 00 00 01 93 53 6f 6e 79 00 00  TMOR&.....Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 03 00 00 00 f3 f4                                ......

APIC @ 0x7f6dff70
  0000: 41 50 49 43 68 00 00 00 01 41 53 6f 6e 79 00 00  APICh....ASony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 00 00 00 00 00 00 e0 fe 01 00 00 00 00 08 00 00  ................
  0030: 01 00 00 00 00 08 01 01 01 00 00 00 01 0c 02 00  ................
  0040: 00 00 c0 fe 00 00 00 00 04 06 00 05 00 01 04 06  ................
  0050: 01 05 00 01 02 0a 00 00 02 00 00 00 05 00 02 0a  ................
  0060: 00 09 09 00 00 00 0d 00                          ........

BOOT @ 0x7f6dffd8
  0000: 42 4f 4f 54 28 00 00 00 01 52 53 6f 6e 79 00 00  BOOT(....RSony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 01 00 00 00 36 00 00 00                          ....6...

SSDT @ 0x7f6d90fa
  0000: 53 53 44 54 1d 01 00 00 01 ee 53 6f 6e 79 00 00  SSDT......Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 10 48 0f 5c 2f 03 5f 53 42 5f 50 43  $.. .H.\/._SB_PC
  0030: 49 30 53 41 54 41 5b 82 45 0e 50 52 54 30 08 5f  I0SATA[.E.PRT0._
  0040: 41 44 52 0b ff ff 14 4d 0b 5f 53 44 44 01 5c 44  ADR....M._SDD.\D
  0050: 42 47 43 0a b8 0a 80 42 43 45 4e 08 47 42 55 30  BGC....BCEN.GBU0
  0060: 11 11 0a 0e 00 00 00 00 00 a0 00 00 00 00 00 00  ................
  0070: a0 f5 8c 47 42 55 30 0a 00 47 42 30 30 8c 47 42  ...GBU0..GB00.GB
  0080: 55 30 0a 01 47 42 30 31 8c 47 42 55 30 0a 02 47  U0..GB01.GBU0..G
  0090: 42 30 32 8c 47 42 55 30 0a 03 47 42 30 33 8c 47  B02.GBU0..GB03.G
  00a0: 42 55 30 0a 04 47 42 30 34 8c 47 42 55 30 0a 05  BU0..GB04.GBU0..
  00b0: 47 42 30 35 8c 47 42 55 30 0a 06 47 42 30 36 a0  GB05.GBU0..GB06.
  00c0: 2e 93 87 68 0b 00 02 8b 68 0a 9c 57 37 38 30 a0  ...h....h..W780.
  00d0: 1e 7b 57 37 38 30 0a 08 00 70 0a 90 47 42 30 30  .{W780...p..GB00
  00e0: 70 0a 03 47 42 30 31 70 0a ef 47 42 30 36 5c 44  p..GB01p..GB06\D
  00f0: 42 47 43 0a b8 0a 81 42 43 45 4e 70 47 42 55 30  BGC....BCENpGBU0
  0100: 47 54 46 30 14 18 5f 47 54 46 00 5c 44 42 47 43  GTF0.._GTF.\DBGC
  0110: 0a b9 0a 80 42 43 45 4e a4 47 54 46 30           ....BCEN.GTF0

SSDT @ 0x7f6d8fd7
  0000: 53 53 44 54 23 01 00 00 01 d2 53 6f 6e 79 00 00  SSDT#.....Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 10 4e 0f 5c 2f 04 5f 53 42 5f 50 43  $.. .N.\/._SB_PC
  0030: 49 30 47 46 58 30 44 44 30 33 08 52 54 4c 31 11  I0GFX0DD03.RTL1.
  0040: 0c 0a 09 14 18 1d 24 2c 35 3f 4c 64 08 49 43 4c  ......$,5?Ld.ICL
  0050: 31 12 18 0b 0a 64 0a 64 0a 04 0a 10 0a 1c 0a 28  1....d.d.......(
  0060: 0a 34 0a 40 0a 4c 0a 58 0a 64 14 0b 5f 42 43 4c  .4.@.L.X.d.._BCL
  0070: 00 a4 49 43 4c 31 14 47 09 5f 42 43 4d 01 78 74  ..ICL1.G._BCM.xt
  0080: 68 0a 04 00 0a 0c 00 60 08 5f 54 5f 30 00 70 99  h......`._T_0.p.
  0090: 50 4e 49 44 00 5f 54 5f 30 a0 12 93 5f 54 5f 30  PNID._T_0..._T_0
  00a0: 0a 01 70 83 88 52 54 4c 31 60 00 60 a1 4b 04 a0  ..p..RTL1`.`.K..
  00b0: 12 93 5f 54 5f 30 0a 02 70 83 88 52 54 4c 31 60  .._T_0..p..RTL1`
  00c0: 00 60 a1 35 a0 12 93 5f 54 5f 30 0a 04 70 83 88  .`.5..._T_0..p..
  00d0: 52 54 4c 31 60 00 60 a1 20 a0 12 93 5f 54 5f 30  RTL1`.`. ..._T_0
  00e0: 0a 05 70 83 88 52 54 4c 31 60 00 60 a1 0b 70 83  ..p..RTL1`.`..p.
  00f0: 88 52 54 4c 31 60 00 60 70 60 42 52 54 4c 70 60  .RTL1`.`p`BRTLp`
  0100: 43 42 4c 56 41 49 4e 54 0a 01 42 52 54 4c 14 14  CBLVAINT..BRTL..
  0110: 5f 42 51 43 00 78 42 52 54 4c 0a 0a 60 61 a4 42  _BQC.xBRTL..`a.B
  0120: 52 54 4c                                         RTL

SSDT @ 0x7f6d8482
  0000: 53 53 44 54 87 02 00 00 01 f7 53 6f 6e 79 00 00  SSDT......Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 10 42 26 5c 2e 5f 50 52 5f 43 50 55  $.. .B&\._PR_CPU
  0030: 30 08 5f 54 50 43 0a 00 14 4a 07 5f 50 54 43 00  0._TPC...J._PTC.
  0040: 5c 44 42 47 43 0a c5 0a c0 42 43 45 4e a0 37 7b  \DBGC....BCEN.7{
  0050: 50 44 43 30 0a 04 00 a4 12 2c 02 11 14 0a 11 82  PDC0.....,......
  0060: 0c 00 7f 00 00 00 00 00 00 00 00 00 00 00 79 00  ..............y.
  0070: 11 14 0a 11 82 0c 00 7f 00 00 00 00 00 00 00 00  ................
  0080: 00 00 00 79 00 a4 12 2c 02 11 14 0a 11 82 0c 00  ...y...,........
  0090: 01 04 01 00 10 10 00 00 00 00 00 00 79 00 11 14  ............y...
  00a0: 0a 11 82 0c 00 01 04 01 00 10 10 00 00 00 00 00  ................
  00b0: 00 79 00 08 54 53 53 49 12 41 07 08 12 0d 05 0a  .y..TSSI.A......
  00c0: 64 0b e8 03 0a 00 0a 00 0a 00 12 0d 05 0a 58 0b  d.............X.
  00d0: 6b 03 0a 00 0a 0f 0a 00 12 0d 05 0a 4b 0b ee 02  k...........K...
  00e0: 0a 00 0a 0e 0a 00 12 0d 05 0a 3f 0b 71 02 0a 00  ..........?.q...
  00f0: 0a 0d 0a 00 12 0d 05 0a 32 0b f4 01 0a 00 0a 0c  ........2.......
  0100: 0a 00 12 0d 05 0a 26 0b 77 01 0a 00 0a 0b 0a 00  ......&.w.......
  0110: 12 0c 05 0a 19 0a fa 0a 00 0a 0a 0a 00 12 0c 05  ................
  0120: 0a 0d 0a 7d 0a 00 0a 09 0a 00 08 54 53 53 4d 12  ...}.......TSSM.
  0130: 41 07 08 12 0d 05 0a 64 0b e8 03 0a 00 0a 00 0a  A......d........
  0140: 00 12 0d 05 0a 58 0b 6b 03 0a 00 0a 1e 0a 00 12  .....X.k........
  0150: 0d 05 0a 4b 0b ee 02 0a 00 0a 1c 0a 00 12 0d 05  ...K............
  0160: 0a 3f 0b 71 02 0a 00 0a 1a 0a 00 12 0d 05 0a 32  .?.q...........2
  0170: 0b f4 01 0a 00 0a 18 0a 00 12 0d 05 0a 26 0b 77  .............&.w
  0180: 01 0a 00 0a 16 0a 00 12 0c 05 0a 19 0a fa 0a 00  ................
  0190: 0a 14 0a 00 12 0c 05 0a 0d 0a 7d 0a 00 0a 12 0a  ..........}.....
  01a0: 00 08 54 53 53 46 0a 00 14 40 09 5f 54 53 53 00  ..TSSF...@._TSS.
  01b0: 5c 44 42 47 43 0a c6 0a c0 42 43 45 4e a0 47 06  \DBGC....BCEN.G.
  01c0: 90 92 54 53 53 46 5b 12 5f 50 53 53 00 70 5f 50  ..TSSF[._PSS.p_P
  01d0: 53 53 60 70 87 60 61 76 61 70 83 88 83 88 60 61  SS`p.`avap....`a
  01e0: 00 0a 01 00 62 70 0a 00 63 a2 35 95 63 87 54 53  ....bp..c.5.c.TS
  01f0: 53 49 70 78 77 62 74 0a 08 63 00 00 0a 08 00 00  SIpxwbt..c......
  0200: 64 70 64 88 83 88 54 53 53 49 63 00 0a 01 00 70  dpd...TSSIc....p
  0210: 64 88 83 88 54 53 53 4d 63 00 0a 01 00 75 63 70  d...TSSMc....ucp
  0220: ff 54 53 53 46 a0 0e 7b 50 44 43 30 0a 04 00 a4  .TSSF..{PDC0....
  0230: 54 53 53 4d a4 54 53 53 49 14 4d 04 5f 54 53 44  TSSM.TSSI.M._TSD
  0240: 00 5c 44 42 47 43 0a c7 0a c0 42 43 45 4e a0 27  .\DBGC....BCEN.'
  0250: 90 7b 43 46 47 44 0c 00 00 00 01 00 92 7b 50 44  .{CFGD.......{PD
  0260: 43 30 0a 04 00 a4 12 0f 01 12 0c 05 0a 05 0a 00  C0..............
  0270: 0a 00 0a fd 0a 02 a4 12 0f 01 12 0c 05 0a 05 0a  ................
  0280: 00 0a 00 0a fc 0a 01                             .......

SSDT @ 0x7f6d83ce
  0000: 53 53 44 54 b4 00 00 00 01 da 53 6f 6e 79 00 00  SSDT......Sony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 10 4f 08 5c 2e 5f 50 52 5f 43 50 55  $.. .O.\._PR_CPU
  0030: 31 08 5f 54 50 43 0a 00 14 16 5f 50 54 43 00 a4  1._TPC...._PTC..
  0040: 5c 2f 03 5f 50 52 5f 43 50 55 30 5f 50 54 43 14  \/._PR_CPU0_PTC.
  0050: 16 5f 54 53 53 00 a4 5c 2f 03 5f 50 52 5f 43 50  ._TSS..\/._PR_CP
  0060: 55 30 5f 54 53 53 14 4d 04 5f 54 53 44 00 5c 44  U0_TSS.M._TSD.\D
  0070: 42 47 43 0a c7 0a c1 42 43 45 4e a0 27 90 7b 43  BGC....BCEN.'.{C
  0080: 46 47 44 0c 00 00 00 01 00 92 7b 50 44 43 31 0a  FGD.......{PDC1.
  0090: 04 00 a4 12 0f 01 12 0c 05 0a 05 0a 00 0a 00 0a  ................
  00a0: fd 0a 02 a4 12 0f 01 12 0c 05 0a 05 0a 00 0a 01  ................
  00b0: 0a fc 0a 01                                      ....

SSDT @ 0x7f6d7e9a
  0000: 53 53 44 54 34 05 00 00 01 4c 53 6f 6e 79 00 00  SSDT4....LSony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 24 06 05 20 10 45 08 5c 00 08 53 53 44 54 12 43  $.. .E.\..SSDT.C
  0030: 05 0c 0d 43 50 55 30 49 53 54 20 00 0c 52 8c 6d  ...CPU0IST ..R.m
  0040: 7f 0c a1 02 00 00 0d 43 50 55 31 49 53 54 20 00  .......CPU1IST .
  0050: 0c f3 8e 6d 7f 0c e4 00 00 00 0d 43 50 55 30 43  ...m.......CPU0C
  0060: 53 54 20 00 0c 09 87 6d 7f 0c b7 04 00 00 0d 43  ST ....m.......C
  0070: 50 55 31 43 53 54 20 00 0c c0 8b 6d 7f 0c 92 00  PU1CST ....m....
  0080: 00 00 08 43 46 47 44 0c f7 69 3f 11 08 5c 50 44  ...CFGD..i?..\PD
  0090: 43 30 0c 00 00 00 80 08 5c 50 44 43 31 0c 00 00  C0......\PDC1...
  00a0: 00 80 08 5c 53 44 54 4c 0a 00 10 44 24 5c 2e 5f  ...\SDTL...D$\._
  00b0: 50 52 5f 43 50 55 30 08 48 49 30 5f 0a 00 08 48  PR_CPU0.HI0_...H
  00c0: 43 30 5f 0a 00 14 42 08 5f 50 44 43 01 5c 44 42  C0_...B._PDC.\DB
  00d0: 47 43 0a c8 0a 80 42 43 45 4e 8a 68 0a 00 52 45  GC....BCEN.h..RE
  00e0: 56 53 8a 68 0a 04 53 49 5a 45 70 87 68 60 70 74  VS.h..SIZEp.h`pt
  00f0: 60 0a 08 00 61 5b 13 68 0a 40 77 61 0a 08 00 54  `...a[.h.@wa...T
  0100: 45 4d 50 08 53 54 53 30 11 07 0a 04 00 00 00 00  EMP.STS0........
  0110: 73 53 54 53 30 54 45 4d 50 62 5f 4f 53 43 11 13  sSTS0TEMPb_OSC..
  0120: 0a 10 16 a6 77 40 0c 29 be 47 9e bd d8 70 58 71  ....w@.).G...pXq
  0130: 39 53 52 45 56 53 53 49 5a 45 62 5c 44 42 47 43  9SREVSSIZEb\DBGC
  0140: 0a c8 0a 81 42 43 45 4e 14 46 1a 5f 4f 53 43 04  ....BCEN.F._OSC.
  0150: 5c 44 42 47 43 0a cc 0a c0 42 43 45 4e 8a 6b 0a  \DBGC....BCEN.k.
  0160: 00 53 54 53 30 8a 6b 0a 04 43 41 50 30 8a 68 0a  .STS0.k..CAP0.h.
  0170: 00 49 49 44 30 8a 68 0a 04 49 49 44 31 8a 68 0a  .IID0.h..IID1.h.
  0180: 08 49 49 44 32 8a 68 0a 0c 49 49 44 33 08 55 49  .IID2.h..IID3.UI
  0190: 44 30 11 13 0a 10 16 a6 77 40 0c 29 be 47 9e bd  D0......w@.).G..
  01a0: d8 70 58 71 39 53 8a 55 49 44 30 0a 00 45 49 44  .pXq9S.UID0..EID
  01b0: 30 8a 55 49 44 30 0a 04 45 49 44 31 8a 55 49 44  0.UID0..EID1.UID
  01c0: 30 0a 08 45 49 44 32 8a 55 49 44 30 0a 0c 45 49  0..EID2.UID0..EI
  01d0: 44 33 a0 32 92 90 90 93 49 49 44 30 45 49 44 30  D3.2....IID0EID0
  01e0: 93 49 49 44 31 45 49 44 31 90 93 49 49 44 32 45  .IID1EID1..IID2E
  01f0: 49 44 32 93 49 49 44 33 45 49 44 33 70 0a 06 53  ID2.IID3EID3p..S
  0200: 54 53 30 a4 6b a0 0f 92 93 69 0a 01 70 0a 0a 53  TS0.k....i..p..S
  0210: 54 53 30 a4 6b 7d 7b 50 44 43 30 0c ff ff ff 7f  TS0.k}{PDC0.....
  0220: 00 43 41 50 30 50 44 43 30 70 7b 50 44 43 30 0a  .CAP0PDC0p{PDC0.
  0230: ff 00 50 43 50 30 a0 4c 05 7b 43 46 47 44 0a 01  ..PCP0.L.{CFGD..
  0240: 00 a0 41 05 90 90 7b 43 46 47 44 0c 00 00 00 01  ..A...{CFGD.....
  0250: 00 93 7b 50 44 43 30 0a 09 00 0a 09 92 7b 53 44  ..{PDC0......{SD
  0260: 54 4c 0a 01 00 7d 53 44 54 4c 0a 01 53 44 54 4c  TL...}SDTL..SDTL
  0270: 5b 80 49 53 54 30 00 83 88 53 53 44 54 0a 01 00  [.IST0...SSDT...
  0280: 83 88 53 53 44 54 0a 02 00 5b 20 49 53 54 30 48  ..SSDT...[ IST0H
  0290: 49 30 5f a0 49 05 7b 43 46 47 44 0a f0 00 a0 4e  I0_.I.{CFGD....N
  02a0: 04 90 90 7b 43 46 47 44 0c 00 00 00 01 00 7b 50  ...{CFGD......{P
  02b0: 44 43 30 0a 18 00 92 7b 53 44 54 4c 0a 02 00 7d  DC0....{SDTL...}
  02c0: 53 44 54 4c 0a 02 53 44 54 4c 5b 80 43 53 54 30  SDTL..SDTL[.CST0
  02d0: 00 83 88 53 53 44 54 0a 07 00 83 88 53 53 44 54  ...SSDT.....SSDT
  02e0: 0a 08 00 5b 20 43 53 54 30 48 43 30 5f a4 6b 10  ...[ CST0HC0_.k.
  02f0: 44 24 5c 2e 5f 50 52 5f 43 50 55 31 08 48 49 31  D$\._PR_CPU1.HI1
  0300: 5f 0a 00 08 48 43 31 5f 0a 00 14 42 08 5f 50 44  _...HC1_...B._PD
  0310: 43 01 5c 44 42 47 43 0a c9 0a 80 42 43 45 4e 8a  C.\DBGC....BCEN.
  0320: 68 0a 00 52 45 56 53 8a 68 0a 04 53 49 5a 45 70  h..REVS.h..SIZEp
  0330: 87 68 60 70 74 60 0a 08 00 61 5b 13 68 0a 40 77  .h`pt`...a[.h.@w
  0340: 61 0a 08 00 54 45 4d 50 08 53 54 53 31 11 07 0a  a...TEMP.STS1...
  0350: 04 00 00 00 00 73 53 54 53 31 54 45 4d 50 62 5f  .....sSTS1TEMPb_
  0360: 4f 53 43 11 13 0a 10 16 a6 77 40 0c 29 be 47 9e  OSC......w@.).G.
  0370: bd d8 70 58 71 39 53 52 45 56 53 53 49 5a 45 62  ..pXq9SREVSSIZEb
  0380: 5c 44 42 47 43 0a c9 0a 81 42 43 45 4e 14 46 1a  \DBGC....BCEN.F.
  0390: 5f 4f 53 43 04 5c 44 42 47 43 0a cc 0a c1 42 43  _OSC.\DBGC....BC
  03a0: 45 4e 8a 6b 0a 00 53 54 53 31 8a 6b 0a 04 43 41  EN.k..STS1.k..CA
  03b0: 50 31 8a 68 0a 00 49 49 44 30 8a 68 0a 04 49 49  P1.h..IID0.h..II
  03c0: 44 31 8a 68 0a 08 49 49 44 32 8a 68 0a 0c 49 49  D1.h..IID2.h..II
  03d0: 44 33 08 55 49 44 31 11 13 0a 10 16 a6 77 40 0c  D3.UID1......w@.
  03e0: 29 be 47 9e bd d8 70 58 71 39 53 8a 55 49 44 31  ).G...pXq9S.UID1
  03f0: 0a 00 45 49 44 30 8a 55 49 44 31 0a 04 45 49 44  ..EID0.UID1..EID
  0400: 31 8a 55 49 44 31 0a 08 45 49 44 32 8a 55 49 44  1.UID1..EID2.UID
  0410: 31 0a 0c 45 49 44 33 a0 32 92 90 90 93 49 49 44  1..EID3.2....IID
  0420: 30 45 49 44 30 93 49 49 44 31 45 49 44 31 90 93  0EID0.IID1EID1..
  0430: 49 49 44 32 45 49 44 32 93 49 49 44 33 45 49 44  IID2EID2.IID3EID
  0440: 33 70 0a 06 53 54 53 31 a4 6b a0 0f 92 93 69 0a  3p..STS1.k....i.
  0450: 01 70 0a 0a 53 54 53 31 a4 6b 7d 7b 50 44 43 31  .p..STS1.k}{PDC1
  0460: 0c ff ff ff 7f 00 43 41 50 31 50 44 43 31 70 7b  ......CAP1PDC1p{
  0470: 50 44 43 31 0a ff 00 50 43 50 31 a0 4c 05 7b 43  PDC1...PCP1.L.{C
  0480: 46 47 44 0a 01 00 a0 41 05 90 90 7b 43 46 47 44  FGD....A...{CFGD
  0490: 0c 00 00 00 01 00 93 7b 50 44 43 31 0a 09 00 0a  .......{PDC1....
  04a0: 09 92 7b 53 44 54 4c 0a 10 00 7d 53 44 54 4c 0a  ..{SDTL...}SDTL.
  04b0: 10 53 44 54 4c 5b 80 49 53 54 31 00 83 88 53 53  .SDTL[.IST1...SS
  04c0: 44 54 0a 04 00 83 88 53 53 44 54 0a 05 00 5b 20  DT.....SSDT...[ 
  04d0: 49 53 54 31 48 49 31 5f a0 49 05 7b 43 46 47 44  IST1HI1_.I.{CFGD
  04e0: 0a f0 00 a0 4e 04 90 90 7b 43 46 47 44 0c 00 00  ....N...{CFGD...
  04f0: 00 01 00 7b 50 44 43 31 0a 18 00 92 7b 53 44 54  ...{PDC1....{SDT
  0500: 4c 0a 20 00 7d 53 44 54 4c 0a 20 53 44 54 4c 5b  L. .}SDTL. SDTL[
  0510: 80 43 53 54 31 00 83 88 53 53 44 54 0a 0a 00 83  .CST1...SSDT....
  0520: 88 53 53 44 54 0a 0b 00 5b 20 43 53 54 31 48 43  .SSDT...[ CST1HC
  0530: 31 5f a4 6b                                      1_.k

XSDT @ 0x7f6d7e0e
  0000: 58 53 44 54 8c 00 00 00 01 75 53 6f 6e 79 00 00  XSDT.....uSony..
  0010: 56 41 49 4f 00 00 00 00 04 07 07 20 50 54 4c 20  VAIO....... PTL 
  0020: 00 00 00 00 04 fc 6d 7f 00 00 00 00 f8 fc 6d 7f  ......m.......m.
  0030: 00 00 00 00 60 fd 6d 7f 00 00 00 00 98 fd 6d 7f  ....`.m.......m.
  0040: 00 00 00 00 d4 fd 6d 7f 00 00 00 00 4a ff 6d 7f  ......m.....J.m.
  0050: 00 00 00 00 70 ff 6d 7f 00 00 00 00 d8 ff 6d 7f  ....p.m.......m.
  0060: 00 00 00 00 fa 90 6d 7f 00 00 00 00 d7 8f 6d 7f  ......m.......m.
  0070: 00 00 00 00 82 84 6d 7f 00 00 00 00 ce 83 6d 7f  ......m.......m.
  0080: 00 00 00 00 9a 7e 6d 7f 00 00 00 00              .....~m.....

RSD PTR @ 0xf8060
  0000: 52 53 44 20 50 54 52 20 18 50 54 4c 54 44 20 02  RSD PTR .PTLTD .
  0010: b6 7d 6d 7f 24 00 00 00 0e 7e 6d 7f 00 00 00 00  .}m.$....~m.....
  0020: 64 00 00 00                                      d...


--------------040309060100050903030900--
