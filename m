Return-Path: <linux-kernel-owner+w=401wt.eu-S1755356AbZIULHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbZIULHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbZIULHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:07:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:54983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755068AbZIULHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:07:36 -0400
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX18f4SkXbM8fxfQddb9Viec3WFeaTtbFWlMk6f3ml8
	/c8zYD2v+GfjWe
Date: Mon, 21 Sep 2009 23:25:53 +1200
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Influence of optimization level, preemption and scheduler on boot
 time
Message-Id: <20090921232553.c97560c7.buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__21_Sep_2009_23_25_53_+1200_+oElbJ3WDygdTJ5Y"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__21_Sep_2009_23_25_53_+1200_+oElbJ3WDygdTJ5Y
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all.

I measured the kernel (and system) boot times while varying the
parameters:
 - Optimization level: -Os, -O2 and also -O3
 - Preemptive model
 - Scheduler: CFQ, Anticipatory, Deadline, Noop

My conclusion was that the optimization level and the preemptive model
had no significant influence on speed. CFQ let my system boot several
seconds faster than the other schedulers.

Graphs can be found at:
http://johannes.jakeapp.com/blog/?p=3D913

This conclusion may not be true for all situations, but I found it
interesting that the optimization level is so irrelevant.

Cheers,
Johannes

(I am not subscribed to the list.)
--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html

--Signature=_Mon__21_Sep_2009_23_25_53_+1200_+oElbJ3WDygdTJ5Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq3YsgACgkQ7X1+MfqVcr3/AACfWAelEgeezRgEr+RcFK/j5LVG
rmUAnjOhpx9RL8scOrfa0BBb71OlAgNs
=EGW8
-----END PGP SIGNATURE-----

--Signature=_Mon__21_Sep_2009_23_25_53_+1200_+oElbJ3WDygdTJ5Y--
