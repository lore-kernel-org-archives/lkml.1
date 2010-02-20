Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab0BTMHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 07:07:42 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:39764 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0BTMHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 07:07:40 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1266665331.12525.0.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UibS8yTvvs8/u5Q0vAU6"
Date: Sat, 20 Feb 2010 13:07:32 +0100
Message-ID: <1266667652.12943.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UibS8yTvvs8/u5Q0vAU6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 12:28 +0100, Johannes Berg wrote:

> It deadlocks after
>=20
> Disabling non-boot CPUs ...

I suspect the BUG: key not in data! thing I get now disables lockdep (it
seems to be mostly due to module loading btw) and then I don't get any
output here.

Seems it's all busted.

johannes

--=-UibS8yTvvs8/u5Q0vAU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf9CBAAoJEODzc/N7+Qmab2kQAMGkAPlVneT9LwPfj0p51fZe
6J0PZO+Yo35T92h9LPHy/lp5Vsp0cxZRFuhOq6CTmnWlwsdVahxfp4ET0s4EauFK
e7TZY0OY3bG6FE7giHLtsbnec4mOeR2FEW0670RUcUtDXpTxRwUwobPqHYSLJYe0
E3IqpLNo3ish6rXLApk/q+6n9bFy3+9LBdpvO6iXFdrDsHe3alYQTiHDTmnR1f+j
MTVGm9eXjdVBV7/1fjpB3a7yS0Bf+PpK3gy5g4em7Io0TuqPmQxh7dGoYErIySLw
LvtHC1kEfuIEEnv8LP+0x0BnCA2Xs8JlDdAhcvZIhvTHzVce0rn5T1hofB8Jl4qr
x+vFq33Tm0EGRTLablq0TeyUHNgxOlt+iRteoBEvn1pn/7vedkfT+y7eGaShhTFl
+oySM/UBN0uKDrqTWcEwJhtyvjWw11XJ/Og5Wye+q2wsguQUr+A28GNXUD31HRmA
tc2Kn0y8dGWa+rjUxebmnbd3O+KyHIZC0OYkiVBF4uiXnYXKHTprLz1KpwJS2m7r
aIWDAYG/16kmfL3DtvcMi0XW9/B/e6hxdbFcoIa1CcF8HGFDFZAkp8QdhWjG+Jy/
WpeRmIp83DkgsEbJnYtdrBJxN7AisvhlXdEkJk8HhjAtLyWSTWLGUG1tyHTBrtxs
CKuu4kPYV9MRJgInOzo/
=HvbB
-----END PGP SIGNATURE-----

--=-UibS8yTvvs8/u5Q0vAU6--

