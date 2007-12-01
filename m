Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbXLBCzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbXLBCzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 21:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXLBCzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 21:55:37 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35408 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXLBCzg (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 21:55:36 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morgan <morgan@kernel.org>
Cc: Serge Hallyn <serue@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: 2.6.24-rc3-mm2 - add-64-bit-capability-support-to-the-kernel
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196497105_14671P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 01 Dec 2007 03:18:25 -0500
Message-ID: <14896.1196497105@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196497105_14671P
Content-Type: text/plain; charset=us-ascii

Question:

The patch does the semantic equivalent of:

-#define cap_clear(c)         do { cap_t(c) =  0; } while(0)
-#define cap_set_full(c)      do { cap_t(c) = ~0; } while(0)

+# define cap_clear(c)         do { (c) = __cap_empty_set; } while (0)
+# define cap_set_full(c)      do { (c) = __cap_full_set; } while (0)
+# define cap_set_init_eff(c)  do { (c) = __cap_init_eff_set; } while (0)

Was it intentional, or an oversight, that this blows chunks in modules
that try to use cap_clear() or cap_set_full() because the __cap_*
symbols don't get an EXPORT_SYMBOL() attached to them?

--==_Exmh_1196497105_14671P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHURjRcC3lWbTT17ARAtyWAJ9sAjP1nncitZQA2tXicjSH9dW3mwCg34lK
klnW8mlw8PkCgPqcCd3OrGA=
=1w2j
-----END PGP SIGNATURE-----

--==_Exmh_1196497105_14671P--
