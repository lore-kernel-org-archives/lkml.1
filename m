Return-Path: <linux-kernel-owner+w=401wt.eu-S1763482AbZD3Wf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763482AbZD3Wf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757724AbZD3Wft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:35:49 -0400
Received: from lug-owl.de ([195.71.106.12]:34427 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbZD3Wfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:35:48 -0400
Date: Fri, 1 May 2009 00:35:47 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/27] add generic lib/checksum.c
Message-ID: <20090430223547.GO12974@lug-owl.de>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
	Michal Simek <monstr@monstr.eu>,
	Remis Lima Baima <remis.developer@googlemail.com>,
	linux-kernel@vger.kernel.org
References: <cover.1241105648.git.arnd@arndb.de> <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6iXXu7NwgEt9u5a7"
Content-Disposition: inline
In-Reply-To: <cda5746ab12cf9d6bcb7803a3667c92250a29784.1241105648.git.arnd@arndb.de>
X-Operating-System: Linux mail 2.6.26-2-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological
	nuclear warfare test the bombastical terror of flooding the spy
	listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear
	warfare test the bombastical terror of flooding the spy listeners
	explosion sex drugs and rock'n'roll
X-message-flag: Please send plain text messages only. Do not send HTML
	emails. Thank you. 
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6iXXu7NwgEt9u5a7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 15:30:31 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> Add a generic (unoptimized) implementation of checksum.c in pure C
> for use by all architectures.
>=20
> Based on microblaze code by Michal Simek <monstr@monstr.eu>
>=20
> Cc: Michal Simek <monstr@monstr.eu>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
> ---
>  include/asm-generic/checksum.h |   79 +++++++++++++++++
>  lib/Makefile                   |    2 +
>  lib/checksum.c                 |  188 ++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 269 insertions(+), 0 deletions(-)
>  create mode 100644 include/asm-generic/checksum.h
>  create mode 100644 lib/checksum.c
>=20
> diff --git a/lib/checksum.c b/lib/checksum.c
                                ^^^^^^^^^^^^^^
> new file mode 100644
> index 0000000..4f80a4d
> --- /dev/null
> +++ b/lib/checksum.c
> @@ -0,0 +1,188 @@
> +/*
> + * arch/microblaze/lib/checksum.c
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> + *
> + * Copyright (C) 2008 Michal Simek <monstr@monstr.eu>

I haven't looked at the code in detail, but it would be nice to see it
show up soon. Just faced the IP checksumming code while resurrecting
the VAX port.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:         "really soon now":      an unspecified period of time=
, likly to
the second  :                                 be greater than any reasonabl=
e definition
                                              of "soon".

--6iXXu7NwgEt9u5a7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkn6J8MACgkQHb1edYOZ4buZlQCggtMS918rOtWzi8mC+00TL7ob
VD0AnjW16QiZ/8f/6yASMg128dfmMXzq
=OBwo
-----END PGP SIGNATURE-----

--6iXXu7NwgEt9u5a7--
