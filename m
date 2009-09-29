Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952AbZI2QKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbZI2QKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 12:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbZI2QKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 12:10:35 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37759 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751096AbZI2QKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 12:10:34 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Henrik Austad <henrik@austad.us>
Cc: Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <200909270855.49367.henrik@austad.us>
References: <1253615424.20345.76.camel@Palantir>
	 <1253623867.20345.156.camel@Palantir> <1253644603.18939.25.camel@laptop>
	 <200909270855.49367.henrik@austad.us>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9bjaRhQuTn10kS5KAjeY"
Date: Tue, 29 Sep 2009 18:10:35 +0200
Message-Id: <1254240635.7775.44.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9bjaRhQuTn10kS5KAjeY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-09-27 at 08:55 +0200, Henrik Austad wrote:
> > An alternative is starting the child out with 0 runtime, and have the
> > parent run sched_setscheduler() on it giving us a clear point to run
> > admission on.
>=20
> Why not start it as sched_fair/sched_rt and let the child apply for
> resources the same way the parent did? That would be fairly
> straightforward and lead to predictable behaviour, and also make a nice,=20
> simple hook into the acceptance-tests.
>=20
Yeah, that's an option as well... It maybe overlap a little bit with
reset_on_fork, but I like tha fact that it allows the task itself to ask
for EDF bandwidth without having to rely on its parent... Thoughts about
that?

Regards,
Dario
=20
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-9bjaRhQuTn10kS5KAjeY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrCMXsACgkQk4XaBE3IOsQsvACgqTN2W36bZKssgXY1okpH0ETx
rHwAnjAii6DH5A6iZaHJtQ/SUL+RPM1d
=HqE5
-----END PGP SIGNATURE-----

--=-9bjaRhQuTn10kS5KAjeY--

