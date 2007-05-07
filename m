Return-Path: <linux-kernel-owner+w=401wt.eu-S966270AbXEGTY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966270AbXEGTY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 15:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXEGTY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 15:24:27 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:32976 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966229AbXEGTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 15:24:26 -0400
Subject: Re: [PATCH] kernel option CONFIG_USB_HIDINPUT_POWERBOOK
	description update
From: =?ISO-8859-1?Q?No=E8l_K=F6the?= <noel@debian.org>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705030951520.16923@twin.jikos.cz>
References: <1178118015.4820.26.camel@mbp.domain.lan>
	 <Pine.LNX.4.64.0705030951520.16923@twin.jikos.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e4dpGKw/gn4rQ11Eg/Hq"
Organization: Debian GNU/Linux, www.debian.org
Date: Mon, 07 May 2007 21:17:21 +0200
Message-Id: <1178565441.4813.22.camel@mbp.domain.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e4dpGKw/gn4rQ11Eg/Hq
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am Donnerstag, den 03.05.2007, 09:56 +0200 schrieb Jiri Kosina:

Hello Jiri,

> > The description of this option needs to be extended to be correct:)

> >  config USB_HIDINPUT_POWERBOOK
> > -       bool "Enable support for iBook/PowerBook special keys"
> > +       bool "Enable support for iBook/PowerBook/MacBook/MacBookPro spe=
cial keys"

> I will apply this into my tree, thanks.

Great thanks. Does this mean it will go into your tree and then into the
mainline kernel, or is there an additional step needed?

> > This option is needed on the Apple Intel Laptops, too. I would suggest=20
> > to rename USB_HIDINPUT_POWERBOOK because its needed on Apple Laptops.=20
> > Maybe USB_HIDINPUT_APPLELAPTOPS or something like this. Is a renaming=20
> > patch for this welcome?
>=20
> The problem here is backwards compatibility - if we would like to do the=20
> change in a consistent way, we should rename all the places which (for=20
> historic reasons) mention powerbook only. Unfortunately this would also=20
> require renaming the module parameter hid_pb_fnmode, which might be a=20
> little too intrusive with respect to maintaining backward compatibility i=
n=20
> userspace (ok, we have already been fiddling with this parameter anyway=20
> during the usbhid code split, but anyway).
>=20
> If you would care to make the patch which maintains backwards=20
> compatibility (for example by aliasing the variable pb_fnmode behing two=20
> module parameters), that might probably be ok.

I understand. I will try.

--=20
No=C3=A8l K=C3=B6the <noel debian.org>
Debian GNU/Linux, www.debian.org

--=-e4dpGKw/gn4rQ11Eg/Hq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGP3tB9/DnDzB9Vu0RAl2EAJ49M0YMhlQ3zv1aQGdeIUOCpwqLigCgk+BW
tP5FAw9uHMQCCR3Te8FJZCI=
=L4ep
-----END PGP SIGNATURE-----

--=-e4dpGKw/gn4rQ11Eg/Hq--

