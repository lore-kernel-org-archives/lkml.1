Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab0BXTaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:30:13 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:44560
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757731Ab0BXTaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:30:11 -0500
Date: Wed, 24 Feb 2010 11:29:59 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: phil@ipom.com, usb-storage@lists.one-eyed-alien.net,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] [resend] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
Message-ID: <20100224192959.GJ20232@one-eyed-alien.net>
Mail-Followup-To: Ondrej Zary <linux@rainbow-software.org>, phil@ipom.com,
	usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201002241141.10103.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Content-Disposition: inline
In-Reply-To: <201002241141.10103.linux@rainbow-software.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 24 Feb 2010 11:30:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 24, 2010 at 11:41:08AM +0100, Ondrej Zary wrote:
> SL11R-IDE 2.6c (at least) reports wrong capacity (one sector more).
> Reading that last sector causes the device not to work anymore (and looks
> like HAL or something does that automatically after plugging in):
> sd 5:0:0:0: [sdc] Device not ready
> sd 5:0:0:0: [sdc] Result: hostbyte=3D0x00 driverbyte=3D0x08
> sd 5:0:0:0: [sdc] Sense Key : 0x2 [current]
> sd 5:0:0:0: [sdc] ASC=3D0x0 ASCQ=3D0x0
> sd 5:0:0:0: [sdc] CDB: cdb[0]=3D0x28: 28 00 04 a8 b5 70 00 00 01 00
>=20
> Add unusual_devs entry to fix the capacity.

Why not just adjust the version range of the entry above where you added a
new one?

If you just expand the upper version of the previous entry, it should cover
both devices.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Oh BAY-bee.
					-- Dust Puppy to Greg
User Friendly, 12/13/1997

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLhX43HL9iwnUZqnkRAlHJAJ9RuAOOshTSwcHWPejzr/RfabzPngCcD4VC
vqhCIR5x1D9F1FW6IUQasGY=
=Z9Yn
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
