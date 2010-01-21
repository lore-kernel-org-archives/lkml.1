Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132Ab0AUAK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab0AUAK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 19:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708Ab0AUAK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 19:10:27 -0500
Received: from vserver.emeraldcity.de ([91.204.170.123]:51197 "EHLO
	smtphost.emeraldcity.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab0AUAK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 19:10:26 -0500
X-Spam-ASN: 
From: Michail Bachmann <mb@emeraldcity.de>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: PROBLEM: kernel BUG at mm/page_alloc.c:775
Date: Thu, 21 Jan 2010 01:10:07 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <201001092232.21841.mb@emeraldcity.de> <alpine.DEB.2.00.1001121524140.25925@router.home> <20100118120315.GD7499@csn.ul.ie>
In-Reply-To: <20100118120315.GD7499@csn.ul.ie>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1463699.XHS8DYmcO1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001210110.18569.mb@emeraldcity.de>
X-Envelope-From: <mb@emeraldcity.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1463699.XHS8DYmcO1
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> On Tue, Jan 12, 2010 at 03:25:23PM -0600, Christoph Lameter wrote:
> > On Sat, 9 Jan 2010, Michail Bachmann wrote:
> > > [   48.505381] kernel BUG at mm/page_alloc.c:775!
> >
> > Somehow nodes got mixed up or the lookup tables for pages / zones are n=
ot
> > giving the right node numbers.
>=20
> Agreed. On this type of machine, I'm not sure how that could happen
> short of struct page information being corrupted. The range should
> always be aligned to a pageblock boundary and I cannot see how that
> would cross a zone boundary on this machine.
>=20
> Does this machine pass memtest?
I ran one pass with memtest86 without errors before posting this bug, but I=
=20
can let it run "all tests" for a while just to be sure it is not caused by=
=20
broken hw.

> Is there any chance the problem can be bisected?
I will give it a try, when the memtest is done.

Thanks.

CU Micha

--nextPart1463699.XHS8DYmcO1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCAAGBQJLV5tiAAoJEDOFMLjtzdvODwwP/1a82BxBKtulW8UC251hgpu+
nTH99e4ifKpQa65PpS3KyZC/ZjeqEhygSPH/rQVemxCLwcmvMtolBbrTEMZ41XhT
ZfC7Jk8F1tNyyo1GolUILZCdYwQK9cajc5r2pvBIjj/rIj4eiaIOVNhdYVfy/MOp
e34ugtVkbM947vzL/9UdIRSpDyG8TRni6K3Gf9/ZJF9PcXaWbv4Zv0ZdStPXfSc9
0wlUTUBDshgRNH+yQO5PJRTswhZ+HDD3mmGQf623AO0l/0Zf197covpCAATt+7Pd
NfvfVLRZro7/4CXhzl6evuXKJRv73sJW/hl50o6Q/vLX8RFAxWFrCQ209gluhUmY
lK6L/juaVNKn+Jk7OA4osw+TbJoaKvdF+0IEzLCfQ5vePAmETe9RSuYaLUyumduv
FDKZqba6xS8AVKVnY2o6eimLHisgeu1T9CYN3Kys1RQdJSap9dvoTt+1yKVfHqyq
b6lWY7f9dh1KtAEVguzJYxg25YQEUBSpyt5L48E7iKrM74jrBMah/1qP0nk+pPRs
nPVsyHjP3FHZQ0MLcvCWcQeRrUWW6NCqgDyDE4Z38eyoeO5bA2ER3q5hg4GrZWqH
8Cjo5VHbDnEC9fzH9BimO+HNC4mD3mjpIOt1Cm+I4pn1nTyfnr0tBOfqOr4rOJlg
OePlidvPg8eNjarfIVnb
=CZOR
-----END PGP SIGNATURE-----

--nextPart1463699.XHS8DYmcO1--
