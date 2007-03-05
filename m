Return-Path: <linux-kernel-owner+w=401wt.eu-S1752556AbXCEAHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbXCEAHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:07:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbXCEAHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:07:52 -0500
Received: from smtp13.wxs.nl ([195.121.247.4]:39352 "EHLO smtp13.wxs.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbXCEAHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:07:52 -0500
Date: Mon, 05 Mar 2007 01:10:19 +0100
From: jos poortvliet <jos@mijnkamer.nl>
X-Face: $0>4o"Xx2u2q(Tx!D+6~yPc{ZhEfnQnu:/nthh%Kr%f$aiATk$xjx^X4admsd*)=?utf-8?q?IZz=3A=5FkT=0A=09=7CurITP!=2E?=)L`*)Vw@4\@6>#r;3xSPW`,~C9vb`W/s]}Gq]b!o_/+(lJ:b)=?utf-8?q?T0=26KCLMGvG=7CS=5E=0A=09z=7B=5C=2E7EtehxhFQE=27eYSsir/=7CtQ?=
 =?utf-8?q?j=23rWQe4o?=>WC>_R<vO,d]czmqWYkq[v~iB.e_GuxB'")
 =?utf-8?q?p3=0A=09jGdrhlY4=5E!vd=3F=3AegW?=)xn&fP4!FV<.
Subject: Re: [ck] Re: [ANNOUNCE] RSDL completely fair starvation free
 interactive cpu scheduler
In-reply-to: <20070304231312.GA2268@1wt.eu>
To: ck@vds.kolivas.org
Cc: Willy Tarreau <w@1wt.eu>, Con Kolivas <kernel@kolivas.org>,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org
Message-id: <200703050110.23629.jos@mijnkamer.nl>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=nextPart26075550.mzCSgbD4dv
Content-transfer-encoding: 7bit
User-Agent: KMail/1.9.5 + Features
References: <200703042335.26785.a1426z@gawab.com>
 <200703050849.29674.kernel@kolivas.org> <20070304231312.GA2268@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart26075550.mzCSgbD4dv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Op Monday 05 March 2007, schreef Willy Tarreau:
> On Mon, Mar 05, 2007 at 08:49:29AM +1100, Con Kolivas wrote:
> (...)
>
> > > That's just what it did, but when you "nice make -j4", things (gears)
> > > start to stutter.  Is that due to the staircase?
> >
> > gears isn't an interactive task. Apart from using it as a background load
> > to check for starvation because it loads up the cpu fully (which a gpu
> > intensive but otherwise simple app like this should _not_ do) graphics
> > card drivers and interrupts and so on, I wouldn't put much credence on
> > gears as anything else. However I suspect that gears will still get a
> > fair share of the cpu on RSDL which almost never happens on any other
> > scheduler.
>
> Con,
>
> I've now given it a try with HZ=250 on my dual-athlon. It works
> beautifully. I also quickly checked that playing mp3 doesn't skip during
> make -j4, and that gears runs fairly smoothly, since those are the
> references people often use.
>
> But with real work, it's excellent too. When I saturate my CPUs by
> injecting HTTP traffic on haproxy, the load is stable and the command line
> perfectly responsive, while in the past the load would oscillate and the
> command line sometimes stopped to respond for a few seconds.
>
> I've also launched my scheddos program (you may remember, the one we did a
> few experiments with). I could not cause any freeze at all. Plain 2.6.20
> had already improved a lot in this area, but above 4 processes/CPU,
> occasional short freezes did still occur. This time, even at 100 processes,
> the system was rather slow (of course!) but just as expected, and nothing
> more.
>
> I also tried the good old "dd if=/dev/zero bs=1|...|dd bs=1 of=/dev/null"
> and it did not cause any trouble.
>
> I will boot 2.6 slightly more often to test the code under various
> conditions, and I will recommend it to a few people I know who tend to
> switch back to 2.4 after one day full of 2.6 jerkiness.
>
> Overall, you have done a great job !
>
> I hope that more people will give it a try, first to help find possible
> remaining bugs, and to pronounce in favour of its inclusion in mainline.
>
> Cheers,
> Willy

Sounds nice... you might want to put this in the -ck wiki: ck.wikia.com/

--nextPart26075550.mzCSgbD4dv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBF61/v+wgQ1AD35iwRAtACAJ48h9RN74QMLBhZf6OSPVJVCYkH/QCbB6G3
oiAAL03+AYhGKM+e66cIC4o=
=mqIX
-----END PGP SIGNATURE-----

--nextPart26075550.mzCSgbD4dv--
