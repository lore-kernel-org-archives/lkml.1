Return-Path: <linux-kernel-owner+w=401wt.eu-S1764255AbXF1DU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764255AbXF1DU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759398AbXF1DUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:20:16 -0400
Received: from smtp1.Stanford.EDU ([171.67.22.28]:36740 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbXF1DUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:20:10 -0400
Subject: 2.6.21.5-rt17 on lenovo t61, some BUG's (lukewarm IQ?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU
Content-Type: multipart/mixed; boundary="=-kXdnviw8C/baCa3i89sm"
Date: Wed, 27 Jun 2007 20:20:02 -0700
Message-Id: <1183000802.4085.5.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kXdnviw8C/baCa3i89sm
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Ingo, this is happening in a brand new laptop, a Lenovo t61 with a
7700 processor and the Santa Rosa chipset. 

Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bee7>] __synchronize_sched+0x35/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bf09>] __synchronize_sched+0x57/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================

I'm attaching the full output of dmesg FYI, let me know if you need
something else to make sense of this. 

[BTW, I tried to unsuccessfully boot rt18 today in one of my CCRMA
machines but the boot hung when trying to start the acpi daemon - this
was on FC6, I'll try to find out more tomorrow. We are seeing some hungs
with rt17 that I have not tried to diagnose yet]

-- Fernando


--=-kXdnviw8C/baCa3i89sm
Content-Disposition: attachment; filename=dmesg.1
Content-Type: text/plain; name=dmesg.1; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Linux version 2.6.21-0182.rt17.1.fc7.ccrmart (machbuild@planetforge.stanford.edu) (gcc version 4.1.2 20070502 (Red Hat 4.1.2-12)) #1 SMP PREEMPT RT Tue Jun 19 16:21:25 EDT 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009d800 end: 000000000009d800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009d800 size: 0000000000002800 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000d2000 size: 0000000000002000 end: 00000000000d4000 type: 2
copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007d5b0000 end: 000000007d6b0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007d6b0000 size: 000000000001d000 end: 000000007d6cd000 type: 3
copy_e820_map() start: 000000007d6cd000 size: 0000000000033000 end: 000000007d700000 type: 4
copy_e820_map() start: 000000007d700000 size: 0000000000900000 end: 000000007e000000 type: 2
copy_e820_map() start: 00000000f0000000 size: 0000000004000000 end: 00000000f4000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000000010000 end: 00000000fec10000 type: 2
copy_e820_map() start: 00000000fed00000 size: 0000000000000400 end: 00000000fed00400 type: 2
copy_e820_map() start: 00000000fed14000 size: 0000000000006000 end: 00000000fed1a000 type: 2
copy_e820_map() start: 00000000fed1c000 size: 0000000000074000 end: 00000000fed90000 type: 2
copy_e820_map() start: 00000000fee00000 size: 0000000000001000 end: 00000000fee01000 type: 2
copy_e820_map() start: 00000000ff000000 size: 0000000001000000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d2000 - 00000000000d4000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007d6b0000 (usable)
 BIOS-e820: 000000007d6b0000 - 000000007d6cd000 (ACPI data)
 BIOS-e820: 000000007d6cd000 - 000000007d700000 (ACPI NVS)
 BIOS-e820: 000000007d700000 - 000000007e000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
1110MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f6900
Entering add_active_range(0, 0, 513712) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   513712
early_node_map[1] active PFN ranges
    0:        0 ->   513712
On node 0 totalpages: 513712
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4040 pages, LIFO batch:0
  Normal zone: 3080 pages used for memmap
  Normal zone: 222200 pages, LIFO batch:31
  HighMem zone: 3887 pages used for memmap
  HighMem zone: 280449 pages, LIFO batch:31
