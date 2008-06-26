Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYFZTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYFZTK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbYFZTKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:10:16 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:35684
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187AbYFZTKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:10:14 -0400
Date: Thu, 26 Jun 2008 12:10:10 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Ben Collins <ben.collins@canonical.com>
Cc: usb-storage <usb-storage@lists.one-eyed-alien.net>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [usb-storage] Ambiguous dupe in libusual device list
Message-ID: <20080626191010.GD31004@one-eyed-alien.net>
Mail-Followup-To: Ben Collins <ben.collins@canonical.com>,
	usb-storage <usb-storage@lists.one-eyed-alien.net>,
	kernel list <linux-kernel@vger.kernel.org>
References: <1214501556.7150.36.camel@cunning>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <1214501556.7150.36.camel@cunning>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 26 Jun 2008 12:10:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2008 at 01:32:36PM -0400, Ben Collins wrote:
> In unusual_devs.h, there are these two entries:
>=20
> #ifdef CONFIG_USB_STORAGE_DATAFAB
> /* Submitted by Olaf Hering <olh@suse.de> */
> UNUSUAL_DEV(  0x07c4, 0xa109, 0x0000, 0xffff,

> #ifdef CONFIG_USB_STORAGE_SDDR55
> /* SM part - aeb <Andries.Brouwer@cwi.nl> */
> UNUSUAL_DEV(  0x07c4, 0xa109, 0x0000, 0xffff,

> If I'm not mistaken (and because libusual is pretty well abstracted, I
> might be) this is an ambiguous dupe that isn't resolved with any
> checking (IOW, the second entry is likely never used), at least when
> both config options are enabled.

Reading the code, it looks like it's a bit more complex than that.

The first entry enables use of a driver (if it's compiled it) which can
drive both slots on a dual-slot device.

The first entry enables use of a driver (if it's compiled it) which can
only drive one slot on a dual-slot device.

This is really the type of thing which shows that we need some sort of
semi-generic "preference" mechanism for driver binding...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

M:  No, Windows doesn't have any nag screens.
C:  Then what are those blue and white screens I get every day?
					-- Mike and Cobb
User Friendly, 1/4/1999

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIY+mSHL9iwnUZqnkRAo19AKCz6FNyQRizSbv9dC4ctBE6QPeA6gCcDCxh
Sd9xNuCVx6gq+FZ001MV2Ow=
=cH16
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
