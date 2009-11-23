Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZKWBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZKWBBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 20:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZKWBA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 20:00:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884AbZKWBA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 20:00:58 -0500
Date: Mon, 23 Nov 2009 12:00:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: linux-next: manual merge of the net tree with the net-current tree
Message-Id: <20091123120052.dd388203.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__23_Nov_2009_12_00_52_+1100_CnAuE2zDVY_yjpMK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Nov_2009_12_00_52_+1100_CnAuE2zDVY_yjpMK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/ieee802154/fakehard.c between commit
56cf54831fd1be105e89a9df899e3b22442da180 ("ieee802154: dont leak skbs in
ieee802154_fake_xmit()") from the net-current tree and commit
8964be4a9a5ca8cab1219bb046db2f6d1936227c ("net: rename skb->iif to
skb->skb_iif") from the net tree.

The former removed the code modified by the latter, so I used the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__23_Nov_2009_12_00_52_+1100_CnAuE2zDVY_yjpMK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksJ3sQACgkQjjKRsyhoI8zqBQCgrqL0/XwoyIDqQ+1sZ6NFaXf4
qE0An2cN4A4jUJsYFObSaHl/fOcA2pXS
=MoYn
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Nov_2009_12_00_52_+1100_CnAuE2zDVY_yjpMK--
