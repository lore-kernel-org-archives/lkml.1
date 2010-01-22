Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602Ab0AVAR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab0AVAR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343Ab0AVAR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:17:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36541 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752864Ab0AVAR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:17:56 -0500
Date: Fri, 22 Jan 2010 11:17:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-Id: <20100122111747.3c224dfd.sfr@canb.auug.org.au>
In-Reply-To: <20100121013822.28781960.sfr@canb.auug.org.au>
References: <20100119211646.GF16096@redhat.com>
	<20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	<20100120054950.GB27108@elte.hu>
	<20100120061551.GB6588@in.ibm.com>
	<20100120062834.GB12165@elte.hu>
	<20100120072925.GA11395@elte.hu>
	<20100121013822.28781960.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__22_Jan_2010_11_17_47_+1100_OuUWTd46+v1b+LRx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Jan_2010_11_17_47_+1100_OuUWTd46+v1b+LRx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo, Andrew,

Any thoughts?

On Thu, 21 Jan 2010 01:38:22 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Wed, 20 Jan 2010 08:29:25 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> >
> >=20
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >=20
> > >=20
> > > * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> > >=20
> > > > On Wed, Jan 20, 2010 at 06:49:50AM +0100, Ingo Molnar wrote:
> > > >=20
> > > > Ingo,
> > > >=20
> > > > > Note, i'm not yet convinced that this (and the rest: uprobes and =
systemtap,=20
> > > > > etc.) can go uptream in its present form.
> > > >=20
> > > > Agreed, uprobes is still not upstream ready -- it was an RFC. We are
> > > > working through the comments there to get it ready for merger.
> > > >=20
> > > > > IMHO the far more important thing to address beyond formalities a=
nd workflow=20
> > > > > cleanliness are the (many) technical observations and objections =
offered by=20
> > > > > Peter Zijstra on lkml. Not just the git history but also the abst=
ractions and=20
> > > > > concepts are messy and should be reworked IMO, and also good and =
working perf=20
> > > > > events integration should be achieved, etc.
> > > >=20
> > > > I think Oleg addressed most of Peter's concerns on utrace when the=
=20
> > > > ptrace/utrace patchset was reposted.
> > >=20
> > > Peter is Cc:-ed and he might want to chime in.
> > >=20
> > > > Perf integration with uprobes will be done and discussions have sta=
rted with=20
> > > > Masami and Frederic. There are a couple of fundamental technical as=
pects=20
> > > > (XOL vma vs. emulation; breakpoint insertion through CoW and not th=
rough=20
> > > > quiesce) that need resolution.
> > > >=20
> > > > > The fact that there's a well established upstream workflow for in=
strumentation=20
> > > > > patches, which is being routed around by the utrace/uprobes/syste=
mtap code=20
> > > > > here is not a good sign in terms of reaching a good upstream solu=
tion. Lets=20
> > > > > hope it works out well though.
> > > >=20
> > > > Agreed.
> > > >=20
> > > > On the other hand, having ptrace/utrace in the -next tree will give=
 it a
> > > > lot more testing, while any outstanding technical issues are being =
addressed.
> > >=20
> > > Including experimental code that is RFC and which is not certain to g=
o=20
> > > upstream is certainly not the purpose of linux-next though.
> > >=20
> > > It will cause conflicts with various other trees and increases the ov=
erhead=20
> > > all around. It also causes us to trust linux-next bugreports less - a=
s it's=20
> > > not the 'next Linux' anymore. Also, there's virtually no high-level=20
> > > technical review done in linux-next: the trees are implicitly trusted=
=20
> > > (because they are pushed by maintainers), bugs and conflicts are repo=
rted=20
> > > but otherwise it's a neutral tree that includes pretty much any commi=
t=20
> > > indiscriminately.
> > >=20
> > > If you need review and testing there's a number of trees you can get=
=20
> > > inclusion into.
> >=20
> > Btw., the utrace code has lived in -mm for quite some time - that's an=
=20
> > excellent route as Andrew does thorough review and testing.
> >=20
> > If Andrew agrees with this particular tree as-is and wants these bits t=
o live=20
> > in linux-next and have it in -mm that way then that's a fair approach=20
> > obviously and i have no objections ...
>=20
> So, what is it to be?  In or out?
>=20
> Frank, please be clear as to which branch you want included (master or
> utrace-ptrace).  Also note that neither of those branches matches what
> was posted in the sense that they both have lots of history and merges
> not represented in the patches.  (I assume that they do produce the same
> final source tree, though).
>=20
> > The point is to have at least one relevant maintainer request and track=
 it and=20
> > then supervise the completion of it (which includes the resolution of a=
ll=20
> > outstanding objections) and then push it to Linus.
>=20
> If we do include it, it is still possible for people to decide (when the
> next merge window opens) that it is still not ready.  It adds a bit of
> maybe unneeded complication to linux-next, but we had the same problem in
> this merge window and we have all survived.  :-)
>=20
> In the end, Linus is the final arbitrator of course.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__22_Jan_2010_11_17_47_+1100_OuUWTd46+v1b+LRx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktY7qsACgkQjjKRsyhoI8zGdwCfR/rtQ92g1m0VuVxoMlLQ/fPu
BpQAoJ9SICGKdTYDCbPXP6T9nZiPli6q
=Egii
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Jan_2010_11_17_47_+1100_OuUWTd46+v1b+LRx--
