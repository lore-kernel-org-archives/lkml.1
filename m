Return-Path: <linux-kernel-owner+w=401wt.eu-S965404AbXCQLEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965404AbXCQLEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 07:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965454AbXCQLEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 07:04:07 -0400
Received: from psmtp08.wxs.nl ([195.121.247.22]:38354 "EHLO psmtp08.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404AbXCQLEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 07:04:04 -0400
Date: Sat, 17 Mar 2007 12:07:10 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: RSDL v0.31
In-reply-to: <20070317075615.GC13685@elte.hu>
To: ck@vds.kolivas.org
Cc: Ingo Molnar <mingo@elte.hu>, Nicholas Miell <nmiell@comcast.net>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Message-id: <200703171207.15221.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart2338137.xGniYVI2nM
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.6
References: <200703042335.26785.a1426z@gawab.com>
 <1174112768.3144.8.camel@entropy> <20070317075615.GC13685@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2338137.xGniYVI2nM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Op Saturday 17 March 2007, schreef Ingo Molnar:
> so it is not at all clear to me that RSDL is indeed an improvement, if
> it does not have comparable auto-nice properties.

Wasn't the point of RSDL to get rid of the auto-nice, because it caused=20
starvation, unpredictable behaviour and other problems?

Anyway, I think it's a good thing we keep having a look at mike's problem, =
but=20
it's not clear to me how far he got in solving it. Does the latest patch=20
solve the interactivity problem, providing X is niced -10 (or something)???=
=20

If it does, I think that's the solution - at least until the X ppl fix X=20
itself. Distributions can just go back renicing X (they did that before,=20
after all), and the biggest problem is fixed. Then all other users can have=
=20
the improvements RSDL offers, the developers can rejoice over the simpler a=
nd=20
cleaner design and code, and everybody is happy.

If it doesn't solve the problem, more work is in order. I think ignoring a=
=20
clear regression to mainline, no matter how rare, isn't smart. It might=20
indicate an underlying problem, and even if it doesn't - you don't want ppl=
=20
complaining the new kernel isn't interactive anymore or something...


/Jos


=2D-=20
Disclaimer:

Alles wat ik doe denk en zeg is gebaseerd op het wereldbeeld wat ik nu heb.=
=20
Ik ben niet verantwoordelijk voor wijzigingen van de wereld, of het beeld w=
at=20
ik daarvan heb, noch voor de daaruit voortvloeiende gedragingen van mezelf.=
=20
Alles wat ik zeg is aardig bedoeld, tenzij expliciet vermeld.

--nextPart2338137.xGniYVI2nM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBF+8vf+wgQ1AD35iwRAsplAJ4w8UJtSP3FMLYZf8h1slFC0akXxQCgkPlo
OtG+AZSzefYtrsWpwAqEgQA=
=E72y
-----END PGP SIGNATURE-----

--nextPart2338137.xGniYVI2nM--
