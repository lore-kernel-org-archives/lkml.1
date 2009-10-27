Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZJ0Deh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZJ0Deh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 23:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZJ0Deg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 23:34:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39807 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZJ0Deg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 23:34:36 -0400
Date: Tue, 27 Oct 2009 14:34:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: block tree build failure
Message-Id: <20091027143433.bfe08a1b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__27_Oct_2009_14_34_33_+1100_dLutrKo/t/gblJhA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Oct_2009_14_34_33_+1100_dLutrKo/t/gblJhA
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

This is the dual in_flight changes breaking again ... I have used the
block tree from next-20091026 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__27_Oct_2009_14_34_33_+1100_dLutrKo/t/gblJhA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrmakkACgkQjjKRsyhoI8wlxwCfTt+6UIUjfLAO6Phy4Q8okJ5K
KiUAoLOy3eq2iSFrpCZTjg/vNBF4EUOO
=ojpF
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Oct_2009_14_34_33_+1100_dLutrKo/t/gblJhA--
