Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbXDMMVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbXDMMVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 08:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXDMMVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 08:21:34 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:33470 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXDMMVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 08:21:33 -0400
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jiri Slaby <jirislaby@gmail.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
In-Reply-To: <200704131400.12021.rjw@sisk.pl>
References: <460B6E4B.3060004@gmail.com> <200704122336.57600.rjw@sisk.pl>
	 <4af2d03a0704130314s78d0d831ja52fe8f92efe097a@mail.gmail.com>
	 <200704131400.12021.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mkceuk3h5Uk8zTq6tD29"
Date: Fri, 13 Apr 2007 22:21:36 +1000
Message-Id: <1176466896.7112.159.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mkceuk3h5Uk8zTq6tD29
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-13 at 14:00 +0200, Rafael J. Wysocki wrote:
> >=20
> > Shrinking memory...  Pages needed: 128103 normal, 0 highmem
> > Pages needed: 125226 normal, 0 highmem
> > Pages needed: -5757 normal, 0 highmem
> > Pages needed: -5757 normal, 0 highmem
> > Pages needed: -5757 normal, 0 highmem
> > Pages needed: -5757
> > Pages needed: 127953 normal, 0 highmem
> > Pages needed: 125076 normal, 0 highmem
> > Pages needed: -6043 normal, 0 highmem
> > Pages needed: -6043 normal, 0 highmem
> > Pages needed: -6043 normal, 0 highmem
> > Pages needed: -6043
> > done (200 pages freed)
> > Freed 800 kbytes in 0.16 seconds (5.00 MB/s)
> > Suspending console(s)
> > ...
> > CPU1 is down
> > swsusp: critical section:
> > swsusp: Need to copy 131358 pages
> > swsusp: Normal pages needed: 131358
> > swsusp: Normal pages needed: 131358 + 1024 + 22, available pages: 13060=
7
>=20
> Well, it looks like someone allocated about 6000 pages after we had freed
> enough memory for suspending.

We have a tunable allowance in Suspend2 for this, because fglrx
allocates a lot of pages in its suspend routine if DRI is enabled. I
think some other drivers do too, but fglrx is the main one I know.

Nigel


--=-mkceuk3h5Uk8zTq6tD29
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGH3XQN0y+n1M3mo0RAuS5AJ9mug/OU4FsWTvpszg8pQfjo81lBQCfdZ5O
NpGLgwEnKMhXy3nkbqvSaYs=
=52K3
-----END PGP SIGNATURE-----

--=-mkceuk3h5Uk8zTq6tD29--

