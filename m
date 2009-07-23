Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZGWMUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZGWMUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 08:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbZGWMUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 08:20:47 -0400
Received: from leia.mcbone.net ([194.97.104.42]:60678 "EHLO leia.mcbone.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZGWMUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 08:20:44 -0400
Subject: early_ioremap messages with old ASUS board
From: Jens Rosenboom <jens@leia.mcbone.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Confused
Date: Thu, 23 Jul 2009 14:20:34 +0200
Message-Id: <1248351634.7237.32.camel@fnki-nb00130>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running 2.6.31-rc4 I get the following dmesg output:

[    0.000000] Linux version 2.6.31-rc4 (root@easy) (gcc version 4.4.0
(GCC) ) #36 SMP PREEMPT Thu Jul 23 10:06:21 CEST 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003fffd000 (usable)
[    0.000000]  BIOS-e820: 000000003fffd000 - 000000003ffff000 (ACPI
data)
[    0.000000]  BIOS-e820: 000000003ffff000 - 0000000040000000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ffff0000 - 0000000100000000
(reserved)
[    0.000000] early_ioremap(000f0000, 00010000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c156194e>] dmi_scan_machine+0x1a/0x1af
[    0.000000]  [<c15404c5>] ? parse_early_options+0x23/0x25
[    0.000000]  [<c1543d92>] setup_arch+0x3d0/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000000 + ffe00000
[    0.000000] DMI 2.0 present.
[    0.000000] early_ioremap(000f5afa, 0000041b) [1] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c1561a43>] dmi_scan_machine+0x10f/0x1af
[    0.000000]  [<c1543d92>] setup_arch+0x3d0/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000afa + ffe40000
[    0.000000] early_iounmap(ffe40afa, 0000041b) [1]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c1561a7d>] dmi_scan_machine+0x149/0x1af
[    0.000000]  [<c1561c45>] ? dmi_decode+0x0/0x408
[    0.000000]  [<c1543d92>] setup_arch+0x3d0/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_iounmap(ffe00000, 00010000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c1561a95>] dmi_scan_machine+0x161/0x1af
[    0.000000]  [<c1561c45>] ? dmi_decode+0x0/0x408
[    0.000000]  [<c1543d92>] setup_arch+0x3d0/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] last_pfn = 0x3fffd max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-F7FFF uncachable
[    0.000000]   F8000-FCFFF write-protect
[    0.000000]   FD000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] initial memory mapped : 0 - 02000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000379fe000
[    0.000000]  0000000000 - 0000200000 page 4k
[    0.000000]  0000200000 - 0037800000 page 2M
[    0.000000]  0037800000 - 00379fe000 page 4k
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] ASUS P2B-DS detected: force use of acpi=ht
[    0.000000] early_ioremap(0000040e, 00000002) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c1194f5d>] acpi_find_root_pointer+0x1b/0x12a
[    0.000000]  [<c155bbd3>] acpi_os_get_root_pointer+0x15/0x1a
[    0.000000]  [<c155c84c>] acpi_initialize_tables+0x67/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 0000040e + ffe00000
[    0.000000] early_iounmap(ffe0040e, 00000002) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194f81>] acpi_find_root_pointer+0x3f/0x12a
[    0.000000]  [<c155bbd3>] acpi_os_get_root_pointer+0x15/0x1a
[    0.000000]  [<c155c84c>] acpi_initialize_tables+0x67/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(000e0000, 00020000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c1194ffc>] acpi_find_root_pointer+0xba/0x12a
[    0.000000]  [<c155bbd3>] acpi_os_get_root_pointer+0x15/0x1a
[    0.000000]  [<c155c84c>] acpi_initialize_tables+0x67/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000000 + ffe00000
[    0.000000] early_iounmap(ffe00000, 00020000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155bbd3>] acpi_os_get_root_pointer+0x15/0x1a
[    0.000000]  [<c155c84c>] acpi_initialize_tables+0x67/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(000f81a0, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c101faec>] ? native_set_fixmap+0x4c/0x60
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c155c87b>] acpi_tb_parse_root_table+0x15/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] ? acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 000001a0 + ffe00000
[    0.000000] ACPI: RSDP 000f81a0 00014 (v00 ASUS  )
[    0.000000] early_iounmap(ffe001a0, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c11947df>] ? acpi_tb_print_table_header+0x61/0x9e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c8cc>] acpi_tb_parse_root_table+0x66/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] ? acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c155c93e>] acpi_tb_parse_root_table+0xd8/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] ? acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000000 + ffe00000
[    0.000000] ACPI: RSDT 3fffd000 00030 (v01 ASUS   P2B-DS   58582E32
MSFT 31313031)
[    0.000000] early_iounmap(ffe00000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c960>] acpi_tb_parse_root_table+0xfa/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] ? acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd000, 00000030) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c155c990>] acpi_tb_parse_root_table+0x12a/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1195030>] ? acpi_find_root_pointer+0xee/0x12a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000000 + ffe00000
[    0.000000] early_iounmap(ffe00000, 00000030) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155ca99>] acpi_tb_parse_root_table+0x233/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd100, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c101fa91>] ? __native_set_fixmap+0x21/0x30
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119485e>] acpi_tb_install_table+0x42/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000100 + ffe00000
[    0.000000] ACPI: FACP 3fffd100 00074 (v01 ASUS   P2B-DS   58582E32
MSFT 31313031)
[    0.000000] early_iounmap(ffe00100, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd100, 00000074) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c1194ea3>] acpi_tb_parse_fadt+0x1a/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000100 + ffe00000
[    0.000000] early_iounmap(ffe00100, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194ec2>] acpi_tb_parse_fadt+0x39/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd180, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c101fa91>] ? __native_set_fixmap+0x21/0x30
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119485e>] acpi_tb_install_table+0x42/0x121
[    0.000000]  [<c1194ed3>] acpi_tb_parse_fadt+0x4a/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000180 + ffe00000
[    0.000000] ACPI: DSDT 3fffd180 01DEE (v01   ASUS P2B-DS   00001000
MSFT 01000001)
[    0.000000] early_iounmap(ffe00180, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c1194ed3>] acpi_tb_parse_fadt+0x4a/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3ffff000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119485e>] acpi_tb_install_table+0x42/0x121
[    0.000000]  [<c1194ee7>] acpi_tb_parse_fadt+0x5e/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000000 + ffe00000
[    0.000000] ACPI: FACS 3ffff000 00040
[    0.000000] early_iounmap(ffe00000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c1194ee7>] acpi_tb_parse_fadt+0x5e/0x63
[    0.000000]  [<c155cacc>] acpi_tb_parse_root_table+0x266/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd040, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119485e>] acpi_tb_install_table+0x42/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000040 + ffe00000
[    0.000000] ACPI: BOOT 3fffd040 00028 (v01 ASUS   P2B-DS   58582E32
MSFT 31313031)
[    0.000000] early_iounmap(ffe00040, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119485e>] acpi_tb_install_table+0x42/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] ACPI: APIC 3fffd080 0005C (v01 ASUS   P2B-DS   58582E32
MSFT 31313031)
[    0.000000] early_iounmap(ffe00080, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c155cab4>] acpi_tb_parse_root_table+0x24e/0x2a6
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c155c85e>] acpi_initialize_tables+0x79/0x81
[    0.000000]  [<c155b50f>] acpi_table_init+0x17/0x8b
[    0.000000]  [<c15499e0>] acpi_boot_table_init+0x31/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd040, 00000028) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c135a7d9>] ? acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194935>] ? acpi_tb_install_table+0x119/0x121
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c15493a0>] ? acpi_parse_sbf+0x0/0x2a
[    0.000000]  [<c155b5cd>] acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c155b534>] ? acpi_table_init+0x3c/0x8b
[    0.000000]  [<c1549a1f>] acpi_boot_table_init+0x70/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000040 + ffe00000
[    0.000000] early_iounmap(ffe00040, 00000028) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c15493a0>] ? acpi_parse_sbf+0x0/0x2a
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] acpi_table_parse+0x66/0x6f
[    0.000000]  [<c1549a1f>] acpi_boot_table_init+0x70/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd180, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c1006c5a>] ? show_trace+0x1a/0x20
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119407d>] acpi_get_table_header+0x5c/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c15493a0>] ? acpi_parse_sbf+0x0/0x2a
[    0.000000]  [<c154a16d>] ? __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] ? early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] ? acpi_table_parse+0x66/0x6f
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000180 + ffe00000
[    0.000000] early_iounmap(ffe00180, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194096>] acpi_get_table_header+0x75/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd180, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119407d>] acpi_get_table_header+0x5c/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000180 + ffe00000
[    0.000000] early_iounmap(ffe00180, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194096>] acpi_get_table_header+0x75/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd180, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119407d>] acpi_get_table_header+0x5c/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000180 + ffe00000
[    0.000000] early_iounmap(ffe00180, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194096>] acpi_get_table_header+0x75/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd180, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c155132d>] ? early_iounmap+0x100/0x15e
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119407d>] acpi_get_table_header+0x5c/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000180 + ffe00000
[    0.000000] early_iounmap(ffe00180, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c135a7d9>] acpi_os_unmap_memory+0x18/0x1a
[    0.000000]  [<c1194096>] acpi_get_table_header+0x75/0x99
[    0.000000]  [<c155b72e>] acpi_blacklisted+0x24/0x108
[    0.000000]  [<c1549a24>] acpi_boot_table_init+0x75/0xce
[    0.000000]  [<c154423a>] setup_arch+0x878/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c154984f>] ? acpi_parse_madt+0x0/0x66
[    0.000000]  [<c155b5cd>] acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c154960d>] early_acpi_boot_init+0x31/0xd1
[    0.000000]  [<c154423f>] setup_arch+0x87d/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154984f>] ? acpi_parse_madt+0x0/0x66
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] acpi_table_parse+0x66/0x6f
[    0.000000]  [<c154960d>] early_acpi_boot_init+0x31/0xd1
[    0.000000]  [<c154423f>] setup_arch+0x87d/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c154a16d>] ? __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549074>] ? acpi_parse_lapic_addr_ovr+0x0/0x30
[    0.000000]  [<c1549630>] early_acpi_boot_init+0x54/0xd1
[    0.000000]  [<c154423f>] setup_arch+0x87d/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549074>] ? acpi_parse_lapic_addr_ovr+0x0/0x30
[    0.000000]  [<c1549630>] early_acpi_boot_init+0x54/0xd1
[    0.000000]  [<c154423f>] setup_arch+0x87d/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 133MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 0 - 379fe000
[    0.000000]   node 0 low ram: 00000000 - 379fe000
[    0.000000]   node 0 bootmap 00009000 - 0000ff40
[    0.000000] (8 early reservations) ==> bootmem [0000000000 -
00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0001000000 - 0001b064dc]    TEXT DATA BSS ==>
[0001000000 - 0001b064dc]
[    0.000000]   #4 [000009f000 - 0000100000]    BIOS reserved ==>
[000009f000 - 0000100000]
[    0.000000]   #5 [0001b07000 - 0001b17184]              BRK ==>
[0001b07000 - 0001b17184]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==>
[0000007000 - 0000009000]
[    0.000000]   #7 [0000009000 - 0000010000]          BOOTMAP ==>
[0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f6ef0] f6ef0
[    0.000000] early_ioremap(000f6ae4, 00001000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154b92d>] get_mpc_size+0x16/0x4d
[    0.000000]  [<c1554178>] ? reserve_bootmem+0x20/0x22
[    0.000000]  [<c154ba4b>] smp_scan_config+0xe7/0x132
[    0.000000]  [<c154bae8>] __find_smp_config+0x52/0x71
[    0.000000]  [<c154bb14>] find_smp_config+0xd/0xf
[    0.000000]  [<c1544251>] setup_arch+0x88f/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000ae4 + ffe00000
[    0.000000] early_iounmap(ffe00ae4, 00001000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154b93b>] get_mpc_size+0x24/0x4d
[    0.000000]  [<c1554178>] ? reserve_bootmem+0x20/0x22
[    0.000000]  [<c154ba4b>] smp_scan_config+0xe7/0x132
[    0.000000]  [<c154bae8>] __find_smp_config+0x52/0x71
[    0.000000]  [<c154bb14>] find_smp_config+0xd/0xf
[    0.000000]  [<c1544251>] setup_arch+0x88f/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0003fffd
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0003fffd
[    0.000000] On node 0 totalpages: 262045
[    0.000000] free_area_init_node: node 0, pgdat c151a8a0, node_mem_map
c1b18000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3948 pages, LIFO batch:0
[    0.000000]   Normal zone: 2841 pages used for memmap
[    0.000000]   Normal zone: 220901 pages, LIFO batch:31
[    0.000000]   HighMem zone: 436 pages used for memmap
[    0.000000]   HighMem zone: 33867 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] early_ioremap(3fffd040, 00000028) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c15493a0>] ? acpi_parse_sbf+0x0/0x2a
[    0.000000]  [<c155b5cd>] acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c1549d4f>] acpi_boot_init+0x3c/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000040 + ffe00000
[    0.000000] early_iounmap(ffe00040, 00000028) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c15493a0>] ? acpi_parse_sbf+0x0/0x2a
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] acpi_table_parse+0x66/0x6f
[    0.000000]  [<c1549d4f>] acpi_boot_init+0x3c/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd100, 00000074) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c1549353>] ? acpi_parse_fadt+0x0/0x4d
[    0.000000]  [<c155b5cd>] acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c1549d5e>] acpi_boot_init+0x4b/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000100 + ffe00000
[    0.000000] ACPI: PM-Timer IO Port: 0xe408
[    0.000000] early_iounmap(ffe00100, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c1549353>] ? acpi_parse_fadt+0x0/0x4d
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] acpi_table_parse+0x66/0x6f
[    0.000000]  [<c1549d5e>] acpi_boot_init+0x4b/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c154984f>] ? acpi_parse_madt+0x0/0x66
[    0.000000]  [<c155b5cd>] acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c1549d6d>] acpi_boot_init+0x5a/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154984f>] ? acpi_parse_madt+0x0/0x66
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b5e9>] acpi_table_parse+0x66/0x6f
[    0.000000]  [<c1549d6d>] acpi_boot_init+0x5a/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c154a16d>] ? __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549074>] ? acpi_parse_lapic_addr_ovr+0x0/0x30
[    0.000000]  [<c1549d90>] acpi_boot_init+0x7d/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549074>] ? acpi_parse_lapic_addr_ovr+0x0/0x30
[    0.000000]  [<c1549d90>] acpi_boot_init+0x7d/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15497e2>] ? acpi_parse_sapic+0x0/0x6d
[    0.000000]  [<c1549dc5>] acpi_boot_init+0xb2/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15497e2>] ? acpi_parse_sapic+0x0/0x6d
[    0.000000]  [<c1549dc5>] acpi_boot_init+0xb2/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549731>] ? acpi_parse_x2apic+0x0/0x33
[    0.000000]  [<c1549ddf>] acpi_boot_init+0xcc/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549731>] ? acpi_parse_x2apic+0x0/0x33
[    0.000000]  [<c1549ddf>] acpi_boot_init+0xcc/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549788>] ? acpi_parse_lapic+0x0/0x5a
[    0.000000]  [<c1549df2>] acpi_boot_init+0xdf/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c1179ef7>] ? acpi_table_print_madt_entry+0x67/0x1ec
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c1549788>] ? acpi_parse_lapic+0x0/0x5a
[    0.000000]  [<c1549df2>] acpi_boot_init+0xdf/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15496ef>] ? acpi_parse_x2apic_nmi+0x0/0x42
[    0.000000]  [<c1549e33>] acpi_boot_init+0x120/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15496ef>] ? acpi_parse_x2apic_nmi+0x0/0x42
[    0.000000]  [<c1549e33>] acpi_boot_init+0x120/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(3fffd080, 0000005c) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    0.000000]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    0.000000]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    0.000000]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    0.000000]  [<c155b646>] acpi_table_parse_entries+0x54/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15496ad>] ? acpi_parse_lapic_nmi+0x0/0x42
[    0.000000]  [<c1549e46>] acpi_boot_init+0x133/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000080 + ffe00000
[    0.000000] early_iounmap(ffe00080, 0000005c) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154a16d>] __acpi_unmap_table+0x10/0x12
[    0.000000]  [<c155bbbc>] early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c155b6e8>] acpi_table_parse_entries+0xf6/0x100
[    0.000000]  [<c155b708>] acpi_table_parse_madt+0x16/0x18
[    0.000000]  [<c15496ad>] ? acpi_parse_lapic_nmi+0x0/0x42
[    0.000000]  [<c1549e46>] acpi_boot_init+0x133/0x35b
[    0.000000]  [<c1544279>] setup_arch+0x8b7/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] Using ACPI for processor (LAPIC) configuration
information
[    0.000000] Intel MultiProcessor Specification v1.1
[    0.000000]     Virtual Wire compatibility mode.
[    0.000000] early_ioremap(000f6ae4, 00001000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154b92d>] get_mpc_size+0x16/0x4d
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c154c21c>] __get_smp_config+0x2ec/0x576
[    0.000000]  [<c1540020>] ? __init_begin+0x20/0x82
[    0.000000]  [<c155bbbc>] ? early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c15498b5>] ? acpi_parse_hpet+0x0/0xfa
[    0.000000]  [<c155b5cd>] ? acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c154c4b0>] get_smp_config+0xa/0xc
[    0.000000]  [<c1544287>] setup_arch+0x8c5/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000ae4 + ffe00000
[    0.000000] early_iounmap(ffe00ae4, 00001000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154b93b>] get_mpc_size+0x24/0x4d
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c154c21c>] __get_smp_config+0x2ec/0x576
[    0.000000]  [<c1540020>] ? __init_begin+0x20/0x82
[    0.000000]  [<c155bbbc>] ? early_acpi_os_unmap_memory+0x11/0x13
[    0.000000]  [<c15498b5>] ? acpi_parse_hpet+0x0/0xfa
[    0.000000]  [<c155b5cd>] ? acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c154c4b0>] get_smp_config+0xa/0xc
[    0.000000]  [<c1544287>] setup_arch+0x8c5/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] early_ioremap(000f6ae4, 000000f4) [0] => Pid: 0, comm:
swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    0.000000]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    0.000000]  [<c154c22e>] __get_smp_config+0x2fe/0x576
[    0.000000]  [<c1540020>] ? __init_begin+0x20/0x82
[    0.000000]  [<c15498b5>] ? acpi_parse_hpet+0x0/0xfa
[    0.000000]  [<c155b5cd>] ? acpi_table_parse+0x4a/0x6f
[    0.000000]  [<c154c4b0>] get_smp_config+0xa/0xc
[    0.000000]  [<c1544287>] setup_arch+0x8c5/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] 00000ae4 + ffe00000
[    0.000000] MPTABLE: OEM ID: OEM00000
[    0.000000] MPTABLE: Product ID: PROD00000000
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] I/O APIC #2 Version 17 at 0xFEC00000.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] early_iounmap(ffe00ae4, 000000f4) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4 #36
[    0.000000] Call Trace:
[    0.000000]  [<c136e48b>] ? printk+0x18/0x1d
[    0.000000]  [<c15512c9>] early_iounmap+0x9c/0x15e
[    0.000000]  [<c154c432>] __get_smp_config+0x502/0x576
[    0.000000]  [<c1540020>] ? __init_begin+0x20/0x82
[    0.000000]  [<c15498b5>] ? acpi_parse_hpet+0x0/0xfa
[    0.000000]  [<c154c4b0>] get_smp_config+0xa/0xc
[    0.000000]  [<c1544287>] setup_arch+0x8c5/0x922
[    0.000000]  [<c1166e82>] ? __spin_lock_init+0x32/0x60
[    0.000000]  [<c1540897>] start_kernel+0x77/0x2da
[    0.000000]  [<c1540352>] i386_start_kernel+0x7c/0x83
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
40000000:bec00000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 11 pages at c2824000, static data 23292
bytes
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 258716
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6 ro root=900
panic=30 console=ttyS1,38400n8 console=tty0 early_ioremap_debug
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (000379fe:0003fffd)
[    0.000000] Memory: 1022280k/1048564k available (3530k kernel code,
25620k reserved, 1815k data, 344k init, 137212k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.000000]       .init : 0xc1540000 - 0xc1596000   ( 344 kB)
[    0.000000]       .data : 0xc1372b53 - 0xc1538888   (1815 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1372b53   (3530 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] NR_IRQS:512
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 400.917 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] console [ttyS1] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.004000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.004000] ... CHAINHASH_SIZE:          16384
[    0.004000]  memory used by lock dependency info: 3487 kB
[    0.004000]  per task-struct memory footprint: 1152 bytes
[    0.004105] Calibrating delay loop (skipped), value calculated using
timer frequency.. 801.83 BogoMIPS (lpj=1603668)
[    0.017007] Mount-cache hash table entries: 512
[    0.029037] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.036028] CPU: L2 cache: 512K
[    0.040038] mce: CPU supports 5 MCE banks
[    0.044135] Checking 'hlt' instruction... OK.
[    0.066164] Freeing SMP alternatives: 14k freed
[    0.073397] ExtINT not setup in hardware but reported by MP table
[    0.081270] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.126758] CPU0: Intel Pentium II (Deschutes) stepping 02
[    0.140347] lockdep: fixing up alternatives.
[    0.144644] Booting processor 1 APIC 0x0 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 801.90
BogoMIPS (lpj=1603811)
[    0.004000] CPU: L1 I cache: 16K, L1 D cache: 16K
[    0.004000] CPU: L2 cache: 512K
[    0.004000] mce: CPU supports 5 MCE banks
[    0.237018] CPU1: Intel Pentium II (Deschutes) stepping 02
[    0.248039] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.256075] Brought up 2 CPUs
[    0.260029] Total of 2 processors activated (1603.73 BogoMIPS).
[    0.264684] CPU0 attaching sched-domain:
[    0.264706]  domain 0: span 0-1 level CPU
[    0.264724]   groups: 0 1
[    0.268167] CPU1 attaching sched-domain:
[    0.268186]  domain 0: span 0-1 level CPU
[    0.268203]   groups: 1 0
[    0.276543] xor: measuring software checksum speed
[    0.300024]    8regs     :   698.000 MB/sec
[    0.324024]    8regs_prefetch:   625.000 MB/sec
[    0.348024]    32regs    :   351.000 MB/sec
[    0.372028]    32regs_prefetch:   331.000 MB/sec
[    0.396024]    pII_mmx   :  1037.000 MB/sec
[    0.420027]    p5_mmx    :  1055.000 MB/sec
[    0.424027] xor: using function: p5_mmx (1055.000 MB/sec)
[    0.429287] NET: Registered protocol family 16
[    0.440050] PCI: PCI BIOS revision 2.10 entry at 0xf0730, last bus=1
[    0.444025] PCI: Using configuration type 1 for base access
[    0.501028] bio: create slab <bio-0> at 0
[    0.505084] ACPI: Interpreter disabled.
[    0.513621] SCSI subsystem initialized
[    0.520371] libata version 3.00 loaded.
[    0.592421] raid6: int32x1     85 MB/s
[    0.664480] raid6: int32x2     87 MB/s
[    0.736283] raid6: int32x4     90 MB/s
[    0.808572] raid6: int32x8     81 MB/s
[    0.880193] raid6: mmxx1      229 MB/s
[    0.952158] raid6: mmxx2      272 MB/s
[    0.956030] raid6: using algorithm mmxx2 (272 MB/s)
[    0.960109] PCI: Probing PCI hardware
[    0.964143] PCI: Probing PCI hardware (bus 00)
[    0.964616] pci 0000:00:00.0: reg 10 32bit mmio:
[0xe4000000-0xe7ffffff]
[    0.968491] pci 0000:00:04.1: reg 20 io port: [0xd800-0xd80f]
[    0.968815] pci 0000:00:04.2: reg 20 io port: [0xd400-0xd41f]
[    0.969016] * Found PM-Timer Bug on the chipset. Due to workarounds
for a bug,
[    0.969027] * this clock source is slow. Consider trying other clock
sources
[    0.972271] pci 0000:00:04.3: quirk: region e400-e43f claimed by
PIIX4 ACPI
[    0.976041] pci 0000:00:04.3: quirk: region e800-e80f claimed by
PIIX4 SMB
[    0.980043] pci 0000:00:04.3: PIIX4 devres B PIO at 0290-0297
[    0.984278] pci 0000:00:06.0: reg 10 io port: [0xd000-0xd0ff]
[    0.984353] pci 0000:00:06.0: reg 14 64bit mmio:
[0xe3000000-0xe3000fff]
[    0.984473] pci 0000:00:06.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.984784] pci 0000:00:09.0: reg 10 32bit mmio:
[0xe2800000-0xe2800fff]
[    0.984833] pci 0000:00:09.0: reg 14 io port: [0xb800-0xb83f]
[    0.984880] pci 0000:00:09.0: reg 18 32bit mmio:
[0xe2000000-0xe20fffff]
[    0.984998] pci 0000:00:09.0: reg 30 32bit mmio: [0x000000-0x0fffff]
[    0.985113] pci 0000:00:09.0: supports D1 D2
[    0.985131] pci 0000:00:09.0: PME# supported from D0 D1 D2 D3hot
[    0.988042] pci 0000:00:09.0: PME# disabled
[    1.000731] pci 0000:00:04.0: PIIX/ICH IRQ router [8086:7110]
[    1.025480] pnp: PnP ACPI: disabled
[    1.071614] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.089614] pci 0000:00:01.0:   IO window: disabled
[    1.104525] pci 0000:00:01.0:   MEM window: disabled
[    1.119673] pci 0000:00:01.0:   PREFETCH window: disabled
[    1.136169] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    1.136192] pci_bus 0000:00: resource 1 mem:
[0x000000-0xffffffffffffffff]
[    1.136666] NET: Registered protocol family 2
[    1.151042] IP route cache hash table entries: 32768 (order: 5,
131072 bytes)
[    1.176339] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.204713] TCP bind hash table entries: 65536 (order: 9, 2097152
bytes)
[    1.275384] TCP: Hash tables configured (established 131072 bind
65536)
[    1.295697] TCP reno registered
[    1.306686] NET: Registered protocol family 1
[    1.322882] Simple Boot Flag at 0x46 set to 0x1
[    1.338742] platform rtc_cmos: registered platform RTC device (no PNP
device found)
[    1.374296] highmem bounce pool size: 64 pages
[    1.392150] msgmni has been set to 1729
[    1.407833] alg: No test for stdrng (krng)
[    1.420452] async_tx: api initialized (sync-only)
[    1.435034] io scheduler noop registered
[    1.447050] io scheduler anticipatory registered
[    1.461136] io scheduler deadline registered
[    1.474361] io scheduler cfq registered (default)
[    1.488753] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    1.507461] pci 0000:00:09.0: Firmware left e100 interrupts enabled;
disabling
[    1.532778] early_ioremap(3fffd080, 0000005c) [0] => Pid: 1, comm:
swapper Not tainted 2.6.31-rc4 #36
[    1.561007] Call Trace:
[    1.568638]  [<c136e48b>] ? printk+0x18/0x1d
[    1.581734]  [<c15513ff>] __early_ioremap+0x74/0x1e9
[    1.596898]  [<c15515aa>] early_ioremap+0x1a/0x1c
[    1.611270]  [<c154a187>] __acpi_map_table+0x18/0x1a
[    1.626451]  [<c135a7f8>] acpi_os_map_memory+0x1d/0x25
[    1.642129]  [<c119459c>] acpi_tb_verify_table+0x20/0x49
[    1.658321]  [<c1193e50>] acpi_get_table_with_size+0x53/0xa1
[    1.675553]  [<c1193eae>] acpi_get_table+0x10/0x15
[    1.690192]  [<c155cc19>] acpi_processor_init+0x23/0xab
[    1.706126]  [<c1001043>] do_one_initcall+0x33/0x180
[    1.721279]  [<c155cbf6>] ? acpi_processor_init+0x0/0xab
[    1.737479]  [<c106893a>] ? register_irq_proc+0xaa/0xc0
[    1.753411]  [<c10689b7>] ? init_irq_proc+0x67/0x80
[    1.768316]  [<c15405e7>] kernel_init+0x120/0x176
[    1.782678]  [<c15404c7>] ? kernel_init+0x0/0x176
[    1.797062]  [<c10038b7>] kernel_thread_helper+0x7/0x10
[    1.812984] 00000080 + ffe00000
[    2.060010] Switched to high resolution mode on CPU 0
[    2.060053] Switched to high resolution mode on CPU 1
[    2.338196] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.623917] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.907912] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    2.930178] Platform driver 'serial8250' needs updating - please use
dev_pm_ops
[    2.986099] brd: module loaded
[    2.995536] Uniform Multi-Platform E-IDE driver
[    3.010792] piix 0000:00:04.1: IDE controller (0x8086:0x7111 rev
0x01)
[    3.030991] piix 0000:00:04.1: not 100% native mode: will probe irqs
later
[    3.051915]     ide0: BM-DMA at 0xd800-0xd807
[    3.065528]     ide1: BM-DMA at 0xd808-0xd80f
[    3.078946] Probing IDE interface ide0...
[    3.364334] hda: WDC WD400BB-32CXA0, ATA DISK drive
[    4.049334] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    4.050259] hda: UDMA/33 mode selected
[    4.062712] Probing IDE interface ide1...
[    4.348331] hdc: WDC WD400BB-60JKA0, ATA DISK drive
[    5.032958] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    5.033111] hdc: UDMA/33 mode selected
[    5.044915] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    5.059777] ide1 at 0x170-0x177,0x376 on irq 15
[    5.081602] ide_generic: please use "probe_mask=0x3f" module
parameter for probing all legacy ISA IDE ports
[    5.111237] ide-gd driver 1.18
[    5.121233] hda: max request size: 128KiB
[    5.158376] hda: 78165360 sectors (40020 MB) w/2048KiB Cache,
CHS=65535/16/63
[    5.180317] hda: cache flushes not supported
[    5.194662]  hda: hda1 hda4 < hda5 hda6 hda7 hda8 hda9 hda10 hda11 >
[    5.282652] hdc: max request size: 128KiB
[    5.317286] hdc: 78165360 sectors (40020 MB) w/2048KiB Cache,
CHS=65535/16/63
[    5.339497] hdc: cache flushes supported
[    5.351950]  hdc: hdc1 hdc4 < hdc5 hdc6 hdc7 hdc8 hdc9 hdc10 hdc11 >
[    5.463672] aic7xxx 0000:00:06.0: can't find IRQ for PCI INT A;
probably buggy MP table
[   10.700237] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev
7.0
[   10.700248]         <Adaptec aic7890/91 Ultra2 SCSI adapter>
[   10.700256]         aic7890/91: Ultra2 Wide Channel A, SCSI Id=7,
32/253 SCBs
[   10.700265] 
[   14.630460] 3ware Storage Controller device driver for Linux
v1.26.02.002.
[   14.658692] Intel(R) PRO/1000 Network Driver - version 7.3.21-k3-NAPI
[   14.678268] Copyright (c) 1999-2006 Intel Corporation.
[   14.694717] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[   14.712738] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[   14.731381] Intel(R) Gigabit Ethernet Network Driver - version
1.3.16-k2
[   14.751759] Copyright (c) 2007-2009 Intel Corporation.
[   14.768118] jme: JMicron JMC2XX ethernet driver version 1.0.4
[   14.787041] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   14.805628] e100: Copyright(c) 1999-2006 Intel Corporation
[   14.822559] e100 0000:00:09.0: can't find IRQ for PCI INT A; probably
buggy MP table
[   14.872749] e100 0000:00:09.0: PME# disabled
[   14.887825] e100: eth0: e100_probe: addr 0xe2800000, irq 11, MAC addr
00:d0:b7:60:9e:e1
[   14.919282] PNP: No PS/2 controller found. Probing ports directly.
[   14.938323] Platform driver 'i8042' needs updating - please use
dev_pm_ops
[   15.212561] serio: i8042 KBD port at 0x60,0x64 irq 1
[   15.231207] mice: PS/2 mouse device common for all mice
[   15.247924] Driver for 1-wire Dallas network protocol.
[   15.265727] md: raid0 personality registered for level 0
[   15.281946] md: raid1 personality registered for level 1
[   15.298200] md: raid10 personality registered for level 10
[   15.314927] md: raid6 personality registered for level 6
[   15.331118] md: raid5 personality registered for level 5
[   15.347310] md: raid4 personality registered for level 4
[   15.363633] cpuidle: using governor ladder
[   15.376201] cpuidle: using governor menu
[   15.390373] TCP cubic registered
[   15.400332] NET: Registered protocol family 17
[   15.414135] Using IPI Shortcut mode
[   15.424871] ------------[ cut here ]------------
[   15.439028] WARNING: at arch/x86/mm/ioremap.c:603
check_early_ioremap_leak+0x56/0x69()
[   15.463165] Hardware name: System Name
[   15.474657] Debug warning: early ioremap leak of 1 areas detected.
[   15.493448] Modules linked in:
[   15.502979] Pid: 1, comm: swapper Not tainted 2.6.31-rc4 #36
[   15.520200] Call Trace:
[   15.527817]  [<c1031ddd>] warn_slowpath_common+0x6d/0xa0
[   15.544063]  [<c155108e>] ? check_early_ioremap_leak+0x56/0x69
[   15.561836]  [<c155108e>] ? check_early_ioremap_leak+0x56/0x69
[   15.579642]  [<c1031e56>] warn_slowpath_fmt+0x26/0x30
[   15.595056]  [<c155108e>] check_early_ioremap_leak+0x56/0x69
[   15.612293]  [<c1001043>] do_one_initcall+0x33/0x180
[   15.627446]  [<c1551038>] ? check_early_ioremap_leak+0x0/0x69
[   15.644946]  [<c106893a>] ? register_irq_proc+0xaa/0xc0
[   15.660899]  [<c10689b7>] ? init_irq_proc+0x67/0x80
[   15.675806]  [<c15405e7>] kernel_init+0x120/0x176
[   15.690213]  [<c15404c7>] ? kernel_init+0x0/0x176
[   15.704609]  [<c10038b7>] kernel_thread_helper+0x7/0x10
[   15.720583] ---[ end trace a0b1852c05553e7a ]---


