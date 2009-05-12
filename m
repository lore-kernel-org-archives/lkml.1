Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZELQqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZELQqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 12:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZELQqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 12:46:01 -0400
Received: from ms01.sssup.it ([193.205.80.99]:34332 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752766AbZELQqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 12:46:00 -0400
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
From: Raistlin <raistlin@linux.it>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: Chris Friesen <cfriesen@nortel.com>, Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A09A525.4080107@sonarnerd.net>
References: <4959198A.3020209@sonarnerd.net>
	 <1230622925.16718.26.camel@twins>  <4959DE51.2020605@sonarnerd.net>
	 <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net>
	 <4971D3D5.6040801@superbug.co.uk>  <497CF128.2060903@sonarnerd.net>
	 <1232954745.4863.4.camel@laptop>  <4A07E044.8040807@sonarnerd.net>
	 <1242107859.11251.301.camel@twins> <4A094707.5040307@sonarnerd.net>
	 <4A099670.5060902@nortel.com>  <4A09A525.4080107@sonarnerd.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SX5SXAnY5hJnWbMcl8XF"
Date: Tue, 12 May 2009 18:45:58 +0200
Message-Id: <1242146758.4792.19.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SX5SXAnY5hJnWbMcl8XF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 19:34 +0300, Jussi Laako wrote:
> Chris Friesen wrote:
> > If all you're trying to do is allow different threads to run at
> > different nice levels, what about extending sys_setpriority() to take a
> > "which" of PRIO_THREAD?  We'd probably have to call the syscall directl=
y
> > until/unless libc picks up the new option.
>=20
> How would this be mapped to a POSIX standard API? I would like to see
> something which works straight out with
> pthread_setschedprio()/pthread_getschedparam(). In order it to work
> correctly it also needs sys_sched_get_priority_min and
> sys_sched_get_priority_max.
>=20
Well, I'm not sure I can see why, since nor a "SCHED_MM" scheduling
policy, nor having priorities for SCHED_OTHER (different from nice
levels) is _not_ POSIX compliant, is it?

Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-SX5SXAnY5hJnWbMcl8XF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoJp7sACgkQk4XaBE3IOsQGPACfX7AUFGQ9I5bbjrJGBzgnN4nm
Z38An0N/E6qFtftzNBOoqM5bbUYYgse2
=juVI
-----END PGP SIGNATURE-----

--=-SX5SXAnY5hJnWbMcl8XF--

