Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZD2Eow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZD2Eow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZD2Eon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:44:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48933 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZD2Eom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:44:42 -0400
Date: Wed, 29 Apr 2009 14:44:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build warnings
Message-Id: <20090429144436.e821c0f1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Apr_2009_14_44_36_+1000_Nd0poYSV6aUXuZAe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Apr_2009_14_44_36_+1000_Nd0poYSV6aUXuZAe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tyler,

Today's linux-next build (x86_64 allmodconfig) generated these warnings:

fs/ecryptfs/inode.c: In function 'ecryptfs_readlink':
fs/ecryptfs/inode.c:670: warning: format '%d' expects type 'int', but argum=
ent 3 has type 'size_t'
fs/ecryptfs/inode.c:693: warning: comparison of distinct pointer types lack=
s a cast

Caused by commit 3a6b42cadc112b01daf0525e5fcd90bb333a5bb3 ("eCryptfs:
Larger buffer for encrypted symlink targets").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Apr_2009_14_44_36_+1000_Nd0poYSV6aUXuZAe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn32zQACgkQjjKRsyhoI8zQwgCcDnQyMDQVoGUcKVjFJBLTNf5r
zUwAniicibO1VlyjUU+IVhWR4NgGRbPH
=i6+c
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Apr_2009_14_44_36_+1000_Nd0poYSV6aUXuZAe--
