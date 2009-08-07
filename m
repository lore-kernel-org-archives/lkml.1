Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZHGGrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZHGGrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbZHGGrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:47:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50497 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbZHGGrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:47:17 -0400
Date: Fri, 7 Aug 2009 16:47:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, Jan Engelhardt <jengelh@medozas.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the tip tree with the net tree
Message-Id: <20090807164705.725869c1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Aug_2009_16_47_05_+1000_gbXiJbopbeIYiJGx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Aug_2009_16_47_05_+1000_gbXiJbopbeIYiJGx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/include/asm/socket.h between commits
49c794e94649020248e37b78db16cd25bad38b4f ("net: implement a SO_PROTOCOL
getsockoption") and 0d6038ee76f2e06b79d0465807f67e86bf4025de ("net:
implement a SO_DOMAIN getsockoption") from the net tree and commit
73a2d096fdf23aa841f7595d114a11ec85a85e4d ("x86: remove all now-duplicate
header files") from the tip tree.

The latter change supercedes the former ones, so I used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Aug_2009_16_47_05_+1000_gbXiJbopbeIYiJGx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp7zekACgkQjjKRsyhoI8yHwQCeI73rOR2k31OPIbpJ/L9ODabl
tvkAoITX+nUI6Cfxs9QJf8/e4tXMcyeA
=UJzM
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Aug_2009_16_47_05_+1000_gbXiJbopbeIYiJGx--
