Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXKUWxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXKUWxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXKUWxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:53:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40951 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXKUWxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:53:06 -0500
Date: Thu, 22 Nov 2007 09:52:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: 2.6.24-rc3-mm1- powerpc link failure
Message-Id: <20071122095256.dd5b6e39.sfr@canb.auug.org.au>
In-Reply-To: <4743E706.6010504@linux.vnet.ibm.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743E706.6010504@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Nov_2007_09_52_56_+1100_SNhmC_mXWA23hoE5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Nov_2007_09_52_56_+1100_SNhmC_mXWA23hoE5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Nov 2007 13:36:30 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> The kernel build fails on powerpc while linking,

Only for allyesconfig (or maybe some other config that builds a lot of
stuff in.

>   AS      .tmp_kallsyms3.o
>   LD      vmlinux.o
> ld: TOC section size exceeds 64k
> make: *** [vmlinux.o] Error 1
>=20
> The patch posted at http://lkml.org/lkml/2007/11/13/414, solves this=20
> failure.

However, that patch needs more testing especially to figure out what
performance effects it has.  i.e. not for merging, yet.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Nov_2007_09_52_56_+1100_SNhmC_mXWA23hoE5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHRLbMTgG2atn1QN8RAv3JAJ0elWher97gDR4ohd9+9yNOAj27IgCcDCBD
xKL2XNiv9EK/IUoswd4ILUc=
=Wmga
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Nov_2007_09_52_56_+1100_SNhmC_mXWA23hoE5--
