Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbXGDXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbXGDXK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 19:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXGDXKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 19:10:18 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:33309 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbXGDXKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 19:10:16 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 5 Jul 2007 09:10:21 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050856.25570.nigel@nigel.suspend2.net> <20070704230109.GA1770@elf.ucw.cz>
In-Reply-To: <20070704230109.GA1770@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2383802.mWUiYE0UgM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707050910.21852.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2383802.mWUiYE0UgM
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 09:01:09 Pavel Machek wrote:
> Hi!
>=20
> > > > > @@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char=20
> > > > > =20
> > > > >  __setup("acpi_sleep=3D", acpi_sleep_setup);
> > > > > =20
> > > > > +/* Ouch, we want to delete this. We already have better version =
in=20
> > > > userspace, in=20
> > > > > +   s2ram from suspend.sf.net project */
> > > >=20
> > > > Do we? This version has advantages in not requiring any userspace a=
pp=20
and=20
> > in=20
> > > > being able to work even if you can't yet get as far as having
> > >=20
> > > Take a look at the file. It has whitelist with just one entry, too
> > > bad.
> >=20
> > The contents of the whitelist are irrelevant. My laptop needs this=20
> > functionality, but I haven't bothered to send you a whitelist entry, in=
=20
part=20
> > because I don't use s2ram.
> >=20
> > Regardless of that, if you had read the whole comment (you've deleted h=
alf=20
of=20
> > it), you would have noticed that I ended up changing my mind and instea=
d=20
> > saying "Why not just delete the __setup now, or at least put it in the=
=20
> > deprecated file?"
>=20
> That should be  certainly done in separate patch, right? It is on my
> todolist somewhere now.

Yeah, agree.

> > > > > @@ -124,7 +124,7 @@ real_save_cr3:	.long 0
> > > > >  real_save_cr4:	.long 0
> > > > >  real_magic:	.long 0
> > > > >  video_mode:	.long 0
> > > > > -video_flags:	.long 0
> > > > > +realmode_flags:	.long 0
> > > > >  beep_flags:	.long 0
> > > > >  real_efer_save_restore:	.long 0
> > > > >  real_save_efer_edx: 	.long 0
> > > >=20
> > > > Beep_flags should be removed too if you're sticking with /proc.
> > >=20
> > > Fixed.
> >=20
> > Ta.  But you didn't answer the question - why /proc and not sysfs?
>=20
> Do you seriously advocate setting two bits of one variable from /proc,
> and one more bit from /sys?

That's partly why I had a separate variable - retaining proc only because i=
t's=20
existing functionality, using sysfs for the new code. Remember, too, that=20
they're really distinct functionality. The only thing they share is that=20
they're both used in real mode.

Regards,

Nigel
=2D-=20
Nigel, Michelle and Alisdair Cunningham
5 Mitchell Street
Cobden 3266
Victoria, Australia

--nextPart2383802.mWUiYE0UgM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjCjdN0y+n1M3mo0RArmIAJoDPnCUDDqJXtFWfOZGzE2OIkCOLgCeI/ff
csL7gfsH6aOUMKCr2P5gcmQ=
=Y8k7
-----END PGP SIGNATURE-----

--nextPart2383802.mWUiYE0UgM--
