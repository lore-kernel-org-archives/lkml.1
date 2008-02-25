Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYBYK25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYBYK25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 05:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYBYK2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 05:28:49 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:52348 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYBYK2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 05:28:48 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Add rdc321x defconfig file
Date: Mon, 25 Feb 2008 11:24:11 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <200802251058.30188.florian.fainelli@telecomint.eu> <20080225101433.GA30685@elte.hu>
In-Reply-To: <20080225101433.GA30685@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3653560.c3gkKYZHgO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802251124.17561.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3653560.c3gkKYZHgO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo,

Le lundi 25 f=E9vrier 2008, Ingo Molnar a =E9crit=A0:
> hm, i'm not sure. Right now we just have a 32-bit defconfig and a 64-bit
> defconfig - but there are about 8 subarchitectures in arch/x86. Given
> the amount of variety in PC hardware, i doubt it makes sense to start
> collecting defconfigs for hardware variants - we'd end up having
> hundreds or thousands of them. Even ARM has only 75 defconfigs.

I was answering to Adrian Bunk's email about missing defconfigs for the x86=
=20
subarchitecture boards.

>
> what i do is i regularly test whether "make allyesconfig" boots all the
> way up to general user-space in regular whitebox PC hardware. For
> example the attached config is such a config, i successfully booted it
> on 2.6.25-rc3 on a stock PC.

Apart from selecting the 486 instruction subset, everything else should be=
=20
allright though I had the habit to have a stripped down kernel for testing.

>
> In fact for rdc321x that should be rather easy to do right now: wdt.c
> could/should become a regular watchdog driver, and do we really need
> those GPIO specials in include/asm-x86/mach-rdc321x/ ? I believe it
> should be possible to boot CONFIG_X86_GENERICARCH on a rdc321x. Am i
> missing any particular complication?

The GPIO calls will be moving later when I have finished the gpiolib=20
integration for RDC just like what is currently done for ARM. You are right=
=20
for the watchdog driver, I will move it right now.

>
> 	Ingo



=2D-=20
Cordialement, Florian Fainelli
=2D-----------------------------

--nextPart3653560.c3gkKYZHgO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHwpdRmx9n1G/316sRAsF+AKCUumIbTmjkAjzFy5bRX9CChIvBPwCeI76x
bws9NbsZ5NJaH9H85H/WRKA=
=/WDE
-----END PGP SIGNATURE-----

--nextPart3653560.c3gkKYZHgO--
