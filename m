Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZIULmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZIULmk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 07:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755774AbZIULmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 07:42:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:59081 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755520AbZIULmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 07:42:35 -0400
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1+PTNECMMyPzL7/tWSOrzMBddY+bWcvMk24VpYRnm
	OJB4TOjabSypyj
Date: Tue, 22 Sep 2009 00:00:48 +1200
From: Johannes Buchner <buchner.johannes@gmx.at>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Influence of optimization level, preemption and scheduler on
 boot time
Message-Id: <20090922000048.0f9aa2b6.buchner.johannes@gmx.at>
In-Reply-To: <20090921132059.10b2723d@infradead.org>
References: <20090921232553.c97560c7.buchner.johannes@gmx.at>
	<20090921132059.10b2723d@infradead.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Sep_2009_00_00_48_+1200_hNs/AIxmEq1SBRWQ"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Sep_2009_00_00_48_+1200_hNs/AIxmEq1SBRWQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Sep 2009 13:20:59 +0200
Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 21 Sep 2009 23:25:53 +1200
> Johannes Buchner <buchner.johannes@gmx.at> wrote:
>=20
> > Hi all.
> >=20
> > I measured the kernel (and system) boot times while varying the
> > parameters:
> >  - Optimization level: -Os, -O2 and also -O3
> >  - Preemptive model
> >  - Scheduler: CFQ, Anticipatory, Deadline, Noop
> >=20
> > My conclusion was that the optimization level and the preemptive
> > model had no significant influence on speed. CFQ let my system boot
> > several seconds faster than the other schedulers.
> >=20
> > Graphs can be found at:
> > http://johannes.jakeapp.com/blog/?p=3D913
> >=20
> > This conclusion may not be true for all situations, but I found it
> > interesting that the optimization level is so irrelevant.
> >=20
>=20
> it's interesting to see that the IO scheduler mattered..=20
> I would think that (s)readahead makes the IO scheduler irrelevant for
> boot time...

I did not use (s)readahead though in this measurements. Trying
readahead-list with CFQ did not bring me any improvement. Maybe, for
the other schedulers, it brings the speed on par with CFQ.


--=20
Emails k=F6nnen ge=E4ndert, gef=E4lscht und eingesehen werden. Signiere oder
versch=FCssele deine Mails mit GPG.
http://web.student.tuwien.ac.at/~e0625457/pgp.html

--Signature=_Tue__22_Sep_2009_00_00_48_+1200_hNs/AIxmEq1SBRWQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkq3avMACgkQ7X1+MfqVcr2VJACeL5NZ0y7xzW51spnpJgCfbyeR
Sx4AnidNIpldcCV3BsyxbFDWxYjj+cpY
=wWlc
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Sep_2009_00_00_48_+1200_hNs/AIxmEq1SBRWQ--
