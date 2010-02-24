Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab0BXWrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:47:46 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:43133
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758046Ab0BXWrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:47:45 -0500
Date: Wed, 24 Feb 2010 14:47:39 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [usb-storage] [PATCH] [resend] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
Message-ID: <20100224224739.GK20232@one-eyed-alien.net>
Mail-Followup-To: Ondrej Zary <linux@rainbow-software.org>,
	usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <201002241141.10103.linux@rainbow-software.org> <20100224192959.GJ20232@one-eyed-alien.net> <201002242222.21008.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <201002242222.21008.linux@rainbow-software.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 24 Feb 2010 14:47:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Phil D. --

I recommend circling around with pwaechtler@loewe-komp.de to see if we
can't condense these into a single entry.

Matt

On Wed, Feb 24, 2010 at 10:22:18PM +0100, Ondrej Zary wrote:
> On Wednesday 24 February 2010 20:29:59 Matthew Dharm wrote:
> > On Wed, Feb 24, 2010 at 11:41:08AM +0100, Ondrej Zary wrote:
> > > SL11R-IDE 2.6c (at least) reports wrong capacity (one sector more).
> > > Reading that last sector causes the device not to work anymore (and l=
ooks
> > > like HAL or something does that automatically after plugging in):
> > > sd 5:0:0:0: [sdc] Device not ready
> > > sd 5:0:0:0: [sdc] Result: hostbyte=3D0x00 driverbyte=3D0x08
> > > sd 5:0:0:0: [sdc] Sense Key : 0x2 [current]
> > > sd 5:0:0:0: [sdc] ASC=3D0x0 ASCQ=3D0x0
> > > sd 5:0:0:0: [sdc] CDB: cdb[0]=3D0x28: 28 00 04 a8 b5 70 00 00 01 00
> > >
> > > Add unusual_devs entry to fix the capacity.
> >
> > Why not just adjust the version range of the entry above where you adde=
d a
> > new one?
>=20
> Because that entry fixes IDENTIFY. My version does not seem to have any=
=20
> problems with IDENTIFY. Or maybe it has but kernel can now handle it=20
> automatically:
> usb 1-1: new full speed USB device using uhci_hcd and address 4
> usb 1-1: configuration #1 chosen from 1 choice
> scsi5 : SCSI emulation for USB Mass Storage devices
> usb-storage: device found at 4
> usb-storage: waiting for device to settle before scanning
> scsi scan: INQUIRY result too short (5), using 36
> scsi 5:0:0:0: Direct-Access     WDC WD40 0BB-00AUA1       18.2 PQ: 0 ANSI=
: 1
> sd 5:0:0:0: Attached scsi generic sg3 type 0
>=20
>=20
> > If you just expand the upper version of the previous entry, it should c=
over
> > both devices.
> >
> > Matt
>=20
>=20
>=20
> --=20
> Ondrej Zary
> _______________________________________________
> Usb-storage mailing list
> Usb-storage@lists.one-eyed-alien.net
> https://lists.one-eyed-alien.net/mailman/listinfo/usb-storage

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLhayLHL9iwnUZqnkRAgQ7AJ4kGZipkk7JihR/+Kf5YHcqlwiTvgCgmFs1
rijroGwUQL6NO7h0Won4Om4=
=C/ti
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