DMI present.
Using APIC driver default
ACPI: RSDP 000F68D0, 0024 (r2 LENOVO)
ACPI: XSDT 7D6BDFB8, 009C (r1 LENOVO TP-7L        1070  LTP        0)
ACPI: FACP 7D6BE100, 00F4 (r3 LENOVO TP-7L        1070 LNVO        1)
ACPI Warning (tbfadt-0434): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7D6BE50C, E6A9 (r1 LENOVO TP-7L        1070 MSFT  3000000)
ACPI: FACS 7D6E4000, 0040
ACPI: SSDT 7D6BE2B4, 0258 (r1 LENOVO TP-7L        1070 MSFT  3000000)
ACPI: ECDT 7D6CCBB5, 0052 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: TCPA 7D6CCC07, 0032 (r2 LENOVO TP-7L        1070 LNVO        1)
ACPI: APIC 7D6CCC39, 0068 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: MCFG 7D6CCCA1, 003C (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: HPET 7D6CCCDD, 0038 (r1 LENOVO TP-7L        1070 LNVO        1)
ACPI: SLIC 7D6CCDF0, 0176 (r1 LENOVO TP-7L        1070  LTP        0)
ACPI: BOOT 7D6CCF66, 0028 (r1 LENOVO TP-7L        1070  LTP        1)
ACPI: ASF! 7D6CCF8E, 0072 (r16 LENOVO TP-7L        1070 PTL         1)
ACPI: SSDT 7D6E271B, 025F (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E297A, 00A6 (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E2A20, 04F7 (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E2F17, 08BD (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: SSDT 7D6E37D4, 069C (r1 LENOVO TP-7L        1070 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7e000000:72000000)
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists.  Total pages: 506689
Kernel command line: ro root=LABEL=/ rhgb quiet
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2394.382 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2016172k/2054848k available (2090k kernel code, 37436k reserved, 1597k data, 244k init, 1137344k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc56000 - 0xfffff000   (3748 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc079f000 - 0xc07dc000   ( 244 kB)
      .data : 0xc060aa1d - 0xc0799f54   (1597 kB)
      .text : 0xc0400000 - 0xc060aa1d   (2090 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet clockevent registered
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 4793.80 BogoMIPS (lpj=2396902)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4788.09 BogoMIPS (lpj=2394049)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T7700  @ 2.40GHz stepping 0a
Total of 2 processors activated (9581.90 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 434532 cycles TSC warp between CPUs, turning off TSC clock.
Brought up 2 CPUs
PM: Adding info for No Bus:platform
Time:  3:58:25  Date: 05/28/107
NET: Registered protocol family 16
PM: Adding info for No Bus:vtcon0
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
PM: Adding info for acpi:acpi_system:00
PM: Adding info for acpi:button_power:00
PM: Adding info for acpi:ACPI0007:00
PM: Adding info for acpi:ACPI0007:01
PM: Adding info for acpi:device:00
PM: Adding info for acpi:PNP0C0F:00
PM: Adding info for acpi:PNP0C0F:01
PM: Adding info for acpi:PNP0C0F:02
PM: Adding info for acpi:PNP0C0F:03
PM: Adding info for acpi:PNP0C0F:04
PM: Adding info for acpi:PNP0C0F:05
PM: Adding info for acpi:PNP0C0F:06
PM: Adding info for acpi:PNP0C0F:07
PM: Adding info for acpi:PNP0C01:00
PM: Adding info for acpi:PNP0C0D:00
PM: Adding info for acpi:PNP0C0E:00
PM: Adding info for acpi:PNP0A08:00
PM: Adding info for acpi:device:01
PM: Adding info for acpi:PNP0C02:00
PM: Adding info for acpi:PNP0000:00
PM: Adding info for acpi:PNP0100:00
PM: Adding info for acpi:PNP0103:00
PM: Adding info for acpi:PNP0200:00
PM: Adding info for acpi:PNP0800:00
PM: Adding info for acpi:PNP0C04:00
PM: Adding info for acpi:PNP0B00:00
PM: Adding info for acpi:PNP0303:00
PM: Adding info for acpi:IBM0057:00
PM: Adding info for acpi:ATM1200:00
PM: Adding info for acpi:PNP0C09:00
PM: Adding info for acpi:power_resource:00
PM: Adding info for acpi:PNP0C0A:00
PM: Adding info for acpi:ACPI0003:00
PM: Adding info for acpi:IBM0068:00
PM: Adding info for acpi:video:00
PM: Adding info for acpi:device:02
PM: Adding info for acpi:device:03
PM: Adding info for acpi:device:04
PM: Adding info for acpi:device:05
PM: Adding info for acpi:video:01
PM: Adding info for acpi:device:06
PM: Adding info for acpi:device:07
PM: Adding info for acpi:device:08
PM: Adding info for acpi:device:09
PM: Adding info for acpi:device:0a
PM: Adding info for acpi:device:0b
PM: Adding info for acpi:device:0c
PM: Adding info for acpi:device:0d
PM: Adding info for acpi:device:0e
PM: Adding info for acpi:device:0f
PM: Adding info for acpi:device:10
PM: Adding info for acpi:device:11
PM: Adding info for acpi:device:12
PM: Adding info for acpi:device:13
PM: Adding info for acpi:device:14
PM: Adding info for acpi:bay:00
PM: Adding info for acpi:device:15
PM: Adding info for acpi:device:16
PM: Adding info for acpi:device:17
PM: Adding info for acpi:device:18
PM: Adding info for acpi:bay:01
PM: Adding info for acpi:device:19
PM: Adding info for acpi:device:1a
PM: Adding info for acpi:device:1b
PM: Adding info for acpi:device:1c
PM: Adding info for acpi:device:1d
PM: Adding info for acpi:device:1e
PM: Adding info for acpi:device:1f
PM: Adding info for acpi:device:20
PM: Adding info for acpi:device:21
PM: Adding info for acpi:device:22
PM: Adding info for acpi:device:23
PM: Adding info for acpi:device:24
PM: Adding info for acpi:device:25
PM: Adding info for acpi:device:26
PM: Adding info for acpi:device:27
PM: Adding info for acpi:device:28
PM: Adding info for acpi:device:29
PM: Adding info for acpi:thermal:00
PM: Adding info for acpi:thermal:01
PM: Adding info for acpi:thermal:02
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PM: Adding info for No Bus:pci0000:00
Boot video device is 0000:00:02.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
PM: Adding info for pci:0000:00:00.0
PM: Adding info for pci:0000:00:02.0
PM: Adding info for pci:0000:00:02.1
PM: Adding info for pci:0000:00:19.0
PM: Adding info for pci:0000:00:1a.0
PM: Adding info for pci:0000:00:1a.1
PM: Adding info for pci:0000:00:1a.7
PM: Adding info for pci:0000:00:1b.0
PM: Adding info for pci:0000:00:1c.0
PM: Adding info for pci:0000:00:1c.1
PM: Adding info for pci:0000:00:1c.2
PM: Adding info for pci:0000:00:1c.3
PM: Adding info for pci:0000:00:1c.4
PM: Adding info for pci:0000:00:1d.0
PM: Adding info for pci:0000:00:1d.1
PM: Adding info for pci:0000:00:1d.2
PM: Adding info for pci:0000:00:1d.7
PM: Adding info for pci:0000:00:1e.0
PM: Adding info for pci:0000:00:1f.0
PM: Adding info for pci:0000:00:1f.2
PM: Adding info for pci:0000:00:1f.3
PM: Adding info for pci:0000:03:00.0
PM: Adding info for pci:0000:15:00.0
PM: Adding info for pci:0000:15:00.1
PM: Adding info for pci:0000:15:00.2
PM: Adding info for pci:0000:15:00.3
PM: Adding info for pci:0000:15:00.4
PM: Adding info for pci:0000:15:00.5
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
PM: Adding info for No Bus:pnp0
PM: Adding info for pnp:00:00
PM: Adding info for pnp:00:01
PM: Adding info for pnp:00:02
PM: Adding info for pnp:00:03
PM: Adding info for pnp:00:04
PM: Adding info for pnp:00:05
PM: Adding info for pnp:00:06
PM: Adding info for pnp:00:07
PM: Adding info for pnp:00:08
PM: Adding info for pnp:00:09
PM: Adding info for pnp:00:0a
pnp: PnP ACPI: found 11 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xc0000-0xc3fff could not be reserved
pnp: 00:00: iomem range 0xc4000-0xc7fff could not be reserved
pnp: 00:00: iomem range 0xc8000-0xcbfff has been reserved
pnp: 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
pnp: 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PM: Adding info for No Bus:mem
PM: Adding info for No Bus:kmem
PM: Adding info for No Bus:null
PM: Adding info for No Bus:port
PM: Adding info for No Bus:zero
PM: Adding info for No Bus:full
PM: Adding info for No Bus:random
PM: Adding info for No Bus:urandom
PM: Adding info for No Bus:kmsg
PM: Adding info for No Bus:oldmem
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: fc000000-fdffffff
  PREFETCH window: f8000000-f80fffff
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-3fff
  MEM window: dc000000-df3fffff
  PREFETCH window: dfe00000-dfefffff
PCI: Bridge: 0000:00:1c.2
  IO window: 4000-4fff
  MEM window: d8000000-d9ffffff
  PREFETCH window: dfb00000-dfbfffff
PCI: Bridge: 0000:00:1c.3
  IO window: 5000-5fff
  MEM window: d4000000-d5ffffff
  PREFETCH window: df800000-df8fffff
PCI: Bridge: 0000:00:1c.4
  IO window: 6000-6fff
  MEM window: d0000000-d1ffffff
  PREFETCH window: df500000-df5fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00007000-000070ff
  IO window: 00007400-000074ff
  PREFETCH window: f4000000-f7ffffff
  MEM window: 80000000-83ffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 7000-afff
  MEM window: f8300000-fbffffff
  PREFETCH window: f4000000-f7ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2883584 bytes)
TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 2822k freed
Simple Boot Flag at 0x35 set to 0x1
apm: BIOS not found.
PM: Adding info for platform:pcspkr
PM: Adding info for No Bus:snapshot
audit: initializing netlink socket (disabled)
audit(1183003104.764:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
PM: Adding info for pci_express:0000:00:1c.0:pcie00
Allocate Port Service[0000:00:1c.0:pcie02]
PM: Adding info for pci_express:0000:00:1c.0:pcie02
Allocate Port Service[0000:00:1c.0:pcie03]
PM: Adding info for pci_express:0000:00:1c.0:pcie03
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
PM: Adding info for pci_express:0000:00:1c.1:pcie00
Allocate Port Service[0000:00:1c.1:pcie02]
PM: Adding info for pci_express:0000:00:1c.1:pcie02
Allocate Port Service[0000:00:1c.1:pcie03]
PM: Adding info for pci_express:0000:00:1c.1:pcie03
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
PM: Adding info for pci_express:0000:00:1c.2:pcie00
Allocate Port Service[0000:00:1c.2:pcie02]
PM: Adding info for pci_express:0000:00:1c.2:pcie02
Allocate Port Service[0000:00:1c.2:pcie03]
PM: Adding info for pci_express:0000:00:1c.2:pcie03
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
PM: Adding info for pci_express:0000:00:1c.3:pcie00
Allocate Port Service[0000:00:1c.3:pcie02]
PM: Adding info for pci_express:0000:00:1c.3:pcie02
Allocate Port Service[0000:00:1c.3:pcie03]
PM: Adding info for pci_express:0000:00:1c.3:pcie03
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
PM: Adding info for pci_express:0000:00:1c.4:pcie00
Allocate Port Service[0000:00:1c.4:pcie02]
PM: Adding info for pci_express:0000:00:1c.4:pcie02
Allocate Port Service[0000:00:1c.4:pcie03]
PM: Adding info for pci_express:0000:00:1c.4:pcie03
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
PM: Adding info for platform:vesafb.0
ACPI: SSDT 7D6E1D72, 0306 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7D6E20FD, 061E (r1  PmRef  Cpu0Cst      100 INTL 20050513)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7D6E1CAA, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7D6E2078, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (52 C)
ACPI: Thermal Zone [THM1] (48 C)
PM: Adding info for No Bus:pnp1
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
PM: Adding info for No Bus:tty
PM: Adding info for No Bus:console
PM: Adding info for No Bus:ptmx
PM: Adding info for No Bus:tty0
PM: Adding info for No Bus:vcs
PM: Adding info for No Bus:vcsa
PM: Adding info for No Bus:tty1
PM: Adding info for No Bus:tty2
PM: Adding info for No Bus:tty3
PM: Adding info for No Bus:tty4
PM: Adding info for No Bus:tty5
PM: Adding info for No Bus:tty6
PM: Adding info for No Bus:tty7
PM: Adding info for No Bus:tty8
PM: Adding info for No Bus:tty9
PM: Adding info for No Bus:tty10
PM: Adding info for No Bus:tty11
PM: Adding info for No Bus:tty12
PM: Adding info for No Bus:tty13
PM: Adding info for No Bus:tty14
PM: Adding info for No Bus:tty15
PM: Adding info for No Bus:tty16
PM: Adding info for No Bus:tty17
PM: Adding info for No Bus:tty18
PM: Adding info for No Bus:tty19
PM: Adding info for No Bus:tty20
PM: Adding info for No Bus:tty21
PM: Adding info for No Bus:tty22
PM: Adding info for No Bus:tty23
PM: Adding info for No Bus:tty24
PM: Adding info for No Bus:tty25
PM: Adding info for No Bus:tty26
PM: Adding info for No Bus:tty27
PM: Adding info for No Bus:tty28
PM: Adding info for No Bus:tty29
PM: Adding info for No Bus:tty30
PM: Adding info for No Bus:tty31
PM: Adding info for No Bus:tty32
PM: Adding info for No Bus:tty33
PM: Adding info for No Bus:tty34
PM: Adding info for No Bus:tty35
PM: Adding info for No Bus:tty36
PM: Adding info for No Bus:tty37
PM: Adding info for No Bus:tty38
PM: Adding info for No Bus:tty39
PM: Adding info for No Bus:tty40
PM: Adding info for No Bus:tty41
PM: Adding info for No Bus:tty42
PM: Adding info for No Bus:tty43
PM: Adding info for No Bus:tty44
PM: Adding info for No Bus:tty45
PM: Adding info for No Bus:tty46
PM: Adding info for No Bus:tty47
PM: Adding info for No Bus:tty48
PM: Adding info for No Bus:tty49
PM: Adding info for No Bus:tty50
PM: Adding info for No Bus:tty51
PM: Adding info for No Bus:tty52
PM: Adding info for No Bus:tty53
PM: Adding info for No Bus:tty54
PM: Adding info for No Bus:tty55
PM: Adding info for No Bus:tty56
PM: Adding info for No Bus:tty57
PM: Adding info for No Bus:tty58
PM: Adding info for No Bus:tty59
PM: Adding info for No Bus:tty60
PM: Adding info for No Bus:tty61
PM: Adding info for No Bus:tty62
PM: Adding info for No Bus:tty63
PM: Adding info for No Bus:rtc
Real Time Clock Driver v1.12ac
PM: Adding info for No Bus:hpet
hpet_resources: 0xfed00000 is busy
PM: Adding info for No Bus:nvram
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
PM: Adding info for No Bus:agpgart
agpgart: AGP aperture is 256M @ 0xe0000000
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
PM: Adding info for platform:serial8250
PM: Adding info for No Bus:ttyS0
PM: Adding info for No Bus:ttyS1
PM: Adding info for No Bus:ttyS2
PM: Adding info for No Bus:ttyS3
PM: Adding info for No Bus:isa
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
PM: Adding info for No Bus:lo
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:20c6]
Yenta: ISA IRQ mask 0x04b8, PCI irq 20
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x7000 - 0xafff
cs: IO port probe 0x7000-0xafff: clean.
pcmcia: parent PCI bridge Memory window: 0xf8300000 - 0xfbffffff
pcmcia: parent PCI bridge Memory window: 0xf4000000 - 0xf7ffffff
PM: Adding info for No Bus:pcmcia_socket0
Clocksource tsc unstable (delta = -73611061 ns)
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
PM: Adding info for platform:i8042
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
PM: Adding info for serio:serio0
PM: Adding info for serio:serio1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
  Magic number: 11:860:968
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 244k freed
Write protecting the kernel read-only data: 1295k
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001860
PM: Adding info for usb:usb1
PM: Adding info for No Bus:usbdev1.1_ep00
usb usb1: configuration #1 chosen from 1 choice
PM: Adding info for usb:1-0:1.0
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev1.1_ep81
PM: Adding info for No Bus:usbdev1.1
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001880
PM: Adding info for usb:usb2
PM: Adding info for No Bus:usbdev2.1_ep00
usb usb2: configuration #1 chosen from 1 choice
PM: Adding info for usb:2-0:1.0
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev2.1_ep81
PM: Adding info for No Bus:usbdev2.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 20, io base 0x000018a0
PM: Adding info for usb:usb3
PM: Adding info for No Bus:usbdev3.1_ep00
usb usb3: configuration #1 chosen from 1 choice
PM: Adding info for usb:3-0:1.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
PM: Adding info for No Bus:usbdev3.1_ep81
PM: Adding info for No Bus:usbdev3.1
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 21, io base 0x000018c0
PM: Adding info for usb:usb4
PM: Adding info for No Bus:usbdev4.1_ep00
usb usb4: configuration #1 chosen from 1 choice
PM: Adding info for usb:4-0:1.0
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio1/input0
PM: Adding info for No Bus:usbdev4.1_ep81
PM: Adding info for No Bus:usbdev4.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 22, io base 0x000018e0
PM: Adding info for usb:usb5
PM: Adding info for No Bus:usbdev5.1_ep00
usb usb5: configuration #1 chosen from 1 choice
PM: Adding info for usb:5-0:1.0
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
input: SynPS/2 Synaptics TouchPad as /class/input/input2
PM: Adding info for serio:serio2
PM: Adding info for No Bus:usbdev5.1_ep81
PM: Adding info for No Bus:usbdev5.1
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe226400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb6
PM: Adding info for No Bus:usbdev6.1_ep00
usb usb6: configuration #1 chosen from 1 choice
PM: Adding info for usb:6-0:1.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
PM: Adding info for No Bus:usbdev6.1_ep81
PM: Adding info for No Bus:usbdev6.1
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe226800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
PM: Adding info for usb:usb7
PM: Adding info for No Bus:usbdev7.1_ep00
usb usb7: configuration #1 chosen from 1 choice
PM: Adding info for usb:7-0:1.0
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
PM: Adding info for No Bus:usbdev7.1_ep81
PM: Adding info for No Bus:usbdev7.1
SCSI subsystem initialized
libata version 2.20 loaded.
ata_piix 0000:00:1f.2: version 2.10ac1
ata_piix 0000:00:1f.2: MAP [ IDE IDE -- -- ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata1: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x00011c30 irq 14
ata2: SATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x00011c38 irq 15
scsi0 : ata_piix
PM: Adding info for No Bus:host0
ata1.00: ATA-7: ST910021AS, 4.06, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 
ata1.00: configured for UDMA/100
scsi1 : ata_piix
PM: Adding info for No Bus:host1
ata2.00: ATAPI, max UDMA/33
ata2.00: applying bridge limits
ata2.00: configured for UDMA/33
PM: Adding info for No Bus:target0:0:0
scsi 0:0:0:0: Direct-Access     ATA      ST910021AS       4.06 PQ: 0 ANSI: 5
PM: Adding info for scsi:0:0:0:0
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 195371568 512-byte hdwr sectors (100030 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: Attached scsi disk sda
PM: Adding info for No Bus:target1:0:0
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-U10N  1.05 PQ: 0 ANSI: 5
PM: Adding info for scsi:1:0:0:0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1183003110.764:2): selinux=0 auid=4294967295
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input3
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
cs: IO port probe 0x100-0x3af: clean.
cs: IO port probe 0x3e0-0x4ff: excluding 0x4d0-0x4d7
cs: IO port probe 0x820-0x8ff: clean.
cs: IO port probe 0xc00-0xcf7: clean.
cs: IO port probe 0xa00-0xaff: clean.
input: PC Speaker as /class/input/input4
ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 19
PM: Adding info for No Bus:i2c-0
PM: Adding info for No Bus:timer
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:15:58:84:b3:c8
PM: Adding info for No Bus:eth0
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:15:00.2 [1180:0822] (rev 21)
ACPI: PCI Interrupt 0000:15:00.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:15:00.2 to 64
PM: Adding info for No Bus:mmc0
mmc0: SDHCI at 0xf8301800 irq 22 DMA
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt 0000:15:00.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:15:00.1 to 64
PM: Adding info for ieee1394:fw-host0
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[21]  MMIO=[f8301000-f83017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
PM: Adding info for No Bus:seq
PM: Adding info for No Bus:sequencer
PM: Adding info for No Bus:sequencer2
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PM: Adding info for No Bus:pcmC0D0p
PM: Adding info for No Bus:pcmC0D0c
PM: Adding info for No Bus:dsp
PM: Adding info for No Bus:audio
PM: Adding info for No Bus:controlC0
PM: Adding info for No Bus:mixer
PM: Adding info for ieee1394:00016c20001618d4
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00016c20001618d4]
PM: Adding info for ieee1394:00016c20001618d4-0
loop: loaded (max 8 devices)
floppy0: no floppy controllers found
lp: driver loaded but no devices found
sonypi: Sony Programmable I/O Controller Driver v1.26.
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
PM: Removing info for No Bus:vcs8
PM: Removing info for No Bus:vcsa8
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
PM: Adding info for No Bus:vcs8
PM: Adding info for No Bus:vcsa8
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 20
ACPI: AC Adapter [AC] (off-line)
ACPI: Battery Slot [BAT0] (battery present)
PM: Adding info for platform:dock.0
ACPI: ACPI Dock Station Driver 
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.IDE0.PRIM.MSTR: Adding notify handler
PM: Adding info for platform:bay.0
ACPI: Bay [\_SB_.PCI0.IDE0.PRIM.MSTR] Added
ACPI: \_SB_.PCI0.SATA.SCND.MSTR: found ejectable bay
ACPI: \_SB_.PCI0.SATA.SCND.MSTR: Adding notify handler
PM: Adding info for platform:bay.1
ACPI: Bay [\_SB_.PCI0.SATA.SCND.MSTR] Added
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input6
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input7
ACPI: Sleep Button (CM) [SLPB]
ibm_acpi: IBM ThinkPad ACPI Extras v0.13
ibm_acpi: http://ibm-acpi.sf.net/
ibm_acpi: ThinkPad EC firmware 7KHT21WW-1.05
ibm_acpi: another device driver is already handling bay events
ibm_acpi: disabling subdriver bay
set_level status: 0
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
set_level status: 0
ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
PM: Adding info for No Bus:device-mapper
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda3, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 3068372k swap on /dev/sda5.  Priority:-1 extents:1 across:3068372k
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:microcode
PM: Adding info for platform:microcode
PM: Adding info for No Bus:microcode
PM: Removing info for No Bus:microcode
PM: Adding info for No Bus:microcode
PM: Removing info for No Bus:microcode
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
PM: Removing info for No Bus:microcode
PM: Removing info for platform:microcode
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth0: e1000_watchdog: 10/100 speed: disabling TSO
audit(1183003162.492:3): audit_pid=2138 old=0 by auid=4294967295
Bluetooth: Core ver 2.11
PM: Adding info for platform:bluetooth
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
eth0: no IPv6 routers present
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Removing info for No Bus:vcs1
PM: Removing info for No Bus:vcsa1
PM: Adding info for No Bus:vcs1
PM: Adding info for No Bus:vcsa1
PM: Removing info for No Bus:vcs4
PM: Removing info for No Bus:vcsa4
PM: Adding info for No Bus:vcs4
PM: Adding info for No Bus:vcsa4
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Removing info for No Bus:vcs3
PM: Removing info for No Bus:vcsa3
PM: Adding info for No Bus:vcs3
PM: Adding info for No Bus:vcsa3
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Removing info for No Bus:vcs5
PM: Removing info for No Bus:vcsa5
PM: Adding info for No Bus:vcs5
PM: Adding info for No Bus:vcsa5
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs6
PM: Removing info for No Bus:vcsa6
PM: Adding info for No Bus:vcs6
PM: Adding info for No Bus:vcsa6
PM: Removing info for No Bus:vcs2
PM: Removing info for No Bus:vcsa2
PM: Adding info for No Bus:vcs2
PM: Adding info for No Bus:vcsa2
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
[drm] Initialized drm 1.1.0 20060810
eth0: no IPv6 routers present
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c042495b>] sched_getaffinity+0xf/0x85
 [<c045bebf>] __synchronize_sched+0xd/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fe2410>] 0xb7fe2410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bee7>] __synchronize_sched+0x35/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fe2410>] 0xb7fe2410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bee7>] __synchronize_sched+0x35/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fe2410>] 0xb7fe2410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bf09>] __synchronize_sched+0x57/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fe2410>] 0xb7fe2410
 =======================
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
PM: Removing info for No Bus:vcs7
PM: Removing info for No Bus:vcsa7
PM: Adding info for No Bus:vcs7
PM: Adding info for No Bus:vcsa7
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c042495b>] sched_getaffinity+0xf/0x85
 [<c045bebf>] __synchronize_sched+0xd/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bee7>] __synchronize_sched+0x35/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bee7>] __synchronize_sched+0x35/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================
Lukewarm IQ detected in hotplug locking
BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
 [<c0405f88>] dump_trace+0x64/0x105
 [<c0406041>] show_trace_log_lvl+0x18/0x2c
 [<c040664e>] show_trace+0xf/0x11
 [<c04066cf>] dump_stack+0x12/0x14
 [<c0447519>] lock_cpu_hotplug+0x51/0x74
 [<c0426251>] sched_setaffinity+0x13/0xe5
 [<c045bf09>] __synchronize_sched+0x57/0x5a
 [<c04244f1>] arch_reinit_sched_domains+0x13/0x29
 [<c0424543>] sched_power_savings_store+0x3c/0x49
 [<c0554680>] sysdev_class_store+0x1e/0x22
 [<c04b32f7>] sysfs_write_file+0xa3/0xc6
 [<c047beb3>] vfs_write+0xa8/0x154
 [<c047c4ce>] sys_write+0x41/0x67
 [<c0404f7c>] syscall_call+0x7/0xb
 [<b7fb3410>] 0xb7fb3410
 =======================

--=-kXdnviw8C/baCa3i89sm--

