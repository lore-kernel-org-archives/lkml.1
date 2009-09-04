Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbZIDEeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbZIDEeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZIDEep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:34:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54961 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414AbZIDEep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:34:45 -0400
Date: Fri, 4 Sep 2009 14:34:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org
Subject: linux-next: net tree build warnings
Message-Id: <20090904143439.c44f61ee.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Sep_2009_14_34_39_+1000_seE2wuBJAAl9RTfS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Sep_2009_14_34_39_+1000_seE2wuBJAAl9RTfS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig gcc-4.4.0) produced thes
warnings:

drivers/net/wan/dlci.c: In function 'dlci_transmit':
drivers/net/wan/dlci.c:205: warning: enumeration value 'NETDEV_TX_LOCKED' n=
ot handled in switch
drivers/net/wan/dlci.c:215: warning: case value '2' not in enumerated type =
'netdev_tx_t'

Introduced by commit d71a674922e7519edb477ecb585e7d29d69c7aa7 ("wan:
convert drivers to netdev_tx_t").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Sep_2009_14_34_39_+1000_seE2wuBJAAl9RTfS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgmN8ACgkQjjKRsyhoI8wjSACcD44h+hNtp+oob27frKKSzgHD
SHIAnRLqNUe8F4TBMmToZnINiqFr9G7e
=oto9
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Sep_2009_14_34_39_+1000_seE2wuBJAAl9RTfS--
