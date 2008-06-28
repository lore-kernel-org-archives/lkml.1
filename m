Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYF1BFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYF1BFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 21:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYF1BF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 21:05:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50167 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbYF1BF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 21:05:28 -0400
Date: Sat, 28 Jun 2008 11:05:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs-masters@oss.sgi.com, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 27 - randconfig build
 fails with !CONFIG_XFS_POSIX_ACL
Message-Id: <20080628110518.5ae86cd6.sfr@canb.auug.org.au>
In-Reply-To: <4865304C.3020301@linux.vnet.ibm.com>
References: <20080627182406.a54b00c1.sfr@canb.auug.org.au>
	<4865304C.3020301@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__28_Jun_2008_11_05_18_+1000_x08UiE53=JvB=67g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__28_Jun_2008_11_05_18_+1000_x08UiE53=JvB=67g
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh.

On Fri, 27 Jun 2008 23:54:12 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> randconfig build on x86_64 machine fails with build failure
>=20
>   CC [M]  fs/xfs/linux-2.6/xfs_xattr.o
> fs/xfs/linux-2.6/xfs_xattr.c: In function =E2=80=98xfs_decode_acl=E2=80=
=99:
> fs/xfs/linux-2.6/xfs_xattr.c:40: error: =E2=80=98_ACL_TYPE_ACCESS=E2=80=
=99 undeclared (first use in this function)
> fs/xfs/linux-2.6/xfs_xattr.c:40: error: (Each undeclared identifier is re=
ported only once
> fs/xfs/linux-2.6/xfs_xattr.c:40: error: for each function it appears in.)
> fs/xfs/linux-2.6/xfs_xattr.c:42: error: =E2=80=98_ACL_TYPE_DEFAULT=E2=80=
=99 undeclared (first use in this function)

Are you sure your sources are OK?  The patch "xfs fix 1" (which is the
second last commit in the next20080627 tree) is supposed to fix that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__28_Jun_2008_11_05_18_+1000_x08UiE53=JvB=67g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhljk4ACgkQTgG2atn1QN/KUQCfSnZ5ZrafLIxuR/s0Y8R1AtQg
x7UAn1qerOHMFjR27JNekKEPqV1obWSL
=MucB
-----END PGP SIGNATURE-----

--Signature=_Sat__28_Jun_2008_11_05_18_+1000_x08UiE53=JvB=67g--
