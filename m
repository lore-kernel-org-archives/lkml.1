Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbXKKSsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbXKKSsj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:48:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXKKSs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:48:28 -0500
Received: from mx3.mail.ru ([194.67.23.149]:4697 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbXKKSs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:48:27 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24 regression:  hibernation hangs on "Suspending console" in low-battery condition
Date: Sun, 11 Nov 2007 21:48:18 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Alexey Starikovskiy <astarikovskiy@suse.de>
References: <200711052201.17150.arvidjaar@mail.ru> <200711111331.00826.arvidjaar@mail.ru> <200711111927.26540.rjw@sisk.pl>
In-Reply-To: <200711111927.26540.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2192903.YP4mebRK1D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711112148.23133.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2192903.YP4mebRK1D
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 11 November 2007, Rafael J. Wysocki wrote:
> On Sunday, 11 of November 2007, Andrey Borzenkov wrote:
> > On Monday 05 November 2007, Andrey Borzenkov wrote:
> > > Notice "hung" not "hangs". This happened so far only once - when low =
battery=20
> > > condition triggered suspend to disk. I was not able to reproduce it a=
fter=20
> > > this running on AC.
> > >=20
> > > Just in case it rings the bell for someone. This is not suspend regre=
ssion=20
> > > reported earlier by Jens - I do not even have SATA nor is using libat=
a=20
> > > drivers.
> > >=20
> >=20
> > This happened second time, now with 2.6.24-rc2. I have kpowersave confi=
gured
> > to initiate suspend-to-disk on low battery. Suspend-to-disk is initiate=
d,
> > but system stops after Suspending console line. Suspend image is not cr=
eated.
> >=20
> > This did work before although I do not name exact version.
> >=20
> > I am rather at loss how to proceed further ... any idea? dmesg and conf=
ig
> > attached just in case. The problem is that hibernation works when I ini=
tiate
> > it manually ...
>=20
> Have you tried it with the battery removed?
>=20
>=20

It works. Subjectively I have relatively long pause after first Suspending =
console
message (where it hangs otherwise), according to dmesg timestamp it is about
1 second before next messages appear. Also last two times I tried it writeo=
ut
of suspend image was really slow; it was both with and without battery. Rea=
ding
on resume in really in order of magnitude faster.

But manual STD so far works both on AC (with or without battery) or on batt=
ery.

Of course it is possible that battery gets exhausted during STD, but system
is not switched off. Rather I would suspect something like ACPI notification
that comes during freeze ...

If someone can advice which options to enable I could try netconsole. But l=
ikely
not before next weekend.

--nextPart2192903.YP4mebRK1D
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHN05zR6LMutpd94wRAvFtAKCoMHdzTogdmFjJxHgtBoFxEmjS0ACffNe3
1vxYlpP5TBURN+3w2N04Us8=
=bOEK
-----END PGP SIGNATURE-----

--nextPart2192903.YP4mebRK1D--
