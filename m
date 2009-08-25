Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZHYALy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZHYALy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 20:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbZHYALx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 20:11:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753700AbZHYALw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 20:11:52 -0400
Date: Tue, 25 Aug 2009 10:11:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: linux-next: origin tree build warning
Message-Id: <20090825101147.fb929fcb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Aug_2009_10_11_47_+1000_5fYDC3ARW03IRdbG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Aug_2009_10_11_47_+1000_5fYDC3ARW03IRdbG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig, gcc 4.4.0) produced these
warnings:

net/sched/sch_api.c: In function 'qdisc_watchdog':
net/sched/sch_api.c:460: warning: initialization from incompatible pointer =
type
net/sched/sch_cbq.c: In function 'cbq_undelay':
net/sched/sch_cbq.c:595: warning: initialization from incompatible pointer =
type

Introduced by commit ee5f9757ea17759e1ce5503bdae2b07e48e32af9
("pkt_sched: Convert qdisc_watchdog to tasklet_hrtimer").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Aug_2009_10_11_47_+1000_5fYDC3ARW03IRdbG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqTLEMACgkQjjKRsyhoI8zhVQCgja2wHctWF+B3qYuGAVEIfNcA
HTQAnA7Yu6Vn6fWPBVEHhb2qSf+G+uSK
=ha/j
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Aug_2009_10_11_47_+1000_5fYDC3ARW03IRdbG--
