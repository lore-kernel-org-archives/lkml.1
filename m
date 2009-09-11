Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbZIKI4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbZIKI4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 04:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbZIKI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 04:56:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41681 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbZIKI4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 04:56:05 -0400
Date: Fri, 11 Sep 2009 18:56:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build warning
Message-Id: <20090911185600.9641f38b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__11_Sep_2009_18_56_00_+1000_zx6ArzwLN9z2A6FI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Sep_2009_18_56_00_+1000_zx6ArzwLN9z2A6FI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allnoconfig) produced this warning:

kernel/sched.c:122: warning: 'double_rq_lock' declared 'static' but never d=
efined

Introduced by commit 18a3885fc1ffa92c2212ff0afdf033403d5b0fa0 ("sched:
Remove reciprocal for cpu_power").  This is a build with CONFIG_SMP
undefined.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__11_Sep_2009_18_56_00_+1000_zx6ArzwLN9z2A6FI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqqEKAACgkQjjKRsyhoI8yJEQCeJmLpsdi8YGLKogMnMY8iWVyl
9/MAn19dC+oLDQsNG8hs5n3oehR+NHUW
=Ekxc
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Sep_2009_18_56_00_+1000_zx6ArzwLN9z2A6FI--
