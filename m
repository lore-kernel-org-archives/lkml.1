Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0BOEUT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 23:20:19 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:32925 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab0BOEUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 23:20:17 -0500
Date: Mon, 15 Feb 2010 15:20:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: linux-next: build failure after merge of the net tree
Message-Id: <20100215152009.c8f9949c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Feb_2010_15_20_09_+1100_6koxfCKX=wbc9kxQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Feb_2010_15_20_09_+1100_6koxfCKX=wbc9kxQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the net tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

usr/include/linux/ethtool.h:17: included file 'linux/rculist.h' is not expo=
rted

Caused by commit 15682bc488d4af8c9bb998844a94281025e0a333 ("ethtool:
Introduce n-tuple filter programming support").

I have used the version of the net tree from next-20100212 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Feb_2010_15_20_09_+1100_6koxfCKX=wbc9kxQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt4y3kACgkQjjKRsyhoI8zX7ACeLoKbkpK8opy6QPyiOdx1cRU/
HaQAoKHFNGT6hZsjJkaHaBsckHXXcTJr
=fTdb
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Feb_2010_15_20_09_+1100_6koxfCKX=wbc9kxQ--
