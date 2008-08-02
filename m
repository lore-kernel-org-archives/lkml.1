Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbYHBEHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbYHBEHP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 00:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYHBEHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 00:07:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYHBEHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 00:07:00 -0400
Date: Sat, 2 Aug 2008 14:06:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: m68k build failure
Message-Id: <20080802140650.ed81402d.sfr@canb.auug.org.au>
In-Reply-To: <20080801204157.GA12390@uranus.ravnborg.org>
References: <20080730175233.02dbf021.sfr@canb.auug.org.au>
	<20080730.010234.193703201.davem@davemloft.net>
	<20080730084935.GA18545@uranus.ravnborg.org>
	<20080801153710.815bbb74.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0808011551120.30950@anakin>
	<20080801204157.GA12390@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_Aug_2008_14_06_50_+1000_ISkAY9GDq13rjiXQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Aug_2008_14_06_50_+1000_ISkAY9GDq13rjiXQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

On Fri, 1 Aug 2008 22:41:57 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
>
> On Fri, Aug 01, 2008 at 03:52:22PM +0200, Geert Uytterhoeven wrote:
> >=20
> > BTW, is there a (good) way to have this without duplicating those heade=
r files?
>=20
> The only solution I can come up with right now is:
>=20
> Makefile:
> ccflags-y +=3D -Iarch/sparc/include
>=20
> foo.c:
> #include <asm/fbio.h>
>=20
> Disadvantage is that we loose the explicit documentation that this
> is header files from another architecture.
> So we should at least add a comment saying this.
>=20
> And the above would not work if the file has same filename,
> but then that is not a likely situation either.

There is at least one of the m68k header files that includes the sparc
file of the same name and then does other stuff.  So this scheme would
not cover that  (unless we used #include_next?)=20

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_Aug_2008_14_06_50_+1000_ISkAY9GDq13rjiXQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiT3VoACgkQjjKRsyhoI8w7hgCeLw3jIy3pfCWMGitfQfyakM39
1ncAoISz17ijuk7I3GQNbUSF44+jV7Kq
=xOzC
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Aug_2008_14_06_50_+1000_ISkAY9GDq13rjiXQ--
