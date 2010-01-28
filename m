Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600Ab0A1Hob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0A1Hob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468Ab0A1Ho3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:44:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43859 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab0A1Ho3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:44:29 -0500
Date: Thu, 28 Jan 2010 18:44:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
Message-Id: <20100128184423.40ce38fb.sfr@canb.auug.org.au>
In-Reply-To: <20091214163338.f811722f.sfr@canb.auug.org.au>
References: <20091214163338.f811722f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Jan_2010_18_44_23_+1100_ltIe824W9k3/l5yp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jan_2010_18_44_23_+1100_ltIe824W9k3/l5yp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 14 Dec 2009 16:33:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (sparc defconfig) produced this warning:
>=20
> In file included from arch/sparc/include/asm/uaccess.h:7,
>                  from include/net/checksum.h:26,
>                  from include/linux/skbuff.h:29,
>                  from net/core/pktgen.c:141:
> In function 'copy_from_user',
>     inlined from 'pktgen_if_write' at net/core/pktgen.c:867:
> arch/sparc/include/asm/uaccess_32.h:276: warning: call to 'copy_from_user=
_overflow' declared with attribute warning: copy_from_user() buffer size is=
 not provably correct
>=20
> and many more.
>=20
> The sparc64 defconfig build produced many similar warnings:
>=20
> In file included from arch/sparc/include/asm/uaccess.h:5,
>                  from include/linux/uaccess.h:6,
>                  from include/linux/highmem.h:7,
>                  from include/linux/pagemap.h:11,
>                  from include/linux/mempolicy.h:63,
>                  from mm/mempolicy.c:69:
> arch/sparc/include/asm/uaccess_64.h: In function 'compat_sys_get_mempolic=
y':
> arch/sparc/include/asm/uaccess_64.h:232: warning: call to 'copy_from_user=
_overflow' declared with attribute warning: copy_from_user() buffer size is=
 not provably correct

I am still seeing these.  Is it my compiler version (gcc4.4.0)?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Jan_2010_18_44_23_+1100_ltIe824W9k3/l5yp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkthQFcACgkQjjKRsyhoI8ze2wCgmGhxSREblfcz2f68tiC0Abnr
kbAAoIJkdJlOFOfT4mA/EC6S1FdyuUzw
=/Xeh
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jan_2010_18_44_23_+1100_ltIe824W9k3/l5yp--
