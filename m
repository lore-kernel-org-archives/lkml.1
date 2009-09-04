Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbZIDHyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbZIDHyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbZIDHyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:54:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36061 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbZIDHyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:54:44 -0400
Date: Fri, 4 Sep 2009 17:54:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: block tree build warning
Message-Id: <20090904175440.09a67ee7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Sep_2009_17_54_40_+1000_.dF3yEFM/h2jwzsr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Sep_2009_17_54_40_+1000_.dF3yEFM/h2jwzsr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next build (powerpc allnoconfig) produced this warning:

fs/fs-writeback.c: In function 'sync_inodes_sb':
fs/fs-writeback.c:1140: warning: overflow in implicit constant conversion

Introduced by commit bda31e6ac21d7d41525c4e57549ac24bacdcf622
("writeback: get rid of generic_sync_sb_inodes() export").  This is a
32bit build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Sep_2009_17_54_40_+1000_.dF3yEFM/h2jwzsr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgx8AACgkQjjKRsyhoI8zn+ACfbxxau3ptWMWhrbgzGDhY1eJc
ojYAoImk0l+cYjzTg9cUz2y3157YeFy0
=uw/u
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Sep_2009_17_54_40_+1000_.dF3yEFM/h2jwzsr--
