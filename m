Return-Path: <linux-kernel-owner+w=401wt.eu-S1757646AbYBLCXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646AbYBLCXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 21:23:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYBLCXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 21:23:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49717 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbYBLCXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:23:13 -0500
Date: Tue, 12 Feb 2008 13:23:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080212132306.6062910e.sfr@canb.auug.org.au>
In-Reply-To: <1202780209.3122.96.camel@localhost.localdomain>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<1202780209.3122.96.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Feb_2008_13_23_06_+1100_LloUtqqId=UH35HX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2008_13_23_06_+1100_LloUtqqId=UH35HX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Mon, 11 Feb 2008 19:36:49 -0600 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> On Tue, 2008-02-12 at 12:02 +1100, Stephen Rothwell wrote:
> >=20
> > Andrew was looking for someone to run a linux-next tree that just
> > contained the subsystem git and quilt trees for 2.6.x+1 and I (in a
> > moment of madness) volunteered.  So, this is to announce the creating of
> > such a tree (it doesn't exist yet) which will require some (hopefully)
> > small amount of work on the part of subsystem maintainers.
>=20
> Actually, it sort of does.  If you look here:

Yes, Andrew pointed me there and I should have mentioned it, sorry.

> http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree/
>=20
> You'll find a merge candidate tree that builds nightly from everyone's
> git and quilt trees.  I'm using it to track merge conflicts (so I only
> build the patch, I don't check it compiles).
>=20
> You're welcome to the scripts that do this:
>=20
> http://www.kernel.org/pub/linux/kernel/people/jejb/build.pl
>=20
> And the config file that runs it:
>=20
> http://www.kernel.org/pub/linux/kernel/people/jejb/merge-tree-build
>=20
> I don't plan to do much more than keep it building to check conflicts,
> so you're welcome to take it over.

Thanks, they are very useful.

> > I hope to recreate this tree every day automatically.  In order to do
> > this, any tree that has a conflict will be dropped from that days tree.
> > The maintainer will be notified.  I hope to provide some clue as to what
> > the conflict is with, but probably not initially.
>=20
> Actually the experiment with the -mc tree shows that most of the
> conflicts are trivial in nature (usually docbook stuff or
> feature-removal.txt stuff), so you can do a trivial triage by hand.  You
> can't automatically drop them (well, not unless you want to end up
> dropping half the trees).

Well I did a trial run with the 40 git trees in the latest -mm and got
only 6 conflicts (which actually were not trivial, unfortunately).  Of
course, a lot of them have already been pulled into Linus' tree by now.

> The other problem is that we actually maintain deliberate conflicts with
> a last person to merge fixes it type attitude.  Again, it's usually in

I was hoping to be able to automatically find the other tree involved in
a conflict and point both maintainers at the problem.  Also, there is
always the possibility of reordering the trees ;-)

> minor areas, and the fixups are fairly trivial, but it illustrates why
> conflicts can't be a reason to drop a tree, you have to maintain some
> sort of automatic fixup (at least I had to with the -mc tree).  The

OK, maybe if the conflict is trivial, we can do fixups.

> reason we do this is that it would give the maintainers a nasty web of
> included trees (which is almost impossible for the quilt trees anyway)
> if we tried to resolve the conflicts and destroy our ability to rebase.

I am hoping (one of Andrew's bugbears) that over time we will end up with
several branches from git using trees (the vast majority) most of which
are completely contained within their own subsystem and don't depend on
anything but Linus' tree.  The conflicting and dependent branches will be
merged later in the sequence.  Thus we will end up with a large amount of
the tree becoming stable as the merge window approaches.  (Yes, sometimes
I am an optimist :-))

> > I will attempt to build the tree between each merge (and a failed build
> > will again cause the offending tree to be dropped).  These builds will =
be
> > necessarily restricted to probably one architecture/config.  I will bui=
ld
> > the entire tree on as many architectures/configs as seem sensible and
> > the results of that will be available on a web page (to be announced).
>=20
> Yes, this is the bit I've never dared do ... principally because it's
> such a time sink.

I have a couple of lackeys who already do this stuff :-)

Thanks for the comments - I will keep them in mind as I sink into the abyss=
 :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Feb_2008_13_23_06_+1100_LloUtqqId=UH35HX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHsQMOTgG2atn1QN8RAjI4AJ0V2H2msdVLn2EU7Ov2feppg3jihQCgkQlX
6qCkdUr3TqHJiUnvW7aPCrE=
=SmEz
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2008_13_23_06_+1100_LloUtqqId=UH35HX--
