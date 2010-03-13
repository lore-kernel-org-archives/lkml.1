Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933295Ab0CMQ3z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 11:29:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:56969 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab0CMQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 11:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=wdWES3zd6Jz8/mYrQiFTNZ7UxV9rpKteKcJfxJXxjjzJm3LUWd15AUIFdnYj21N+Cm
         WRGJDZQgHW65Jy1Dqhv4eixoINMcP3L12zpqkuvRI2P6nUVOEfvsBG29MaPxPL4IydYr
         i5Vltq7SLzoXo4zQdWiHcFwJKkFgF23+CcjZ8=
From: Markus Rathgeb <rathgeb.markus@googlemail.com>
To: zinx@epicsol.org
Subject: [PATCH 2.6.33] hid-tmff: Add RGT ff clutch device id
Date: Sat, 13 Mar 2010 17:29:43 +0100
User-Agent: KMail/1.13.1 (Linux/2.6.33-gentoo; KDE/4.4.1; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1752502.yV2X9y86Vr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201003131729.48645.rathgeb.markus@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1752502.yV2X9y86Vr
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

=46rom: Markus Rathgeb

This patch enables force feedback for the "RGT Force Feedback CLUTCH Racing=
 Wheel".
It only modifies hid-core.c (hid_blacklist) and hid-tmff.c to add the new U=
SB IDs.

Signed-off-by: Markus Rathgeb <rathgeb.markus@googlemail.com>
=2D--
=2D-- a/a/drivers/hid/hid-core.c
+++ b/b/drivers/hid/hid-core.c
@@ -1347,6 +1347,7 @@ static const struct hid_device_id hid_blacklist[] =3D=
 {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb653) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) =
},
 	{ HID_USB_DEVICE(USB_VENDOR_ID_TWINHAN, USB_DEVICE_ID_TWINHAN_IR_REMOTE) =
},
diff --git a/a/drivers/hid/hid-tmff.c b/b/drivers/hid/hid-tmff.c
index 167ea74..c32f32c 100644
=2D-- a/a/drivers/hid/hid-tmff.c
+++ b/b/drivers/hid/hid-tmff.c
@@ -251,6 +251,8 @@ static const struct hid_device_id tm_devices[] =3D {
 		.driver_data =3D (unsigned long)ff_rumble },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),	/* FGT Rumble Force=
 Wheel */
 		.driver_data =3D (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb653),	/* RGT Force Feedba=
ck CLUTCH Raging Wheel */
+		.driver_data =3D (unsigned long)ff_joystick },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654),	/* FGT Force Feedba=
ck Wheel */
 		.driver_data =3D (unsigned long)ff_joystick },
 	{ }

=2D-=20
Markus Rathgeb
Public Key Server: http://wwwkeys.us.pgp.net/ bzw. hkp://wwwkeys.us.pgp.net/
Public Key Server: http://stinkfoot.org:11371/ bzw. hkp://stinkfoot.org

--nextPart1752502.yV2X9y86Vr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEABECAAYFAkubvXwACgkQuSMlFb8kR62CXACcDxHLAyCfzoQgCA8QHdlj7VmT
FHcAn0YoXJw3+jsnlzg4FcCH/3q91CaB
=IRUA
-----END PGP SIGNATURE-----

--nextPart1752502.yV2X9y86Vr--
