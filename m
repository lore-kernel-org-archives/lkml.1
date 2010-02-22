Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0BVIkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 03:40:15 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:38492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab0BVIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 03:40:14 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002220019h32ed0ec3i9d5fa4080a2ca335@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
	 <1266747440.5468.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002220019h32ed0ec3i9d5fa4080a2ca335@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qFqmdDI5eUSWLbB5LlLw"
Date: Mon, 22 Feb 2010 09:39:28 +0100
Message-ID: <1266827968.5154.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qFqmdDI5eUSWLbB5LlLw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-22 at 16:19 +0800, Am=C3=A9rico Wang wrote:

> >> Could you test the patch below? Thanks!
> >
> > No change, sorry, still hangs right after "Disabling non-boot CPUs
> ..."
> > before the machine turns off.
> >
>=20
> Oh, I see, then this will be another problem.
>=20
> My previous patch is to fix the cpufreq lockdep warning mentioned
> in Benjamin's report, so this hang should be caused by other problem,
> not the cpufreq lockdep problem.

Right, sounds like -- and I haven't seen that lockdep report during
shutdown any more.

johannes

--=-qFqmdDI5eUSWLbB5LlLw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgkK9AAoJEODzc/N7+QmaAsYP/RKQ0NXtSLFYC2aQNEGbSPX3
7Gq3n2H5CEcLdWPcehBByoqhImE+UAvnsmEtLmoX9ABCmXxlpDDWZVeKIrk7KigU
NQgOnbYexOziXOmIMcvySYOsoI2XmrXZfZCERvxnHJumhqez4/LkQiDybXtPVqZP
w2LBxE+zdCTryhle0E++yQWZl1Jky25vwZNYv/uOeU8TuOTb6zUjdsBUgfN3gYD/
AF8GYSKCpifxAu7MUsqOe4xXdGHUcDp5+yRJ3WHn4nyohpejkKLVctd4i5O7AyXq
YNtggiD6ciYFWP2XjmdeAe68pxQWTDZ4NWNxu8iZmxU1Kcq7sTwZZ/svX829Zqfd
HZSOIslwglUEt5bo0eir/prrLGQ7apd42cCum3uMVKn5lAFzoXqYna3TRW2cjkVm
PH52W5KCmDVkW7iUfTlj/JAuzCw1IC+UYWaGIyV3aP1O7wQmOGIM/j1fO30qUQTZ
p+0K7+CquuzJ5EDAjxq4XcCfdIm9x4mpEVUsUA9QYtJVmH3k/SuND5VvbBLfFME+
cduTOtR9u16FLY/zuAJnAa2vylMRPvUUpvzodPq/gSAkFZaj25crwimVwujYH72q
ZpO7ffqGR5919GJaqc0m1y67K7dTDW2IlmEFxDOOMg4vor9LW280LpcC+BNYpIrc
YoMvnEuRH0taoshOOZSM
=3YRx
-----END PGP SIGNATURE-----

--=-qFqmdDI5eUSWLbB5LlLw--

