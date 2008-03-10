Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYCJTkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYCJTkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYCJTkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:40:23 -0400
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:34621
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752292AbYCJTkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:40:22 -0400
Date: Mon, 10 Mar 2008 12:40:22 -0700
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc5: WARNING: at arch/x86/mm/ioremap.c
Message-ID: <20080310194022.GA1764@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still getting the 'WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xb1/0x165()'
error in -rc5.  Seen a few threads on this error, but apparently still not
resolved.  Anyone need more info?

Phil


ACPI: EC: Look up EC in DSDT
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xb1/0x165()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc5 #1
 [<c0110dbf>] warn_on_slowpath+0x40/0x4f
 [<c01bac1e>] acpi_ut_update_object_reference+0xb0/0x109
 [<c01b37a1>] acpi_ns_lookup+0x205/0x2ea
 [<c01bb684>] acpi_ut_release_mutex+0x50/0x55
 [<c01b4a86>] acpi_ns_get_node+0x79/0x83
 [<c0213089>] raw_pci_read+0x3d/0x45
 [<c01bb746>] acpi_ut_acquire_mutex+0x2e/0x64
 [<c01bb684>] acpi_ut_release_mutex+0x50/0x55
 [<c01b569f>] acpi_get_parent+0x63/0x6c
 [<c0213089>] raw_pci_read+0x3d/0x45
 [<c010c88e>] __ioremap+0xb1/0x165
 [<c01b181d>] acpi_ex_system_memory_space_handler+0xdd/0x210
 [<c01b1740>] acpi_ex_system_memory_space_handler+0x0/0x210
 [<c01aafdc>] acpi_ev_address_space_dispatch+0x127/0x168
 [<c01aeb6e>] acpi_ex_access_region+0x1a5/0x1b7
 [<c01aec8b>] acpi_ex_field_datum_io+0x10b/0x193
 [<c01b3b66>] acpi_ns_search_one_scope+0x12/0x37
 [<c01b3c83>] acpi_ns_search_and_enter+0xf8/0x159
 [<c01aedab>] acpi_ex_extract_from_field+0x98/0x221
 [<c01bb32b>] acpi_ut_allocate_object_desc_dbg+0x29/0x58
 [<c01bb36f>] acpi_ut_create_internal_object_dbg+0x15/0x67
 [<c01ad7f4>] acpi_ex_read_data_from_field+0x108/0x136
 [<c01b249d>] acpi_ex_resolve_node_to_value+0x145/0x1c0
 [<c01ae37e>] acpi_ex_resolve_to_value+0x202/0x20c
 [<c01b0277>] acpi_ex_resolve_operands+0x1e1/0x4aa
 [<c01a89fd>] acpi_ds_exec_end_op+0xa7/0x3ae
 [<c01b685e>] acpi_ps_parse_loop+0x546/0x6f8
 [<c01b5d37>] acpi_ps_parse_aml+0x5f/0x222
 [<c01b6ee7>] acpi_ps_execute_method+0x10a/0x1a7
 [<c01b4464>] acpi_ns_evaluate+0x90/0xe4
 [<c01b4fbd>] acpi_ns_init_one_device+0x72/0xad
 [<c01b5494>] acpi_ns_walk_namespace+0x94/0x114
 [<c01b4f18>] acpi_ns_initialize_devices+0x80/0xb3
 [<c01b4f4b>] acpi_ns_init_one_device+0x0/0xad
 [<c01ba392>] acpi_initialize_objects+0x28/0x3a
 [<c03172f9>] acpi_init+0x77/0x21f
 [<c030b5fa>] kernel_init+0x97/0x1d1
 [<c010e921>] schedule_tail+0xe/0x39
 [<c0102772>] ret_from_fork+0x6/0x1c
 [<c030b563>] kernel_init+0x0/0x1d1
 [<c030b563>] kernel_init+0x0/0x1d1
 [<c01033b7>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace ca143223eefdc828 ]---
ACPI: Interpreter enabled
