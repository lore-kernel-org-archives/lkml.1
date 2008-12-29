Return-Path: <linux-kernel-owner+w=401wt.eu-S1754419AbYL2UhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419AbYL2UhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYL2Uev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:34:51 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33466 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552AbYL2Ueu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:34:50 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
Date: Mon, 29 Dec 2008 15:34:48 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org> <20081229140356.GB7327@uranus.ravnborg.org>
In-Reply-To: <20081229140356.GB7327@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7511048.Gq6DTsmTqc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812291534.49577.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7511048.Gq6DTsmTqc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 09:03:56 Sam Ravnborg wrote:
> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
> > Rather than constantly fixing up size type breakage in userspace header=
s,
> > auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
> > appropriate __uXX or __sXX type.
>
> Is this the right thing to do?
> uintXX_t belongs to a namespace that the kernel should not use.

some headers are shared between projects and so use the uintXX_t form, so i=
'm=20
not sure outright banning it is a nice answer for them
=2Dmike

--nextPart7511048.Gq6DTsmTqc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWTRpAAoJEEFjO5/oN/WB2pQP/12B/nRGIeUMxEPzcm8cYXvp
bqFFhZiz4049u3aoM28uyb1vQv6zofQvZxg7210hm1qNwqLdHZMYI6GV70fatrMg
5st4gj4NBm4PhTmdSVDEXJ43Dy53cZzrUte86ugESYcUAU9q4LV2zb/4EQXVg3g+
+ETAZP/Fc0fW3qGCgw/gG1vN6Gn0yztQabjak0okABBrClOn5Oqutn4vsd1ZR++4
NKPmbGgpj+FG7FF1vpTKozVlMMdOmIk+Y64fZTynlaaQBk3LlMA8bHvnVywhnUWN
y1sIQLtFu2WNkQVZMdVjlQz2F1NZGyYliyOmZUnTEjyJEboMpJi4uqY049M+KxIY
y1pQW/tJafuZb8PVtdaSR10OUnven6hqACAJDMKIyrh9BVrfKkvEEAmz46LhaaHD
ZFiActdmvryvxHvzzVxYgCeIJ1GL5QUYQGMvmouDc2DyteYp3bjwaULF1RV6OQO/
ZSWAUUsALPzgepylo64fJPrlXeyHgEyRaUSV04eKz3apsgrXae5JWjNQaXZ02fxR
fVAwrSfuLrhSYDwVHdWGSED8BEcERLeaeXi4CMdD9YVntPmKdKGV/gwcQcLcpx1a
ctZcN1EssMHMb24zYh/HepWUJDGUt9hCfzQkdN0lXdHT8Sky7r4vmMyx7Zf/YpZB
mjNBmZw9b4tC2hFxJ7QD
=DMRh
-----END PGP SIGNATURE-----

--nextPart7511048.Gq6DTsmTqc--
