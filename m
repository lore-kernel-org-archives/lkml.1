Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZEBFO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZEBFO1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 01:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751112AbZEBFOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 01:14:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51242 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZEBFOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 01:14:16 -0400
Date: Sat, 2 May 2009 15:13:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: linux-next procedures: (Was: Re: linux-next: manual merge of the
 driver-core tree with the tracing tree)
Message-Id: <20090502151356.d8bf76af.sfr@canb.auug.org.au>
In-Reply-To: <20090501052256.GA18785@kroah.com>
References: <20090501150115.ce386142.sfr@canb.auug.org.au>
	<20090501052256.GA18785@kroah.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__2_May_2009_15_13_56_+1000_/5wnOGc9POXdlQ6U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_May_2009_15_13_56_+1000_/5wnOGc9POXdlQ6U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

[Greg, this is not directed only at you, but is a wider issue and you
have given me the opportunity to dicsuss it].

On Thu, 30 Apr 2009 22:22:56 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, May 01, 2009 at 03:01:15PM +1000, Stephen Rothwell wrote:
> >
> > [Aside:  the first I can find of this is the patch submission to LKML
> > within the last day ... so "posted, reviewed, unit tested"?  I assume
> > this has had some discussion somewhere, but Google doesn't know where.]
>=20
> It was posted today for discussion, which didn't seem to happen.

That was my point - waiting less than a day between the posting of a new
feature publicly and its inclusion in linux-next seems a bit impatient.
*And* you seem to have gotten some discussion now :-).

> It has been unit tested a lot in SuSE's kernels with review from our
> kernel developers (hence the 3 signed-off-bys).   We use it to speed up
> booting a lot because we have to use an initramfs (like all distros need
> to for various reasons.)  It aleviates the udev coldplug issues a lot,
> and the embedded developers have been very happy to see this (for some
> reason they only like writing private emails, not to the list, which is
> unfortunate.)

Having seen what is coming in this patch for linux-next on Monday it is
clear that there is more work to be done on this before it is ready for
Linus' tree.  linux-next is for integration testing, it is not a
development tree.  Everything in it should, in the tree maintainers
opinion, be ready for Linus' tree (if he happens to go insane and open
the merge window unexpectedly).  I am making no comment about this
particular feature, just what should be in the linux-next tree.

I would expect maintainers to have (at least) three (publicly available)
trees (where "tree" can be a quilt (sub)series, or a git branch etc):
development, ready and bug-fixes.  Development is ongoing work and new
features, not yet ready for Linus' tree. Ready is pretty much done - it
may not be bug free, but it is (as far as is reasonably possible) tested
and ready to go into Linus' tree. Bug-fixes is the stuff for Linus after
the merge window closes.

Maybe I have not made this clear enough in the past, but linux-next
should really (except for a couple of clear exceptions like "staging")
only contain the ready and bug-fixes trees.

Discussion, anyone?  I am open to changes if people think things should
be run differently, but the above makes sense to me.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__2_May_2009_15_13_56_+1000_/5wnOGc9POXdlQ6U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn71pYACgkQjjKRsyhoI8zFDgCeNL92gkoO4jQu//yPZCZ1XZ/Y
xk4AoJa4TZsitzylY/4IZklCLZKJe45H
=mBhg
-----END PGP SIGNATURE-----

--Signature=_Sat__2_May_2009_15_13_56_+1000_/5wnOGc9POXdlQ6U--
