Return-Path: <linux-kernel-owner+w=401wt.eu-S1751720AbXCLSoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbXCLSoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 14:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751704AbXCLSoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 14:44:24 -0400
Received: from smtp14.wxs.nl ([195.121.247.5]:45648 "EHLO smtp14.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXCLSoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 14:44:23 -0400
Date: Mon, 12 Mar 2007 19:47:11 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
 interactive cpu scheduler
In-reply-to: <200703130505.05132.kernel@kolivas.org>
To: ck@vds.kolivas.org
Cc: Con Kolivas <kernel@kolivas.org>, Al Boldi <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Message-id: <200703121947.16008.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2687731.mml4ruIgb3
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <200703121714.25034.a1426z@gawab.com> <200703130505.05132.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2687731.mml4ruIgb3
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Monday 12 March 2007, schreef Con Kolivas:
> On Tuesday 13 March 2007 01:14, Al Boldi wrote:
> > Con Kolivas wrote:
> > > > > The higher priority one always get 6-7ms whereas the lower priori=
ty
> > > > > one runs 6-7ms and then one larger perfectly bound expiration
> > > > > amount. Basically exactly as I'd expect. The higher priority task
> > > > > gets precisely RR_INTERVAL maximum latency whereas the lower
> > > > > priority task gets RR_INTERVAL min and full expiration (according
> > > > > to the virtual deadline) as a maximum. That's exactly how I intend
> > > > > it to work. Yes I realise that the max latency ends up being long=
er
> > > > > intermittently on the niced task but that's -in my opinion-
> > > > > perfectly fine as a compromise to ensure the nice 0 one always ge=
ts
> > > > > low latency.
> > > >
> > > > I think, it should be possible to spread this max expiration latency
> > > > across the rotation, should it not?
> > >
> > > There is a way that I toyed with of creating maps of slots to use for
> > > each different priority, but it broke the O(1) nature of the virtual
> > > deadline management. Minimising algorithmic complexity seemed more
> > > important to maintain than getting slightly better latency spreads for
> > > niced tasks. It also appeared to be less cache friendly in design. I
> > > could certainly try and implement it but how much importance are we to
> > > place on latency of niced tasks? Are you aware of any usage scenario
> > > where latency sensitive tasks are ever significantly niced in the real
> > > world?
> >
> > It only takes one negatively nice'd proc to affect X adversely.
>
> I have an idea. Give me some time to code up my idea. Lack of sleep is
> making me very unpleasant.

You're excited by RSDL and the positive comments, aren't you? Well, don't=20
forget to sleep, sleeping makes ppl smarter you know ;-)

--nextPart2687731.mml4ruIgb3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF9aAw+wgQ1AD35iwRAnYXAJ9O98rS3PKPzZp78xGDo7O9a4f51gCfX3R+
t96LVrpooN5G/kCSd8bl7kk=
=Q0y3
-----END PGP SIGNATURE-----

--nextPart2687731.mml4ruIgb3--
