Return-Path: <linux-kernel-owner+w=401wt.eu-S1754231AbZHJA6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbZHJA6Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 20:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZHJA6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 20:58:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55911 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbZHJA6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 20:58:14 -0400
Date: Mon, 10 Aug 2009 10:58:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: nfs tree build warning
Message-Id: <20090810105806.266011df.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_10_58_06_+1000_Kyck1GX7TlHAUSrP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_10_58_06_+1000_Kyck1GX7TlHAUSrP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

fs/nfs/write.c: In function 'nfs_migrate_page':
fs/nfs/write.c:1601: warning: unused variable 'inode'

Introduced by commit 1ec000f4f76ea914aa4ac57f8cec53fa958bd477 ("NFS: Add
a ->migratepage() aop for NFS").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_10_58_06_+1000_Kyck1GX7TlHAUSrP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/cJ4ACgkQjjKRsyhoI8zg7wCfREjz/cNo5drIst5lCzp3chdI
d3EAnRxIXeA+jP3eoiZiS2u4iaLJA66o
=OrS0
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_10_58_06_+1000_Kyck1GX7TlHAUSrP--
