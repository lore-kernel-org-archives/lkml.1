Return-Path: <linux-kernel-owner+w=401wt.eu-S1751931AbZAZKwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbZAZKwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 05:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZAZKwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 05:52:21 -0500
Received: from mxpdbe1.wincor-nixdorf.com ([80.154.98.129]:40267 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZAZKwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 05:52:20 -0500
Message-ID: <497D9469.3030908@wincor-nixdorf.com>
Date: Mon, 26 Jan 2009 11:46:01 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: Max Weninger <max.weninger@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: support of touchscreen reported as eGalax but is not working
References: <20090125234902.7605fd16@zork.foo.com>
In-Reply-To: <20090125234902.7605fd16@zork.foo.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig06BA5BCBCBFAFB7342B240C7"
X-OriginalArrivalTime: 26 Jan 2009 10:49:07.0454 (UTC) FILETIME=[B678D9E0:01C97FA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig06BA5BCBCBFAFB7342B240C7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Max Weninger wrote:
> Hi
>=20
> I recently got a used USB touchscreen and try to get it working
> It looks like a eGalax type but not really is :-(
>=20
=2E..
> /proc/bus/usb/devices gives
>=20
> T:  Bus=3D02 Lev=3D01 Prnt=3D01 Port=3D00 Cnt=3D01 Dev#=3D 13 Spd=3D1.5=
 MxCh=3D 0
> D:  Ver=3D 1.10 Cls=3D00(>ifc ) Sub=3D00 Prot=3D00 MxPS=3D 8 #Cfgs=3D  =
1
> P:  Vendor=3D0eef ProdID=3D0001 Rev=3D 1.00
> C:* #Ifs=3D 1 Cfg#=3D 1 Atr=3Da0 MxPwr=3D 44mA
> I:* If#=3D 0 Alt=3D 0 #EPs=3D 1 Cls=3D03(HID  ) Sub=3D00 Prot=3D00 Driv=
er=3Dusbhid
> E:  Ad=3D81(I) Atr=3D03(Int.) MxPS=3D   8 Ivl=3D5ms
>=20
> I compared this output to other eGalax and discovered some differences
> like that iManufactur and iProduct is not filled also
> bInterfaceSubClass and bInterfaceProtocol

Looks like a touchscreen which is supported by a closed(?) source driver
of eGalax we have here too:
$ /sbin/modinfo tkusb.ko=20
filename:       tkusb.ko
license:        GPL
description:    USB TouchScreen Driver
author:         eGalax Inc. http://www.egalax.com.tw
srcversion:     B0872D8913B07BF5665B5BA
alias:          usb:v3823p0001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EEFp0002d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0EEFp0001d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1234p0002d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1234p0001d*dc*dsc*dp*ic*isc*ip*
depends:        usbcore
vermagic:       2.6.17-8.wn mod_unload 686 REGPARM 4KSTACKS gcc-4.0

You can obviously download the drivers from
<http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.

It would be great if eGalax could be convinced to get these drivers
included in main-line ;)

Hope that helps,
Niels


--------------enig06BA5BCBCBFAFB7342B240C7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJfZRp5KAkGQPO/QoRApr0AJsHWbTgwZZ6kmkGTeig0kNjJts7/QCgmrCJ
AABvbx/e9xcJrsyMpcpzuqg=
=Tv+i
-----END PGP SIGNATURE-----

--------------enig06BA5BCBCBFAFB7342B240C7--
