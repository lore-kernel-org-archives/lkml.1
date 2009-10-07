Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZJGCz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZJGCz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 22:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZJGCzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 22:55:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35248 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbZJGCzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 22:55:54 -0400
Date: Wed, 7 Oct 2009 13:55:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: block tree build failure
Message-Id: <20091007135505.df1f058c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Oct_2009_13_55_05_+1100_WGOGbk=59+JqOSwA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Oct_2009_13_55_05_+1100_WGOGbk=59+JqOSwA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
drivers/block/drbd/drbd_req.c:43: error: lvalue required as increment opera=
nd
drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
drivers/block/drbd/drbd_req.c:56: error: lvalue required as decrement opera=
nd

This is back again :-(

I have used the block tree from next-20091006 for today.  I also had to
use the device-mapper tree from next-20091006 since that is based on the
block tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Oct_2009_13_55_05_+1100_WGOGbk=59+JqOSwA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrMAwkACgkQjjKRsyhoI8wlDgCaAjX+tc7SlH8G0SOMYezFnOWt
6scAoJxOBXgNFWSBuHwMoQCoJPvN6h19
=WjqK
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Oct_2009_13_55_05_+1100_WGOGbk=59+JqOSwA--
