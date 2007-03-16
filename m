Return-Path: <linux-kernel-owner+w=401wt.eu-S2992449AbXCPXGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992449AbXCPXGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 19:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992452AbXCPXGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 19:06:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:53164 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992449AbXCPXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 19:06:09 -0400
From: Dirk Schoebel <dirk@liji-und-dirk.de>
To: ck@vds.kolivas.org
Subject: Re: [ck] Re: RSDL v0.31
Date: Sat, 17 Mar 2007 00:05:58 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200703042335.26785.a1426z@gawab.com> <200703170813.32594.kernel@kolivas.org> <1174084207.7009.9.camel@Homer.simpson.net>
In-Reply-To: <1174084207.7009.9.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3135312.XgdcERKLbP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200703170006.02362.dirk@liji-und-dirk.de>
X-Provags-ID: V01U2FsdGVkX19EV0t5RHynawUprcuhohBOLbPIZ8zxDfQY+zr
 th+I5mhw34acF0QfOwQ6xzYrHD4zUVOjrOcwVCSvI94joz46DK
 8V1t1+R8LgX4lEvyI2vIg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3135312.XgdcERKLbP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

=46reitag, 16. M=E4rz 2007 wrote Mike Galbraith:
> On Sat, 2007-03-17 at 08:13 +1100, Con Kolivas wrote:
> > On Saturday 17 March 2007 02:34, Mike Galbraith wrote:
> > > On Sat, 2007-03-17 at 00:40 +1100, Con Kolivas wrote:
> > > > Here are full patches for rsdl 0.31 for various base kernels. A full
> > > > announce with a fresh -mm series will follow...
> > > >
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.20.3-rsdl-0.31=
=2Ep
> > > >atch
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-r=
sd
> > > >l-0. 31.patch
> > > > http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-mm2-rsd=
l-
> > > >0.31 .patch
> > >
> > > It still has trouble with the x/gforce vs two niced encoders scenario.
> > > The previously reported choppiness is still present.
> > >
> > > I suspect that x/gforce landing in the expired array is the trouble,
> > > and that this will never be smooth without some kind of exemption.  I
> > > added some targeted unfairness to .30, and it didn't help much at all.
> > >
> > > Priorities going all the way to 1 were a surprise.
> >
> > It wasn't going to change that case without renicing X.
>
> Con.  You are trying to wedge a fair scheduler into an environment where
> totally fair simply can not possibly function.
>
> If this is your final answer to the problem space, I am done testing,
> and as far as _I_ am concerned, your scheduler is an utter failure.
>

I can not let this comment stay like that. I have an AMD X2 4400+ Dual Core=
=20
running Gentoo and now kernel 2.6.21-rc3 with RSDL 0.30 (HZ=3D300).
Up till now whenever I wanted to watch a movie i had to stop compiling with=
=20
more than one task for the movie to run without skips. When playing games i=
=20
have to renice the game (-15-) or else it would get 'choppy'.
With the new RSDL i compile packages with -j3 (reniced to 15), my wife lets=
 up=20
to 8 computations (scientific computations) running at the same time and th=
e=20
game and a movie still run without any visible flaws. The only thing i saw=
=20
till now was that the mouse cursor was a little less responsive and scrolli=
ng=20
in firefox took a little longer. But amarok for music, the movie in mplayer=
,=20
the 3d game, everything went smooth though a load of > 11. This all without=
=20
even renicing anything but the compiles. With mainline kernel already=20
watching a movie with this load was impossible.
I used the staircase scheduler before RSDL but even with staircase such=20
overload was not possible while watching a movie.
Mike, maybe use higher nice levels for your encoders or just use one. Or ma=
ybe=20
scheck your memory, i guess if the memory bandwidth is too low there's no=20
scheduler which can foresee such thing and react accordingly. Since you hav=
e=20
a HT system it's just one physical ALU, so everything has to be squeezed on=
to=20
this one ALU, up to a certain degree it works, but not forever. And the lam=
e=20
encoders i suppose won't wait that very much and long for their data to get=
=20
delivered from memory so they'll utilize the ALU quite a lot.
Con, continue your scheduler development as it helps many cases which were =
not=20
possible otherwise. I'm amazed of the ability of the scheduler to handle a =
5=20
times overloaded system without too much hazzle.
Great work Con.

Dirk.

PS: Con, don't stress your neck too much, your health is the only thing you=
=20
have to keep for live.

--nextPart3135312.XgdcERKLbP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBF+yLa6YYnt7muP7IRAk+kAKCoXwcCR7ij83qRsXO0udIgAI4kHwCg2Agu
Wj/KQz/m4bXbjYux18voleU=
=2Tc9
-----END PGP SIGNATURE-----

--nextPart3135312.XgdcERKLbP--
