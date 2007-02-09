Return-Path: <linux-kernel-owner+w=401wt.eu-S2992457AbXBISvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992457AbXBISvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 13:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992456AbXBISvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 13:51:31 -0500
Received: from smtpa2.netcabo.pt ([212.113.174.17]:52962 "EHLO
	exch01smtp01.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992451AbXBISv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 13:51:29 -0500
Message-ID: <45CCC3CF.4090604@rncbc.org>
Date: Fri, 09 Feb 2007 18:56:15 +0000
From: Rui Nuno Capela <rncbc@rncbc.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rui Nuno Capela <rncbc@rncbc.org>, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: 2.6.20-rt5 Oops on boot
References: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
In-Reply-To: <23932.213.58.131.130.1170156409.squirrel@www.rncbc.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2007 18:51:27.0271 (UTC) FILETIME=[4DC3BB70:01C74C7B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have terrible news: 2.6.20-rt5 does not boot at all on a couple
machines I was brave enough to try -- a P4@3.3Ghz SMP/HT desktop, and a
Core2 Duo T7200@2.0Ghz laptop. For the first case I could capture the
following dump via serial console:

--BOF--
Linux version 2.6.20-rt5.1 (root@gamma-suse1) (gcc version 4.1.2
20061115 (prerelease) (SUSE Linux)) #1 SMP PREEMPT Fri Feb 9 18:30:22
WET 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end:
000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000e8000 size: 0000000000018000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003fe30000 end:
000000003ff30000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003ff30000 size: 0000000000010000 end:
000000003ff40000 type: 3
copy_e820_map() start: 000000003ff40000 size: 00000000000b0000 end:
000000003fff0000 type: 4
copy_e820_map() start: 000000003fff0000 size: 0000000000010000 end:
0000000040000000 type: 2
copy_e820_map() start: 00000000ffb80000 size: 0000000000480000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ff30000 (usable)
 BIOS-e820: 000000003ff30000 - 000000003ff40000 (ACPI data)
 BIOS-e820: 000000003ff40000 - 000000003fff0000 (ACPI NVS)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 261936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261936
early_node_map[1] active PFN ranges
    0:        0 ->   261936
On node 0 totalpages: 261936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 254 pages used for memmap
  HighMem zone: 32306 pages, LIFO batch:7
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP (v002 ACPIAM                                ) @ 0x000f9e60
ACPI: XSDT (v001 A M I  OEMXSDT  0x08000320 MSFT 0x00000097) @ 0x3ff30100
ACPI: FADT (v003 A M I  OEMFACP  0x08000320 MSFT 0x00000097) @ 0x3ff30290
ACPI: MADT (v001 A M I  OEMAPIC  0x08000320 MSFT 0x00000097) @ 0x3ff30390
ACPI: OEMB (v001 A M I  OEMBIOS  0x08000320 MSFT 0x00000097) @ 0x3ff40040
ACPI: DSDT (v001  P4P81 P4P81086 0x00000086 INTL 0x02002026) @ 0x00000000
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bfb80000)
Detected 3361.210 MHz processor.
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists.  Total pages: 259890
Kernel command line: root=/dev/hda1 vga=0x31a resume=/dev/hda3
splash=silent console=tty0 console=ttyS0,115200n8 debug
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
CPU 0 irqstacks, hard=c03ed000 soft=c03eb000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour dummy device 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1030292k/1047744k available (1725k kernel code, 16684k reserved,
1005k data, 220k init, 130240k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc03af000 - 0xc03e6000   ( 220 kB)
      .data : 0xc02af5dd - 0xc03aacf4   (1005 kB)
      .text : 0xc0100000 - 0xc02af5dd   (1725 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 6723.97 BogoMIPS
(lpj=3361989)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
Freeing SMP alternatives: 9k freed
ACPI: Core revision 20060707
CPU0: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c03ee000 soft=c03ec000
Initializing CPU#1
Calibrating delay using timer specific routine.. 6720.94 BogoMIPS
(lpj=3360473)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00004400
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU 2.80GHz stepping 09
Total of 2 processors activated (13444.92 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
BUG: unable to handle kernel NULL pointer dereference at virtual address
0000001c
 printing eip:
c011783d
*pde = 00000000
stopped custom tracer.
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in:
CPU:    1
EIP:    0060:[<c011783d>]    Not tainted VLI
EFLAGS: 00010286   (2.6.20-rt5.1 #1)
EIP is at try_to_wake_up+0x11/0x395
eax: 00000000   ebx: 00000000   ecx: 00000000   edx: dfc87ccc
esi: 00000000   edi: c18a4700   ebp: dfc87cdc   esp: dfc87c90
ds: 007b   es: 007b   ss: 0068   preempt: 00000001
Process swapper (pid: 1, ti=dfc87000 task=dfca1670 task.ti=dfc87000)
Stack: 00000046 00000000 0000001f 00000008 c18a3d80 dfca1670 dfc87cc0
dfc87cb8
       00000046 dfca1670 00000001 dfc87cc4 c0136f34 dfc87cd0 c012dbc8
dfc87cf4
       00000000 c18a3d80 c18a4700 dfc87ce8 c0117c64 00000000 dfc87d3c
c01180e6
Call Trace:
 [<c0117c64>] wake_up_process+0x19/0x1b
 [<c01180e6>] set_cpus_allowed+0x6c/0x92
 [<c0118140>] measure_one+0x34/0x165
 [<c0118953>] build_sched_domains+0x6e2/0xce4
 [<c0118f70>] arch_init_sched_domains+0x1b/0x1d
 [<c03c15dd>] sched_init_smp+0x10/0x47
 [<c010047d>] init+0xd0/0x335
 [<c0104b87>] kernel_thread_helper+0x7/0x10
 =======================
Code: 5d f0 89 4f 44 89 5f 48 8b 55 e8 89 f8 e8 99 e1 ff ff 83 c4 0c 5b
5e 5f 5d c3 55 89 e5 57 56 89 c6 53 83 ec 40 89 55 bc 8d 55 f0 <83> 78
1c 63 b8 00 00 00 00 0f 4f c1 89 45 b8 89 f0 e8 ca e1 ff
EIP: [<c011783d>] try_to_wake_up+0x11/0x395 SS:ESP 0068:dfc87c90
 <0>Kernel panic - not syncing: Attempted to kill init!
 [<c0104f7e>] dump_trace+0x63/0x1e5
 [<c010511a>] show_trace_log_lvl+0x1a/0x2f
 [<c010572a>] show_trace+0x12/0x14
 [<c01057bd>] dump_stack+0x16/0x18
 [<c011c791>] panic+0x50/0xf3
 [<c011f25b>] do_exit+0x9b/0x771
 [<c01056c3>] die+0x211/0x237
 [<c02add07>] do_page_fault+0x3f3/0x4bf
 [<c02ac39c>] error_code+0x7c/0x84
 [<c011783d>] try_to_wake_up+0x11/0x395
 [<c0117c64>] wake_up_process+0x19/0x1b
 [<c01180e6>] set_cpus_allowed+0x6c/0x92
 [<c0118140>] measure_one+0x34/0x165
 [<c0118953>] build_sched_domains+0x6e2/0xce4
 [<c0118f70>] arch_init_sched_domains+0x1b/0x1d
 [<c03c15dd>] sched_init_smp+0x10/0x47
 [<c010047d>] init+0xd0/0x335
 [<c0104b87>] kernel_thread_helper+0x7/0x10
 =======================
--EOF--

Hope it helps.
-- 
rncbc aka Rui Nuno Capela
rncbc@rncbc.org
