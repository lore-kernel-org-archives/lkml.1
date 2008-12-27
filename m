Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYL0TVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYL0TVX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 14:21:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYL0TVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 14:21:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56471 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416AbYL0TVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 14:21:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 14:21:07 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227191223.GA10592@uranus.ravnborg.org> <49567EB5.5030409@zytor.com>
In-Reply-To: <49567EB5.5030409@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1412066.uRl02uAOjA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812271421.10087.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1412066.uRl02uAOjA
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 14:15:01 H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> > On Sat, Dec 27, 2008 at 10:58:11AM -0800, H. Peter Anvin wrote:
> >> Sam Ravnborg wrote:
> >>> I wnet with the scripted conversion for now.
> >>> If that does not fly we can come back to this proposal.
> >>>
> >>> What I like most with the auto conversion is that we avoid
> >>> adding yet another special rule about how to do stuff in exported
> >>> headers.
> >>
> >> Indeed, and being keyword conversion, it's independent of context, at
> >> least as long as one doesn't have too many run-ins with weird uses of
> >> the # and ## preprocessor operators, which are a *lot* easier to rule
> >> out globally.
> >
> > Speaking of what we want to use in exported headers.
> > What is the recommendation with respect to uint32_t and friends?
> > To my best knowledge they are banned in exported headers as they
> > are not part of the kernel namespace and I see few users too.
> > But is this something we should check for?
>
> I personally would not be upset if we auto-changed {su}{8,16,32,64},
> [u]int_{8,16,32,64}_t

{su}{8,16,32,64} doesnt matter too much to me vs {u,}int_t{8,16,32,64}_t.  =
as=20
long as people stop using __{su}{8,16,32,64}.  using the latter though does=
=20
mean headers will more likely be "just usable" w/out needing linux/types.h=
=20
include.  but then people would be forced to include stdint.h or similar=20
before a linux header ... and that sucks.

unless of course we start adding appropriate C library includes for=20
!__KERNEL__ ... i'd love that personally

> and bool into the appropriate __{su}{8,16,32,64}
> types and _Bool.

i dont get your bool comment.  the "bool" type is already a standard type. =
=20
there is no conversion needed.
=2Dmike

--nextPart1412066.uRl02uAOjA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVoAlAAoJEEFjO5/oN/WB/hAQAIf/Rqrpji7OkZakUjHLkuIB
fKxJcxh4TA7CNIrzqCw66sanI/ZiJt6KSLHZAtjHFtb3lxXGR88WJdC2DHfUnQzw
2c8db1PzyGYMgOyRKiZDhjREbKOg1yUvVbWCQ/1HwaX5yMjEz83LpVr7YPe2Nu6L
qrfXICzIrVlWjwnUqazbZ5N0DQMFuwLXk+kj3rGMuUQAGFYpbS1rEjij9NJ7dB/+
Jjcb9jwn2aPDWsvITeBtJh4uP3n6F1Raz+/uRExcVGZKoav8hj0qxA5Tfn/mDalV
AXTIOZqi04HopzsVH5H7BesxZahSw3paKxNdFhEP6t9dfEtKuCe/KR8vKhCnrwhx
iTstq/SIfL9vZ4gkUnKOj3Jqplh81bw077AyTyemI+3mwY4J8UsNNBX0X7czA8KX
0cd8RKssedHv26Pip6MV2vqKH7YNfpdappyKG8FRnIX1bgML0C3jC+PkaESu3ARK
uUCMsApn6nawLe4G0eWaOHHPJ1mkXGqYnyFBvv/Ij4nV3QkpNINWXpOElD+EPt4A
cT8VwGTBu1a8LpXejwiZA/C5oNxyUEtYSBP9Ezx8xU4XRwqG0eNNoCF/Et2GkVUS
sQg3g72EJpbd0uNWwgJ8TJy1694v7JvcYF5tPXgHnR2IzyotXAxHqrUwb+PHzsFv
ucXkIdA+r0pDXdzf2PPg
=MKgJ
-----END PGP SIGNATURE-----

--nextPart1412066.uRl02uAOjA--
