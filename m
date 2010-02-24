Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0BXIF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:05:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0BXIF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:05:26 -0500
Date: Wed, 24 Feb 2010 19:05:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: linux-next: build warning after merge of the ext3 tree
Message-Id: <20100224190520.8cd15930.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Feb_2010_19_05_20_+1100_lpnvOsvUXievMj6o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Feb_2010_19_05_20_+1100_lpnvOsvUXievMj6o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

After merging the ext3 tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

fs/gfs2/quota.c:1581: warning: initialization from incompatible pointer type

Introduced by commit ec304a27d7750ba666ad2d446434ddd47fa93c40 ("quota:
move code from sync_quota_sb into vfs_quota_sync").  From the commit
message, I expect that this has been thought about.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Feb_2010_19_05_20_+1100_lpnvOsvUXievMj6o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuE3cAACgkQjjKRsyhoI8yKegCfWux2UzaWBDgoMycPF/iusA+T
QsAAn2QFs9dJzkMm6bnfgJH3K5X0yGKu
=o08c
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Feb_2010_19_05_20_+1100_lpnvOsvUXievMj6o--
