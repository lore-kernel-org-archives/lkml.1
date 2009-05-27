Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbZE0Qyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbZE0Qyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbZE0QyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:54:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35231 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbZE0QyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:54:24 -0400
Date: Thu, 28 May 2009 02:54:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tomas 'Sleep_Walker' Cech" <sleep_walker@suse.cz>,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: pxa tree build failure
Message-Id: <20090528025406.781cfc0b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_May_2009_02_54_06_+1000_tLODcILJeSdM.TU8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_May_2009_02_54_06_+1000_tLODcILJeSdM.TU8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next build (most of the arm configs) failed like this:

arch/arm/mm/mmu.c:839: error: implicit declaration of function 'machine_is_=
treo680'

Caused by commit c81fe1207795c71a6933f84d62ded0946a6af8a4 ("[ARM]
pxa/treo680: initial support").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_May_2009_02_54_06_+1000_tLODcILJeSdM.TU8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkodcDAACgkQjjKRsyhoI8xmxgCfctFG2kvy3pZRxIP2sWK6RgOG
tesAoLKopMPigoMXPh/3MnVNAPZotobl
=hdF5
-----END PGP SIGNATURE-----

--Signature=_Thu__28_May_2009_02_54_06_+1000_tLODcILJeSdM.TU8--
