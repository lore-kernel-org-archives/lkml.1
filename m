Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZGOKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZGOKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 06:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZGOKZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 06:25:28 -0400
Received: from mail.open.by ([193.232.92.17]:55714 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZGOKZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 06:25:28 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9032 [Jul 15 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Info: {UDS BL}
X-SpamTest-Method: probable
X-SpamTest-Rate: 65
X-SpamTest-SPF: softfail
X-SpamTest-Status: Probable Spam
X-SpamTest-Status-Extended: probable_spam
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 15 Jul 2009 13:27:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090715102733.GA3055@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
 <20090711235530.GA3231@localdomain.by>
 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
 <20090714162837.GC3145@localdomain.by>
 <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/15/09 11:05), Alan Cox wrote:
> > Hello Alan,
> > I'm having another problem which I guess may be caused by pty/tty chang=
es.
> > The problem is that ppp connection constantly hangups under load (downl=
oading)=20
> > (it works perfectly with 30 kernel).
>=20
> Have you also got the unthrottle change reverted - without that revert it
> certainly will hang as you describe.
>=20

Hello Alan, do yo mean

drivers/net/ppp_async.c
commit a6540f731d506d9e82444cf0020e716613d4c46c
ppp: Fix throttling bugs

-       tty_unthrottle(tty);

I'll revert it and test.

Thanks,
	Sergey
--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpdrxUACgkQfKHnntdSXjSWNgQAms6TSKmdHCXVxI8pXP7PmC00
6Bsdvo+ElH9XMDUorjCQF+wAVlZi6Ww+EkZk69ZGtmN3eB7P8U3pFgZ7c5lRrhah
Ap6xd3F6/SFTxqmJbeVNkMFxo2od5Ga3qeg7xYj5aNJj2v9rKxjrTDcCQ4hHtiyp
+J8nFXCEvnR6aMafqp0=
=A+io
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
