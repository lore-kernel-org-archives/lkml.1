Return-Path: <linux-kernel-owner+w=401wt.eu-S1751527AbZIZHWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbZIZHWV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 03:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbZIZHWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 03:22:21 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48310 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751385AbZIZHWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 03:22:20 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Raistlin <raistlin@linux.it>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       sat <takeuchi_satoru@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4ABD4839.7060508@nortel.com>
References: <4ABC068A.6070704@jp.fujitsu.com>
	 <4ABCEABC.4050200@gandalf.sssup.it>  <4ABD36CE.3080400@nortel.com>
	 <1253918258.18939.192.camel@laptop>  <4ABD4839.7060508@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tl6KQ1t4AtySK1wl2+gY"
Date: Sat, 26 Sep 2009 09:22:20 +0200
Message-Id: <1253949740.4924.34.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tl6KQ1t4AtySK1wl2+gY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-09-25 at 16:46 -0600, Chris Friesen wrote:
> On 09/25/2009 04:37 PM, Peter Zijlstra wrote:=20
> > afaiu he doesn't, he simply splits the task's wcet between parent and
> > child and (intends?) to feed back on child exit.
>=20
> How does this work if we have one parent task that forks off a bunch of
> kids like massive_intr?  Does each child get half the bandwidth of the
> previous child?
>=20
Yes, that's exactly how I think it goes... Moreover, also the parent's
bandwidth is halved at each fork, which make things very odd in
workloads like massive_intr! :-(

> Right...so would it perhaps be more interesting to try a modified test
> where each child's bandwidth is equal and small enough that there is no
> oversubscription?
>=20
So right! I think that should be the way to go, and I'll try to do
something like this as soon as I can... I promise... :-D

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-tl6KQ1t4AtySK1wl2+gY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq9wOoACgkQk4XaBE3IOsSUxQCbBPYVckZQeI5z3mQJSuDBaeke
Qa8An1/atwZXKCwmssBOgNW0JRWjfnh0
=wjGD
-----END PGP SIGNATURE-----

--=-tl6KQ1t4AtySK1wl2+gY--

