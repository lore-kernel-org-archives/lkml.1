Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbZFLH2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbZFLH2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759504AbZFLH20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:28:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35331 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbZFLH2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:28:25 -0400
Date: Fri, 12 Jun 2009 16:49:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: linux-next: manual merge of the asm-generic tree with Linus' tree
Message-Id: <20090612164914.e03160af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_16_49_14_+1000_N2UVDlEL+wRrCsDf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_16_49_14_+1000_N2UVDlEL+wRrCsDf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the asm-generic tree got a conflict in
include/asm-generic/atomic.h between commit
53e111a730ea8b002d57dd226098c12789993329 ("x86: Fix atomic_long_xchg() on
64bit") from Linus' tree and commit
72099ed2719fc5829bd79c6ca9d1783ed026eb37 ("asm-generic: rename atomic.h
to atomic-long.h") from the asm-generic tree.

I applied the fix from the former patch to atomic-long.h
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_16_49_14_+1000_N2UVDlEL+wRrCsDf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkox+moACgkQjjKRsyhoI8xG9gCdGkgQdki7QSlXZ7dMIJwUTyj9
bq4AniYISRUEPthZdN1EDrStu4qINQDG
=ItJG
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_16_49_14_+1000_N2UVDlEL+wRrCsDf--
