Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab0CAHPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:15:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39792 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0CAHO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:14:59 -0500
Date: Mon, 1 Mar 2010 18:14:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pauli Nieminen <suokkos@gmail.com>
Subject: linux-next: build warning after merge of the drm tree
Message-Id: <20100301181452.9efa3661.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_18_14_52_+1100_+6eyE0/gS3dy4+hu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_18_14_52_+1100_+6eyE0/gS3dy4+hu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/gpu/drm/radeon/r300_cmdbuf.c: In function 'r300_do_cp_cmdbuf':
drivers/gpu/drm/radeon/r300_cmdbuf.c:1154: warning: format '%d' expects typ=
e 'int', but argument 4 has type 'long unsigned int'

Introduced by commit b4fe945405e477cded91772b4fec854705443dd5
("drm/radeon: Fix memory allocation failures in the preKMS command stream
checking").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_18_14_52_+1100_+6eyE0/gS3dy4+hu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLaWwACgkQjjKRsyhoI8x/WgCeItglYu7tTlRdvCa3vkrlPS0m
A78AoKUhW2ipf+gQYL+phVCEDzNj6Gq5
=Zmnm
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_18_14_52_+1100_+6eyE0/gS3dy4+hu--
