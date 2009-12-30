Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbZL3XpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbZL3XpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:45:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZL3XpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:45:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54202 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZL3XpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:45:15 -0500
Date: Thu, 31 Dec 2009 10:45:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Shaun Ruffell <sruffell@digium.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: linux-next: tip tree build warning
Message-Id: <20091231104505.7cb8a241.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__31_Dec_2009_10_45_05_+1100_0+o1s1Wk2Sh.PVT7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_Dec_2009_10_45_05_+1100_0+o1s1Wk2Sh.PVT7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's (and the previous few) linux-next build (powerpc allyesconfig)
produced this warning:

lib/dma-debug.c: In function 'dma_debug_device_change':
lib/dma-debug.c:680: warning: 'return' with no value, in function returning=
 non-void

Introduced by commit f797d9881b62c2ddb1d2e7bd80d87141949c84aa
("dma-debug: Do not add notifier when dma debugging is disabled").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__31_Dec_2009_10_45_05_+1100_0+o1s1Wk2Sh.PVT7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks75gEACgkQjjKRsyhoI8x7VQCgm3TZZdO49kQ9bnLVoZU+f03H
CdEAnjwfYFGMK7z9esJ8woesR6tSI33E
=4rZo
-----END PGP SIGNATURE-----

--Signature=_Thu__31_Dec_2009_10_45_05_+1100_0+o1s1Wk2Sh.PVT7--
