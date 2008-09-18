Return-Path: <linux-kernel-owner+w=401wt.eu-S1756300AbYIRQq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300AbYIRQq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYIRQqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:46:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:57658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYIRQqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:46:19 -0400
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and
	rfkill->get_state()
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, John Linville <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20080918164339.GM1583@khazad-dum.debian.net> (sfid-20080918_184349_935626_1261357F)
References: <20080918145236.GJ1583@khazad-dum.debian.net>
	 <1221751166-9927-1-git-send-email-hmh@hmh.eng.br>
	 <200809181724.03723.IvDoorn@gmail.com>
	 <20080918164339.GM1583@khazad-dum.debian.net>
	 (sfid-20080918_184349_935626_1261357F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b7eJR4XjKi7of7rMOJqF"
Date: Thu, 18 Sep 2008 18:45:39 +0200
Message-Id: <1221756339.9262.86.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b7eJR4XjKi7of7rMOJqF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 13:43 -0300, Henrique de Moraes Holschuh wrote:

> Now it must do something like this in pseudo-code:
>=20
> 	1. if (the bit is disabled (i.e. SW rfkill is NOT ACTIVE)) {
> 		rfkill-SW-status =3D disabled;
> 	   }  else if (the bit is enabled (i.e. SW rfkill is ACTIVE)) {
> 		if (tx power off is NOT ACTIVE)
> 			rfkill-SW-status =3D enabled;
> 		else
> 			rfkill-SW-status =3D whatever the user asked
> 	   }
>=20
> THEN, it should use rfkill-sw-status, along with the hw rfkill line statu=
s,
> to synthesize the state it must pass to rfkill_force_status().
>=20
> ICK.  Of course, if the driver has another way to implement txpower off t=
hat
> does not clash with sw rfkill, the above is unneeded.

Why are we not handling soft-rfkill in mac80211 entirely?

johannes

--=-b7eJR4XjKi7of7rMOJqF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0oWuAAoJEKVg1VMiehFYmg4P/R2ix8QvQ8C/Tc5HVbwk2k8r
HxcdL7ksGsZzKRi6RU/fkap+JHqHlTEOJDlFo8Bm/1rg+JydMHweSCGWjPJKYNTe
XLQf1CymVg4Y07NwYdLfi2AZyxzaegIH1PPV63aAYCM5kVaTXY6+n7z7bofeD5fa
TLb2ET3Y7IJChiGbvMa7kK5a8cSYiGm5vWTct64/XAOLyHxODzwhu+vTnGqMb351
XoEhCT44H93X/MIFeJk/4jsxaPglAGZn/iJe5n1a83x1/t02stBFtObTSSJnIyhf
/8qxvHpUCaSnAnc3EGHYv37JLqxWWPwfahs45T7Hiau87uVpl2LIRaZfDQidGp6y
EZdw1kLyVfpcCfZaK4dW1Pk2OumZZsDSw9F5HHGnKA4yrcWmQvU6CgkdF2G12Luv
7vhgTrCtg+9SFvzpYiHpnPJoaB2PD4Mr4qvZepUuyDnq3BlpVIJroON1XriBXGZn
+8TOBSJGdImtf/Bh/i538ZBm3H//2YiNaUyKrueDW9jEuUZUUg8JFx+KfKJWn2Hc
sycxOt+CZFfFejYQBPceMRZkx4ifM2Wfsy4SCz5vvoLsJ7ex4ZiCvRNaLBz8jHhM
RpcsFzkzewRB+D4nivdArhbH+L6Q1FA5ri/sStB+C5SaG2V8SX34Kl+HyANlwjMt
IBZ7rCI+EgD+Z61HUfNm
=oaZO
-----END PGP SIGNATURE-----

--=-b7eJR4XjKi7of7rMOJqF--

