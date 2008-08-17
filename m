Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYHQW2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYHQW2m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYHQW2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:28:34 -0400
Received: from ms01.sssup.it ([193.205.80.99]:39566 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751758AbYHQW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:28:34 -0400
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Dario Faggioli <raistlin@linux.it>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <48A0741F.60901@redhat.com>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>  <1218464753.10800.92.camel@twins>
	 <1218471794.6450.87.camel@Palanthas> <1218472252.10800.107.camel@twins>
	 <48A0741F.60901@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jIEH6uqDGSKEHj/hMICS"
Date: Mon, 18 Aug 2008 00:27:31 +0200
Message-Id: <1219012051.25992.31.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jIEH6uqDGSKEHj/hMICS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-11 at 10:17 -0700, Ulrich Drepper wrote:
> > Well, a new version of glibc could use those to implement the posix
> > interface. Because as I understand it, glibc can break ABI on certain
> > version bumps.
>=20
> In theory.  But this hasn't happened so far and I don't expect it to
> happen any time soon.  New interfaces are not a real problem for me, thou=
gh.
>=20
Ok, we'll see.
I still think that SCHED_SPORADIC task (but specially group!) scheduling
could be useful, even with a non fully-POSIX interface.

This mail only to say that I'm actively working on it, i.e., I'm
rewriting it with the new sched_param2/sched_setscheduler2 interface and
fixing some very glaring bugs that was present in my first code. :-P

Unfortunately, I'll be off the PC till September 4th... If you are still
interested in, we will talk about it at that time, when I'll post the
new version of the RFC.
I also hope, by then, to be able to show you some test cases and
overhead estimation.

Thanks all of you for minding me, and sorry if I wasted some of your
time. :-)

Best Regards,
Dario

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-jIEH6uqDGSKEHj/hMICS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIqKXSk4XaBE3IOsQRAplEAJ49mHe9YPlM4UDzd60gyOfSusOgvACcCc0V
YdoUP3WZCYT3wZcVYSHBk70=
=eUC7
-----END PGP SIGNATURE-----

--=-jIEH6uqDGSKEHj/hMICS--

