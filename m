Return-Path: <linux-kernel-owner+w=401wt.eu-S1753816AbYIOLPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbYIOLPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 07:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYIOLPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 07:15:37 -0400
Received: from bokovka.donpac.ru ([80.254.111.46]:35080 "EHLO
	bokovka.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbYIOLPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 07:15:36 -0400
Date: Mon, 15 Sep 2008 15:12:31 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH] ibmasr: remove unnecessary spin_unlock()
Message-ID: <20080915111231.GB28801@pazke.donpac.ru>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>
References: <20080913094717.GA3571@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20080913094717.GA3571@localhost.localdomain>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 257, 09 13, 2008 at 06:47:19 +0900, Akinobu Mita wrote:
> __asr_toggle() is always called with asr_lock held.
> But there is unnecessary spin_unlock() call in __asr_toggle().
>=20
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Andrey Panin <pazke@donpac.ru>

Acked-by: Andrey Panin <pazke@donpac.ru>

> ---
>  drivers/watchdog/ibmasr.c |    1 -
>  1 file changed, 1 deletion(-)
>=20
> Index: 2.6-git/drivers/watchdog/ibmasr.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- 2.6-git.orig/drivers/watchdog/ibmasr.c
> +++ 2.6-git/drivers/watchdog/ibmasr.c
> @@ -85,7 +85,6 @@ static void __asr_toggle(void)
> =20
>  	outb(reg & ~asr_toggle_mask, asr_write_addr);
>  	reg =3D inb(asr_read_addr);
> -	spin_unlock(&asr_lock);
>  }
> =20
>  static void asr_toggle(void)
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQFIzkMfIWZCBzwS8mkRArzQAJi0d+oO8W83H25/G+PKWBQmiCquAJ9KmGSg
5cE78mFtzuGe6jhdmds/Tg==
=4lL5
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
