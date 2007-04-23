Return-Path: <linux-kernel-owner+w=401wt.eu-S1030307AbXDWX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307AbXDWX4Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030342AbXDWX4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:56:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44881 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030307AbXDWX4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:56:15 -0400
X-Sasl-enc: jM4gQ9pAiZrJJWiOxGmcbhPhVjQ/oMqKvbnRVVLLjy2J 1177372574
Message-ID: <462D483D.7080503@imap.cc>
Date: Tue, 24 Apr 2007 01:58:53 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       kkeil@suse.de, i4ldeveloper@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
References: <20070115172912.GA3323@pingi.kke.suse.de>	<462A0CA7.2090908@imap.cc>	<20070421215844.542d3aab@the-village.bc.nu>	<20070421.151052.78709111.davem@davemloft.net>	<462B54A0.9000203@imap.cc>	<20070422135835.037e323c@the-village.bc.nu>	<462B712D.7070504@imap.cc>	<20070422161708.54253ab7@the-village.bc.nu>	<a781481a0704220848t16cc8ed2l3cb5ee52d9b405e1@mail.gmail.com> <20070422172017.52f21a90@the-village.bc.nu>
In-Reply-To: <20070422172017.52f21a90@the-village.bc.nu>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC74C44F5898A3D2EAFDF230C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC74C44F5898A3D2EAFDF230C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 22.04.2007 17:17 schrieb Alan Cox:
> Well once it ends up && BROKEN perhaps patches will appear, or before
> that. If not well the pain factor will resolve the problem.
>
>>> No risk of deadlock. It'll progress to && BROKEN which will either ca=
use
>>> sufficient pain for someone to get off their arse and fix it, for eno=
ugh
>>> of a vendors users to get the vendor to do the work or for someone wh=
o
>>> cares to pay a third party to do the work.
>>
>> Do I sense some hidden agenda there?
>=20
> No I'm speaking from experience - if a subsystem maintainer is too
> busy/working on other projects and the subsystem stops working it
> produces a rapid and sudden supply of new maintainers, unless nobody
> cares in which case it can go in the bitbucket.
>=20
>> > The isdn4linux subsystem will not "progress" to BROKEN unless
>> > somebody pushes it there.=20
>=20
> It has drivers using functions that will soon be deleted. That isn't so=

> much as pushing more like getting fed up of pulling someone elses cart
> along.

Do I understand you correctly? You deliberately want to move it
to BROKEN to cause pain in the hope of forcing somebody other than
"the person who did the kernel change in the first place" (quote
stable_api_nonsense.txt) to do the fixing up?

Am 22.04.2007 18:20 schrieb Alan Cox:
>> Why, or
>> rather how, were the writers of newer APIs _allowed_ to push *their*
>> stuff into the kernel _without_ even bothering to convert the
>> *existing* users of the older APIs in the kernel? This goes against
>=20
> Because to convert the existing ISDN4Linux heap into the new APIs would=

> require someone with all the cards involved and a lot of time (as the
> card drivers need a *lot* of work by now to bring them up to todays wor=
k)

Not true. None of the past kernel API changes were done by someone
who had all the hardware for the affected drivers. I have personally
acked changes to the driver I maintain from people who don't have
the hardware, and the changes were fine. The one inventing a new
kernel API to replace an old one is in the best position for actually
replacing it in the existing users of the old API, and that's also
what stable_api_nonsense.txt stipulates.

> "Precedent", that implies it is a new behaviour - which it isn't. We
> regularly break old driver code when it is neccessary in order to make
> general progress. Grep for "BROKEN" in the kernel tree.

I did grep for "BROKEN" in the 2.6.21-rc7 sources and couldn't find
an instance of a driver that was still in active use being broken in
order to make general progress. OTOH I remember several cases of
drivers being kept alive even though they were in the way of
progress, because there were still users relying on them.

> You, and anyone else who wants to, are free to work on I4L and fix it,
> improve it and make it better.=20

You are turning the situation on its head. I4L works. Somebody wants
to push through a kernel API change that would break it. In every
other case I know, it was the responsibility of those doing the
kernel API change to fix the in-tree users of that API. As long as
they didn't finish that job, the old API would stay. Nobody advocates
moving reiserfs to BROKEN for still using lock_kernel(), to cite a
recent issue. So why isdn4linux?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- Undetected errors are handled as if no error occurred. (IBM) -


--------------enigC74C44F5898A3D2EAFDF230C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGLUg9MdB4Whm86/kRAuHIAJ0fGhC6ymA7G1EApjU4FY1PYED+ogCfaYvi
v4sLoBEDc+f20eDhtaQgVIg=
=sdwT
-----END PGP SIGNATURE-----

--------------enigC74C44F5898A3D2EAFDF230C--
