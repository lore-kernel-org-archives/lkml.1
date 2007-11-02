Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbXKBUVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbXKBUVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 16:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbXKBUVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 16:21:12 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44798 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbXKBUVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 16:21:11 -0400
Date: Fri, 2 Nov 2007 15:18:35 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com
Subject: Re: [PATCH 3/3] eCryptfs: Set inode key only once per crypto operation
Message-ID: <20071102201835.GC30487@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20071102185033.GB30487@localhost.austin.ibm.com> <20071102185308.GC30760@localhost.austin.ibm.com> <20071102131031.3369e6e6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <20071102131031.3369e6e6.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 02, 2007 at 01:10:31PM -0700, Andrew Morton wrote:
> On Fri, 2 Nov 2007 13:53:08 -0500
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
>=20
> > There is no need to keep re-setting the same key for any given
> > eCryptfs inode. This patch optimizes the use of the crypto API and
> > helps performance a bit.
> >=20
> > Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
> > Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
>=20
> I've inferred from this that Michael authored this patch.  Please
> let me know if that was incorrect.

Trevor Highland actually authored this one.

> The way in which we indicate authorship is to put a From: line right
> at the top of the changelog.  If no such line appears then the From:
> line from the mail headers is used.

Noted.

Mike

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iQEVAwUBRyuGG9tAhTFtyodpAQMnXQf/YJlxOY0iBAE0eIywYtLs4VphkyVFr+/y
0/WN9IkK8gnAUSGyzCj4Oo0jNyzV7q5onmSoLW8q9jXWBkdSdgagxss47Ro5j7pN
NGb33laRCRV4jSPzedVLLb2pAplAB0wLZUoKMZzHvi4mFooP7gdPkwBYrh8GEGv3
3N9sMwhmhnMHUbgR+wkPDYj4hdoHH8OlyH1Vy090Y1DKsMI0w+EuT1CTuLT47pTE
SY6Q4s1Bm4Kfk/M7k0petkd31lHIyYtpzZ5of9d2vW/IKhAlGiPDivYFe7xUGCwo
2G4OMPBAF49yvm8/DxtsqgTEHrZT4AfXEGv0jnoj/FYdzi9vRESMWw==
=nkwq
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
