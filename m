Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871Ab0AMKqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0AMKqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482Ab0AMKqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:46:35 -0500
Received: from ms01.sssup.it ([193.205.80.99]:60985 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755474Ab0AMKqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:46:34 -0500
Subject: Re: [RFC 0/12][PATCH] SCHED_DEADLINE: core of the scheduling class
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
In-Reply-To: <1262097699.7135.154.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707614.6228.453.camel@Palantir>  <1262097699.7135.154.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eXU0EvhyHMqU7dXYN77w"
Date: Wed, 13 Jan 2010 11:46:31 +0100
Message-ID: <1263379591.3853.79.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eXU0EvhyHMqU7dXYN77w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 15:41 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:40 +0200, Raistlin wrote:
> > +static unsigned long
> > +load_balance_deadline(struct rq *this_rq, int this_cpu, struct rq *bus=
iest,
> > +                unsigned long max_load_move,
> > +                struct sched_domain *sd, enum cpu_idle_type idle,
> > +                int *all_pinned, int *this_best_prio)
> > +{
> > +       /* for now, don't touch SCHED_DEADLINE tasks */
> > +       return 0;
> > +}
> > +
> > +static int
> > +move_one_task_deadline(struct rq *this_rq, int this_cpu, struct rq *bu=
siest,
> > +                 struct sched_domain *sd, enum cpu_idle_type idle)
> > +{
> > +       return 0;
> > +}=20
>=20
> The good news is that I've killed all that :-)
>=20
Yeah, good news then! :-D

By the way... I hope you all will soon hear from us something regarding
global-SMP and migrations with respect to this scheduler.

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-eXU0EvhyHMqU7dXYN77w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNpIYACgkQk4XaBE3IOsT/ygCgm6bnn9N3UJ3qC5hj/7OZjc7J
X2AAoKjTmzWjXOOdTkkDc7z0ktklLbKr
=4JFk
-----END PGP SIGNATURE-----

--=-eXU0EvhyHMqU7dXYN77w--

