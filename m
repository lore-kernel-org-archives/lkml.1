Return-Path: <linux-kernel-owner+w=401wt.eu-S1760167AbYJMXCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760167AbYJMXCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 19:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbYJMXCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 19:02:12 -0400
Received: from smtp.ono.com ([62.42.230.12]:20477 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755092AbYJMXCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 19:02:09 -0400
Date: Tue, 14 Oct 2008 01:02:02 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.27-git3: rtl8169 oops and wireless missing symbols
Message-ID: <20081014010202.71d13eaf@werewolf.home>
X-Mailer: Claws Mail 3.6.1cvs2 (GTK+ 2.14.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi...

Booting .27-git3 on the Aspire One gave me a couple oopses.
And loading ath5k gives a lot of undefined symbols, looks like there
is a dependency missing somewhere. It happens the same trying to load
ath5k on a box that even does not that hardware:

werewolf:~# modprobe ath5k
WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
WARNING: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting ath5k (/lib/modules/2.6.27-jam03/kernel/drivers/net/wireless/ath5k/ath5k.ko): Unknown symbol in module, or unknown parameter (see dmesg)
werewolf:~# modprobe mac80211
WARNING: Error inserting cfg80211 (/lib/modules/2.6.27-jam03/kernel/net/wireless/cfg80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)
FATAL: Error inserting mac80211 (/lib/modules/2.6.27-jam03/kernel/net/mac80211/mac80211.ko): Unknown symbol in module, or unknown parameter (see dmesg)

Dmesg is below.

Linux version 2.6.27-jam03 (root@werewolf.home) (gcc version 4.3.2 (GCC) ) #1 SMP PREEMPT Mon Oct 13 17:55:46 CEST 2008
KERNEL supported cpus:
  Intel GenuineIntel
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f376000 (usable)
 BIOS-e820: 000000001f376000 - 000000001f3bf000 (reserved)
 BIOS-e820: 000000001f3bf000 - 000000001f46d000 (usable)
 BIOS-e820: 000000001f46d000 - 000000001f4bf000 (ACPI NVS)
 BIOS-e820: 000000001f4bf000 - 000000001f4f0000 (usable)
 BIOS-e820: 000000001f4f0000 - 000000001f4ff000 (ACPI data)
 BIOS-e820: 000000001f4ff000 - 000000001f500000 (usable)
 BIOS-e820: 000000001f500000 - 0000000020000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x1f500 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
original variable MTRRs
reg 0, base: 4194176KB, range: 128KB, type WP
reg 1, base: 4194048KB, range: 128KB, type UC
reg 2, base: 0GB, range: 256MB, type WB
reg 3, base: 256MB, range: 256MB, type WB
reg 4, base: 504MB, range: 8MB, type UC
reg 5, base: 502MB, range: 2MB, type UC
reg 6, base: 501MB, range: 1MB, type UC
reg 7, base: 0GB, range: 128KB, type UC
total RAM coverred: 501M
 gran_size: 64K 	chunk_size: 64K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 64K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 128K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 128K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 256K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 256K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 512K 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 512K 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 1M 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 2M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 4M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 8M 	num_reg: 8  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 16M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 64M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 128M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 256M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 512M 	num_reg: 4  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 1G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 1M 	chunk_size: 2G 	num_reg: 7  	lose cover RAM: 0G
 gran_size: 2M 	chunk_size: 2M 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 4M 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 32M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 64M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 128M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 2M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 4M 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 8M 	num_reg: 7  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 16M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 32M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 64M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 128M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 256M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 512M 	num_reg: 3  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 1G 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 4M 	chunk_size: 2G 	num_reg: 6  	lose cover RAM: 1M
 gran_size: 8M 	chunk_size: 8M 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 16M 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 32M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 64M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 8M 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 16M 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 32M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 64M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 1G 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 16M 	chunk_size: 2G 	num_reg: 5  	lose cover RAM: 5M
 gran_size: 32M 	chunk_size: 32M 	num_reg: 4  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 64M 	num_reg: 2  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 1G 	num_reg: 4  	lose cover RAM: 21M
 gran_size: 32M 	chunk_size: 2G 	num_reg: 4  	lose cover RAM: 21M
 gran_size: 64M 	chunk_size: 64M 	num_reg: 3  	lose cover RAM: 53M
 gran_size: 64M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 53M
 gran_size: 64M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 53M
 gran_size: 64M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 53M
 gran_size: 64M 	chunk_size: 1G 	num_reg: 3  	lose cover RAM: 53M
 gran_size: 64M 	chunk_size: 2G 	num_reg: 3  	lose cover RAM: 53M
 gran_size: 128M 	chunk_size: 128M 	num_reg: 2  	lose cover RAM: 117M
 gran_size: 128M 	chunk_size: 256M 	num_reg: 2  	lose cover RAM: 117M
 gran_size: 128M 	chunk_size: 512M 	num_reg: 2  	lose cover RAM: 117M
 gran_size: 128M 	chunk_size: 1G 	num_reg: 2  	lose cover RAM: 117M
 gran_size: 128M 	chunk_size: 2G 	num_reg: 2  	lose cover RAM: 117M
 gran_size: 256M 	chunk_size: 256M 	num_reg: 1  	lose cover RAM: 245M
 gran_size: 256M 	chunk_size: 512M 	num_reg: 1  	lose cover RAM: 245M
 gran_size: 256M 	chunk_size: 1G 	num_reg: 1  	lose cover RAM: 245M
 gran_size: 256M 	chunk_size: 2G 	num_reg: 1  	lose cover RAM: 245M
 gran_size: 512M 	chunk_size: 512M 	num_reg: 0  	lose cover RAM: 501M
 gran_size: 512M 	chunk_size: 1G 	num_reg: 0  	lose cover RAM: 501M
 gran_size: 512M 	chunk_size: 2G 	num_reg: 0  	lose cover RAM: 501M
 gran_size: 1G 	chunk_size: 1G 	num_reg: 0  	lose cover RAM: 501M
 gran_size: 1G 	chunk_size: 2G 	num_reg: 0  	lose cover RAM: 501M
 gran_size: 2G 	chunk_size: 2G 	num_reg: 0  	lose cover RAM: 501M
Found optimal setting for mtrr clean up
gran_size: 64K 	chunk_size: 16M 	num_reg: 4  	lose RAM: 0G
range0: 0000000000000000 - 0000000020000000
Setting variable MTRR 0, base: 0GB, range: 512MB, type WB
hole: 000000001f500000 - 0000000020000000
Setting variable MTRR 1, base: 501MB, range: 1MB, type UC
Setting variable MTRR 2, base: 502MB, range: 2MB, type UC
Setting variable MTRR 3, base: 504MB, range: 8MB, type UC
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 1f500000 @ 7000-d000
ACPI: RSDP 000FE020, 0024 (r2 INTEL )
ACPI: XSDT 1F4FE120, 0064 (r1 INTEL  Napa            1       1000013)
ACPI: FACP 1F4FC000, 00F4 (r4 INTEL  Napa            1 MSFT  1000013)
ACPI: DSDT 1F4F2000, 5DAE (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: FACS 1F488000, 0040
ACPI: SSDT 1F4FD000, 04C4 (r2  PmRef    CpuPm     3000 INTL 20051117)
ACPI: HPET 1F4FB000, 0038 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: APIC 1F4FA000, 0068 (r2 INTEL  Napa            1 MSFT  1000013)
ACPI: MCFG 1F4F9000, 003C (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: ASF! 1F4F8000, 00A5 (r32 INTEL  Napa            1 MSFT  1000013)
ACPI: SLIC 1F4F1000, 0180 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: BOOT 1F4F0000, 0028 (r1 INTEL  Napa            1 MSFT  1000013)
ACPI: DMI detected: Acer
0MB HIGHMEM available.
501MB LOWMEM available.
  mapped low ram: 0 - 1f500000
  low ram: 00000000 - 1f500000
  bootmap 00002000 - 00005ea0
(8 early reservations) ==> bootmem [0000000000 - 001f500000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000100000 - 0000519594]    TEXT DATA BSS ==> [0000100000 - 0000519594]
  #4 [000051a000 - 000051d000]    INIT_PG_TABLE ==> [000051a000 - 000051d000]
  #5 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
  #7 [0000002000 - 0000006000]          BOOTMAP ==> [0000002000 - 0000006000]
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x0001f500
  HighMem  0x0001f500 -> 0x0001f500
Movable zone start PFN for each node
early_node_map[5] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x0001f376
    0: 0x0001f3bf -> 0x0001f46d
    0: 0x0001f4bf -> 0x0001f4f0
    0: 0x0001f4ff -> 0x0001f500
On node 0 totalpages: 127989
free_area_init_node: node 0, pgdat c0463680, node_mem_map c1000000
  DMA zone: 3967 pages, LIFO batch:0
  Normal zone: 123020 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 000000001f376000 - 000000001f3bf000
PM: Registered nosave memory: 000000001f46d000 - 000000001f4bf000
PM: Registered nosave memory: 000000001f4f0000 - 000000001f4ff000
Allocating PCI resources starting at 30000000 (gap: 20000000:c0000000)
PERCPU: Allocating 31132 bytes of per cpu data
NR_CPUS: 4, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 126987
Kernel command line: BOOT_IMAGE=Linux root=/dev/sda1 ro enable_mtrr_cleanup video=vesafb:mtrr,ywrap resume=/dev/sda2 elevator=noop maxcpus=2 vga=788
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c04bd000 soft=c04b9000
PID hash table entries: 2048 (order: 11, 8192 bytes)
Fast TSC calibration using PIT
Detected 1595.973 MHz processor.
Console: colour dummy device 80x25
console [tty0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 502880k/513024k available (2597k kernel code, 8748k reserved, 933k data, 252k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff85000 - 0xfffff000   ( 488 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xdfd00000 - 0xff7fe000   ( 506 MB)
    lowmem  : 0xc0000000 - 0xdf500000   ( 501 MB)
      .init : 0xc0477000 - 0xc04b6000   ( 252 kB)
      .data : 0xc0389787 - 0xc0472d1c   ( 933 kB)
      .text : 0xc0100000 - 0xc0389787   (2597 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 3191.94 BogoMIPS (lpj=1595973)
Mount-cache hash table entries: 512
CPU: L1 I cache: 32K, L1 D cache: 24K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
CPU 1 irqstacks, hard=c04be000 soft=c04ba000
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3191.83 BogoMIPS (lpj=1595918)
CPU: L1 I cache: 32K, L1 D cache: 24K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Atom(TM) CPU N270   @ 1.60GHz stepping 02
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (6383.78 BogoMIPS).
net_namespace: 296 bytes
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: missing confirmations, switch off interrupt mode.
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:02.0 reg 10 32bit mmio: [38480000, 384fffff]
PCI: 0000:00:02.0 reg 14 io port: [60c0, 60c7]
PCI: 0000:00:02.0 reg 18 32bit mmio: [20000000, 2fffffff]
PCI: 0000:00:02.0 reg 1c 32bit mmio: [38500000, 3853ffff]
PCI: 0000:00:02.1 reg 10 32bit mmio: [38400000, 3847ffff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [38540000, 38543fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [6080, 609f]
PCI: 0000:00:1d.1 reg 20 io port: [6060, 607f]
PCI: 0000:00:1d.2 reg 20 io port: [6040, 605f]
PCI: 0000:00:1d.3 reg 20 io port: [6020, 603f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [38544400, 385447ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [60a0, 60af]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 20 io port: [6000, 601f]
PCI: bridge 0000:00:1c.0 io port: [5000, 5fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [37300000, 383fffff]
PCI: bridge 0000:00:1c.0 64bit mmio pref: [30000000, 30ffffff]
PCI: 0000:02:00.0 reg 10 io port: [3000, 30ff]
PCI: 0000:02:00.0 reg 18 32bit mmio: [31010000, 31010fff]
PCI: 0000:02:00.0 reg 20 32bit mmio: [31000000, 3100ffff]
PCI: 0000:02:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 io port: [3000, 4fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [36300000, 372fffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [31000000, 320fffff]
PCI: 0000:03:00.0 reg 10 64bit mmio: [35200000, 3520ffff]
PCI: bridge 0000:00:1c.2 io port: [2000, 2fff]
PCI: bridge 0000:00:1c.2 32bit mmio: [35200000, 362fffff]
PCI: bridge 0000:00:1c.2 64bit mmio pref: [32100000, 330fffff]
PCI: 0000:04:00.0 reg 10 32bit mmio: [34100300, 341003ff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [ffff8000, ffffffff]
PCI: 0000:04:00.2 reg 10 32bit mmio: [34100200, 341002ff]
PCI: 0000:04:00.3 reg 10 32bit mmio: [34100100, 341001ff]
PCI: 0000:04:00.4 reg 10 32bit mmio: [34100000, 341000ff]
PCI: bridge 0000:00:1c.3 io port: [1000, 1fff]
PCI: bridge 0000:00:1c.3 32bit mmio: [34100000, 351fffff]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [33100000, 340fffff]
pci 0000:00:1e.0: transparent bridge
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 11 12) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Switched to high resolution mode on CPU 0
tracer: 772 pages allocated for 65536 entries of 48 bytes
Switched to high resolution mode on CPU 1
   actual entries 65620
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:01: io resource (0x164e-0x164f) overlaps 0000:00:1c.3 BAR 7 (0x1000-0x1fff), disabling
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x200-0x20f has been reserved
system 00:01: ioport range 0x600-0x60f has been reserved
system 00:01: ioport range 0x610-0x610 has been reserved
system 00:01: ioport range 0x800-0x80f has been reserved
system 00:01: ioport range 0x400-0x47f has been reserved
system 00:01: ioport range 0x500-0x53f has been reserved
system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: 0x5000-0x5fff
pci 0000:00:1c.0:   MEM window: 0x37300000-0x383fffff
pci 0000:00:1c.0:   PREFETCH window: 0x00000030000000-0x00000030ffffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
pci 0000:00:1c.1:   MEM window: 0x36300000-0x372fffff
pci 0000:00:1c.1:   PREFETCH window: 0x00000031000000-0x000000320fffff
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.2:   IO window: 0x2000-0x2fff
pci 0000:00:1c.2:   MEM window: 0x35200000-0x362fffff
pci 0000:00:1c.2:   PREFETCH window: 0x00000032100000-0x000000330fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.3:   IO window: 0x1000-0x1fff
pci 0000:00:1c.3:   MEM window: 0x34100000-0x351fffff
pci 0000:00:1c.3:   PREFETCH window: 0x00000033100000-0x000000340fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: disabled
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffff]
bus: 01 index 0 io port: [5000, 5fff]
bus: 01 index 1 mmio: [37300000, 383fffff]
bus: 01 index 2 mmio: [30000000, 30ffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [3000, 4fff]
bus: 02 index 1 mmio: [36300000, 372fffff]
bus: 02 index 2 mmio: [31000000, 320fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [2000, 2fff]
bus: 03 index 1 mmio: [35200000, 362fffff]
bus: 03 index 2 mmio: [32100000, 330fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 io port: [1000, 1fff]
bus: 04 index 1 mmio: [34100000, 351fffff]
bus: 04 index 2 mmio: [33100000, 340fffff]
bus: 04 index 3 mmio: [0, 0]
bus: 05 index 0 mmio: [0, 0]
bus: 05 index 1 mmio: [0, 0]
bus: 05 index 2 mmio: [0, 0]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
NET: Registered protocol family 1
Simple Boot Flag value 0x5 read from CMOS RAM was invalid
Simple Boot Flag at 0x44 set to 0x1
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk> <peter.oruba@amd.com>
msgmni has been set to 982
io scheduler noop registered (default)
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.2: setting latency timer to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: framebuffer at 0x20000000, mapped to 0xdfd80000, using 1875k, total 7872k
vesafb: mode is 800x600x16, linelength=1600, pages=7
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 100x37
fb0: VESA VGA frame buffer device
ACPI: RTC can wake from S4
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
intel_rng: FWH not detected
Ethernet Channel Bonding Driver: v3.3.0 (June 10, 2008)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0x60a0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x60a8 irq 15
ata2.00: ATA-5: SSDPAMM0008G1EA, Ver2.I0H, max UDMA/66
ata2.00: 15761088 sectors, multi 0: LBA 
ata2.00: configured for UDMA/66
scsi 1:0:0:0: Direct-Access     ATA      SSDPAMM0008G1EA  Ver2 PQ: 0 ANSI: 5
sd 1:0:0:0: [sda] 15761088 512-byte hardware sectors: (3.77GB/3.51GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sda] 15761088 512-byte hardware sectors: (3.77GB/3.51GiB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 16, io mem 0x38544400
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 16, io base 0x00006080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb 1-5: new high speed USB device using ehci_hcd and address 3
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 17, io base 0x00006060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-5: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 2-1: new low speed USB device using uhci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.3: setting latency timer to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00006020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
i8042.c: Warning: Keylock active.
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04771/0xa40000
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio2/input/input1
dca service started, version 1.4
input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
Using IPI No-Shortcut mode
EXT4-fs warning (device sda1): ext4_fill_super: extents feature not enabled on this filesystem, use tune2fs.

VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 252k freed
cfg80211: Unknown parameter `ieee80211_regdom'
sd 1:0:0:0: Attached scsi generic sg0 type 0
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:02:00.0: setting latency timer to 64
BUG: unable to handle kernel NULL pointer dereference at 00000050
IP: [<dfd3af77>] :r8169:rtl_rar_set+0x45/0x5d
*pde = 00000000 
Oops: 0002 [#1] PREEMPT SMP 
Modules linked in: r8169(+) sg

Pid: 639, comm: modprobe Not tainted (2.6.27-jam03 #1) AOA110
EIP: 0060:[<dfd3af77>] EFLAGS: 00010046 CPU: 1
EIP is at rtl_rar_set+0x45/0x5d [r8169]
EAX: ffffffc0 EBX: 00000000 ECX: da89f480 EDX: 00000050
ESI: 00000000 EDI: 00000000 EBP: da89f4a0 ESP: de07cdd8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 639, ti=de07c000 task=dec857a0 task.ti=de07c000)
Stack: 000000cc decd1400 de07ce4c da89f480 dfd3e0c3 de07ce50 dfd3f16b dfd3f171 
       de8c6000 00000000 de286540 c0186072 de8c6000 c01b12eb de07ce3c de286540 
       de286540 da89f000 00000014 decd1400 dfd3e448 dfd24000 dfd24040 dfd24050 
Call Trace:
 [<dfd3e0c3>] rtl8169_init_one+0x843/0xaa9 [r8169]
 [<c0186072>] iput+0x1d/0x4a
 [<c01b12eb>] sysfs_addrm_finish+0x38/0x1e5
 [<c022607f>] pci_device_probe+0x40/0x5b
 [<c02785f6>] driver_probe_device+0x79/0x17d
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c0278750>] __driver_attach+0x56/0x58
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c027804c>] bus_for_each_dev+0x47/0x65
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c02784b6>] driver_attach+0x16/0x1a
 [<c02786fa>] __driver_attach+0x0/0x58
 [<c0277b3c>] bus_add_driver+0x192/0x1f9
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c027889d>] driver_register+0x5c/0x11e
 [<c0135f1e>] hrtimer_start+0xb5/0x17c
 [<dfd22000>] rtl8169_init_module+0x0/0x14 [r8169]
 [<c0226270>] __pci_register_driver+0x3c/0x7c
 [<dfd22000>] rtl8169_init_module+0x0/0x14 [r8169]
 [<c0101109>] _stext+0x21/0x129
 [<c0119985>] hrtick_start_fair+0x14d/0x163
 [<c011c59d>] check_preempt_wakeup+0x9e/0xb3
 [<c011cc37>] try_to_wake_up+0xaf/0x171
 [<c0142b41>] sys_init_module+0x7b/0x19e
 [<c01746d5>] sys_read+0x41/0x70
 [<c0103109>] sysenter_do_call+0x12/0x25
 =======================
Code: 02 09 c3 0f b6 42 03 c1 e0 18 09 c3 0f b6 7a 05 c1 e7 08 0f b6 42 04 09 c7 8d 69 20 89 e8 e8 7f d4 64 e0 8d 56 50 b8 c0 ff ff ff <88> 02 89 1e 83 c6 04 89 3e 31 c0 88 02 89 e8 5b 5e 5f 5d e9 a8 
EIP: [<dfd3af77>] rtl_rar_set+0x45/0x5d [r8169] SS:ESP 0068:de07cdd8
---[ end trace 3e229fe88afcf906 ]---
note: modprobe[639] exited with preempt_count 1
BUG: scheduling while atomic: modprobe/639/0x10000002
Modules linked in: r8169(+) sg
Pid: 639, comm: modprobe Tainted: G      D   2.6.27-jam03 #1
 [<c0386b3f>] schedule+0x375/0x803
 [<c01564b6>] __pagevec_free+0x1c/0x28
 [<c0159144>] release_pages+0x14b/0x18d
 [<c0136ec3>] __atomic_notifier_call_chain+0x46/0x4d
 [<c0136ee1>] atomic_notifier_call_chain+0x17/0x1b
 [<c011eefd>] __cond_resched+0x13/0x28
 [<c0387075>] _cond_resched+0x2b/0x37
 [<c015f610>] unmap_vmas+0x4fb/0x5bd
 [<c026ec52>] vt_console_print+0x0/0x2fd
 [<c01219f4>] __call_console_drivers+0x53/0x5f
 [<c01626ee>] exit_mmap+0x7c/0x110
 [<c011f942>] mmput+0x1e/0x80
 [<c0122eb8>] exit_mm+0xea/0x114
 [<c0124599>] do_exit+0x11c/0x7a5
 [<c0386567>] printk+0x17/0x20
 [<c0386567>] printk+0x17/0x20
 [<c010422e>] oops_begin+0x0/0x7e
 [<c011501d>] do_page_fault+0x100/0x6e3
 [<c011898c>] task_tick_fair+0x2f/0x85
 [<c013555f>] hrtimer_forward+0xe5/0x118
 [<c0108522>] read_tsc+0x6/0x2d
 [<c01386de>] getnstimeofday+0x3b/0xd7
 [<c011061d>] lapic_next_event+0x10/0x13
 [<c013b7cf>] clockevents_program_event+0x98/0x11e
 [<c013c736>] tick_dev_program_event+0x31/0x9f
 [<c013c7f8>] tick_program_event+0x24/0x2a
 [<c013633b>] hrtimer_interrupt+0x194/0x1c1
 [<c0125d24>] irq_exit+0x42/0x44
 [<c0110d00>] smp_apic_timer_interrupt+0x59/0x84
 [<c0314868>] pci_conf1_read+0xa4/0xce
 [<c0315cfc>] raw_pci_read+0x6c/0x73
 [<c0315da2>] pci_read+0x2a/0x30
 [<c0114f1d>] do_page_fault+0x0/0x6e3
 [<c03889ba>] error_code+0x72/0x78
 [<dfd3af77>] rtl_rar_set+0x45/0x5d [r8169]
 [<dfd3e0c3>] rtl8169_init_one+0x843/0xaa9 [r8169]
 [<c0186072>] iput+0x1d/0x4a
 [<c01b12eb>] sysfs_addrm_finish+0x38/0x1e5
 [<c022607f>] pci_device_probe+0x40/0x5b
 [<c02785f6>] driver_probe_device+0x79/0x17d
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c0278750>] __driver_attach+0x56/0x58
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c027804c>] bus_for_each_dev+0x47/0x65
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c02784b6>] driver_attach+0x16/0x1a
 [<c02786fa>] __driver_attach+0x0/0x58
 [<c0277b3c>] bus_add_driver+0x192/0x1f9
 [<c0225ff6>] pci_device_remove+0x0/0x36
 [<c027889d>] driver_register+0x5c/0x11e
 [<c0135f1e>] hrtimer_start+0xb5/0x17c
 [<dfd22000>] rtl8169_init_module+0x0/0x14 [r8169]
 [<c0226270>] __pci_register_driver+0x3c/0x7c
 [<dfd22000>] rtl8169_init_module+0x0/0x14 [r8169]
 [<c0101109>] _stext+0x21/0x129
 [<c0119985>] hrtick_start_fair+0x14d/0x163
 [<c011c59d>] check_preempt_wakeup+0x9e/0xb3
 [<c011cc37>] try_to_wake_up+0xaf/0x171
 [<c0142b41>] sys_init_module+0x7b/0x19e
 [<c01746d5>] sys_read+0x41/0x70
 [<c0103109>] sysenter_do_call+0x12/0x25
 =======================
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, hpet irqs
ACPI: AC Adapter [ACAD] (on-line)
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input4
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input5
ACPI: SSDT 1F380C90, 0239 (r2  PmRef  Cpu0Ist     3000 INTL 20051117)
ACPI: SSDT 1F37FE10, 01C7 (r2  PmRef  Cpu0Cst     3001 INTL 20051117)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 1F380F10, 00D0 (r2  PmRef  Cpu1Ist     3000 INTL 20051117)
ACPI: SSDT 1F37EF10, 0083 (r2  PmRef  Cpu1Cst     3000 INTL 20051117)
ACPI: Lid Switch [LID0]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input6
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
Linux agpgart interface v0.103
ACPI: Sleep Button (CM) [SLPB]
mac80211: Unknown symbol wiphy_register
mac80211: Unknown symbol wiphy_new
mac80211: Unknown symbol wiphy_unregister
mac80211: Unknown symbol ieee80211_radiotap_iterator_init
mac80211: Unknown symbol __ieee80211_get_channel
mac80211: Unknown symbol ieee80211_radiotap_iterator_next
mac80211: Unknown symbol ieee80211_channel_to_frequency
mac80211: Unknown symbol ieee80211_frequency_to_channel
mac80211: Unknown symbol wiphy_free
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
ath5k: Unknown symbol ieee80211_free_hw
ath5k: Unknown symbol ieee80211_alloc_hw
ath5k: Unknown symbol ieee80211_register_hw
ath5k: Unknown symbol ieee80211_get_hdrlen_from_skb
ath5k: Unknown symbol ieee80211_generic_frame_duration
ath5k: Unknown symbol __ieee80211_get_tx_led_name
ath5k: Unknown symbol __ieee80211_get_rx_led_name
ath5k: Unknown symbol ieee80211_wake_queues
ath5k: Unknown symbol __ieee80211_rx
ath5k: Unknown symbol ieee80211_tx_status
ath5k: Unknown symbol ieee80211_stop_queue
ath5k: Unknown symbol ieee80211_stop_queues
ath5k: Unknown symbol ieee80211_unregister_hw
ath5k: Unknown symbol ieee80211_hdrlen
ath5k: Unknown symbol ieee80211_beacon_get
ath5k: Unknown symbol ieee80211_frequency_to_channel
Marking TSC unstable due to possible TSC halt in C2
ACPI: Battery Slot [BAT1] (battery present)
ACPI: WMI: Mapper loaded
Clocksource tsc unstable (delta = -208580844 ns)


-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP
