Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbYL2Ant@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbYL2Ant (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 19:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbYL2Ank
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 19:43:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbYL2Anj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 19:43:39 -0500
Date: Mon, 29 Dec 2008 11:43:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Aleksey Senin <alekseys@voltaire.com>
Subject: linux-next: origin tree build failure
Message-Id: <20081229114321.4b6baea5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Dec_2008_11_43_21_+1100_i6JBmXzXD+xdLyhM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Dec_2008_11_43_21_+1100_i6JBmXzXD+xdLyhM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Roland,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

ERROR: ".ipv6_chk_addr" [drivers/infiniband/core/ib_addr.ko] undefined!
ERROR: ".ip6_route_output" [drivers/infiniband/core/ib_addr.ko] undefined!

Caused by commit 38617c64bf9a10bf20e41d95b69bb81e8560fe9d ("RDMA/addr:
Add support for translating IPv6 addresses").  This requires a dependency
on IPV6.

I have reverted that commit for today (which fixes the build, but may not
be the correct solution).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/


--Signature=_Mon__29_Dec_2008_11_43_21_+1100_i6JBmXzXD+xdLyhM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklYHSkACgkQjjKRsyhoI8xTwgCgtsdUBxVl8CasF3jivNEZEIH3
T2UAn3ACZuW01imdIPxlZh4RVI8jU0Gt
=M28q
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Dec_2008_11_43_21_+1100_i6JBmXzXD+xdLyhM--
