Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZHCAf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZHCAf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 20:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbZHCAf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 20:35:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57700 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbZHCAf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 20:35:56 -0400
Date: Mon, 3 Aug 2009 10:35:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andre Noll <maan@systemlinux.org>
Subject: linux-next:  tree build failure
Message-Id: <20090803103550.9b28900a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_Aug_2009_10_35_50_+1000_7.WuXeXwnH_65FJ1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Aug_2009_10_35_50_+1000_7.WuXeXwnH_65FJ1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

ERROR: ".md_integrity_add_rdev" [drivers/md/multipath.ko] undefined!

Caused by commit 66f4f3f41f5c334f399e920b2aaad9b82514acda ("md: Push down
data integrity code to personalities") from the md-current and md trees.
Looks like md_integrity_add_rdev needs an EXPORT_SYMBOL.

I have used the version of the md-current and md trees from next-20090731
for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_Aug_2009_10_35_50_+1000_7.WuXeXwnH_65FJ1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2MOYACgkQjjKRsyhoI8x5lwCbBuupixOJObwb4WhJd2KX5AEm
qosAn0SGX0WcTtdOgExhBEe2PSuWgHLM
=iC+p
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Aug_2009_10_35_50_+1000_7.WuXeXwnH_65FJ1--
