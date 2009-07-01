Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZGAHZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZGAHZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGAHZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:25:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60229 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbZGAHZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:25:47 -0400
Date: Wed, 1 Jul 2009 17:25:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the percpu tree with Linus' tree
Message-Id: <20090701172545.574315e3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__1_Jul_2009_17_25_45_+1000_HEFdvBgRK7wfu/.z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__1_Jul_2009_17_25_45_+1000_HEFdvBgRK7wfu/.z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
include/linux/percpu-defs.h between commit
b01e8dc34379f4ba2f454390e340a025edbaaa7e ("alpha: fix percpu build
breakage") from Linus' tree and commit
7c756e6e19e71f0327760d8955f7077118ebb2b1 ("percpu: implement optional
weak percpu definitions") from the percpu tree.

The latter seems to subsume the former changes, so I just used the percpu
tree version of this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__1_Jul_2009_17_25_45_+1000_HEFdvBgRK7wfu/.z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpLD3kACgkQjjKRsyhoI8yh+QCgj+ThZQunOH8hnrbXBim5dkV1
VqgAoJjf8zqY4VHsSBw7/Us+ldp39LcH
=7DK5
-----END PGP SIGNATURE-----

--Signature=_Wed__1_Jul_2009_17_25_45_+1000_HEFdvBgRK7wfu/.z--
