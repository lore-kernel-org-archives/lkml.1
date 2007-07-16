Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXGPQvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXGPQvW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXGPQuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:50:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:47119 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933315AbXGPQuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:50:52 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch] use __attribute__ in asm-powerpc
Date: Mon, 16 Jul 2007 12:51:37 -0400
User-Agent: KMail/1.9.7
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <200707142336.10343.vapier@gentoo.org> <Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be>
In-Reply-To: <Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1377632.05SH6qtCS7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707161251.40449.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1377632.05SH6qtCS7
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 July 2007, Geert Uytterhoeven wrote:
> On Sat, 14 Jul 2007, Mike Frysinger wrote:
> > Pretty much everyone uses "__attribute__" or "attribute", no one
> > uses "__attribute".  This patch tweaks the three places in asm-powerpc
> > where this comes up.  While only asm-powerpc/types.h is interesting (for
> > userspace), I did asm-powerpc/processor.h as well for consistency.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > diff --git a/include/asm-powerpc/processor.h
> > b/include/asm-powerpc/processor.h index d947b16..2ce6ea6 100644
> > --- a/include/asm-powerpc/processor.h
> > +++ b/include/asm-powerpc/processor.h
> > @@ -153,9 +153,9 @@ struct thread_struct {
> >  	unsigned long	dabr;		/* Data address breakpoint register */
> >  #ifdef CONFIG_ALTIVEC
> >  	/* Complete AltiVec register set */
> > -	vector128	vr[32] __attribute((aligned(16)));
> > +	vector128	vr[32] __attribute__((aligned(16)));
>
> If the code is not exported to userspace (and thus not subject to differe=
nt
> compilers), I think the preferred form is plain `attribute'.

i never said asm-powerpc/processor.h was exported to userspace ... i did sa=
y=20
that i changed the file to be consistent with all other files.
=2Dmike

--nextPart1377632.05SH6qtCS7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iQIVAwUARpuiHEFjO5/oN/WBAQIDjA/+MvlW71LHzAfh+9uBhXWFQZt0NwUr+V+2
4x//AQ56ZYdQS8Y2T0t7RmiES0DwUc7NyxaI5onGBZpp8mb7Vv/pGKejJuCN/IBD
HtZwFvg+y74HwVegL9VE1x4axYv8vPZyBkq8mU6Sl6ATfIKiB4f0Noffn6TH+wUl
Blf4Bx1meny4KORuzqxbVjn74KOHwqw9qO+GezQCHh84cz2YMttuUwKLCY9L76GV
dytgoYGS8JOmOzFshLwNG0zOyYO3TcI4pYa4LpSvlpfpeLZSGDEx2XZ6nTSh0m+y
QSMExx0wLT1uI0GxmVP0UiBd7blB8rypo3F5BeesbNB+olO6tJo4flXcHsDunVGd
QRRXfbEDJavTdcsT6EhIAUzJz8cLSuAfBWUkxFDKtsHUDOn9gj54tjpLvpotiJBF
wyk/1Ro0kOsqstbmmhh1nnY3UhuFtbEsXTWCJgCrFK7GuRylxLFG4mhQmD7VMcWH
6AwCnXpQnWYQrA0Pxkh0F8WzdrnozBskc7HoH8u2p2UR6RlYL90plzSdSzwugawi
Nhm6/UEz2VX4xBgUsQZyABIRpx+mNF85WmZkEuDV8YcrOzZaL6bnC7o8lh7rZOfa
eyQyxpfI6D2eegsEuXyo332aXlyRdArAgcJitGGFptNp9LnuFmF7sNKXCL7Z1SmQ
r7QVn8m6XBg=
=CFNW
-----END PGP SIGNATURE-----

--nextPart1377632.05SH6qtCS7--
