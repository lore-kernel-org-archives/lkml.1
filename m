Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYF0H0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYF0H0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 03:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYF0H0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 03:26:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38322 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbYF0H0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 03:26:22 -0400
Date: Fri, 27 Jun 2008 17:26:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-masters@oss.sgi.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Alexander Beregalov" <a.beregalov@gmail.com>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
Message-Id: <20080627172614.83a604e4.sfr@canb.auug.org.au>
In-Reply-To: <4861A4E8.1060101@sgi.com>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au>
	<20080624171809.42bbdf68.randy.dunlap@oracle.com>
	<20080625003751.GP29319@disturbed>
	<4861A00E.6040801@sgi.com>
	<4861A4E8.1060101@sgi.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_Jun_2008_17_26_14_+1000_X9bqhmhapx7==tXO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Jun_2008_17_26_14_+1000_X9bqhmhapx7==tXO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Jun 2008 11:52:40 +1000 Timothy Shimmin <tes@sgi.com> wrote:
>
> So we could move up the acl defines in xfs_acl.h.
> Unless Christoph wants some other rearrangement...
>=20
> Index: 2.6.x-xfs-quilt/fs/xfs/xfs_acl.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- 2.6.x-xfs-quilt.orig/fs/xfs/xfs_acl.h	2008-06-25 10:46:42.000000000 +=
1000
> +++ 2.6.x-xfs-quilt/fs/xfs/xfs_acl.h	2008-06-25 11:45:25.221045485 +1000
> @@ -46,6 +46,8 @@ typedef struct xfs_acl {
>  #define SGI_ACL_FILE_SIZE	(sizeof(SGI_ACL_FILE)-1)
>  #define SGI_ACL_DEFAULT_SIZE	(sizeof(SGI_ACL_DEFAULT)-1)
> =20
> +#define _ACL_TYPE_ACCESS	1
> +#define _ACL_TYPE_DEFAULT	2
> =20
>  #ifdef CONFIG_XFS_POSIX_ACL
> =20
> @@ -66,8 +68,6 @@ extern int xfs_acl_vset(bhv_vnode_t *, v
>  extern int xfs_acl_vget(bhv_vnode_t *, void *, size_t, int);
>  extern int xfs_acl_vremove(bhv_vnode_t *, int);
> =20
> -#define _ACL_TYPE_ACCESS	1
> -#define _ACL_TYPE_DEFAULT	2
>  #define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECU=
TE))
> =20
>  #define _ACL_INHERIT(c,m,d)	(xfs_acl_inherit(c,m,d))
>=20

I have applied this to linux-next for today, please apply it (or
something similar) to the xfs tree soon.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_Jun_2008_17_26_14_+1000_X9bqhmhapx7==tXO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhklhYACgkQTgG2atn1QN8VngCfXEvOn4b/xqF9mJrYitz+mpwt
ttsAmwZ8w7lUl2cMKGC+co8+sKSPSz8V
=RPGa
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Jun_2008_17_26_14_+1000_X9bqhmhapx7==tXO--
