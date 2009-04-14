Return-Path: <linux-kernel-owner+w=401wt.eu-S1755912AbZDNW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbZDNW2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZDNW2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:28:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbZDNW2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:28:44 -0400
Subject: TRACE_BRANCH_PROFILING breaks gcc warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uJnmUmClaXCFiLwmfi1p"
Date: Wed, 15 Apr 2009 00:28:10 +0200
Message-Id: <1239748090.4205.26.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uJnmUmClaXCFiLwmfi1p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

With TRACE_BRANCH_PROFILING enabled you get "dummy may be used
uninitialised" with code like the following (and gcc 4.3.3):

void *dummy, *c;

if (a && (dummy =3D b()))
	c =3D dummy;

Therefore, allyesconfig has become useless for looking at warnings.

:(

johannes


--=-uJnmUmClaXCFiLwmfi1p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5Q32AAoJEKVg1VMiehFYRvQQAKoCHL8WfsdklUF2tnPlbcoY
ADXuK4ilq4UlaFjCdG+90RGL8s72fNE3q3i/kqI1eI1QrGgc9qiTDGitYew/gw5T
oZwf7nFefDDD9KAKWP36sUlaOR71ySmijzsIScTugBeuxlYRUvmnPfrkH07va3wb
X+Lk8qAM3RyNzI3ObbWK+eoDxwkdf4oSPLb3vZc7vCHkQmjpgSozwQAtwhleG/b/
FKBympm/FPaiezve9PufRFgGVatB8p3cK6SP0c2UzN4SrYW1X33uOSHTpmKXkxSk
BHZyEYGOUsLoW1oDrPsvKwWRrSzmnQ2K1Af9dhCQaEG6cJistDyJ0nwRtUzCPTSF
siTD2awa6prva/uZTNhYYCHu+txp8Otw4IjbvAz7hgbHwLKExQ93+G6HSZflOPT1
0zqpqg30bQclhRGMPVXFaDn3SGF58aYx9l4mSPQRjaDbUDcNTAaxdpGdbNhrE6F3
cIraqO8IEcH/q42Z5i2pcyNS95R337UTEQo251veLEoQlsFabOQcTTNxNrkisdqD
cmRW+49FyN/jsWM16H5o5DN3lAltFuLjRD0ORyaIRkjrobYeyvF9icZJ4PiYB5/S
4IMpI+kbACUW1/uMVqL6/Ms8m1fDiXGUB8mEOr5GMz1uM1giKS3z6N9PlXRP19CJ
ocoINDpuPDjCYoBpsyOb
=PBW+
-----END PGP SIGNATURE-----

--=-uJnmUmClaXCFiLwmfi1p--

