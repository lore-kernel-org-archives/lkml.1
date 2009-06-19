Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZFSGab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZFSGab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 02:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFSGaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 02:30:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44757 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbZFSGaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 02:30:23 -0400
Date: Fri, 19 Jun 2009 16:30:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090619163021.8ae4c588.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Jun_2009_16_30_21_+1000_7ObvBuuUABKfXRC3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jun_2009_16_30_21_+1000_7ObvBuuUABKfXRC3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc64, gcc 4.1.3) failed like this:

drivers/video/logo/logo_linux_mono.c:11: error: logo_linux_mono_data causes=
 a section type conflict

Caused by commit ae52bb2384f721562f15f719de1acb8e934733cb ("fbdev: move
logo externs to header file") but probably really a compiler bug as gcc
4.3 and 4.4 do not get this error.  I have reverted that commit for
today, but we really need some workaround as gcc 4.1.3 is not uncommon.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Jun_2009_16_30_21_+1000_7ObvBuuUABKfXRC3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko7MH0ACgkQjjKRsyhoI8x+8wCfQ4lW8oNK9v1Uun0tG3nOmVVe
iFUAn2r5XwH1dhJ2b7MaFSQaDFV8TLiW
=B0ex
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jun_2009_16_30_21_+1000_7ObvBuuUABKfXRC3--
