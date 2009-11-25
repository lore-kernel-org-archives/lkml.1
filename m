Return-Path: <linux-kernel-owner+w=401wt.eu-S1758670AbZKYKxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbZKYKxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758624AbZKYKxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:53:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60225 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbZKYKxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:53:49 -0500
Date: Wed, 25 Nov 2009 21:53:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: linux-next: tip tree build warning
Message-Id: <20091125215338.d07a95b9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_21_53_38_+1100_YbXsy6+CWxd0pb1u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_21_53_38_+1100_YbXsy6+CWxd0pb1u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

kernel/perf_event.c:4306: warning: 'bp_perf_event_destroy' defined but not =
used

Introduced by commit 24f1e32c60c45c89a997c73395b69c8af6f0a84e
("hw-breakpoints: Rewrite the hw-breakpoints layer on top of perf
events").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Nov_2009_21_53_38_+1100_YbXsy6+CWxd0pb1u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNDLIACgkQjjKRsyhoI8xS1wCgtumM6LTUSfICs5BTNBCAHSlo
hIMAn3/Uom3IRlyjjnx816M63bm3/XA6
=+I5Y
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_21_53_38_+1100_YbXsy6+CWxd0pb1u--
