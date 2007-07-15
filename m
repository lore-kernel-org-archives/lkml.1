Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXGOWXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXGOWXP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXGOWXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:23:00 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:54313 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbXGOWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:22:59 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Date: Sun, 15 Jul 2007 19:08:04 +1000
User-Agent: KMail/1.9.6
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1184483593.1898.98.camel@caritas-dev.intel.com>
In-Reply-To: <1184483593.1898.98.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2387600.KdldWAbgaJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707151908.05388.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2387600.KdldWAbgaJ
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Sunday 15 July 2007 17:13:13 Huang, Ying wrote:
> The complete changelog of the patch is as follow:
>=20
> ---
>=20
> Kexec base hibernation has some potential advantages over uswsusp and
> TuxOnIce (suspend2). Some most obvious advantages are:
>=20
> 1. The hibernation image size can exceed half of memory size easily.
> 2. The hibernation image can be written to and read from almost
>    anywhere, such as USB disk, NFS.

This isn't right. TuxOnIce has no problem with image sizes exceeding half t=
he=20
amount of memory, and both uswsusp and TuxOnIce could write to a USB disk/k=
ey=20
or NFS as well. Historically, the issue with writing to USB devices has bee=
n=20
an issue with USB device drivers, not hibernation implementations. I haven'=
t=20
tried writing an image to USB, but with the work on the drivers, I wouldn't=
=20
be surprised if it was usable now. NFS? Again, I haven't tried, but wouldn'=
t=20
expect it to be impossible. I did try writing an image to an NBD device a=20
couple of years ago. It didn't quite work, but wasn't far away.
=20
Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2387600.KdldWAbgaJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGmeP1N0y+n1M3mo0RAoHhAJ9YREzwIWYaoPvbA4ET8xBpobd93gCgg9TC
j7gTdHPM36nEygefLK6wyC0=
=q9qY
-----END PGP SIGNATURE-----

--nextPart2387600.KdldWAbgaJ--
