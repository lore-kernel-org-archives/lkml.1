Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbZFCBvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbZFCBvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 21:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZFCBvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 21:51:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbZFCBvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 21:51:05 -0400
Date: Wed, 3 Jun 2009 11:50:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jan Kiszka <jan.kiszka@siemens.com>
Subject: linux-next: manual merge of the kvm tree with the x86 tree
Message-Id: <20090603115058.947305fc.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_11_50_58_+1000_6FQXWDxH4CT8tgup"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_11_50_58_+1000_6FQXWDxH4CT8tgup
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next merge of the kvm tree got a conflict in
arch/x86/include/asm/mce.h between commits
06b851d98266b812b2fa23d007cdf53f41194bbb ("x86, mce: unify, prepare 64bit
in mce.h") and 01c6680a547a3ee8dd170c269ea8e037b3191b71 ("x86, mce:
Cleanup MCG definitions") from the x86 tree and commit
1a6a35a1c82eb3b95719a375da2e3aac2910a1df ("x86: Make MCE defines
32-bit-safe") from the kvm tree.

I think the latter is subsumed by the former commits.  I fixed it up (by
using the version from the x86 tree) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Jun_2009_11_50_58_+1000_6FQXWDxH4CT8tgup
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkol1wIACgkQjjKRsyhoI8wlzQCgrW+GcfBIJr9ktB+a6jO6Gnjt
cdQAoJ2DMJbYDQgnBM2soUIcUXBAq3cj
=muO/
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_11_50_58_+1000_6FQXWDxH4CT8tgup--
