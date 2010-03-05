Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0CEAa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 19:30:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:58632 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab0CEAaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 19:30:55 -0500
Message-ID: <4B905072.9080407@kernel.org>
Date: Thu, 04 Mar 2010 16:29:38 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: no boot with NO_BOOTMEM=y [was: mmotm 2010-03-02-18-38 uploaded]
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8FC98E.3070203@gmail.com> <4B8FCC4D.6040202@gmail.com>
In-Reply-To: <4B8FCC4D.6040202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2010 07:05 AM, Jiri Slaby wrote:
> Subject fixed.
> 
> On 03/04/2010 03:54 PM, Jiri Slaby wrote:
>> On 03/03/2010 03:39 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2010-03-02-18-38 has been uploaded to
>>
>> Hi, the kernel does not boot in qemu-kvm with NO_BOOTMEM=y. The last
>> message is 'Booting the kernel.'
> 

tried with kvm/qemu with 512m and 8192m all works here...

/x/kernel.org/kvm/qemu-system-x86_64 -L /x/kernel.org/kvm/qemu -m 512 -smp 4 -cdrom /x/kernel.org/image_2.6.34_k8.2.iso -boot d -vnc 10.6.189.177:0 -pcidevice host=81:00.0 -serial telnet:10.6.189.177:4444,server


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.33-tip-yh-08403-g051ad64-dirty (yhlu@linux-siqj) (gcc version 4.4.1 [gcc-4_4-branch revision 150839] (SUSE Linux) ) #209 SMP Thu Mar 4 16:16:13 PST 2010
[    0.000000] Command line: BOOT_IMAGE=linux debug apic=debug ramdisk_size=262144 root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200n8 initrd=initrd.img
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fff0000 (usable)
[    0.000000]  BIOS-e820: 000000001fff0000 - 0000000020000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
[    0.000000] Early serial console at I/O port 0x3f8 (options '115200n8')
[    0.000000] bootconsole [uart0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1fff0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFFFFFFFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Scan SMP from ffff880000000000 for 1024 bytes.
[    0.000000] Scan SMP from ffff88000009fc00 for 1024 bytes.
[    0.000000] Scan SMP from ffff8800000f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [ffff8800000fbc20] fbc20
[    0.000000]   mpc: fba20-fbc1c
[    0.000000] init_memory_mapping: 0000000000000000-000000001fff0000
[    0.000000]  0000000000 - 001fe00000 page 2M
[    0.000000]  001fe00000 - 001fff0000 page 4k
[    0.000000] kernel direct mapping tables up to 1fff0000 @ 8000-b000
[    0.000000] RAMDISK: 1ddda000 - 1ffcee10
[    0.000000] ACPI: RSDP 00000000000fbd40 00014 (v00 QEMU  )
[    0.000000] ACPI: RSDT 000000001fff0000 00030 (v01 QEMU   QEMURSDT 00000001 QEMU 00000001)
[    0.000000] ACPI: FACP 000000001fff01b4 00074 (v01 QEMU   QEMUFACP 00000001 QEMU 00000001)
[    0.000000] ACPI: DSDT 000000001fff0280 01DD4 (v01   BXPC   BXDSDT 00000001 INTL 20061109)
[    0.000000] ACPI: FACS 000000001fff0240 00040
[    0.000000] ACPI: SSDT 000000001fff2054 009E3 (v01   BXPC   BXSSDT 00000001 INTL 20061109)
[    0.000000] ACPI: APIC 000000001fff2a38 000E0 (v01 QEMU   QEMUAPIC 00000001 QEMU 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000001fff0000
[    0.000000] Adding active range (0, 0x1, 0x9f) 0 entries of 3200 used
[    0.000000] Adding active range (0, 0x100, 0x1fff0) 1 entries of 3200 used
[    0.000000] Initmem setup node 0 0000000000000000-000000001fff0000
[    0.000000]   NODE_DATA [000000000336e040 - 000000000337303f]
[    0.000000]  [ffffea0000000000-ffffea7fffffffff] PGD -> ffff880003b75000 on node 0
[    0.000000]  [ffffea0000000000-ffffea003fffffff] PUD -> ffff880003b76000 on node 0
[    0.000000]  [ffffea0000000000-ffffea00007fffff] PMD -> [ffff880003c00000-ffff8800043fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001fff0
[    0.000000] start - node_states[2]: 
[    0.000000] On node 0 totalpages: 130958
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1736 pages used for memmap
[    0.000000]   DMA32 zone: 125224 pages, LIFO batch:31
[    0.000000] after - node_states[2]: 0
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x04] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x06] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x08] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x09] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x0a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x0b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x0c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x0d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x0e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x0f] disabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] init_cpu_to_node:
[    0.000000] cpu 0 -> apicid 0x0 -> node 0
[    0.000000] cpu 1 -> apicid 0x1 -> node 0
[    0.000000] cpu 2 -> apicid 0x2 -> node 0
[    0.000000] cpu 3 -> apicid 0x3 -> node 0
[    0.000000] mapped APIC to ffffffffff5fc000 (fee00000)
[    0.000000] mapped IOAPIC to ffffffffff5fb000 (fec00000)
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 20000000 (gap: 20000000:dffbc000)
[    0.000000] early_res array is doubled to 64 at [7060 - 785f]
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 477 pages/cpu @ffff880004400000 s1924312 r8192 d21288 u2097152
[    0.000000] pcpu-alloc: s1924312 r8192 d21288 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] build_zonelists: local_node: 0 next_best_node: 0 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 129166
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=linux debug apic=debug ramdisk_size=262144 root=/dev/ram0 rw ip=dhcp console=uart8250,io,0x3f8,115200n8 initrd=initrd.img
[    0.000000] PID hash table entries: 2048 (order: 2, 16384 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (43 early reservations)
[    0.000000]   #1 [0001000000 - 000336dae0]   TEXT DATA BSS
[    0.000000]   #2 [001ddda000 - 001ffcee10]         RAMDISK
[    0.000000]   #3 [000336e000 - 000336e03d]             BRK
[    0.000000]   #4 [00000fbc30 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000fbc20 - 00000fbc30]    MP-table mpf
[    0.000000]   #6 [000009fc00 - 00000fba20]   BIOS reserved
[    0.000000]   #7 [00000fbc1c - 00000fbc20]   BIOS reserved
[    0.000000]   #8 [00000fba20 - 00000fbc1c]    MP-table mpc
[    0.000000]   #9 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #10 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #11 [0000008000 - 0000009000]         PGTABLE
[    0.000000]   #12 [000336e040 - 0003373040]       NODE_DATA
[    0.000000]   #13 [0003373040 - 0003374040]         BOOTMEM
[    0.000000]   #14 [0000007000 - 0000007060]         BOOTMEM
[    0.000000]   #15 [0003b75000 - 0003b76000]         BOOTMEM
[    0.000000]   #16 [0003b76000 - 0003b77000]         BOOTMEM
[    0.000000]   #17 [0003c00000 - 0004400000]        MEMMAP 0
[    0.000000]   #18 [0003374040 - 00033c4040]         BOOTMEM
[    0.000000]   #19 [00033c4040 - 0003414040]         BOOTMEM
[    0.000000]   #20 [0003415000 - 0003416000]         BOOTMEM
[    0.000000]   #21 [000336db00 - 000336db43]         BOOTMEM
[    0.000000]   #22 [000336db80 - 000336dd08]         BOOTMEM
[    0.000000]   #23 [000336dd40 - 000336dda8]         BOOTMEM
[    0.000000]   #24 [000336ddc0 - 000336de28]         BOOTMEM
[    0.000000]   #25 [000336de40 - 000336dea8]         BOOTMEM
[    0.000000]   #26 [000336dec0 - 000336df28]         BOOTMEM
[    0.000000]   #27 [000336df40 - 000336dfa8]         BOOTMEM
[    0.000000]   #28 [0003414040 - 00034140a8]         BOOTMEM
[    0.000000]   #29 [00034140c0 - 0003414145]         BOOTMEM
[    0.000000]   #30 [0003414180 - 0003414205]         BOOTMEM
[    0.000000]   #31 [0004400000 - 00045dd000]         BOOTMEM
[    0.000000]   #32 [0004600000 - 00047dd000]         BOOTMEM
[    0.000000]   #33 [0004800000 - 00049dd000]         BOOTMEM
[    0.000000]   #34 [0004a00000 - 0004bdd000]         BOOTMEM
[    0.000000]   #35 [000336dfc0 - 000336dfc8]         BOOTMEM
[    0.000000]   #36 [0003414240 - 0003414248]         BOOTMEM
[    0.000000]   #37 [0003414280 - 0003414290]         BOOTMEM
[    0.000000]   #38 [00034142c0 - 00034142e0]         BOOTMEM
[    0.000000]   #39 [0003414300 - 0003414450]         BOOTMEM
[    0.000000]   #40 [0003414480 - 0003414500]         BOOTMEM
[    0.000000]   #41 [0003414500 - 0003414580]         BOOTMEM
[    0.000000]   #42 [0003416000 - 000341a000]         BOOTMEM
[    0.000000]  9 40 - 80 9f
[    0.000000]  100 100 - 1000 1000
[    0.000000]  341a 3440 - 3b40 3b75
[    0.000000]  3b77 3b80 - 3c00 3c00
[    0.000000]  45dd - 4600
[    0.000000]  47dd - 4800
[    0.000000]  49dd - 4a00
[    0.000000]  4bdd 4c00 - 1ddc0 1ddda
[    0.000000]  1ffcf - 1fff0
[    0.000000] Memory: 436228k/524224k available (12324k kernel code, 392k absent, 87604k reserved, 8908k data, 2768k init)

