Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbYGHJbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbYGHJbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbYGHJbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:31:31 -0400
Received: from mxpdbe1.wincor-nixdorf.com ([80.154.98.129]:54841 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394AbYGHJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:31:30 -0400
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jul 2008 05:31:30 EDT
Message-ID: <48733119.5080502@wincor-nixdorf.com>
Date: Tue, 08 Jul 2008 11:19:21 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.14 (X11/20080526)
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] serio.h: trivial documentation fix
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig25BF37E1391462482A0740CD"
X-OriginalArrivalTime: 08 Jul 2008 09:20:12.0389 (UTC) FILETIME=[D3150950:01C8E0DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25BF37E1391462482A0740CD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

In include/linux/serio.h two different define-series are
documented as "Serio types". However the second series contains
defines for the different protocols.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>
---
diff --git a/include/linux/serio.h b/include/linux/serio.h
index 95674d9..1ed3998 100644
--- a/include/linux/serio.h
+++ b/include/linux/serio.h
@@ -175,7 +175,7 @@ static inline void serio_unpin_driver(struct serio *s=
erio)
#define SERIO_8042_XL  0x06

/*
- * Serio types
+ * Serio protocols
 */
#define SERIO_UNKNOWN  0x00
#define SERIO_MSC      0x01


--------------enig25BF37E1391462482A0740CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFIczEZ5KAkGQPO/QoRAvbAAKDWdy0JFEJcTZtTEJUh9oTHBZXXnwCfdSdF
uGS7Kx8JZvRdV3/MtPmo31M=
=0MwQ
-----END PGP SIGNATURE-----

--------------enig25BF37E1391462482A0740CD--
