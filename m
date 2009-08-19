Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZHSSn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZHSSn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZHSSn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:43:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZHSSn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:43:26 -0400
Subject: Re: [PATCH 2/3] Add rfkill support to compal-laptop
From: Johannes Berg <johannes@sipsolutions.net>
To: Mario Limonciello <Mario_Limonciello@Dell.com>
Cc: cezary.jackiewicz@gmail.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
References: <1250706969-10382-1-git-send-email-Mario_Limonciello@Dell.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nYXA9SiGEd7OD+CwqUNb"
Date: Wed, 19 Aug 2009 20:42:56 +0200
Message-Id: <1250707376.8073.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nYXA9SiGEd7OD+CwqUNb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-08-19 at 13:36 -0500, Mario Limonciello wrote:
> Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
> Reviewed-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

> +	ret =3D setup_rfkill();
> +	if (ret)
> +		goto fail_rfkill;
> +
>  	printk(KERN_INFO "compal-laptop: driver "COMPAL_DRIVER_VERSION
>  		" successfully loaded.\n");
> =20
>  	return 0;
> =20
> +fail_rfkill:
>  fail_platform_device2:

Isn't that missing sysfs_remove_group()?

johannes

--=-nYXA9SiGEd7OD+CwqUNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKjEetAAoJEODzc/N7+QmaD/IP/jOs9tXj4Iw4h5kLh2UNKAS6
n16HcvOKu4EvK/01ag9iCUUxvmbqWvQcN3tv+taTgRpDD8L3Huh355PycoNzN18c
HbDOp/QYPV0c8YNeLjXH3sHOCwINrp9i8SwW2d5mqE4xocLnV/y9qXRHkYbKWgJG
IUc0oOf9xC1h/6LuEfKL7OZcG3RyMucPc9nu9hufcmiAx1b/4t7FwuHN4FA7Lyat
ew+5rhcUiiq/HkUPWUe9S+bso5QmG3KIXn1J0yRuBzWoV9KhqGxKCSccrGL7Size
EtfJqG3EbGC5dBcoj2NQDBORYuTeZbkdbMUAhs6nP0YaQIJKHe3qy/kvx1mf1JRr
Q0X4hWg9BiEYl6W3+TEhoi0PCrCeQ/CzY/8aQZ2wriQhEdf7njhsG+Zyop5gW5jY
pxS2nDArtDYIwQXnsFOfdreZV5wsY9KvZBWuUOiToo+YMdH5OD22zKzanTHtFiNL
LqlR8pD/OKgZVkrVAkMcb2hDIWzm9xJISAsMdrsgNyID2jAG/3VPI2dXCTGg1g0h
VU7NnK+Xa/rhTJ3UhUsfYgfahsTaYf5TdmoYDf3ojTZwqzrcXAkWoAwG6UERg69g
AE2i6QhFazgM9IceHoZsY2ffi/NyemLeO+Wby2VQJ8oRb7z267OJWOT2pvAVWPeb
qDPYCK9P6VStp8Z6TA3u
=qCmr
-----END PGP SIGNATURE-----

--=-nYXA9SiGEd7OD+CwqUNb--

