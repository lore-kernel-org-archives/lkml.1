Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXEaHnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXEaHnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbXEaHnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:43:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53762 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbXEaHnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:43:08 -0400
Subject: Re: [PATCH} x86_64 PM_TRACE support.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Jones <davej@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       Julian Sikorski <belegdol@gmail.com>, Andi Kleen <ak@suse.de>
In-Reply-To: <20070530170921.e793a34f.randy.dunlap@oracle.com>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
	 <20070531000133.GE2794@redhat.com>
	 <20070530170921.e793a34f.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6EK22YvVV0FH6PHIJq1s"
Date: Thu, 31 May 2007 17:43:06 +1000
Message-Id: <1180597386.6777.59.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6EK22YvVV0FH6PHIJq1s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-05-30 at 17:09 -0700, Randy Dunlap wrote:
> > On Sat, May 26, 2007 at 04:32:54PM +1000, Nigel Cunningham wrote:
> >=20
> > Hi Nigel,
> >=20
> >  > As promised I took another look at the patch and at what Randy had
> >  > prepared to fix the IA64 compilation error. I did some more work on =
it,
> >  > and believe that the following is the tidiest correct solution I can
> >  > come up with. It differs from the version that caused the compilatio=
n
> >  > error primarily in that:
> >  >=20
> >  > * the #include <asm/resume-trace.h> is inside the #ifdef=20
> >  >   CONFIG_PM_TRACE.
> >  > * now-unnecessary protection for multiple #includes and ifdef testin=
g of
> >  >   CONFIG_PM_TRACE in the asm code were removed.
> >  > * do-nothing definitions for !PM_TRACE restored to
> >  >   include/linux/resume-trace.h.
> >  >=20
> >  > We're therefore depending upon kernel/power/Kconfig having the right
> >  > depends condition. As far as I can see, IA64 doesn't define CONFIG_X=
86.
> >  > Is that correct, or do we need to have (X86 && !IA64)?
> >=20
> > Can you post a copy of this that isn't mangled by quoted-printable enco=
ding?
> > Whilst it looks fine in my MUA, the diff ends up looking like..
>=20
> yep :(
>=20
> http://www.xenotime.net/linux/patches/x8664-pm-trace-support.patch
>=20
> in case Nigel is asleep.

Thanks Randy. I wasn't asleep, but was out for most of the day.

> > I'm beginning to think we really need a Documentation/Unhorking-MUAs-HO=
WTO
> > judging by the amount of broken encodings we seem to get to lkml these =
days.

That would be good. I just took a look through evo's settings, but can't
find whatever option is set wrong. I think it's devolved on me :\.

Regards,

Nigel

--=-6EK22YvVV0FH6PHIJq1s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXnyKN0y+n1M3mo0RApxCAJwN0colC2ZsQ+WP/jT1dtTmpsYerQCgspgH
kf3ID/EbtYoQ81S2rkxbP8g=
=ozhJ
-----END PGP SIGNATURE-----

--=-6EK22YvVV0FH6PHIJq1s--

