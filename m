Return-Path: <linux-kernel-owner+w=401wt.eu-S1755776AbZGUUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbZGUUuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755529AbZGUUuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:50:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:36469 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZGUUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=h3fZbBICrHzTueVHcDwcyhaVKgtxXMSlVWH/v1RlAIQDmyNSRazqeVsaSx8YEssEoI
         BH91U+MtyCR2I4uS7e4CqMd0rkfJi12sWQKqKzV49VOKRBFXqzkt2ofKvJ4CiygnGR06
         Dia3p+fI8CCTo0/0AJAFpGnklR9vxDmqZ1VK4=
Subject: Re: [PATCH 1/6] regulator: Add regulator_get_exclusive() API
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>
In-Reply-To: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8n3hcMeb/PY+p6hOCgss"
Date: Tue, 21 Jul 2009 17:49:57 -0300
Message-Id: <1248209397.4333.50.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8n3hcMeb/PY+p6hOCgss
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Ter, 2009-07-21 =C3=A0s 16:00 +0100, Mark Brown escreveu:
> Some consumers require complete control of the regulator and can't
> tolerate sharing it with other consumers, most commonly because they need
> to have the regulator actually disabled so can't have other consumers
> forcing it on. This new regulator_get_exclusive() API call allows these
> consumers to explicitly request this, documenting the assumptions that
> they are making.
>=20
> In order to simplify coding of such consumers the use count for regulator=
s
> they request is forced to match the enabled state of the regulator when
> it is requested. This is not possible for consumers which can share
> regulators due to the need to keep track of the ownership of use counts.
>=20
> A new API call is used rather than an additional argument to the existing
> regulator_get() in order to avoid merge headaches with driver code in
> other trees.
>=20
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks for finally fixing the mmc/regulator issue. ;)

Can you update pxamci.c and twl4030-mmc.c to make use of this new API?

--=20
Daniel Ribeiro

--=-8n3hcMeb/PY+p6hOCgss
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpmKfUACgkQw3OYl0G0liTI0wCbBC57yj8PR4tWnshrz96XkIcP
n3kAmwffI5mZE1n6N3Bw3bJ6ORWyiiw5
=sPPF
-----END PGP SIGNATURE-----

--=-8n3hcMeb/PY+p6hOCgss--

