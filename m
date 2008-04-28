Return-Path: <linux-kernel-owner+w=401wt.eu-S935113AbYD1RjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935113AbYD1RjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:39:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934201AbYD1Ri5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:38:57 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765669AbYD1Ri4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:38:56 -0400
Subject: Re: [REGRESSION] Trouble seeing some wireless networks in latest
	git
From: Johannes Berg <johannes@sipsolutions.net>
To: Priit Laes <plaes@plaes.org>
Cc: Michael Buesch <mb@bu3sch.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1209315625.4095.4.camel@localhost> (sfid-20080427_190124_741883_54F863BD)
References: <1209288298.3851.12.camel@localhost>
	 <48149F2B.4000503@lwfinger.net>  <200804271748.49377.mb@bu3sch.de>
	 <1209315625.4095.4.camel@localhost> (sfid-20080427_190124_741883_54F863BD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HDvOvdVi0Jbo2yWZ+Gn/"
Date: Mon, 28 Apr 2008 19:38:45 +0200
Message-Id: <1209404326.29025.5.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HDvOvdVi0Jbo2yWZ+Gn/
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-04-27 at 20:00 +0300, Priit Laes wrote:
> =C3=9Chel kenal p=C3=A4eval, P, 2008-04-27 kell 17:48, kirjutas Michael B=
uesch:
> > > > Any hints how to debug this further?
> > Nah, it's a regulatory setting issue.
> > The default regdomain is US, which only allows chans 1-11.
> > There's some module parameter to switch the regdomain.
> > This is not a regression, but a feature.
> >=20
> Regdomain setting seems to be OK (and missing for b43):
> =EF=BB=BFiwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels

This should really read "EEPROM tunable channels" instead, cfg80211 will
further restrict it.

johannes

--=-HDvOvdVi0Jbo2yWZ+Gn/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBYLpKVg1VMiehFYAQLMOg//RcWupjJZsxUmMD1ia4jtoCCb915jPZfS
/2L8KCC6db+YxPhoIj/1Rq2YogGh68x5mL0ugzctGYPkwA/W5XN1jWCh+aU4eiJg
kjKv2uYKfqwMld7Ja/OMTcvehfISz04YgU3B5SDPooHRpHGZHzyFQZKbCCfUY6Ws
dIULzK5bYqTpeCj8CCQ2JLM5Ukg8VMUeBWhRGm87jPdnc6CkUd1xY9zu/ZWFb6wv
bfGdgW40lqPD4X7K4x4NP6MUMWsfDhnkSpsdyj1zA5k2/OIdQwZzWidyrb20uRky
HS5ePHK8GxPfvrnQYmjb23mSS9Cztxk3J4aM7phXatJ9vl0s3PorXyEhHrBa15fK
6TO3Ifz+YuTqx19jt7rnLB8/5nUVAalciy7dq5P0t9MXPgld1zytHFrO/qhsRAFu
2TImlAdHhjgBKWCOYbJURUR8IZcxargAli5h8p65iYPpzXfDxn7NxKwmxXolxL7D
9wfyaY54Yi3TEc6kBQEk90DJ46Lj4X09nQgaCINBFogZT9AdvoqB97ZlYqUIKo6L
MEzB705PqXY43KUMjRlBVadL6fJv+V71WUP12FXq+kfWrQva6fnaI6ZPq/OUXHFE
KMuPuyxu4maT42KNonTXf5Vz9mvo+uQV6NCXe1Sukm3ziD20iDov6+v/BrkWYeOe
A6S6kOL6csE=
=4NaT
-----END PGP SIGNATURE-----

--=-HDvOvdVi0Jbo2yWZ+Gn/--

