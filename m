Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbYB1SOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbYB1SOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750983AbYB1SOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:14:34 -0500
Received: from mx40.mail.ru ([194.67.23.36]:50028 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbYB1SOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:14:33 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org, linux-iinput@vger.kernel.org
Subject: [PATCH] [repost] Make real parent for ACPI button input devices
Date: Thu, 28 Feb 2008 21:14:26 +0300
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1281105.KvUD347ZHE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802282114.28680.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1281105.KvUD347ZHE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

Make sure input device for  ACPI button gets proper place
in device tree.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/button.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 24a7865..6c5da83 100644
=2D-- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -449,6 +449,7 @@ static int acpi_button_add(struct acpi_device *device)
 	input->phys =3D button->phys;
 	input->id.bustype =3D BUS_HOST;
 	input->id.product =3D button->type;
+	input->dev.parent =3D &device->dev;
=20
 	switch (button->type) {
 	case ACPI_BUTTON_TYPE_POWER:

--nextPart1281105.KvUD347ZHE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)

iEYEABECAAYFAkfG+gQACgkQR6LMutpd94yFxACfQDC7FHpvGB7NGdgZmh8HWzpu
gecAoMpvzjklvQe/Lar9uCrWcAaQRnz8
=Ea3A
-----END PGP SIGNATURE-----

--nextPart1281105.KvUD347ZHE--
