Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYL2KPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYL2KPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbYL2KPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:15:12 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:52319 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbYL2KPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:15:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] headers_check.pl: disallow extern's
Date: Mon, 29 Dec 2008 05:15:08 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1230363816-24097-1-git-send-email-vapier@gentoo.org> <20081227184355.GA9264@uranus.ravnborg.org> <20081227185415.GA10361@uranus.ravnborg.org>
In-Reply-To: <20081227185415.GA10361@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1285319.Rd85L7B90i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812290515.09121.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1285319.Rd85L7B90i
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 13:54:15 Sam Ravnborg wrote:
> > And we need to get these fixed before we apply this patch.
> > Otherwise we will break every allyesconfig/allmodconfig builds
>
> I turned them into warnings for now.
> And when I was there I fixed the TODO:
>
> From 2bbc376f97c4a75fbbb603b34f73db235a8cd2c1 Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 27 Dec 2008 19:52:20 +0100
> Subject: [PATCH] kbuild: check for leaked CONFIG_ symbols to userspace

btw, do you maintain these in a git tree somewhere, or you just posting the=
m=20
to lkml ?  the two kbuild trees under your name on kernel.org/git seems to =
be=20
lacking this change.  i was looking at adding another check: barf if the=20
header uses __[us]{8,16,32,64} types but does not include linux/types.h.
=2Dmike

--nextPart1285319.Rd85L7B90i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWKMtAAoJEEFjO5/oN/WBZY0P/iyWvVesi9o4Gt5LA1kC3LCX
smeOYFsJWB6qSS25fz9RKGPCk3KM1aMhm86g4wFWULUwHX7uT2hVEgW1yCOicVK0
dNVIth5V6zepobtZCR3reCy1aNuB1EMvF9N71Om4SzEyjf++D3IvC/8i6lve5T86
fi/vJMtXj1+WiqGpoFPUxgs+Xv4UZzsEu8lb7EGG6PmviNh0MyNjJinMRukQFA6s
9IvIjsav1JxpLeffCh/Av9My8x32ANPnfjRaKQC2n5cEd0dyLfAqaKynn23ZMruf
mOhfwyINwg4SiPaLYfD820kECfDGKiQUksfAp1FJoG4tunvxk/W4fBTuXSkVH5Rg
ANb7LFEBrr+wayXIrfqvAsceT46Ct0WfbxpAmSmanuS5AREpy/T7RWl64WkQqd2c
qc7hLZWEDwZnVkF92bPWRF6Ch5TsjDwcvtQWDn58Uy0KHvNKLW/SzKprZfIntzqP
uVXyzab/Apha1XeXSZfBaUUnyFpQi3Du+EAqBaNDktSJS4rWTo7+rRF6A9kb3r95
DHmgX+m8gGgpjBhaqCCw48D4/cNV4LLM3IRX3u0fJ1UBIFFCEoUKB/nzwoWs9PpO
l9y6rL52bZ6qhS2dc7M1c/dxouWN+yRSesJp+p6/wxYIQ/UGDq5aHZXd6uQdwh6c
EeUDrfalByphCii36r1y
=Qw6H
-----END PGP SIGNATURE-----

--nextPart1285319.Rd85L7B90i--
