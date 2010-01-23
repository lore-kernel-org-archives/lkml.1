Return-Path: <linux-kernel-owner+w=401wt.eu-S1755280Ab0AWCn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab0AWCn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 21:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651Ab0AWCn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 21:43:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33585 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752696Ab0AWCnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 21:43:55 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org, stable@kernel.org,
       Rohan Hart <rohan.hart17@gmail.com>, Ryan May <rmay31@gmail.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20100123001113.401655891@mini.kroah.org>
References: <20100123001113.401655891@mini.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zr3S3Sksk2si4EgSH7Tt"
Date: Sat, 23 Jan 2010 02:43:46 +0000
Message-ID: <1264214626.373.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [25/29] USB: fix usbstorage for 2770:915d
 delivers no FAT
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Zr3S3Sksk2si4EgSH7Tt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 16:10 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: Ryan May <rmay31@gmail.com>
>=20
> commit 10d2cdb6102669279bee2d9a00a22431b74583d5 upstream.
>=20
> Resolves kernel.org bug 14914.
>=20
> Remove entry for 2770:915d (usb digital camera with mass storage
> support) from unusual_devs.h. The fix triggered by the entry causes
> the file system on the camera to be completely inaccessible (no
> partition table, the device is not mountable).
>=20
> The patch works, but let me clarify a few things about it.  All the
> patch does is remove the entry for this device from the
> drivers/usb/storage/unusual_devs.h, which is supposed to help with a
> problem with the device's reported size (I think).  I'm pretty sure it
> was originally added for a reason, so I'm not sure removing it won't
> cause other problems to reappear.  Also, I should note that this
> unusual_devs.h entry was present (and activating workarounds) in
> 2.6.29, but in that version everything works fine.  Starting with
> 2.6.30, things no longer work.
[...]

It doesn't sound like this bug or fix are sufficiently well understood
yet to be suitable for a stable update.  The bug report is currently
marked as invalid!

Ben.

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-Zr3S3Sksk2si4EgSH7Tt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS1piXOe/yOyVhhEJAQK4cQ//b2EFStH9404SlLc2cey2tNEKF85XhnI4
BFG2TADK39utvDEawQcP49aaQULIdrRi1OIykyu30RvQmNY7jsyazoU0Qyb+b14B
rV6lja+eV2UIAFmtZBg5xNdNAhGXlreWeSsMqztQ9llQ19a/LN/D52gvhb6UHurt
PmLmq/L61DEYMNPibYt1wRyN5gwPj3sSh5/DG8hjSSKGf4kQY+0K+X8p0yssEbRI
2euGNIBP4ba4Kw/xu3GJ3cwlYBtgMQSltg1P6P8KcvI7mpY/JaO8UFcSD4gfvPjW
OXRy2RtMZZ/aGuNCMKw64ZdtWz9NhYWvq2qr5tB3pNEko/8VaQpXWfMzNMS+tjUy
BaowCDCBtfwItAW2WtnZovc3bcsikKJLY72MvtoZQuaNYgVa7qRDbFaaG3snBPV8
x05PRBZWlqfIdTvb6ockhV8Uc0jLo73u6LZu75bLYQWOh1V8R2KSViNHFbUHxPzK
4KzQWcK/IesBJoiFU/M8Z7jpNK4iCF8NHXHT6Bj9GjAxvaYgtkc7F+JfgcmihUYd
wzAHeb1LsEGB0BXuOAazKWTpMat6R9FMitk4EvkecZ+xW7kmIALUlJ3nNmVAPtwD
zNrGyXml8ugsnXEFA5OSt2j7CfzYrb8yG2I8Qf9+9AewruaSeMXqvG4gFfYll376
URV7fS/p/GM=
=OHXI
-----END PGP SIGNATURE-----

--=-Zr3S3Sksk2si4EgSH7Tt--
