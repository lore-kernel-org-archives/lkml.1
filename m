Return-Path: <linux-kernel-owner+w=401wt.eu-S1753630AbYCQEBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630AbYCQEBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 00:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYCQEA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 00:00:56 -0400
Received: from mx7.mail.ru ([194.67.23.27]:29718 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYCQEAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 00:00:55 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [possible regression] 2.6.22 reiserfs/libata sporadically hangs on resume from hibernation
Date: Mon, 17 Mar 2008 07:00:48 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200706300859.47133.arvidjaar@mail.ru> <200803162204.44131.arvidjaar@mail.ru> <200803162025.35558.rjw@sisk.pl>
In-Reply-To: <200803162025.35558.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1811841.LRpXThIseB";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803170700.49490.arvidjaar@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1811841.LRpXThIseB
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 16 March 2008, Rafael J. Wysocki wrote:
> On Sunday, 16 of March 2008, Andrey Borzenkov wrote:
> > On Thursday 13 March 2008, Rafael J. Wysocki wrote:
> > > On Thursday, 13 of March 2008, Andrey Borzenkov wrote:
> > > >=20
> > > > For the record - it happened again under 2.6.25-rc5; it reall drives
> > > > me nuts. Of course every time it happens I do not have infrastructu=
re to use
> > > > netconsole :( I am about to reformat the whole with ext3 as this se=
ems
> > > > to always hang somewhere in fs access and looks like not many people
> > > > use reiser today.
> > > >
> > >=20
> > > Well, it may be related to having the root partition on reiserfs.  I'=
ve never
> > > seen anything like this with non-root reiserfs partitions ...
> > >=20
> >=20
> > This one looks the hell similar to what I posted and Ingo is using ext3=
 ...
> >=20
> > http://marc.info/?l=3Dlinux-kernel&m=3D120479427912295&w=3D2
>=20
> Hm, this is not related to hibernation.
>=20

I forgot to mention that last couple of times I had it after STR.

> Perhaps hibernation just makes it easier to trigger the bug.
>=20
> There's entire thread related to this problem, please have a look at it:
> http://lkml.org/lkml/2008/3/16/55
>=20

As Alan pointed, the patch is likely to cause other issues; also I had the
issue with libata as well :(

--nextPart1811841.LRpXThIseB
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkfd7PEACgkQR6LMutpd94wB5wCdHxIwgmO0FbtPhGZDuxvbrqJL
wd8An1tf8PS/OARxjjGo5nT9eDyvBa87
=Z02C
-----END PGP SIGNATURE-----

--nextPart1811841.LRpXThIseB--
