Return-Path: <linux-kernel-owner+w=401wt.eu-S933105AbZLOSDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105AbZLOSDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933169AbZLOSDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:03:48 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:49700
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbZLOSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:03:16 -0500
Date: Tue, 15 Dec 2009 10:03:00 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091215180300.GF16426@one-eyed-alien.net>
Mail-Followup-To: Oliver Neukum <oliver@neukum.org>,
	Josua Dietze <digidietze@draisberghof.de>,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de> <200912151611.08576.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0H629O+sVkh21xTi"
Content-Disposition: inline
In-Reply-To: <200912151611.08576.oliver@neukum.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 15 Dec 2009 10:03:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0H629O+sVkh21xTi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2009 at 04:11:08PM +0100, Oliver Neukum wrote:
> Am Dienstag, 15. Dezember 2009 13:31:13 schrieb Josua Dietze:
> > Stefan Seyfried schrieb:
> >=20
> > > The USB ID claimed by zd1211rw for the fake storage device is
> > > also in use by other, non-zd1211rw devices (Sphairon Homelink
> > > 1202). Move the eject of these devices to where it belongs and
> > > where all the needed infrastructure already exists: usb-storage.
> >=20
> >=20
> > We can do the eject (as other mode switches) in userspace. Previous=20
> > discussions pointed into that direction.
> >=20
> > And there is always the question of being able to access the "fake=20
> > CD-ROM" without hacking the kernel.
> >=20
> > I'd like to see these devices removed from unusual_devs.h.
>=20
> This would break existing systems and thus introduce a regression.
> We'd need to go through a feature removal process. For the time being
> I see no alternative to Seife's patch, as we cannot introduce ejection
> code to another wireless driver and need to support these devices.

The right answer here is neither to move the eject code nor to introduce
more of it.  New devices should be supported via userspace.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--0H629O+sVkh21xTi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLJ89UHL9iwnUZqnkRAq2bAJ4iWbg2zp+JMXfran8P1HyHPCOKoACfZpFi
OCcWRKIkW33enNpjN3qh7b0=
=UIM0
-----END PGP SIGNATURE-----

--0H629O+sVkh21xTi--
