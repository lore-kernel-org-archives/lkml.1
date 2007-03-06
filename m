Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbXCFNJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbXCFNJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933914AbXCFNJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:09:30 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:57411 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbXCFNJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:09:29 -0500
Subject: Re: Problem with freezable workqueues
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
In-Reply-To: <200702272251.28844.rjw@sisk.pl>
References: <200702272251.28844.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mtulcmuYQEa/J9wRz5To"
Date: Tue, 06 Mar 2007 01:30:19 +0100
Message-Id: <1173141019.15891.39.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mtulcmuYQEa/J9wRz5To
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-02-27 at 22:51 +0100, Rafael J. Wysocki wrote:

> For 2.6.21-rc1 I've invented the appended workaround (works for me, waiti=
ng for
> Johannes to confirm it works for him too), but I think we need something =
better
> for -mm and future kernels.

Finally I could get back to this but after reading the thread I figured
it might not be necessary to test this. Please let me know ASAP if you
want this patch tested as well or it'll take quite a long time (going
skiing for a week on Saturday)

In any case, I made the two xfs workqueues non-freezable and everything
on my quad powermac works again, I also couldn't detect any filesystem
correction. I wanted to adapt the BUG_ON(block IO not from suspend code)
patch from suspend2 but haven't gotten around to it yet.

johannes

--=-mtulcmuYQEa/J9wRz5To
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7LYb/ETPhpq3jKURAnJ2AKCAK+hM7+Lkf7GJ65471DYySCYNFgCgrG+H
jSGr6rqxF/UxHaXBfKWJssU=
=+oSe
-----END PGP SIGNATURE-----

--=-mtulcmuYQEa/J9wRz5To--

