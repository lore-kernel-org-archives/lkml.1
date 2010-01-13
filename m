Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743Ab0AMKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0AMKgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004Ab0AMKgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:36:47 -0500
Received: from ms01.sssup.it ([193.205.80.99]:37107 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755703Ab0AMKgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:36:36 -0500
Subject: Re: [RFC 1/12][PATCH] Extended scheduling parameters structure
 added.
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
In-Reply-To: <1262088943.7135.137.camel@laptop>
References: <1255707324.6228.448.camel@Palantir>
	 <1255707535.6228.451.camel@Palantir>  <1262088943.7135.137.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iaBeWhvdSnnK5sAq6ehN"
Date: Wed, 13 Jan 2010 11:36:34 +0100
Message-ID: <1263378994.3853.71.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iaBeWhvdSnnK5sAq6ehN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-29 at 13:15 +0100, Peter Zijlstra wrote:
> On Fri, 2009-10-16 at 17:38 +0200, Raistlin wrote:
>=20
> >  include/linux/sched.h |    8 ++++++++
> >  1 files changed, 8 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 75e6e60..ac9837c 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -94,6 +94,14 @@ struct sched_param {
> > =20
> >  #include <asm/processor.h>
> > =20
> > +struct sched_param_ex {
> > +	int sched_priority;
> > +	struct timespec sched_runtime;
> > +	struct timespec sched_deadline;
> > +	struct timespec sched_period;
> > +	int sched_flags;
> > +};
> > +
> >  struct exec_domain;
> >  struct futex_pi_state;
> >  struct robust_list_head;
>=20
> Why separate this change from the introduction of the new system calls?
>=20
Nothing particular... I was just thinking that the extended data
structure might have sense even for other --more general-- purposes. But
I can merge the two if it sounds better.

Thanks and regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-iaBeWhvdSnnK5sAq6ehN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAktNojIACgkQk4XaBE3IOsS1xQCghSLMI1A0gmenAJtH4B+chZlV
J08An2cCmUvze35/dZQmTgjwyH1Uxqfj
=qRc5
-----END PGP SIGNATURE-----

--=-iaBeWhvdSnnK5sAq6ehN--

