Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579Ab0CLEAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:00:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50103 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0CLEAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:00:14 -0500
Date: Fri, 12 Mar 2010 15:00:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20100312150003.afd9b59a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Mar_2010_15_00_03_+1100_ZNNe+6aC6uWK/Ap7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Mar_2010_15_00_03_+1100_ZNNe+6aC6uWK/Ap7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".perf_arch_fetch_caller_regs" [fs/xfs/xfs.ko] undefined!
ERROR: ".perf_arch_fetch_caller_regs" [arch/powerpc/platforms/cell/spufs/sp=
ufs.ko] undefined!

Caused by commit 5331d7b84613b8325362dde53dc2bff2fb87d351 ("perf:
Introduce new perf_fetch_caller_regs() for hot regs snapshot") from the
tip tree.  Presumably commit 639fe4b12f92b54c9c3b38c82cdafaa38cfd3e63
("perf: export perf_trace_regs and perf_arch_fetch_caller_regs") should
have exported the weak version as well as the x86 one.

I have used the version of the tip tree from next-20100311 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Mar_2010_15_00_03_+1100_ZNNe+6aC6uWK/Ap7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuZvEMACgkQjjKRsyhoI8zhDgCgqM6xL8PUHR4OELbwFKQWOkBu
aG0AnjhHCSK419g0jAeBwmMsMFnSg5d2
=HUdy
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Mar_2010_15_00_03_+1100_ZNNe+6aC6uWK/Ap7--
