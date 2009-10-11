Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZJKKJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZJKKJj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 06:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZJKKJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 06:09:36 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979AbZJKKJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 06:09:36 -0400
Subject: Re: NOHZ: local_softirq_pending 08
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20091011095217.GA2200@darkstar>
References: <20091011095217.GA2200@darkstar>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jeXzTCDyo+eyGDHJK11A"
Date: Sun, 11 Oct 2009 12:08:55 +0200
Message-Id: <1255255735.4095.53.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jeXzTCDyo+eyGDHJK11A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-10-11 at 17:52 +0800, Dave Young wrote:

> With kernel 2.6.32-rc3-00052-g0eca52a I got following KERN_ERR
> messages just while using firefox:
>=20
> [  130.527399] NOHZ: local_softirq_pending 08

> Any idea? or known issue?

Are you using b43 (or wl12x1)? If so, it's a known issue, but the driver
was recently left without an active maintainer in a brouhaha about a bug
fix.

Cf. http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440

Absent proof that mac80211 is safe to run with BHs enabled, the correct
solution is disabling tasklets around the RX function, unlike all the
proposed patches. However, Michael thinks it's such a bad solution that
he has refused to implement it. So far, nobody has bothered to fix the
drivers.

FWIW, I believe the bug to be in b43 and wl12x1, and not as Michael
thinks in the stack.

johannes


--=-jeXzTCDyo+eyGDHJK11A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK0a6zAAoJEODzc/N7+QmalLEQAJE7mPME5/ZV+QiHOa9a6QMS
OsuriRx25ka6aPfesWzULByBNZp9bFUKXAl/cQPwmULowxxBUduNnWwcAJcJD+B2
BWOeNvOplouWpk7Fa9DpmuHhYBxsOoxIQrlnWisPh1OZQfsgnGeqAjpyOA2oiYmM
LOupMlsHullIEeUW+vKpVWxUGmKQrMEvzZXPT/c6RYz9/1m/YzVuc1vejm2X0Isj
ZhaA6fKaRNqc75BswzeB2e0TFjK1rRR2D4AftKmWuZ3ZISPeqNU85Db5kXWYYQTy
gdpgV+vaYZFgkf/gcNzKpJ9C+LpAWgPOyYnvhOHX8cDbI7ihSMOcVI+EmbNuQqh0
NU5bRszebTjgFxXt2AfjwI0V1d0Hr6dIOmtAB73xEtqGaEUc9BKKidhkN6ThJEmm
+ikSq3Z/8h3N+V3N2iWboJxQzzqQBEFezSin+R3+k35/hCdr/HWNRE8VqloMisow
fQlHLPmfVf+4msK2pGLt3JwxoPa6NclVzW2ewq017ZCKT9HYtBKX31QVAGPOzcsF
PCweNWJ3kEpyZl1EwtynykQHRjggFFt40qRyBmRGEY9wmKujHnekFzQaLu/mgEM3
2F6sIWRNg7dQzmDOriVz9BF8wkg1iqKRnd+S17ESxzysylKu0z++6Ekt6DqzrulG
9Pe4T5RbtKlZZ5FnBq2k
=Tvl/
-----END PGP SIGNATURE-----

--=-jeXzTCDyo+eyGDHJK11A--

