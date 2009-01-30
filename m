Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbZA3JmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbZA3JmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZA3Jl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:41:59 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36445 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbZA3Jl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:41:58 -0500
Subject: Re: [PATCH] w35und: fix registration with wlan stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Bruno Randolf <br1@einfach.org>
In-Reply-To: <20090130093846.GC9495@atrey.karlin.mff.cuni.cz>
References: <497F5FEA.7020203@gmail.com> <20090127200602.GA16444@elf.ucw.cz>
	 <4980B2DD.307@gmail.com> <4980BB9A.2020309@cs.helsinki.fi>
	 <4980C028.2030709@gmail.com> <4980C035.4070105@cs.helsinki.fi>
	 <4980DB5D.6010906@gmail.com> <20090130090525.GA1997@elf.ucw.cz>
	 <1233306825.13655.28.camel@penberg-laptop>
	 <1233306980.4161.19.camel@johannes.local>
	 <20090130093846.GC9495@atrey.karlin.mff.cuni.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D9ODfc8eHNVXZUYtAPf6"
Date: Fri, 30 Jan 2009 10:41:51 +0100
Message-Id: <1233308511.4161.23.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-D9ODfc8eHNVXZUYtAPf6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-01-30 at 10:38 +0100, Pavel Machek wrote:

> > > >  	dev->channel_change_time =3D 1000;
> > > > +	dev->max_signal =3D 100;
> > >=20
> > > And the IEEE80211_HW_SIGNAL_UNSPEC and ->max_signal from commit
> > > 566bfe5a8bcde13188a356f77666f8115813cf31 ("mac80211: use hardware fla=
gs
> > > for signal/noise units"). Lets cc Bruno.
> >=20
> > Seems reasonable, though does it would be good to see if it can do DBM,
> > which we very very much prefer.
>=20
> Well, currenlty it reports all zeros...

In that case you shouldn't do this patch to avoid userspace getting
bogus values.

johannes

--=-D9ODfc8eHNVXZUYtAPf6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgstbAAoJEKVg1VMiehFY0noP/0vFnVs2QGmDbTXLQQEBkQ/w
VX5hhDLErqHmpiUGU318iubus0T/FtdCw2FzAiPYJjGBq4NQQpCz2ZhfZKCK/5Mo
FkQtgKsAn9ppQYMzAEeYOwNFwQo6AO41Bm64vPLor4je9aMGJdl16TbIZgFGiaQS
UXeg7FkSwqs96Or1EmRtpu2DjsiM7FxILlCkBKli1FdmdHepYlAvsEGMW/wqdxA5
6u5qSz7c2yBateCbkCzYnMNvPDClj3fOvn6W67naiK8x2MMpfgRc4uF+T/diU2QU
cduivh2dD5moLWLUG4RhYeDXoXpr6m2GgZeyS9Saeek5F3XvmvHVYrEjuL4KwjTC
6zOyzMTduvc8xWqpl6OV8ftkNwLL2Wvw+JxiJMkGXP+E+cuTIq7WE8w5MZrTu82G
hQGXAMbzU3K5a9W2Wxkv9lr+PrG1amyp/ye9m8hZMo1VQJc3PWSs6ufYxXvnw43I
sH+h90lCrhxowchd7UliL7WiL0FE7CkiJ/HnGaKALxDir1a6VqMfJeVH13j+lC4G
oCzPYVp+FRvIjawHDHCLyQuxJqpVfB19jr3fTrROcfcjKa59ShAqgCdhO6Z8ybjy
3VYVO8ofcjS7N8N8T76R08ceFrBzRVA/4FkGTs8PpKEj95sE5GOzOn+i/vfS/tHs
oKapp8q9JXiq5jo36R+N
=jKgQ
-----END PGP SIGNATURE-----

--=-D9ODfc8eHNVXZUYtAPf6--

