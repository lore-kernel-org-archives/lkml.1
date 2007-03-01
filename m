Return-Path: <linux-kernel-owner+w=401wt.eu-S965522AbXCAT3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965522AbXCAT3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965525AbXCAT3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:29:12 -0500
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:56911 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965522AbXCAT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:29:11 -0500
Message-ID: <45E7297F.4030901@freedesktop.org>
Date: Thu, 01 Mar 2007 11:29:03 -0800
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rcutorture: Mark rcu_torture_init as __init
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig13E6027D5E6093DA793A6A70"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig13E6027D5E6093DA793A6A70
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Josh Triplett <josh@freedesktop.org>
---
The corresponding rcu_torture_cleanup cannot get marked as __exit, becaus=
e
rcu_torture_init uses it to clean up if init fails.

 kernel/rcutorture.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 7258bcb..df49eca 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -866,7 +866,7 @@ rcu_torture_cleanup(void)
 		rcu_torture_print_module_parms("End of test: SUCCESS");
 }
=20
-static int
+static int __init
 rcu_torture_init(void)
 {
 	int i;


--------------enig13E6027D5E6093DA793A6A70
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF5ymAGJuZRtD+evsRAkL/AJ0dXKJBm+fcib6FRvVJ6mGHGwd7tQCdE5G0
7wo1xqjBuYZaVt13dIevQ/Y=
=unCT
-----END PGP SIGNATURE-----

--------------enig13E6027D5E6093DA793A6A70--
