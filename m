Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751184Ab0BWFBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 00:01:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36777 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab0BWFBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 00:01:41 -0500
Date: Tue, 23 Feb 2010 16:01:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: linux-next: build warning after merge of the tip tree
Message-Id: <20100223160129.f3819f35.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_16_01_29_+1100_p4U7V8g2EtUaLupc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_16_01_29_+1100_p4U7V8g2EtUaLupc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) produced these warnings:

mm/sparse.c: In function 'sparse_init':
mm/sparse.c:488: warning: unused variable 'map_count'
mm/sparse.c:484: warning: unused variable 'size2'
mm/sparse.c:481: warning: unused variable 'map_map'
mm/sparse.c: At top level:
mm/sparse.c:442: warning: 'sparse_early_mem_maps_alloc_node' defined but no=
t used

Introduced by commit 9bdac914240759457175ac0d6529a37d2820bc4d
("sparsemem: Put mem map for one node together").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_16_01_29_+1100_p4U7V8g2EtUaLupc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDYSkACgkQjjKRsyhoI8wBvgCcCwLgqlvDkL8vRYbWbCjFHbRt
Rb4AnierK4xewQIcv8qINXk0j76By3jo
=eW7w
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_16_01_29_+1100_p4U7V8g2EtUaLupc--
