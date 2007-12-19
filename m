Return-Path: <linux-kernel-owner+w=401wt.eu-S1753735AbXLSQAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbXLSQAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbXLSQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:00:42 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:57966 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbXLSQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:00:41 -0500
Subject: Re: [PATCH v3 7/8] debugfs: allow access to signed values
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mattias Nissler <mattias.nissler@gmx.de>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071219012739.6dcdd150@morte> (sfid-20071219_003309_142235_6F2FB382)
References: <20071219001955.055692620@polimi.it> >
	  <20071219012739.6dcdd150@morte> (sfid-20071219_003309_142235_6F2FB382)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vV5RfQtKUpfaWJOSKbKU"
Date: Wed, 19 Dec 2007 17:00:34 +0100
Message-Id: <1198080034.4747.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vV5RfQtKUpfaWJOSKbKU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static u64 debugfs_s8_get(void *data)


>  struct simple_attr {
> -	u64 (*get)(void *);
> +	unsigned long long (*get)(void *);

That seems wrong. Wouldn't you have to declare all the _get functions
with unsigned long long too now to avoid trouble on systems where u64 !=3D
unsigned long long?

johannes

--=-vV5RfQtKUpfaWJOSKbKU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2lAIKVg1VMiehFYAQJbAg/+L3QiUe7g57i9ckVtFVC+8w0/09b09HgS
ExHeBiyARmPEEhj7UwKGGVeXE7Nowrkx0lkBN7hjrEnnujCpMnIqgD0KuikhsJNT
TH3llpCAuyyaFqO0QhxnUntweDGp7wUK01eeazHBVJrMjwjExZjG2HgySme7rYcr
X8B8QIoUggle1x6I29KGBdnDmNgkS2Zz6Uxkcqteu/Lk1y2F3vSG1Yjx+Cgn17yT
7l9sO6Og/JT9YIMq97vSkF0kIiyJXrzCdwc/EDuj/FOgruJS2BLmXvIr63YSOTi8
Kc/G5qUBX4TCUhR9Uxx4g1Xs2EthRqrkOCxarS/RNMz0hmnkU0qSRfamn2yFKx9J
unNunhH+fAnKc8Gz2QX6QNyfJeFh+Y/1iizQr123TNZcJzmtkLp/o+Pk9uKWjXj0
+vqHqNvQ+QmqV+/mxM1bkzGfzA42BOTBIO/YyuyOksHwZOG94KgAGuqrIr0w6yRb
D+noobpQ7dsyxEJPN89U8+T9ZfauqwMW3yqcDQ32YogT07URxeguuWWL0/zaBI2A
mLXYRGfpGXYMSNn+he9NMurRLWGlqEz49o3Qy5QYeIh6xDSUIHzNWzh/l4/IcDU3
ZNUFGaOFMJiO/PipflRaXAn5RKDGp5TGQ/9NmFISxo/pPX+XU8NWoAPzbOe1Xzf0
UkXAKgeoIVo=
=6Vsf
-----END PGP SIGNATURE-----

--=-vV5RfQtKUpfaWJOSKbKU--

