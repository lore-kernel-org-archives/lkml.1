Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbZHBRFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbZHBRFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 13:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZHBRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 13:05:11 -0400
Received: from mail.open.by ([193.232.92.17]:58373 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbZHBRFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 13:05:10 -0400
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
Date: Sun, 2 Aug 2009 20:07:54 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
Message-ID: <20090802170754.GB3181@localdomain.by>
References: <20090802120120.GA3097@localdomain.by>
 <20090802160532.GA25312@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20090802160532.GA25312@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kXdP64Ggrk/fb43R
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

Sorry, I forgot to mention: rc5

	Sergey
--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkp1x+oACgkQfKHnntdSXjSp6wP+LOv3xZr8goKF9ylgam8Fu8wO
ML0m0a2buuzMIiCx/9kx3dfHFFntALU5h8s/OfyLRfv9ZsoN9RUNU1SAId9xHVEN
/63mFe1dSBvgovo0TCKNEeG11KvdjjL3lhHA4PISUvie4+N7wNSPop8gDryQluwB
Vuapv8+0sZgyFLb28SA=
=3o+/
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
