Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbYL0JVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbYL0JVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYL0JVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:21:41 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45088 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbYL0JVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:21:40 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 04:21:35 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org> <20081227084708.GA16077@elte.hu>
In-Reply-To: <20081227084708.GA16077@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9328476.1M6iK9Flnp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812270421.38774.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9328476.1M6iK9Flnp
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 03:47:08 Ingo Molnar wrote:
> * Sam Ravnborg wrote:
> > On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> > > Use __asm__/__inline__ rather than asm/inline for all the functions
> > > exported to userspace.
> >
> > I will imagine that we will see cleanup patches converting
> > these back to inline/asm.
> > How about doing this conversion as part of the headers_install.pl
> > script so we know it is always correct?
> >
> > Then we can keep the familiar inline/asm in the kernel headers
> > and always use the correct __asm__, __inline__ version for our
> > exported headers.
>
> or name it __asm__exported__ to make sure it isnt cleaned up away.

i think we can try the automated approach first as that'll make things easi=
er=20
on everyone ... but if it doesnt work out, this sounds like a reasonable=20
solution to keep things sane.
=2Dmike

--nextPart9328476.1M6iK9Flnp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVfOiAAoJEEFjO5/oN/WBlvIQAI8mMyPUZSESiQApAXEjqxxd
BYxZKRYVDplxKm7dT+Rsi/LSODArdGEUH7hdnmHVQQ5rr/T2DKLRzcgJGIAY79/C
2IdLNkHUpGlThDajuLShN1qFz3IHQr70fYDy8Do1gHNGQVj3k6kkWQjW+Y2oQ9/c
JbQ3sJXl70FlXvZDHerV7TPlRsHtX+8U0eQZYL+SIEusRegT8GcEeo9e/K4ptXVz
ylpRjOa/O5/NEvJXmD6tLfF14bH4s3EcYJpLyNuurq/FtTarbOFBvd9vGR6dLZMl
mY/evHOVbaK2MdoIMoJRu7XwEwsesTcuOWHEnOxisXyBPu3WBRWVtRu5CGwNciHZ
CZ4tyFWEAx9pztXPNCeHo4f/gXV9fgDb3S5Emvaai78cRC93iTw+LWL+hxRGT/7d
KRsIQQpl2u1Frybu1MNJD1PvS8xbtFKWcccdbRN7cjo0XQTYqJbyr2W0yWf6k225
FEleQFZSjL4pOMplxdx3M1cJwKkCfDeczjrPmUy3JeURdn0jLd7JEu+eSnInXUgF
hQRg5PdzLUJQODesvlfUfvviE5y1FxTBnTcAk5ArLYhSN19MBzltufiUYX/hPcbP
dHUbxv2CimXMxZeHhTjZY4mQFZBBS+R1Kd9lwhHuC3iiSBcrWH3jd7nabGqF59lx
eE9PZOtn45b3EM5ZM1N/
=M1ou
-----END PGP SIGNATURE-----

--nextPart9328476.1M6iK9Flnp--
