Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZENWXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZENWXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 18:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZENWXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 18:23:39 -0400
Received: from dovecot.org ([82.118.211.50]:47150 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863AbZENWXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 18:23:39 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 May 2009 18:23:38 EDT
Subject: ext3/ext4 directories don't shrink after deleting lots of files
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UyXqKQlYD3/uo4g/C+IM"
Date: Thu, 14 May 2009 18:02:03 -0400
Message-Id: <1242338523.6933.664.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UyXqKQlYD3/uo4g/C+IM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I've noticed that if you create e.g. 100k files to a directory and then
delete the files, the directory entry still seems to take a couple of
megabytes. Later whenever accessing the (almost empty) directory it can
take a few seconds to load it into cache.

Is there a way to shrink the directory somehow without having to rmdir()
it? Would be nice if kernel did it automatically, but I could live with
a manual userspace syscall/tool as well.


--=-UyXqKQlYD3/uo4g/C+IM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoMlNsACgkQyUhSUUBVisndUACfQ7KJuuSvpU7WZqBpTEMfGvTj
UywAoIF5rsv1oJc8rsfcUlG0ivfJl0Nm
=0EY9
-----END PGP SIGNATURE-----

--=-UyXqKQlYD3/uo4g/C+IM--

