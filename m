Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbZFWGO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbZFWGO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 02:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZFWGOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 02:14:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57756 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbZFWGOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 02:14:20 -0400
Date: Tue, 23 Jun 2009 16:14:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: rr tree build failure
Message-Id: <20090623161416.072b43ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Jun_2009_16_14_16_+1000_vT1CKCZHo2Anuj.I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jun_2009_16_14_16_+1000_vT1CKCZHo2Anuj.I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (arm realview-smp_defconfig) failed like this:

arch/arm/kernel/smp.c: In function 'flush_tlb_mm':
arch/arm/kernel/smp.c:646: error: lvalue required as unary '&' operand
arch/arm/kernel/smp.c: In function 'flush_tlb_page':
arch/arm/kernel/smp.c:657: error: lvalue required as unary '&' operand
arch/arm/kernel/smp.c: In function 'flush_tlb_range':
arch/arm/kernel/smp.c:680: error: lvalue required as unary '&' operand

Caused by commit e97df8b735e20500a1d6a3743bef153869c472d3
("cpumask:use-mm_cpumask-arm").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Jun_2009_16_14_16_+1000_vT1CKCZHo2Anuj.I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpAcrgACgkQjjKRsyhoI8yMYQCgjh9MIJMnk85dL8fFP/u2Z6xj
a9wAn2SLPGZTKDjhxkO/Jt4PcmcWz8qY
=3k7E
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jun_2009_16_14_16_+1000_vT1CKCZHo2Anuj.I--
