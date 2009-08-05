Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbZHEKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbZHEKNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbZHEKNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:13:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52236 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046AbZHEKNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:13:42 -0400
Date: Wed, 5 Aug 2009 20:13:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: Tree for August 5
Message-Id: <20090805201336.fd2de2ad.sfr@canb.auug.org.au>
In-Reply-To: <4A793EA8.50306@panasas.com>
References: <20090805172337.b0688db1.sfr@canb.auug.org.au>
	<4A793EA8.50306@panasas.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__5_Aug_2009_20_13_36_+1000_eSyC8LVwkK8CnzZl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Aug_2009_20_13_36_+1000_eSyC8LVwkK8CnzZl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boaz,

On Wed, 05 Aug 2009 11:11:20 +0300 Boaz Harrosh <bharrosh@panasas.com> wrot=
e:
>
> On 08/05/2009 10:23 AM, Stephen Rothwell wrote:
> >=20
> > This tree fails to build for powerpc allyesconfig (final link problem).
>=20
> Above is reported for a long time. Is it related to this:
> http://www.spinics.net/lists/kernel/msg921978.html

No, it is this:

powerpc-linux-ld: TOC section size exceeds 64k

It is powerpc specific and the only way we can think of fixing it
involves stopping building the built-in.o files and linking the entire
kernel in one go at the end.  We just haven't had time (or the energy) to
try to fix it properly while it only affects the final link of the
allyesconfig kernel.=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Aug_2009_20_13_36_+1000_eSyC8LVwkK8CnzZl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp5W1AACgkQjjKRsyhoI8zEFwCZARDlISc+5nnBI6y1rFTPKaE3
6mEAnRGPk74YNqEwsbXPlIu+T3D1V1iX
=C2Kf
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Aug_2009_20_13_36_+1000_eSyC8LVwkK8CnzZl--
