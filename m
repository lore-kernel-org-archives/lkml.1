Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXKVCi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXKVCi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 21:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbXKVCiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 21:38:20 -0500
Received: from dovecot.org ([82.118.211.50]:42970 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbXKVCiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 21:38:20 -0500
X-Greylist: delayed 1721 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 21:38:20 EST
Subject: [PATCH] Allow changing O_SYNC with fcntl().
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zbLd/eZRd7fsy/l4S/U9"
Date: Thu, 22 Nov 2007 04:09:37 +0200
Message-Id: <1195697377.28091.26.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zbLd/eZRd7fsy/l4S/U9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Is there a reason why this isn't allowed now?

---
 fs/fcntl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 8685263..fc0c92e 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -203,7 +203,7 @@ asmlinkage long sys_dup(unsigned int fildes)
 	return ret;
 }
=20
-#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT |=
 O_NOATIME)
+#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | FASYNC | O_DIRECT |=
 O_NOATIME | O_SYNC)
=20
 static int setfl(int fd, struct file * filp, unsigned long arg)
 {


--=-zbLd/eZRd7fsy/l4S/U9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHROThyUhSUUBViskRAoY+AJ4oQaujqQ5ED3aPApQGg7/r+ArYSgCfVi3W
Il6V6l56ORJqctnLgMt8gwI=
=ZI0V
-----END PGP SIGNATURE-----

--=-zbLd/eZRd7fsy/l4S/U9--

