Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142Ab0BER2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 12:28:18 -0500
Received: from mail-iw0-f189.google.com ([209.85.223.189]:54677 "EHLO
	mail-iw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab0BER2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 12:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sHy2b0PfrA0uIaeb9sBSzNeB1K/VPlYK6JyXVcPgEnYq4Vy1QmDmSqCnjeW66xDfvC
         tUqBF/mR1VWq3IYs3eCdVuitalw/oXABS+gGYwcUFyaOJzhye8PNMEYWcga0v5U77lFK
         cosV7WmayK6zShtSEt7sRlAPpwoN0pesTcsKo=
MIME-Version: 1.0
Date: Fri, 5 Feb 2010 09:28:12 -0800
Message-ID: <dd18b0c31002050928u1f01cfe8kd9c1504d729b0942@mail.gmail.com>
Subject: early_ioremap_debug=1 gives a bunch of Call Traces
From: Justin Mattock <justinmattock@gmail.com>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cant seem to find an ioremap mailing list
to send too, so I'll just send post dmesg to linux-acpi
(since I'm seeing acpi in the trace)and CC lkml.

using early_ioremap_debug=1 is giving a mess load of
call traces.(not sure if this is normal or not).

[    0.000000] Linux version 2.6.33-rc5 (name@name) (gcc version 4.4.2
(GCC) ) #2 SMP Fri Jan 22 20:42:35 PST 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.33-rc5
root=/dev/sda1 ro debug audit=1 selinux=1 video=efifb vga=791
enforcing=0 early_ioremap_debug=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] early_ioremap(000f0000, 00010000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816a7d76>] dmi_scan_machine+0x76/0xe5
[    0.000000]  [<ffffffff81681ca0>] setup_arch+0x38d/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] DMI 2.4 present.
[    0.000000] early_ioremap(000e0000, 000005a2) [1] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816a7cb9>] dmi_present+0xe2/0x129
[    0.000000]  [<ffffffff816a7d92>] dmi_scan_machine+0x92/0xe5
[    0.000000]  [<ffffffff81681ca0>] setup_arch+0x38d/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff440000
[    0.000000] early_iounmap(ffffffffff440000, 000005a2) [1]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff816a7cf0>] dmi_present+0x119/0x129
[    0.000000]  [<ffffffff816a7d92>] dmi_scan_machine+0x92/0xe5
[    0.000000]  [<ffffffff81681ca0>] setup_arch+0x38d/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_iounmap(ffffffffff400000, 00010000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff816a7dad>] dmi_scan_machine+0xad/0xe5
[    0.000000]  [<ffffffff81681ca0>] setup_arch+0x38d/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 03FF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003f0ea000
[    0.000000]  0000000000 - 003f000000 page 2M
[    0.000000]  003f000000 - 003f0ea000 page 4k
[    0.000000] kernel direct mapping tables up to 3f0ea000 @ 8000-b000
[    0.000000] early_ioremap(00008000, 00001000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690ba8>] early_memremap+0x13/0x15
[    0.000000]  [<ffffffff813d6619>] alloc_low_page+0x6e/0x8b
[    0.000000]  [<ffffffff816b06f7>] phys_pmd_init+0x1b7/0x284
[    0.000000]  [<ffffffff813ea925>] ? _raw_spin_unlock_irqrestore+0x1b/0x1f
[    0.000000]  [<ffffffff816b08ca>] phys_pud_init+0x106/0x2a8
[    0.000000]  [<ffffffff8105b65a>] ? vprintk+0x347/0x374
[    0.000000]  [<ffffffff816b0b2f>] kernel_physical_mapping_init+0xc3/0x1af
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8105b0be>] ? release_console_sem+0x192/0x1c3
[    0.000000]  [<ffffffff813d6449>] init_memory_mapping+0x419/0x57b
[    0.000000]  [<ffffffff81683cb0>] ? reserve_early+0x30/0x38
[    0.000000]  [<ffffffff81681e12>] setup_arch+0x4ff/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00001000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff813d664d>] unmap_low_page+0x17/0x19
[    0.000000]  [<ffffffff816b0726>] phys_pmd_init+0x1e6/0x284
[    0.000000]  [<ffffffff816b08ca>] phys_pud_init+0x106/0x2a8
[    0.000000]  [<ffffffff8105b65a>] ? vprintk+0x347/0x374
[    0.000000]  [<ffffffff816b0b2f>] kernel_physical_mapping_init+0xc3/0x1af
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8105b0be>] ? release_console_sem+0x192/0x1c3
[    0.000000]  [<ffffffff813d6449>] init_memory_mapping+0x419/0x57b
[    0.000000]  [<ffffffff81683cb0>] ? reserve_early+0x30/0x38
[    0.000000]  [<ffffffff81681e12>] setup_arch+0x4ff/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(0000040e, 00000002) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81683cb0>] ? reserve_early+0x30/0x38
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124ff7a>] acpi_find_root_pointer+0x3a/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 0000040e + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff40040e, 00000002) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124ffd7>] acpi_find_root_pointer+0x97/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(0009fc00, 00000400) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124fff1>] acpi_find_root_pointer+0xb1/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000c00 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400c00, 00000400) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff812506ed>] ? acpi_ut_ptr_exit+0x36/0x3e
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff81250066>] acpi_find_root_pointer+0x126/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(000e0000, 00020000) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff812500a4>] acpi_find_root_pointer+0x164/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00020000) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff812506ed>] ? acpi_ut_ptr_exit+0x36/0x3e
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff81250111>] acpi_find_root_pointer+0x1d1/0x254
[    0.000000]  [<ffffffff816a11c5>] acpi_os_get_root_pointer+0x4e/0x54
[    0.000000]  [<ffffffff816a2549>] acpi_initialize_tables+0x98/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(000fe020, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff8125194f>] ? acpi_ut_validate_exception+0x10/0xa2
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a25eb>] acpi_tb_parse_root_table+0x3e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000020 + ffffffffff400000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] early_iounmap(ffffffffff400020, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a265d>] acpi_tb_parse_root_table+0xb0/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefd1c0, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a2670>] acpi_tb_parse_root_table+0xc3/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 000001c0 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff4001c0, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a2686>] acpi_tb_parse_root_table+0xd9/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefd1c0, 00000074) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a269a>] acpi_tb_parse_root_table+0xed/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 000001c0 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff4001c0, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a26d4>] acpi_tb_parse_root_table+0x127/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefd1c0, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a26eb>] acpi_tb_parse_root_table+0x13e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 000001c0 + ffffffffff400000
[    0.000000] ACPI: XSDT 000000003fefd1c0 00074 (v01 APPLE   Apple00
000000A5      01000013)
[    0.000000] early_iounmap(ffffffffff4001c0, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a273d>] acpi_tb_parse_root_table+0x190/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefd1c0, 00000074) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a279b>] acpi_tb_parse_root_table+0x1ee/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 000001c0 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff4001c0, 00000074) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff816a28be>] acpi_tb_parse_root_table+0x311/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefb000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: FACP 000000003fefb000 000F4 (v03 APPLE   Apple00
000000A5 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefb000, 000000f4) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124fda5>] acpi_tb_parse_fadt+0x2c/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 000000f4) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124fdce>] acpi_tb_parse_fadt+0x55/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff8124fde3>] acpi_tb_parse_fadt+0x6a/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: DSDT 000000003fef0000 048D1 (v01 APPLE  MacBookP
00020002 INTL 20050309)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff8124fde3>] acpi_tb_parse_fadt+0x6a/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fec0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff8124fdfb>] acpi_tb_parse_fadt+0x82/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: FACS 000000003fec0000 00040
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff8124fdfb>] acpi_tb_parse_fadt+0x82/0x8b
[    0.000000]  [<ffffffff816a28f6>] acpi_tb_parse_root_table+0x349/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fefa000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: HPET 000000003fefa000 00038 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: APIC 000000003fef9000 00068 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef8000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: MCFG 000000003fef8000 0003C (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef7000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: ASF! 000000003fef7000 000A0 (v32 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef6000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: SBST 000000003fef6000 00030 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef5000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: ECDT 000000003fef5000 00053 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3feef000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: SSDT 000000003feef000 004DC (v01 APPLE     CpuPm
00003000 INTL 20050309)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3febd000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: SSDT 000000003febd000 0064F (v01 SataRe  SataPri
00001000 INTL 20050309)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3febc000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f5ea>] acpi_tb_install_table+0x55/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: SSDT 000000003febc000 0069C (v01 SataRe  SataSec
00001000 INTL 20050309)
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f6e2>] acpi_tb_install_table+0x14d/0x15a
[    0.000000]  [<ffffffff816a28db>] acpi_tb_parse_root_table+0x32e/0x3ac
[    0.000000]  [<ffffffff81250143>] ? acpi_find_root_pointer+0x203/0x254
[    0.000000]  [<ffffffff816a2580>] acpi_initialize_tables+0xcf/0xfc
[    0.000000]  [<ffffffff816a096c>] acpi_table_init+0x1b/0x99
[    0.000000]  [<ffffffff8168827a>] acpi_boot_table_init+0x27/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e825>] acpi_get_table_header+0x62/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81687c45>] ? acpi_parse_sbf+0x0/0x2c
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e849>] acpi_get_table_header+0x86/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e825>] acpi_get_table_header+0x62/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e849>] acpi_get_table_header+0x86/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e825>] acpi_get_table_header+0x62/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e849>] acpi_get_table_header+0x86/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef0000, 00000024) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690d08>] ? early_iounmap+0x149/0x198
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e825>] acpi_get_table_header+0x62/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000024) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff813d7d13>] acpi_os_unmap_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124e849>] acpi_get_table_header+0x86/0xac
[    0.000000]  [<ffffffff816a0c14>] acpi_blacklisted+0x45/0x15b
[    0.000000]  [<ffffffff81688296>] acpi_boot_table_init+0x43/0x98
[    0.000000]  [<ffffffff81682092>] setup_arch+0x77f/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168809b>] ? acpi_parse_madt+0x0/0x65
[    0.000000]  [<ffffffff816a0a47>] acpi_table_parse+0x5d/0x84
[    0.000000]  [<ffffffff81687e3a>] early_acpi_boot_init+0x37/0xdc
[    0.000000]  [<ffffffff81682097>] setup_arch+0x784/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168809b>] ? acpi_parse_madt+0x0/0x65
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0a65>] acpi_table_parse+0x7b/0x84
[    0.000000]  [<ffffffff81687e3a>] early_acpi_boot_init+0x37/0xdc
[    0.000000]  [<ffffffff81682097>] setup_arch+0x784/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029aca>] ? show_trace_log_lvl+0x4f/0x58
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168786f>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81687e62>] early_acpi_boot_init+0x5f/0xdc
[    0.000000]  [<ffffffff81682097>] setup_arch+0x784/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168786f>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81687e62>] early_acpi_boot_init+0x5f/0xdc
[    0.000000]  [<ffffffff81682097>] setup_arch+0x784/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 003f0ea000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00017b0f88]    TEXT DATA BSS ==>
[0001000000 - 00017b0f88]
[    0.000000]   #2 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #3 [00017b1000 - 00017b1271]              BRK ==>
[00017b1000 - 00017b1271]
[    0.000000]   #4 [0000001000 - 0000003000]       TRAMPOLINE ==>
[0000001000 - 0000003000]
[    0.000000]   #5 [0000003000 - 0000007000]      ACPI WAKEUP ==>
[0000003000 - 0000007000]
[    0.000000]   #6 [0000008000 - 0000009000]          PGTABLE ==>
[0000008000 - 0000009000]
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD ->
[ffff880001c00000-ffff8800029fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3839 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3476 pages used for memmap
[    0.000000]   DMA32 zone: 250710 pages, LIFO batch:31
[    0.000000] early_ioremap(3fefb000, 000000f4) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687bf6>] ? acpi_parse_fadt+0x0/0x4f
[    0.000000]  [<ffffffff816a0a47>] acpi_table_parse+0x5d/0x84
[    0.000000]  [<ffffffff81688569>] acpi_boot_init+0x54/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] early_iounmap(ffffffffff400000, 000000f4) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81687bf6>] ? acpi_parse_fadt+0x0/0x4f
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0a65>] acpi_table_parse+0x7b/0x84
[    0.000000]  [<ffffffff81688569>] acpi_boot_init+0x54/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168809b>] ? acpi_parse_madt+0x0/0x65
[    0.000000]  [<ffffffff816a0a47>] acpi_table_parse+0x5d/0x84
[    0.000000]  [<ffffffff8168857c>] acpi_boot_init+0x67/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168809b>] ? acpi_parse_madt+0x0/0x65
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0a65>] acpi_table_parse+0x7b/0x84
[    0.000000]  [<ffffffff8168857c>] acpi_boot_init+0x67/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029aca>] ? show_trace_log_lvl+0x4f/0x58
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168786f>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885a4>] acpi_boot_init+0x8f/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168786f>] ? acpi_parse_lapic_addr_ovr+0x0/0x2e
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885a4>] acpi_boot_init+0x8f/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168800e>] ? acpi_parse_sapic+0x0/0x4c
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885d8>] acpi_boot_init+0xc3/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168800e>] ? acpi_parse_sapic+0x0/0x4c
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885d8>] acpi_boot_init+0xc3/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687f6d>] ? acpi_parse_x2apic+0x0/0x36
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885f5>] acpi_boot_init+0xe0/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81687f6d>] ? acpi_parse_x2apic+0x0/0x36
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816885f5>] acpi_boot_init+0xe0/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687fcb>] ? acpi_parse_lapic+0x0/0x43
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8168860a>] acpi_boot_init+0xf5/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff813e5b59>] ? generic_processor_info+0x163/0x16c
[    0.000000]  [<ffffffff81687fcb>] ? acpi_parse_lapic+0x0/0x43
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8168860a>] acpi_boot_init+0xf5/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687f26>] ? acpi_parse_x2apic_nmi+0x0/0x47
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688647>] acpi_boot_init+0x132/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81687f26>] ? acpi_parse_x2apic_nmi+0x0/0x47
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688647>] acpi_boot_init+0x132/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687edf>] ? acpi_parse_lapic_nmi+0x0/0x47
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8168865c>] acpi_boot_init+0x147/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81687edf>] ? acpi_parse_lapic_nmi+0x0/0x47
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff8168865c>] acpi_boot_init+0x147/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff8168805a>] ? acpi_parse_ioapic+0x0/0x41
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816886d5>] acpi_boot_init+0x1c0/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff8168cdea>] ? mp_register_ioapic+0xf7/0x108
[    0.000000]  [<ffffffff8168805a>] ? acpi_parse_ioapic+0x0/0x41
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff816886d5>] acpi_boot_init+0x1c0/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff81029ae3>] ? show_trace+0x10/0x12
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81688377>] ? acpi_parse_int_src_ovr+0x0/0xe8
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688712>] acpi_boot_init+0x1fd/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688377>] ? acpi_parse_int_src_ovr+0x0/0xe8
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688712>] acpi_boot_init+0x1fd/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] early_ioremap(3fef9000, 00000068) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff8105b65a>] ? vprintk+0x347/0x374
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81687fa3>] ? acpi_parse_nmi_src+0x0/0x28
[    0.000000]  [<ffffffff816a0ae2>] acpi_table_parse_entries+0x74/0x142
[    0.000000]  [<ffffffff8103872c>] ? save_mp_irq+0x26/0x67
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688794>] acpi_boot_init+0x27f/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] early_iounmap(ffffffffff400000, 00000068) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81687fa3>] ? acpi_parse_nmi_src+0x0/0x28
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0b9f>] acpi_table_parse_entries+0x131/0x142
[    0.000000]  [<ffffffff816a0bcd>] acpi_table_parse_madt+0x1d/0x1f
[    0.000000]  [<ffffffff81688794>] acpi_boot_init+0x27f/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] early_ioremap(3fefa000, 00000038) [0] => Pid: 0, comm:
swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff816909e4>] __early_ioremap+0x77/0x228
[    0.000000]  [<ffffffff8105b65a>] ? vprintk+0x347/0x374
[    0.000000]  [<ffffffff81690bbd>] early_ioremap+0x13/0x15
[    0.000000]  [<ffffffff816888af>] __acpi_map_table+0x17/0x19
[    0.000000]  [<ffffffff813d7d2e>] acpi_os_map_memory+0x19/0x1b
[    0.000000]  [<ffffffff8124f0e5>] acpi_tb_verify_table+0x44/0xbe
[    0.000000]  [<ffffffff8124e4c7>] acpi_get_table_with_size+0x55/0xaf
[    0.000000]  [<ffffffff81688100>] ? acpi_parse_hpet+0x0/0x153
[    0.000000]  [<ffffffff816a0a47>] acpi_table_parse+0x5d/0x84
[    0.000000]  [<ffffffff81688848>] acpi_boot_init+0x333/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] 00000000 + ffffffffff400000
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] early_iounmap(ffffffffff400000, 00000038) [0]
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.33-rc5 #2
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81690c60>] early_iounmap+0xa1/0x198
[    0.000000]  [<ffffffff81688100>] ? acpi_parse_hpet+0x0/0x153
[    0.000000]  [<ffffffff81688896>] __acpi_unmap_table+0x13/0x15
[    0.000000]  [<ffffffff816a1175>] early_acpi_os_unmap_memory+0x12/0x14
[    0.000000]  [<ffffffff816a0a65>] acpi_table_parse+0x7b/0x84
[    0.000000]  [<ffffffff81688848>] acpi_boot_init+0x333/0x36e
[    0.000000]  [<ffffffff816820e1>] setup_arch+0x7ce/0x851
[    0.000000]  [<ffffffff813e7e86>] ? printk+0x3c/0x3e
[    0.000000]  [<ffffffff8107f088>] ? clockevents_register_notifier+0x3e/0x4a
[    0.000000]  [<ffffffff8167f9a8>] start_kernel+0xa1/0x38b
[    0.000000]  [<ffffffff8167f2a0>] x86_64_start_reservations+0xa7/0xab
[    0.000000]  [<ffffffff8167f39c>] x86_64_start_kernel+0xf8/0x107
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
40000000:b0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001800000 s91736
r8192 d22952 u1048576
[    0.000000] pcpu-alloc: s91736 r8192 d22952 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 254549
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.33-rc5 root=/dev/sda1 ro debug audit=1
selinux=1 video=efifb vga=791 enforcing=0 early_ioremap_debug=1
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 1007956k/1033128k available (4031k kernel code,
388k absent, 24136k reserved, 2521k data, 504k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using HPET reference calibration
[    0.000000] Detected 2161.247 MHz processor.
[    0.004007] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4322.49 BogoMIPS (lpj=2161247)
[    0.004073] Security Framework initialized
[    0.004084] SELinux:  Initializing.
[    0.004115] SELinux:  Starting in permissive mode
[    0.004133] Mount-cache hash table entries: 256
[    0.004722] CPU: Physical Processor ID: 0
[    0.004727] CPU: Processor Core ID: 0
[    0.004734] mce: CPU supports 6 MCE banks
[    0.004747] CPU0: Thermal monitoring enabled (TM2)
[    0.004753] using mwait in idle threads.
[    0.004758] Performance Events: Core2 events, Intel PMU driver.
[    0.005006] ... version:                2
[    0.005010] ... bit width:              40
[    0.005015] ... generic registers:      2
[    0.005020] ... value mask:             000000ffffffffff
[    0.005025] ... max period:             000000007fffffff
[    0.005030] ... fixed-purpose events:   3
[    0.005035] ... event mask:             0000000700000003
[    0.006127] ACPI: Core revision 20091214
[    0.029585] Setting APIC routing to flat
[    0.029970] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.039983] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.039999] Booting Node   0, Processors  #1 Ok.
[    0.111046] Brought up 2 CPUs
[    0.111055] Total of 2 processors activated (8644.81 BogoMIPS).
[    0.113431] NET: Registered protocol family 16
[    0.115080] ACPI: bus type pci registered
[    0.115132] PCI: Using configuration type 1 for base access
[    0.132105] bio: create slab <bio-0> at 0
[    0.134793] ACPI: EC: EC description table is found, configuring boot EC
[    0.143160] ACPI: BIOS _OSI(Linux) query ignored
[    0.144436] ACPI: Interpreter enabled
[    0.144444] ACPI: (supports S0 S3 S4 S5)
[    0.144554] ACPI: Using IOAPIC for interrupt routing
[    0.179217] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.180818] ACPI: No dock devices found.
[    0.184206] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.184308] pci_root PNP0A08:00: ignoring host bridge windows from
ACPI; boot with "pci=use_crs" to use them
[    0.189406] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.189416] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.189425] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.189435] pci_root PNP0A08:00: host bridge window [mem
0x40000000-0xfebfffff] (ignored)
[    0.189540] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.189548] pci 0000:00:01.0: PME# disabled
[    0.189586] pci 0000:00:07.0: reg 10: [mem 0x50404000-0x50404fff]
[    0.189688] pci 0000:00:1b.0: reg 10: [mem 0x50400000-0x50403fff 64bit]
[    0.189754] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.189762] pci 0000:00:1b.0: PME# disabled
[    0.189867] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.189876] pci 0000:00:1c.0: PME# disabled
[    0.189984] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.189992] pci 0000:00:1c.1: PME# disabled
[    0.190105] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.190114] pci 0000:00:1c.2: PME# disabled
[    0.190188] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.190261] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.190334] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.190442] pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
[    0.190512] pci 0000:00:1d.7: reg 10: [mem 0x50405400-0x504057ff]
[    0.190580] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.190590] pci 0000:00:1d.7: PME# disabled
[    0.190768] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.190779] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    0.190788] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0680 (mask 000f)
[    0.190798] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
1640 (mask 000f)
[    0.190810] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
0300 (mask 001f)
[    0.190873] pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
[    0.190885] pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
[    0.190896] pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
[    0.190908] pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
[    0.190919] pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
[    0.190979] pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
[    0.190991] pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
[    0.191007] pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
[    0.191019] pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
[    0.191030] pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
[    0.191042] pci 0000:00:1f.2: reg 24: [mem 0x50405000-0x504053ff]
[    0.191076] pci 0000:00:1f.2: PME# supported from D3hot
[    0.191084] pci 0000:00:1f.2: PME# disabled
[    0.191154] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.191232] pci 0000:01:00.0: reg 10: [mem 0x40000000-0x47ffffff pref]
[    0.191244] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.191256] pci 0000:01:00.0: reg 18: [mem 0x50300000-0x5030ffff]
[    0.191279] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.191310] pci 0000:01:00.0: supports D1 D2
[    0.191375] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.191382] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.191389] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.191398] pci 0000:00:01.0:   bridge window [mem
0x40000000-0x47ffffff 64bit pref]
[    0.191473] pci 0000:02:00.0: reg 10: [mem 0x50200000-0x50203fff 64bit]
[    0.191488] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.191526] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.191586] pci 0000:02:00.0: supports D1 D2
[    0.191591] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.191601] pci 0000:02:00.0: PME# disabled
[    0.191668] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.191677] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.191685] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.191761] pci 0000:03:00.0: reg 10: [mem 0x50100000-0x5010ffff 64bit]
[    0.191858] pci 0000:03:00.0: supports D1
[    0.191863] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.191872] pci 0000:03:00.0: PME# disabled
[    0.191949] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.191960] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.192038] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.192047] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.192056] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.192068] pci 0000:00:1c.2:   bridge window [mem
0x48000000-0x4bffffff 64bit pref]
[    0.192132] pci 0000:0c:03.0: reg 10: [mem 0x4c004000-0x4c0047ff]
[    0.192145] pci 0000:0c:03.0: reg 14: [mem 0x4c000000-0x4c003fff]
[    0.192213] pci 0000:0c:03.0: supports D1 D2
[    0.192219] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.192228] pci 0000:0c:03.0: PME# disabled
[    0.192295] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive decode)
[    0.192307] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.192346] pci_bus 0000:00: on NUMA node 0
[    0.192358] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.193624] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.194054] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.194473] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.194903] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.195411] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.231040] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.231389] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.231731] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.232080] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.232418] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.232758] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.233111] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.233447] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.234080] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.234080] vgaarb: loaded
[    0.235075] SCSI subsystem initialized
[    0.235090] libata version 3.00 loaded.
[    0.235092] usbcore: registered new interface driver usbfs
[    0.235092] usbcore: registered new interface driver hub
[    0.235092] usbcore: registered new device driver usb
[    0.236071] Advanced Linux Sound Architecture Driver Version 1.0.21.
[    0.236071] PCI: Using ACPI for IRQ routing
[    0.236071] PCI: pci_cache_line_size set to 64 bytes
[    0.238073] cfg80211: Using static regulatory domain info
[    0.238073] cfg80211: Regulatory domain: 00
[    0.238073]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[    0.238073]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.238073]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.238073]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, 2000 mBm)
[    0.238073]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.238073]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
[    0.238073] cfg80211: Calling CRDA to update world regulatory domain
[    0.238111] NetLabel: Initializing
[    0.238111] NetLabel:  domain hash size = 128
[    0.238111] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.238166] NetLabel:  unlabeled traffic allowed by default
[    0.238177] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.238189] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.238198] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.241017] Switching to clocksource tsc
[    0.250836] pnp: PnP ACPI init
[    0.250871] ACPI: bus type pnp registered
[    0.257210] pnp 00:07: disabling [io  0x1640-0x164f] because it
overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.260075] pnp: PnP ACPI: found 9 devices
[    0.260081] ACPI: ACPI bus type pnp unregistered
[    0.260102] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.260110] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.260118] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.260126] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.260133] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.260141] system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.260156] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.260178] system 00:07: [io  0x0680-0x06ef] has been reserved
[    0.260186] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.260193] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.260201] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.260209] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.266980] pci 0000:01:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.266993] pci 0000:02:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.267058] pci 0000:00:1c.0: BAR 9: assigned [mem
0x50500000-0x506fffff pref]
[    0.267069] pci 0000:00:1c.1: BAR 9: assigned [mem
0x50700000-0x508fffff 64bit pref]
[    0.267079] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.267088] pci 0000:01:00.0: BAR 6: assigned [mem
0x50320000-0x5033ffff pref]
[    0.267098] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.267104] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.267112] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.267120] pci 0000:00:01.0:   bridge window [mem
0x40000000-0x47ffffff 64bit pref]
[    0.267132] pci 0000:02:00.0: BAR 6: assigned [mem
0x50500000-0x5051ffff pref]
[    0.267141] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.267148] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.267159] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.267168] pci 0000:00:1c.0:   bridge window [mem
0x50500000-0x506fffff pref]
[    0.267182] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.267189] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.267199] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.267209] pci 0000:00:1c.1:   bridge window [mem
0x50700000-0x508fffff 64bit pref]
[    0.267223] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.267230] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.267240] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.267249] pci 0000:00:1c.2:   bridge window [mem
0x48000000-0x4bffffff 64bit pref]
[    0.267264] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
[    0.267269] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.267279] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.267288] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.267309] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.267317] pci 0000:00:01.0: setting latency timer to 64
[    0.267333] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.267342] pci 0000:00:1c.0: setting latency timer to 64
[    0.267356] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.267364] pci 0000:00:1c.1: setting latency timer to 64
[    0.267380] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.267389] pci 0000:00:1c.2: setting latency timer to 64
[    0.267567] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.267578] pci 0000:00:1e.0: setting latency timer to 64
[    0.267587] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.267593] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    0.267599] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.267605] pci_bus 0000:01: resource 1 [mem 0x50300000-0x503fffff]
[    0.267611] pci_bus 0000:01: resource 2 [mem 0x40000000-0x47ffffff
64bit pref]
[    0.267620] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.267626] pci_bus 0000:02: resource 1 [mem 0x50200000-0x502fffff]
[    0.267632] pci_bus 0000:02: resource 2 [mem 0x50500000-0x506fffff pref]
[    0.267638] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.267644] pci_bus 0000:03: resource 1 [mem 0x50100000-0x501fffff]
[    0.267650] pci_bus 0000:03: resource 2 [mem 0x50700000-0x508fffff
64bit pref]
[    0.267659] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.267664] pci_bus 0000:04: resource 1 [mem 0x4c100000-0x500fffff]
[    0.267671] pci_bus 0000:04: resource 2 [mem 0x48000000-0x4bffffff
64bit pref]
[    0.267679] pci_bus 0000:0c: resource 1 [mem 0x4c000000-0x4c0fffff]
[    0.267685] pci_bus 0000:0c: resource 3 [io  0x0000-0xffff]
[    0.267691] pci_bus 0000:0c: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    0.267741] NET: Registered protocol family 2
[    0.267833] IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.268404] TCP established hash table entries: 131072 (order: 9,
2097152 bytes)
[    0.269413] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.270784] TCP: Hash tables configured (established 131072 bind 65536)
[    0.270792] TCP reno registered
[    0.270805] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.270844] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.271095] NET: Registered protocol family 1
[    0.271303] pci 0000:01:00.0: Boot video device
[    0.271327] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.275629] microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
[    0.275651] microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
[    0.275830] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.277817] Initializing RT-Tester: OK
[    0.278070] audit: initializing netlink socket (enabled)
[    0.278100] type=2000 audit(1265389957.277:1): initialized
[    0.289133] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.312290] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.312665] fuse init (API version 7.13)
[    0.313454] msgmni has been set to 1969
[    0.313803] SELinux:  Registering netfilter hooks
[    0.315077] alg: No test for stdrng (krng)
[    0.315102] io scheduler noop registered
[    0.315542] io scheduler cfq registered (default)
[    0.316882] vesafb: framebuffer at 0x40000000, mapped to
0xffffc90000100000, using 1536k, total 1536k
[    0.316920] vesafb: mode is 1024x768x16, linelength=2048, pages=0
[    0.316926] vesafb: scrolling: redraw
[    0.316932] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[    0.341492] Console: switching to colour frame buffer device 128x48
[    0.363748] fb0: VESA VGA frame buffer device
[    0.381614] Linux agpgart interface v0.103
[    0.385402] loop: module loaded
[    0.385753] input: Macintosh mouse button emulation as
/devices/virtual/input/input0
[    0.387509] ata_piix 0000:00:1f.1: version 2.13
[    0.387869] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.388172] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.388548] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.388972] scsi0 : ata_piix
[    0.389986] scsi1 : ata_piix
[    0.392903] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    0.393223] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    0.393642] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.394097] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.544767] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.545148] scsi2 : ata_piix
[    0.545659] scsi3 : ata_piix
[    0.550475] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    0.554585] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    0.555789] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.563176] usbcore: registered new interface driver usblcd
[    0.567513] usbcore: registered new interface driver usbled
[    0.572310] PNP: No PS/2 controller found. Probing ports directly.
[    0.577661] i8042.c: No controller found.
[    0.582679] mice: PS/2 mouse device common for all mice
[    0.583178] ata1.00: configured for UDMA/66
[    0.585270] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R
UJ-857D  KCV9 PQ: 0 ANSI: 5
[    0.589929] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.589932] Uniform CD-ROM driver Revision: 3.20
[    0.590378] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.590745] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.621833] Linux video capture interface: v2.00
[    0.629740] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05)
initialised: dm-devel@redhat.com
[    0.636301] EDAC MC: Ver: 2.1.0 Jan 22 2010
[    0.643398] cpuidle: using governor ladder
[    0.650232] cpuidle: using governor menu
[    0.661164] usbcore: registered new interface driver hiddev
[    0.668470] usbcore: registered new interface driver usbhid
[    0.675714] usbhid: USB HID core driver
[    0.682951] ALSA device list:
[    0.690259]   No soundcards found.
[    0.697975] oprofile: using NMI interrupt.
[    0.705689] IPVS: Registered protocols (TCP, AH, ESP)
[    0.713297] IPVS: Connection hash table configured (size=4096,
memory=64Kbytes)
[    0.720904] IPVS: ipvs loaded.
[    0.728643] Initializing XFRM netlink socket
[    0.736058] NET: Registered protocol family 17
[    0.743332] NET: Registered protocol family 15
[    0.750535] lib80211: common routines for IEEE802.11 drivers
[    0.769025] lib80211_crypt: registered algorithm 'NULL'
[    0.777657] No TPM chip found, activating TPM-bypass!
[    0.783129] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    0.783132] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.789147] ata3.01: configured for UDMA/100
[    0.789299] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU
MHW2120B 0081 PQ: 0 ANSI: 5
[    0.789977] sd 2:0:1:0: [sda] 234441648 512-byte logical blocks:
(120 GB/111 GiB)
[    0.790117] sd 2:0:1:0: [sda] Write Protect is off
[    0.790119] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.790176] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.848122] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    0.848226]  sda: sda1 sda2
[    0.865093] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.915304] EXT4-fs (sda1): mounted filesystem with ordered data mode
[    0.923432] VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
[    0.931749] Freeing unused kernel memory: 504k freed
[    1.374848] SELinux: 8192 avtab hash slots, 168758 rules.
[    1.529594] SELinux: 8192 avtab hash slots, 168758 rules.
[    1.867838] SELinux:  7 users, 13 roles, 2932 types, 108 bools, 1
sens, 256 cats
[    1.876092] SELinux:  77 classes, 168758 rules
[    1.894744] SELinux:  Completing initialization.
[    1.902628] SELinux:  Setting up existing superblocks.
[    1.910473] SELinux: initialized (dev sda1, type ext4), uses xattr
[    1.918585] SELinux: initialized (dev securityfs, type securityfs),
uses genfs_contexts
[    1.926692] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    1.934846] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    1.942822] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses transition SIDs
[    1.950681] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    1.958579] SELinux: initialized (dev inotifyfs, type inotifyfs),
uses genfs_contexts
[    1.966648] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    1.974764] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    1.983010] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    1.992068] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    2.000359] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    2.008756] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    2.017178] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    2.025474] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    2.033720] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    2.062886] type=1403 audit(1265389959.062:2): policy loaded
auid=4294967295 ses=4294967295
[    2.866839] usbcore: registered new interface driver uvcvideo
[    2.875685] USB Video Class driver (v0.1.0)
[    2.895861] applesmc: Apple MacBook Pro detected:
[    2.904954] applesmc:  - Model with accelerometer
[    2.914332] applesmc:  - Model with light sensors and backlight
[    2.923686] applesmc:  - Model with 12 temperature sensors
[    2.934062] applesmc: device has already been initialized (0xe0, 0x00).
[    2.934064] applesmc: device successfully initialized.
[    2.943701] applesmc: 2 fans found.
[    2.954629] input: applesmc as /devices/platform/applesmc.768/input/input1
[    2.964113] Registered led device: smc::kbd_backlight
[    2.973493] applesmc: driver successfully loaded.
[    2.994399] usbcore: registered new interface driver appletouch
[    3.020836] ACPI: SSDT 000000003feb8c10 002AE (v01 APPLE   Cpu0Ist
00003000 INTL 20050309)
[    3.031907] ACPI: SSDT 000000003feb8910 002A0 (v01 APPLE   Cpu0Cst
00003001 INTL 20050309)
[    3.042858] Monitor-Mwait will be used to enter C-1 state
[    3.042907] Monitor-Mwait will be used to enter C-2 state
[    3.042956] Monitor-Mwait will be used to enter C-3 state
[    3.042965] Marking TSC unstable due to TSC halts in idle
[    3.052703] Switching to clocksource hpet
[    3.055408] ACPI: SSDT 000000003feb8f10 00087 (v01 APPLE   Cpu1Ist
00003000 INTL 20050309)
[    3.056707] ACPI: SSDT 000000003feb7f10 00085 (v01 APPLE   Cpu1Cst
00003000 INTL 20050309)
[    3.144680] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.154642] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.164716] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.164720] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.174736] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    3.184921] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    3.195014] ehci_hcd 0000:00:1d.7: debug port 1
[    3.208845] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.208899] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    3.230309] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.241064] hub 1-0:1.0: USB hub found
[    3.250917] hub 1-0:1.0: 8 ports detected
[    3.276352] uhci_hcd: USB Universal Host Controller Interface driver
[    3.290066] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.300032] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.300036] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.313065] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    3.323080] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    3.333529] hub 2-0:1.0: USB hub found
[    3.343259] hub 2-0:1.0: 2 ports detected
[    3.353266] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.363241] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.363245] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.373228] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    3.383235] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    3.393526] hub 3-0:1.0: USB hub found
[    3.406182] hub 3-0:1.0: 2 ports detected
[    3.416089] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.425646] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.425651] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.434950] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    3.444080] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    3.453618] hub 4-0:1.0: USB hub found
[    3.462177] hub 4-0:1.0: 2 ports detected
[    3.470953] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.479717] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.479721] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.488461] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    3.497309] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    3.506556] hub 5-0:1.0: USB hub found
[    3.515046] hub 5-0:1.0: 2 ports detected
[    3.623705] ieee1394: raw1394: /dev/raw1394 device initialized
[    3.688587] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    3.737067] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    3.864492] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[    3.878212] uvcvideo: UVC non compliance - GET_DEF(PROBE) not
supported. Enabling workaround.
[    4.055198] udev: starting version 147
[    4.300305] usb 2-1: new low speed USB device using uhci_hcd and address 2
[    4.526547] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level,
low) -> IRQ 19
[    4.536372] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf]
conflicts with ACPI region SMBI [0xefa0-0xefaf]
[    4.546381] ACPI: If an ACPI driver is available for this device,
you should use it instead of the native driver
[    4.676438] input: Mitsumi Electric Apple Optical USB Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input2
[    4.981047] input: Lid Switch as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input3
[    4.991247] sky2 driver version 1.26
[    5.001227] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.092654] apple 0003:05AC:0304.0001: input: USB HID v1.10 Mouse
[Mitsumi Electric Apple Optical USB Mouse] on
usb-0000:00:1d.0-1/input0
[    5.149923] ACPI: Lid Switch [LID0]
[    5.222170] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[    5.247799] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.258736] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[    5.258819] HDA Intel 0000:00:1b.0: irq 24 for MSI/MSI-X
[    5.258880] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.259117] power_supply ADP1: uevent
[    5.259118] power_supply ADP1: No power supply yet
[    5.259149] power_supply ADP1: power_supply_changed
[    5.259154] ACPI: AC Adapter [ADP1] (on-line)
[    5.259274] power_supply ADP1: power_supply_changed_work
[    5.259277] power_supply ADP1: power_supply_update_gen_leds 1
[    5.259295] power_supply ADP1: uevent
[    5.259296] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    5.259301] power_supply ADP1: Static prop TYPE=Mains
[    5.259304] power_supply ADP1: 1 dynamic props
[    5.259306] power_supply ADP1: prop ONLINE=1
[    5.280758] sky2 0000:02:00.0: setting latency timer to 64
[    5.280802] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    5.292016] sky2 0000:02:00.0: irq 25 for MSI/MSI-X
[    5.292977] sky2 eth0: addr 00:17:f2:cb:e3:71
[    5.369940] power_supply BAT0: uevent
[    5.369945] power_supply BAT0: No power supply yet
[    5.370106] power_supply BAT0: power_supply_changed
[    5.370120] power_supply BAT0: power_supply_changed_work
[    5.392672] power_supply BAT0: power_supply_update_bat_leds 0
[    5.393222] power_supply BAT0: uevent
[    5.393226] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.393236] power_supply BAT0: Static prop TYPE=Battery
[    5.393244] power_supply BAT0: 13 dynamic props
[    5.393251] power_supply BAT0: prop STATUS=Unknown
[    5.393261] power_supply BAT0: prop PRESENT=1
[    5.393271] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.393280] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.393289] power_supply BAT0: prop VOLTAGE_NOW=12522000
[    5.393298] power_supply BAT0: prop CURRENT_NOW=0
[    5.393306] power_supply BAT0: prop POWER_NOW=0
[    5.393314] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.393323] power_supply BAT0: prop ENERGY_FULL=49610000
[    5.393332] power_supply BAT0: prop ENERGY_NOW=49320000
[    5.393341] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.393350] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.393358] power_supply BAT0: prop SERIAL_NUMBER=
[    5.393709] power_supply BAT0: uevent
[    5.393714] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.393723] power_supply BAT0: Static prop TYPE=Battery
[    5.393731] power_supply BAT0: 13 dynamic props
[    5.393738] power_supply BAT0: prop STATUS=Unknown
[    5.393747] power_supply BAT0: prop PRESENT=1
[    5.393758] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.393767] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.393776] power_supply BAT0: prop VOLTAGE_NOW=12522000
[    5.393784] power_supply BAT0: prop CURRENT_NOW=0
[    5.393793] power_supply BAT0: prop POWER_NOW=0
[    5.393801] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.393810] power_supply BAT0: prop ENERGY_FULL=49610000
[    5.393819] power_supply BAT0: prop ENERGY_NOW=49320000
[    5.393828] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.393836] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.393844] power_supply BAT0: prop SERIAL_NUMBER=
[    5.417084] ACPI: Battery Slot [BAT0] (battery present)
[    5.432437] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input4
[    5.446593] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    5.463705] usb 2-2: new full speed USB device using uhci_hcd and address 3
[    5.464321] input: HDA Intel Line In at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input5
[    5.464512] input: HDA Intel HP Out at Ext Rear Jack as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input6
[    5.516673] ACPI: Power Button [PWRB]
[    5.534498] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.535221] input: Sleep Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input7
[    5.535370] ACPI: Sleep Button [SLPB]
[    5.535598] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input8
[    5.535697] ACPI: Power Button [PWRF]
[    5.599210] ath9k 0000:03:00.0: setting latency timer to 64
[    5.767736] ath: EEPROM regdomain: 0x64
[    5.767739] ath: EEPROM indicates we should expect a direct regpair map
[    5.767743] ath: Country alpha2 being used: 00
[    5.767745] ath: Regpair used: 0x64
[    5.790458] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    5.791003] Registered led device: ath9k-phy0::radio
[    5.804209] Registered led device: ath9k-phy0::assoc
[    5.816662] Registered led device: ath9k-phy0::tx
[    5.827411] input: Apple Computer Apple Internal Keyboard /
Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input9
[    5.827494] apple 0003:05AC:021A.0002: input: USB HID v1.11
Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input0
[    5.832039] appletouch: Geyser mode initialized.
[    5.832181] input: appletouch as
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input10
[    5.838201] input: Apple Computer Apple Internal Keyboard /
Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input11
[    5.838304] apple 0003:05AC:021A.0003: input: USB HID v1.11 Device
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input2
[    5.965580] Registered led device: ath9k-phy0::rx
[    5.980118] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81
mem=0xffffc900008c0000, irq=17
[    6.199147] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    6.389929] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    6.391337] generic-usb 0003:05AC:8240.0004: hiddev0: USB HID v1.11
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    6.505110] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[    6.513364] Adding 345388k swap on /dev/sda2.  Priority:1 extents:1
across:345388k
[    6.632367] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    6.844348] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[    7.027142] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[    7.278214] usb 5-1: USB disconnect, address 2
[    7.505051] usb 5-1: new full speed USB device using uhci_hcd and address 3
[    7.932440] Bluetooth: Core ver 2.15
[    7.932545] NET: Registered protocol family 31
[    7.932547] Bluetooth: HCI device and connection manager initialized
[    7.932551] Bluetooth: HCI socket layer initialized
[    7.958657] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    7.960290] usbcore: registered new interface driver btusb
[    8.277992] ip_tables: (C) 2000-2006 Netfilter Core Team
[    8.315292] nf_conntrack version 0.5.0 (7883 buckets, 31532 max)
[    8.318016] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Please use
[    8.318023] nf_conntrack.acct=1 kernel parameter, acct=1
nf_conntrack module option or
[    8.318027] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    8.972681] Bluetooth: L2CAP ver 2.14
[    8.972686] Bluetooth: L2CAP socket layer initialized
[    9.235538] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    9.235544] Bluetooth: BNEP filters: protocol multicast
[    9.344579] Bluetooth: SCO (Voice Link) ver 0.6
[    9.344584] Bluetooth: SCO socket layer initialized
[    9.664487] Bluetooth: RFCOMM TTY layer initialized
[    9.665375] Bluetooth: RFCOMM socket layer initialized
[    9.665378] Bluetooth: RFCOMM ver 1.11
[   11.294500] applesmc: light sensor data length set to 6
[   14.103423] sky2 eth0: enabling interface
[   17.487330] type=1100 audit(1265389974.487:3): user pid=1920 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:authentication acct="name" exe="/bin/login" hostname=?
addr=? terminal=/dev/tty1 res=success'
[   17.493668] type=1101 audit(1265389974.493:4): user pid=1920 uid=0
auid=4294967295 ses=4294967295
subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:accounting acct="name" exe="/bin/login" hostname=? addr=?
terminal=/dev/tty1 res=success'
[   17.593807] type=1006 audit(1265389974.593:5): login pid=1920 uid=0
old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   17.729176] type=2300 audit(1265389974.729:6): user pid=1920 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='pam: default-context=name:staff_r:staff_t:s0
selected-context=name:staff_r:staff_t:s0: exe="/bin/login" hostname=?
addr=? terminal=tty1 res=success'
[   17.929556] type=1105 audit(1265389974.929:7): user pid=1920 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:session_open acct="name" exe="/bin/login" hostname=?
addr=? terminal=/dev/tty1 res=success'
[   17.957482] type=1103 audit(1265389974.957:8): user pid=1920 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=PAM:setcred acct="name" exe="/bin/login" hostname=? addr=?
terminal=/dev/tty1 res=success'
[   17.957727] type=1112 audit(1265389974.957:9): user pid=1920 uid=0
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255
msg='op=login acct="name" exe="/bin/login" hostname=? addr=?
terminal=/dev/tty1 res=success'
[   20.136422] wlan0: direct probe to AP 00:1e:2a:00:67:f0 (try 1)
[   20.139446] wlan0: direct probe responded
[   20.139448] wlan0: authenticate with AP 00:1e:2a:00:67:f0 (try 1)
[   20.145759] wlan0: authenticated
[   20.145816] wlan0: associate with AP 00:1e:2a:00:67:f0 (try 1)
[   20.148087] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=4)
[   20.148089] wlan0: associated
[   20.728551] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   20.903984] [drm] Initialized drm 1.1.0 20060810
[   20.988499] [drm] radeon defaulting to userspace modesetting.
[   20.991042] pci 0000:01:00.0: setting latency timer to 64
[   20.991780] [drm] Initialized radeon 1.31.0 20080528 for
0000:01:00.0 on minor 0
[   21.410445] [drm] Setting GART location based on new memory map
[   21.412319] [drm] Loading R500 Microcode
[   21.412471] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[   21.521516] [drm] Num pipes: 1
[   21.521534] [drm] writeback test succeeded in 1 usecs
[   35.090229] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=46670 PROTO=UDP
SPT=49194 DPT=137 LEN=58
[   35.397480] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=11610 PROTO=UDP
SPT=49194 DPT=137 LEN=58
[   35.602266] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=15144 PROTO=UDP
SPT=49194 DPT=137 LEN=58
[   36.011802] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=23851 PROTO=UDP
SPT=49195 DPT=137 LEN=58
[   36.216567] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=16712 PROTO=UDP
SPT=49195 DPT=137 LEN=58
[   36.523897] FIREWALL:INPUT IN=wlan0 OUT=
MAC=ff:ff:ff:ff:ff:ff:00:25:00:43:7d:b1:08:00 SRC=10.0.0.94
DST=10.0.0.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=8524 PROTO=UDP
SPT=49195 DPT=137 LEN=58




-- 
Justin P. Mattock
