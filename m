Return-Path: <linux-kernel-owner+w=401wt.eu-S1752662AbXB1ABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662AbXB1ABV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 19:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932065AbXB1ABV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 19:01:21 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:33399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbXB1ABQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 19:01:16 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Gautham R Shenoy <ego@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <200702280100.36649.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
	 <20070227232855.GA457@tv-sign.ru> <1172619412.3681.11.camel@johannes.berg>
	 <200702280100.36649.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rruhtUAhlkKY4+mau4FK"
Date: Wed, 28 Feb 2007 01:00:44 +0100
Message-Id: <1172620844.3681.17.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rruhtUAhlkKY4+mau4FK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 01:00 +0100, Rafael J. Wysocki wrote:

> > > How about other kthread_stop()s ? For example, kernel/softirq.c:cpu_c=
allback() ?
> >=20
> > I'd they should be affected as well.
>=20
> They won't be, if they have PF_NOFREEZE set.

Yup, I missed that.

johannes

--=-rruhtUAhlkKY4+mau4FK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5MYs/ETPhpq3jKURAhKLAKCFu57DTTBxYDjT/E6bl5VykpCStwCbBOQk
Vs4i9oA+4JaR8liU45Xe97E=
=7f2E
-----END PGP SIGNATURE-----

--=-rruhtUAhlkKY4+mau4FK--

