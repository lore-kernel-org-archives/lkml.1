Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbYDAOei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbYDAOei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 10:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755533AbYDAOe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 10:34:29 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:37229
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531AbYDAOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 10:34:28 -0400
Date: Tue, 1 Apr 2008 07:34:20 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb-storage, error reading the last 8 sectors, regression in 2.6.25-rc7
Message-ID: <20080401143420.GB20920@one-eyed-alien.net>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oliver@neukum.org>, Sergey Dolgov <solkaa@gmail.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200804010938.53853.oliver@neukum.org> <Pine.LNX.4.44L0.0804011028230.3993-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0804011028230.3993-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 01 Apr 2008 07:34:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2008 at 10:28:52AM -0400, Alan Stern wrote:
> On Tue, 1 Apr 2008, Oliver Neukum wrote:
>=20
> > Am Dienstag, 1. April 2008 03:58:31 schrieb Alan Stern:
> > > Nevertheless, it's clear that the problem has nothing to do with the=
=20
> > > USB stack. =A0The real source of the problem lies in the device itsel=
f,=20
> > > for reporting a bogus error when in fact nothing went wrong. =A0That =
may=20
> > > also explain why you don't always see the problem -- sometimes the=20
> > > device works the way it ought to.
> >=20
> > Reminds me of the devices that can read the last sector but only if it =
is read
> > by itself. Do you reckon this device may have the "opposite" quirk?
>=20
> Could be something like that.

Didn't I see some SCSI patches go by to implement exactly this change?
That is, only read the last sector by itself?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

We can customize our colonels.
					-- Tux
User Friendly, 12/1/1998

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH8kfsHL9iwnUZqnkRAlB7AKCKKTtHTm8Wc/yY5IgrlRCNEba0DACfTdAn
ibTbM78OGZbllr+nyk/XoGE=
=1Rec
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
