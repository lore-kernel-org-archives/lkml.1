Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbZLOR6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbZLOR6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:58:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759935AbZLOR6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:58:35 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:48789
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757496AbZLOR6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:58:34 -0500
Date: Tue, 15 Dec 2009 09:58:15 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Josua Dietze <digidietze@draisberghof.de>
Cc: Stefan Seyfried <stefan.seyfried@googlemail.com>,
       usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [usb-storage] [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091215175815.GE16426@one-eyed-alien.net>
Mail-Followup-To: Josua Dietze <digidietze@draisberghof.de>,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	usb-storage@lists.one-eyed-alien.net, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <4B278191.1010009@draisberghof.de> <20091215150137.46bd9817@strolchi.home.s3e.de> <4B27A443.6040908@draisberghof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
Content-Disposition: inline
In-Reply-To: <4B27A443.6040908@draisberghof.de>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 15 Dec 2009 09:58:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 15, 2009 at 03:59:15PM +0100, Josua Dietze wrote:
> The more basic arguments that prevailed at the last time such an=20
> "eject" command was being considered for inclusion into usb-storage=20
> were:
>=20
> 1. Userspace can obviously react a lot quicker than kernel space to=20
> new or changed devices popping up.
>=20
> 2. Userspace works with older kernels immediately.
>=20
> > That's a fundamental difference in opinions, and I fear I'm not the one
> > who is going to decice how this will be handled ;)

I hate to say this, but I really consider this discussion to be closed.
Nobody has introduced a new argument in quite some time.  This material,
where possible, belongs in userspace.

The primary reason userspace may *not* be apropriate is if the device needs
a non-standard eject command.  Some devices need something very *close* to
an eject, but not quite an eject.  Or, they have some goofy timing
restriction which makes the startup time for udev too long, or somesuch.

> Neither am I. But the number of known mode-switching USB devices is=20
> now at around 50. New ones are arriving by the month or even week.
>=20
> A decision to handle *all of them* in usb-storage would lead to the=20
> disadvantages pointed out.

The rate at which these devices are arriving makes this more than a
"disadvantage", it makes it practically impossible for management at the
kernel level.

> A decision to handle just *some of them* can hardly be made=20
> plausible if there are no immediate technical reasons.

The current decision is that all new devices, whenever possible, are to be
handled in userspace.  Old devices currently handled by the kernel will be
removed on an "as we get around to it" schedule.

> Oh, and in most cases (including your suggestion) there *are*=20
> already two drivers necessary to make these devices work,=20
> independent of where the switching is happening ...

This is true.  However, drivers such as usb-serial support dynamic addition
of IDs, so no kernel change is necessary.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You were using cheat codes too.  You guys suck.
					-- Greg to General Studebaker
User Friendly, 12/16/1997

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLJ843HL9iwnUZqnkRArhdAJ9QjQJRG/rVvQmRuy4y+OQpWmgGGQCfY5HX
end06fbM/ULaPqfqFrirNl8=
=maNk
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
