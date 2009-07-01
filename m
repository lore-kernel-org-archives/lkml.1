Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZGAHTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZGAHTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZGAHT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:19:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44656 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZGAHT0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:19:26 -0400
Date: Wed, 1 Jul 2009 17:19:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the percpu tree with Linus' tree
Message-Id: <20090701171925.6db8121d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_17_19_25_+1000_2_9GPeCE26UwT.E6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jul_2009_17_19_25_+1000_2_9GPeCE26UwT.E6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/alpha/include/asm/percpu.h between commit
b01e8dc34379f4ba2f454390e340a025edbaaa7e ("alpha: fix percpu build
breakage") from Linus' tree and commit
6088464cf1ae9fb3d2ccc0ec5feb3f5b971098d8 ("alpha: kill unnecessary __used
attribute in PER_CPU_ATTRIBUTES") from the percpu tree.

The latter just removes what the former changed, so I used the percpu
tree version of this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jul_2009_17_19_25_+1000_2_9GPeCE26UwT.E6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLDf0ACgkQjjKRsyhoI8xp2gCdEt3M+RBdpw/YIcenRPK7SQr4
s04AnRbYuctKxFghO/efSvBhy6I54DIc
=WNtQ
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_17_19_25_+1000_2_9GPeCE26UwT.E6--
