Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbZGNOBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbZGNOBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 10:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZGNOBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 10:01:42 -0400
Received: from mail.open.by ([193.232.92.17]:57733 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbZGNOBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 10:01:41 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9024 [Jul 14 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Tue, 14 Jul 2009 17:03:49 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemleak hexdump proposal
Message-ID: <20090714140349.GA3145@localdomain.by>
References: <20090629201014.GA5414@localdomain.by>
 <1247566033.28240.46.camel@pc1117.cambridge.arm.com>
 <20090714103356.GA2929@localdomain.by>
 <1247567641.28240.51.camel@pc1117.cambridge.arm.com>
 <20090714105709.GB2929@localdomain.by>
 <1247578781.28240.92.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1247578781.28240.92.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/14/09 14:39), Catalin Marinas wrote:
> On Tue, 2009-07-14 at 13:57 +0300, Sergey Senozhatsky wrote:
> [...]
> > +/*
> > + * Printing of the objects hex dump to the seq file. The number on lin=
es
> > + * to be printed is limited to HEX_MAX_LINES to prevent seq file spamm=
ing.
> > + * The actual number of printed bytes depends on HEX_ROW_SIZE.
> > + * It must be called with the object->lock held.
> > + */
> [...]
>=20
> The patch looks fine. Could you please add a description and
> Signed-off-by line?
>=20

Sure. During 30-40 minutes (sorry, I'm a bit busy now). OK?
Should I update Documentation/kmemeleak.txt either?


> Thanks.
>=20
> --=20
> Catalin
>=20

	Sergey

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpckEUACgkQfKHnntdSXjTNKgP/Z2SFMRD4sQZU/JCn/3jgNszp
fsuN65FbX/iOVCpHSPzL0UwPSddxbangiYiEauiP1hRpZkRSscmT1W/pOEjI0fZB
UfK1AHdToB25pMIeyJJmDpOslwKOsJsFQ4IXa4ooz1RDkUjvDpnJfqyYYqYYHjNg
8qmx7ksiTEwFQX4eBF4=
=qewY
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
