Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759872AbYLQHbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872AbYLQHbZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYLQHbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:31:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:33171 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbYLQHbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:31:05 -0500
Date: Wed, 17 Dec 2008 18:30:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kbuild@vger.kernel.org, mel@csn.ul.ie,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        linux-next@vger.kernel.org, sam@ravnborg.org
Subject: Re: next-20081216 - powerpc link error 'dynreloc miscount'
Message-Id: <20081217183054.79fa2546.sfr@canb.auug.org.au>
In-Reply-To: <20081217070858.GA7424@linux.vnet.ibm.com>
References: <20081216223754.0c8e21d4.sfr@canb.auug.org.au>
	<20081217070858.GA7424@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Dec_2008_18_30_54_+1100_ZWTYu0wcAuYkD1Z/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Dec_2008_18_30_54_+1100_ZWTYu0wcAuYkD1Z/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Wed, 17 Dec 2008 12:38:58 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> 	next-20081216 build breaks on powerpc
>=20
> ld: dynreloc miscount for kernel/built-in.o, section .opd
> ld: can not edit opd Bad value
> make: *** [vmlinux.o] Error 1
>=20
> # ld --version
> GNU ld version 2.16.1 Debian GNU/Linux
>=20
> # gcc --version
> gcc (GCC) 4.0.2 20050808 (prerelease) (Ubuntu 4.0.1-4ubuntu9)

Yeah, I have seen this as well.  A later toolchain (gcc 4.3.2, binutils
2.19) works ok.  Also it is only a problem for some configs (see
http://kisskb.ellerman.id.au/kisskb/branch/9/).  It started with
next-20081215.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Dec_2008_18_30_54_+1100_ZWTYu0wcAuYkD1Z/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklIqq4ACgkQjjKRsyhoI8yypgCgq67JOQdiBWnaaMVNomra3fGv
v0MAnjZrE9xk/okAHYOFBkgin3X51aGh
=jl4r
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Dec_2008_18_30_54_+1100_ZWTYu0wcAuYkD1Z/--
