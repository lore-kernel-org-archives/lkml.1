Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXL2CXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXL2CXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbXL2CWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:22:54 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50358 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038AbXL2CWx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:22:53 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.6.24-rc6-mm1 - document 'make prepare' in 'make help'
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1198894968_2814P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Dec 2007 21:22:48 -0500
Message-ID: <25749.1198894968@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1198894968_2814P
Content-Type: text/plain; charset=us-ascii

The output of 'make help' covers a lot of options, but doesn't include
a listing for 'make prepare'.  Here's a one-liner to fix that...

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
---
--- linux-2.6.24-rc6-mm1/Makefile.prepare	2007-12-28 21:16:18.000000000 -0500
+++ linux-2.6.24-rc6-mm1/Makefile	2007-12-28 21:18:13.000000000 -0500
@@ -1181,6 +1181,7 @@ help:
 	@echo  '  dir/            - Build all files in dir and below'
 	@echo  '  dir/file.[ois]  - Build specified target only'
 	@echo  '  dir/file.ko     - Build module including final link'
+	@echo  '  prepare         - Set up for building external modules'
 	@echo  '  rpm		  - Build a kernel as an RPM package'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'


--==_Exmh_1198894968_2814P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHda94cC3lWbTT17ARAsPgAJwN8Vm3uNFdt4VFJoJVdb3W9BVk6gCfWPuz
pox8WhzPUkUcktyRcZJNVss=
=F6Gd
-----END PGP SIGNATURE-----

--==_Exmh_1198894968_2814P--
