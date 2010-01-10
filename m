Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686Ab0AJWrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab0AJWrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570Ab0AJWrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:47:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab0AJWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:47:04 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <omZ8aBZReyD.A.rz.COlSLB@chimera>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera>
	 <omZ8aBZReyD.A.rz.COlSLB@chimera>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CTGxYW/wRIyMvkqQRHHu"
Date: Sun, 10 Jan 2010 22:46:56 +0000
Message-ID: <1263163616.2236.68.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Bug #14791] Something has been broken in the network stack
 this week
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CTGxYW/wRIyMvkqQRHHu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-10 at 23:27 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>=20
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14791
> Subject		: Something has been broken in the network stack this week
> Submitter	: Delete This Account <speedyboyinovator@hotmail.com>
> Date		: 2009-12-12 13:06 (30 days old)

You can mark this as Handled-by me, but I'm waiting for someone
(anyone!) to verify that this can be solved by reverting changes to this
driver made by commit 37e8273cd30592d3a82bcb70cbb1bdc4eaeb6b71.  The
submitter has disappeared.

The patch is trivial:

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -419,7 +419,7 @@
=20
 static const struct driver_info        cdc_info =3D {
        .description =3D  "CDC Ethernet Device",
-       .flags =3D        FLAG_ETHER | FLAG_LINK_INTR,
+       .flags =3D        FLAG_ETHER,
        // .check_connect =3D cdc_check_connect,
        .bind =3D         cdc_bind,
        .unbind =3D       usbnet_cdc_unbind,
--- END ---

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-CTGxYW/wRIyMvkqQRHHu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS0pY1ue/yOyVhhEJAQIETBAAjHzEcMauDJ+20rKaM64fzFXsPZAPIqzQ
2LlCTbxgMzPOZwnfcbP6DcLrEW2/cFQWtJiTKniQoUe1igKKokkju6icSOgJnV+n
yeNn7dVe+pVNuFDU/pKQPAMPy5aBGa81wtRk5ZwjX37VkV7ESq5QnLrYC+vku8PP
Yet02WABMnMap+KvI95rYCsnGb/oCWkSpMglCu7BEopBB0pRA9KdLjq0RhghngYm
TxVNcVbtYldeuTn/yZp8OI1+P0MLTwiB0bchbp/4IToiJWF94tFYmqQ7LdZj32mg
Osv/LWhdCiekQi5t5hTQ8Bmid5+kSPpn+cVSHfTkf2hsPbZ382GN9LTgy1ZLqnGj
ovxShXQs8wwDGNxcDJt770uaL1AQ5VT1xDUnOmCumGCJ4dQUllSsy3dRynjb/K9+
7SMrO2Nz3zm/6c9OVtxxGmYKtHuaDuTll/76m6mCkCwBXqyJ3SJntrKTdHQ0383Y
pHTmI69vq9m4GgpaKy5/K7UKiJ877SMWd9b3Kz+Jsc611NstDVi56kWmxK5j+Q5z
4nY14OUyYOT/HbGKm3JnFseqVcrkoesiP+N+K1LmnncXO+BOftOwvg/8PMEbzNtz
sblTrx2EySUgcI/dtzx6oiLt1Avfh1hMIEaJvib1kszo9C+APGFABICB7RS8Gg41
I5wYPJvTyY0=
=ivbo
-----END PGP SIGNATURE-----

--=-CTGxYW/wRIyMvkqQRHHu--
