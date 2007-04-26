Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbXDZVMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbXDZVMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbXDZVMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:12:43 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46024 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXDZVMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:12:42 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Theodore Tso <tytso@mit.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>, Johannes Berg <johannes@sipsolutions.net>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070426210631.GD24852@thunk.org>
References: <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <1177582633.6814.29.camel@johannes.berg>
	 <20070426103051.GP17387@elf.ucw.cz> <20070426104052.GA19072@elf.ucw.cz>
	 <1177585897.6814.49.camel@johannes.berg>
	 <20070426111645.GR17387@elf.ucw.cz>
	 <1177586850.6814.52.camel@johannes.berg>
	 <20070426112641.GS17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704260855380.9964@woody.linux-foundation.org>
	 <20070426210631.GD24852@thunk.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-31LHRbIT0seAedDODMV/"
Date: Fri, 27 Apr 2007 07:12:39 +1000
Message-Id: <1177621960.4737.66.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-31LHRbIT0seAedDODMV/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 17:06 -0400, Theodore Tso wrote:
> On Thu, Apr 26, 2007 at 08:56:48AM -0700, Linus Torvalds wrote:
> >=20
> >=20
> > On Thu, 26 Apr 2007, Pavel Machek wrote:
> > >=20
> > > Yes, probably will. The other option is to break existing 32-bit
> > > userspace, which is a bit more common AFAICT.
> >=20
> > And *this* is why kernel/userspace things simply should not be done.
> >=20
> > It's simply better to do things entirely in the kernel. Because you add=
=20
> > bugs and complications otherwise, and doing it in the kernel allows you=
=20
> > to just switch things around.
> >=20
> > As it is, it appears that user-space suspend is just broken whichever w=
ay=20
> > we turn.
>=20
> Well, in that case maybe suspend2 should be very seriously considered,
> since it has the features of uswsusp --- basic features which every
> single Microsoft and MacOSX user are used to like, like progress bars
> --- and it's all done in the kernel.

Umm. I don't want to be picky, but that's not quite true. The progress
bar is done in userspace.

There's also the possibility of using a userspace app to manage storage
too (I did work on establishing/tearing down an NBD connection as
necessary but didn't quite get it finished and have never released it).
That said, this bit can be torn out by simply removing a file and the
Makefile line.

Nigel

--=-31LHRbIT0seAedDODMV/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMRXHN0y+n1M3mo0RAucMAKCTKhHUjoeRacKeTrPoiSME60N/EQCgxxQp
drtwISKbP17za4OGJtjDeL4=
=64Z5
-----END PGP SIGNATURE-----

--=-31LHRbIT0seAedDODMV/--

