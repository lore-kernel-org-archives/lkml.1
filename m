Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbZICXzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbZICXzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 19:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756586AbZICXzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 19:55:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50170 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574AbZICXzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 19:55:08 -0400
Date: Fri, 4 Sep 2009 09:55:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Felix Blyakher <felixb@sgi.com>
Subject: linux-next: manual merge of the xfs tree with the ext3 tree
Message-Id: <20090904095500.04205407.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Sep_2009_09_55_00_+1000_nDIOfB5+91cZ9WR6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Sep_2009_09_55_00_+1000_nDIOfB5+91cZ9WR6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in
fs/xfs/linux-2.6/xfs_lrw.c between commit
218604a0bf712976171798b1dd5c44d26d6d0ea4 ("xfs: Convert sync_page_range()
to simple filemap_write_and_wait_range()") from the ext3 tree and commit
13e6d5cdde0e785aa943810f08b801cadd0935df ("xfs: merge fsync and O_SYNC
handling") from the xfs tree.

They both do the same thing (to this bit of code) ... I used the version
from the xfs tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Sep_2009_09_55_00_+1000_nDIOfB5+91cZ9WR6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgV1QACgkQjjKRsyhoI8ziQQCdGHOw+/mptt+GHdFbKGBmQa3j
xqgAoIxaYf8/uwdfIOX4wb0E4jDHzBmV
=A3Xk
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Sep_2009_09_55_00_+1000_nDIOfB5+91cZ9WR6--
