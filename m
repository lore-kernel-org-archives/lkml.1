Return-Path: <linux-kernel-owner+w=401wt.eu-S936369AbXGMJ14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369AbXGMJ14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762949AbXGMJ1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:27:49 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3164 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312AbXGMJ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:27:48 -0400
Message-ID: <46974586.3050505@imap.cc>
Date: Fri, 13 Jul 2007 11:27:34 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: [x86 setup 31/33] Use the new x86 setup code for i386
References: <1184181538674-git-send-email-hpa@zytor.com> <118418153862-git-send-email-hpa@zytor.com> <11841815382283-git-send-email-hpa@zytor.com> <11841815392122-git-send-email-hpa@zytor.com> <11841815393975-git-send-email-hpa@zytor.com> <11841815393014-git-send-em <11841815433482-git-send-email-hpa@zytor.com>
In-Reply-To: <11841815433482-git-send-email-hpa@zytor.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8C624F6FC84620C1BDE21BA4"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C624F6FC84620C1BDE21BA4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin schrieb:
> From: H. Peter Anvin <hpa@zytor.com>
>=20
> This patch hooks the new x86 setup code into the Makefile machinery.  I=
t
> also adapts boot/tools/build.c to a two-file (as opposed to three-file)=

> universe, and simplifies it substantially.

[...]

> diff --git a/arch/i386/boot/tools/build.c b/arch/i386/boot/tools/build.=
c
> index 0579841..886f47d 100644
> --- a/arch/i386/boot/tools/build.c
> +++ b/arch/i386/boot/tools/build.c
> @@ -1,13 +1,12 @@
>  /*
>   *  Copyright (C) 1991, 1992  Linus Torvalds
>   *  Copyright (C) 1997 Martin Mares
> + *  Copyright (C) 2007 H. Peter Anvin
>   */
> =20
>  /*
>   * This file builds a disk-image from three different files:
>   *
> - * - bootsect: compatibility mbr which prints an error message if
> - *             someone tries to boot the kernel directly.
>   * - setup: 8086 machine code, sets up system parm
>   * - system: 80386 code for actual system
>   *

You might want to change the word "three" to "two" in the first
line of that comment.

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8C624F6FC84620C1BDE21BA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGl0WGMdB4Whm86/kRAvRMAJ98ZrLLlYquP1r+8FmNHOxK8iz29wCePnJX
F88wDWkDF61nnhd2SjlKPfM=
=yVqc
-----END PGP SIGNATURE-----

--------------enig8C624F6FC84620C1BDE21BA4--
