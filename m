Return-Path: <linux-kernel-owner+w=401wt.eu-S1751699AbXCHPc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbXCHPc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 10:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbXCHPc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 10:32:28 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:57053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXCHPc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 10:32:27 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <200703062131.23465.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
	 <1173141019.15891.39.camel@johannes.berg>  <200703062131.23465.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N7X/cEe+/GVxUJFjMJZu"
Date: Thu, 08 Mar 2007 00:10:45 +0100
Message-Id: <1173309045.3546.7.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-N7X/cEe+/GVxUJFjMJZu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-06 at 21:31 +0100, Rafael J. Wysocki wrote:

> For now, we have decided to make the workqueues nonfreezable (the patch f=
or
> that has already been merged, AFAICT).

It isn't in 2.6.21-rc3.

> > I wanted to adapt the BUG_ON(block IO not from suspend code)=20
> > patch from suspend2 but haven't gotten around to it yet.
>=20
> That might be a good idea for other reasons too, but I'd prefer WARN_ON()
> instead of BUG_ON() when you're at it. ;-)

I won't be able to do that for quite a while... It's just on my "future
projects that would be nice" list :P

johannes

--=-N7X/cEe+/GVxUJFjMJZu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF70Z1/ETPhpq3jKURAlRoAJ9Fj8J+K3EpEBxuOVUAXJnYTnzvtwCfYqtR
6RgJJ1Ub89uOW5neZfl+2/Y=
=91zM
-----END PGP SIGNATURE-----

--=-N7X/cEe+/GVxUJFjMJZu--

