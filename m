Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYGUNIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYGUNIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 09:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYGUNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 09:08:04 -0400
Received: from ns0.wincor-nixdorf.com ([80.154.98.130]:55156 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYGUNID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 09:08:03 -0400
Message-ID: <488489D4.2030604@wincor-nixdorf.com>
Date: Mon, 21 Jul 2008 15:06:28 +0200
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.14 (X11/20080526)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] linux/fs.h: include linux/path.h
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF0B8691EC9CE93FA897B1B17"
X-OriginalArrivalTime: 21 Jul 2008 13:07:27.0512 (UTC) FILETIME=[B99E7180:01C8EB32]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0B8691EC9CE93FA897B1B17
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

In linux/fs.h 'struct path' is being used. Therefore linux/path.h should
be included.

Signed-off-by: Niels de Vos <niels.devos@wincor-nixdorf.com>

---
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d8e2762..a14f1c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -289,6 +289,7 @@ extern int dir_notify_enable;
 #include <linux/mutex.h>
 #include <linux/capability.h>
 #include <linux/semaphore.h>
+#include <linux/path.h>
=20
 #include <asm/atomic.h>
 #include <asm/byteorder.h>




--------------enigF0B8691EC9CE93FA897B1B17
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFIhInU5KAkGQPO/QoRAroaAKC/cxCF4F9TnzzKEieqsMLxThakSwCfVagV
A3uBlVEZMXzvaU9qNkH5wMQ=
=hYvX
-----END PGP SIGNATURE-----

--------------enigF0B8691EC9CE93FA897B1B17--
