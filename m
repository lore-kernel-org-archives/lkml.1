Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbZABKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbZABKQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZABKQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:16:09 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47093 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZABKQI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:16:08 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Henrik Rydberg <rydberg@euromail.se>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-mmotm1230 drivers/input/input.c warning msg
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230891358_3417P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Jan 2009 05:15:58 -0500
Message-ID: <27989.1230891358@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230891358_3417P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

patch input-allow-certain-ev_abs-events-to-bypass-all-filtering.patch
caused a new warning to be added to the compile:

  CC      drivers/input/input.o
drivers/input/input.c:1661: warning: function declaration isn=E2=80=99t a=
 prototype

Fix up the declaration so the compiler knows what the prototype is.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks=40vt.edu>

--- linux-2.6.28-mmotm1230/drivers/input/input.c.dist	2009-01-01 17:23:02=
.000000000 -0500
+++ linux-2.6.28-mmotm1230/drivers/input/input.c	2009-01-02 05:09:12.0000=
00000 -0500
=40=40 -1657,7 +1657,7 =40=40 static const struct file_operations inpu
 	.open =3D input_open_file,
 =7D;
=20
-static void __init input_init_abs_bypass()
+static void __init input_init_abs_bypass(void)
 =7B
 	const unsigned int *p;
 	for (p =3D input_abs_bypass_init_data; *p; p++)


--==_Exmh_1230891358_3417P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXelecC3lWbTT17ARAnd1AKCMlzIivYPz5GqEQ83E7+NQLvjivgCgnjej
0pD1pmzNli8xd/7cT42BEvU=
=7BzT
-----END PGP SIGNATURE-----

--==_Exmh_1230891358_3417P--
