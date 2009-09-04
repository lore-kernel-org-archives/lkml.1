Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbZIDHch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbZIDHch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 03:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbZIDHcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 03:32:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49561 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbZIDHcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 03:32:35 -0400
Date: Fri, 4 Sep 2009 17:32:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the staging tree with the net tree
Message-Id: <20090904173225.0817003b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Sep_2009_17_32_25_+1000_LOd6NaK3ZOxqwaTz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Sep_2009_17_32_25_+1000_LOd6NaK3ZOxqwaTz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/at76_usb/at76_usb.c between commits
6ed106549d17474ca17a16057f4c0ed4eba5a7ca ("net: use NETDEV_TX_OK instead
of 0 in ndo_start_xmit() functions") and
0fc0b732eaa38beb93a6fb62f77c7bd9622c76ec ("netdev: drivers should make
ethtool_ops const") from the net tree and commit
c0e03fabb4f2a6e48f6e0b55729b26a599a2bd02 ("Staging: remove at76_usb
wireless driver") from the staging tree.

The latter just removes the driver, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Sep_2009_17_32_25_+1000_LOd6NaK3ZOxqwaTz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgwokACgkQjjKRsyhoI8wD1ACffHVjaIxBvYE5ErBF14U5WjD9
BQoAn1n5HLuaA05g8LLrbnCUdsKwqF+Z
=Uo7T
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Sep_2009_17_32_25_+1000_LOd6NaK3ZOxqwaTz--
