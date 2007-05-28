Return-Path: <linux-kernel-owner+w=401wt.eu-S1762283AbXE1K1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762283AbXE1K1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752111AbXE1K1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:27:23 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:34702 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXE1K1W (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:27:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc2-mm1 - a different BUG: at mm/slab.c:777 __find_general_cachep()
In-Reply-To: Your message of "Wed, 23 May 2007 00:42:33 PDT."
             <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070523004233.5ae5f6fd.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180348036_4040P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 28 May 2007 06:27:16 -0400
Message-ID: <13451.1180348036@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180348036_4040P
Content-Type: text/plain; charset=us-ascii

On Wed, 23 May 2007 00:42:33 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc2/2.6.22-rc2-mm1/

Dell Latitude D820 laptop, Intel T7200 dual-core, x86_64 kernel.

Does something wonky during very early boot, before userspace has started:

[4294667.471000] Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
[4294667.471000] Brought up 2 CPUs 
[4294667.471000] NET: Registered protocol family 16
[4294667.472000] ACPI: ACPI Dock Station Driver
[4294667.472000] ACPI: bus type pci registered
[4294667.472000] BUG: at mm/slab.c:777 __find_general_cachep()
[4294667.472000] 
[4294667.472000] Call Trace:
[4294667.472000]  [<ffffffff8020b2a8>] dump_trace+0xca/0x3cb
[4294667.472000]  [<ffffffff8020b5e5>] show_trace+0x3c/0x52
[4294667.472000]  [<ffffffff8020b610>] dump_stack+0x15/0x17
[4294667.472000]  [<ffffffff8028952e>] __kmalloc+0x41/0xb2
[4294667.472000]  [<ffffffff8042c450>] get_modalias+0x6c/0x107 
[4294667.472000]  [<ffffffff8042c520>] dmi_dev_uevent+0x35/0x4d
[4294667.472000]  [<ffffffff803b7d5f>] dev_uevent+0x19b/0x1d1
[4294667.472000]  [<ffffffff8034bd3c>] kobject_uevent_env+0x244/0x477
[4294667.472000]  [<ffffffff8034bf7a>] kobject_uevent+0xb/0xd
[4294667.472000]  [<ffffffff803b7971>] device_add+0x2b5/0x4eb
[4294667.472000]  [<ffffffff803b7bc0>] device_register+0x19/0x1d 
[4294667.472000]  [<ffffffff807dd71a>] dmi_id_init+0x2d1/0x2e9
[4294667.472000]  [<ffffffff807c1651>] kernel_init+0x168/0x2da
[4294667.472000]  [<ffffffff8020acd8>] child_rip+0xa/0x12
[4294667.472000] 
[4294667.473000] PCI: Using MMCONFIG at f0000000 - f3ffffff 
[4294667.489000] ACPI: SSDT 7FE819CE, 0043 (r1  LMPWR  DELLLOM     1001 INTL 20050624)

Any suggestions before I go doing the bisect shuffle?

--==_Exmh_1180348036_4040P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGWq6EcC3lWbTT17ARApTxAJ4+8osQTBPiZE+ZJ1mONrUa5ne/sACgtTfX
0FQZi1FbH2fr+JmeKFqMoHM=
=73JY
-----END PGP SIGNATURE-----

--==_Exmh_1180348036_4040P--
