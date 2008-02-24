Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYBXAoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYBXAoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 19:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYBXAo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 19:44:29 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:39375 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBXAo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 19:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CYKE51Fci/Lk9YK1a1SW5IUlIcyDO/X3GE5wQ19avlFCi9BucTKxbvkXyScLnQGXwrI7//SyWDDGXDdYDWgkMbuWGRUuZOkPq+IyBH5XlzU1lkewv3wvHPVtKRDlim12JfNrWzt0dJUn7w3UxY6nPFVcY6+9pXz0lxH8ffw6BXE=
Message-ID: <47C0BDE2.4020402@googlemail.com>
Date: Sun, 24 Feb 2008 01:44:18 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071204)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>,
       Arjan van dev Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr>
In-Reply-To: <47B7553D.5040601@free.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Riffard wrote:
> Le 16.02.2008 09:25, Andrew Morton a écrit :
>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> Got this in dmesg output:
> 
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/ioremap.c:129 __ioremap+0xc7/0x182()
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.25-rc2-mm1 #40
>  [<c0118955>] warn_on_slowpath+0x41/0x6d
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c01fdd89>] ? acpi_os_release_object+0x8/0xc
>  [<c02188d4>] ? acpi_ut_delete_object_desc+0x39/0x3e
>  [<c0217f05>] ? acpi_ut_delete_internal_obj+0x2c1/0x2c9
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c0131cde>] ? trace_hardirqs_on_caller+0xdf/0x100
>  [<c0131d0a>] ? trace_hardirqs_on+0xb/0xd
>  [<c01129c5>] __ioremap+0xc7/0x182
>  [<c0112a99>] ioremap_nocache+0xa/0xc
>  [<c02a6877>] acpi_os_map_memory+0x11/0x1a
>  [<c020b697>] acpi_ex_system_memory_space_handler+0xd3/0x228
>  [<c0203bd8>] ? acpi_ev_address_space_dispatch+0x142/0x1a8
>  [<c020b5c4>] ? acpi_ex_system_memory_space_handler+0x0/0x228
>  [<c0203bfd>] acpi_ev_address_space_dispatch+0x167/0x1a8
>  [<c02083dd>] acpi_ex_access_region+0x1e4/0x270
>  [<c02085bc>] acpi_ex_field_datum_io+0x153/0x2a1
>  [<c0158ac0>] ? cache_alloc_debugcheck_after+0xe9/0x165
>  [<c020879b>] acpi_ex_extract_from_field+0x91/0x224
>  [<c0206bcf>] ? acpi_ex_read_data_from_field+0x163/0x1b0
>  [<c0206bec>] acpi_ex_read_data_from_field+0x180/0x1b0
>  [<c020d256>] acpi_ex_resolve_node_to_value+0x1aa/0x230
>  [<c0207a32>] acpi_ex_resolve_to_value+0x270/0x2aa
>  [<c0209e47>] acpi_ex_resolve_operands+0x24e/0x52f
>  [<c0200827>] acpi_ds_exec_end_op+0xb7/0x4f4
>  [<c0212d51>] acpi_ps_parse_loop+0x5e5/0x79c
>  [<c02120dc>] acpi_ps_parse_aml+0xb2/0x2dd
>  [<c021350c>] acpi_ps_execute_method+0x13d/0x20d
>  [<c020fb72>] acpi_ns_evaluate+0x10e/0x1b0
>  [<c02164ca>] acpi_ut_evaluate_object+0x57/0x1a1
>  [<c02166ce>] acpi_ut_execute_STA+0x22/0x7b
>  [<c0218d61>] ? acpi_ut_release_mutex+0x85/0x8f
>  [<c020f45d>] acpi_ns_get_device_callback+0x5a/0x121
>  [<c021173e>] acpi_ns_walk_namespace+0xfa/0x114
>  [<c020f381>] acpi_get_devices+0x47/0x5d
>  [<c020f403>] ? acpi_ns_get_device_callback+0x0/0x121
>  [<c021ce4a>] ? ec_parse_device+0x0/0x6e
>  [<c03a4460>] acpi_ec_ecdt_probe+0xaa/0x10a
>  [<c03a404b>] acpi_init+0x73/0x21e
>  [<c023e5bb>] ? class_create+0x4b/0x64
>  [<c0390652>] kernel_init+0xa3/0x1f3
>  [<c0103a4e>] ? restore_nocheck_notrace+0x0/0xe
>  [<c03905af>] ? kernel_init+0x0/0x1f3
>  [<c03905af>] ? kernel_init+0x0/0x1f3
>  [<c01045a7>] kernel_thread_helper+0x7/0x10
>  =======================
> ---[ end trace 4eaa2a86a8e2da22 ]---
> 
> The offending code in arch/x86/mm/ioremap.c is:
> 101 static void __iomem *__ioremap(unsigned long phys_addr, unsigned long size,
> 102                                enum ioremap_mode mode)
> 103 {
> ...
> 119         /*
> 120          * Don't allow anybody to remap normal RAM that we're using..
> 121          */
> 122         for (pfn = phys_addr >> PAGE_SHIFT; pfn < max_pfn_mapped &&
> 123              (pfn << PAGE_SHIFT) < last_addr; pfn++) {
> 124                 if (page_is_ram(pfn) && pfn_valid(pfn) &&
> 125                     !PageReserved(pfn_to_page(pfn)))
> 126                         return NULL;
> 127         }
> 128 
> 129         WARN_ON_ONCE(page_is_ram(pfn));
> 130 
> 
> The WARN_ON was introduced by git-agpgart.patch.
> 
[..]

I'm getting that in mainline now on one of my older laptops also.

> laurent
> 

Gabriel
