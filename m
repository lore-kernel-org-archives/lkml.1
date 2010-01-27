Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200Ab0A0Ah0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0A0Ah0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117Ab0A0AhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:37:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46206 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab0A0AhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:37:24 -0500
Date: Wed, 27 Jan 2010 11:37:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: vfs tree build failure
Message-Id: <20100127113718.5177ceb1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Jan_2010_11_37_18_+1100_gXBG=lKdb/T964xd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jan_2010_11_37_18_+1100_gXBG=lKdb/T964xd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "ima_path_check" [fs/nfsd/nfsd.ko] undefined!

Caused by commit b35d5b4f7f47215f322bc6d9a1fd8499c11455d2 ("Fix
untangling ima mess, part 2 with counters").

I have used the vfs tree from next-20100125 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Jan_2010_11_37_18_+1100_gXBG=lKdb/T964xd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktfir4ACgkQjjKRsyhoI8wHjgCgpv+KFgJbkKapRzl5460remmX
11AAn3om+4g69Pj9lPSJwUrDixLmcAo7
=4uB/
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jan_2010_11_37_18_+1100_gXBG=lKdb/T964xd--
