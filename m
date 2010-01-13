Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307Ab0AMJl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0AMJl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245Ab0AMJlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:41:25 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43224 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755218Ab0AMJlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:41:25 -0500
Subject: Re: [RFC 9/12][PATCH] SCHED_DEADLINE: system wide bandwidth
 management
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1262011449.7135.116.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707940.6228.464.camel@Palantir>  <1262011449.7135.116.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Gz1nP96g+6ShOvpmkcrb"
Date: Wed, 13 Jan 2010 10:41:23 +0100
Message-ID: <1263375683.3853.15.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gz1nP96g+6ShOvpmkcrb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 15:44 +0100, Peter Zijlstra wrote:
> > Default value is _zero_ bandwidth available, thus write some numbers in=
 those
> > files before trying to start some SCHED_DEADLINE task. Setting runtime =
> period
> > is allowed (i.e., more than 100% bandwidth available for -deadline task=
s),
> > since it makes more than sense in SMP systems.
>=20
> Right, so the current rt bandwidth controls go up to 100%, where 100% is
> root_domain wide. That is, the bandwidth usage scale is irrespective of
> the number of cpus.
>=20
Yep, I know. Mine controls were working a little bit different because
of the fact I have bandwidth control at the task group --not rq-- level.
Anyway...

> If that was the best choice could of course be argued, but since we have
> that, it would be strange to add another set of controls which do not
> conform.
>=20
... I again agree that consistency come first, and I'll move the
controls in the right place, and convert them to the conforming
behavior.

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Gz1nP96g+6ShOvpmkcrb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNlUIACgkQk4XaBE3IOsRu7ACfbVMXqnXuAEDbyqsgsR2hX/J8
H9gAnRtvEJgNOWGVaBlT2yUCOH9dGPy+
=Ub5V
-----END PGP SIGNATURE-----

--=-Gz1nP96g+6ShOvpmkcrb--

