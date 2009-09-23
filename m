Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZIWOpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZIWOpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 10:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZIWOpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 10:45:16 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42598 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751467AbZIWOpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 10:45:15 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Peter Zijlstra <peterz@infradead.org>, michael@evidence.eu.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <63386a3d0909230708g10aa2911vaa39a6e02530c902@mail.gmail.com>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909221355o45cccdf2j707a5cb4cf36754b@mail.gmail.com>
	 <4ABA20FF.4020601@evidence.eu.com>
	 <63386a3d0909230708g10aa2911vaa39a6e02530c902@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-obZqSfsoU6cI6uigClmN"
Date: Wed, 23 Sep 2009 16:45:15 +0200
Message-Id: <1253717115.5631.500.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-obZqSfsoU6cI6uigClmN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-23 at 16:08 +0200, Linus Walleij wrote:
> > With EDF, instead, the test is much easier: if the bandwidth is less th=
an
> > 100%, then you are sure that the deadlines will be met. In other words,=
 you
> > can fully exploit processor bandwidth up to 100% being sure that timing
> > constraints of EDF tasks will be guaranteed.
>=20
> This must be under the assumption that all code running in the system
> is preemtible, is it not? Which means, negligible or close to negligible
> non-preemptible code.
>=20
Right. Moreover, this also happen only if tasks are independent, do not
share resources, etc. which all are things that do not apply to Linux...
This is more than true!

However, this holds for any scheduler you may decide to consider,
especially if a real-time one.
A scheduling test is always based on a task model and, at least, with a
simple --completely preemptible, independent tasks-- model, EDF is
simpler than other solutions.

Obviously, if the model gets more complicated, more complicated analysis
has to be used, and again, this happen to all the schedulers you will
try to analyze.

> How much as we might like it to be, that is not (yet) the situation
> with the Linux kernel, far off.
>=20
> So we will still very much need the CONFIG_PREEMPT_RT patch
> to get closer to that ideal situation, and we still need to get rid of
> the BKL.
>=20
Independently from the above, I agree with you here, and in fact a
SCHED_EDF patch on top of PREEMPT_RT will hopefully come shortly, we and
some other guys are already at work on this! ;-P

> Now I ought to write fewer mails and look into solving that little
> problem... You don't happen to know if we can have a EU FP7
> project sponsored to rid out the BKL and switch and test drivers
> en masse to use threaded interrupt handlers do you? ;-)
>=20
Well, it's an interesting (applied) research topic, and I think there
still is a call for FP7 EU fundings! :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-obZqSfsoU6cI6uigClmN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq6NHQACgkQk4XaBE3IOsSpMQCfcaUtGtLeAs8R+w2AnMM+mD7K
GmAAn2VRVhHyaH4kilOKix/B5KUrIYgo
=9wDp
-----END PGP SIGNATURE-----

--=-obZqSfsoU6cI6uigClmN--

