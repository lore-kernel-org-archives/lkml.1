Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYBDQLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYBDQLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYBDQLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:11:18 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:53832 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYBDQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:11:16 -0500
Message-ID: <47A7391F.2020408@in.ibm.com>
Date: Mon, 04 Feb 2008 21:41:11 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, kexec@lists.infradead.org
Subject: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
Content-Type: multipart/mixed;
 boundary="------------080006030209040204000908"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080006030209040204000908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

While trying to configure kdump with 2.6.24-rc8-mm1 [ on a x86-64 box ]
i ran into this problem. Here is the snippet from dmesg during the
failure. [ dmesg log attached ]

early_ioremap(000000000000040e, 00000002) => -000002103442418
early_iounmap(ffffffff82a0040e, 00000002)
early_ioremap(000000000009dc00, 00001000) => -000002102797312
early_iounmap(ffffffff82a9dc00, 00001000)
crashkernel reservation failed - memory is in use
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0

I am using 128M@32M value for crashkernel parameter.

Thanks
-Sachin



--------------080006030209040204000908
Content-Type: text/plain;
 name="dmesg-log-2624rc8mm1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg-log-2624rc8mm1"

Linux version 2.6.24-rc8-mm1 (root@xxxxxxxxxx) (gcc version 4.1.1 20070105 (Red Hat 4.1.1-52)) #2 SMP Mon Feb 4 20:24:24 IST 2008
Command line: root=/dev/sdd1 console=tty0 console=ttyS0,38400 crashkernel=128M@32M selinux=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009dc00 (usable)
 BIOS-e820: 000000000009dc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000c7fcae00 (usable)
 BIOS-e820: 00000000c7fcae00 - 00000000c7fcf800 (ACPI data)
 BIOS-e820: 00000000c7fcf800 - 00000000c8000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 819146) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
