Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZGNTOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZGNTOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:14:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756027AbZGNTOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:14:40 -0400
Received: from ms01.sssup.it ([193.205.80.99]:56112 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755452AbZGNTOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:14:39 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <4A5CCD5A.80108@nortel.com>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com> <1247590112.9086.936.camel@Palantir>
	 <4A5CCD5A.80108@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MRo2C8k7mHoqG/cwkZ/l"
Date: Tue, 14 Jul 2009 21:14:12 +0200
Message-Id: <1247598852.4839.99.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MRo2C8k7mHoqG/cwkZ/l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 12:24 -0600, Chris Friesen wrote:
> > - that A is actually blocked, as said before;
>=20
> Why does it make any difference that A is blocked rather than busy
> waiting?  In either case A cannot make forward progress.
>=20
I think it's not a problem of A, but of the overall schedule, from a
system predictability perspective.

Anyway, we are still evaluating what, if any could the issues be.

> > - that A's budget is not diminished.
>=20
> If we're running B with A's priority, presumably it will get some amount
> of cpu time above and beyond what it would normally have gotten during a
> particular scheduling interval. =20
>
Right...

> Perhaps it would make sense to charge B
> what it would normally have gotten, and charge the excess amount to A?
>=20
Mmm.. That's right, but I'm not sure I get what happen while executing
C... Anyway, it seems to me that we are getting closer to each other
point of view... let's keep staying in touch! :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-MRo2C8k7mHoqG/cwkZ/l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpc2QQACgkQk4XaBE3IOsQuAgCeIb3kMjLV+nBcJuOGBXramc6y
ISoAni/i533oEpgsZvJF/JYgNkBsgNHG
=D2j6
-----END PGP SIGNATURE-----

--=-MRo2C8k7mHoqG/cwkZ/l--

