Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbZKLCYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbZKLCYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 21:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759907AbZKLCYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 21:24:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48047 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759588AbZKLCYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 21:24:24 -0500
Date: Thu, 12 Nov 2009 13:24:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: net tree build warning
Message-Id: <20091112132424.e010e3c5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_13_24_24_+1100_WYWE=aQftocoSL.Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_13_24_24_+1100_WYWE=aQftocoSL.Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

net/ipv6/addrconf.c: In function 'inet6_dump_ifinfo':
net/ipv6/addrconf.c:3833: warning: unused variable 'err'

Introduced by commit 84d2697d9649339215675551eae28ba04068dea1 ("ipv6:
speedup inet6_dump_ifinfo()").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_13_24_24_+1100_WYWE=aQftocoSL.Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7cdgACgkQjjKRsyhoI8wwNACgsRc782JJ82TAiBcJZmKLaEZV
/qoAn3IT+QhRV6AHlHLqNP6sCKIo3iTi
=CSew
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_13_24_24_+1100_WYWE=aQftocoSL.Z--
