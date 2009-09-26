Return-Path: <linux-kernel-owner+w=401wt.eu-S1751292AbZIZG4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbZIZG4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 02:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750880AbZIZG4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 02:56:11 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59285 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750852AbZIZG4K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 02:56:10 -0400
Subject: Re: massive_intr on CFS, BFS, and EDF
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       sat <takeuchi_satoru@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1253918258.18939.192.camel@laptop>
References: <4ABC068A.6070704@jp.fujitsu.com>
	 <4ABCEABC.4050200@gandalf.sssup.it>  <4ABD36CE.3080400@nortel.com>
	 <1253918258.18939.192.camel@laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OPjqHAchiic8FgKPzieA"
Date: Sat, 26 Sep 2009 08:56:11 +0200
Message-Id: <1253948171.4924.14.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OPjqHAchiic8FgKPzieA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-09-26 at 00:37 +0200, Peter Zijlstra wrote:
> On Fri, 2009-09-25 at 15:31 -0600, Chris Friesen wrote:=20
> > Do you allow oversubscription with EDF?  It would seem so based on thes=
e
> > results.  Would it maybe make sense to disallow oversubscription, or
> > make it an option?
>=20
> afaiu he doesn't,=20
yeaah, as explained in the previous mail, this is in place only if group
scheduling is on since now, but I'll add these bits to non-group
solution, aalready planned that. :-)

> he simply splits the task's wcet between parent and
> child and (intends?) to feed back on child exit.
>=20
yes again, that's what the submitted patch does, which is an arbitrary
choice among all the non-optimal solutions I'm able to think of, as
explained in the first e-mail! :-(

Now, I'm going to give your suggestion of assigning children 0 bandwidth
a shot, and ask the parent (they can't they have no bandwidth!) to give
them some runtime/deadline to make them run.
This also has some issues, I think, but looks more natural... At least
does not affect parent's bandwidth, possibly reducing it to (almost)
0!! :-(

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-OPjqHAchiic8FgKPzieA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkq9uwsACgkQk4XaBE3IOsQJiwCgjCSwcX0m9f1b9ym3Uzcocsl7
oJ8AnReif+NpgZ0a5w1k9SSDJQEfCK2a
=mCut
-----END PGP SIGNATURE-----

--=-OPjqHAchiic8FgKPzieA--

