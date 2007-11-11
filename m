Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbXKKS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbXKKS6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 13:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXKKS57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 13:57:59 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:53724 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbXKKS55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 13:57:57 -0500
Date: Sun, 11 Nov 2007 19:57:54 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-g74521c28: oops during boot [<ffffffff881c03e4>]
 :power_supply:power_supply_show_property+0x94/0x150
In-reply-to: <4736EE1C.3010500@archlinux.org>
To: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <473750B2.4060208@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enigE959CCE834E498A157A35761
X-IronPort-AV: E=Sophos;i="4.21,402,1188770400";
 d="asc'?scan'208";a="33892534"
X-Enigmail-Version: 0.95.1
References: <472C5C2D.9010700@archlinux.org> <200711031926.01665.rjw@sisk.pl>
 <472CC005.4070609@archlinux.org> <4736EE1C.3010500@archlinux.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE959CCE834E498A157A35761
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

>>> http://bugzilla.kernel.org/show_bug.cgi?id=3D9299
>=20
> I just tested again (with 2.6.24-rc2-gecd744ee). If I only load the 'ac=
'
> kernel module and not the 'battery' kernel module, then the system boot=
s
> fine. However, if I load the 'battery' module during boot or later, I
> still get the oops.
>=20
> I am running 2.6.24-rc2-gecd744ee right now, but without the battery
> module. I am forwarding this to the ACPI list as well.
>=20

Replying to myself again. Apparently, a fix for this bug was applied to
the linux-acpi tree independently of my bug report, see here:
http://git.kernel.org/?p=3Dlinux/kernel/git/lenb/linux-acpi-2.6.git;a=3Dc=
ommit;h=3D4c41d3ad6544f1c9aec37c441af04f5d0ad3a731


--------------enigE959CCE834E498A157A35761
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHN1CyEda5KzHP/VARCBymAJ4uepr2VPU487E2ir0wK5LwhHHWjACeM+UI
v87KwP053+vyPml53qnTYZA=
=tQJ+
-----END PGP SIGNATURE-----

--------------enigE959CCE834E498A157A35761--
