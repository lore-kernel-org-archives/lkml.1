Return-Path: <linux-kernel-owner+w=401wt.eu-S932098AbXCLVcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbXCLVcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 17:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbXCLVcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 17:32:13 -0400
Received: from smtp17.wxs.nl ([195.121.247.8]:63030 "EHLO smtp17.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbXCLVcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 17:32:11 -0400
Date: Mon, 12 Mar 2007 22:34:57 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
In-reply-to: <200703130738.19034.kernel@kolivas.org>
To: ck@vds.kolivas.org
Cc: Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <200703122235.05093.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart20244809.UGx3Vv2yQG
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703111457.17624.kernel@kolivas.org>
 <1173730314.6431.30.camel@Homer.simpson.net>
 <200703130738.19034.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart20244809.UGx3Vv2yQG
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Monday 12 March 2007, schreef Con Kolivas:
> > > If we fix 95% of the desktop and worsen 5% is that bad given how much
> > > else we've gained in the process?
> >
> > Killing the known corner case starvation scenarios is wonderful, but
> > let's not just pretend that interactive tasks don't have any special
> > requirements.
>
> Now you're really making a stretch of things. Where on earth did I say th=
at
> interactive tasks don't have special requirements? It's a fundamental
> feature of this scheduler that I go to great pains to get them as low
> latency as possible and their fair share of cpu despite having a complete=
ly
> fair cpu distribution.

As far as I understand it, RSDL always gives an equal share of cpu, but=20
interactive tasks can have lower latency, right? So you get in trouble with=
=20
interactive tasks only when their share isn't enough to actually do what th=
ey=20
have to do in that period, eg on a heavily (over?) loaded box. Staircase,=20
like mainline which gave them MORE than their share, would support that=20
(though this comes at a price).

So, if your box is overloaded to a great extend, X, which can use a lot of=
=20
cpu, can get unresponsive - unless it's negatively niced. But most other ap=
ps=20
aren't as demanding as X is, so they won't really suffer. Thus the problem =
is=20
mostly X. And at least part of that problem is being solved - X wasting cpu=
=20
cycles. Also, cpu's are getting stronger, and I think it's likely X's=20
relative CPU usage goes down as well.

In the long term, RSDL seems like the best way to go. Nice X down, and you =
got=20
most of the disadvantages. You still have the perfect fairness, no stalls a=
nd=20
starvation ;-)

If RSDL can be improved to help X, great. But introducing again the problem=
=20
which RSDL was supposed to solve would be pretty pointless. I think that's=
=20
what grumpy Con is trying to say, and he's right at it.

grtz

Jos

=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart20244809.UGx3Vv2yQG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF9ceB+wgQ1AD35iwRAsZjAJ9+yhEAiYK+1ri8QCQb1M2ltu1ddQCeIvhV
bGqNrUhUK/lVhXdj5RL+cU0=
=bpWb
-----END PGP SIGNATURE-----

--nextPart20244809.UGx3Vv2yQG--
