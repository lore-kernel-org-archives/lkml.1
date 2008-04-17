Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbYDQPZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbYDQPZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 11:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbYDQPZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 11:25:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:34877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758244AbYDQPZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 11:25:27 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19Q5mpiyJxQNkhGbO4PSTQjYt7gO27CUzKlbCAw95
	KZzU9dl+Tbl8iv
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: build issue #469 for v2.6.25-rc8-166-g6fdf5e6 in pms.c : undefined reference to `video_usercopy'
Date: Thu, 17 Apr 2008 17:25:20 +0200
User-Agent: KMail/1.9.7
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <200804061448.42888.toralf.foerster@gmx.de> <200804151958.39524.toralf.foerster@gmx.de> <20080415190112.GA1677@cs181133002.pp.htv.fi>
In-Reply-To: <20080415190112.GA1677@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1928574.2bQBKdJUvf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804171725.23879.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1928574.2bQBKdJUvf
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Tuesday 15 April 2008 21:01:12 Adrian Bunk wrote :
> On Tue, Apr 15, 2008 at 07:58:39PM +0200, Toralf F=C3=B6rster wrote:
> >...
> > @@ -60,9 +60,14 @@ config VIDEO_V4L1_COMPAT
> >=20
> >  config VIDEO_V4L2
> >         bool
> > +       tristate
> >         depends on VIDEO_DEV && VIDEO_V4L2_COMMON
> >         default VIDEO_DEV && VIDEO_V4L2_COMMON
> >...
>=20
> i don't know whether this gets parsed, but it shouldn't have both "bool"=
=20
> and "tristate".
>=20
> cu
> Adrian
>=20

Right, I get the warning :

drivers/media/Kconfig:61:warning: type of 'VIDEO_V4L2' redefined from 'bool=
ean' to 'tristate'


=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1928574.2bQBKdJUvf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIB2vjhyrlCH22naMRAlgQAJ0b7ltzw8xSJ7Dt5wLW30ohdoOiEACfZAJQ
3fDJf1JbtXYO6A3MFdGkuDA=
=234E
-----END PGP SIGNATURE-----

--nextPart1928574.2bQBKdJUvf--
