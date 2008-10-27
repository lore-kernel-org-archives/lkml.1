Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYJ0Qxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYJ0Qxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889AbYJ0QxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:53:20 -0400
Received: from mx38.mail.ru ([194.67.23.16]:55664 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYJ0QxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:53:18 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Mon, 27 Oct 2008 19:52:55 +0300
User-Agent: KMail/1.9.10
Cc: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200809061108.34877.arvidjaar@mail.ru> <200809061120.00224.arvidjaar@mail.ru> <200809080301.24907.trenn@suse.de>
In-Reply-To: <200809080301.24907.trenn@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4827531.uYl8vR864B";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810271953.04764.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4827531.uYl8vR864B
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 08 September 2008, Thomas Renninger wrote:
> On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrote:
> > On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > > I have now two different devices that refer to the same hardware:
> > >
> > > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 root root 0
> > > 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/toshiba/
> > >
> > > Unfortunately, due to ACPI implementation the acpi_video0 one is much
> > > inferior (as it provides only effectively two levels instead of 8);
> > > and user level tools are apparently quite confused which one to select.
> > >
> > > Is there any mechanism that would allow tochiba_acpi to claim brightness
> > > for internal LCD screen that video would not attempt to grab it too?
> > >
> > > Of course manually disabling brightness handling in video is always
> > > possible,
> >
> > Actually it is not. brightness_switch_enabled only disables event handling;
> > it still resets actual brightness on loading and creates sysfs files to
> > confuse user space.
> >
> > > still is nice for this to be handled automatically.
> It is in latest ACPI test branch queued for 2.6.28.

It is still not in rc2; is it scheduled for 2.6.28 or delayed further?

--nextPart4827531.uYl8vR864B
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkF8ekACgkQR6LMutpd94xkZACgiRnEvriBfI/t9C4vLdC9jCuP
aJYAoKCl+p9Inu/Y+8zCiNV7JZKwuk0Z
=XR/4
-----END PGP SIGNATURE-----

--nextPart4827531.uYl8vR864B--
