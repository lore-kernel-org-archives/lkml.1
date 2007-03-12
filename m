Return-Path: <linux-kernel-owner+w=401wt.eu-S1030266AbXCLO4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030266AbXCLO4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 10:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030309AbXCLO4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 10:56:33 -0400
Received: from psmtp09.wxs.nl ([195.121.247.23]:53467 "EHLO psmtp09.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030266AbXCLO4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 10:56:31 -0400
Date: Mon, 12 Mar 2007 15:58:44 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
 interactive cpu scheduler
In-reply-to: <200703121714.25034.a1426z@gawab.com>
To: ck@vds.kolivas.org
Cc: Al Boldi <a1426z@gawab.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org
Message-id: <200703121559.23157.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2323006.tXNY7odxGV
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <200703122352.51257.kernel@kolivas.org> <200703121714.25034.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2323006.tXNY7odxGV
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Monday 12 March 2007, schreef Al Boldi:
> Con Kolivas wrote:
> > > > The higher priority one always get 6-7ms whereas the lower priority
> > > > one runs 6-7ms and then one larger perfectly bound expiration amoun=
t.
> > > > Basically exactly as I'd expect. The higher priority task gets
> > > > precisely RR_INTERVAL maximum latency whereas the lower priority ta=
sk
> > > > gets RR_INTERVAL min and full expiration (according to the virtual
> > > > deadline) as a maximum. That's exactly how I intend it to work. Yes=
 I
> > > > realise that the max latency ends up being longer intermittently on
> > > > the niced task but that's -in my opinion- perfectly fine as a
> > > > compromise to ensure the nice 0 one always gets low latency.
> > >
> > > I think, it should be possible to spread this max expiration latency
> > > across the rotation, should it not?
> >
> > There is a way that I toyed with of creating maps of slots to use for
> > each different priority, but it broke the O(1) nature of the virtual
> > deadline management. Minimising algorithmic complexity seemed more
> > important to maintain than getting slightly better latency spreads for
> > niced tasks. It also appeared to be less cache friendly in design. I
> > could certainly try and implement it but how much importance are we to
> > place on latency of niced tasks? Are you aware of any usage scenario
> > where latency sensitive tasks are ever significantly niced in the real
> > world?
>
> It only takes one negatively nice'd proc to affect X adversely.

Then, maybe, we should start nicing X again, like we did/had to do until a =
few=20
years ago? Or should we just wait until X gets fixed (after all, developmen=
t=20
goes faster than ever)? Or is this really the scheduler's fault?

> Thanks!
>
> --
> Al
>
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

--nextPart2323006.tXNY7odxGV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF9Wql+wgQ1AD35iwRAiv1AKC1Y8Hn9ABVNVY2u+fIYCVrtV8f8gCff0YI
5uX/vksJR6cAdFKRCJ9DH4U=
=q1xN
-----END PGP SIGNATURE-----

--nextPart2323006.tXNY7odxGV--
