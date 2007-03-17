Return-Path: <linux-kernel-owner+w=401wt.eu-S965536AbXCQNll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965536AbXCQNll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965527AbXCQNll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:41:41 -0400
Received: from smtp17.wxs.nl ([195.121.247.8]:62617 "EHLO smtp17.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965536AbXCQNlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:41:40 -0400
Date: Sat, 17 Mar 2007 14:44:48 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: RSDL v0.31
In-reply-to: <20070317124458.GA32301@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <200703171444.51314.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart4329815.3HogQBxmSC
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <200703171207.15221.jos@mijnkamer.nl> <20070317124458.GA32301@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4329815.3HogQBxmSC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 17 March 2007, schreef Ingo Molnar:
> * jos poortvliet <jos@mijnkamer.nl> wrote:
> > Op Saturday 17 March 2007, schreef Ingo Molnar:
> > > so it is not at all clear to me that RSDL is indeed an improvement,
> > > if it does not have comparable auto-nice properties.
> >
> > Wasn't the point of RSDL to get rid of the auto-nice, because it
> > caused starvation, unpredictable behaviour and other problems?
>
> it doesnt really get rid of it, it replaces it with another mechanism
> that is fundamentally unfair too.
>
> RSDL has _another_, albeit more hidden "auto-nice" behavior: this time
> expressed not via the plain manipulation of priorities based on the
> sleep average, but expressed via the quota-depletion flux of tasks over
> time, fed into a complex dance of rotating priorities - which
> quota-depletion flux is in essence a sleep average too, just more
> derived and more hardcoded.

Hmmm. I wonder, then, does RSDL give an advantage in the areas I mentioned=
=20
(starvation and predictability)?=20

RSDL does give equal timeslices (eg equal cpu time) to each process - it's=
=20
just that processes which didn't use their time yet can quickly run, right?=
=20
Now I might not understand things here, but that it sounds more fair, thoug=
h=20
you're more quallified to judge that. So, for me, as an user, it boils down=
=20
to: does this solve problems, and does it introduce problems?

I must say I compare RSDL to staircase, as that's what I'm used to - a bit=
=20
more interactive compared to mainline. RSDL does slightly worse AND slightl=
y=20
better - worse in interactivity on heavy loads (8 makes running on my=20
dualcore) but it doesn't have the systemwide stalls sometimes occurring on=
=20
both mainline and staircase - though it replaces them with shorter,=20
app-specific ones (the worse interactivity I mention).

> or looking at it from another angle, code size:
>
>    text    data     bss     dec     hex filename
>   15750      24    6008   21782    5516 sched.o.vanilla
>   15960     360    6336   22656    5880 sched.o.rsdl
>
> there's no reduction in complexity, it just moved elsewhere.
>
> 	Ingo



=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart4329815.3HogQBxmSC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF+/DQ+wgQ1AD35iwRAvPuAJ4lk3dOzB+Jev4Nt0co6q62TVqEnQCgwWJh
Tm3ti+g2cXfg1Ffxq8NgC80=
=/Xj2
-----END PGP SIGNATURE-----

--nextPart4329815.3HogQBxmSC--
