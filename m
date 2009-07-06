Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZGFCGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZGFCGS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 22:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZGFCGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 22:06:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42767 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150AbZGFCGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 22:06:06 -0400
Date: Mon, 6 Jul 2009 12:05:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Anderson <tanderson@mvista.com>, Ralf Baechle <ralf@linux-mips.org>,
       Mike Travis <travis@sgi.com>
Subject: linux-next: manual merge of the rr tree with Linus' tree
Message-Id: <20090706120558.3b8cc5cd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jul_2009_12_05_58_+1000_Kxr_Qn2oR2nSwPi3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jul_2009_12_05_58_+1000_Kxr_Qn2oR2nSwPi3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the rr tree got a conflict in
arch/mips/kernel/smp-cmp.c between commit
0365070f05f12f1648b4adf22cfb52ec7a8a371c ("MIPS: CMP: activate CMP
support") from Linus' tree and commit
e7cb633472a7c3b197e2696e6a3d19a981e8988f
("cpumask:use-cpumap-accessors-mips") from the rr tree.

The former removes the code that the latter modifies in this file, so I
used the former version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jul_2009_12_05_58_+1000_Kxr_Qn2oR2nSwPi3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRXAYACgkQjjKRsyhoI8y3uACgjjkO2JoiQTCOvDBgqh34tTSR
QUIAn0iNCtzRZb8gP1CpChi4MAAouLH5
=59KZ
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jul_2009_12_05_58_+1000_Kxr_Qn2oR2nSwPi3--
