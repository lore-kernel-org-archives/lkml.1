Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYBLL5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYBLL5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYBLL5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:57:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53573 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYBLL5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:57:24 -0500
Date: Tue, 12 Feb 2008 22:57:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080212225716.cf695fe4.sfr@canb.auug.org.au>
In-Reply-To: <20080211221535.bc0dc9cf.akpm@linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
	<20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
	<20080211221535.bc0dc9cf.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Feb_2008_22_57_16_+1100_Bu_vf4sm8pZq6e=0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2008_22_57_16_+1100_Bu_vf4sm8pZq6e=0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Feb 2008 22:15:35 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Another thing we could do when these things happen is all gang up on Linus
> and ask him to merge the API change into mainline.  Because often the
> change can be done in two stages: 1) change the interface then 2) add the=
 code
> in the callee which _uses_ that changed interface.  Part 1 is an obviousl=
y-safe
> do-nothing change and fixes the merge problems.  Part 2 is at a single si=
te
> and can be merged in 2.6.x+1.

I have an alternative (with help from Paul Mackerras).

We have a branch in linux-next that is stable and only progresses forward
i.e. is never rebased.  Global API changes/introductions that are of type
1 above go into this branch (after appropriate etc).  Fixes to them go in
as well.  People can base development on this branch.

But ... they can only really do that *if* we can guarantee that part of
linux-next will be in Linus' tree very early in the next merge window.
So here is the had part ...

We need to ask Linus to promise that he will pull the stable branch from
linux-next first in the merge window.  For that to happen, I would expect
that Linus would also review and sign off (or ack) these commits to the
linux-next tree.

The rest of linux-next would always be based on the stable part plus
Linus' current tree.

Will this fly?

Comments?

> A fully running and successful linux-next won't change outcomes a lot, I
> expect.  It will help to pick up on obvious bugs and build errors and
> bisection breakages prior to them hitting mainline.  But we fix those
> things by -rc1 or -rc2 anyway.  So it's just a time-shift, causing no gre=
at
> change in the final 2.6.x.

I am hoping that this time shift will allow more time for bug
fixing/polishing.  But maybe I am being to optimistic again :-)

> linux-next will do little to solve our (IMO) largest problem: unfixed
> regressions and bugs.  otoh it will free up a lot of my time and
> hair-tearing, so I can devote more attention to the bugs.  (where
> "attention" usually=3D "sending irritiating emails")

And may be you can get more sleep and dream up some more schemes :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Feb_2008_22_57_16_+1100_Bu_vf4sm8pZq6e=0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsYmhTgG2atn1QN8RAuiLAKCJXspwwncOlnVeqpNzJda5mJs31gCfX0T7
b2kZl7UE6SFS395urzPd2Pw=
=pqMW
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2008_22_57_16_+1100_Bu_vf4sm8pZq6e=0--
