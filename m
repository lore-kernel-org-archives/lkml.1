Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbZGCAGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbZGCAGK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 20:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZGCAF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 20:05:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39035 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZGCAF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 20:05:56 -0400
Date: Fri, 3 Jul 2009 10:05:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@lst.de>,
       Felix Blyakher <felixb@sgi.com>
Subject: linux-next: xfs tree build failure
Message-Id: <20090703100551.e3f21aa0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__3_Jul_2009_10_05_51_+1000_flDlnoq/yzeTOhDc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Jul_2009_10_05_51_+1000_flDlnoq/yzeTOhDc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next build (x86_64 allmodconfig) failed like this:

fs/xfs/xfs_log_recover.c: In function 'xlog_recover_check_summary':
fs/xfs/xfs_log_recover.c:4046: error: implicit declaration of function 'xfs=
_read_agf'

Caused by commit 370f048214b4e9aa2102fa3c454ae1374da287c5 ("xfs: add more
statics & drop some unused functions").

I have used the xfs tree from next-20090702 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__3_Jul_2009_10_05_51_+1000_flDlnoq/yzeTOhDc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpNS18ACgkQjjKRsyhoI8wY+QCfVZysJFo5zF6EbO8ZfzsZB65G
qfwAoLoz5/zTWhXVrPFI+g3EklbJJSlc
=BWTK
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Jul_2009_10_05_51_+1000_flDlnoq/yzeTOhDc--
