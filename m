Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZJEDgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZJEDgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 23:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758426AbZJEDgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 23:36:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34725 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758346AbZJEDgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 23:36:36 -0400
Date: Mon, 5 Oct 2009 14:35:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Subject: linux-next: block/drbd tree build failure
Message-Id: <20091005143552.977a2d4d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_14_35_52_+1100_2ZCHj9cMIv.fPR.Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_14_35_52_+1100_2ZCHj9cMIv.fPR.Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
drivers/block/drbd/drbd_req.c:43: error: subscripted value is neither array=
 nor pointer
drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
drivers/block/drbd/drbd_req.c:56: error: subscripted value is neither array=
 nor pointer

I reported a similar error against the dbd tree, which was fixed, but now
the commit that caused that error has been reverted and thus we get
this :-(

I have reverted the drbd commits from the block tree for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Oct_2009_14_35_52_+1100_2ZCHj9cMIv.fPR.Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJaZgACgkQjjKRsyhoI8wJVACgqTXbwMTIz4i4e7dAsoonH1Rk
gLUAn12cxosRRzbpeEeDygaWaFQVcSiq
=xTzB
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_14_35_52_+1100_2ZCHj9cMIv.fPR.Z--
