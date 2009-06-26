Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbZFZCxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbZFZCxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752390AbZFZCxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:53:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45710 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242AbZFZCxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:53:34 -0400
Date: Fri, 26 Jun 2009 12:53:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>
Subject: linux-next: block tree build failure
Message-Id: <20090626125331.89c689f2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Jun_2009_12_53_31_+1000_J_SIOY2nSiBHFCjq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jun_2009_12_53_31_+1000_J_SIOY2nSiBHFCjq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

block/blk-core.c: In function '__make_request':
block/blk-core.c:1179: error: expected ';' before 'return'

Caused by commit 6cf2a6c8d01514e86a8d38e4eeed402378b635dc ("Restore
barrier support for md and probably other virtual devices") which I have
reverted for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Jun_2009_12_53_31_+1000_J_SIOY2nSiBHFCjq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpEOCsACgkQjjKRsyhoI8xPCwCfXNr7+EWwLKTVu+VWAmVuSY5U
toMAoIN8IaMNlfmZoXLT9st+blmQnWIb
=IXib
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jun_2009_12_53_31_+1000_J_SIOY2nSiBHFCjq--
