Return-Path: <linux-kernel-owner+w=401wt.eu-S1751658AbZKWFqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbZKWFqN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 00:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbZKWFqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 00:46:12 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39009 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZKWFqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 00:46:11 -0500
Date: Mon, 23 Nov 2009 16:46:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       Li Hong <lihong.hi@gmail.com>
Subject: linux-next: manual merge of the tip tree with the mips tree
Message-Id: <20091123164607.096bb339.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_Nov_2009_16_46_07_+1100_/Rs=Lk=F9g9mbsU9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Nov_2009_16_46_07_+1100_/Rs=Lk=F9g9mbsU9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
scripts/recordmcount.pl between commit
8faf0bcd7be5c9a86223a857f78e033e9cf5f1f5 ("MIPS: Tracing: Add an endian
argument to scripts/recordmcount.pl") from the mips tree and commit
e2d753fac5b3954a3b6001f98479f0435fe7c868 ("tracing: Correct the check for
number of arguments in recordmcount.pl") from the tip tree.

Just two updates to the same line.  I fixed it up (using the mips tree
version) and can carry the fix as necessary.  Thanks again, Ralf, for the
heads up.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Nov_2009_16_46_07_+1100_/Rs=Lk=F9g9mbsU9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEUEARECAAYFAksKIZ8ACgkQjjKRsyhoI8xRoACXUMSOk3Bm/57CgQ0MisHkYfEl
ggCgjwnQhmQWv30rliv+bn0AbP/+1L4=
=qmRw
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Nov_2009_16_46_07_+1100_/Rs=Lk=F9g9mbsU9--
