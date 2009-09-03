Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZICSRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZICSRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 14:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZICSRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 14:17:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38524 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059AbZICSRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 14:17:37 -0400
Subject: Re: [PATCH] cfg80211: clear cfg80211_inform_bss() from kmemleak 
 reports
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
References: <1251958266-10692-1-git-send-email-lrodriguez@atheros.com>
	 <1251962791.3336.3.camel@johannes.local>
	 <43e72e890909031113r6010519br3b81d15cc331ba85@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8SVsRaDgTkfpfHnoZCbH"
Date: Thu, 03 Sep 2009 20:17:17 +0200
Message-Id: <1252001837.9336.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8SVsRaDgTkfpfHnoZCbH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-03 at 11:13 -0700, Luis R. Rodriguez wrote:

> What I meant is it gobbles it up and spits another thing out. When it
> gobbles it up the routine then uses kref_put().
>=20
> > Why can it not track this?
>=20
> It probably can, just not sure if it follows kref_put(), I was under
> the impression here it doesn't and because of it we were getting false
> positives. Catalin, can you confirm?

Ah I'd think that if it can't track it then that's because we use a
pointer to the middle of the struct to keep track of it much of the
time.

johannes

--=-8SVsRaDgTkfpfHnoZCbH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKoAgqAAoJEODzc/N7+QmaJqkQAJ4JIzLJDmWS6Wx6WI2mmVnz
ku+ON9OhOUtSIQXtr67UiIFhYUMe4+DCiqfNxaJ8QoalY/F+Qqf0zeLhneXJs3TZ
X0Ch+dC/3U9rKWlpOApGMSJaJjnKUyb/hfPrRLBnwNVbSoyeXptkkEzjW6ZWqx2o
yg1drotgroho1KxZVl2a1katemcPXzumMnmkbd44dOr9F0H8QD9K+/yJwgfzu8pp
5dSntyRFcyPP/5SRbiia5nTwZALxwJvwli3gS7WemnBozQQB+V4uCao1sIwTCaau
ddGXbpHqT0/5nF/s2fB6e+a/5ZQ/oNa6v02iCIhnlncfHkXZRjlYnEnvn2mz/m6m
i8kThUM6b2e+uH08Oq65kYvMGEx3HkPCgRm/zFfWXcgwTMMtz1T/2NfuC+Cmo+mI
zAUHYwqMMC7LbonNCk9JxIW+1iwFL55Q2bgthKE4c6jBSipFs+J9GnuYKZiUUtbI
S9hrXDCGYPOzwVMzu+Z20AFX1W+lJ0jIYLZGKHvCQzHcSIdlyvzOi8dp7iFtBBWy
ZLTs8reQ7aU+mBcUgzV22s3K9Ll2cfxL3emm9O+aGl30R5i9OQHXTH05oSXRo4tk
1jm0IFA/Z36j9hcZt/ESPAqCGYCTlSkks7320wtEC1pTqA1l96wOk8BhN2PH3qTB
rXCK2HBW6tUyFv/3NoY4
=uP1G
-----END PGP SIGNATURE-----

--=-8SVsRaDgTkfpfHnoZCbH--

