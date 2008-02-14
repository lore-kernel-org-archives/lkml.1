Return-Path: <linux-kernel-owner+w=401wt.eu-S933330AbYBNMWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbYBNMWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbYBNMWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:22:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758828AbYBNMWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:22:41 -0500
Date: Thu, 14 Feb 2008 23:22:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080214232229.f7bdc6ac.sfr@canb.auug.org.au>
In-Reply-To: <20080214081405.GA20791@flint.arm.linux.org.uk>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
	<20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
	<20080211221535.bc0dc9cf.akpm@linux-foundation.org>
	<20080212225716.cf695fe4.sfr@canb.auug.org.au>
	<20080214081405.GA20791@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__14_Feb_2008_23_22_29_+1100_sndb.Bs6hu81vY.G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__14_Feb_2008_23_22_29_+1100_sndb.Bs6hu81vY.G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Thu, 14 Feb 2008 08:14:05 +0000 Russell King <rmk+lkml@arm.linux.org.uk>=
 wrote:
>
> On Tue, Feb 12, 2008 at 10:57:16PM +1100, Stephen Rothwell wrote:
> > We need to ask Linus to promise that he will pull the stable branch from
> > linux-next first in the merge window.  For that to happen, I would expe=
ct
> > that Linus would also review and sign off (or ack) these commits to the
> > linux-next tree.
>=20
> Changing the commits in git in anyway changes their ID, which has the
> same effects as a rebase.

Correct.

> With this idea, Linus only has two choices:
>=20
> 1. pull the entire set of linux-next changes whether he likes them or not,
>    because he's going to get them either from the linux-next tree or some=
one
>    elses tree which is based upon that.
>=20
> 2. don't pull the changes, nor anyone elses tree if he hates the changes
>    in linux-next.
>=20
> So really, Linus needs to ack the changes _before_ they go into linux-nex=
t.

This is exactly what I suggested (or meant to) *except* that I want it to
only apply to the stable branch.  I intend that the stable branch of
linux-next will never be rebased and so is suitable for others to base
their trees off.  The master branch will be continually rebased as the
subsystem trees change over time.

Originally, I assumed the stable branch would be for our "usual" API
changes, but it appears we are not having any more of those. :-)  However,
I see an argument for attempting to stabilise possible conflicting
changes get Linus' review/ack and add them to the stable branch.

Linus suggested that such changes should go into an independent tree that
everyone could pull into their trees with the full confidence that that
tree would be merged into Linus' tree when the merge window opens.  I am
suggesting that that tree be the stable branch of linux-next.

I know I haven't thought through all the consequences of this, so
discussion is encouaged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__14_Feb_2008_23_22_29_+1100_sndb.Bs6hu81vY.G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtDKMTgG2atn1QN8RAnLHAJwNKxwZx5NwzhALxFIZ56IE7tmSWACfWKWC
ODPz50adZaYwTFKNa63QTSs=
=LOGm
-----END PGP SIGNATURE-----

--Signature=_Thu__14_Feb_2008_23_22_29_+1100_sndb.Bs6hu81vY.G--
