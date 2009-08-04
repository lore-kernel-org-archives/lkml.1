Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbZHDA1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbZHDA1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 20:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZHDA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 20:27:20 -0400
Received: from mail.open.by ([193.232.92.17]:62730 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZHDA1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 20:27:19 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9235 [Aug 3 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 4 Aug 2009 03:30:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: proper tty-ldisc refcounting (was Re: WARNING at:
 drivers/char/tty_ldisc.c)
Message-ID: <20090804003009.GA3121@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
 <20090802190514.GA3278@localdomain.by>
 <alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
 <87k51l9apo.fsf@devron.myhome.or.jp>
 <alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
 <20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
 <alpine.LFD.2.01.0908031047010.3208@localhost.localdomain>
 <20090803181811.GA15848@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20090803181811.GA15848@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/03/09 11:18), Greg KH wrote:
> Ok, I'll queue them up if they pass Sergey's testing.
>=20
 =20
patch -p1 < tty_patch_1_2=20
patching file drivers/char/tty_ldisc.c
patching file include/linux/tty_ldisc.h
 =20
patch -p1 < tty_patch_2_2=20
patching file drivers/char/tty_ldisc.c
 =20
patch -p1 < tty_patch_3_2=20
patching file drivers/char/tty_ldisc.c
 =20
patch -p1 < tty_patch_4_2
patching file drivers/char/tty_ldisc.c
 =20
patch -p1 < tty_patch_5_2=20
patching file drivers/char/tty_ldisc.c
 =20
Works for me (SMP/non-SMP x86 builds). Great job.
 =20
Tested-by: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
 =20
 =20

On (08/03/09 15:25), Linus Torvalds wrote:
> Absolutely nothing to be sorry about - you've been an exemplary tester
> with very low latency. Thanks a lot.
Thanks a lot, Linus.


        Sergey

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp3gREACgkQfKHnntdSXjQDXwP9G6KJ5IjwPhTU4a+PsUTue8jN
8g9vcdiZeO88aHc+yjndH/pPTFUlZnSUEVslIlSeiZnC3Jp6nke+RISRedjGKFqs
DAUWDrTQKQutsjSpiJlHmIEqB0Y8Asu5nxT9C315V7A795lit/QgL0dGfz+D+x/x
2Sibzp86N0QEw5ChfRI=
=8Dmi
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
