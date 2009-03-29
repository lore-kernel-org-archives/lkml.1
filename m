Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbZC2Rwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbZC2Rwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 13:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbZC2RwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 13:52:22 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:61807 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbZC2RwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 13:52:22 -0400
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.38,442,1233529200";   d="asc'?scan'208";a="6434494"
Message-id: <49CFB553.1020800@archlinux.org>
Date: Sun, 29 Mar 2009 19:52:19 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: fastboot/async and initramfs: How am I supposed to know when
	devices are finished initializing?
References: <49CF9BA1.5030400@archlinux.org>
 <20090329091148.16a618bf@infradead.org> <49CFA436.5080000@archlinux.org>
 <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
In-reply-to: <ac3eb2510903291036w13dc34cbi97525e6dd9af1da5@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig6D190F19285971515EDBEF23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6D190F19285971515EDBEF23
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Kay Sievers schrieb:
> In initramfs, you have to wait until the device shows up, not for a
> random module to initialize, or a bus to be scanned -- that can never
> work correctly, it's pure luck, that your logic was always slower than
> the kernel.
>=20
> You need a block device -- so you should just wait for the block
> device, instead of making assumptions about initialization of drivers
> or buses. :)

I am planning to do that but there is one problem: Usually, the user=20
specifies a root device, or a device that I want to open with=20
cryptsetup, or anything similar and I can wait until it shows up.

For lvm however, the user does not specify a specific block device that=20
I can wait for, instead lvm scans all available block devices. Now, how=20
do I know that the block device that contains my physical volume is=20
already there? Maybe I have several hard drives, and several volume=20
groups, so should I now call vgchange -ay again and again until the=20
right volume group shows up?


--------------enig6D190F19285971515EDBEF23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAknPtVMACgkQEda5KzHP/VAYywCfbaCbPN3/XiwEhCHIHijyp1F7
w6sAn181yrOihcDiDEnOe8sM9FjyITN8
=B0tm
-----END PGP SIGNATURE-----

--------------enig6D190F19285971515EDBEF23--
