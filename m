Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYDRUOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYDRUOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 16:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbYDRUOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:14:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51853 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYDRUOf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:14:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1
In-Reply-To: Your message of "Fri, 18 Apr 2008 01:47:57 PDT."
             <20080418014757.52fb4a4f.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1208549670_5142P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Apr 2008 16:14:30 -0400
Message-ID: <8007.1208549670@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1208549670_5142P
Content-Type: text/plain; charset=us-ascii

On Fri, 18 Apr 2008 01:47:57 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1/

I may have reported this same one previously against an earlier -mm, or somebody
did, or something... ;)

x86_64 kernel, Core2 Duo T7200, Dell Latitude D820 laptop...

[    0.060388] ACPI: Core revision 20080321
[    0.070079] ------------[ cut here ]------------
[    0.070082] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x41/0x7c()
[    0.070085] Modules linked in:
[    0.070089] Pid: 1, comm: swapper Not tainted 2.6.25-mm1 #1
[    0.070091]
[    0.070092] Call Trace:
[    0.070099]  [<ffffffff8023c702>] warn_on_slowpath+0x67/0xb7
[    0.070105]  [<ffffffff805d096e>] ? _spin_lock+0x25/0x54
[    0.070111]  [<ffffffff8021e399>] ? __cpus_weight+0x4b/0x68
[    0.070114]  [<ffffffff802245c1>] read_apic_id+0x41/0x7c
[    0.070119]  [<ffffffff807a0ded>] verify_local_APIC+0xb4/0x177
[    0.070123]  [<ffffffff805d4153>] ? sub_preempt_count+0x44/0x6e
[    0.070126]  [<ffffffff8079faf4>] native_smp_prepare_cpus+0x238/0x36a
[    0.070129]  [<ffffffff805d4153>] ? sub_preempt_count+0x44/0x6e
[    0.070134]  [<ffffffff80794712>] kernel_init+0x69/0x2a1
[    0.070137]  [<ffffffff805d0d42>] ? _spin_unlock_irq+0x43/0x62
[    0.070143]  [<ffffffff802366b7>] ? finish_task_switch+0x3e/0xb4
[    0.070147]  [<ffffffff8020d6e8>] child_rip+0xa/0x12
[    0.070150]  [<ffffffff8020cdd0>] ? restore_args+0x0/0x30
[    0.070154]  [<ffffffff807946a9>] ? kernel_init+0x0/0x2a1
[    0.070157]  [<ffffffff8020d6de>] ? child_rip+0x0/0x12
[    0.070159]
[    0.070166] ---[ end trace a7919e7f17c0a725 ]---
[    0.070169] ------------[ cut here ]------------
[    0.070171] WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x41/0x7c()
[    0.070174] Modules linked in:
[    0.070177] Pid: 1, comm: swapper Tainted: G        W 2.6.25-mm1 #1
[    0.070179]
[    0.070179] Call Trace:
[    0.070182]  [<ffffffff8023c702>] warn_on_slowpath+0x67/0xb7
[    0.070186]  [<ffffffff805d096e>] ? _spin_lock+0x25/0x54
[    0.070189]  [<ffffffff8021e399>] ? __cpus_weight+0x4b/0x68
[    0.070192]  [<ffffffff802245c1>] read_apic_id+0x41/0x7c
[    0.070195]  [<ffffffff807a0e1f>] verify_local_APIC+0xe6/0x177
[    0.070199]  [<ffffffff805d4153>] ? sub_preempt_count+0x44/0x6e
[    0.070202]  [<ffffffff8079faf4>] native_smp_prepare_cpus+0x238/0x36a
[    0.070205]  [<ffffffff805d4153>] ? sub_preempt_count+0x44/0x6e
[    0.070209]  [<ffffffff80794712>] kernel_init+0x69/0x2a1
[    0.070212]  [<ffffffff805d0d42>] ? _spin_unlock_irq+0x43/0x62
[    0.070215]  [<ffffffff802366b7>] ? finish_task_switch+0x3e/0xb4
[    0.070218]  [<ffffffff8020d6e8>] child_rip+0xa/0x12
[    0.070221]  [<ffffffff8020cdd0>] ? restore_args+0x0/0x30
[    0.070225]  [<ffffffff807946a9>] ? kernel_init+0x0/0x2a1
[    0.070228]  [<ffffffff8020d6de>] ? child_rip+0x0/0x12
[    0.070230]
[    0.070231] ---[ end trace a7919e7f17c0a725 ]---
[    0.081710] CPU0: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06

Other than that, it's lived for an hour without barfing yet, but I won't
have a chance to kick the tires and try stupid sysadmin tricks like I usually
do until Sunday-ish... Have a good weekend...

--==_Exmh_1208549670_5142P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFICQEmcC3lWbTT17ARAlemAKC9u7jesxzzpStCgwqbAZ6GnybGBwCfS353
XcZjmwqtQjE0IbH75OgcEz0=
=bOtb
-----END PGP SIGNATURE-----

--==_Exmh_1208549670_5142P--
