Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437Ab0BHCWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 21:22:54 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45017 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab0BHCWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 21:22:52 -0500
Date: Mon, 8 Feb 2010 13:22:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sridhar Samudrala <sri@us.ibm.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100208132243.ab967d9c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__8_Feb_2010_13_22_43_+1100_KM_2hHKPG.=88CWW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__8_Feb_2010_13_22_43_+1100_KM_2hHKPG.=88CWW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/packet/af_packet.c: In function 'packet_setsockopt':
net/packet/af_packet.c:1977: error: 'struct packet_sock' has no member name=
d 'rx_ring'
net/packet/af_packet.c:1977: error: 'struct packet_sock' has no member name=
d 'tx_ring'

Caused by commit bfd5f4a3d605e0f6054df0b59fe0907ff7e696d3 ("packet: Add
GSO/csum offload support").  This build has CONFIG_PACKET_MMAP unset.

I used the version of the net tree from next-20100205 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__8_Feb_2010_13_22_43_+1100_KM_2hHKPG.=88CWW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktvdXMACgkQjjKRsyhoI8wCjwCgklGTJHtFmHc0iZn41WGnsrpe
NXgAoLGRv9enkPNIdahJLf2mzz+RsxQz
=PhzF
-----END PGP SIGNATURE-----

--Signature=_Mon__8_Feb_2010_13_22_43_+1100_KM_2hHKPG.=88CWW--
