Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbZHFX4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbZHFX4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbZHFX4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:56:40 -0400
Received: from gold.linx.net ([195.66.232.40]:36279 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZHFX4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:56:39 -0400
Subject: Re: [PATCH 2.6.32 v2] MCP55 SATA2 conditional MSI support for
 sata_nv
From: Tony Vroon <tony@linx.net>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockrwd@gmail.com>, Chetan.Loke@Emulex.Com,
       jgarzik@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, philipl@overt.org
In-Reply-To: <4A7B66C2.3060207@kernel.org>
References: <20090805192055.8F2DE1007C@gold.linx.net>
	 <4A7A16C9.6030500@gmail.com>
	 <412A05BA40734D4887DBC67661F433080D73228B@EXMAIL.ad.emulex.com>
	 <1249574363.4530.23.camel@localhost>
	 <412A05BA40734D4887DBC67661F433080D7322B1@EXMAIL.ad.emulex.com>
	 <4A7B633C.3040500@gmail.com>  <4A7B66C2.3060207@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ExIEFUPpzKGVIqbQcAdL"
Organization: London Internet Exchange (LINX; AS5459)
Date: Fri, 07 Aug 2009 00:57:05 +0100
Message-Id: <1249603025.30124.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ExIEFUPpzKGVIqbQcAdL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-07 at 08:26 +0900, Tejun Heo wrote:
> Yeah, if the device was enabled with pcim_enable_device(), devres will
> take of all the cleanups.

Confirmed Tejun, that pcim_enable_device call is made earlier on in
nv_init_one. I was careful to call the MSI enable at exactly the same
point between enabling master & returning control as sata_mv did.

>   No need to worry about them.

Glad to hear.

> Thanks.

Regards,
Tony V.

--=-ExIEFUPpzKGVIqbQcAdL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkp7bdEACgkQp5vW4rUFj5p8ZgCfYV5TJ1NlU1hGooJXQM2zhh5c
0PgAn1tAtXUcck9K/+kHT8RI8qETYNuj
=/jRS
-----END PGP SIGNATURE-----

--=-ExIEFUPpzKGVIqbQcAdL--

