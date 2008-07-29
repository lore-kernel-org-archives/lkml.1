Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbYG2C3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbYG2C3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYG2C3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:29:04 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:58134 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYG2C3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:29:03 -0400
Date: Mon, 28 Jul 2008 21:28:40 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 28/30] W1: ds2490.c ds_write_block remove extra ds_wait_status
Message-ID: <20080729022840.GB24452@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yda//aIZIMrd7mir"
Content-Disposition: inline
In-Reply-To: <20080729020433.GA24424@spacedout.fries.net>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:28:41 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yda//aIZIMrd7mir
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Drop the extra ds_wait_status() in ds_write_block().

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index d9e07d6..466048f 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -648,8 +648,6 @@ static int ds_write_block(struct ds_device *dev, u8 *bu=
f, int len)
 	if (err < 0)
 		return err;
=20
-	ds_wait_status(dev, &st);
-
 	err =3D ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
 	if (err)
 		return err;
--=20
1.4.4.4

--yda//aIZIMrd7mir
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjoBYAI852cse6PARAnUxAJ9jQk7GDVYSZAJYkMRSL71xaPVS0QCgo80E
nV0vsrST1K3MYK9lTpu2s4w=
=m/cw
-----END PGP SIGNATURE-----

--yda//aIZIMrd7mir--
