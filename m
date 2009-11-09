Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbZKIHPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbZKIHPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZKIHPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:15:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50781 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbZKIHPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:15:36 -0500
Date: Mon, 9 Nov 2009 18:15:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bart Massey <bart@cs.pdx.edu>,
       Dominik Brodowski <linux@dominikbrodowski.net>
Subject: linux-next: manual merge of the staging tree with the pcmcia tree
Message-Id: <20091109181534.c844974d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_18_15_34_+1100_4F.WK3f8NJzPvoq9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_18_15_34_+1100_4F.WK3f8NJzPvoq9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/ni_labpc_cs.c between commit
4e338b7f55b4c30e60fa3fa9ff3d21e930f40116 ("pcmcia/staging: update comedi
drivers") from the pcmcia tree and commits
c22f24e5f0ed5a45e4b339577a1151c4bbb8977a ("Staging: comedi: ni_labpc_cs:
added mandatory whitespace to comparison") and
f195fbc2466c79cda709074fdbb969079e0787e0 ("Staging: comedi: ni_labpc_cs:
wrapped long comments") from the staging tree.

I fixed it up (using the pcmcia tree version where there was a clash) and
can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_18_15_34_+1100_4F.WK3f8NJzPvoq9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3wZYACgkQjjKRsyhoI8xNdwCfUAkXq5DRDq2mxTmb91VJ/DV3
lrUAoKpGJMiRyt/pSiDCzghvj+tcVfR6
=4bsz
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_18_15_34_+1100_4F.WK3f8NJzPvoq9--
