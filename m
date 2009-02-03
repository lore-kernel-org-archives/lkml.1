Return-Path: <linux-kernel-owner+w=401wt.eu-S1759086AbZBCAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759086AbZBCAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 19:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbZBCAsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 19:48:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58819 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbZBCAsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 19:48:08 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: Add support for VMU devices (v2) [1/3]
Date: Mon, 2 Feb 2009 19:48:01 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.28; KDE/4.2.0; x86_64; ; )
Cc: greg KH <greg@kroah.com>, dwmw2 <dwmw2@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>
References: <1233619569.13918.12.camel@localhost.localdomain> <1233620263.13918.31.camel@localhost.localdomain>
In-Reply-To: <1233620263.13918.31.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3028677.rxxFT817vE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200902021948.04031.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3028677.rxxFT817vE
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 02 February 2009 19:17:43 Adrian McMenamin wrote:
> +	if (src_ofs >=3D ((card->parts)[partition]).numblocks * card->blocklen)
> +	if (num > ((card->parts)[partition]).numblocks)
> +	pcache =3D (card->parts[partition]).pcache;

ive only quoted some, but the use of parenthesis here is pointless and imo=
=20
makes the code harder to read.  it's like trying to parse lisp ;).

> +	vblock =3D kmalloc(sizeof(struct vmu_block), GFP_KERNEL);

sizeof(*vblock) ?

> +static int __init vmu_flash_map_init(void)
> +{
> +	maple_driver_register(&vmu_flash_driver);
> +	return 0;
> +}

shouldnt this be:
	return maple_driver_register(&vmu_flash_driver);
=2Dmike

--nextPart3028677.rxxFT817vE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJh5RDAAoJEEFjO5/oN/WBRykP/iv7lqy/HPvyJ6uGn9lnDJTQ
U/SP1CdoPdRekhY4cn0dmjmHhVk6NXtSy5Pm+TXJ3c024WEdU5MSu0h4ZVvJ77cF
v44SU7rSBwvaGruUhMEpRzMdmBvaqrun4G7NhHcK5KT6Qkc9mKuC1vPVfJ8n9Na1
4dTQv3dScf1y7RmETJwdUcfrleIE3bDODXOhI3MXoRKVpI96KRWJUp/bNGwxUEzB
Gq6+lObXsCWD2rIhgMkRVC6dstb1A/RRkseH12DGyY51ke6mLMsnDuhAMJ0fhn/r
jbwIrI//G+Hj00uWrmoBLz3idom9kgW2sTJRtjrnVg0++mqLpl+X9MMUdBHb1gsK
Nz+JD6CVwdeZIfzEAJCBO6xa4U7v22cS9abxnpZd2Y7AsCyYgGCikymFoNlXMwr8
39voMlruHucFzXABa0OTldRsUYjnO2GbmGtj3ARcBLIW1Vfpsn95TgPjMj4m6KlH
gXHkFXFr6NpHOe98RgNBD9zrf+rPcOorWyGRAIpmwyzVoli3IEswgJhbbyeD15aE
hxy8dmcmd689i/rMCc0Wr43zpW5WH22ugHwP1+kwDIJZeT+ATJ8L1WW1xvVKdLcp
PTOZFij5W4laVhUGIsZMrNf13v5AJpRL4ouTbFiX02fIyROE5lcA86C+aehyEx2k
ULxC3loEadAwU/58cap4
=Iz4Y
-----END PGP SIGNATURE-----

--nextPart3028677.rxxFT817vE--
