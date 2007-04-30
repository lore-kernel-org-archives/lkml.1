Return-Path: <linux-kernel-owner+w=401wt.eu-S1030908AbXD3LSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030908AbXD3LSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030929AbXD3LSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:18:44 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:34382 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030927AbXD3LSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:18:43 -0400
Message-ID: <4635D019.7010906@web.de>
Date: Mon, 30 Apr 2007 13:16:41 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@suse.de>
Subject: [KJ][PATCH] i386: white space fixes in i387.h
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig18145B8300DBC54CD60679CA"
X-Provags-ID: V01U2FsdGVkX1/A4kOuuOxqXtNnKdvMcPhw6D9CuqFTnPhf/HA6
	lOVkvAWrp6iAF6TwbjaEQYs20SdW67ioCiRBYBXMJknIrIjw7C
	OQI7rFVyU=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig18145B8300DBC54CD60679CA
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 include/asm-i386/i387.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/include/asm-i386/i387.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/include/asm-i386/i387.h
+++ linux-2.6/include/asm-i386/i387.h
@@ -83,8 +83,8 @@ static inline void __save_init_fpu( stru
=20
 #define __clear_fpu( tsk )					\
 do {								\
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {		\
-		asm volatile("fnclex ; fwait");				\
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
+		asm volatile("fnclex ; fwait");			\
 		task_thread_info(tsk)->status &=3D ~TS_USEDFPU;	\
 		stts();						\
 	}							\
@@ -113,7 +113,7 @@ static inline void save_init_fpu( struct
 	__clear_fpu( tsk );	\
 	preempt_enable();	\
 } while (0)
-					\
+
 /*
  * FPU state interaction...
  */


--------------enig18145B8300DBC54CD60679CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGNdAZniDOoMHTA+kRAqTZAJ9y6QfcSHDYE1qNau2sMLiAts6twACfbl5m
I5vTnIFHA2j8f/Wjt8HvVDA=
=QtLt
-----END PGP SIGNATURE-----

--------------enig18145B8300DBC54CD60679CA--
