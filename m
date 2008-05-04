Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbYEDJvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbYEDJvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 05:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYEDJvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 05:51:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:53535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752213AbYEDJvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 05:51:13 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1/kYZ0hL2bkRVOHc+oJe/snaGJO6VzOLqpTaLEuXc
	Xeo+ysLL9AFwKe
Date: Sun, 4 May 2008 11:51:08 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
Message-ID: <20080504115108.7b5a8e3f@highlander.home.lan>
In-Reply-To: <20080503231813.GA18248@kroah.com>
References: <20080504005209.13af2b2c@highlander.home.lan>
	<20080503231813.GA18248@kroah.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/n/Sd_l44hkO0eiljY28Jqei";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/n/Sd_l44hkO0eiljY28Jqei
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 3 May 2008 16:18:13 -0700
Greg KH <greg@kroah.com> wrote:

> On Sun, May 04, 2008 at 12:52:09AM +0200, Malte Schr=C3=B6der wrote:
> > Hello,
> Hm, this doesn't look good.  Is it repeatable?  Your log shows all the
> PCI devices pretty much going out to lunch, which is very odd.

It happens about every two days or so. There is no specific action I
know of to reproduce this.=20

>=20
> If it's repeatable, it would be interesting if you are able to do a
> git-bisect to try to narrow the issue down...

Hmm, that's about the only box of mine where bisecting a kernel really
hurts. It's my central VoIP, internet, mail and other stuff gateway and
it takes ages to boot (it's the box where my old hardware ends up).

>=20
> > [    0.674334] ACPI: PCI Interrupt Link [ALKA] disabled and referenced,=
 BIOS bug
> > [    0.675016] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
> > [    0.675909] ACPI: PCI Interrupt 0000:00:0f.0[A] -> Link [ALKA] -> GS=
I 20 (level, low) -> IRQ 20
>=20
> Does these lines also show up in 2.6.24.5?

Yes, they do. I currently have 2.6.24.6 running.


>=20
> thanks,
>=20
> greg k-h
>=20


--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------

--Sig_/n/Sd_l44hkO0eiljY28Jqei
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHYcP4q3E2oMjYtURAhURAJ9Pr3pGQaNl/vKi4GDGM8TT3P3QpQCcCMP/
EE76Xq1EVo55LaV0vTMaCLU=
=HtTo
-----END PGP SIGNATURE-----

--Sig_/n/Sd_l44hkO0eiljY28Jqei--
