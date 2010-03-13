Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab0CMDsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:48:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757337Ab0CMDss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:48:48 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <20100313002705.836357664@kvm.kroah.org>
References: <20100313002705.836357664@kvm.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xrXv5oDlTtut9kZq/lor"
Date: Sat, 13 Mar 2010 03:48:42 +0000
Message-ID: <1268452122.7439.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [007/145] V4L/DVB: cxusb: Select all required frontend and
 tuner modules
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xrXv5oDlTtut9kZq/lor
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-12 at 16:25 -0800, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let me =
know.
>=20
> ----------------
> From: Ben Hutchings <ben@decadent.org.uk>
>=20
> commit fc4a7f93087a48619005111895dcaa115f807399 upstream.
>=20
> cxusb uses the atbm8830 and lgs8gxx (not lgs8gl5) frontends and the
> max2165 tuner, so it needs to select them.

I thought I already replied to say this is wrong for 2.6.32.

The correct change would be:
---
From: Ben Hutchings <ben@decadent.org.uk>

commit fc4a7f93087a48619005111895dcaa115f807399 upstream.

cxusb now uses the lgs8gxx (not lgs8gl5) frontend.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -112,8 +112,8 @@ config DVB_USB_CXUSB
 	select DVB_MT352 if !DVB_FE_CUSTOMISE
 	select DVB_ZL10353 if !DVB_FE_CUSTOMISE
 	select DVB_DIB7000P if !DVB_FE_CUSTOMISE
-	select DVB_LGS8GL5 if !DVB_FE_CUSTOMISE
 	select DVB_TUNER_DIB0070 if !DVB_FE_CUSTOMISE
+	select DVB_LGS8GXX if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_SIMPLE if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_XC2028 if !MEDIA_TUNER_CUSTOMISE
 	select MEDIA_TUNER_MXL5005S if !MEDIA_TUNER_CUSTOMISE

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-xrXv5oDlTtut9kZq/lor
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5sLEee/yOyVhhEJAQJnZBAAky4bTwuridE++nRKrzxlA3os1MuQ3CcB
FWaH+MLJzhuo2lhZabgp5qUjzZTI7vKPn0s2KJNJdqEG6gaqxqKzocA2aDiUBAzx
+Vy9GhH3yDFhRVPj9yMhZjinMqsBRTEYe/hRDGLIy9nVmjEq+jvsgdP0dYBL/mOn
+6AUt9zLA50k8IR6jvlKGsVC94FIIIXE2cG4eOGdJwPyWQ4UnfsWaBQebSR+zLkD
5EB0dCNIo1Uv+3nXy8eNTktjwkq8vRzD1zlctwBZZ4J68nCy5NVeFdgra9Z9tOJ1
Ru9rIsJIA6inAn0rKngqDxGfF5nCpO3hPDsPwfvTXTgmVO08NfX3F8P5r/FitWoV
e1JYeh7wPCebdc2CVMJggNmwZ2HhdxenlFG96uQYzTRbUr2vNWiTqcYo6i7xRoLB
IHNDhsGjvnV7AObxGMZN3S2HVv71++PLKEpBT2W+ZroHWcUcdjbRrFBo8CxBUoOS
Dg1ToMWK2eZmDO43mI2ykxFv4eKI1rnnj+8cheh8yCbjrNSZ50ZcPvHDcyiFHiue
gdAiIIAxG8EDGSufoXx/MT2GIZC4aqy4oIZzEU6zj8pHe75MVgnNn8Z7MIcGFZE+
VLRuo3AGq3RQMZfKEJ5leNSNiXEcfkTNycMsnAgB0AtD+FDMkZivBQ9b7/2gJsH/
iAQ14Mos6y8=
=kRzP
-----END PGP SIGNATURE-----

--=-xrXv5oDlTtut9kZq/lor--
