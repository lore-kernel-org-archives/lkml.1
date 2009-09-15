Return-Path: <linux-kernel-owner+w=401wt.eu-S934371AbZIOD17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934371AbZIOD17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbZIOD1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:27:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42912 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758047AbZIOD1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:27:53 -0400
Date: Tue, 15 Sep 2009 13:27:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Siarhei Liakh <sliakh.lkml@gmail.com>, Xuxian Jiang <jiang@cs.ncsu.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: linux-next: rr tree build failure
Message-Id: <20090915132748.18662dc9.sfr@canb.auug.org.au>
In-Reply-To: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
References: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Sep_2009_13_27_48_+1000_fyhRmlMZqn5SsnSA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Sep_2009_13_27_48_+1000_fyhRmlMZqn5SsnSA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Wed, 9 Sep 2009 13:47:52 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>=20
> kernel/module.c: In function 'set_section_ro_nx':
> kernel/module.c:1549: error: implicit declaration of function 'set_memory=
_ro'
> kernel/module.c:1560: error: implicit declaration of function 'set_memory=
_nx'
> kernel/module.c: In function 'unset_section_ro_nx':
> kernel/module.c:1575: error: implicit declaration of function 'set_memory=
_rw'
>=20
> Caused by commit 25306e21864c2a220d6fa2e0632425028aa9626c
> ("module:ro-nx-protection") which uses these interfaces that are only
> defined on x86 ...
>=20
> I have used the version of the rr tree from next-20090908 for today.

Still happening ... Siarhei posted a replacement patch on Sept 11.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Sep_2009_13_27_48_+1000_fyhRmlMZqn5SsnSA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqvCbUACgkQjjKRsyhoI8yqqACgkgxuLn4nxtN4VDyjobo65O9C
hVQAn2eZqpxPzY5NucnKs7PekPTqXLN4
=bOJm
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Sep_2009_13_27_48_+1000_fyhRmlMZqn5SsnSA--
