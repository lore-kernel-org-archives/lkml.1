Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZHRIXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZHRIXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 04:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbZHRIXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 04:23:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43322 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZHRIXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 04:23:23 -0400
Date: Tue, 18 Aug 2009 18:23:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-Id: <20090818182313.3a1d3db1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Aug_2009_18_23_13_+1000_S/+9euet.AbRwP49"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Aug_2009_18_23_13_+1000_S/+9euet.AbRwP49
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

The linux-next merge of the mips tree gets conflicts between several
commits from Linus' tree and (basically) the same commits from the mips
tree.  I have been getting these for some time.  The mips tree for
linux-next hasn't been updated since June 6 and doing a manula merge with
Linus' tree (or rebasing it on top of Linus' tree) would fix most of these
conflicts:

$ git merge mips
Auto-merging arch/mips/Kconfig
Auto-merging arch/mips/cavium-octeon/dma-octeon.c
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/dma-octeon.c
Auto-merging arch/mips/cavium-octeon/executive/cvmx-helper-errata.c
CONFLICT (add/add): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-errata.c
Auto-merging arch/mips/cavium-octeon/octeon-irq.c
Auto-merging arch/mips/include/asm/cpu-features.h
Auto-merging arch/mips/include/asm/mach-cavium-octeon/cpu-feature-overrides=
.h
Auto-merging arch/mips/mm/c-r4k.c
Auto-merging arch/mips/mm/tlbex.c
CONFLICT (content): Merge conflict in arch/mips/mm/tlbex.c
Auto-merging arch/mips/sibyte/Kconfig
Auto-merging arch/mips/sibyte/swarm/setup.c
CONFLICT (content): Merge conflict in arch/mips/sibyte/swarm/setup.c
Auto-merging arch/mips/txx9/generic/setup.c
Auto-merging arch/mips/txx9/rbtx4939/setup.c
Auto-merging drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
Auto-merging drivers/char/hw_random/Makefile
CONFLICT (content): Merge conflict in drivers/char/hw_random/Makefile
Auto-merging drivers/dma/Kconfig
Auto-merging drivers/dma/Makefile
Auto-merging drivers/dma/txx9dmac.c
CONFLICT (add/add): Merge conflict in drivers/dma/txx9dmac.c
Automatic merge failed; fix conflicts and then commit the result.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Aug_2009_18_23_13_+1000_S/+9euet.AbRwP49
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkqKZPEACgkQjjKRsyhoI8xMDACgsJC2JXdzQgSK1apVYNZNMBBl
GaQAlR5cykULs08pf5v7+lphd4nwx5g=
=7rUo
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Aug_2009_18_23_13_+1000_S/+9euet.AbRwP49--
