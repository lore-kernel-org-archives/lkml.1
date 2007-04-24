Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXDXEDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXDXEDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 00:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDXEDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 00:03:05 -0400
Received: from mse2fe1.mse2.exchange.ms ([69.25.50.163]:16276 "EHLO
	mse2fe1.mse2.exchange.ms" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbXDXEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 00:03:04 -0400
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
	(Dave: How do FreeBSD folks maintain the KGDB stub?)
From: Piet Delaney <pdelaney@bluelane.com>
Reply-To: pdelaney@bluelane.com
To: Andi Kleen <ak@suse.de>, "David O'Brien" <obrien@freebsd.org>
Cc: pdelaney@bluelane.com, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Piet Delaney <piet@bluelane.com>, Tom Rini <trini@kernel.crashing.org>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@freebsd.org>
In-Reply-To: <200704211148.09525.ak@suse.de>
References: <20070307204516.GA24095@blade.az.mvista.com>
	 <1177109495.9479.81.camel@piet2.bluelane.com>
	 <20070420163450.d8c8b3b7.akpm@linux-foundation.org>
	 <200704211148.09525.ak@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8BlH+x+YL2MxSmlcly29"
Organization: Blue Lane Technologies
Date: Mon, 23 Apr 2007 21:02:56 -0700
Message-Id: <1177387377.9479.175.camel@piet2.bluelane.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4-3mdk 
X-OriginalArrivalTime: 24 Apr 2007 04:03:01.0773 (UTC) FILETIME=[73C7BBD0:01C78625]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8BlH+x+YL2MxSmlcly29
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-04-21 at 11:48 +0200, Andi Kleen wrote:
> > Lots of people want kgdb.  One person is famously less keen on it, but
> > we'll be able to talk him around, as long as the patches aren't daft.
>=20
> The big question is if the kgdb developers seriously want mainline.
> At least in the past this definitely wasn't the case.

I haven't seen any email from kgdb developers saying they didn't want
kgdb to be part of mainline.=20

Happen to have any e-mail demonstrating that?=20

It's appears to me that:

	1. Jason Wessel is putting a lot of effort at that right now.

        2. Tom Rini worked hard at this just a few months ago.

        3. George Anzinger was working hard at this a year or two
           with the mm series and as likely disappointed when it wasn't
           put into the mainline. As I recall the reason Linus gave
           was that there were two competing patches and he wanted that
           be resolved before integrating it into the mainline. So
           George worked with Amit at SourceForge over that past year
           or two and it's now integrated.

>=20
> If they're not open to change requests from mainline reviewers we don't
> even need to bother to start the whole exercise.

What issue are there of have been that your referring to?

Once KGDB is part of KORG can't it's maintenance and support be
a kernel wide responsibility. If someone breaks kgdb shouldn't
that be backed out until the KORG developers fixes the problem?
Centralizing the responsibility for KGDB seems like mistake. I=20
doubt the FreeBSD folks rip out the KGDB support of a kernel hacker
breaks KGDB and then leaves a group of KGDB developers to sort out
the problem. Seems it should be cough as a mm patch with Andrew tossing
out the patch if it breaks KGDB. Kgdb developers could try to give
Andrew a heads up if this occurs and he didn't notice it.

Once KGDB is integrated the maintenance should be minimal and changes
that break KGDB are likely best addressed by the developer that just
broke it. At least that what I'd think is an optimal approach. Perhaps
Dave O'Brien could tell us how the FreeBSD folks take care for KGDB.

>=20
> Just putting their stuff onto korg isn't enough.

Yep, and once it's integrated into korg it should finally become
a permanent part of the kernel and I suspect maintained by all
kernel developers. New KGDB features could be developed at SourceForge
but maintaining kernel coherence seems like a global responsibility.
Like running fault injection on your code before checking it in.

Maybe I'm totally out to lunch on this; perhaps Dave O'Brien
can straighten me our if I'm wrong or the Linux kernel core
responsibility paradigm are incompatible with this.

I'd prefer Linux being just as good as NetBSD with Debugging support;=20
current presentations like:

	http://foss.in/2005/slides/netbsd-linux.pdf

show our current support as being much worse. Let's fix it.

You developed a kgdb proxy for Keith Owens kdb and I suspect you
would like to have KGDB being part of the kernel mainline as
long as it's done well. I doubt anyone would argue with that.
=20
Perhaps it's possible to eventually setup KGDB so it can be=20
debugged with kdb. Once KGDB is mainline that are plenty of
issues that can be addressed; for example taking a kernel
core dump after dropping into kgdb and having the registers
show up correctly in Dave Anderson's crash utility.

-piet

>=20
> -Andi
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-8BlH+x+YL2MxSmlcly29
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBGLYFwJICwm/rv3hoRAp+WAJ9Rk6E/nX2LhzTNegg6igMvIoLieQCfTGHz
TDmHlug7bh16ShrCV3JLmTs=
=o+yI
-----END PGP SIGNATURE-----

--=-8BlH+x+YL2MxSmlcly29--

