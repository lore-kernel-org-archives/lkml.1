Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXFJMJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXFJMJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 08:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbXFJMJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 08:09:43 -0400
Received: from bay2-f252.bay2.hotmail.com ([65.54.246.77]:48773 "EHLO
	bay0-omc1-s5.bay0.hotmail.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752141AbXFJMJm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 08:09:42 -0400
Message-ID: <BAY103-DAV160F003E4B6DBCE103C7C9B21B0@phx.gbl>
X-Originating-IP: [85.41.109.158]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <BAY103-DAV1066400DF0615AD677EA1B2730@phx.gbl> <20070316012520.GN5743@melbourne.sgi.com> <BAY103-DAV13EC09E9BCB3E8C9D5EEA2B2710@phx.gbl> <20070316195951.GB5743@melbourne.sgi.com> <BAY103-DAV1484A3797D5368C28969CBB2700@phx.gbl> <BAY103-DAV9C465F21C87A900314523B2760@phx.gbl> <20070320064632.GO32602149@melbourne.sgi.com> <BAY103-DAV7076D9B4230E07680B724B2260@phx.gbl> <20070607130505.GE85884050@sgi.com> <BAY103-DAV141D991980E54836534A00B2250@phx.gbl> <a781481a0706100005wf6b1e4ercfd94d9f4a80bbb@mail.gmail.com>
Subject: Re: XFS internal error xfs_da_do_buf(2) at line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd
Date: Sun, 10 Jun 2007 14:20:52 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2180
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
X-OriginalArrivalTime: 10 Jun 2007 12:09:41.0731 (UTC) FILETIME=[39B9FB30:01C7AB58]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:

> Hi,

ciao

> On 6/8/07, Marco Berizzi <pupilla@hotmail.com> wrote:
>> After few hours linux has crashed with this message:
>> BUG: at arch/i386/kernel/smp.c:546 smp_call_function()
> 
> Which kernel (exactly) was this

2.6.21.3

>  and does this occur
> reproducibly?

I don't know. I try to explain. With all debugging options
enabled 2.6.21.x has never crashed. After two days 2.6.21.3
was running without any debug options, it has crashed.
Tomorrow morning I will start that linux box with linux 2.6.21.3
without any debug options, and I will keep you informed
(friday evening I have switched back to 2.6.21.3 with debug
options enabled, so the machine doesn't crash during the week
end: this system is my company firewall.)

> Also, could you please send the dmesg,

Jun 4 20:53:05 Pleiadi kernel: sanitize start
Jun 4 20:53:05 Pleiadi kernel: sanitize end
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 0000000000000000
size: 000000000009ac00 end: 000000000009ac00 type: 1
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000000009ac00
size: 0000000000005400 end: 00000000000a0000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000000ce000
size: 0000000000002000 end: 00000000000d0000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000000e0000
size: 0000000000020000 end: 0000000000100000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 0000000000100000
size: 000000003fdf0000 end: 000000003fef0000 type: 1
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003fef0000
size: 000000000000b000 end: 000000003fefb000 type: 3
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003fefb000
size: 0000000000005000 end: 000000003ff00000 type: 4
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003ff00000
size: 0000000000080000 end: 000000003ff80000 type: 1
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() type is E820_RAM
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 000000003ff80000
size: 0000000000080000 end: 0000000040000000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000e0000000
size: 0000000010000000 end: 00000000f0000000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fec00000
size: 0000000000100400 end: 00000000fed00400 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fee00000
size: 0000000000100000 end: 00000000fef00000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000ffb00000
size: 0000000000100000 end: 00000000ffc00000 type: 2
Jun 4 20:53:05 Pleiadi kernel: copy_e820_map() start: 00000000fff00000
size: 0000000000100000 end: 0000000100000000 type: 2
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 0000000000000000 -
000000000009ac00 (usable)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000000009ac00 -
00000000000a0000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000000ce000 -
00000000000d0000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000000e0000 -
0000000000100000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 0000000000100000 -
000000003fef0000 (usable)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003fef0000 -
000000003fefb000 (ACPI data)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003fefb000 -
000000003ff00000 (ACPI NVS)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003ff00000 -
000000003ff80000 (usable)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 000000003ff80000 -
0000000040000000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000e0000000 -
00000000f0000000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fec00000 -
00000000fed00400 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fee00000 -
00000000fef00000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000ffb00000 -
00000000ffc00000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: BIOS-e820: 00000000fff00000 -
0000000100000000 (reserved)
Jun 4 20:53:05 Pleiadi kernel: Zone PFN ranges:
Jun 4 20:53:05 Pleiadi kernel: DMA 0 -> 4096
Jun 4 20:53:05 Pleiadi kernel: Normal 4096 -> 229376
Jun 4 20:53:05 Pleiadi kernel: HighMem 229376 -> 262016
Jun 4 20:53:05 Pleiadi kernel: early_node_map[1] active PFN ranges
Jun 4 20:53:05 Pleiadi kernel: 0: 0 -> 262016
Jun 4 20:53:05 Pleiadi kernel: ACPI: RSDP 000F6BA0, 0024 (r2 PTLTD )
Jun 4 20:53:05 Pleiadi kernel: ACPI: XSDT 3FEF5381, 004C (r1 PTLTD ^I
XSDT 6040001 LTP 0)
Jun 4 20:53:05 Pleiadi kernel: ACPI: FACP 3FEF5441, 00F4 (r3 FSC
6040001 F4240)
Jun 4 20:53:05 Pleiadi kernel: ACPI: DSDT 3FEF5535, 597B (r1 FSC
D1649 6040001 MSFT 2000002)
Jun 4 20:53:05 Pleiadi kernel: ACPI: FACS 3FEFBFC0, 0040
Jun 4 20:53:05 Pleiadi kernel: ACPI: SPCR 3FEFAEB0, 0050 (r1 PTLTD
$UCRTBL$ 6040001 PTL 1)
Jun 4 20:53:05 Pleiadi kernel: ACPI: MCFG 3FEFAF00, 0040 (r1 PTLTD
MCFG 6040001 LTP 0)
Jun 4 20:53:05 Pleiadi kernel: ACPI: APIC 3FEFAF40, 0098 (r1 PTLTD ^I
APIC 6040001 LTP 0)
Jun 4 20:53:05 Pleiadi kernel: ACPI: BOOT 3FEFAFD8, 0028 (r1 PTLTD
$SBFTBL$ 6040001 LTP 1)
Jun 4 20:53:05 Pleiadi kernel: Processor #0 15:4 APIC version 20
Jun 4 20:53:05 Pleiadi kernel: Processor #1 15:4 APIC version 20
Jun 4 20:53:05 Pleiadi kernel: IOAPIC[0]: apic_id 2, version 32,
address 0xfec00000, GSI 0-23
Jun 4 20:53:05 Pleiadi kernel: IOAPIC[1]: apic_id 3, version 32,
address 0xfec80000, GSI 24-47
Jun 4 20:53:05 Pleiadi kernel: IOAPIC[2]: apic_id 4, version 32,
address 0xfec80800, GSI 48-71
Jun 4 20:53:05 Pleiadi kernel: IOAPIC[3]: apic_id 5, version 32,
address 0xfec84000, GSI 72-95
Jun 4 20:53:05 Pleiadi kernel: IOAPIC[4]: apic_id 6, version 32,
address 0xfec84800, GSI 96-119
Jun 4 20:53:05 Pleiadi kernel: Enabling APIC mode: Flat. Using 5 I/O
APICs
Jun 4 20:53:05 Pleiadi kernel: Allocating PCI resources starting at
50000000 (gap: 40000000:a0000000)
Jun 4 20:53:05 Pleiadi kernel: Built 1 zonelists. Total pages: 259969
Jun 4 20:53:05 Pleiadi kernel: PID hash table entries: 4096 (order: 12,
16384 bytes)
Jun 4 20:53:05 Pleiadi kernel: Detected 3200.428 MHz processor.
Jun 4 20:53:05 Pleiadi kernel: Console: colour VGA+ 80x25
Jun 4 20:53:05 Pleiadi kernel: Dentry cache hash table entries: 131072
(order: 7, 524288 bytes)
Jun 4 20:53:05 Pleiadi kernel: Inode-cache hash table entries: 65536
(order: 6, 262144 bytes)
Jun 4 20:53:05 Pleiadi kernel: virtual kernel memory layout:
Jun 4 20:53:05 Pleiadi kernel: fixmap : 0xfff9d000 - 0xfffff000
( 392 kB)
Jun 4 20:53:05 Pleiadi kernel: pkmap : 0xff800000 - 0xffc00000
(4096 kB)
Jun 4 20:53:05 Pleiadi kernel: vmalloc : 0xf8800000 - 0xff7fe000
( 111 MB)
Jun 4 20:53:05 Pleiadi kernel: lowmem : 0xc0000000 - 0xf8000000
( 896 MB)
Jun 4 20:53:05 Pleiadi kernel: .init : 0xc039f000 - 0xc03ce000
( 188 kB)
Jun 4 20:53:05 Pleiadi kernel: .data : 0xc02fd400 - 0xc0398114
( 619 kB)
Jun 4 20:53:05 Pleiadi kernel: .text : 0xc0100000 - 0xc02fd400
(2037 kB)
Jun 4 20:53:05 Pleiadi kernel: Checking if this processor honours the
WP bit even in supervisor mode... Ok.
Jun 4 20:53:05 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6403.78 BogoMIPS (lpj=32018905)
Jun 4 20:53:05 Pleiadi kernel: Mount-cache hash table entries: 512
Jun 4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
Jun 4 20:53:05 Pleiadi kernel: using mwait in idle threads.
Jun 4 20:53:05 Pleiadi kernel: CPU0: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Jun 4 20:53:05 Pleiadi kernel: Booting processor 1/1 eip 2000
Jun 4 20:53:05 Pleiadi kernel: Calibrating delay using timer specific
routine.. 6400.45 BogoMIPS (lpj=32002267)
Jun 4 20:53:05 Pleiadi kernel: monitor/mwait feature present.
Jun 4 20:53:05 Pleiadi kernel: CPU1: Intel(R) Xeon(TM) CPU 3.20GHz
stepping 0a
Jun 4 20:53:05 Pleiadi kernel: ENABLING IO-APIC IRQs
Jun 4 20:53:05 Pleiadi kernel: migration_cost=142
Jun 4 20:53:05 Pleiadi kernel: Setting up standard PCI resources
Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [PS2M] status [00000008]:
functional but not present; setting present
Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [ECP] status [00000008]:
functional but not present; setting present
Jun 4 20:53:05 Pleiadi kernel: ACPI: Device [COM1] status [00000008]:
functional but not present; setting present
Jun 4 20:53:05 Pleiadi kernel: PCI quirk: region f000-f07f claimed by
ICH4 ACPI/GPIO/TCO
Jun 4 20:53:05 Pleiadi kernel: PCI quirk: region f180-f1bf claimed by
ICH4 GPIO
Jun 4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Jun 4 20:53:05 Pleiadi kernel: PCI: PXH quirk detected, disabling MSI
for SHPC device
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3
4 5 6 7 9 10 *11 12 14 15)
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3
4 5 6 7 *9 10 11 12 14 15)
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3
4 *5 6 7 9 10 11 12 14 15)
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3
4 5 6 7 9 *10 11 12 14 15)
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3
4 5 6 7 9 10 11 12 14 15) *0, disabled.
Jun 4 20:53:05 Pleiadi kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3
*4 5 6 7 9 10 11 12 14 15)
Jun 4 20:53:05 Pleiadi kernel: IP route cache hash table entries: 32768
(order: 5, 131072 bytes)
Jun 4 20:53:05 Pleiadi kernel: TCP established hash table entries:
131072 (order: 8, 1572864 bytes)
Jun 4 20:53:05 Pleiadi kernel: TCP bind hash table entries: 65536
(order: 7, 524288 bytes)
Jun 4 20:53:05 Pleiadi kernel: highmem bounce pool size: 64 pages
Jun 4 20:53:05 Pleiadi kernel: PNP: PS/2 controller doesn't have AUX
irq; using default 12
Jun 4 20:53:05 Pleiadi kernel: nf_conntrack version 0.5.0 (8188
buckets, 65504 max)
Jun 4 20:53:05 Pleiadi kernel: ip_tables: (C) 2000-2006 Netfilter Core
Team
Jun 4 20:53:05 Pleiadi kernel: Using IPI Shortcut mode
Jun 4 20:53:05 Pleiadi kernel: VFS: Mounted root (xfs filesystem)
readonly.

> stack trace, etc for when this happened?

I have only a monitor bitmap. Tell me if you want it.

