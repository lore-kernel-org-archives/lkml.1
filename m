Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbXB0Xh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbXB0Xh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 18:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXB0Xh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 18:37:28 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:60876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbXB0Xh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 18:37:27 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <20070227232855.GA457@tv-sign.ru>
References: <200702272251.28844.rjw@sisk.pl>
	 <20070227232855.GA457@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-M19pFw2T1iBjdc5XusLF"
Date: Wed, 28 Feb 2007 00:36:52 +0100
Message-Id: <1172619412.3681.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M19pFw2T1iBjdc5XusLF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 02:28 +0300, Oleg Nesterov wrote:

> Ugh. I know nothing, nothing, nothing about suspend. I'll try to guess.
>=20
>    Commit: ed746e3b18f4df18afa3763155972c5835f284c5

> Yes? with the patch above, _cpu_down() called _after_ freeze_processes() =
???

perfect :)
See also my original mail and the thread:
http://thread.gmane.org/gmane.linux.power-management.general/4314

> How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_callb=
ack() ?

I'd they should be affected as well. For me, I guess I haven't run into
them because xfs is enough to freeze the box ;) As for Rafael, I don't
know why he isn't seeing that... I haven't been able to test this patch
on my quad powermac so far unfortunately, been sick and away from the
machine. I'll probably be able to test tomorrow.

> I think we need a general "cpu_down() after freeze" implementation,

Yeah, I'd think so.

>  this is what
> Gautham and Srivatsa are working on, right?

That I don't know.

johannes

--=-M19pFw2T1iBjdc5XusLF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5MCU/ETPhpq3jKURAlssAJ9DTSZS4ryU8tX/epyMqul6ykkv1ACglgya
2FSpYH+Jsc2Snmy/kqBhxJU=
=qEJ8
-----END PGP SIGNATURE-----

--=-M19pFw2T1iBjdc5XusLF--

