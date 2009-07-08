Return-Path: <linux-kernel-owner+w=401wt.eu-S1758835AbZGHDHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835AbZGHDHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 23:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZGHDH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 23:07:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60350 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720AbZGHDH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 23:07:26 -0400
Subject: Re: Possible memory leak in net/wireless/scan.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
References: <1246986269.9451.105.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hw7ePegt/4QO/g8lVWSe"
Date: Wed, 08 Jul 2009 05:06:53 +0200
Message-Id: <1247022413.4755.56.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Hw7ePegt/4QO/g8lVWSe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-07-07 at 18:04 +0100, Catalin Marinas wrote:
> Hi,
>=20
> I'm investigating several kmemleak reports like the one below (it could
> as well be a false positive but it needs more digging):

By the way, what kind of machine do you need for kmemleak to be
feasible? I tried booting a kernel with it in kvm on my 2 ghz laptop,
and that was completely unfeasible.

johannes

--=-Hw7ePegt/4QO/g8lVWSe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVA1JAAoJEODzc/N7+QmaPUQP/2rY9IrdF/M7ikk727ZVo1Rs
LMovxUWcCyvK39s7tDM/yPoBZiiH0nPjUt87cEQFgMTP7omi7cFPnWQEDyiVmq5X
+drLoY2/IHAmvfRFuS5unl5OAKd18ZdAQAD1uxS/1Fj8kurVEFCmBhmrb3U9ivqE
ZMBe22XBzI7FvqPO1pcBMJa9mZvP9tjeLLVa2Onp4HnxKwoYfveKjCy0dWAu4B57
ULa1/IdGqg9m9/Z2sMqngUhG8zgp511LK84AA2+qFez8eRa1q/w0rx4f22ZohVCP
GAGuARZG9gAjwaWK5dgqUz+PDXuCUcEFE2yStDoDxL2T20lvTALMCqLWhTRSn4vC
+hPn/cVk/sIVYnregh9QzxBAoKZgCDMtmNfA2ztFLzbRmNJWqIKFcFwvGOZBUqBS
X2evYzJcb5kWVYQkfTtH+kWtmXuPwuH2/An4p9+KVVpbIpv0q6EFYsdns7lsfGBI
9duu8lEv0mFTH6aMEVrA9HEvfi8VvQhor2bBngbIinO8eOqKZ8pd+J09W0t0MCJv
NDfvOv3irOvPqoNHbH+jfJrPfiudrF75IVAmkCAeMF/r04iQpGHpPuEJ1sC7Sipi
aD+ekVgttBqSzFFZSlAdBvktRsSyebxmutNCYJRDkmmle+Qfy+Z4a8HFUOvJOjKV
5AhyU/0l2KCjb8itNRJg
=I8C/
-----END PGP SIGNATURE-----

--=-Hw7ePegt/4QO/g8lVWSe--

