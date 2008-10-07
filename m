Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYJGRI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYJGRI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYJGRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:08:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYJGRIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:08:50 -0400
Subject: Re: bad DMAR interaction with iwlagn and SATA
From: Johannes Berg <johannes@sipsolutions.net>
To: Kyle McMartin <kyle@infradead.org>
Cc: Andres Freund <andres@anarazel.de>, Tomas Winkler <tomasw@gmail.com>,
       Muli Ben-Yehuda <muli@il.ibm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081007170404.GB5171@bombadil.infradead.org>
References: <200809251511.20132.andres@anarazel.de>
	 <1ba2fa240809290140i5a47d534qa30f9088df834162@mail.gmail.com>
	 <1223296015.15196.2.camel@johannes.berg>
	 <200810061632.08375.andres@anarazel.de>
	 <1223368636.3778.64.camel@johannes.berg>
	 <20081007170404.GB5171@bombadil.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wsyw07jVLbAhv9X7WnUT"
Date: Tue, 07 Oct 2008 19:08:43 +0200
Message-Id: <1223399323.7328.51.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wsyw07jVLbAhv9X7WnUT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 13:04 -0400, Kyle McMartin wrote:

> 2MB pages (and 4MB pages) are dependent on PSE/PAE, there's no configurab=
le
> page size on x86 like there is on other platforms.
>=20
> PSE gives you 4MB pages, PAE reduces your 4MB pages to 2MB pages (for
> extra flag and address bits.)
>=20
> About the only useful places for these are large mappings like ioremap
> and whatnot.

Thanks for the explanation. Can you explain too why iwlwifi crashes when
I enable 64k pages? ;)

johannes

--=-wsyw07jVLbAhv9X7WnUT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI65eXAAoJEKVg1VMiehFYn5cP/2goTM4qQelVufRLQaMTXBXS
ODMuyveZb6EsGx10bvqtVCQX6xnHzAnx297dWon/VpjbKi2VPg6DKIcLryC3Lju4
lt/KqtsKFXUv5BP/Cp1CAZpYO22xsTizZeuToQWCpPLN88ysfAuBbnDgHIZHZh6y
mhYdxUtHgARU88tZl6gSR58ReNW9KNopy6JP2t82EPJMsZiNhcvdEQo+ceY9eJCt
GHIsqGSF9RrEKeUkpavUuZMbH9c6q+BqdM4PSElga/dUIlZaJV2xiU66XUXPCBlf
4mQeRQ/vK/a+LmJDDHZ1gjZ7Nyc9SOcFkItIIEjkDRdThKQTSg47koUBRBx4tbWz
NK3mRB3J6OAhM20J0HGLjiYFf2xb+vk6FrBbmbZzuRym3C6dxftZFIw90ueO6m4l
ifxyZQRt7iByjcbaIVxmwFzPyi+iQRtxErVJU9W0fH8HpETihP2jNchHA3+vhlKD
eMsR8zS2FK/iu76/tY8/Jsp5fVDbhDYIabSJ8ocpJF8zKA+IPeGdHcrdYzTnu4lc
S1uWgBDMhxafMGSZS+FZJiz5U8bUUTKSY+aPUgxka06ThLn4R44RP4VNRaHKwEFx
/esCw1F9kxYSt1jAdIFDJy/PicQ/Tq6R/DwUZUI3zSwanX8p/CufiBj6hEaofEEw
8SO0x0mkrJbqIx7HY+er
=DbQF
-----END PGP SIGNATURE-----

--=-wsyw07jVLbAhv9X7WnUT--

