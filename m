Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbZEKSXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbZEKSXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZEKSXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:23:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51300 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZEKSW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:22:59 -0400
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
In-Reply-To: <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>
	 <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-43F+4Sjr8Wyi/viTfxoD"
Date: Mon, 11 May 2009 20:22:50 +0200
Message-Id: <1242066170.3873.43.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-43F+4Sjr8Wyi/viTfxoD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 10:57 -0700, Linus Torvalds wrote:

> Ok, it's -rc5, and apparently nothing has happened about this problem.=20
> Johannes has just been stone-walling and ignoring the reports, and=20
> claiming it's fixed when it clearly wasn't.=20

?
I always only said it was fixed in wireless-testing and that the fix was
on the way upstream. I have no influence over more. And I worked with
Parag in the bugzilla bug to fix the other bug he was seeing on
wireless-testing-based wireless code up to where he could no longer
reproduce the issue.

> I just verified on one of my older machines (running current fedora-11,=20
> with a 4965AGN rev=3D0x4) that the problem is real, and that reverting th=
at=20
> commit does indeed seem to fix it.

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3Dc428c89201a57a0ce24c37ed79e540d1f4101cf3

What does "older" mean here, and what kernel were you using?

> So here goes: I'm going to revert that commit today or tomorrow, unless=20
> somebody sends me a fix that I can verify. I don't want any more excuses,=
=20
> I don't want to hear developers dismissing bug-reports, and I _can_ verif=
y=20
> this problem myself.
>=20
> We do not fix bugs by introducing new regressions and then ignoring the=20
> reports. Especially since the bug that the commit in question fixes seems=
=20
> to be _way_ less important than the bug it then introduces.

I never ignored the reports. I was a little mad at Parag because he was
reporting a bug that I had just fixed, and he had even seen the original
report. It turned out it wasn't his fault that he couldn't find the fix
from the original thread, and I suppose I could have handled the
duplicate report better even if Parag had known about the fix. I'm sorry
about that.

If you revert that commit (from subject), you're going to make it
default to transmit power -1 dBm if commit c428c892 is in your tree as
well. I have to wonder whether your testing included that commit,
because if reverting 47afbaf5 helped I would think it did not.

=46rom my perspective the bug is dealt with since commit c428c892, if you
want to revert anything please revert _both_ c428c892 and 47afbaf5.

johannes


--=-43F+4Sjr8Wyi/viTfxoD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCGzzAAoJEODzc/N7+QmaCo4QAMPxqEhkaeZ5cggjmnFzehFy
F8SJHjjxTMJLIzm2MGs6jsmopudN4dv4xWLEvxYV2YhfQJVbqzQN53uj5XbvHXhV
a+VT3BI/uiSViH3XHcrz94N66a3/DD1/8Djpwd3NFOxPb7nlKS5HLsiq/QIvZJS2
RSL+YaZpyFlXLRMLM+JbyuB5lLq/SERmJWMvDtTWwMMHH9cvozk3yoL1zbhvn/lP
9NOwv+EaVVly7irjDthKQaPI6UVPhWWUaB2TX3syQ/emx5N5TXVkYXr+K4GV1qa6
83Dv2SnvrlHl7qW6FppPwBdArkBCHhQDkjzZryaduOhRWSa7XipstF9ifGolJDwj
kmpxZQUOljgtD+wRwGhYENxYQGoQH7/4WcsIU6jxzztvQpMs0syCODfnh7aCH83B
pkPkPjnXG9dzoWf3U3gbqERJ5bI5sXrxp3Fpj3A4RYMCQ2tzUCyTk5lolQWbd5OH
OyLJ1OsVtuP67zxjmgAziLRIilEM9Xm4kseFyohQPKPda/+5AW2f6UaIn67rkmLk
fMJfEX7E+lj3WI8zFpt8yAg6XSr/JzByO9NDU/XH9ND/NEQDVX1x7ZgSg4GsDHVZ
RS9NHL9M7jubCyAS0gQXcITomcyFArvQkDzxos9yp7YI1UfwOEk03ndIcVXezJYR
oQKx97VKK0S4+8+VN0zg
=wuWR
-----END PGP SIGNATURE-----

--=-43F+4Sjr8Wyi/viTfxoD--

