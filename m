Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444Ab0AWNNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0AWNNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 08:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755204Ab0AWNNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 08:13:46 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:60347 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab0AWNNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 08:13:45 -0500
Message-ID: <4B5AF5FF.6050702@web.de>
Date: Sat, 23 Jan 2010 14:13:35 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Miller <davem@davemloft.net>,
       Karsten Keil <isdn@linux-pingi.de>, linux-kernel@vger.kernel.org,
       i4ldeveloper@listserv.isdn4linux.de, isdn4linux@listserv.isdn4linux.de,
       netdev@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 31/31] CAPI: Officially claim char major 191
References: <cover.1264201406.git.jan.kiszka@web.de>	 <445e1bf881b6f8b6a5886d6eee70f6435a5619d6.1264201408.git.jan.kiszka@web.de>	 <20100123122430.5a078b4a@lxorguk.ukuu.org.uk> <1264250892.3469.52.camel@violet>
In-Reply-To: <1264250892.3469.52.camel@violet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig64C0F6C8F6B9EEC14775D2D7"
X-Provags-ID: V01U2FsdGVkX18OR7n4IZcoj+G5YgChhKCz2hwQK4ZC8ZKsQaT+
	OzsL/49ZY9nU9V40UqGi60j79tfvL/zY7xPCDExy+Pz32Vyv5V
	vZCZpPK3U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig64C0F6C8F6B9EEC14775D2D7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Marcel Holtmann wrote:
> Hi Alan,
>=20
>>> I found no trace of this mysterious "pcl181" device, neither in-tree =
nor
>>> out there in the wild. At the same time, the in-tree CAPI middleware =
is
>>> using major 191 for many years now and obviously without any conflict=
=2E
>>> Let's officially claim this major number.
>> This is not the way it should have been done but whoever needs spankin=
g
>> got away with it years ago. Given that this seems the best way forward=
=2E
>>
>> With LANANA hat on
>=20
> actually in the days of udev, the capifs is not really needed anymore.
> The right choice would be to remove it. I haven't been enabling it sinc=
e
> years.

First of all, the capifs story is orthogonal to the major claim.

But basically you are right, capifs is likely not needed anymore. The
only user visible change - and that was holding me back to suggest its
removal - is the time when the NCCI minor ttys show up under /dev/capi/
(or wherever you direct them to). If I didn't miss something about udev,
it will make all possible minors pop up once the major is registered.
However, I'm not sure if there is some userland actually relying on this.=


Jan


--------------enig64C0F6C8F6B9EEC14775D2D7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEUEARECAAYFAkta9gMACgkQitSsb3rl5xQJzwCg5XSeY79DUfnbksivaf+P11oV
VLIAmKF9AZx5eLoFAW8ztsiUpiiQwvE=
=XSl9
-----END PGP SIGNATURE-----

--------------enig64C0F6C8F6B9EEC14775D2D7--
