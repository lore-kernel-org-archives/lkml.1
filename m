Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbYHKQtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbYHKQtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbYHKQtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:49:41 -0400
Received: from ms01.sssup.it ([193.205.80.99]:51693 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751033AbYHKQtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:49:40 -0400
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1218472252.10800.107.camel@twins>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>  <1218464753.10800.92.camel@twins>
	 <1218471794.6450.87.camel@Palanthas>  <1218472252.10800.107.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u/RMhKKrvavvHYRDOpj2"
Date: Mon, 11 Aug 2008 18:49:33 +0200
Message-Id: <1218473373.6450.108.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-u/RMhKKrvavvHYRDOpj2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-11 at 18:30 +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-11 at 18:23 +0200, Dario Faggioli wrote:
> > On Mon, 2008-08-11 at 16:25 +0200, Peter Zijlstra wrote:
> > > My suggestion would be to create struct sched_param2 with plenty of
> > > padding to support future expansion and add
> > > sys_sched_setscheduler2()/sys_sched_getscheduler2() to deal with this
> > > new structure.
> > And we will miss POSIX compliance. :-(
> > Anyway, I agree the ABI issue this could raise are serious enough and, =
I
> > repeat, I can't see any other solution too.
>=20
> Well, a new version of glibc could use those to implement the posix
> interface.=20
I see. Actually, you're more than right! I have not thought at it in
those terms...

> Because as I understand it, glibc can break ABI on certain
> version bumps.
Seems better to me too... I confirm I'll do the interface change as soon
as possible.

Thanks again,
Dario

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-u/RMhKKrvavvHYRDOpj2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIoG2dk4XaBE3IOsQRAtmFAJ49C/Os3kTR7QdW1CsN9D9K/dUJ0ACghH1O
47HNZoOViRPcHy+Uwqt9Y+Y=
=EiZz
-----END PGP SIGNATURE-----

--=-u/RMhKKrvavvHYRDOpj2--

