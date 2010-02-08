Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0BHEs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 23:48:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42554 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756364Ab0BHEs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 23:48:27 -0500
Date: Mon, 8 Feb 2010 15:48:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Daniel Mack <daniel@caiaq.de>
Subject: linux-next: manual merge of the trivial tree with the arm tree
Message-Id: <20100208154821.0560fcca.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_15_48_21_+1100_If.hxruF_jt3Rik2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_15_48_21_+1100_If.hxruF_jt3Rik2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-u300/include/mach/debug-macro.S between commit
7f62dc4756eaf761570b96250630d48f80397d64 ("ARM: 5910/1: ARM: Add tmp
register for addruart and loadsp") from the arm tree and commit
ba5584a307a1166597fbbe970ffdf49c8b7ee42a ("tree-wide: Assorted spelling
fixes") from the trivial tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-u300/include/mach/debug-macro.S
index ca4a028,d591fe1..0000000
--- a/arch/arm/mach-u300/include/mach/debug-macro.S
+++ b/arch/arm/mach-u300/include/mach/debug-macro.S
@@@ -10,8 -10,8 +10,8 @@@
   */
  #include <mach/hardware.h>
 =20
 -	.macro	addruart,rx
 +	.macro	addruart, rx, tmp
- 	/* If we move the adress using MMU, use this. */
+ 	/* If we move the address using MMU, use this. */
  	mrc	p15, 0, \rx, c1, c0
  	tst	\rx, #1			@ MMU enabled?
  	ldreq	\rx,	  =3D U300_SLOW_PER_PHYS_BASE @ MMU off, physical address

--Signature=_Mon__8_Feb_2010_15_48_21_+1100_If.hxruF_jt3Rik2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktvl5UACgkQjjKRsyhoI8xD0wCfTufdy0K1gHmaCOq6jNKrJjLx
+NgAnjULZZ+pMlmOE+LW1wVGRFDTOUIo
=kDO4
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_15_48_21_+1100_If.hxruF_jt3Rik2--
