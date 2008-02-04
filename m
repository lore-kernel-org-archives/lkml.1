Return-Path: <linux-kernel-owner+w=401wt.eu-S1755666AbYBDOYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666AbYBDOYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYBDOY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:24:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:58711 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYBDOY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id:mime-version:x-mailer;
        b=ZXhqUNIg7v1EV2PVq5PCapxG95M3ORyb90BYndQrsA+lFaq4WpPaM5I7xrAgywQCtr+44Sb5EUqfn+o3b9JdjHdE8V4fu8xZNwJc2i2WBFO5qeHNBMHkMHdN+Wtxq2qyPKkppFfCVaI8ijWUtRctmMDvTplYN7FUDmaXINtLQjc=
Subject: [PATCH] sata_via.c: Remove missleading comment.
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zMX+Gd2l5iOL7vA67gIj"
Date: Mon, 04 Feb 2008 15:19:52 +0100
Message-Id: <1202134792.5671.7.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zMX+Gd2l5iOL7vA67gIj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Maybe for the trivial tree...


sata_via.c has PATA support since:

  d73f30e1c9a9af14757fa5bf4014343926047156
  =20
  sata_via: PATA support

AFAICS so the TODO list is no longer true.


---
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 3ef072f..30caa03 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -30,8 +30,6 @@
  *  Hardware documentation available under NDA.
  *
  *
- *  To-do list:
- *  - VT6421 PATA support
  *
  */
=20


--=-zMX+Gd2l5iOL7vA67gIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Esta parte del mensaje =?ISO-8859-1?Q?est=E1?= firmada
	digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iEYEABECAAYFAkenHwgACgkQ3GEkiSnUSOHetwCdFXNXQnpsSofSSQNzenzvlUpg
VjIAnRR7ch5/OUjDJHNg9aimS/OM1pVB
=wHm7
-----END PGP SIGNATURE-----

--=-zMX+Gd2l5iOL7vA67gIj--

