Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZERQY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZERQY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbZERQYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:24:48 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39722 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbZERQYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:24:47 -0400
Subject: Re: iwlagn broken in next-20090514 and next-20090515
From: Johannes Berg <johannes@sipsolutions.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1242662635.32358.523.camel@rc-desk>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	 <20090515102621.GA5735@ikn.schottelius.org>
	 <20090518171505.d30d2f64.sfr@canb.auug.org.au>
	 <1242662635.32358.523.camel@rc-desk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mpAqau/H5D0XCUUjMzFm"
Date: Mon, 18 May 2009 18:24:27 +0200
Message-Id: <1242663867.27425.1.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mpAqau/H5D0XCUUjMzFm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 09:03 -0700, reinette chatre wrote:

> > > Also wpa_supplicant is not happy:
> > >=20
> > > + wpa_supplicant -B -Dwext -iwlan0 -c /home/user/nico/ethz/wlan/wpa_s=
upplicant.conf
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > >=20
>=20
> There were some changes recently to this ioctl, but I am not familiar
> with details. Johannes will know.

Yeah, I'm not sure -- this happens when clearing keys. I'll look into
it, we probably need to accept removing a key that doesn't exist.

johannes

--=-mpAqau/H5D0XCUUjMzFm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEYu4AAoJEODzc/N7+QmahigQALS7Q1Nq1UDZbfhvDXGU+Swo
TvooX7SRRfQrP5TNiKN6tmAQjjv1SOvKbi5qGvFBnzadOVdQ788AjN+VeNug4aeP
Qn+x/9ZiLK8nQoSAoaSBAp/ypMdjBxEIjS/nNoT4Atkt4B92hs0uuMnlSLch6JJe
eHu412JA4yg5zUbmbHzww9PcPB1voUtW4CT+wAWXiRwhdCRWL4wIO+Onx4whm1cu
TFz2PhIirej8QJNR3GiKln5Z/TrFB0ZGfgE83crPvrOFCsvG4fobIBb5zxuYcpcw
zP7Zn895gDYR5wKacQ6u8qs6BVSTLyJXju2aJfGMpc7oQ806ZKYgLNuo3Yo3gPc2
jPgXfl36ZWXVNSQwnUF/FYXcodJuSW4FoP9SIqwHZOsR6vOVNh/wlS3zD0jARBTp
3LGs4zJbEznzLyFSK7g8XmMLyqRJuWqETPfFYEplIGFyqC5BobjnPd2bq+zhrEz/
sh3kP0inEgygQueJNl4qWAFmxSvSO7ZJ5dog6/6foM4BkOrZSu6Bi+RB7+tKN/hc
dUqj1yUXlxxTZjrD1yr6OI5IfdFw8XEtTtrV7F3HR/aGLLyP5s2HJdgqdpNrT/Uw
kNdaLWmrQM5TJzqHJRCU2hWqQZ4YEICSyqHQ2eWh3e8CfRPmeoaXz+wXuAjKEglf
PGvsv9xQpm4iF77eVY6L
=wP09
-----END PGP SIGNATURE-----

--=-mpAqau/H5D0XCUUjMzFm--

