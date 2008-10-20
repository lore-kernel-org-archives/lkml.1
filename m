Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbYJTMds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbYJTMds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbYJTMdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:33:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:47876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbYJTMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:33:37 -0400
Subject: Re: iwl3945 broken in current git
From: Johannes Berg <johannes@sipsolutions.net>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Dieter Ries <clip2@gmx.de>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <20081020121710.GA3607@isilmar.linta.de> (sfid-20081020_141718_690091_E56EF8AB)
References: <48FC6C05.6020901@gmx.de>
	 <20081020121710.GA3607@isilmar.linta.de>
	 (sfid-20081020_141718_690091_E56EF8AB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dCWFWQaIQtZheQ+VVkpE"
Date: Mon, 20 Oct 2008 14:33:30 +0200
Message-Id: <1224506010.27899.23.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dCWFWQaIQtZheQ+VVkpE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:17 +0200, Dominik Brodowski wrote:

> > iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> > iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> > 0x4416 ser 0x0000004B
> > iwl3945: Can't stop Rx DMA.
>=20
> It needs a more recent uCode -- the driver really should scream out loudl=
y
> that the old firmware no longer suffices.

You could try reverting ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, that's
the only commit I can find that seems to be vaguely related to the
problem as Tomas described it. Not that it might not be hidden in some
other commit...

johannes

--=-dCWFWQaIQtZheQ+VVkpE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/HqWAAoJEKVg1VMiehFYHqsQALvv+VcQ2Nx5BP4LByRFg5rz
fVyaZxC2y/vb21R3oFvWUek0nZQFb7DavbjtPtf1qi28JMIiCn7gkLAOHZQEYyaj
YsN/4lJB2cpBdzU/LwMJwsOnDIc3Q5KzmiZwFSPLd9ReWnpr3APmAZZDpPfkPd9t
MIoP5csFvbbkMny/IHmk/7T11ISPp2/lTBtO27VBzAT6wkPh2INHofqZ0L9D/HIv
ABbUBnx1jZQLOo7mRMvt9EwU0YQLCkUwGJwHIc6WThZAWt6SaDS1YX2XTgL6O7fF
GbyzBMFlFZ93M+t46rtv0lFvXVtxVgIpCFCFgSfeKiV60quRlAXK0hE3uToBCrnZ
/MTP969Jmg41EhCSp7qWnK/yiFMWYGgqkUsNzKOVSgziKk0JAZIO2g3y2MW9aTfr
yoB1LhFOdLmbhJBVaU2ce+HNpUCynwkjm2PD9hPutRatTORUuHzvgJ5+XJqHp+hB
ivXA3U8hO4OZ3soGFsxiNvW8siUX7oHW2eOxdrHdKQixgXeob59LcvLJ4bknSqTQ
+9fp6L/S3H3cGFyu2yxVJpu5BucRi8yk5AM4/IgvItMuBy+wckfW3UEAgKOFCnXs
iI635+oDD9sfst1hyMKjT7zdhUPFJnQh+QPPTAHKDN8QytGAgbXHQUin1UdDnnTB
6Q1Oc9ZTrP1ly4J0zgut
=lKel
-----END PGP SIGNATURE-----

--=-dCWFWQaIQtZheQ+VVkpE--

