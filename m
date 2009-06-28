Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbZF1RDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbZF1RDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 13:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZF1RDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 13:03:05 -0400
Received: from storm.alittletooquiet.net ([67.23.28.199]:60043 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbZF1RC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 13:02:57 -0400
Date: Sun, 28 Jun 2009 13:03:01 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Woody Suwalski <woodys@xandros.com>,
       =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
       Harald Welte <HaraldWelte@viatech.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] Build vt6656.ko, not vntwusb.ko.
Message-ID: <20090628170301.GF9143@alittletooquiet.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="glwmnIOgU1tcuP7N"
Content-Disposition: inline
In-Reply-To: <200906281759.46152.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--glwmnIOgU1tcuP7N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Greg: This patch series does not differ from that which you already have.]

Build vt6656.ko, not vntwusb.ko.

Signed-off-by: Forest Bond <forest@alittletooquiet.net>
---
 drivers/staging/vt6656/device_cfg.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/vt6656/device_cfg.h b/drivers/staging/vt6656/d=
evice_cfg.h
index c0492bd..f272c98 100644
--- a/drivers/staging/vt6656/device_cfg.h
+++ b/drivers/staging/vt6656/device_cfg.h
@@ -89,7 +89,7 @@ struct _version {
 #define VCAM_SIZE           32
 #define TX_QUEUE_NO         8
=20
-#define DEVICE_NAME         "vntwusb"
+#define DEVICE_NAME         "vt6656"
 #define DEVICE_FULL_DRV_NAM "VIA Networking Wireless LAN USB Driver"
=20
 #ifndef MAJOR_VERSION
--=20
1.5.6.3


--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--glwmnIOgU1tcuP7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKR6JFRO4fQQdv5AwRAv8OAKDSCyaxY13wO8jPAf7hkotZzTNkpQCgkP4h
VVcERi7WWye6ZwXX+Vq0blk=
=vVTF
-----END PGP SIGNATURE-----

--glwmnIOgU1tcuP7N--
