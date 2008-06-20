Return-Path: <linux-kernel-owner+w=401wt.eu-S1757750AbYFTOPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbYFTOPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 10:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYFTOPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 10:15:20 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:36341
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326AbYFTOPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:15:18 -0400
Date: Fri, 20 Jun 2008 07:14:45 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: David Brownell <david-b@pacbell.net>,
       Alan Stern <stern@rowland.harvard.edu>, Matthew Wilcox <matthew@wil.cx>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel@vger.kernel.org, dsd@gentoo.org, linux-usb@vger.kernel.org,
       vegardno@ifi.uio.no, James.Bottomley@hansenpartnership.com,
       linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080620141445.GA16839@one-eyed-alien.net>
Mail-Followup-To: Gabor Gombas <gombasg@sztaki.hu>,
	David Brownell <david-b@pacbell.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Matthew Wilcox <matthew@wil.cx>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	linux-kernel@vger.kernel.org, dsd@gentoo.org,
	linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
	James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.0806191735570.2229-100000@iolanthe.rowland.org> <200806191613.25552.david-b@pacbell.net> <20080620095311.GK15159@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
In-Reply-To: <20080620095311.GK15159@boogie.lpds.sztaki.hu>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Fri, 20 Jun 2008 07:14:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 20, 2008 at 11:53:11AM +0200, Gabor Gombas wrote:
> On Thu, Jun 19, 2008 at 04:13:25PM -0700, David Brownell wrote:
>=20
> > Why give up, ever?=20
>=20
> It would be quite useful to time out and reboot using the previous
> kernel ("lilo -R") when one wants to figure out remotely why the new
> kernel does not boot.

And thus we arrive at only one conclusion:  You should do this with an
initrd so that any policy that is desired can be implemented.  No matter
what the kernel does by default, it will be incorrect for some scenarios.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIW7tVHL9iwnUZqnkRAsRGAJ9RnexoqKsfNBqW/WbGKwk5fm/TCwCdGlAV
bbvn4PaFBrXngbqa9zAiO5A=
=1bl4
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
