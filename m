Return-Path: <linux-kernel-owner+w=401wt.eu-S1755224AbZKECao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbZKECao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZKECan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:30:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60925 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZKECan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:30:43 -0500
Date: Thu, 5 Nov 2009 13:30:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: net tree build warning
Message-Id: <20091105133041.a2aa30f7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__5_Nov_2009_13_30_41_+1100_LCYfm.LQYhLZ=ufv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Nov_2009_13_30_41_+1100_LCYfm.LQYhLZ=ufv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

net/ipv4/devinet.c: In function 'inet_select_addr':
net/ipv4/devinet.c:902: warning: label 'out' defined but not used

Probably introduced by commit c6d14c84566d6b70ad9dc1618db0dec87cca9300
("net: Introduce for_each_netdev_rcu() iterator").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__5_Nov_2009_13_30_41_+1100_LCYfm.LQYhLZ=ufv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkryONEACgkQjjKRsyhoI8zAfwCgk0n+5CvpxH/5BlRGaZmNarIb
5gIAniqdu11L4P3d0exa6ATIkobz9ZXN
=9yq3
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Nov_2009_13_30_41_+1100_LCYfm.LQYhLZ=ufv--
