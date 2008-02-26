Return-Path: <linux-kernel-owner+w=401wt.eu-S1761204AbYBZDyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761204AbYBZDyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758660AbYBZDy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:54:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54932 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758325AbYBZDyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:54:25 -0500
Date: Tue, 26 Feb 2008 14:54:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080226145418.59f6f35f.sfr@canb.auug.org.au>
In-Reply-To: <20080216000943.GD31474@flint.arm.linux.org.uk>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080216000943.GD31474@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Feb_2008_14_54_18_+1100_P4.bJaZUzzVusBqf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Feb_2008_14_54_18_+1100_P4.bJaZUzzVusBqf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Sat, 16 Feb 2008 00:09:43 +0000 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> On Tue, Feb 12, 2008 at 12:02:08PM +1100, Stephen Rothwell wrote:
> > I will attempt to build the tree between each merge (and a failed build
> > will again cause the offending tree to be dropped).  These builds will =
be
> > necessarily restricted to probably one architecture/config.  I will bui=
ld
> > the entire tree on as many architectures/configs as seem sensible and
> > the results of that will be available on a web page (to be announced).
>=20
> This restriction means that the value for the ARM architecture is soo
> limited it's probably not worth the hastle participating in this project.
>=20
> We already know that -mm picks up on very few ARM conflicts because
> Andrew doesn't run through the entire set of configurations; unfortunately
> ARM is one of those architectures which is very diverse [*], and because
> of that, ideas like "allyconfig" are just completely irrelevant to it.
>=20
> As mentioned elsewhere, what we need for ARM is to extend the kautobuild
> infrastructure (see armlinux.simtec.co.uk) so that we can have more trees
> at least compile tested regularly - but that requires the folk there to
> have additional compute power (which isn't going to happen unless folk
> stamp up some machines _or_ funding).

I now have an arm cross compiler (gcc-4.0.2-glibc-2.3.6
arm-unknown-linux-gnu).  (See the results page at
http://kisskb.ellerman.id.au/kisskb/branch/9/ - I must get a better
name/place :-(.)  Is this sufficient to help you out?  What configs would
be useful to build (as Andrew said, they don't take very long each).

I really want as many subsystems as possible in the linux-next tree in an
attempt to avoid some of the merge/conflict problems we have had in the
past.  What can we do to help?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Feb_2008_14_54_18_+1100_P4.bJaZUzzVusBqf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHw41uTgG2atn1QN8RArnCAJ9C5NEof7XPsPca6AbTZTLMFtlt3ACeJ3oT
XxM2GDdIFPvh4I3uE3gLxRI=
=ee6M
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Feb_2008_14_54_18_+1100_P4.bJaZUzzVusBqf--
