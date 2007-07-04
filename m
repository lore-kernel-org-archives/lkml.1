Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbXGDW41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbXGDW41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbXGDW4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:56:20 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:38809 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbXGDW4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:56:19 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Optional Beeping During Resume From Suspend To Ram.
Date: Thu, 5 Jul 2007 08:56:25 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <200706192118.23706.nigel@nigel.suspend2.net> <200707050834.17747.nigel@nigel.suspend2.net> <20070704224859.GC2491@elf.ucw.cz>
In-Reply-To: <20070704224859.GC2491@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5563874.DVzBRLnvIJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707050856.25570.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5563874.DVzBRLnvIJ
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 08:48:59 Pavel Machek wrote:
> Hi!
>=20
> > Documentation is also an issue. Your patch should update the=20
kernel_parameters=20
> > file so users can know how to get the beeping to happen. It would be ni=
ce=20
if=20
> > it mentioned the proc entry too.
>=20
> Fixed the docs.

Ta.
=20
> > > @@ -80,9 +82,11 @@ static int __init acpi_sleep_setup(char=20
> > > =20
> > >  __setup("acpi_sleep=3D", acpi_sleep_setup);
> > > =20
> > > +/* Ouch, we want to delete this. We already have better version in=20
> > userspace, in=20
> > > +   s2ram from suspend.sf.net project */
> >=20
> > Do we? This version has advantages in not requiring any userspace app a=
nd=20
in=20
> > being able to work even if you can't yet get as far as having
>=20
> Take a look at the file. It has whitelist with just one entry, too
> bad.

The contents of the whitelist are irrelevant. My laptop needs this=20
functionality, but I haven't bothered to send you a whitelist entry, in par=
t=20
because I don't use s2ram.

Regardless of that, if you had read the whole comment (you've deleted half =
of=20
it), you would have noticed that I ended up changing my mind and instead=20
saying "Why not just delete the __setup now, or at least put it in the=20
deprecated file?"

> > > @@ -124,7 +124,7 @@ real_save_cr3:	.long 0
> > >  real_save_cr4:	.long 0
> > >  real_magic:	.long 0
> > >  video_mode:	.long 0
> > > -video_flags:	.long 0
> > > +realmode_flags:	.long 0
> > >  beep_flags:	.long 0
> > >  real_efer_save_restore:	.long 0
> > >  real_save_efer_edx: 	.long 0
> >=20
> > Beep_flags should be removed too if you're sticking with /proc.
>=20
> Fixed.

Ta.  But you didn't answer the question - why /proc and not sysfs?

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart5563874.DVzBRLnvIJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjCWZN0y+n1M3mo0RAkutAJ0RCztxAPdriBG8cBCi71tWUmUhMQCgkJWa
lKqYlBfduLLMPF6JvgCovro=
=VASB
-----END PGP SIGNATURE-----

--nextPart5563874.DVzBRLnvIJ--
