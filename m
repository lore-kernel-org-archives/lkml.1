Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbZKXAhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbZKXAhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757281AbZKXAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:37:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54094 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbZKXAhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:37:16 -0500
Date: Tue, 24 Nov 2009 11:37:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Florian Fainelli <florian@openwrt.org>
Subject: linux-next: manual merge of the mips tree with the net-current tree
Message-Id: <20091124113717.c5d86d41.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__24_Nov_2009_11_37_17_+1100_h9jrgQotXG6hntqd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Nov_2009_11_37_17_+1100_h9jrgQotXG6hntqd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
drivers/net/au1000_eth.c between commit
63edaf647607795a065e6956a79c47f500dc8447 ("Au1x00: fix crash when trying
register_netdev()") from the net-current tree and commit
6cdbc95856e7f4ab4e7b2f2bdab5c3844537ad83 ("NET: au1000-eth: convert to
platform_driver model") from the mips tree.

It looks to me that the mips tree change supercedes the net-current one
(since it moves the register_netdev() call much later), so I just used
this file from the mips tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__24_Nov_2009_11_37_17_+1100_h9jrgQotXG6hntqd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksLKr0ACgkQjjKRsyhoI8zvfACglKpQKL7O6BRZohnR5GTw0D3l
ojIAn2svORhXI5LzwTY1LFL1ao9niQre
=3T2G
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Nov_2009_11_37_17_+1100_h9jrgQotXG6hntqd--
