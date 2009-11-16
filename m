Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbZKPFZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbZKPFZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZKPFZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:25:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60330 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbZKPFZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:25:06 -0500
Date: Mon, 16 Nov 2009 16:25:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build warning
Message-Id: <20091116162503.7f083c3a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_Nov_2009_16_25_03_+1100_Q2.FzuN.jkzgZmdj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Nov_2009_16_25_03_+1100_Q2.FzuN.jkzgZmdj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/apic/apic.c: In function 'calibrate_APIC_clock':
arch/x86/kernel/apic/apic.c:650: warning: format '%ld' expects type 'long i=
nt', but argument 2 has type 'u32'

Introduced by commit 23af368e9a904f59256c27d371ce223d6cee0430
("clockevents: Use u32 for mult and shift factors").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_Nov_2009_16_25_03_+1100_Q2.FzuN.jkzgZmdj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksA4i8ACgkQjjKRsyhoI8ym6wCdGGBNkbAvfMtqnT3VPWHuB9nM
PI0AmwXsgs1t5ZaTkUmfTR3ONnyZ4yIK
=C5fB
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Nov_2009_16_25_03_+1100_Q2.FzuN.jkzgZmdj--
