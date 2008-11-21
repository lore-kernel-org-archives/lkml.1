Return-Path: <linux-kernel-owner+w=401wt.eu-S1755571AbYKUNSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571AbYKUNSL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:18:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbYKUNRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:17:44 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:53454 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbYKUNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:17:42 -0500
Message-ID: <4926B375.2030902@linux.vnet.ibm.com>
Date: Fri, 21 Nov 2008 18:41:17 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: chandru@linux.vnet.ibm.com, sachinp@linux.vnet.ibm.com
Subject: Problem while booting kdump kernel on IBM x3500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

We are seeing a problem with kdump on IBM x3500 box. The kdump kernel is
panicking. The call trace is consistent in each time.

This is the serial console log for 2.6.28-rc5 kernel.

mx3500:~ # echo c > /proc/sysrq-trigger
SysRq : Trigger a crashdump
BIOS EBDA/lowmem at: 0009c400/0009c400
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.28-rc5-2-default (root@mx3500) (gcc version 4.3.2
[gcc-4_3-branch revision 141291] (SUSE Linux) ) #1 SMP Tue Nov 18
18:28:35 IST 2008
Command line: root=/dev/disk/by-id/scsi-SServeRA_Label_1_C94BBDA8-part1
resume=/dev/disk/by-id/scsi-SServeRA_Label_1_C94BBDA8-part3
splash=silent earlyprintk=serial,ttyS0,38400 irqpoll maxcpus=1
memmap=exactmap memmap=640K@0K memmap=130412K@66176K elfcorehdr=196588K
memmap=40K#3145088K memmap=88K#3145128K
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000100 - 000000000009c400 (usable)
 BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d6000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bff60000 (usable)
 BIOS-e820: 00000000bff60000 - 00000000bff6a000 (ACPI data)
 BIOS-e820: 00000000bff6a000 - 00000000bff80000 (ACPI NVS)
 BIOS-e820: 00000000bff80000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
console [earlyser0] enabled
last_pfn = 0x140000 max_arch_pfn = 0x3ffffffff
user-defined physical RAM map:
 user: 0000000000000000 - 00000000000a0000 (usable)
 user: 00000000040a0000 - 000000000bffb000 (usable)
 user: 00000000bff60000 - 00000000bff80000 (ACPI data)
DMI present.
last_pfn = 0xbffb max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
init_memory_mapping: 0000000000000000-000000000bffb000
last_map_addr: bffb000 end: bffb000
RAMDISK: 0b446000 - 0bfee6bd
ACPI: RSDP 000F6710, 0014 (r0 PTLTD )
ACPI: RSDT BFF63C23, 003C (r1 PTLTD    RSDT    6040000  LTP        0)
ACPI: FACP BFF69E48, 0074 (r1 INTEL            6040000 PTL         3)
ACPI: DSDT BFF6504B, 4DFD (r1  Intel BLAKFORD  6040000 MSFT  100000E)
ACPI: FACS BFF6AFC0, 0040
ACPI: APIC BFF69EBC, 0090 (r1 PTLTD       APIC    6040000  LTP        0)
ACPI: MCFG BFF69F4C, 003C (r1 PTLTD    MCFG    6040000  LTP        0)
ACPI: BOOT BFF69F88, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SPCR BFF69FB0, 0050 (r1 PTLTD  $UCRTBL$  6040000 PTL         1)
ACPI: SSDT BFF63C5F, 13EC (r1  PmRef    CpuPm     3000 INTL 20050228)
(6 early reservations) ==> bootmem [0000000000 - 000bffb000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 -
0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 -
0000008000]
  #2 [0004200000 - 00048e9618]    TEXT DATA BSS ==> [0004200000 -
00048e9618]
  #3 [000b446000 - 000bfee6bd]          RAMDISK ==> [000b446000 -
000bfee6bd]
  #4 [000009c400 - 0000100000]    BIOS reserved ==> [000009c400 -
0000100000]
  #5 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 -
0000009000]
found SMP MP-table at [ffff8800000f6740] 000f6740
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x000000a0
    0: 0x000040a0 -> 0x0000bffb
PANIC: early exception 02 rip 10:ffffffff803fab70 error 0 cr2
7f1a7915b000
Pid: 0, comm: swapper Not tainted 2.6.28-rc5-2-default #1
Call Trace:
 [<ffffffff80797195>] early_idt_handler+0x55/0x69
 [<ffffffff803fab70>] ? read_pci_config_16+0x47/0x98
 [<ffffffff807a14c2>] early_quirks+0x33/0x127
 [<ffffffff8079c028>] setup_arch+0x698/0x730
 [<ffffffff807979d7>] start_kernel+0x77/0x45c
 [<ffffffff80797296>] x86_64_start_reservations+0xa5/0xa9
 [<ffffffff80797392>] x86_64_start_kernel+0xd5/0xdc
RIP 0x10

Any suggestions / solutions ?

Thank you in advance,
Ciju


