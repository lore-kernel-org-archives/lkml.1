Return-Path: <linux-kernel-owner+w=401wt.eu-S1755218AbYKKDUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbYKKDUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYKKDUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:20:37 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60652 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYKKDUh (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:20:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: rc4-mmotm1110 - Another build error
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226373633_3458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 22:20:33 -0500
Message-ID: <38231.1226373633@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226373633_3458P
Content-Type: text/plain; charset=us-ascii

gcc --version says:
gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)

ka-blam number 2:

  CC      kernel/audit.o
In file included from include/net/dst.h:15,
                 from include/net/sock.h:57,
                 from kernel/audit.c:54:
include/net/neighbour.h:114: error: braced-group within expression allowed only inside a function
make[1]: *** [kernel/audit.o] Error 1

I'm placing bets on patches/align-avoid-evaluating-its-argument-twice.patch

Yep, revert that patch, and audit.o compiles again.

--==_Exmh_1226373633_3458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJGPoBcC3lWbTT17ARAprVAKCnzN/swRKeFLYtVGmM+Bwae2qPAACgwlpE
Zjds8i7tn/NbXg90zKzXpIc=
=tk6f
-----END PGP SIGNATURE-----

--==_Exmh_1226373633_3458P--
