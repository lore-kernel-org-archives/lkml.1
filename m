Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZG2Gwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZG2Gwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 02:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZG2Gwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 02:52:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60788 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbZG2Gw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 02:52:29 -0400
Date: Wed, 29 Jul 2009 16:52:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the staging tree with the net tree
Message-Id: <20090729165211.c13f3ca3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Jul_2009_16_52_11_+1000_tSItDSZrr+=axNu9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jul_2009_16_52_11_+1000_tSItDSZrr+=axNu9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/epl/VirtualEthernetLinux.c between commit
6ed106549d17474ca17a16057f4c0ed4eba5a7ca ("net: use NETDEV_TX_OK instead
of 0 in ndo_start_xmit() functions") from the net tree and commit
49acb975a21d150c4beba4e581f3e1d004dd2867 ("Staging: remove epl driver")
from the staging tree.

The latter just removes the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__29_Jul_2009_16_52_11_+1000_tSItDSZrr+=axNu9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpv8ZsACgkQjjKRsyhoI8y1RwCgjJ83Ts3/H//W1QPdjq6XYAPW
xc8An3lYN39dwJz49a+csUcrASPbf9fW
=sBuY
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jul_2009_16_52_11_+1000_tSItDSZrr+=axNu9--
