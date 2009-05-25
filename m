Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZEYXdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZEYXdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZEYXc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:32:59 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZEYXc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:32:58 -0400
Subject: Re: [PATCH] ath5k: added initial RFKILL support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Jiri Slaby <jirislaby@gmail.com>,
       ath5k-devel@venema.h4ckr.net, mickflemm@gmail.com,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200905260124.03287.tobias.doerffel@gmail.com>
References: <1242850139-25438-1-git-send-email-jirislaby@gmail.com>
	 <200905202216.43996.tobias.doerffel@gmail.com>
	 <20090520202124.M71221@bobcopeland.com>
	 <200905260124.03287.tobias.doerffel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-pwMUlbMbIYrOfiVxTAI1"
Date: Tue, 26 May 2009 01:32:46 +0200
Message-Id: <1243294366.29222.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pwMUlbMbIYrOfiVxTAI1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-26 at 01:24 +0200, Tobias Doerffel wrote:

> +       err =3D rfkill_register(sc->rf_kill.rfkill);
> +       if (err) {
> +               sc->rf_kill.rfkill =3D NULL;
> +               return -1;
> +       }

Missing rfkill_free, and why -EPERM? Could you try to work against v11
of my rfkill patch, or better even against the cfg80211 rfkill instead?

johannes

--=-pwMUlbMbIYrOfiVxTAI1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKGyqaAAoJEODzc/N7+Qma4kQQAKBt0Hoca77S2xruoQ6BIojI
obzBtj6uf4xVm3S8cZhIbY5FYDT9pKWrCCHKo1dTCKUn+IEvZvyx5g63/j37Qzre
8LTjxCph8zwFZSDH9SW+UQkt3eNiFxvU/L+RIkrm9j67DHNQGUFmBKJeSTMRQbl8
YouT1/yS9cxMtBAemu4MjSQ9T4KaNpgXvJfzPlQdytKxwNIqv5NG3FMa4R9y3G98
X+hWzy6SBE1YNrwClYKqqXQg4jfeiugzn55fMLE33bQW3QiR2/pgKhfSmgUXe6Z6
vuZCVBv8BnJkzIcbYYLPYuGJMcsrhaO/9mk4ogPnzy/GMv2u2sEUDAzIQYmgbH9F
UZu4Iw0AvHfRfiE13nJ1iWvWdUV4o1kt/mZgK+97egsHiVPbuXHO+3Jm+/rVdYC+
HDaGlX7bbWrERLG7ef1A3DRdDme+jAi4OC5vZl8M1+cPNi8NxL0aQtcatpwzrnzX
HsA11YUAsLpSY07LpzdGTjgz5FkBRC2BNJ4BTGcnY6pEt2IJjJounkzzhPBc1225
FJ7JC60t57syM97LAMm9QhGFJEA8XES4c4P5er2SuCt/w/5Go6WpR5lb9b/K/MYR
LdiP0QKITSiT8n/pxtcdQmgO9xIKrsjo/1lYBQWutTpdasT/48L9CjDywT5ob2a8
seX488cSixennsH8Evy+
=bkCz
-----END PGP SIGNATURE-----

--=-pwMUlbMbIYrOfiVxTAI1--

