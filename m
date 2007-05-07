Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXEGLpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXEGLpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 07:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933305AbXEGLpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 07:45:00 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:58792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285AbXEGLo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 07:44:59 -0400
Subject: Re: [PATCH -mm] PM: Separate hibernation code from suspend code
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>
In-Reply-To: <200705051550.53436.rjw@sisk.pl>
References: <200705041132.32227.rjw@sisk.pl>
	 <200705051421.31067.rjw@sisk.pl> <1178368028.7408.93.camel@johannes.berg>
	 <200705051550.53436.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-otH3NKaaeqLXLiRucHc3"
Date: Mon, 07 May 2007 13:46:43 +0200
Message-Id: <1178538404.7261.16.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-otH3NKaaeqLXLiRucHc3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-05-05 at 15:50 +0200, Rafael J. Wysocki wrote:

> @@ -60,6 +60,9 @@ void hibernation_set_ops(struct hibernat
>  	}
>  	mutex_lock(&pm_mutex);
>  	hibernation_ops =3D ops;
> +	if (ops)
> +		hibernation_mode =3D HIBERNATION_PLATFORM;

	else if (hibernation_mode =3D=3D HIBERNATION_PLATFORM)
		hibernation_mode =3D HIBERNATION_SHUTDOWN;

> +
>  	mutex_unlock(&pm_mutex);

johannes

--=-otH3NKaaeqLXLiRucHc3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGPxGj/ETPhpq3jKURAmgpAKCWrxilIOwgwIqO4dYNYvLiQB6Q2wCfXja+
hzByLxRnkM0YnTXbb4Mvv+Y=
=/yKc
-----END PGP SIGNATURE-----

--=-otH3NKaaeqLXLiRucHc3--

