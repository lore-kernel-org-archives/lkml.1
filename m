Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZFIAzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZFIAzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbZFIAzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:55:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41449 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbZFIAzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:55:02 -0400
Date: Tue, 9 Jun 2009 10:54:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: linux-next: ext4 tree build warning
Message-Id: <20090609105459.b1ae3575.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_10_54_59_+1000_rC/WP=thR78NI8AE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_10_54_59_+1000_rC/WP=thR78NI8AE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

fs/ext4/inode.c: In function 'ext4_ind_get_blocks':
fs/ext4/inode.c:939: warning: unused variable 'disksize'
fs/ext4/inode.c:936: warning: unused variable 'ei'

Introduced by commit fb8c2ba20b8530d74239c2420d335df81aa18e13 ("ext4: Get
rid of EXTEND_DISKSIZE flag of ext4_get_blocks_handle()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_10_54_59_+1000_rC/WP=thR78NI8AE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkotsuMACgkQjjKRsyhoI8yaGACdFXPsR5oBPLlA9NEphxwBu6xK
7JQAn1V8HEb4Rr/ZqT8aquiuSZ9468BE
=uDyR
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_10_54_59_+1000_rC/WP=thR78NI8AE--
