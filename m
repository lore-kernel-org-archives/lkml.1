Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0BTIq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:46:59 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0BTIq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:46:58 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <a8e1da1002192342x7ca67176ta285db35ec6d34a6@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <a8e1da1002192342x7ca67176ta285db35ec6d34a6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-s1kmBr7O6mGEGqC2At2o"
Date: Sat, 20 Feb 2010 09:46:47 +0100
Message-ID: <1266655607.3790.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-s1kmBr7O6mGEGqC2At2o
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 15:42 +0800, Dave Young wrote:

> > Well, it used to not deadlock and actually shut down the machine :)
> So
> > in that sense it's definitely new. It might have printed a lockdep
> > warning before, which you wouldn't normally see since the machine
> turns
> > off right after this.
>=20
> before shutdown, you can:
> echo N > /proc/sys/kernel/printk_delay
> to see the printk messages, N is 0-10000 in milliseconds

Well if I understand Am=C3=A9rico correctly then it won't have printed
anything (even if it were to deadlock) before adding the lockdep
annotations to s_active, so I guess that theory is out.

johannes

--=-s1kmBr7O6mGEGqC2At2o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf6F0AAoJEODzc/N7+Qmapq4P/RfYApz3kzq4JaNFarqTspDD
M6Cy+4U7XPEqDCmgxhvmwL7eB/EVOBpoiq7b/My7pWsQFaY5TqvSzDoeYsUZaFWp
4Pf3FdQT1+vSjthTnqjm7GMFpguZ+M9/D1uKASu7IDPESLK7Mwjfnx02/WwQaUmj
pkXpYcW2k8nAJ2iyS3eMExvyYHaMl5WN7sBG5BWL3F1lApEExEEgJljPjyv9lV+U
YNbN6WPpGV1wtUnRB0J1plwpNQMvprzUxQ/3eruzVgIAZ5efhXJ+u65YjCOPpxlz
oCQUlk/I9pjTRpehw+e3JPa723kSv/1hcTB3YQTSChmWeSMb7vR5w36KDXCTKtkx
x4kRzID+G3+Urphr8Z9pP1U6sjvonIV+rPjG/h8fsz/9fzK5qR7QDXJ401yOl5xV
BCYSVMPK09fVX0bNfojeg2JotpHROHkHbY8A66/8kBZNFD16cOGKPcAropEw33l5
i2njxfqP9m4A5VFX0FoaYxPIoSDPHyaxr6vnlsZUZVowxnj64XsC5LgF0qE7P8U2
XSpEl1VWhBp2A706sxzoANGyta/gYi7+YVVY+PHu+tayTB9aT4MymS0Ydu2CU201
P+qN9dRNstvvSYAeT6BjaG1UAHmDwWO4+bXFReI8ymkUq6jtMqyRUNcY63N+RpMh
GWFk07TaXCFg5lIVgDkk
=dBYI
-----END PGP SIGNATURE-----

--=-s1kmBr7O6mGEGqC2At2o--

