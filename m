Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbZGPX31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbZGPX31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933548AbZGPX3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:29:19 -0400
Received: from ms01.sssup.it ([193.205.80.99]:44130 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933582AbZGPX3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:29:15 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Ted Baker <baker@cs.fsu.edu>
Cc: "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <20090715205503.GA14993@cs.fsu.edu>
References: <1247336891.9978.32.camel@laptop> <4A594D2D.3080101@ittc.ku.edu>
	 <1247412708.6704.105.camel@laptop> <1247499843.8107.548.camel@Palantir>
	 <4A5B61DF.8090101@nortel.com> <1247568455.9086.115.camel@Palantir>
	 <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iixmZwmzoqEb8NdtUbUW"
Date: Fri, 17 Jul 2009 01:29:11 +0200
Message-Id: <1247786951.4929.52.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iixmZwmzoqEb8NdtUbUW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 16:55 -0400, Ted Baker wrote:
> I hope that Linux will not pursue EDF or EDZL in only a narrow
> sense, as simple priority scheduling algorithms, without providing
> for bandwidth guaranteees and limits.
>=20
Yes, me to...

> By bandwith "guarantee" I mean that the task/scheduling entity is
> guaranteed to be able to at least *compete* at a certain level for
> a certain percentage of the CPU, if we cannot (better) provide an
> admission control mechanism that guarantees it will actually get a
> certain percentage of the CPU.
>
Again, I agree... But giving a group an explicit priority assignment,
although very simple conceptually, raises a lot of issues when the
current implementation of global task scheduling in Linux, with
"distributed" (one per CPU) runqueue, is concerned.

> For example, in the fixed-priority domain, we have Sporadic
> Server.  This guarantees the server a chance to compete at its top
> priority for at least sched_ss_init_budget time in every
> sched_ss_repl_period time, at sched_priority, within some
> tolerance.  It also should not be permitted to use more than
> sched_ss_init_budget time in every sched_ss_repl_period time, at
> sched_priority, within some tolerance.
>=20
And that's why I'm trying what I said before... For, e.g., the sporadic
server policy to extend and be applied to group scheduling, groups need
to have priorities for the standard, already existent, analysis to work.

> In the deadline scheduling domain, we have algorithms like
> Constant Bandwidth Server (and some improved variants) that
> provide similar gurantees and limites, in terms of deadlines.  (I
> recall seeing one very good version in a paper I recently saw,
> which I could seek out and provide to the list if there is
> interest.)
>=20
Well, if it does not bother you too much, I'm curious about that
solution... When you find some time, even via private mail, if I'm the
only one, it would be nice if you can point that paper out to me.

Thanks in advice.

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-iixmZwmzoqEb8NdtUbUW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpft8AACgkQk4XaBE3IOsRXKgCfWxk+FvELsneO/20uoyxcqGK4
KrEAoKr5NV5KJNJYRUsgek1kUscg/apE
=bpkS
-----END PGP SIGNATURE-----

--=-iixmZwmzoqEb8NdtUbUW--

