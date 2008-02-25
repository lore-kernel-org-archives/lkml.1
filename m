Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYBYCJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYBYCJc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 21:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbYBYCJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 21:09:24 -0500
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:59640
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751155AbYBYCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 21:09:23 -0500
Date: Sun, 24 Feb 2008 18:09:22 -0800
From: Phil Oester <kernel@linuxace.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.25-rc3: WARNING: at arch/x86/mm/ioremap.c:137
Message-ID: <20080225020922.GA1711@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got the below on -rc3.  Tried applying the "more info" patch from Arjan
(http://marc.info/?l=linux-kernel&m=120336371506283&w=2), but that just
made the warning go away.  

Phil



ACPI: EC: Look up EC in DSDT
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xb1/0x16b()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-rc3 #7
 [<c01112d3>] warn_on_slowpath+0x40/0x4f
 [<c01bb692>] acpi_ut_update_object_reference+0xb0/0x109
 [<c01b4215>] acpi_ns_lookup+0x205/0x2ea
 [<c01bc0f8>] acpi_ut_release_mutex+0x50/0x55
 [<c01b54fa>] acpi_ns_get_node+0x79/0x83
 [<c0213a91>] raw_pci_read+0x3d/0x45
 [<c01bc1ba>] acpi_ut_acquire_mutex+0x2e/0x64
 [<c01bc0f8>] acpi_ut_release_mutex+0x50/0x55
 [<c01b6113>] acpi_get_parent+0x63/0x6c
 [<c0213a91>] raw_pci_read+0x3d/0x45
 [<c010cdde>] __ioremap+0xb1/0x16b
 [<c01b2291>] acpi_ex_system_memory_space_handler+0xdd/0x210
 [<c01b21b4>] acpi_ex_system_memory_space_handler+0x0/0x210
 [<c01aba50>] acpi_ev_address_space_dispatch+0x127/0x168
 [<c01af5e2>] acpi_ex_access_region+0x1a5/0x1b7
 [<c01af6ff>] acpi_ex_field_datum_io+0x10b/0x193
 [<c01b45da>] acpi_ns_search_one_scope+0x12/0x37
 [<c01b46f7>] acpi_ns_search_and_enter+0xf8/0x159
 [<c01af81f>] acpi_ex_extract_from_field+0x98/0x221
 [<c01bbd9f>] acpi_ut_allocate_object_desc_dbg+0x29/0x58
 [<c01bbde3>] acpi_ut_create_internal_object_dbg+0x15/0x67
 [<c01ae268>] acpi_ex_read_data_from_field+0x108/0x136
 [<c01b2f11>] acpi_ex_resolve_node_to_value+0x145/0x1c0
 [<c01aedf2>] acpi_ex_resolve_to_value+0x202/0x20c
 [<c01b0ceb>] acpi_ex_resolve_operands+0x1e1/0x4aa
 [<c01a9471>] acpi_ds_exec_end_op+0xa7/0x3ae
 [<c01b72d2>] acpi_ps_parse_loop+0x546/0x6f8
 [<c01b67ab>] acpi_ps_parse_aml+0x5f/0x222
 [<c01b795b>] acpi_ps_execute_method+0x10a/0x1a7
 [<c01b4ed8>] acpi_ns_evaluate+0x90/0xe4
 [<c01b5a31>] acpi_ns_init_one_device+0x72/0xad
 [<c01b5f08>] acpi_ns_walk_namespace+0x94/0x114
 [<c01b598c>] acpi_ns_initialize_devices+0x80/0xb3
 [<c01b59bf>] acpi_ns_init_one_device+0x0/0xad
 [<c01bae06>] acpi_initialize_objects+0x28/0x3a
 [<c03182ba>] acpi_init+0x77/0x21f
 [<c030c5fd>] kernel_init+0x97/0x1d1
 [<c010ee27>] schedule_tail+0xe/0x39
 [<c01027b2>] ret_from_fork+0x6/0x1c
 [<c030c566>] kernel_init+0x0/0x1d1
 [<c030c566>] kernel_init+0x0/0x1d1
 [<c01033f7>] kernel_thread_helper+0x7/0x10
 =======================
---[ end trace ca143223eefdc828 ]---

