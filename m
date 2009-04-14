Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbZDNHen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbZDNHen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 03:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbZDNHee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 03:34:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44730 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbZDNHed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 03:34:33 -0400
Date: Tue, 14 Apr 2009 17:34:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090414173423.2b9ab235.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Apr_2009_17_34_23_+1000_zMlsWEn.s1bcE2=P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Apr_2009_17_34_23_+1000_zMlsWEn.s1bcE2=P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (cris etrax-100lx_defconfig) failed like this:

drivers/serial/crisv10.c:4428: error: unknown field 'read_proc' specified i=
n initializer

Caused by commit 0f043a81ebe84be3576667f04fdda481609e3816 ("proc tty:
remove struct tty_operations::read_proc").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Apr_2009_17_34_23_+1000_zMlsWEn.s1bcE2=P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknkPH8ACgkQjjKRsyhoI8xpPwCgjPx+BF+dQZ0HOr7ZGSvtHFLG
4hsAn1waZxCbt0+W0pmb0wSy+AUVYh0m
=tv7e
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Apr_2009_17_34_23_+1000_zMlsWEn.s1bcE2=P--
