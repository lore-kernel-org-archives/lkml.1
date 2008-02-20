Return-Path: <linux-kernel-owner+w=401wt.eu-S1760854AbYBTOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760854AbYBTOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYBTOzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:55:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58166 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYBTOzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:55:19 -0500
Date: Thu, 21 Feb 2008 01:55:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080221015511.1b54d4d3.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080212042133.GA4625@kroah.com>
	<20080211203146.3d28d1a0@laptopd505.fenrus.org>
	<1202791555.20739.6.camel@heimdal.trondhjem.org>
	<20080212051136.GA12802@mit.edu>
	<20080211221535.bc0dc9cf.akpm@linux-foundation.org>
	<20080212225716.cf695fe4.sfr@canb.auug.org.au>
	<20080214081405.GA20791@flint.arm.linux.org.uk>
	<20080214232229.f7bdc6ac.sfr@canb.auug.org.au>
	<alpine.LFD.1.00.0802140949460.6110@woody.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Feb_2008_01_55_11_+1100_=PJcBvYyEL5jN.p7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2008_01_55_11_+1100_=PJcBvYyEL5jN.p7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Thu, 14 Feb 2008 10:01:14 -0800 (PST) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> I absolutely have no problem with having a "this is the infrastrcture=20
> changes that will go into the next release". In fact, I can even=20
> *maintain* such a branch.=20
>=20
> I've not wanted to open up a second branch for "this is for next release"=
,=20
> because quite frankly, one of the other problems we have is that people=20
> already spend way too much time on the next release compared to just=20
> looking at regressions in the current one. But especially if we're talkin=
g=20
> about _purely_ API changes etc infrastructure, I could certainly do a=20
> "next" branch.=20

So, will you open such a branch?  If so, what would be the mechanics of
having patches applied to it?  I assume people would have to suggest such
changes explicitly and have them reviewed (hopefully more thoroughly than
usual) in that light.  I guess one place these "infrastructure" changes
may be noticed would be when subsystem maintainers stray outside their
subsystem in what they submit to the linux-next tree (or break it).

Then I assume most people would start working on a merge of this "next"
branch and your "master" branch, right?  Consequently, each linux-next
would also be based on that merge.

I suppose I am stating the obvious (or asking the dumb questions), but I
always find it easier to have explicit answers to these sorts of things.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Feb_2008_01_55_11_+1100_=PJcBvYyEL5jN.p7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHvD9UTgG2atn1QN8RAsHKAJ9HBQDKqSFthSl0Ua6uWMLkFLdQ9wCff0Hb
22w3DehCjH6nvrhd1PKo5MY=
=NhP2
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2008_01_55_11_+1100_=PJcBvYyEL5jN.p7--
