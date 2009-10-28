Return-Path: <linux-kernel-owner+w=401wt.eu-S932655AbZJ1H7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932655AbZJ1H7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932616AbZJ1H7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:59:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50927 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576AbZJ1H7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:59:17 -0400
Date: Wed, 28 Oct 2009 18:59:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Aristeu Rozanski <aris@redhat.com>
Subject: linux-next: i7core_edac tree build warning
Message-Id: <20091028185914.2f26c026.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Oct_2009_18_59_14_+1100_dmXa3pPLrffcAKJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Oct_2009_18_59_14_+1100_dmXa3pPLrffcAKJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next build (i386 defconfig) produced this warning:

WARNING: arch/x86/pci/built-in.o(__ksymtab_gpl+0x8): Section mismatch in re=
ference from the variable __ksymtab_pci_legacy_init to the function .init.t=
ext:pci_legacy_init()
The symbol pci_legacy_init is exported and annotated __init=20
Fix this by removing the __init annotation of pci_legacy_init or drop the e=
xport.

Introduced by commit a120a84ebbc4cbc9c1addddd2b491e3683b842a6 ("pci: Add
a probing code that seeks for an specific bus").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Oct_2009_18_59_14_+1100_dmXa3pPLrffcAKJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrn+dIACgkQjjKRsyhoI8xXQwCfd43/t+cVkmTGcKUDpv1N0lAj
aQ0AnAvjMF2xVqD16ZEiPvPt99E/BaO1
=BsHG
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Oct_2009_18_59_14_+1100_dmXa3pPLrffcAKJ0--
