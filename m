Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZA3KPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZA3KPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZA3KPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:15:37 -0500
Received: from ns1.wincor-nixdorf.com ([80.154.98.129]:54945 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751824AbZA3KPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:15:36 -0500
Message-ID: <4982D1A3.4070706@wincor-nixdorf.com>
Date: Fri, 30 Jan 2009 11:08:35 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: trivial@kernel.org
CC: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH (trivial)] MTD: remove EOL from MODULE_DESCRIPTION
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BCEAD3C1F702A74164C9974"
X-OriginalArrivalTime: 30 Jan 2009 10:11:38.0308 (UTC) FILETIME=[23876840:01C982C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BCEAD3C1F702A74164C9974
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

There is no need to have a "\n" on a MODULE_DESCRIPTION, remove it.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

---
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.=
c
index e4226e0..e51c1ed 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1773,4 +1773,4 @@ module_exit(cleanup_nanddoc);
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium=
 Plus device driver\n");
+MODULE_DESCRIPTION("M-Systems DiskOnChip 2000, Millennium and Millennium=
 Plus device driver");



--------------enig5BCEAD3C1F702A74164C9974
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJgtGj5KAkGQPO/QoRAv2xAJ9USus6RuMV0GtEiRyK2qX5/xnDCgCgsco0
4pKPISonhArkgdvkWyr9HqM=
=Glda
-----END PGP SIGNATURE-----

--------------enig5BCEAD3C1F702A74164C9974--
