Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZKIHPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZKIHPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZKIHPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:15:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50789 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947AbZKIHPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:15:42 -0500
Date: Mon, 9 Nov 2009 18:15:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Vadim Mutilin <mutilin@ispras.ru>
Subject: linux-next: manual merge of the staging tree with the pcmcia tree
Message-Id: <20091109181544.454695c0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_18_15_44_+1100_2fcxF7pn=V6H_iMc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_18_15_44_+1100_2fcxF7pn=V6H_iMc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/comedi/drivers/cb_das16_cs.c between commit
4e338b7f55b4c30e60fa3fa9ff3d21e930f40116 ("pcmcia/staging: update comedi
drivers") from the pcmcia tree and commit
e18c724339a542aac71d1d47b0695bf7b4a5c3a3 ("STAGING: comedi: cb_das16_cs:
fixing coding style errors") from the staging tree.

I fixed it up (using the pcmcia tree version when there is a clash) and
can carry the fix as necessary.

[Greg, that staging tree commit has no SOB from its author ...]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_18_15_44_+1100_2fcxF7pn=V6H_iMc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3waAACgkQjjKRsyhoI8yw9QCgq2b7yw9Osbw7YUKCIAp9Tz4B
sLcAniWH5Gyd+fE2S1/+jbOihbzM09yl
=iSCA
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_18_15_44_+1100_2fcxF7pn=V6H_iMc--
