Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZD3IKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZD3IKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbZD3IKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:10:04 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbZD3IKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:10:00 -0400
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vget.kernel.org
In-Reply-To: <m24ow6vah1.fsf@igel.home> (sfid-20090430_095859_848503_CEFFB30C)
References: <m24ow6vah1.fsf@igel.home>
	 (sfid-20090430_095859_848503_CEFFB30C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-g1aNS0cpVjs7sRVHcHlm"
Date: Thu, 30 Apr 2009 10:09:26 +0200
Message-Id: <1241078967.25477.8.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g1aNS0cpVjs7sRVHcHlm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 09:58 +0200, Andreas Schwab wrote:
> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
> this build error:
>=20
> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error:
> __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
>=20
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> ---
> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
> misattributed as a compiler bug.

At least in my tree the function isn't static...(yet I still got the
compiler error)?

johannes

--=-g1aNS0cpVjs7sRVHcHlm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+Vy0AAoJEKVg1VMiehFY2OAP/AomeAp34Xh0iYWBzC0noZ5M
3K6miUr1ppUCKNuzCFeHKOw/NiX6IuAo4zDp93I/lyHQ+Yy6W43UAvOVSnMy5NfY
RCSzqsZVgpCVVy+GJr+Te1DqDVpPFeTlXXNuqapX0ocKOHJkAf535KKx8qbBLNMe
vRdXsSIEmgjobspmXxM8E/+tsWO1gR8XOQtZN+ppQITgcs4XxxEFU1/6mzLXmbvv
en4hrLMyloSC58X/q8/g7M4U2qhqJHvxnCdwoliNuar0w3qi16CvZ9eLbSSzdMlg
xWcTiW6CgYnuVyaxRojXMrZGfv0OeJCFwed8kZHxaZfF+3JZLhg5/k72po/67vMG
RYD3eGgnVzeGw+w+G+vz8Zn2/oTMbgYW6wBhH6I+ZPEO4alHIVFujZR/rKEQM6s9
m2scz4wWLZJ1fJAiJ2S9NAxQZUhfas4A7nj4slsVVI9QYLVod7tKIm0OGdfN2Uu4
Gi0LyJbxj2dESI9WR8kwDgO6lK2Ho3TAbvHPbzrgGjtqzIvFSNi2UnPp0ClZgETI
TZC2RAQc9oO1qtmfa5tK72JVVmdYYBbKa6oY08xp4rGi4hPGdet61iaWmBW3Mwt9
NwAHVFWL0KU3+B7hpKTzDYDtZmegD4kBVw0idSSNYZFTpf6/BBbZWjOCgw08WaaQ
Qtxer0ulkPABvwBiYtp8
=pQh5
-----END PGP SIGNATURE-----

--=-g1aNS0cpVjs7sRVHcHlm--

