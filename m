Return-Path: <linux-kernel-owner+w=401wt.eu-S1754209AbZGNJgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbZGNJgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZGNJgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:36:20 -0400
Received: from ms01.sssup.it ([193.205.80.99]:49572 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753619AbZGNJgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:36:19 -0400
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
In-Reply-To: <1247560935.7500.48.camel@twins>
References: <200907102350.47124.henrik@austad.us>
	 <1247336891.9978.32.camel@laptop>  <1247478955.8107.24.camel@Palantir>
	 <1247480080.7529.66.camel@twins>  <1247501182.8107.572.camel@Palantir>
	 <1247560935.7500.48.camel@twins>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UYxh8sgEJVKJL0aRDM2q"
Date: Tue, 14 Jul 2009 11:36:12 +0200
Message-Id: <1247564172.9086.26.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UYxh8sgEJVKJL0aRDM2q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-14 at 10:42 +0200, Peter Zijlstra wrote:
> On Mon, 2009-07-13 at 18:06 +0200, Raistlin wrote:
> > Anyway, maybe if, on some architecture, for some kind of application,
> > the affinity may have been set to preserve some kind actual cache or
> > memory locality for the task access pattern, maybe this could be an
> > issue, couldn't it? :-)
> > I mean, in some case where being sure of having a task running on a
> > particular CPU is somehow of paramount importance...
>=20
> Right, and you answered your own question :-), its _running_ that is
> important, so as long as its blocked (not running), you're free to place
> the task on another cpu if that helps out with something.
>=20
Yep! Re-reading both your and my comments I saw I misunderstood your
point! :-(

I agree thet you have to move some task and, moving the "blocked" ones,
would allow the lock-owner to continue running in its place, which
sounds good to me to. :-)

Sorry!
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-UYxh8sgEJVKJL0aRDM2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpcUYUACgkQk4XaBE3IOsS95wCeOGAiZRgfqY4RotkmSG1IA3UP
ArsAnAjpf2rzuI3k6qWHOx8sY8VtA5t6
=GjuC
-----END PGP SIGNATURE-----

--=-UYxh8sgEJVKJL0aRDM2q--

