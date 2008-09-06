Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYIFHUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYIFHUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 03:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYIFHUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 03:20:05 -0400
Received: from mx3.mail.ru ([194.67.23.149]:26711 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbYIFHUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 03:20:03 -0400
X-Greylist: delayed 685 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Sep 2008 03:20:03 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: toshiba_acpi@memebeam.org
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Sat, 6 Sep 2008 11:19:59 +0400
User-Agent: KMail/1.9.10
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809061108.34877.arvidjaar@mail.ru>
In-Reply-To: <200809061108.34877.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2260725.8hmhFBs2Tj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809061120.00224.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2260725.8hmhFBs2Tj
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 06 September 2008, Andrey Borzenkov wrote:
> I have now two different devices that refer to the same hardware:
>=20
> lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 -> ../../devices/vi=
rtual/backlight/acpi_video0/
> lrwxrwxrwx 1 root root 0 2008-09-06 11:04 toshiba -> ../../devices/virtua=
l/backlight/toshiba/
>=20
> Unfortunately, due to ACPI implementation the acpi_video0 one is much
> inferior (as it provides only effectively two levels instead of 8);
> and user level tools are apparently quite confused which one to select.
>=20
> Is there any mechanism that would allow tochiba_acpi to claim brightness
> for internal LCD screen that video would not attempt to grab it too?
>=20
> Of course manually disabling brightness handling in video is always possi=
ble,

Actually it is not. brightness_switch_enabled only disables event handling;
it still resets actual brightness on loading and creates sysfs files to
confuse user space.

> still is nice for this to be handled automatically.
>=20



--nextPart2260725.8hmhFBs2Tj
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjCLyAACgkQR6LMutpd94ymmQCfRPLPsTEKpKj+OCyIYm+xdN2k
F+8An3WbwJrtJcQDW2vcZbiYNsINDk/Z
=19Mk
-----END PGP SIGNATURE-----

--nextPart2260725.8hmhFBs2Tj--
