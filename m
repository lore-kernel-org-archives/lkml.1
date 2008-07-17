Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbYGQC3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbYGQC3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYGQC3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:29:05 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:1609 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYGQC3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:29:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=TWsut6SwXg7HohMvxgnGvo7bMweawux/7juq/EtShZ9YHld5Cnpvy85wiS5ZKx5Q+G
         lLv4zFmQqIuFJ1UcVvG/ckIhmQ68JMIP1tNCHwOBgHenqb+ZH78Ba01VP+qrLL1Jkr9V
         n9B1CeuzkrjwAm99tKJt1EwJ6jW5QbQHMqG10=
Message-ID: <76366b180807161929i4eb9462exc3d2255e0ec881e8@mail.gmail.com>
Date: Wed, 16 Jul 2008 22:29:02 -0400
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: ACPI WARNING: at drivers/acpi/tables/tbfadt.c:348 acpi_tb_create_local_fadt+0x147/0x2f4()
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f7398d4113dcb412
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just saw this for the first time using a kernel built from the git
head. This is all the ACPI related printk info around the warning. If
more information is needed to figure out what this is, please let me
know.

[    0.000000] ACPI: RSDP 000F7CE0, 0024 (r2 RS690 )
[    0.000000] ACPI: XSDT 3DFE30C0, 004C (r1 RS690  AWRDACPI 42302E31 AWRD  0)
[    0.000000] ACPI: FACP 3DFE7400, 00F4 (r3 RS690  AWRDACPI 42302E31 AWRD  0)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at drivers/acpi/tables/tbfadt.c:348
acpi_tb_create_local_fadt+0x147/0x2f4()
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1
[    0.000000]  [<c01171bb>] warn_on_slowpath+0x3b/0x74
[    0.000000]  [<c01ede36>] acpi_os_vprintf+0x1d/0x20
[    0.000000]  [<c01ede46>] acpi_os_printf+0xd/0xe
[    0.000000]  [<c020120e>] acpi_ut_info+0x21/0x24
[    0.000000]  [<c0200016>] acpi_tb_print_table_header+0x96/0x9c
[    0.000000]  [<c020032b>] acpi_tb_create_local_fadt+0x147/0x2f4
[    0.000000]  [<c0200508>] acpi_tb_parse_fadt+0x30/0x6c
[    0.000000]  [<c03eeda5>] acpi_tb_parse_root_table+0x264/0x2ab
[    0.000000]  [<c03ee469>] acpi_table_init+0x14/0x6d
[    0.000000]  [<c03e3b28>] acpi_boot_table_init+0x2b/0xc3
[    0.000000]  [<c03dfcf4>] setup_arch+0x3fa/0x557
[    0.000000]  [<c03de7a9>] start_kernel+0x41/0x1ec
[    0.000000]  =======================
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] ACPI: DSDT 3DFE3240, 4146 (r1 RS690  AWRDACPI     1000
MSFT  100000E)
[    0.000000] ACPI: FACS 3DFE0000, 0040
[    0.000000] ACPI: SSDT 3DFE7600, 0136 (r1 PTLTD  POWERNOW        1  LTP  1)
[    0.000000] ACPI: HPET 3DFE7780, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD 98)
[    0.000000] ACPI: MCFG 3DFE7800, 003C (r1 RS690  AWRDACPI 42302E31 AWRD  0)
[    0.000000] ACPI: APIC 3DFE7540, 0068 (r1 RS690  AWRDACPI 42302E31 AWRD  0)
