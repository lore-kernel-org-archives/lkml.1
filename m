Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0BDI3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:29:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44252 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787Ab0BDI3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:29:38 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@kernel.org, LKML <linux-kernel@vger.kernel.org>,
       stable-review@kernel.org
In-Reply-To: <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
References: <1265245849.3362.1.camel@localhost>
	 <1265256174.2952.11.camel@localhost>
	 <alpine.LFD.2.00.1002032135380.3707@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eVL9LJF7p1Mu7GCrJC3r"
Date: Thu, 04 Feb 2010 08:29:34 +0000
Message-ID: <1265272174.2952.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eVL9LJF7p1Mu7GCrJC3r
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-03 at 21:39 -0800, Linus Torvalds wrote:
>=20
> On Thu, 4 Feb 2010, Ben Hutchings wrote:
> >=20
> > I'm using Debian i386 (i.e. 32-bit userland) with a 64-bit kernel.
> > After applying commit 221af7f to Debian's kernel source (approximately
> > equivalent to 2.6.32.7), the kernel fails to exec init.  After commit
> > 7ab02af it can exec init but that immediately segfaults:
>=20
> It sounds like you have picked individual commits.

Yes - I'm one of the kernel package maintainers and we're sticking with
2.6.32-stable.

> But you don't mention commit 05d43ed8a, which is also a required part of=20
> the series.
>=20
> So you _should_ have a combination of
>  - 221af7f87 ("Split 'flush_old_exec' into two functions")
>  - 05d43ed8a ("x86: get rid of the insane TIF_ABI_PENDING bit")
>  - 7ab02af42 ("Fix 'flush_old_exec()/setup_new_exec()' split")
>=20
> (and there are also additional sparc/ppc versions of that TIF_ABI_PENDING=
=20
> bit removal, but they shouldn't matter on your system)

Thanks.  If all the necessary patches are all in the stable queue then
we can pick them from there.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-eVL9LJF7p1Mu7GCrJC3r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS2qFaee/yOyVhhEJAQKtDA//aKmJfjQ0JzDVaMQDjE7hEiJmYqvohS14
3vozJN0TQY/II55sSkOkNU7xi2Zlmi5i4Z7pRXsdkIas5EgyXnDnNKcw7IxIjiwB
sP0Wb+GAvmFf6Aqw/nsM9cy/C0XCxkzFNLJFpjBgONeqGsmAQSvOB0G66f+x8T3w
P7QdyQLfNSpfM2Zu9Kl6CUjb9mQ9yzQUh3urfpT/eYPWAlFDjOfYkkph2aLqC8GG
5Rp+3N1KJ0BIycYOJCqVAx/HdHTVP2/QmoyCk5k4PvYcWHVlmLDcDb4/3k5HK7pZ
7MXd46MII9i+sG21dHpLQ9gzQHPkhp0zkajoD9i3EKkxaB9SrBDI2dyGeoWl5SBl
yy6amz1udvsyn7YhJS20WhGWc5jZLLskQjgYfrzpEIGzTD6APUYiM9F1zv3Iac1m
cyA9omJPqg6lspxWrp1miy8qKQVKKBwxIEJjw68D7TovUqru69gJ6O5jV3YyyYDN
BsJ5HOkq+f7dJ1VfAey8zA5pQP2HSntdo7ZeYZf4kkfvw/dIGTorTtKvG/0K3X9Y
AlWQBxaJcDzTQGILJDiiZlBUhxPbm75RKlM+Ku+QgEG7E2qUsQ1qmngT3n5rVASc
H1b8PN1x4two3pHaaLh7WnCW1NFGYRyUPAaWa6zo/dsGCilw1mQXJR0cO161H67U
6rv8J7WCeUk=
=oTxG
-----END PGP SIGNATURE-----

--=-eVL9LJF7p1Mu7GCrJC3r--
