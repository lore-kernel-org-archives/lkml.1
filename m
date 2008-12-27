Return-Path: <linux-kernel-owner+w=401wt.eu-S1753821AbYL0Hz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbYL0Hz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 02:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYL0Hzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 02:55:48 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36724 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbYL0Hzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 02:55:48 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
Date: Sat, 27 Dec 2008 02:55:45 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <20081227071208.GB27736@uranus.ravnborg.org>
In-Reply-To: <20081227071208.GB27736@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1938992.yMAX9HEhkZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812270255.47013.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1938992.yMAX9HEhkZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 27 December 2008 02:12:08 Sam Ravnborg wrote:
> On Sat, Dec 27, 2008 at 01:50:04AM -0500, Mike Frysinger wrote:
> > Use __asm__/__inline__ rather than asm/inline for all the functions
> > exported to userspace.
>
> I will imagine that we will see cleanup patches converting
> these back to inline/asm.
> How about doing this conversion as part of the headers_install.pl
> script so we know it is always correct?
>
> Then we can keep the familiar inline/asm in the kernel headers
> and always use the correct __asm__, __inline__ version for our
> exported headers.

yeah, i think these kind of "fixes" went in between 2.6.27 and 2.6.28 becau=
se=20
there's a lot more hits on "inline" than there were previously ...
=2Dmike

--nextPart1938992.yMAX9HEhkZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJVd+CAAoJEEFjO5/oN/WBnpcP/RSXHfIiSbRT536f6zSsrkjo
hA3zhkVwFFyMYF8QKDVvdXtnac282QWFkZUi0aetKhA2PNLJHVGwqCnR345Y5HUs
1aheTEzD12WhzaJUuokQ/OQ1e9JIAuHJqw8yo9TUSenBFy9tPzsEYJ0GNvyVeOsP
hlNZxQ9qUzqO1gW4WW4z9I/1uGzy5F/Z9JVWYV90J/UQN0y5llIlAq0PUqWc2Qfd
FwPJrmaYWSqTRRZSe0PVHkBH8Kw45cc5VxeEMPl2Yfzm3M7e9tfxrrggTjs935s6
2yCsSNmsY49HYgcX3KFnXLHNrWWfIR7Xn9lpGBoZT68S8rnNLZLSw4wNYe0wsEgJ
tgUNfFk5YorH4ecjuBhgjua9VLgPVynf/s4ro8i449kCtUMXQ80mNbSc0MDBkrGQ
zHY4c5m9W02MlKpmcD4EI1UTetrmnLFIaQBSiMqB96wH6vPx8cl/3d4Ztposf8iV
UIKiLSrA87/P5smee8FE1BZ+14X0gwFf4vLDtqpiy3MmPKtUbcVsx+tO8tEV33t5
EkrPdBiQ+vDjvorxJWNS8MdNi95ZTWBmAGQeP+yUVuQMZ/Y5Xw+99W/kkK2qFCPS
tFb3h/pz+0aHwCahJXZJrzM/dGrMioQTVORDoiLxTwdDmy9qvlZaavKitxDqHkab
jIhhTXegkJGQuzvRWoZ7
=Fbi/
-----END PGP SIGNATURE-----

--nextPart1938992.yMAX9HEhkZ--
