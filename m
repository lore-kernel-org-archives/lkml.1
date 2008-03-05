Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbYCEWmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbYCEWmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYCEWmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:42:08 -0500
Received: from testure.choralone.org ([194.9.77.134]:54063 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYCEWmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:42:05 -0500
Date: Wed, 5 Mar 2008 17:41:55 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-acpi@vger.kernel.org
Subject: ACPI: WARNING: at arch/x86/mm/ioremap.c:138 __ioremap+0xa3/0x153()
Message-ID: <20080305224155.GA10583@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > https://bugzilla.redhat.com/show_bug.cgi?id=436213
 > 
 >            Summary: WARNING: at arch/x86/mm/ioremap.c:138
 >                     __ioremap+0xa3/0x153() (Not tainted)
 >            Product: Fedora
 >            Version: rawhide
 >           Platform: i686
 >         OS/Version: Linux
 >             Status: NEW
 >           Severity: low
 >           Priority: low
 >          Component: kernel
 >         AssignedTo: kernel-maint@redhat.com
 >         ReportedBy: orion@cora.nwra.com
 >          QAContact: extras-qa@fedoraproject.org
 > 
 > 
 > Description of problem:
 > 
 > Seeing this on a pentium M laptop during install.  Let me know what else you need.
 > 
 > <4>WARNING: at arch/x86/mm/ioremap.c:138 __ioremap+0xa3/0x153() (Not tainted)
 > <4>Modules linked in:
 > <4>Pid: 1, comm: swapper Not tainted 2.6.25-0.90.rc3.git5.fc9 #1
 > <4> [<c0428957>] warn_on_slowpath+0x47/0x75
 > <4> [<c0483ee4>] ? check_object+0x130/0x184
 > <4> [<c0437e51>] ? __kernel_text_address+0x34/0x3e
 > <4> [<c0406fad>] ? dump_trace+0xc5/0xe5
 > <4> [<c040c6ee>] ? save_stack_address+0x0/0x2c
 > <4> [<c05221e6>] ? acpi_os_release_object+0x8/0xc
 > <4> [<c040c76c>] ? save_stack_trace+0x1d/0x3b
 > <4> [<c0443c89>] ? save_trace+0x37/0x89
 > <4> [<c0444617>] ? mark_lock+0xbb/0x3f1
 > <4> [<c0483ee4>] ? check_object+0x130/0x184
 > <4> [<c041ae80>] __ioremap+0xa3/0x153
 > <4> [<c041af49>] ioremap_nocache+0xa/0xd
 > <4> [<c062c65f>] acpi_os_map_memory+0x11/0x1a
 > <4> [<c052d58c>] acpi_ex_system_memory_space_handler+0xd7/0x207
 > <4> [<c052d4b5>] ? acpi_ex_system_memory_space_handler+0x0/0x207
 > <4> [<c0526b4a>] acpi_ev_address_space_dispatch+0x132/0x173
 > <4> [<c052a852>] acpi_ex_access_region+0x1b6/0x1c4
 > <4> [<c052a977>] acpi_ex_field_datum_io+0x117/0x1af
 > <4> [<c052aaa0>] acpi_ex_extract_from_field+0x91/0x1e9
 > <4> [<c05374ec>] ? acpi_ut_allocate_object_desc_dbg+0x39/0x6a
 > <4> [<c0537532>] ? acpi_ut_create_internal_object_dbg+0x15/0x62
 > <4> [<c05296f5>] acpi_ex_read_data_from_field+0x12b/0x15a
 > <4> [<c052e287>] acpi_ex_resolve_node_to_value+0x137/0x1c8
 > <4> [<c052a060>] acpi_ex_resolve_to_value+0x20c/0x218
 > <4> [<c052bf86>] acpi_ex_resolve_operands+0x201/0x4b7
 > <4> [<c0524491>] acpi_ds_exec_end_op+0xd2/0x3ad
 > <4> [<c0532827>] acpi_ps_parse_loop+0x557/0x6ac
 > <4> [<c0531cd0>] acpi_ps_parse_aml+0x6d/0x20e
 > <4> [<c0532e9b>] acpi_ps_execute_method+0x122/0x1e3
 > <4> [<c05302a7>] acpi_ns_evaluate+0x93/0xec
 > <4> [<c053574e>] acpi_ut_evaluate_object+0x5d/0x163
 > <4> [<c05358c5>] acpi_ut_execute_STA+0x1d/0x49
 > <4> [<c052fd2a>] acpi_ns_get_device_callback+0x59/0x112
 > <4> [<c05378ef>] ? acpi_ut_acquire_mutex+0x36/0x74
 > <4> [<c0531366>] acpi_ns_walk_namespace+0x9a/0x110
 > <4> [<c052fc55>] acpi_get_devices+0x47/0x5d
 > <4> [<c052fcd1>] ? acpi_ns_get_device_callback+0x0/0x112
 > <4> [<c053afe0>] ? ec_parse_device+0x0/0x6e
 > <4> [<c0786582>] acpi_ec_ecdt_probe+0xaa/0x10a
 > <4> [<c0785f88>] acpi_init+0x76/0x218
 > <4> [<c056f224>] ? class_create+0x4b/0x63
 > <4> [<c076a2ad>] kernel_init+0x1a1/0x2f3
 > <4> [<c076a10c>] ? kernel_init+0x0/0x2f3
 > <4> [<c076a10c>] ? kernel_init+0x0/0x2f3
 > <4> [<c04069f3>] kernel_thread_helper+0x7/0x10
 > <4> =======================
 > <4>---[ end trace ca143223eefdc828 ]---
 > 
 > Version-Release number of selected component (if applicable):
 > 2.6.25-0.90.rc3.git5.fc9
 > 
 > How reproducible:
 > Every time at boot.

-- 
http://www.codemonkey.org.uk
