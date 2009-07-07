Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZGGVsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZGGVsj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZGGVsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:48:30 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbZGGVs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:48:29 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1247002168.5710.1.camel@pc1117.cambridge.arm.com>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
	 <1246986768.4755.43.camel@johannes.local>
	 <1247002168.5710.1.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0PUhK/GrmTISWbbafTOi"
Date: Tue, 07 Jul 2009 23:47:21 +0200
Message-Id: <1247003241.4755.55.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0PUhK/GrmTISWbbafTOi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 22:29 +0100, Catalin Marinas wrote:

> > >  	if (found) {
> > > -		kref_get(&found->ref);
> > >  		found->pub.beacon_interval =3D res->pub.beacon_interval;
> > >  		found->pub.tsf =3D res->pub.tsf;
> > >  		found->pub.signal =3D res->pub.signal;
> > >=20
> > > I'll try this later today to see if it fixes the leak. If that's not
> > > correct, I'll post more information about the content of the reported
> > > object (in general, it shouldn't be on any valid list or rb tree sinc=
e
> > > kmemleak can't find it).
> >=20
> > I have already sent that exact patch.
>=20
> OK. I can now confirm that it fixes the memory leak.

Great, thanks for checking.

johannes

--=-0PUhK/GrmTISWbbafTOi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKU8JmAAoJEODzc/N7+QmaypIQAMSKA3v2RAeggGyjGvQphO46
aS9Na8t0aNrQIGGiThPI8dFpP5A9oe5RBuNusn0SXR2pw1yPY2ZP0h4fgAZ0GVuR
o14L6F1eAjO0xZv/dNaeFtItqi2kDaHl962LK5S/zZ2dKBtSjuMIX5qE9brMbDiF
585VzuF03AJnKN4Ahd/ao6OqxYkNZS/y4mlqRpTzSAlqD0yJw3cXW8B7odSw184R
hzHW/oOaTMXHkN5r5lEGoz/JclzyHJqK0W76IJNxNNP/Xv5sY60HzlErkIi4ZiRZ
9QGXQwnBpTTFEOA0Wu3637K+q06MFlRlyGqhsnqFVcZkLOhJ4UqtHM2AfHXWWb2H
PJkCU6ZPprEu9vZnolXFl8WHCJFpjELONWIBv3nBEumnOSUCWQebqy9RRVSbJDTp
wp9fIbSrgU9mov6WHCK4IFLiiX+Z2ZpC5V+kQdLj8cfPfTQVyc98cC9dndOSWmmA
YegaeqoRVq+moAM+XnzJjBlz+HbZW744gG9d5cBZZOXX+aGW/FNPyX2e31XXGVp5
KHxH1glyLRlyOVOPOV7MRnWEdKMHBaq5Z4y3rRTEZPQY9kSJWezLuk564rpvqgGp
GhEpUKDUzz1tQwQtxY4+M4RGTCcRmEabM1TPuiNUn01AHRwRMP7yKtfBumGqESV6
YHQ47UlmUh3YW8gKhoG2
=w21r
-----END PGP SIGNATURE-----

--=-0PUhK/GrmTISWbbafTOi--

