Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXE1Gt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXE1Gt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 02:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbXE1Gtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 02:49:51 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40877 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXE1Gtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 02:49:50 -0400
Subject: Re: [PATCH} x86_64 PM_TRACE support.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Julian Sikorski <belegdol@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>, Andi Kleen <ak@suse.de>
In-Reply-To: <4659F3C8.8080606@gmail.gom>
References: <1180161174.9773.60.camel@nigel.suspend2.net>
	 <20070527203955.GE3989@ucw.cz>  <4659F3C8.8080606@gmail.gom>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-leR7rmUV35bXhG5evdg1"
Date: Mon, 28 May 2007 07:54:56 +1000
Message-Id: <1180302896.4020.37.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-leR7rmUV35bXhG5evdg1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-05-27 at 22:10 +0100, Julian Sikorski wrote:
> Pavel Machek pisze:
> > Hi!
> >=20
> >> As promised I took another look at the patch and at what Randy had
> >> prepared to fix the IA64 compilation error. I did some more work on it=
,
> >> and believe that the following is the tidiest correct solution I can
> >> come up with. It differs from the version that caused the compilation
> >> error primarily in that:
> >>
> >> * the #include <asm/resume-trace.h> is inside the #ifdef=20
> >>   CONFIG_PM_TRACE.
> >> * now-unnecessary protection for multiple #includes and ifdef testing =
of
> >>   CONFIG_PM_TRACE in the asm code were removed.
> >> * do-nothing definitions for !PM_TRACE restored to
> >>   include/linux/resume-trace.h.
> >>
> >> We're therefore depending upon kernel/power/Kconfig having the right
> >> depends condition. As far as I can see, IA64 doesn't define CONFIG_X86=
.
> >> Is that correct, or do we need to have (X86 && !IA64)?
> >=20
> > ia64? did you mean x86-64?
> >=20
> > Otherwise looks ok to me.
> >=20
> IIRC enabling pm_trace on x86_64 was breaking compilation on ia64, so I
> think Nigel meant the latter.

Yes, it was breaking ia64, so I meant what I said - I can test x86_64
easily. I was concerned about ensuring the condition was right for ia64.

Regards,

Nigel

--=-leR7rmUV35bXhG5evdg1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWf4wN0y+n1M3mo0RAk1pAJ9tBv0lHIAJcdHw6B33V1qHWW0onwCdF/rX
o4uFSLNmcCLJo3XGrmdtn5E=
=AfNc
-----END PGP SIGNATURE-----

--=-leR7rmUV35bXhG5evdg1--

