Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbYL2KyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbYL2KyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYL2KyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:54:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48248 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYL2KyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:54:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Mon, 29 Dec 2008 05:54:12 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <4958A792.9080704@zytor.com>
In-Reply-To: <4958A792.9080704@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1790896.xKTpuQKiOr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812290554.13712.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1790896.xKTpuQKiOr
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 05:33:54 H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > Headers in userspace should be using the __xxx__ form of the asm, inlin=
e,
> > and volatile keywords.  Since people like to revert these things without
> > realizing what's going on, have the headers install step autoconvert
> > these keywords.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> volatile?
>
> volatile is a keyword in C90, and anything older than that we're
> guaranteed to not be compatible with anyway...

i dont really have any history examples left at this point.  we've been doi=
ng=20
{asm,inline,volatile} conversion together forever in the Gentoo world, so i=
=20
dont have anything to point you at.  i would highlight that the code to=20
support it is trivial and "free", so just leaving it in is easy enough.
=2Dmike

--nextPart1790896.xKTpuQKiOr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWKxVAAoJEEFjO5/oN/WBTmMQANyA/FBZZErQKVBHwLJV8xz+
91K0C8c+pgkNkszlgdggECtLBtj7N32sYTKNLG2yLeXbu3yiYjoPJwz9jhIEJ3Ci
sqAhplSvggpqac/dOzfURBGP1Nbqc0lY5GwNQln2jRW/tlwF2CwJrYYgWoQB0M5j
xEeMOzzrKNJJWoR3edfW2cLI/k54VmWg7KC5kKsx96whKFoW9oScB2kYQocQKzY0
c80zRGPlbcqOKu/ypepyzvPSAAFVMhDf7H5d+ca+2QuU9KTRsJ8kGLlYxPFbwcJp
pFPLJfzV2cgUgkTptm98YKg4UGJs/xXndP5vwsd64EoJVEtAWBElmKnZge0qTNEJ
KbjgxWQn9xA+babmkKoSqOSxRnoBiQEC0E1qxx4vhjewYjgn8OUpvf+SeGfBLyVC
KgiZ7LYyi8278RtdEncBRD56WB8He7vcdFMErHQyC/XjgUVFibZODyapJbYOAfWU
yx2jv2GgI40W506s+xGGpmMTh86awsynu+eqGyGoC+xcL6ii61CXIQcJcjVNJMqG
ycfe1WAuKwSsSjGK5upUXv3vzz3Wv16WWk8nTw8Ik+qXi+8e4nObGYgHMNn9l6Qr
BIVk9dzxsV+zQBprvnJAV51GoDoFS7XwUQq0eM82hiTmjXJaHijH6Q7Ae/hH7Mpc
jcaVUGDJ6vVncQUyQv+s
=m2e1
-----END PGP SIGNATURE-----

--nextPart1790896.xKTpuQKiOr--
