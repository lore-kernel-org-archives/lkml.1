Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab0CKFQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 00:16:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55363 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab0CKFQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 00:16:05 -0500
Date: Thu, 11 Mar 2010 16:15:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kbuild tree
Message-Id: <20100311161559.fcdfc6dc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Mar_2010_16_15_59_+1100_eurSYPiOY/gOTaeq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Mar_2010_16_15_59_+1100_eurSYPiOY/gOTaeq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

After merging the kbuild tree, a build like
"make modules modules_install" failed like this:

cp: cannot stat `/home/sfr/kernels/ntest.obj/modules.builtin': No such file=
 or directory

Caused by commit a6c366324cacd5f71107dd01362b995a1c67b1ad ("kbuild: Do
not unnecessarily regenerate modules.builtin").  I have reverted that
commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Mar_2010_16_15_59_+1100_eurSYPiOY/gOTaeq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuYfI8ACgkQjjKRsyhoI8ySJQCfYu4XIjZrjd8h6xxjoKCnP/rc
bi8AnAyoTGsXtvNkgvaZnDodzDbMNW0y
=0hAS
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Mar_2010_16_15_59_+1100_eurSYPiOY/gOTaeq--
