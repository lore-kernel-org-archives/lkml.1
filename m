Return-Path: <linux-kernel-owner+w=401wt.eu-S1763382AbXEZRiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763382AbXEZRiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 13:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756883AbXEZRiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 13:38:12 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:1180 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbXEZRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 13:38:10 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: suspend2-devel@lists.suspend2.net
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy)
Date: Sat, 26 May 2007 19:37:57 +0200
User-Agent: KMail/1.9.7
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <200704182245.24156.mail@earthworm.de> <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org> <20070425072350.GA6866@ucw.cz> (sfid-20070425_120821_912508_DB49EB08) (sfid-20070425_120821_912508_DB49EB08)
In-Reply-To: <20070425072350.GA6866@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5623918.ij7IiMHNTh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705261938.03911.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5623918.ij7IiMHNTh
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 25 April 2007 schrieb Pavel Machek:
> Hi!
>
> > This is why there's a lot to be said for
> >
> > 	echo mem > /sys/power/state
> >
> > and being able to follow the path through _one_ object (the kernel)
> > over trying to figure out the interaction between many different
> > parts with different versions.
>
> The 'promise' is 'if you can get echo disk > /sys/power/state working,
> uswsusp will work. too'. IOW it should be ok to debug the in-kernel
> parts, only.

Hello Nigel, Pavel, Rafael and everyone else who is involved,

I would like to ask what come out of the suspend2 merge discussion. Nigel=20
just told that suspend2 likely won't be merged anytime soon and thats its=20
business as usual:

=2D--------------------------------------------------------------------
It's pretty much business as usual. Linus doesn't want another
implementation merged, and he wants the three of us (Pavel, Rafael and
myself) to agree on a way forward. He also believes that we're
approaching things from the wrong direction at the moment. Funnily
enough, this is the one area on which we do all agree.
=2D--------------------------------------------------------------------
http://lists.suspend2.net/lurker/message/20070510.021641.fe306add.en.html


Has there been any further discussion and preferably agreement on the way=20
to go forward?

Although you Linus, as I read from different mails only use suspend to=20
RAM, there are many users out there who use suspend to disk daily.=20

I used in kernel software suspend initially and it worked quite nice with=20
starting from 2.6.10 or 2.6.11 where suspend2 didn't work for me before=20
2.6.14 with the hibernate script. But from then on suspend2 worked better=20
than in kernel software suspend for me and colleagues on:

=2D ThinkPad T23
=2D ThinkPad T42
=2D Possibly some other ThinkPads
=2D as well various Dell workstations we have at work

It was faster and more reliable, yielding uptimes up to 40 days on my=20
workstation recently (with 2.6.17.7 still). And even that uptime was only=20
ended by booting a newly build kernel (2.6.21 with sws 2.2.9.13). For me=20
in the role of a user actually this is a really satisfying solution!

I tried userspace software suspend from time to time but then just was fed=
=20
up with it, cause I could not get it to work within any sensible amount=20
of time - even with some bog standard Debian kernel, I think it was some=20
2.6.18 one. Maybe I am dumb, but so be it, it should not be that=20
complicated to get it to work. Recently I didn't even bother to try=20
anymore. Well and I read in the suspend2 merge discussion that even in=20
kernel suspend does not work reliably anymore.

As long I cannot be convinced that the vanilla kernel contains a suspend=20
to disk solution that works as good as suspend2 I will patch suspend2=20
into all of the desktop kernels I build.

Thats quite bad IMHO for exactly the same reason than having drivers=20
maintained out of the kernel. For the same reason I think swap prefetch=20
should go in as soon as possible. It will never have the adoption and=20
care taking of an in-kernel-tree solution.

I am convinced that a working suspend to RAM just is not enough - well it=20
wasn't working correctly last time I checked. But I even don't bother=20
about suspend to RAM anymore. I can wait those additional seconds for=20
suspend to disk and it allows me to drive my laptops without batteries=20
most of the time and have workstations switched off completely so that=20
they do not consume standby power.

So please, pretty please consider working together on a reliable, fast,=20
stable, easy to use and configurable in-kernel-tree snapshot solution!=20
Actually I as a user I couldn't care less about the implementation=20
details, but as someone who is interested in kernel technologies I like=20
it to be a clean and well designed solution, too. ;-)

Maybe when the Linux Foundation organizes a meeting for Nigel, Pavel,=20
Rafael and other kernel developers interested in creating such a solution=20
it will help. To me it seems such a concentrated meeting in a good=20
atmosphere could be more effective than endless mailing list discussions=20
not leading to a clear result. When its not easy for the involved people=20
to work together maybe a casual bystander who understands enough of=20
kernel details should moderate the meeting and help finding an agreement.

It would just be such a pity to miss the chance to have a nicely working=20
snapshot solution in the Linux kernel, that may even be interesting for=20
virtualization (you could store a backup of a machine state permanently=20
or even more of them - if not already available through other=20
technologies like well suspend2 with filewriter for example).

Regards,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5623918.ij7IiMHNTh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWHB7mRvqrKWZhMcRAp79AJ0X/5fp7Q62covyEMpqlkvyXTYu5wCgjBO2
wrkYxd6OMSEaOm/xyzeWZlA=
=bItK
-----END PGP SIGNATURE-----

--nextPart5623918.ij7IiMHNTh--
