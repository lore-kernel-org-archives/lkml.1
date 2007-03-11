Return-Path: <linux-kernel-owner+w=401wt.eu-S1750709AbXCKUoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750709AbXCKUoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 16:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750894AbXCKUoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 16:44:06 -0400
Received: from redmars.org ([85.13.250.71]:34307 "EHLO vercetti.redmars.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXCKUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 16:44:05 -0400
X-Greylist: delayed 2413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Mar 2007 16:44:05 EDT
Date: Sun, 11 Mar 2007 20:03:03 +0000
To: linux-usb-devel@lists.sourceforge.net
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] two more device ids for dm9601 usbnet driver
Message-ID: <20070311200303.GB4299@konishi.dowland>
Mail-Followup-To: linux-usb-devel@lists.sourceforge.net,
	Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jon Dowland <jon@alcopop.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch for the linux-usb-devel tree adds two more
product ids to the dm9601 driver. These ids were found on
rebadged dm9601 devices in the wild.

Signed-off-by: Jon Dowland <jon@alcopop.org>

---
 drivers/usb/net/dm9601.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/net/dm9601.c b/drivers/usb/net/dm9601.c
index 4a932e1..26ad64f 100644
--- a/drivers/usb/net/dm9601.c
+++ b/drivers/usb/net/dm9601.c
@@ -574,6 +574,14 @@ static const struct usb_device_id products[] =3D {
 	 USB_DEVICE(0x0a46, 0x9601),	/* Davicom USB-100 */
 	 .driver_info =3D (unsigned long)&dm9601_info,
 	 },
+	{
+	 USB_DEVICE(0x0a46, 0x6688),	/* ZT6688 USB NIC */
+	 .driver_info =3D (unsigned long)&dm9601_info,
+	 },
+	{
+	 USB_DEVICE(0x0a46, 0x0268),	/* ShanTou ST268 USB NIC */
+	 .driver_info =3D (unsigned long)&dm9601_info,
+	 },
 	{},			// END
 };
=20
--=20
1.4.4.2

--=20
Jon Dowland

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF9GB3FotOcXAy8jgRAvmsAKCXNJzTL89Z/xif7zkxWBk0n18+tACeNedY
ZTS6boiQy5wQ4mos52OYHyc=
=J2qG
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
