Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbXE2MYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbXE2MYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 08:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbXE2MYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 08:24:13 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:43596 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbXE2MYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 08:24:11 -0400
Subject: Re: [2.6.21.1] resume doesn't run suspended kernel?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
In-Reply-To: <200705291403.09773.rjw@sisk.pl>
References: <4658B7DD.3060309@tmr.com>
	 <1180392482.4149.15.camel@nigel.suspend2.net>
	 <20070529112952.GA23046@elf.ucw.cz>  <200705291403.09773.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m7wnNWlAsbO1BO+cPnTd"
Date: Tue, 29 May 2007 22:23:58 +1000
Message-Id: <1180441438.20718.1.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m7wnNWlAsbO1BO+cPnTd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Tue, 2007-05-29 at 14:03 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 29 May 2007 13:29, Pavel Machek wrote:
> > Hi!
> >=20
> > > > Yup.  Don't we do something like this for the (ACPI-based) suspend =
to RAM
> > > > already?
> > >=20
> > > Yeah, I was thinking about this overnight too. It should be doable. I=
n
> > > addition to what we already do, I think you'd want:
> > >=20
> > > - to copy the assembly to do the copying to a safe page;
> > > - to put the location of the cpu state that was saved in the image
> > > header so that it can be used after the data is copied back;
> >=20
> > ...alternatively, we can just rely on copy routine (and its data) not
> > changing frequently.

I'd rather be sure. It will be extra code, but reliability is important.

> > > - to copy the nosave data to a 'safe' page.
> > >=20
> > > What else?
> >=20
> > page directories need to be on a safe place, too.
>=20
> They are already.

Yeah - that's why I ignored them.

Regards,

Nigel

--=-m7wnNWlAsbO1BO+cPnTd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXBtdN0y+n1M3mo0RArJLAKDbVqS/UE0OAL0Y4vN2gccAXu/bPwCcDocH
FgrZpK2RHOk5oH+fEiuvcFw=
=uIiQ
-----END PGP SIGNATURE-----

--=-m7wnNWlAsbO1BO+cPnTd--

