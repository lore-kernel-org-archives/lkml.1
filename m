Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbZHBQ6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbZHBQ6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 12:58:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZHBQ6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 12:58:42 -0400
Received: from mail.open.by ([193.232.92.17]:51516 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753125AbZHBQ6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 12:58:42 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9223 [Aug 2 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Sun, 2 Aug 2009 20:01:20 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802170120.GA3181@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <20090802160532.GA25312@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20090802160532.GA25312@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/02/09 09:05), Greg KH wrote:
> On Sun, Aug 02, 2009 at 03:01:20PM +0300, Sergey Senozhatsky wrote:
> > Hello Linus, Ogawa,
> > Looks like we have one more bug in tty code:
> > 'shutdown -r now' in 'single' user mode gives following trace:
> >=20
> > WARNING at: drivers/char/tty_ldisc.c:209 tty_ldisc_put+0x95/0xa0
>=20
> Ugh, someone still has a ldisc reference somehow.  Does this happen for
> you on a "normal" boot and shutdown?
>=20

Hello Greg,
No, I can't see this while shutting down "normal" booted system.

	Sergey

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp1xmAACgkQfKHnntdSXjS0tAQAoV6+MWWn99Tv08HdNs5tun2/
rhfNrBjTQxgYPh5RJsvPwhTKOKKSdHvobVKw4fm6FmoJNyMKspJJo0M6O3O3WEjz
NBrrg7EgJ2yV5iMKF+j0912ujliwFVa4PUeh5zg9CeKYZUcDexUx+F/d1cHr+GlI
q2NrV7Am5zDVL7IlPcQ=
=90o1
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
