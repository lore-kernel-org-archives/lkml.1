Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0BODdH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 22:33:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49340 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab0BODdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 22:33:05 -0500
Date: Mon, 15 Feb 2010 14:32:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>
Subject: linux-next: build warning after merge of the net tree
Message-Id: <20100215143257.7af33452.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Feb_2010_14_32_57_+1100_4MUE_yWPF6LzytOv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Feb_2010_14_32_57_+1100_4MUE_yWPF6LzytOv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

net/mac80211/iface.c: In function 'ieee80211_stop':
net/mac80211/iface.c:416: warning: passing argument 4 of '__dev_addr_unsync=
' makes pointer from integer without a cast
include/linux/netdevice.h:1967: note: expected 'int *' but argument is of t=
ype 'int'

Introduced by commit 4cd24eaf0c6ee7f0242e34ee77ec899f255e66b5 ("net: use
netdev_mc_count and netdev_mc_empty when appropriate").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Feb_2010_14_32_57_+1100_4MUE_yWPF6LzytOv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt4wGkACgkQjjKRsyhoI8yiRACdGKonY+B59p389LkbjfLcANc4
35IAnj3hrac7LlMivP5of9U3e4cYnS0g
=Fu3v
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Feb_2010_14_32_57_+1100_4MUE_yWPF6LzytOv--
