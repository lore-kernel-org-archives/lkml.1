Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbZK3XXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbZK3XXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZK3XXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:23:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43152 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbZK3XXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:23:51 -0500
Date: Tue, 1 Dec 2009 10:23:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Gibson <david@gibson.dropbear.id.au>
Subject: linux-next: powerpc tree build failure
Message-Id: <20091201102352.8a2d0a52.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_10_23_52_+1100_9kD/jf7JG0Z1.H3l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_10_23_52_+1100_9kD/jf7JG0Z1.H3l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

arch/powerpc/mm/mmu_context_hash64.c: In function 'destroy_context':
arch/powerpc/mm/mmu_context_hash64.c:96: error: passing argument 1 of 'subp=
age_prot_free' from incompatible pointer type
arch/powerpc/include/asm/mmu-hash64.h:404: note: expected 'pgd_t *' but arg=
ument is of type 'struct mm_struct *'

Casued by commit c045256d146800ea1d741a8e9e377dada6b7e195 ("powerpc/mm:
Fix bug in pagetable cache cleanup with CONFIG_PPC_SUBPAGE_PROT") which I
have reverted for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Dec_2009_10_23_52_+1100_9kD/jf7JG0Z1.H3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksUVAgACgkQjjKRsyhoI8zmmgCfTeShjC/JngEwzVslw/LgHG56
29QAn0CMZ2f+t28ylqHQtbzxphS7whDb
=GLt3
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_10_23_52_+1100_9kD/jf7JG0Z1.H3l--
