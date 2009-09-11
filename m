Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZIKEcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZIKEcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 00:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZIKEcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 00:32:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47522 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZIKEcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 00:32:09 -0400
Date: Fri, 11 Sep 2009 14:32:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: block tree build failure
Message-Id: <20090911143203.e52e294d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Sep_2009_14_32_03_+1000_0VOaJ.i2npdZb73u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Sep_2009_14_32_03_+1000_0VOaJ.i2npdZb73u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/aoe/aoeblk.c: In function 'aoeblk_gdalloc':
drivers/block/aoe/aoeblk.c:271: error: request for member 'backing_dev_info=
' in something not a structure or union

Caused by commit 7cd6134162529e6b7f9eaa5d72b1ef8fe3b355c9 ("writeback:
add name to backing_dev_info"). 'q->blkq' changed to be a pointer in
commit 7135a71b19be1faf48b7148d77844d03bc0717d6 ("aoe: allocate unused
request_queue for sysfs").

Please be a bit more careful with rebases.

I have used the version of the block tree from next-20090910 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Sep_2009_14_32_03_+1000_0VOaJ.i2npdZb73u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqp0sMACgkQjjKRsyhoI8xrEwCfToWOUF9/uqXbrnhn5TbnDKX+
Mh8AoJn20E/T8FV9GUuYv/D3iXchge/R
=47xf
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Sep_2009_14_32_03_+1000_0VOaJ.i2npdZb73u--
