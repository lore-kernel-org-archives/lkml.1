Return-Path: <linux-kernel-owner+w=401wt.eu-S1753851AbYGYHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbYGYHRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 03:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYGYHRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 03:17:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49419 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYGYHRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 03:17:25 -0400
Date: Fri, 25 Jul 2008 17:17:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: benh@kernel.crashing.org
Cc: Michael Brown <mbrown@fensystems.co.uk>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Jeff Garzik <jgarzik@pobox.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: sfx.c driver build failure
Message-Id: <20080725171715.9287c823.sfr@canb.auug.org.au>
In-Reply-To: <1216966559.11188.85.camel@pasglop>
References: <1216966559.11188.85.camel@pasglop>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__25_Jul_2008_17_17_15_+1000_=dg3HtgGfsAYefMY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Jul_2008_17_17_15_+1000_=dg3HtgGfsAYefMY
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jul 2008 16:15:59 +1000 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> The sfx driver (which happens to be part of some of our test configs)
> fails to build in current Linus tree on powerpc with this error:
>=20
> /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c: In function =E2=
=80=98efx_probe_interrupts=E2=80=99:
> /home/benh/kernels/linux-powerpc/drivers/net/sfc/efx.c:845: error: lvalue=
 required as unary =E2=80=98&=E2=80=99 operand

Commit 695a6b456307455a10059512208e8ed0d376ecd3 "topology: work around
topology_core_siblings() breakage" in linux-next (from the cpus4096 tree)
comments out the offending lines ...  With the comment "the topology API
is a mess right now".

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Jul_2008_17_17_15_+1000_=dg3HtgGfsAYefMY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiJffsACgkQjjKRsyhoI8zX6ACeP7LvkzHL3ujlfcXok1av2KZu
z58AoKXXaEI0I5Yy4gWJDtRC5e7SHszi
=o3CA
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Jul_2008_17_17_15_+1000_=dg3HtgGfsAYefMY--
