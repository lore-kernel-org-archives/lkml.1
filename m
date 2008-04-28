Return-Path: <linux-kernel-owner+w=401wt.eu-S937439AbYD1TER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937439AbYD1TER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937328AbYD1TDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:03:31 -0400
Received: from rk.rkuhn.info ([88.198.164.84]:40286 "EHLO mailhost.rkuhn.info"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937323AbYD1TD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:03:29 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2008 15:03:29 EDT
From: Roland Kuhn <rkuhn@e18.physik.tu-muenchen.de>
To: timur@freescale.com
In-Reply-To: <481529B6.6030802@freescale.com>
Subject: Re: cross-compiling on OS X, make menuconfig fails
References: <481529B6.6030802@freescale.com>
Message-Id: <8FEAC32C-868F-468C-B383-8450D400691C@e18.physik.tu-muenchen.de>
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1--827065573"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Mon, 28 Apr 2008 20:46:07 +0200
Cc: linux-kernel@vger.kernel.org
X-Pgp-Agent: GPGMail d51 (Leopard)
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1--827065573
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed; delsp=yes
Content-Transfer-Encoding: quoted-printable

Hi Timur!

On 28 Apr 2008, at 03:34, timur@freescale.com wrote:

> I'm trying to cross-compile a PowerPC kernel from an Intel OS X =20
> system.  I've almost got it working, except "make menuconfig" dies.  =20=

> It says I'm missing ncurses:
>
> *** Unable to find the ncurses libraries or the
> *** required header files.
> *** 'make menuconfig' requires the ncurses libraries.
>
> However, I do not think that ncurses is the real problem, since I do =20=

> have ncurses installed.  I think the real problem is that the check-=20=

> lxdialog.sh is trying to execute this code:
>
> echo -e ' #include CURSES_LOC \n main() {}' | gcc '-=20
> DCURSES_LOC=3D<ncurses.h>' -DLOCALE -DKBUILD_NO_NLS -lncurses -xc - -=20=

> o .lxdialog.tmp
>
> And the compiler is failing with this output:
>
> <stdin>:1: error: syntax error before =91-=92 token
> <stdin>:1: error: stray =91#=92 in program
>
> So something strange is going on.  Has anyone been able to cross-=20
> compile from an Intel Mac running OS X?

For some strange reason Apple decided to change 'echo':

/bin/bash -c 'echo -e ...' does the right thing
/bin/sh -c 'echo -e ...' keeps the "-e" in the output but interprets =20
the \n
/bin/echo -e ... does no interpretation and even keeps the \n

I'd recommend installing the coreutils-default package from fink, then =20=

you get a sane /sw/bin/echo.

Side-note on sanity: ISTR that POSIX defines echo in this (/bin/echo) =20=

strange way, urging people to use printf instead.

Ciao,
                     Roland

--
Any society that would give up a little liberty to gain a little
security will deserve neither and lose both.  - Benjamin Franklin
-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GS/CS/M/MU d-(++) s:+ a-> C+++ UL++++ P+++ L+++ E(+) W+ !N K- w--- M+ !=20=

V Y+
PGP++ t+(++) 5 R+ tv-- b+ DI++ e++++ h---- y+++
------END GEEK CODE BLOCK------




--Apple-Mail-1--827065573
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iEYEARECAAYFAkgWG3AACgkQI4MWO8QIRP3pywCgs/FrNVPrOYYMRnPkC5tWUXma
rYAAnjKmlSt53Zyk//dQDLuuMXTmtPq8
=iYfq
-----END PGP SIGNATURE-----

--Apple-Mail-1--827065573--
