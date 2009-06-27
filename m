Return-Path: <linux-kernel-owner+w=401wt.eu-S1755272AbZF0O7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272AbZF0O7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 10:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbZF0O7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 10:59:04 -0400
Received: from zucker.schokokeks.org ([78.46.69.5]:52311 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbZF0O7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 10:59:03 -0400
X-Greylist: delayed 304 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Jun 2009 10:59:03 EDT
From: Hanno =?utf-8?q?B=C3=B6ck?= <hanno@hboeck.de>
To: smurf@smurf.noris.de
Subject: [PATCH] option.c: Support QUALCOMM iCON 210
Date: Sat, 27 Jun 2009 16:53:49 +0200
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1660497.IUooApq6mX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906271653.49970.hanno@hboeck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1660497.IUooApq6mX
Content-Type: multipart/mixed;
  boundary="Boundary-01=_9JjRKz1UQCe2V3q"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_9JjRKz1UQCe2V3q
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

Attached is a patch for option.c to support the QUALCOMM HSDPA-Stick iCON 2=
10.

There was an earlier patch (http://patchwork.kernel.org/patch/29709/) that=
=20
wasn't applied.

I was a bit unsure how to handle it as it contians not the known qualcomm=20
vendor id. Maybe it's from some third-party vendor, though it's unknown in=
=20
usb.ids.
I've named the variable QUALCOMM_ICON_VENDOR_ID, hope this is ok, else give=
 me=20
feedback how to handle that.

Please apply. CC me on all answers, as I'm not subscribed to the mailing=20
lists.

cu,

=2D-=20
Hanno B=C3=B6ck		Blog:		http://www.hboeck.de/
GPG: 3DBD3B20		Jabber/Mail:	hanno@hboeck.de

http://schokokeks.org - professional webhosting

--Boundary-01=_9JjRKz1UQCe2V3q
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="option-icon210.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="option-icon210.diff"

=2D-- linux-2.6.30-crap/drivers/usb/serial/option.c	2009-06-10 05:05:27.000=
000000 +0200
+++ linux-2.6.30/drivers/usb/serial/option.c	2009-06-27 14:13:56.000000000 =
+0200
@@ -285,6 +285,9 @@
=20
 #define QUALCOMM_VENDOR_ID			0x05C6
=20
+#define QUALCOMM_ICON_VENDOR_ID			0x1E0E
+#define QUALCOMM_ICON_PRODUCT_210		0x9000
+
 #define MAXON_VENDOR_ID				0x16d8
=20
 #define TELIT_VENDOR_ID				0x1bc7
@@ -513,6 +516,7 @@
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
+	{ USB_DEVICE(QUALCOMM_ICON_VENDOR_ID, QUALCOMM_ICON_PRODUCT_210)}, /* Qua=
lcomm iCON 210 */
 	{ USB_DEVICE(MAXON_VENDOR_ID, 0x6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_UC864E) },
 	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622) },

--Boundary-01=_9JjRKz1UQCe2V3q--

--nextPart1660497.IUooApq6mX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkpGMn0ACgkQr2QksT29OyCFUgCfSJzVIucTc0eb6lX3idms3N/4
qaAAniZpVzQwh4T1h71VCgkPlGJibWYk
=SvVs
-----END PGP SIGNATURE-----

--nextPart1660497.IUooApq6mX--
