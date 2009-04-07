Return-Path: <linux-kernel-owner+w=401wt.eu-S1757467AbZDGNP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbZDGNP1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbZDGNOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:14:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51941 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964AbZDGNOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:14:04 -0400
Subject: Re: attempt to scan fails (device busy) if essid/ssid was changed
 recently
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1239109497.15015.12.camel@maxim-laptop> (sfid-20090407_150534_375314_4DA28551)
References: <1239062401.4705.23.camel@maxim-laptop>
	 (sfid-20090407_020013_939126_90578556)  <1239092296.22453.1.camel@johannes.local>
	 <1239108689.15015.3.camel@maxim-laptop>
	 (sfid-20090407_145137_740898_8D0C40FD)  <1239109001.22453.40.camel@johannes.local>
	 <1239109497.15015.12.camel@maxim-laptop>
	 (sfid-20090407_150534_375314_4DA28551)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-M74qu0Gb2BZ7cPztZp/z"
Date: Tue, 07 Apr 2009 15:13:30 +0200
Message-Id: <1239110010.22453.41.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M74qu0Gb2BZ7cPztZp/z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 16:04 +0300, Maxim Levitsky wrote:

> > > > > Looking a bit deeper I discovered that each time NM disconnects f=
rom a
> > > > > networks it sets random ssid/essid to the card (using wireless
> > > > > extensions)
> > > >=20
> > > > This forces a scan
> > > >=20
> > > > > After that scan fails for some time.
> > > > >=20
> > > > > as a NM free example you can run=20
> > > > >=20
> > > > > iwconfig wlan0 essid dummy
> > > > > iwlist scan
> > > >=20
> > > > and then this fails with EBUSY.
> > > Thanks for explanation.
> > > Since NM has its reasons to clear essid (to prevent unwanted
> > > association), then what can be  done to prevent this (and still use
> > > wireless extensions, since nl80211 support isn't yet mature)?
> >=20
> > Nothing. Wext sucks, news at 11, yadda.
> Thanks.
> Everything understood.

Of course, we can go back to dropping the scan request, but that
wouldn't be very nice.

Is this creating any problems?

johannes

--=-M74qu0Gb2BZ7cPztZp/z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ21F4AAoJEKVg1VMiehFYBPQQAIwMkG6bhZm4TxYnAC7UBT2+
gmGmcjU7ewhnlAuJjeKAjsznvD/KovTV8fY3J+EzKAE0TJ4ix8CaUFpZvSF74ZRc
MBw/XoothpoxoqmI4q+H/huNVoVHRY/c7xMzgP7EXUElB0qOJGrMelO2eJS0l0uz
HE5uHkqhsbDAE44QVfRZTADGj3B8eXseuSWKnqLE7nQsiMJMh7O4L+nFBaVIJ7dL
CdTmFoDvAMjPKNeK+tMeSDDiaF+8oRjhvwhcVaj5VDyNQKJa8ekzXubA7lAespF+
/SdsxqUdrIPBGZk6694ls6/HJ/bzJGuVwtlmyJz+EShAH9yLIDEAxjnz0bUumIPJ
3odR4kIMvSLQh2r0VCX/8jlhcIDGeYEni1oBWUatO85I9h708G3zhsHP3V/bfGoU
3GbUy++jpvNvNjgUvW2kVM+5j4jVhTqRFfnELJBxRqvEIDvU7hIHElrpIr98DaI4
yvkgqSeUkRdyU95rmWWC04dk5e3UnsHsUFmeSCUubaGJ+lqcKIxgnT7tDHYtquhn
ns2mlVa7jJunLWReZall8kF53ilh0wAlDNt32pUY3lNMkume4X5V6wFslVv/3dPI
9ysir9brQ4LAPwtaz8a+mAFTZPdxoDK2X3j3z7lVqb78R3G+Q7HaiXB/4Fs2rbwp
gn+ohGiveTg42UzDUZ+Y
=dXuV
-----END PGP SIGNATURE-----

--=-M74qu0Gb2BZ7cPztZp/z--

