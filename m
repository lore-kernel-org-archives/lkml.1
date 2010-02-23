Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab0BWC0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 21:26:34 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57644 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab0BWC0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 21:26:32 -0500
Date: Tue, 23 Feb 2010 13:26:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       dann frazier <dannf@hp.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100223132619.e6f5ff0e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_13_26_19_+1100_OEfkwZWuAxQ9Lf8X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_13_26_19_+1100_OEfkwZWuAxQ9Lf8X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

usr/include/linux/cciss_ioctl.h:6: included file 'linux/cciss_defs.h' is no=
t exported

Caused by commit 429c42c9d246f5bda868495c09974312a0177328 ("cciss:
Consolidate duplicate bits in cciss_cmd.h & cciss_ioctl.h").

I have used the block tree from next-20100222 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_13_26_19_+1100_OEfkwZWuAxQ9Lf8X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDPMsACgkQjjKRsyhoI8xKmACgkFrUIZJapGOXEbmEnShHgEhc
pm0Aniz60CD4/sgePHpEC3u2XcIbgKIP
=zGDJ
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_13_26_19_+1100_OEfkwZWuAxQ9Lf8X--
