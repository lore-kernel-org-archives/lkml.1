Return-Path: <linux-kernel-owner+w=401wt.eu-S1760257AbXK2JKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257AbXK2JKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbXK2JKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:10:16 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:35154
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451AbXK2JKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:10:14 -0500
Date: Thu, 29 Nov 2007 01:09:26 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Add the infamous Huawei E220 to option.c
Message-ID: <20071129090926.GD24795@one-eyed-alien.net>
Mail-Followup-To: Oliver Neukum <oliver@neukum.org>,
	Pete Zaitcev <zaitcev@redhat.com>,
	Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
	linux-usb@vger.kernel.org, preining@logic.at,
	kristoffer.ericson@gmail.com, drussell@redhat.com,
	linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <200711290844.39428.oliver@neukum.org> <20071129000149.7569eab1.zaitcev@redhat.com> <200711290914.48050.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ylS2wUBXLOxYXZFQ"
Content-Disposition: inline
In-Reply-To: <200711290914.48050.oliver@neukum.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2007 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 29 Nov 2007 01:09:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ylS2wUBXLOxYXZFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 29, 2007 at 09:14:47AM +0100, Oliver Neukum wrote:
> Am Donnerstag, 29. November 2007 09:01:49 schrieb Pete Zaitcev:
> > On Thu, 29 Nov 2007 08:44:38 +0100, Oliver Neukum <oliver@neukum.org> w=
rote:
> > > 3. Make sure usbcore doesn't probe the devices in the wrong mode with=
 the
> > > option driver
> >
> > This fixes duplication. And to take it further, why don't we turn this
> > idea around and let usb-storage fail to attach with some "ignore" quirk?
> > I suspect that someone put the initializer into usb-storage in order
> > to let the generic usb serial to work, but this simply was a bad idea.
>=20
> Yes, you are right. That's the correct approach.

Changing the unusual_devs.h flag to IGNORE_DEVICE should accomplish what
you want.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Like the Furby?
DP: He gives me the creeps.  Think the SPCA will take him?
					-- Cobb and Dust Puppy
User Friendly, 1/2/1999

--ylS2wUBXLOxYXZFQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHToHGHL9iwnUZqnkRAthpAKCDxTlSan6DyZEsWDceeGnM5UZyYwCfZyOd
NyPAht5O7rb+KjsRn1SrB2E=
=Xwo/
-----END PGP SIGNATURE-----

--ylS2wUBXLOxYXZFQ--
