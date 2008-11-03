Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYKCJQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYKCJQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbYKCJQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:16:23 -0500
Received: from mx40.mail.ru ([194.67.23.36]:54705 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279AbYKCJQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:16:21 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_get_physical_pci_device
Date: Mon, 3 Nov 2008 12:16:13 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2580284.8bpasYynaP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811031216.15690.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2580284.8bpasYynaP
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] Fix argument type for acpi_evaluate_integer in acpi_get_ph=
ysical_pci_device
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

CC      drivers/acpi/glue.o
/home/bor/src/linux-git/drivers/acpi/glue.c: In function 'acpi_get_physical=
_pci_device':
/home/bor/src/linux-git/drivers/acpi/glue.c:157: warning: passing argument =
4 of 'acpi_evaluate_integer' from incompatible pointer type

acpi_evaluate_integer takes pointer to unsigned long long as fourth argument

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/acpi/glue.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 98c9c76..436c8a3 100644
=2D-- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -150,7 +150,7 @@ EXPORT_SYMBOL(acpi_get_physical_device);
 struct device *acpi_get_physical_pci_device(acpi_handle handle)
 {
 	struct device *dev;
=2D	long device_id;
+	unsigned long long device_id;
 	acpi_status status;
=20
 	status =3D

--nextPart2580284.8bpasYynaP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkOwV8ACgkQR6LMutpd94yiWwCgxMdkhPNPfg50nlYC3EWwo5gu
c8cAoKm+xRainmJn5ipBLOSkl/qgF8G0
=4y5F
-----END PGP SIGNATURE-----

--nextPart2580284.8bpasYynaP--
