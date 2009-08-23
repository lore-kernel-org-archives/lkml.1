Return-Path: <linux-kernel-owner+w=401wt.eu-S934072AbZHWNdC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934072AbZHWNdC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:33:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934058AbZHWNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:32:58 -0400
Received: from smurf.noris.de ([192.109.102.42]:30440 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934022AbZHWNc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:32:56 -0400
X-Greylist: delayed 1319 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Aug 2009 09:32:56 EDT
Subject: Re: [PATCH v2] scripts: add typdef removal tool
From: Matthias Urlichs <matthias@urlichs.de>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, Joe Perches <joe@perches.com>,
       devel@driverdev.osuosl.org, akpm@linux-foundation.org
In-Reply-To: <20090817060203.GL5039@cr0.nay.redhat.com>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
	 <20090817060203.GL5039@cr0.nay.redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jpiZwrQJ5XjuKy7KZfKl"
Organization: {M:U} IT Design
Date: Sun, 23 Aug 2009 15:22:53 +0200
Message-Id: <1251033773.10339.1105.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jpiZwrQJ5XjuKy7KZfKl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-17 at 14:02 +0800, Amerigo Wang wrote:
> These two 'find's can be merged:
>=20
>   find $REM_PATH -type f -name '*.c' -o -name '*.h'
>=20
You mean

find $REM_PATH -type f \( -name '*.c' -o -name '*.h' \)

or

find $REM_PATH -type f -name '*.[ch]'

Otherwise, directory names ending in .h will cause false postiives.
(Yes, I know that we don't have any of those at the moment, but =E2=80=A6)

--=-jpiZwrQJ5XjuKy7KZfKl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqRQq0ACgkQ8+hUANcKr/mU8wCfWFk44fNo4Lu199Bt8keWTcTg
XaAAni6Adnd0G6pTd7jatta2YVv/QtcD
=Yygy
-----END PGP SIGNATURE-----

--=-jpiZwrQJ5XjuKy7KZfKl--

