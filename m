Return-Path: <linux-kernel-owner+w=401wt.eu-S965301AbXCTKXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965301AbXCTKXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 06:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965320AbXCTKXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 06:23:21 -0400
Received: from smtp14.wxs.nl ([195.121.247.5]:55639 "EHLO smtp14.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965301AbXCTKXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 06:23:20 -0400
Date: Tue, 20 Mar 2007 11:26:40 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: RSDL v0.31
In-reply-to: <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
To: ck@vds.kolivas.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Xavier Bestel <xavier.bestel@free.fr>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Mark Lord <lkml@rtr.ca>, Nicholas Miell <nmiell@comcast.net>
Message-id: <200703201126.41114.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart1954619.Rz0z5MrxHk
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <1174322580.30876.72.camel@frg-rhel40-em64t-04>
 <Pine.LNX.4.64.0703192006130.6730@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1954619.Rz0z5MrxHk
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Tuesday 20 March 2007, schreef Linus Torvalds:
> On Mon, 19 Mar 2007, Xavier Bestel wrote:
> > > >> Stock scheduler wins easily, no contest.
> > > >
> > > > What happens when you renice X ?
> > >
> > > Dunno -- not necessary with the stock scheduler.
> >
> > Could you try something like renice -10 $(pidof Xorg) ?
>
> Could you try something as simple and accepting that maybe this is a
> problem?
>
> Quite frankly, I was *planning* on merging RSDL very early after 2.6.21,
> but there is one thing that has turned me completely off the whole thing:
>
>  - the people involved seem to be totally unwilling to even admit there
>    might be a problem.
>
> This is like alcoholism. If you cannot admit that you might have a
> problem, you'll never get anywhere. And quite frankly, the RSDL proponents
> seem to be in denial ("we're always better", "it's your problem if the old
> scheduler works better", "just one report of old scheduler being better").
>
> And the thing is, if people aren't even _willing_ to admit that there may
> be issues, there's *no*way*in*hell* I will merge it even for testing.
> Because the whole and only point of merging RSDL was to see if it could
> replace the old scheduler, and the most important feature in that case is
> not whether it is perfect, BUT WHETHER ANYBODY IS INTERESTED IN TRYING TO
> FIX THE INEVITABLE PROBLEMS!

Con simply isn't available right now, but you're right. RSDL isn't ready ye=
t,=20
imho, there seem to be some regressions (and I'm bitten by them, too). But =
if=20
con's past behaviour says anything about how he's going to behave in the=20
future (and according to my psych prof it's the most reliable predictor ;-)=
),=20
I'm pretty sure he'll jump on this when he's healthy again. He's gone throu=
gh=20
great lengths to fix problems with staircase, no matter how obscure, so I s=
ee=20
no reason why he wouldn't do the same for RSDL... Though scheduler problems=
=20
can be extremely hard to reproduce on other hardware.

> See?
>
> Can you people not see that the way you're doing that "RSDL is perfect"
> chorus in the face of people who report problems, you're just making it
> totally unrealistic that it will *ever* get merged.
>
> So unless somebody steps up to the plate and actually *talks* about the
> problem reports, and admits that maybe RSDL will need some tweaking, I'm
> not going to merge it.
>
> Because there is just _one_ thing that is more important than code - and
> that is the willingness to fix the code...
>
> 		Linus
> _______________________________________________
> http://ck.kolivas.org/faqs/replying-to-mailing-list.txt
> ck mailing list - mailto: ck@vds.kolivas.org
> http://vds.kolivas.org/mailman/listinfo/ck



=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

Please avoid sending me Word or PowerPoint attachments.
See http://www.gnu.org/philosophy/no-word-attachments.html

--nextPart1954619.Rz0z5MrxHk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF/7bh+wgQ1AD35iwRAp1OAKDO+TXuoTLeuJLnpHjMg4KAwF7ZLQCeLyWb
zE1T6ueYRt3G8bETaXO3noI=
=BmDr
-----END PGP SIGNATURE-----

--nextPart1954619.Rz0z5MrxHk--
