Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbXG1SD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbXG1SD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 14:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXG1SDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 14:03:51 -0400
Received: from psmtp13.wxs.nl ([195.121.247.25]:44387 "EHLO psmtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbXG1SDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 14:03:50 -0400
Date: Sat, 28 Jul 2007 20:03:41 +0200
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: Linus 2.6.23-rc1
In-reply-to: <alpine.LFD.0.999.0707281017230.3442@woody.linux-foundation.org>
To: ck@vds.kolivas.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Chang <thenewme91@gmail.com>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200707282003.45142.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1498472.m48f8JVY1L
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.7
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
 <b14e81f00707280618m73461fdfx989d87a3a0074192@mail.gmail.com>
 <alpine.LFD.0.999.0707281017230.3442@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1498472.m48f8JVY1L
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 28 July 2007, schreef Linus Torvalds:
> On Sat, 28 Jul 2007, Michael Chang wrote:
> > I do recall there is one issue on which Con wouldn't budge -- anything
> > that involved boosting certain kinds of processes in the kernel.
>
> I did that myself, so that's a non-issue.
>
> No. The complaints were about the CK scheduler not being as responsive
> under load as even the _old_ scheduler was. I don't know why people ignore
> this fact. It was a long thread back in March or April, and I'm pretty
> sure the CK mailing list was cc'd.

Of course it wasn't. The speed of tasks slows proportionally with the amoun=
t=20
of system usage. That's the whole point, and CFS can't fix that either, can=
=20
it?

> Sure, most people don't actually have load-averages above ten etc, but
> it's important to do those well _too_.
>
> 			Linus

<sarcasm>
http://osnews.com/permalink.php?news_id=3D18350&comment_id=3D259044

Now I wonder. Apparently, one person complaining about SD was reason to kee=
p=20
it out http://osnews.com/permalink.php?news_id=3D18350&comment_id=3D258997

Will this first post stop CFS from entering the kernel?
</sarcasm>


Now I'll try to be a bit more constructive. I hope your benevolent=20
dictatorship allows self reflection.

Sure, the difference in behaviour (not in code) between SD and CFS is small=
,=20
and for me it doesn't matter. I'm fine with CFS in the kernel, it's a huge=
=20
improvement over the previous one. But why, while there was a seemingly goo=
d=20
alternative, did THAT one stay in that long? And this argument goes for mor=
e=20
code 'out there', btw.
=20
 Some things get into the kernel, other don't. Some get in too soon, others=
=20
too late. Sure. But shouldn't we try to improve this process, instead of=20
saying 'it is what it is, get over it'?
=20
 For me, that's the purpose of this whole discussion. We're losing valuable=
=20
code and contributors, yet at the same time code which isn't mature yet=20
enters the kernel. Acknowledging there is a problem is the first step in=20
solving it.

 Of course, I don't have answers - but I do feel strongly that you think th=
ere=20
is no issue. Is there, or isn't there? And if there is, what do you plan to=
=20
do about it?



Your influence on the behaviour of the people around you, your 'lieutenants=
',=20
is huge. Larger than you might think. And in many cases, ppl following=20
someone behave more extreme. That's a big reason why the LKML isn't very=20
polite nor inviting (mind you, I don't think that's necessarily a bad thing=
,=20
that's up to you to decide).

You might want to think about ways to improve the whole process. Again, I'm=
 no=20
Linus, it's your call. And you can make a big difference, I'm sure.


Greetings,

Jos

--nextPart1498472.m48f8JVY1L
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGq4T9+wgQ1AD35iwRAjOkAJ9R2JUPaG0QXrwUNlHY6aX1TRj5QgCgu+O3
NmsxqseICr9IxhA2H+YphSc=
=K39q
-----END PGP SIGNATURE-----

--nextPart1498472.m48f8JVY1L--
