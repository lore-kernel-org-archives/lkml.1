Return-Path: <linux-kernel-owner+w=401wt.eu-S1761039AbXE1Iaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761039AbXE1Iaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXE1Iab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:30:31 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53960 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbXE1Iab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:30:31 -0400
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before
	hibernation/suspend
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
In-Reply-To: <200705272345.04518.rjw@sisk.pl>
References: <200705272229.21263.rjw@sisk.pl>
	 <200705272231.54535.rjw@sisk.pl> <20070527204955.GA22202@srcf.ucam.org>
	 <200705272345.04518.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TeYUmiz5EeRIrG0UU77U"
Date: Mon, 28 May 2007 18:30:26 +1000
Message-Id: <1180341026.14749.12.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TeYUmiz5EeRIrG0UU77U
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-05-27 at 23:45 +0200, Rafael J. Wysocki wrote:
> On Sunday, 27 May 2007 22:49, Matthew Garrett wrote:
> > On Sun, May 27, 2007 at 10:31:53PM +0200, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > >=20
> > > Use a hibernation and suspend notifier to disable the firmware reques=
ting
> > > mechanism before a hibernation/suspend and enable it after the operat=
ion.
> >=20
> > This avoids the problem of .resume methods calling userspace while=20
> > userspace is frozen and a resulting hang, but does it actually result i=
n=20
> > the drivers beginning to work again?
>=20
> Well, this was acutally invented before you've decided to remove the free=
zing
> of tasks from the suspend code path (which I think is a mistake, but that=
's
> only my personal opinion, so it doesn't matter very much ;-)) and I regar=
d it
> as a workaround.

Suspend-to-ram code paths shouldn't assume userspace is unfrozen anyway.
Doesn't [u]swsusp have a code path like Suspend2 where we can suspend to
ram after writing the hibernation image? In that case, it will still be
possible that we seek to enter and leave S3 with processes frozen.

Apologies if anyone has already mentioned this - I'm just starting to
play catchup.

Regards,

Nigel


--=-TeYUmiz5EeRIrG0UU77U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWpMiN0y+n1M3mo0RAsiAAKDgdGSlgBjRl4Yt5qHxrn6DYslkigCfYVXU
F3kwH+POpwElE+WiSataFXI=
=oI4M
-----END PGP SIGNATURE-----

--=-TeYUmiz5EeRIrG0UU77U--

