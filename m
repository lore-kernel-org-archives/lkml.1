Return-Path: <linux-kernel-owner+w=401wt.eu-S1759641AbYBWOhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759641AbYBWOhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 09:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbYBWOhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 09:37:10 -0500
Received: from mx48.mail.ru ([194.67.23.226]:2960 "EHLO mx48.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbYBWOhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 09:37:08 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI: add ACPI aliases to toshiba_acpi module
Date: Sat, 23 Feb 2008 17:36:46 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Olivier Blin <blino@mandriva.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3619050.yedp1jv414";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802231736.50346.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3619050.yedp1jv414
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] ACPI: add ACPI aliases to toshiba_acpi module
=46rom: Andrey Borzenkov < arvidjaar@mail.ru>

This adds aliases to enable autoloading of toishiba_acpi. Two aliases
are defined - TOS6200 (for \\_SB_.VALD.GHCI) and TSO1900 (for
\\_SB_.VALZ.GHCI). This allows toishiba_acpi to be autoloaded on
systems that provide those devices.

Signed-off-by: Andrey Borzenkov < arvidjaar@mail.ru>

=2D--

TOS6200 case is tested by me. I do not have device with TOS1900 and gathere=
d HID
from searching available information on Iternet.

 drivers/acpi/toshiba_acpi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 9e8c20c..0a43c8e 100644
=2D-- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -99,6 +99,13 @@ MODULE_LICENSE("GPL");
 #define HCI_VIDEO_OUT_CRT		0x2
 #define HCI_VIDEO_OUT_TV		0x4
=20
+static const struct acpi_device_id toshiba_device_ids[] =3D {
+	{"TOS6200", 0},
+	{"TOS1900", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, toshiba_device_ids);
+
 /* utility
  */
=20

--nextPart3619050.yedp1jv414
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkfAL38ACgkQR6LMutpd94wQkACeP2h5Rj/3nYDBF4ldiMl5KqC6
pm4AnReJJVo61385tV+vXfKqJKKiFlTd
=dq5S
-----END PGP SIGNATURE-----

--nextPart3619050.yedp1jv414--
