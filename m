Return-Path: <linux-kernel-owner+w=401wt.eu-S933606AbZGQAnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606AbZGQAnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933361AbZGQAnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:43:24 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42745 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933314AbZGQAnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:43:24 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ted Baker <baker@cs.fsu.edu>, Dhaval Giani <dhaval.giani@gmail.com>,
       Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Douglas Niehaus <niehaus@ittc.ku.edu>, Henrik Austad <henrik@austad.us>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
In-Reply-To: <1247734722.15471.83.camel@twins>
References: <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
	 <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
	 <20090715231646.GI14993@cs.fsu.edu>  <1247734722.15471.83.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/hVZGFjHDzKHtQjDG7Mg"
Date: Fri, 17 Jul 2009 02:43:17 +0200
Message-Id: <1247791397.4929.191.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/hVZGFjHDzKHtQjDG7Mg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 10:58 +0200, Peter Zijlstra wrote:
> Now, let me first state that the current code is a hack, and I know its
> nowhere near proper. But it was the best I could come up with on a short
> notice -- and Fabio is now looking at doing better :-)
>=20
If I can say something (more!) there is quite a lot of work in our lab
on this stuff, starting from different perspective and aiming at
different goals.

I've been involved, and continuing being, on sporadic server
implementation, EDF implementation in separate scheduling class (with
Michael), while Fabio is doing a lot (and a lot better!) work on
deadlines in sched-rt.

Independently from what concerns priorities or deadlines, the way the
global scheduling is implemented, i.e., with distributed ready queues,
raises a lot of issues with the implementation of _global_
_hierarchical_ scheduling policies of both kind, EDF and FP.
It is being very hard to figure out, and much more to implement, how
things should go when you have push, pull, affinity, and so on! :-(

I'll be more precise when I have the code ready, but here the question
is, do you think the push and pull approach "is there to stay", or is
there room, maybe after trials, errors, experiments and exhaustive
search for the correct data structure, to migrate to something that
would make global scheduling easier?

Dario
--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-/hVZGFjHDzKHtQjDG7Mg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfyR4ACgkQk4XaBE3IOsR3/ACfcQFOsY/OgLPCjhjYUS3wpciQ
2EAAnAwtWbR6ghmdQL7ilK41sLyETf3u
=cSQp
-----END PGP SIGNATURE-----

--=-/hVZGFjHDzKHtQjDG7Mg--

