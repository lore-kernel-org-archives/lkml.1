Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbYGQDfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbYGQDfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 23:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYGQDev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 23:34:51 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:4213 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481AbYGQDer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 23:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=mH/ZNA/QcIWKnoH83EHX8+jwswXnZxymPhLsuas2wC1FH5c+WYDY/z+i/4W7xYNFAv
         VJGfWijjErlIrjiFGMcaZWUK7PE+wM75ouu6w0MhJoxV/eHsYQ/yRZ5t2IMUp+a1CyZZ
         2/m+LnGoTJcdJ5SVp4erYGXP9ve80TrN7ifg0=
Message-ID: <76366b180807162034y1e725b15t7658c331bb89b52@mail.gmail.com>
Date: Wed, 16 Jul 2008 23:34:45 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348 acpi_tb_create_local_fadt+0x147/0x2f4()
Cc: "Jan Beulich" <jbeulich@novell.com>, "Andi Kleen" <ak@linux.intel.com>,
       "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
X-Google-Sender-Auth: fd746d107d549ae7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 10:29 PM, Andrew Paprocki <andrew@ishiboo.com> wrote:
> I just saw this for the first time using a kernel built from the git
> head. This is all the ACPI related printk info around the warning. If
> more information is needed to figure out what this is, please let me
> know.
>
> [    0.000000] ACPI: RSDP 000F7CE0, 0024 (r2 RS690 )
> [    0.000000] ACPI: XSDT 3DFE30C0, 004C (r1 RS690  AWRDACPI 42302E31 AWRD  0)
> [    0.000000] ACPI: FACP 3DFE7400, 00F4 (r3 RS690  AWRDACPI 42302E31 AWRD  0)
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at drivers/acpi/tables/tbfadt.c:348
> acpi_tb_create_local_fadt+0x147/0x2f4()
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1
> [    0.000000]  [<c01171bb>] warn_on_slowpath+0x3b/0x74
> [    0.000000]  [<c01ede36>] acpi_os_vprintf+0x1d/0x20
> [    0.000000]  [<c01ede46>] acpi_os_printf+0xd/0xe
> [    0.000000]  [<c020120e>] acpi_ut_info+0x21/0x24
> [    0.000000]  [<c0200016>] acpi_tb_print_table_header+0x96/0x9c
> [    0.000000]  [<c020032b>] acpi_tb_create_local_fadt+0x147/0x2f4
> [    0.000000]  [<c0200508>] acpi_tb_parse_fadt+0x30/0x6c
> [    0.000000]  [<c03eeda5>] acpi_tb_parse_root_table+0x264/0x2ab
> [    0.000000]  [<c03ee469>] acpi_table_init+0x14/0x6d
> [    0.000000]  [<c03e3b28>] acpi_boot_table_init+0x2b/0xc3
> [    0.000000]  [<c03dfcf4>] setup_arch+0x3fa/0x557
> [    0.000000]  [<c03de7a9>] start_kernel+0x41/0x1ec
> [    0.000000]  =======================
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] ACPI: DSDT 3DFE3240, 4146 (r1 RS690  AWRDACPI     1000
> MSFT  100000E)
> [    0.000000] ACPI: FACS 3DFE0000, 0040
> [    0.000000] ACPI: SSDT 3DFE7600, 0136 (r1 PTLTD  POWERNOW        1  LTP  1)
> [    0.000000] ACPI: HPET 3DFE7780, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD 98)
> [    0.000000] ACPI: MCFG 3DFE7800, 003C (r1 RS690  AWRDACPI 42302E31 AWRD  0)
> [    0.000000] ACPI: APIC 3DFE7540, 0068 (r1 RS690  AWRDACPI 42302E31 AWRD  0)
>

This most definitely broke because of:

commit 01a5bba576b9364b33f61f0cd9fa70c2cf5535e2
Author: Jan Beulich <jbeulich@novell.com>
Date:   Wed Jul 16 23:27:08 2008 +0200

    Fix FADT parsing

I added printk()s and this is what is reported here:

        printk(KERN_INFO
               "xpm1a_event_block bit_width=%d pm1_register_length=%d\n",
               acpi_gbl_FADT.xpm1a_event_block.bit_width, pm1_register_length);
        acpi_tb_init_generic_address(&acpi_gbl_xpm1a_enable,
                                     pm1_register_length,
                                     (acpi_gbl_FADT.xpm1a_event_block.address +
                                      pm1_register_length));

[    0.000000] xpm1a_event_block bit_width=8 pm1_register_length=0

The bit width is not % 16, so the following patch addition a few lines
earlier fails:

        WARN_ON(ACPI_MOD_16(acpi_gbl_FADT.xpm1a_event_block.bit_width));

Also, I noticed that the patch changed the definition of
acpi_tb_init_generic_address to name the parameter byte_width instead
of bit_width. The declaration at the top of the file and the
documentation still refer to it as bit_width.

I also added printk()s to the first call to
acpi_tb_init_generic_address ~ line 326 and the lengths passed to the
function at that point are:
[    0.000000] fadt_info_table[i].length=88
[    0.000000] fadt_info_table[i].length=89
[    0.000000] fadt_info_table[i].length=93
