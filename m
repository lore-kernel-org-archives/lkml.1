Return-Path: <linux-kernel-owner+w=401wt.eu-S933513AbZJHUtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513AbZJHUtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbZJHUty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:49:54 -0400
Received: from mike.loitsch.com ([81.169.140.130]:42966 "EHLO mike.loitsch.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663AbZJHUtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:49:53 -0400
X-Greylist: delayed 1756 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 16:49:53 EDT
From: Christian Loitsch <lkml@abc.delta64.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: eGalax TouchScreen
Date: Thu, 8 Oct 2009 22:19:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-ARCH; KDE/4.3.1; i686; ; )
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2867285.TdLFfj6VYb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200910082219.43160.lkml@abc.delta64.com>
X-Warning: Could verify sender
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2867285.TdLFfj6VYb
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello

(please CC me directly)

i don't need this touchscreen any longer, and would like to donate it to=20
anybody willing to work on improved support.

10" (currently used with an MSI Wind)
0eef:0001 D-WAV Scientific Co., Ltd eGalax TouchScreen
(you can find this touchscreen on ebay)

I once was able to make the touchscreen work, but it wasn't as easy as=20
pluging the touchscreen in.

=46irst come first served, except for Daniel Ritz (the developer of the=20
touchscreen module), who has highest priority.

Please just email me your address.  I will try to update:=20
<http://christian.delta64.com/touchscreen/stillAvailable.html>
as fast as possible.

Please give me ~1week to prepare the package (and also give Daniel some=20
time to respond).

a+
christian

here are some details i found out:

There are currently 3 ways an eGalax touchscreen 0eef:0001 can be=20
handled by the kernel.

1) tkusb: a module (GPL) provided by the manufacturer, which is not in=20
the kernel and (AFAIK) requires a binary-only xorg module. [1]

2) usbhid: which recognized my touchscreen, but I was not able to make=20
it work in xorg.

3) the usbtouchscreen module.  This module only "accepts" the=20
touchscreen if usbhid did not (so I currently unload usbhid before=20
activating the touchscreen).
This module however only works if the touchscreen is set to use a=20
different mode. (loading the tkusb module before the usbtouchscreen=20
module works, as tkusb sends this mode-change command to the touchscreen=20
[2])

The touchscreen works perfectly with usbtouchscreen and evdev.  I was=20
not able to make it work in any other way.

If I understood the usbtouchscreen code correctly you would just need to=20
add a device specific init for eGalax touchscreens and send the command=20
([2]) to the device.  (AFAIK eeti does the same in their tkusb module=20
for every eGalax touchscreen).

[1]  <http://home.eeti.com.tw/web20/eGalaxTouchDriver/linuxDriver.htm>
[2]  code from eeti-driver tkusb.c:
=2D--
                #ifndef _REMOVE_CHANGE_FORMAT^M
                        scr->output[0] =3D 0x0A;^M
                        scr->output[1] =3D 1;^M
                        scr->output[2] =3D 'A';^M
                        if( !DoSendData( scr, 3 ) )^M
=2D--

--nextPart2867285.TdLFfj6VYb
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrOSVkACgkQTGjGxfSQVIoeFACcDHgIVIMIP0eS+6xdk4SLv6tG
ehAAnRKnBaczvH6W/qKtyy8YO1OAYo4C
=EJ3S
-----END PGP SIGNATURE-----

--nextPart2867285.TdLFfj6VYb--
