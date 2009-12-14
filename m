Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbZLNFdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbZLNFdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZLNFdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:33:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56577 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZLNFdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:33:45 -0500
Date: Mon, 14 Dec 2009 16:33:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: sparc tree build warning
Message-Id: <20091214163338.f811722f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_16_33_38_+1100_UlpviB1zkGjSqJ3R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_16_33_38_+1100_UlpviB1zkGjSqJ3R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (sparc defconfig) produced this warning:

In file included from arch/sparc/include/asm/uaccess.h:7,
                 from include/net/checksum.h:26,
                 from include/linux/skbuff.h:29,
                 from net/core/pktgen.c:141:
In function 'copy_from_user',
    inlined from 'pktgen_if_write' at net/core/pktgen.c:867:
arch/sparc/include/asm/uaccess_32.h:276: warning: call to 'copy_from_user_o=
verflow' declared with attribute warning: copy_from_user() buffer size is n=
ot provably correct

and many more.

The sparc64 defconfig build produced many similar warnings:

In file included from arch/sparc/include/asm/uaccess.h:5,
                 from include/linux/uaccess.h:6,
                 from include/linux/highmem.h:7,
                 from include/linux/pagemap.h:11,
                 from include/linux/mempolicy.h:63,
                 from mm/mempolicy.c:69:
arch/sparc/include/asm/uaccess_64.h: In function 'compat_sys_get_mempolicy':
arch/sparc/include/asm/uaccess_64.h:232: warning: call to 'copy_from_user_o=
verflow' declared with attribute warning: copy_from_user() buffer size is n=
ot provably correct
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_16_33_38_+1100_UlpviB1zkGjSqJ3R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkslzjIACgkQjjKRsyhoI8x1HQCgs5vx9FJYC+eGE0ieqNGRsC8M
yGwAoIUS/fmg3DWM6E3BVAgg4F1qijAj
=liC6
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_16_33_38_+1100_UlpviB1zkGjSqJ3R--
