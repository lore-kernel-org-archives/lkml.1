Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZCUMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZCUMLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbZCUMK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:10:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:44831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZCUMK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:10:57 -0400
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <b6a2187b0903200914r23d635c9obc55b30b7cc04382@mail.gmail.com> (sfid-20090320_171427_332673_B71D0D63)
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
	 <b6a2187b0903182149x77e416ecuf73be2970173c601@mail.gmail.com>
	 <1237455534.5100.56.camel@johannes.local>
	 <b6a2187b0903192155q33510b57l9d5927538a0f4f99@mail.gmail.com>
	 <1237537967.5100.135.camel@johannes.local>
	 <b6a2187b0903200304l469e3eeet87c51b1cddb43ea8@mail.gmail.com>
	 <1237544033.5100.143.camel@johannes.local>
	 <b6a2187b0903200914r23d635c9obc55b30b7cc04382@mail.gmail.com>
	 (sfid-20090320_171427_332673_B71D0D63)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yoAsfB/ad+FmHrXW6y3a"
Date: Sat, 21 Mar 2009 13:09:35 +0100
Message-Id: <1237637375.5100.178.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yoAsfB/ad+FmHrXW6y3a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 00:14 +0800, Jeff Chua wrote:

> I went back to 2.6.28 and found out that I could associate as follows
> (but this would not work in 2.6.29-rc8 ... should work with the
> patch).
>=20
> modprobe -r iwlagn
> modprobe iwlagn
> iwconfig wlan0 mode Managed
> ifconfig wlan0 up
> iwconfig wlan0 essid "xxx"
> iwconfig wlan0 key restricted xxx
> iwconfig wlan0 ap auto channel auto
> iwlist wlan0 scan >/dev/null

Thing is that this works perfectly fine for me, on very similar
hardware.

OTOH, maybe it got _fixed_ again. Would you check wireless-testing
(http://wireless.kernel.org/en/developers/Documentation#wireless-testing.gi=
t) for me? Or compat-wireless (http://wireless.kernel.org/en/users/Download=
)

johannes

--=-yoAsfB/ad+FmHrXW6y3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxNj9AAoJEKVg1VMiehFYtR0QAKTf7xrImi8vzq3looDokqgF
Ky/+xH06/PRSf8VxeB89SSyridRagfky1jalBbx08lpYMD9qQoX9GI92oOJ6JZkk
trIFHnhtKegYG0+ff95gjqstCsaEY6XFSNLthTfshv5UMfILjmy6QsAjCLbICeLd
dfuDoB2Rg1/5pRi59Hr7s7DNHeTk1ieOy/2jNgoFpfJZEvElD2zVxFZ9j9gFN8Ny
yx6IrtnfHTAEyL223RGv87dXp8f//jFlW6/tiJUbvZZDiG8K8qnPVIvNaaTZ8AtW
QSYAG0Sao59E8qwJ3h5UQpOaB0Gt4vplBVjfxtEO4xXllztE7j9dHVjRcRiN/dZb
FdtN1WnRw2cgpInGcIf9Mwvds1dcINfIy2W2jpjymNFN7ZX6r84OqoDjGa1Z7bgG
s9imYFoN/orXewS5er4gvWi8lQhMMoQcIc3dw+po0t9NthwxPW/SaDKJ+BPuX4Ut
GFKVRExTGUFrrR2H9fzrAd0N7Q1d2UBxDXICIzncymaOjWTMrpMwHT5TT67A/7Xy
+VqRypXBgsr/PlMWt+INgCUpuC4armFAXV6h6W0KLBfQz4QCWNdAEijxGYAI8N10
YCvUB+fRiIgqnneMMp2uFx8VowxDIk5IAdnFwq/sMUvfmw82ThS8GOXl7sNsIqIn
GVY6emMiE3Ez2ayNZNj+
=P6f9
-----END PGP SIGNATURE-----

--=-yoAsfB/ad+FmHrXW6y3a--

