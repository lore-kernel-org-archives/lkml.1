Return-Path: <linux-kernel-owner+w=401wt.eu-S932785AbXDAGkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbXDAGkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 02:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbXDAGkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 02:40:17 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:57455 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932785AbXDAGkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 02:40:15 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] [PATCH] sched: staircase deadline misc fixes
Date: Sun, 1 Apr 2007 08:40:07 +0200
User-Agent: KMail/1.9.6
Cc: linux list <linux-kernel@vger.kernel.org>
References: <200703290237.38777.kernel@kolivas.org> <200703281934.17932.prakash@punnoor.de>
In-Reply-To: <200703281934.17932.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1314662.aESkcNa9nf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704010840.11387.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1314662.aESkcNa9nf
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 28 M=E4rz 2007 schrieb Prakash Punnoor:
> Am Mittwoch 28 M=E4rz 2007 schrieb Con Kolivas:
> > I'm cautiously optimistic that we're at the thin edge of the bugfix wed=
ge
> > now.
> >
> > ---
> > set_load_weight() should be performed after p->quota is set. This fixes=
 a
> > large SMP performance regression.
>
> Hi, I am using 2.6.21-rc5 with rsdl 0.37 and think I still see a regressi=
on
> with my Athlon X2. Namely using this ac3 encoder
> (http://aften.sourceforge.net/), which I parallelized in a simple way, wi=
th
> my test sample I remember having encoding times of ~5.4sec with vanilla a=
nd
> ~5.8 sec with rsdl - once the whole test wave is in cache. Otherwise you
> can easily I/O limit the encoder. ;-) You need to get sources from svn
> though. The current 0.06 release doesn't have threads support.

BTW, I confirmed this regression. With vanilla 2.76.21-rc5 I get back my 5.=
4=20
secs with the test sample and two threads. Furtmermore for me vanilla=20
actually feels nicer on my dual core, even with load - just subjectively=20
that's why I ditched rsdl...

Cheers,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1314662.aESkcNa9nf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGD1PLxU2n/+9+t5gRAiVjAKCizhqJUcWkKSKw+YhsWgWMW6xPOgCfeGyc
B3tPCLfWj9kir5DBOKpYRTs=
=kRiL
-----END PGP SIGNATURE-----

--nextPart1314662.aESkcNa9nf--
