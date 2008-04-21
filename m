Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbYDUQLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbYDUQLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 12:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYDUQLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 12:11:03 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:37075 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346AbYDUQLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 12:11:00 -0400
Date: Mon, 21 Apr 2008 18:10:58 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
In-reply-to: <200804182151.49021.lenb@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: Matthew <jackdachef@gmail.com>, linux-acpi@vger.kernel.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Message-id: <480CBC92.4070502@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig09A50DE316E4C90017CDAD28
X-IronPort-AV: E=Sophos;i="4.25,690,1199660400";
 d="asc'?scan'208";a="62797858"
X-Enigmail-Version: 0.95.6
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
 <200804182151.49021.lenb@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080228)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig09A50DE316E4C90017CDAD28
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Len Brown schrieb:
> Hello Mat,
> I'm not familiar with "coretemp", can you point me to the exact version=

> of the application you are running so I can see how it is getting at
> the underlying information?

I think there is some confusion here: "coretemp" is a kernel module, and =

all applications reading it will probably use the lm_sensors libraries.=20
(I don't think the hwmon module are related to ACPI)

$ modinfo coretemp
filename:       /lib/modules/2.6.25-ARCH/kernel/drivers/hwmon/coretemp.ko=

license:        GPL
description:    Intel Core temperature monitor
author:         Rudolf Marek <r.marek@assembler.cz>
depends:
vermagic:       2.6.25-ARCH SMP preempt mod_unload

That said, I have two Core 2 CPUs (one mobile, one desktop) and the=20
values coretemp reports have not changed compared to earlier kernel=20
versions (around 60=B0C when idle on the mobile, much less on the desktop=
).

 > Also, do you see any change with and without kernel built with=20
CONFIG_THERMAL=3Dy?

The values I see from ACPI thermal are also the same as before (this is=20
funny: they are always about 15=B0C cooler than the coretemp values).

So I don't see a regression here, maybe the reporter should try a=20
vanilla kernel.


--------------enig09A50DE316E4C90017CDAD28
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEAREIAAYFAkgMvJIACgkQEda5KzHP/VDyKgCgv4GkMdfiTPuP2d9hz2sNc201
p5UAn0aAabx23Ku8y5Wox54kp6jAnVao
=iC1k
-----END PGP SIGNATURE-----

--------------enig09A50DE316E4C90017CDAD28--
