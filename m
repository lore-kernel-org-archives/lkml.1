Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZHGB6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZHGB6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 21:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZHGB6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 21:58:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46353 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485AbZHGB6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 21:58:48 -0400
Date: Fri, 7 Aug 2009 11:58:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Jan Engelhardt <jengelh@medozas.de>,
       Michal Simek <monstr@monstr.eu>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20090807115836.f559986f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Aug_2009_11_58_36_+1000_CcqVjbK827.Es2Tw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Aug_2009_11_58_36_+1000_CcqVjbK827.Es2Tw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the net tree got a conflict in
arch/microblaze/include/asm/socket.h between commit
81d8279ea31a3fc6d4ffacd87119a04c561ca62e ("microblaze: fall back on
generic header files for the ABI") from Linus' tree and commits
49c794e94649020248e37b78db16cd25bad38b4f ("net: implement a SO_PROTOCOL
getsockoption") and 0d6038ee76f2e06b79d0465807f67e86bf4025de ("net:
implement a SO_DOMAIN getsockoption") from the net tree.

The former commit supercedes the latter ones, so I used that version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Aug_2009_11_58_36_+1000_CcqVjbK827.Es2Tw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp7ik0ACgkQjjKRsyhoI8yBLACggC+NU9XSRAL1kbns3b4BqB/D
DPUAnjIbTuqPQdHZEYmreWy6FG1ORh1S
=pjOV
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Aug_2009_11_58_36_+1000_CcqVjbK827.Es2Tw--
