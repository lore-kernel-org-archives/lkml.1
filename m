Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbYKXWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbYKXWHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYKXWH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:07:26 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:36510 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750909AbYKXWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:07:25 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, kbuild <linux-kbuild@vger.kernel.org>,
       Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <1227560095-32597-8-git-send-email-sam@ravnborg.org>
References: <20081124205150.GA32497@uranus.ravnborg.org>
	 <1227560095-32597-8-git-send-email-sam@ravnborg.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PDHTPpob3MhAZPVFgIKK"
Date: Mon, 24 Nov 2008 22:07:14 +0000
Message-Id: <1227564434.16868.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 8/8] kbuild: move tags support to a shell script
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=V84b4ZJ0d9AA:10 a=50qSNOvygccA:10 a=WWBql4ttNm7lneV60FIA:9 a=Sx3XCO0HnfTkdNAlu40rF3JeJX4A:4 a=LY0hPdMaydYA:10 a=LjMR3qvCiUwfVEDTRGkA:9 a=zmjhjhIShGHvA6gUiUWUKTCN_QcA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PDHTPpob3MhAZPVFgIKK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 21:54 +0100, Sam Ravnborg wrote:
>=20
> +# Support um (which has SUBARCH)
> +# FIXME: add support for ALLSOURCE_ARCHS if really used
> +if [ "${ARCH}" =3D=3D "${SUBARCH}" ]; then
> +       archs=3D"${ARCH} ${SUBARCH}"
> +else
> +       archs=3D"${SRCARCH}"
> +fi

I've never used um but is this conditional backwards? If ${ARCH} =3D=3D
${SUBARCH} then archs=3D"${ARCH} ${SUBARCH}" is equivalent to archs=3D"
${ARCH} ${ARCH}", isn't it?

I'm not quite sure I understand the distinction between ARCH, SRCARCH
and SUBARCH either but is it expected that for ARCH=3Dum, SUBARCH will be
i386/x86_64 or x86? I think it's the former in which case I'd expect
these days nothing will be found in arch/i386 or arch/x86_64? is a
SRCSUBARCH required?

Ian.

--=20
Ian Campbell

To do two things at once is to do neither.
		-- Publilius Syrus

--=-PDHTPpob3MhAZPVFgIKK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkrJZIACgkQM0+0qS9rzVlhqgCcD6WjVPkLRZcsXo83z29YS99m
EiAAn1YrUc3lZRJGnBr+c4mBCuUrQHOj
=tgag
-----END PGP SIGNATURE-----

--=-PDHTPpob3MhAZPVFgIKK--

