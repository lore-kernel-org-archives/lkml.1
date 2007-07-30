Return-Path: <linux-kernel-owner+w=401wt.eu-S968409AbXG3VYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968409AbXG3VYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 17:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966928AbXG3VYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 17:24:37 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:56349 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966768AbXG3VYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 17:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=Qrs+0KYLQU9OaZQ0Ojtv4ZEB9/K5usMtSnaGnKJrTEq2xds/NA9Oqq5GhNcVbZRHXQteEobKnh+LbbUrLWrZasfYxY4B4eWvnketsrYq+IBewcvpnfKCkER/YCXgqJYpqqn7stdnSG+0NCaRRebuSHYE4PdrbZ85u9teRSM2ehY=
Message-ID: <46AE570B.3050802@gmail.com>
Date: Mon, 30 Jul 2007 17:24:27 -0400
From: Kenneth Prugh <ken69267@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: John <darknessenvelops@gmail.com>, ck@vds.kolivas.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185536610.502.8.camel@localhost> <20070729170641.GA26220@elte.hu> <930f95dc0707291154j102494d9m58f4cc452c7ff17c@mail.gmail.com> <20070729204716.GB1578@elte.hu> <930f95dc0707291431j4e50214di3c01cd44b5597502@mail.gmail.com> <20070730114649.GB19186@elte.hu> <46AE25F3.7020904@gmail.com> <20070730191029.GA29327@elte.hu>
In-Reply-To: <20070730191029.GA29327@elte.hu>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig42DDD0AB56AFD57E100CAAB0"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig42DDD0AB56AFD57E100CAAB0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Kenneth Prugh <ken69267@gmail.com> wrote:
>=20
>> Ingo Molnar wrote:
>>> <large snip>
>> Hello, I have a gaming rig and would love to help benchmark with my=20
>> copy of UT2004(E6600 Core2 and a 7950GTO card). Or if you have=20
>> anything else that would better serve as a benchmark I could grab it=20
>> and try.
>>
>> The only problem is I don't know what 2 kernels I should be using to=20
>> test the schedulers. I assume 2.6.23-rc1 for CFS, but what about SD?
>=20
> .22-ck1 includes it, so that should be fine:
>=20
>  http://ussg.iu.edu/hypermail/linux/kernel/0707.1/0318.html
>=20
> 	Ingo
>=20

Alright, Just got done with some testing of UT2004 between 2.6.23-rc1
CFS and 2.6.22-ck1 SD. This series of tests was run by spawning in a map
while not moving at all and always facing the same direction, while
slowing increasing the number of loops.

CFS generally seemed a lot smoother as the load increased, while SD
broke down to a highly unstable fps count that fluctuated massively
around the third loop. Seems like I will stick to CFS for gaming now.

Below you will find the results of my test with the average number of FPS=
=2E

		CFS		|		SD
UT2004 + 0 loops | 200 FPS		UT2004 + 0 loops | 190 FPS
UT2004 + 1 loops | 195 FPS		UT2004 + 1 loops | 190 FPS
UT2004 + 2 loops | 190 FPS		UT2004 + 2 loops | 190 FPS
UT2004 + 3 loops | 189 FPS		UT2004 + 3 loops | 136 FPS
UT2004 + 4 loops | 150 FPS		UT2004 + 4 loops | 137 FPS
UT2004 + 5 loops | 145 FPS		UT2004 + 5 loops | 136 FPS
UT2004 + 6 loops | 145 FPS		UT2004 + 6 loops | 105 FPS
UT2004 + 7 loops | 118 FPS		UT2004 + 7 loops | 104 FPS
UT2004 + 8 loops | 97 FPS		UT2004 + 8 loops | 104 FPS
UT2004 + 9 loops | 94 FPS		UT2004 + 9 loops | 89 FPS
UT2004 + 10 loops | 92 FPS		UT2004 + 10 loops | 91 FPS

--=20
Kenneth Prugh


--------------enig42DDD0AB56AFD57E100CAAB0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGrlcQ0PM4px2/kjgRAiYJAJ0c72onj6fVfGQXar2zeyQ/+SbZhQCdGE1I
fcwlppIzcldrF8JtuyLr0J8=
=U5zV
-----END PGP SIGNATURE-----

--------------enig42DDD0AB56AFD57E100CAAB0--
