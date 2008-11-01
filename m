Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbYKAKow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbYKAKow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYKAKon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:44:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:3765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbYKAKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ljRKSjfNtGfs7HLpFkQWVMSMEkgAHJ3FH0uG5Xp0huyRaeZpVwkZ2IVitVJrUSMXqX
         WssCTMT77XoeuS4fZXpm64kdQUiHtuafLPocBJ5D2mu95ql5yFkJQ/0HwOCIDBYULu7z
         Afdv6fBEzoczxeLcJfKZdkftdtp9SZeFDChNs=
Message-ID: <19f34abd0811010344h7fe9fb8by79f9ae02dbf03ec7@mail.gmail.com>
Date: Sat, 1 Nov 2008 11:44:39 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: linux-next: Tree for October 31
Cc: "Rusty Russell" <rusty@rustcorp.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081031185613.7892fd8d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031185613.7892fd8d.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 8:56 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> (patches at
> http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
> are tracking the linux-next tree using git, you should not use "git pull"
> to do so as that will try to merge the new linux-next release with the
> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
> (see below).

Hm, won't boot for me :-(

   [Linux-bzImage, setup=0x3000, size=0xfdbd90]

BIOS EBDA/lowmem at: 0009fc00/0009fc00
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.28-rc2-next-20081031 (vegard@localhost.localdomain) (gcc versi
on 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #59 SMP Sat Nov 1 08:01:36 CET 2008
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  NSC Geode by NSC
  Cyrix CyrixInstead
  Centaur CentaurHauls
  Transmeta GenuineTMx86
  Transmeta TransmetaCPU
  UMC UMC UMC UMC
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
 BIOS-e820: 000000003ffc0000 - 000000003ffce000 (ACPI data)
 BIOS-e820: 000000003ffce000 - 000000003fff0000 (ACPI NVS)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
console [earlyser0] enabled
debug: ignoring loglevel setting.
DMI 2.3 present.
AMI BIOS detected: BIOS may corrupt low RAM, working it around.
last_pfn = 0x3ffc0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 373fe000 @ 100000-1e1000
ACPI: RSDP 000F9380, 0014 (r0 ACPIAM)
ACPI: RSDT 3FFC0000, 0034 (r1 A M I  OEMRSDT   7000624 MSFT       97)
ACPI: FACP 3FFC0200, 0084 (r2 A M I  OEMFACP   7000624 MSFT       97)
ACPI: DSDT 3FFC0430, 42F0 (r1   945P  945PA30        0 INTL  2002026)
ACPI: FACS 3FFCE000, 0040
ACPI: APIC 3FFC0390, 005C (r1 A M I  OEMAPIC   7000624 MSFT       97)
ACPI: MCFG 3FFC03F0, 003C (r1 A M I  OEMMCFG   7000624 MSFT       97)
ACPI: OEMB 3FFCE040, 0046 (r1 A M I  AMI_OEM   7000624 MSFT       97)
ACPI: Local APIC address 0xfee00000
139MB HIGHMEM available.
883MB LOWMEM available.
  mapped low ram: 0 - 373fe000
  low ram: 00000000 - 373fe000
  bootmap 00010000 - 00016e80
(8 early reservations) ==> bootmem [0000000000 - 00373fe000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 0002915914]    TEXT DATA BSS ==> [0000400000 - 0002915914]
  #4 [0002916000 - 0002932000]    INIT_PG_TABLE ==> [0002916000 - 0002932000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000100000 - 00001c2000]          PGTABLE ==> [0000100000 - 00001c2000]
  #7 [0000010000 - 0000017000]          BOOTMAP ==> [0000010000 - 0000017000]
found SMP MP-table at [c00ff780] 000ff780
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000373fe
  HighMem  0x000373fe -> 0x0003ffc0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003ffc0
On node 0 totalpages: 261967
free_area_init_node: node 0, pgdat c22fbf80, node_mem_map c2933380
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3927 pages, LIFO batch:0
  Normal zone: 3038 pages used for memmap
  Normal zone: 219168 pages, LIFO batch:31
  HighMem zone: 490 pages used for memmap
  HighMem zone: 35288 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
Using APIC driver default
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e6000
PM: Registered nosave memory: 00000000000e6000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bee00000)
BUG: Int 6: CR2 00000000
     EDI 01000000  ESI 00000000  EBP c2345f6c  ESP c2345f0c
     EBX c23e3dac  EDX 00000006  ECX 00000080  EAX c23e3dac
     err 00000000  EIP c2372d2a   CS 00000060  flg 00010046
Stack: c2345f74 c2372f3f 00000001 fffffeec 00000114 00000046 c2345fb0 c0465301
       00000080 00000000 c23e3dac 000000df c23e3dac 00001001 000373fe 00000000
       00000000 c23e3dac 01000000 00000000 c2345f98 c2372ff8 01000000 00000000
Pid: 0, comm: swapper Not tainted 2.6.28-rc2-next-20081031 #59
Call Trace:
 [<c2372d2a>] ? alloc_bootmem_core+0x49/0x2b2
 [<c2372f3f>] ? alloc_bootmem_core+0x25e/0x2b2
 [<c0465301>] ? vprintk+0x181/0x440
 [<c2372ff8>] ? ___alloc_bootmem_nopanic+0x65/0x91
 [<c237308d>] ? ___alloc_bootmem+0x16/0x3c
 [<c237308d>] ? ___alloc_bootmem+0x16/0x3c
 [<c2373163>] ? __alloc_bootmem+0x12/0x14
 [<c23757fe>] ? cpu_alloc_init+0x4b/0x5d
 [<c2354709>] ? start_kernel+0xe9/0x3c1
 [<c2354099>] ? __init_begin+0x99/0xa1

This is EIP:

static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
                                unsigned long size, unsigned long align,
                                unsigned long goal, unsigned long limit)
{
        unsigned long fallback = 0;
        unsigned long min, max, start, sidx, midx, step;

        BUG_ON(!size); <-- HERE!

...coming from:

void __init cpu_alloc_init(void)
{
        base_percpu_in_units = (__per_cpu_end - __per_cpu_start
                                        + UNIT_SIZE - 1) / UNIT_SIZE;

        nr_units = PERCPU_AREA_SIZE / UNIT_SIZE - base_percpu_in_units;

        cpu_alloc_map = alloc_bootmem(BITS_TO_LONGS(nr_units)); <-- HERE!
}

...looks to have been introduced in:

commit 66f2d2c531e755656a5481fb92a9d137404d9f44
Author: Christoph Lameter <cl@linux-foundation.org>
Date:   Mon Oct 27 14:45:46 2008 -0500

    cpualloc: the allocator

Adding to Cc.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
