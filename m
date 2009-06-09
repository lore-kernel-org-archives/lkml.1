Return-Path: <linux-kernel-owner+w=401wt.eu-S1755726AbZFIFo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726AbZFIFo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 01:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZFIFow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 01:44:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41704 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbZFIFov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 01:44:51 -0400
Date: Tue, 9 Jun 2009 15:44:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rohit Hagargundgi <h.rohit@samsung.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kyungmin.park@samsung.com>
Subject: linux-next: mtd tree build warning
Message-Id: <20090609154449.edb6306a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_15_44_49_+1000_uhgmGJ6eUx2xuiov"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_15_44_49_+1000_uhgmGJ6eUx2xuiov
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/mtd/onenand/onenand_base.c:3266: warning: 'flexonenand_setup' defin=
ed but not used

Introduced by commit 5988af2319781bc8e0ce418affec4e09cfa77907 ("mtd:
Flex-OneNAND support").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_15_44_49_+1000_uhgmGJ6eUx2xuiov
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkot9tEACgkQjjKRsyhoI8yMCwCeJNyo07LqySflA8W5fEp1NhnW
pCsAn11EC2LLQSvpDqghqbrzAS30oVLm
=32/q
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_15_44_49_+1000_uhgmGJ6eUx2xuiov--
