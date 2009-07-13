Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbZGMJ4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbZGMJ4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZGMJ4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:56:02 -0400
Received: from ms01.sssup.it ([193.205.80.99]:53176 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752197AbZGMJ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:56:00 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Henrik Austad <henrik@austad.us>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>
In-Reply-To: <1247336891.9978.32.camel@laptop>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+4spjaKWxCIlYZtLbDkP"
Date: Mon, 13 Jul 2009 11:55:55 +0200
Message-Id: <1247478955.8107.24.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+4spjaKWxCIlYZtLbDkP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 20:28 +0200, Peter Zijlstra wrote:=20
> > There are still some issues left to solve, for instance how to best
> > handle sporadic tasks, and whether or not deadline-miss should be allow=
,
> > or just 'bounded deadline tardiness'. Either way, EFF should be able to
> > handle it. Then, there are problems concerning blocking of tasks. One
> > solution would be BWI or PEP, but I have not had the time to read
> > properly through those, but from what I've gathered a combination of BW=
I
> > and PEP looks promising (anyone with good info about BWI and PEP - feel
> > free to share! (-: ).
>=20
> Our SSSUP friends have a BWI paper here:
>=20
>   http://retis.sssup.it/~tommaso/publications/OSPERT-2008.pdf
>=20
And here we are! :-)

The paper Peter pointed you to mainly describes the work I did some
months ago to implement BandWidth Inheritance inside one real-time Linux
variant of us (ReTiS Lab, in Pisa, Italy)... Feel free to ask anything
related to it directly to me.

It is exactly implemented as a "proxy execution" protocol and things
were easy there, since --for now-- the framework I was talking about is
UP-only! :-(

Now we are back on work on it, especially thinking on how to extend the
protocol to SMP architectures...

> Thing is, both BWI and PEP seems to work brilliantly on Uni-Processor
> but SMP leaves things to be desired. Dhaval is currently working on a
> PEP implementation that will migrate all the blocked tasks to the
> owner's cpu, basically reducing it to the UP problem.
>=20
Nice... Only one question, doesn't this impact with task affinity
related issues?

regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-+4spjaKWxCIlYZtLbDkP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpbBKQACgkQk4XaBE3IOsRNpACglOdL6qHSJA9hwycAfqM8SDxP
hh8An0mU67WmrweuEaoCN6dYe6eFpdeZ
=uE15
-----END PGP SIGNATURE-----

--=-+4spjaKWxCIlYZtLbDkP--

