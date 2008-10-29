Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbYJ2QWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbYJ2QWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 12:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYJ2QWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 12:22:22 -0400
Received: from mx38.mail.ru ([194.67.23.16]:63050 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYJ2QWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 12:22:20 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Wed, 29 Oct 2008 19:22:00 +0300
User-Agent: KMail/1.9.10
Cc: Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       andi@firstfloor.org, preining@logic.at
References: <200809061108.34877.arvidjaar@mail.ru> <200810281922.20490.arvidjaar@mail.ru> <200810291654.56710.trenn@suse.de>
In-Reply-To: <200810291654.56710.trenn@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2674804.0H5T0XTODU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810291922.03656.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2674804.0H5T0XTODU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29 October 2008, Thomas Renninger wrote:
> On Tuesday 28 October 2008 17:22:12 Andrey Borzenkov wrote:
> > On Tuesday 28 October 2008, Rafael J. Wysocki wrote:
> > > On Tuesday, 28 of October 2008, Thomas Renninger wrote:
> > > > On Monday 27 October 2008 17:52:55 Andrey Borzenkov wrote:
> > > > > On Monday 08 September 2008, Thomas Renninger wrote:
> > > > > > On Saturday 06 September 2008 09:19:59 am Andrey Borzenkov wrot=
e:
> > > > > > > On Saturday 06 September 2008, Andrey Borzenkov wrote:
> > > > > > > > I have now two different devices that refer to the same
> > > > > > > > hardware:
> > > > > > > >
> > > > > > > > lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 ->
> > > > > > > > ../../devices/virtual/backlight/acpi_video0/ lrwxrwxrwx 1 r=
oot
> > > > > > > > root 0 2008-09-06 11:04 toshiba ->
> > > > > > > > ../../devices/virtual/backlight/toshiba/
> > > > > > > >
> > > > > > > > Unfortunately, due to ACPI implementation the acpi_video0 o=
ne
> > > > > > > > is much inferior (as it provides only effectively two levels
> > > > > > > > instead of 8); and user level tools are apparently quite
> > > > > > > > confused which one to select.
> > > > > > > >
> > > > > > > > Is there any mechanism that would allow tochiba_acpi to cla=
im
> > > > > > > > brightness for internal LCD screen that video would not att=
empt
> > > > > > > > to grab it too?
> > > > > > > >
> > > > > > > > Of course manually disabling brightness handling in video is
> > > > > > > > always possible,
> > > > > > >
> > > > > > > Actually it is not. brightness_switch_enabled only disables e=
vent
> > > > > > > handling; it still resets actual brightness on loading and
> > > > > > > creates sysfs files to confuse user space.
> > > > > > >
> > > > > > > > still is nice for this to be handled automatically.
> > > > > >
> > > > > > It is in latest ACPI test branch queued for 2.6.28.
> > > > >
> > > > > It is still not in rc2; is it scheduled for 2.6.28 or delayed
> > > > > further?
> > > >
> > > > Right, it's not there.
> > > > Len, what happened with the:
> > > > "Check for ACPI backlight support otherwise use vendor ACPIdrivers -
> > > > version 4" patches?
> > > >
> > > > They are pretty essential for video.ko.
> > > > Otherwise graphics devices may get double poked (through vendor_acp=
i.ko
> > > > drivers) or may register for graphics cards which are not there.
> > >
> > > Do you have a pointer to those patches?
> >
> > So far I am running with these commits from
> > git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-acpi-2.6:
> This tree does not exist anymore...
>=20
> Andrey, do you still have a local copy?
> Could you use git format-patch and repost the whole series
> (should be about 11 patches) to Len and CC me.

Do you have at least subjects for the patches? I have only
been using the quoted below, so I am not sure which other to pick.
Here is what git log --author=3DRenninger gives me:

Thu Aug 28 17:26:10 2008 +0200 ACPI video: Debug interface used for error m=
essage cleanup
=46ri Aug 1 17:37:55 2008 +0200 Check for ACPI backlight support otherwise =
use vendor ACPI drivers
=46ri Aug 1 17:37:54 2008 +0200 ACPI: video: Ignore devices that aren't pre=
sent in hardware
Mon Jul 23 14:44:41 2007 +0200 ACPI: autoload modules - Create __mod_acpi_d=
evice_table symbol for all ACPI drivers
Mon Jun 26 23:58:43 2006 -0400 ACPI: Enable ACPI error messages w/o CONFIG_=
ACPI_DEBUG
Tue Nov 8 05:27:00 2005 -0500 [ACPI] Fix Null pointer deref in video/lcd/br=
ightness

If you have open git repository, I could probably just push my
linux-acpi branch to you?

> It would be some work for me to recollect everything.
>=20
> I hope Len is reading that soon and can give a comment why this was
> in Andi's, but did not get into his ACPI git tree...
>=20
> This should directly go into ACPI test branch again.
> It would be great if it could still get cherry-picked into .28.
>=20
> Thanks,
>=20
>      Thomas
>=20
> Norbert: I just saw your brightness complains about your Sony on the acpi=
=20
> list. You should start testing with the patchset we are talking about her=
e.
> video.ko is rather broken without them.
>=20
>      Thomas
>=20
> > commit f43d728731c691772ddc29e50d25c68a859935b5
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Fri Aug 1 17:37:55 2008 +0200
> >
> >     Check for ACPI backlight support otherwise use vendor ACPI drivers
> >
> >
> > commit ad9ed8385ed6ec5be8da7094db911c824258ceec
> > Author: Thomas Renninger <trenn@suse.de>
> > Date:   Fri Aug 1 17:37:54 2008 +0200
> >
> >     ACPI: video: Ignore devices that aren't present in hardware
> >
> > I have been waiting for in-tree inclusion to submit patches for
> > toshiba_acpi against stable base.
>=20
>=20
>=20



--nextPart2674804.0H5T0XTODU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkIjasACgkQR6LMutpd94y66gCgiXPRbxOTfANrMaFDktHjsDQJ
C3oAnjMkv78Gm3j6PyM2b0RtG9JnTILG
=m/Xv
-----END PGP SIGNATURE-----

--nextPart2674804.0H5T0XTODU--
