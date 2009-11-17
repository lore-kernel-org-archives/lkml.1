Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZKQIEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZKQIEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZKQIEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:04:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45922 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031AbZKQIEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:04:06 -0500
Date: Tue, 17 Nov 2009 19:04:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: linux-next: manual merge of the sysctl tree with Linus' tree
Message-Id: <20091117190406.108f967d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Nov_2009_19_04_06_+1100_zSX6WCkQ71oVpwsm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Nov_2009_19_04_06_+1100_zSX6WCkQ71oVpwsm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the sysctl tree got a conflict in
net/decnet/sysctl_net_decnet.c between commit
887e671f324d9898aaedb29a6ece6c853c394067 ("decnet: netdevice refcount
leak") from Linus' tree and commit
f8572d8f2a2ba75408b97dc24ef47c83671795d7 ("sysctl net: Remove unused
binary sysctl code") from the sysctl tree.

The latter removed the code (function dn_def_dev_strategy()) modified by
the former, so I just used the latter.  I can carry this fix for a while,
but it can be fixed by merging v2.6.32-rc7 (or just the
above commit from Linus' tree - which would merge a much smaller number of
commits) into the sysctl tree.=20
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Nov_2009_19_04_06_+1100_zSX6WCkQ71oVpwsm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksCWPcACgkQjjKRsyhoI8zL6gCdE8OZxbrGqE5mhGY1/yPh1LsN
yMkAnRTe4gygNpBtS/1Qevf1xGIeoKbs
=m1B3
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Nov_2009_19_04_06_+1100_zSX6WCkQ71oVpwsm--
