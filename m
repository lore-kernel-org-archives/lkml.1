Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbZGPMSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbZGPMSF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 08:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755672AbZGPMSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 08:18:01 -0400
Received: from ms01.sssup.it ([193.205.80.99]:33905 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755454AbZGPMR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 08:17:59 -0400
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
From: Raistlin <raistlin@linux.it>
To: Ted Baker <baker@cs.fsu.edu>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, Chris Friesen <cfriesen@nortel.com>,
       "James H. Anderson" <anderson@cs.unc.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
In-Reply-To: <20090715231646.GI14993@cs.fsu.edu>
References: <4A5B61DF.8090101@nortel.com>
	 <1247568455.9086.115.camel@Palantir> <4A5C9ABA.9070909@nortel.com>
	 <alpine.LRH.2.00.0907141109190.16818@anderson.cs.unc.edu>
	 <1247589099.7500.191.camel@twins>
	 <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu>
	 <20090715205503.GA14993@cs.fsu.edu> <4A5E4FDD.7090307@nortel.com>
	 <20090715223400.GF14993@cs.fsu.edu>
	 <8aa016e10907151539t16fb1d7fk3122d77e69ac7de5@mail.gmail.com>
	 <20090715231646.GI14993@cs.fsu.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PzzgzVcm8MNIGBCmv6TH"
Date: Thu, 16 Jul 2009 14:17:56 +0200
Message-Id: <1247746676.5775.280.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PzzgzVcm8MNIGBCmv6TH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-15 at 19:16 -0400, Ted Baker wrote:
> > > 1) The priority of a group seemed to be defined by the priority of
> > > the highest-priority thread in the group's run-queue, which means
> > > it varies dynamically according to which threads in the group are
> > > contending.
> > >
> >=20
> > This is true, but it also ensures that the time allocated to the group
> > is also consumed by group if it wants to.
>=20
> I don't see how schedulability analysis can be done with this model,
> since a single budget is being expended at varying priorities/deadlines.
>=20
Yes, I agree... Right in these days I'm looking at this, and I have some
stub code to provide rt groups with a priority the user can, if he
wants, set through the cgroupfs.

The main problem is dealing with the "distributed" scheduling with push
and pull based migration mechanism.

Equally interesting, to me, is trying to figure out what kind of
analysis (if any!) could be inferred by the current implementation,
which could be an hack --as Peter say-- but, has some features I like...
Working on it as well, but I progress slowly, I'm not that good at
theoretical stuff yet! :-D

But that's another thread... I'll let all you know, if interested, soon
I hope. :-)

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-PzzgzVcm8MNIGBCmv6TH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpfGnQACgkQk4XaBE3IOsR7DQCdGhPV9ufzl1mZB46B3cGyr9Ho
7H8AmQF8ml1mnUVC/bLeDQ4sCo+A1p5P
=sNFh
-----END PGP SIGNATURE-----

--=-PzzgzVcm8MNIGBCmv6TH--

