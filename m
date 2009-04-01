Return-Path: <linux-kernel-owner+w=401wt.eu-S1763788AbZDBBmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788AbZDBBmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 21:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZDBBmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 21:42:10 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:55497 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZDBBmJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 21:42:09 -0400
X-Greylist: delayed 11133 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2009 21:42:09 EDT
X-Envelope-From: santiago@crfreenet.org
Date: Thu, 2 Apr 2009 00:42:44 +0200
From: Ondrej Zajicek <santiago@crfreenet.org>
To: Michal Januszewski <spock@gentoo.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [Linux-fbdev-devel] [PATCH] s3fb: fix color component length
	for pseudocolor modes
Message-ID: <20090401224243.GD4085@localhost>
References: <20090330221104.GD6993@spock.one.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <20090330221104.GD6993@spock.one.pl>
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2009 at 12:11:04AM +0200, Michal Januszewski wrote:
> s3fb incorrectly sets the length of the color fields to 6 bits
> for PSEUDOCOLOR modes, even though 8 or 4 bits are used per pixel.
> Fix this by setting the length to 8 or 4, respectively.
>=20
> Signed-off-by: Michal Januszewski <spock@gentoo.org>

Acked-by: Ondrej Zajicek <santiago@crfreenet.org>

> ---
> diff --git a/drivers/video/s3fb.c b/drivers/video/s3fb.c
> index 4dcec48..c3fad34 100644
> --- a/drivers/video/s3fb.c
> +++ b/drivers/video/s3fb.c
> @@ -45,11 +45,11 @@ struct s3fb_info {
>  static const struct svga_fb_format s3fb_formats[] =3D {
>  	{ 0,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
>  		FB_TYPE_TEXT, FB_AUX_TEXT_SVGA_STEP4,	FB_VISUAL_PSEUDOCOLOR, 8, 16},
> -	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
> +	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 0,
>  		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
> -	{ 4,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 1,
> +	{ 4,  {0, 4, 0},  {0, 4, 0},  {0, 4, 0}, {0, 0, 0}, 1,
>  		FB_TYPE_INTERLEAVED_PLANES, 1,		FB_VISUAL_PSEUDOCOLOR, 8, 16},
> -	{ 8,  {0, 6, 0},  {0, 6, 0},  {0, 6, 0}, {0, 0, 0}, 0,
> +	{ 8,  {0, 8, 0},  {0, 8, 0},  {0, 8, 0}, {0, 0, 0}, 0,
>  		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_PSEUDOCOLOR, 4, 8},
>  	{16,  {10, 5, 0}, {5, 5, 0},  {0, 5, 0}, {0, 0, 0}, 0,
>  		FB_TYPE_PACKED_PIXELS, 0,		FB_VISUAL_TRUECOLOR, 2, 4},
>=20

--=20
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknT7eMACgkQw1GB2RHercMFTgCfcblD2S+5L+hJlqsHDo++j95w
0gYAniLObB3GXgl6BJdQes+MwYx+bvLc
=ro40
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
