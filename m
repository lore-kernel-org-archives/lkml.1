Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089Ab0AMJq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0AMJq5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:46:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442Ab0AMJq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:46:57 -0500
Received: from ms01.sssup.it ([193.205.80.99]:35330 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751902Ab0AMJq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:46:56 -0500
Subject: Re: [RFC 10/12][PATCH] SCHED_DEADLINE: group bandwidth management
 code
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
In-Reply-To: <1262011872.7135.119.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255708004.6228.466.camel@Palantir>  <1262011872.7135.119.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y28LBuYjTxJY9WKQHE+q"
Date: Wed, 13 Jan 2010 10:46:54 +0100
Message-ID: <1263376014.3853.20.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y28LBuYjTxJY9WKQHE+q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-28 at 15:51 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:46 +0200, Raistlin wrote:
> > CPU Container Groups support for SCHED_DEADLINE is introduced by this c=
ommit.
> >=20
> > CGroups, if configured, have a SCHED_DEADLINE bandwidth, and it is enfo=
rced
> > that the sum of the bandwidths of entities (tasks and groups) belonging=
 to
> > a group stays below its own bandwidth.
>=20
> No real comment on the code here, but since we have a deadline bandwidth
> reservation, should we not also couple to the existing rt (fifo)
> bandwidth reservation?
>=20
> We can't after all guarantee the FIFO time if there's deadline
> reservations around for more.
>=20
Mmm... If I'm getting this right, you're suggesting to decrease from the
available system rt-bandwidth the bandwidth devoted to deadline
scheduling.

This make more than sense to me... I'll think about how to make the code
reflect that.

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-Y28LBuYjTxJY9WKQHE+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNlo0ACgkQk4XaBE3IOsSnkACfZDM3BfhnDOHElROFgQZUQJQV
kq4AoJDTC0tY2CHRZPQCEuGefRO6kEQQ
=0Tsg
-----END PGP SIGNATURE-----

--=-Y28LBuYjTxJY9WKQHE+q--

