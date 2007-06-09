Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbXFIIZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbXFIIZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXFIIZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:25:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:56536 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757424AbXFIIZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:25:34 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1+1c7xqC+m1Y0/HGqa0CXdNr1M08EZDfxfDCwkiif
	7ZSMabSDabsWW/
Date: Sat, 9 Jun 2007 10:25:25 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.21.3-rt9: SMP errors with VIA Rhine on Uniproc
Message-ID: <20070609102525.4fec991c@SiRiUS.home>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_POinLlwIavHuA1WIM_sAVkq;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_POinLlwIavHuA1WIM_sAVkq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having some trouble with the 2.6.21 -rt series on my single
processor machine:

APIC error on CPU0: 01(01)
 [<a010ce5b>] smp_error_interrupt+0x5b/0x70
 [<a01034f8>] error_interrupt+0x28/0x30
 [<a024ca38>] iowrite16+0x28/0x30
 [<a02c7ecf>] rhine_interrupt+0x6f/0xb20
 [<a039d553>] __sched_text_start+0x303/0x800
 [<a013f37c>] handle_IRQ_event+0x5c/0xe0
 [<a013f8c9>] thread_simple_irq+0x59/0x90
 [<a013febb>] do_irqd+0x25b/0x2e0
 [<a013fc60>] do_irqd+0x0/0x2e0
 [<a012e538>] kthread+0xa8/0xe0
 [<a012e490>] kthread+0x0/0xe0
 [<a010361b>] kernel_thread_helper+0x7/0x1c
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This looks like it has to do with my onbaord VIA Rhine VT6102 ethernet
controller. After two or three of these errors, the network performance
decreases massively.

On vanilla 2.6.22-rc series I also get a lot of APIC errors, but they
show no trace at all.

The kernel is compiled without SMP support.

Any idea for a fix?

Thanks,
Thomas

--Sig_POinLlwIavHuA1WIM_sAVkq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGamP6MQFfAqZTGfwRAn7aAJ4yZksbR5QGMhhQyn/9OZKcL6vISwCfY6We
B/fvs9a1OApt+C4KBGSTg/g=
=+YKV
-----END PGP SIGNATURE-----

--Sig_POinLlwIavHuA1WIM_sAVkq--
