Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757906AbYLQG7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYLQG7l (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 01:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbYLQG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 01:59:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41814 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYLQG7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 01:59:30 -0500
Date: Wed, 17 Dec 2008 17:59:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <David.Woodhouse@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <ext-adrian.hunter@nokia.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: mtd tree build failures (Was: Re: linux-next: Tree for
 December 16)
Message-Id: <20081217175911.594ae84f.sfr@canb.auug.org.au>
In-Reply-To: <20081216152607.f232fafd.akpm@linux-foundation.org>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
	<20081216152607.f232fafd.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Dec_2008_17_59_11_+1100_ZmOmGec1uvXcL=B3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Dec_2008_17_59_11_+1100_ZmOmGec1uvXcL=B3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Dec 2008 15:26:07 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> This MTD patch:
>=20
> commit 69423d99fc182a81f3c5db3eb5c140acc6fc64be
> Author:     Adrian Hunter <ext-adrian.hunter@nokia.com>
> AuthorDate: Wed Dec 10 13:37:21 2008 +0000
> Commit:     David Woodhouse <David.Woodhouse@intel.com>
> CommitDate: Wed Dec 10 13:37:21 2008 +0000
>=20
>     [MTD] update internal API to support 64-bit device size
>=20
> broke the i386 build:

Also a few arm configs and the m68k allmodconfig.  I shall revert the mtd
tree from linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Dec_2008_17_59_11_+1100_ZmOmGec1uvXcL=B3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklIoz8ACgkQjjKRsyhoI8wQRwCgo9YGNCQSRqepx8yzl9oB5fg4
MwMAn3WVJXlLzHGIAbw84QIO051yF90j
=Bsci
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Dec_2008_17_59_11_+1100_ZmOmGec1uvXcL=B3--
