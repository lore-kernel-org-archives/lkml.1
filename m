Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZF2Jxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZF2Jxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759324AbZF2JxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:53:24 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723AbZF2JxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:53:23 -0400
Subject: Re: [2.6.31-rc1] iwlagn (4965): regression when hardware rf switch
 is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200906291148.55386.elendil@planet.nl>
References: <200906291128.05639.elendil@planet.nl>
	 <1246268022.7775.24.camel@johannes.local>
	 <200906291148.55386.elendil@planet.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nR90e+n93M6RcmUjuK9k"
Date: Mon, 29 Jun 2009 11:53:23 +0200
Message-Id: <1246269203.7775.26.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nR90e+n93M6RcmUjuK9k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-29 at 11:48 +0200, Frans Pop wrote:
> On Monday 29 June 2009, Johannes Berg wrote:
> > > [enable]
> > > usb 3-1: new full speed USB device using uhci_hcd and address 3
> > > usb 3-1: configuration #1 chosen from 1 choice
> >
> > That is completely unrelated. You plugged in a USB device too :)
>=20
> No, it's my "bluetooth + wlan" device. Note that disabling wireless with=20
> the hardware switch also gives 'usb 3-1: USB disconnect, address 2'.
>=20
> From lsusb:
> Bus 003 Device 002: ID 03f0:171d Hewlett-Packard Wireless (Bluetooth +=20
> WLAN) Interface [Integrated Module]

Ah :) That's just bluetooth then though, not wifi.

> > > A lot uglier with those errors. And after that I have to run
> > > ifdown/ifup before networking is up again (ifup only does not work as
> > > it will complain "interface already configured"):
> >
> > And that's actually expected, and/or a bug in the debian networking
> > scripts.
> > (You can trigger the same problem by doing
> > ifup wlan0
> > ip link set wlan0 down
> > ifup wlan0 -> error)
>=20
> OK, I can accept that. Wonder why it does work with 2.6.30 then. But it=20
> can certainly wait until the driver problem you mentioned is resolved.

2.6.30 didn't have the "ip link set wlan0 down" on rfkill behaviour, but
overall that makes life for everybody (except people who actually use
ifup/down) much easier.

johannes

--=-nR90e+n93M6RcmUjuK9k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSI8QAAoJEODzc/N7+QmaL6MP/jrTYdIw5OAu+ifhNjD/Qbnt
edjTTAwnndqMLfh932h7J0K3EgGHdZquAWtWCk+h93vuSg8WeOiCoxtXiPodb3iA
ICNdLC42JKap9XL6XzGNM0lOgtqnoRMLQa+xDaafmAiYdow3/PNY7pPvwVgy8PDy
J4FfmVaryaU6Qgj7EboAEN9Xtxbe3bWhcmoH7xwdrXG3CRZ2Vb/xdoBDKQoVhrwY
9dO6NFG/bj6LP1Ewl1+MW660NxhJgNuU3GE8woYqjnfvYoNMjRWbTmNTi5DhdJRj
6CT2HcTSRH6GcL+ZB9DSmwEHkJgnQoSyOUioZhjMH1vq6vKL9yxayQeng9sKSUrZ
+19nrAm3KdeMFx1S3fTrjPuIgob5DZq0U3n6BV7wx5dP1uruW68+Yjvu7O4bOR4+
ydc+ImQd/WBkq3EiGPqu6FmNNe453Lrr8e3oVAOeMQxd15sh82sDRXvxSUpRZWQ5
YhEc0Lw5yRUU0ffaQ9d+YrpPi/X3RAjvNJY1OsBMONhK1hkRY6WW3p9ucZCyo0ab
b1NfA+G+ACxUhvwiQTn1CacMjja6N3khRHXlBJ457RnEsoIKNQNzcJ2SzHDIgbTW
u+mg/KeiLPNdIPYohP1+azrwcHjxcbHudgJjXwIGttY+gpdmkQhffjPkN/X+euEj
DYuDzLS0nK7Z4bEIzBIv
=t9de
-----END PGP SIGNATURE-----

--=-nR90e+n93M6RcmUjuK9k--