end_pfn_map = 2326528
early_ioremap(000000000000040e, 00000002) => -000002105539570
early_iounmap(ffffffff8280040e, 00000002)
early_ioremap(000000000009dc00, 00000002) => -000002104894464
early_iounmap(ffffffff8289dc00, 00000002)
early_ioremap(0000000000008000, 00001000) => -000002105507840
early_ioremap(0000000000009000, 00001000) => -000002103406592
early_iounmap(ffffffff82a09000, 00001000)
early_ioremap(000000000000a000, 00001000) => -000002103402496
early_iounmap(ffffffff82a0a000, 00001000)
early_ioremap(000000000000b000, 00001000) => -000002103398400
early_iounmap(ffffffff82a0b000, 00001000)
early_ioremap(000000000000c000, 00001000) => -000002103394304
early_iounmap(ffffffff82a0c000, 00001000)
early_ioremap(000000000000d000, 00001000) => -000002103390208
early_iounmap(ffffffff82a0d000, 00001000)
early_ioremap(000000000000e000, 00001000) => -000002103386112
early_iounmap(ffffffff82a0e000, 00001000)
early_ioremap(000000000000f000, 00001000) => -000002103382016
early_iounmap(ffffffff82a0f000, 00001000)
early_ioremap(0000000000010000, 00001000) => -000002103377920
early_iounmap(ffffffff82a10000, 00001000)
early_ioremap(0000000000011000, 00001000) => -000002103373824
early_iounmap(ffffffff82a11000, 00001000)
early_iounmap(ffffffff82808000, 00001000)
early_ioremap(00000000000f0000, 00010000) => -000002104557568
DMI 2.3 present.
early_ioremap(00000000000f83eb, 000009e1) => -000002102426645
early_iounmap(ffffffff82af83eb, 000009e1)
early_iounmap(ffff81000000040e, 00000002)
early_iounmap(ffff81000009dc00, 00000400)
early_iounmap(ffff8100000e0000, 00020000)
ACPI: RSDP 000FDFB0, 0024 (r2 IBM   )
early_iounmap(ffff8100000fdfb0, 00000024)
early_iounmap(ffff8100c7fcf700, 00000024)
early_iounmap(ffff8100c7fcf700, 0000003c)
ACPI: XSDT C7FCF700, 003C (r1 IBM    SERONYXP     1001 IBM  45444F43)
early_iounmap(ffff8100c7fcf700, 00000024)
early_iounmap(ffff8100c7fcf700, 0000003c)
ACPI: FACP C7FCF640, 0084 (r2 IBM    SERONYXP     1001 IBM  45444F43)
early_iounmap(ffff8100c7fcf640, 00000024)
early_iounmap(ffff8100c7fcf640, 00000084)
ACPI: DSDT C7FCAE00, 4168 (r2 IBM    SERGEODE     1000 INTL 20041203)
early_iounmap(ffff8100c7fcae00, 00000024)
ACPI: FACS C7FCF500, 0040
early_iounmap(ffff8100c7fcf500, 00000024)
ACPI: APIC C7FCF580, 009C (r1 IBM    SERONYXP     1001 IBM  45444F43)
early_iounmap(ffff8100c7fcf580, 00000024)
ACPI: MCFG C7FCF540, 003C (r1 IBM    SERONYXP     1001 IBM  45444F43)
early_iounmap(ffff8100c7fcf540, 00000024)
early_iounmap(ffff8100c7fcae00, 00000024)
early_iounmap(ffff8100c7fcae00, 00000024)
early_iounmap(ffff8100c7fcae00, 00000024)
early_iounmap(ffff8100c7fcae00, 00000024)
No NUMA configuration found
Faking a node at 0000000000000000-0000000238000000
Entering add_active_range(0, 0, 157) 0 entries of 3200 used
Entering add_active_range(0, 256, 819146) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2326528) 2 entries of 3200 used
Bootmem setup node 0 0000000000000000-0000000238000000
early_ioremap(0000000000000000, 00000400) => -000002103443456
early_iounmap(ffffffff82a00000, 00000400)
early_ioremap(000000000009fc00, 00000400) => -000002102789120
early_iounmap(ffffffff82a9fc00, 00000400)
early_ioremap(00000000000f0000, 00010000) => -000002102460416
early_iounmap(ffffffff82af0000, 00010000)
early_ioremap(000000000000040e, 00000002) => -000002103442418
early_iounmap(ffffffff82a0040e, 00000002)
early_ioremap(000000000009dc00, 00001000) => -000002102797312
early_iounmap(ffffffff82a9dc00, 00001000)
DEBUG crash_base = 2000000 crash_size = 8000000
hm, page 02a9d000 reserved twice.
crashkernel reservation failed - memory is in use
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002e00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810003200000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004600000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004a00000 on node 0
 [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004e00000 on node 0
 [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810005200000 on node 0
 [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005600000 on node 0
 [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005a00000 on node 0
 [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005e00000 on node 0
 [ffffe20002600000-ffffe200027fffff] PMD ->ffff810006200000 on node 0
 [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006600000 on node 0
 [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006a00000 on node 0
 [ffffe20003800000-ffffe200039fffff] PMD ->ffff810006e00000 on node 0
 [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810007200000 on node 0
 [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810007600000 on node 0
 [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810007a00000 on node 0
 [ffffe20004000000-ffffe200041fffff] PMD ->ffff810007e00000 on node 0
 [ffffe20004200000-ffffe200043fffff] PMD ->ffff810008200000 on node 0
 [ffffe20004400000-ffffe200045fffff] PMD ->ffff810008600000 on node 0
 [ffffe20004600000-ffffe200047fffff] PMD ->ffff810008a00000 on node 0
 [ffffe20004800000-ffffe200049fffff] PMD ->ffff810008e00000 on node 0
 [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff810009200000 on node 0
 [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff810009600000 on node 0
 [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff810009a00000 on node 0
 [ffffe20005000000-ffffe200051fffff] PMD ->ffff810009e00000 on node 0
 [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000a200000 on node 0
 [ffffe20005400000-ffffe200055fffff] PMD ->ffff81000a600000 on node 0
 [ffffe20005600000-ffffe200057fffff] PMD ->ffff81000aa00000 on node 0
 [ffffe20005800000-ffffe200059fffff] PMD ->ffff81000ae00000 on node 0
 [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff81000b200000 on node 0
 [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff81000b600000 on node 0
 [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff81000ba00000 on node 0
 [ffffe20006000000-ffffe200061fffff] PMD ->ffff81000be00000 on node 0
 [ffffe20006200000-ffffe200063fffff] PMD ->ffff81000c200000 on node 0
 [ffffe20006400000-ffffe200065fffff] PMD ->ffff81000c600000 on node 0
 [ffffe20006600000-ffffe200067fffff] PMD ->ffff81000ca00000 on node 0
 [ffffe20006800000-ffffe200069fffff] PMD ->ffff81000ce00000 on node 0
 [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000d200000 on node 0
 [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000d600000 on node 0
 [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000da00000 on node 0
 [ffffe20007000000-ffffe200071fffff] PMD ->ffff81000de00000 on node 0
 [ffffe20007200000-ffffe200073fffff] PMD ->ffff81000e200000 on node 0
 [ffffe20007400000-ffffe200075fffff] PMD ->ffff81000e600000 on node 0
 [ffffe20007600000-ffffe200077fffff] PMD ->ffff81000ea00000 on node 0
 [ffffe20007800000-ffffe200079fffff] PMD ->ffff81000ee00000 on node 0
 [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff81000f200000 on node 0
 [ffffe20007c00000-ffffe20007dfffff] PMD ->ffff81000f600000 on node 0
sizeof(struct page) = 56
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2326528
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0:        0 ->      157
    0:      256 ->   819146
    0:  1048576 ->  2326528
On node 0 totalpages: 2096999
  DMA zone: 56 pages used for memmap
  DMA zone: 1959 pages reserved
  DMA zone: 1982 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 800770 pages, LIFO batch:31
  Normal zone: 17472 pages used for memmap
  Normal zone: 1260480 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x588
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 13, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0c] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 12, address 0xfec80400, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at cc000000 (gap: c8000000:36c00000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 66848 bytes of per cpu data
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2063232
Policy zone: Normal
Kernel command line: root=/dev/sdd1 console=tty0 console=ttyS0,38400 crashkernel=128M@32M selinux=0
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized

<< Rest of the log messages were removed >>

--------------080006030209040204000908--
