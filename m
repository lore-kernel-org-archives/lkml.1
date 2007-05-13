Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbXEMX0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbXEMX0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 19:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761237AbXEMX0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 19:26:06 -0400
Received: from mx.laposte.net ([81.255.54.16]:49859 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761122AbXEMX0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 19:26:05 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070513154718.bb338ceb.akpm@linux-foundation.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aBgjzX0C4JXxyHdccFZK"
Organization: Adresse perso
Date: Mon, 14 May 2007 01:25:42 +0200
Message-Id: <1179098742.7322.5.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.nim.2) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aBgjzX0C4JXxyHdccFZK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le dimanche 13 mai 2007 =C3=A0 15:47 -0700, Andrew Morton a =C3=A9crit :
> On Sun, 13 May 2007 14:02:50 -0700 bugme-daemon@bugzilla.kernel.org wrote=
:
>=20
> > http://bugzilla.kernel.org/show_bug.cgi?id=3D8473
>=20
> Please follow up via emailed reply-to-all.
>=20
> In fact, please report -mm bugs via email.  bugzilla is more suited to
> longer-term problems, and -mm bugs are super-short-term, we hope.

Can't attach trace screenshots or long log dumps to mails :(

> May 13 22:59:43 rousalka kernel: Unable to handle kernel NULL pointer
> dereference at 0000000000000000 RIP:=20
> May 13 22:59:43 rousalka kernel: [<0000000000000000>]

> Anything you can do to make that wordwrapping go away for ever would be
> great, thanks.

You have the full kernel log with no wrapping there
http://bugzilla.kernel.org/attachment.cgi?id=3D11492

> I don't know what would have caused this.  do_ioctl() did a jump-to-zero,
> but it has code in there to explicitly test for null pointers.
>=20
> Perhaps some weird race, although I find it hard to imagine how we could
> have such a race in any ioctl which bash is likely to be calling.
>=20
> Is it repeatable at all?

It happened once so far. The load was moderate (and certainly not
comparable to what I did for Mel yesterday)

--=20
Nicolas Mailhot

--=-aBgjzX0C4JXxyHdccFZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZHnnAACgkQI2bVKDsp8g0Y0QCgqeqpB/D72jPA0jlhSQW4KtUN
IX4An05FEJQAOdK4lZW9LWnZcQPqzg9u
=7fUw
-----END PGP SIGNATURE-----

--=-aBgjzX0C4JXxyHdccFZK--
