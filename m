Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbZIBFhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbZIBFhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbZIBFhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:37:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55744 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755800AbZIBFhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:37:06 -0400
Date: Wed, 2 Sep 2009 15:36:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the block tree with the ubifs tree
Message-Id: <20090902153657.dc174bf6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Sep_2009_15_36_57_+1000_GxrH7TJyvmSkUakQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Sep_2009_15_36_57_+1000_GxrH7TJyvmSkUakQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
fs/ubifs/super.c between commit 887ee17117fd23e962332b353d250ac9e090b20f
("UBIFS: remove unneeded call from ubifs_sync_fs") from the ubifs tree
and commit 0184fca792940a9e4058b2c63b3f334326a4c7af ("writeback: move
super_block argument to struct writeback_control") from the block tree.

The former removes the code that the latter changes.  I just used the
version from the ubifs tree.  I can carry this fixup as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Sep_2009_15_36_57_+1000_GxrH7TJyvmSkUakQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqeBHkACgkQjjKRsyhoI8yMuwCgjUwWxWDRLFR/5RR/ricJrVb2
bvoAoLQFKeQ5SJ/4L7IqmIddgMahvXv/
=m78R
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Sep_2009_15_36_57_+1000_GxrH7TJyvmSkUakQ--
