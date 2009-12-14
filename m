Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZLNX7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZLNX7c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbZLNX7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:59:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41342 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbZLNX7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:59:30 -0500
Date: Tue, 15 Dec 2009 10:59:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: linux-next: ext3 tree build warning
Message-Id: <20091215105925.59a66556.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Dec_2009_10_59_25_+1100_kV7lY+95MOE5a/r_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Dec_2009_10_59_25_+1100_kV7lY+95MOE5a/r_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

fs/quota/dquot.c: In function 'dquot_alloc_inode':
fs/quota/dquot.c:1521: warning: passing argument 1 of 'mark_all_dquot_dirty=
' discards qualifiers from pointer target type
fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of t=
ype 'struct dquot * const*'
fs/quota/dquot.c: In function 'dquot_free_inode':
fs/quota/dquot.c:1649: warning: passing argument 1 of 'mark_all_dquot_dirty=
' discards qualifiers from pointer target type
fs/quota/dquot.c:327: note: expected 'struct dquot **' but argument is of t=
ype 'struct dquot * const*'

Introduced by commit e91077e3d523c2ac2090b3447bf6244567cf7128 ("quota:
Move duplicated code to separate functions").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Dec_2009_10_59_25_+1100_kV7lY+95MOE5a/r_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksm0V0ACgkQjjKRsyhoI8wRBwCggYISMYSAHtyQT29jGj2CQGns
zcUAoIfak5XbEx/OtDLb/Lgb+dfWtvhP
=ZuCw
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Dec_2009_10_59_25_+1100_kV7lY+95MOE5a/r_--
