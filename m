Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZGBTQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZGBTQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZGBTQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:16:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39232 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZGBTQf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:16:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
In-Reply-To: Your message of "Tue, 30 Jun 2009 12:51:30 PDT."
             <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246562163_2896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jul 2009 15:16:03 -0400
Message-ID: <6719.1246562163@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246562163_2896P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 12:51:30 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-06-30-12-50 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

This whinges at me during early startup:

[    0.654180] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
[    0.655101] ACPI: SSDT 000000007fe82138 00244 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.655547] power_supply AC: prop ONLINE=1
[    0.655984] ACPI: SSDT 000000007fe81eed 001C6 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.657061] ------------[ cut here ]------------
[    0.657296] WARNING: at kernel/lockdep.c:2143 trace_hardirqs_on_caller+0xc7/0x145()
[    0.657664] Hardware name: Latitude D820
[    0.657933] Modules linked in:
[    0.658056] Pid: 0, comm: swapper Not tainted 2.6.31-rc1-mmotm0630 #1
[    0.658056] Call Trace:
[    0.658056]  <IRQ>  [<ffffffff8103ef3d>] warn_slowpath_common+0x77/0x8f
[    0.658056]  [<ffffffff8120a76a>] ? acpi_processor_get_throttling_fadt+0x81/0x8c
[    0.658056]  [<ffffffff8103ef64>] warn_slowpath_null+0xf/0x11
[    0.658056]  [<ffffffff81065ba9>] trace_hardirqs_on_caller+0xc7/0x145
[    0.658056]  [<ffffffff81065c34>] trace_hardirqs_on+0xd/0xf
[    0.658056]  [<ffffffff8120a76a>] acpi_processor_get_throttling_fadt+0x81/0x8c
[    0.658056]  [<ffffffff8120a3c4>] get_throttling+0x18/0x1f
[    0.658056]  [<ffffffff8106dbbf>] generic_smp_call_function_single_interrupt+0x73/0x95
[    0.658056]  [<ffffffff8101e9bf>] smp_call_function_single_interrupt+0x13/0x23
[    0.658056]  [<ffffffff8100c093>] call_function_single_interrupt+0x13/0x20
[    0.658056]  <EOI>  [<ffffffff81012a52>] ? mwait_idle+0x7a/0x95
[    0.658056]  [<ffffffff81012a49>] ? mwait_idle+0x71/0x95
[    0.658056]  [<ffffffff814a8d49>] ? atomic_notifier_call_chain+0xf/0x11
[    0.658056]  [<ffffffff8100a4aa>] ? enter_idle+0x20/0x22
[    0.658056]  [<ffffffff8100a521>] ? cpu_idle+0x75/0xfd
[    0.658056]  [<ffffffff8148bc41>] ? rest_init+0x75/0x77
[    0.658056]  [<ffffffff81801c53>] ? start_kernel+0x36e/0x379
[    0.658056]  [<ffffffff8180129c>] ? x86_64_start_reservations+0xac/0xb0
[    0.658056]  [<ffffffff81801384>] ? x86_64_start_kernel+0xe4/0xeb
[    0.658056] ---[ end trace a7919e7f17c0a725 ]---
[    0.803166] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.814078] processor LNXCPU:00: registered as cooling_device0
[    0.825244] ACPI: Processor [CPU0] (supports 8 throttling states)



--==_Exmh_1246562163_2896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTQdzcC3lWbTT17ARAnM2AKDGBfLYlksGhNGd4srxR9hgrSOKAgCfcPy9
MzZOogp1G9jAAf76g+MgOeE=
=PkZJ
-----END PGP SIGNATURE-----

--==_Exmh_1246562163_2896P--
