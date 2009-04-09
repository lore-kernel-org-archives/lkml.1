Return-Path: <linux-kernel-owner+w=401wt.eu-S935315AbZDIPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935315AbZDIPfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbZDIPf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:35:26 -0400
Received: from nn7.de ([85.214.94.156]:32852 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757809AbZDIPfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:35:25 -0400
Subject: Re: 2.6.29+ ath5k connect disconnect cycles?
From: Soeren Sonnenburg <sonne@debian.org>
To: "\"Markus" =?ISO-8859-1?Q?Ko=DFmann=22?= <mkossmann_ml1@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Tulio Magno Quites Machado Filho <tuliom@quites.com.br>
In-Reply-To: <20090407102927.225890@gmx.net>
References: <1239008128.32048.211.camel@localhost>
	 <20090406195544.GA3542@joutaro.rooms.iriga>
	 <1239097961.32048.484.camel@localhost>  <20090407102927.225890@gmx.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4c8jnvrIoDfjccsyDo4B"
Date: Thu, 09 Apr 2009 17:35:13 +0200
Message-Id: <1239291313.8961.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4c8jnvrIoDfjccsyDo4B
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 12:29 +0200, "Markus Ko=DFmann" wrote:
> > On Mon, 2009-04-06 at 21:55 +0200, Tulio Magno Quites Machado Filho
> > wrote:
> > > On Apr 06 09 10:55, Soeren Sonnenburg wrote:
> > > > does anyone else observer strange connect disconnect cycles with
> > ath5k?
> > > > I have two different notebooks here one with an AR5414 and one with
> > some
> > > > 2424 (?) chipset both having the same problems to connect...
> > >=20
> > > Hello Soeren,
> > >=20
> > > Is there any information from dmesg?
> >=20
> > I am seeing cycles of
[connecting and reconnecting]
> > Not sure about the involvement of network-manager here... but I see tha=
t
> > the device gets a valid IP via dhcp.
> >=20
> I've seen such cycles also with intel ipw5300 WLAN and using ifconfig to =
start the network. To get WLAN working again, I have to ifdown wlan0 , unlo=
ad and reload the driver module and  finally ifup wlan0. So it's probably n=
either a ath5k nor a network-manager problem.

A rmmod ath5k / reload didn't help in my case.

Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-4c8jnvrIoDfjccsyDo4B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkneFaoACgkQ/h9eL9HisW/HmwCggeYk/jhs9fSwxuHQdS5LdnIU
MqsAn2ozdbcHOvUipbNYRrBaj8YDJ330
=0gu7
-----END PGP SIGNATURE-----

--=-4c8jnvrIoDfjccsyDo4B--
