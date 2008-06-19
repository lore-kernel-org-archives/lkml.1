Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbYFSUjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbYFSUjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbYFSUjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:39:42 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:48788
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031AbYFSUjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:39:41 -0400
X-Greylist: delayed 2795 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 16:39:41 EDT
Date: Thu, 19 Jun 2008 12:52:40 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080619195240.GX19934@one-eyed-alien.net>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, dsd@gentoo.org,
	linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
	James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
	Greg KH <greg@kroah.com>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org> <20080619182310.GA30833@parisc-linux.org> <485AA7EA.6080105@s5r6.in-berlin.de> <20080619185419.GN4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OrT4iOlIQZp3kw4S"
Content-Disposition: inline
In-Reply-To: <20080619185419.GN4392@parisc-linux.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 19 Jun 2008 12:52:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OrT4iOlIQZp3kw4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2008 at 12:54:19PM -0600, Matthew Wilcox wrote:
> On Thu, Jun 19, 2008 at 08:39:38PM +0200, Stefan Richter wrote:
> > The problem is AFAIU not exactly how many Scsi_Host instances (initiato=
r=20
> > port representations, or something remotely related to that) are=20
> > instantiated, but rather _when_ they are instantiated.  On multi=20
> > protocol buses or networks like USB and FireWire, it makes sense to=20
> > create the SCSI initiator port representation when we discovered that=
=20
> > there are actually SCSI targets on the bus or network.
>=20
> I'm not convinced of that.  Why shouldn't we create one scsi host for
> all USB scsi devices?  I know that today there's a certain amount of
> per-device state stored in the scsi_host, but that should be fixable.

First, there are usb-storage devices which are USB<->SCSI bridges and
therefore support multiple target devices.

Second, you would still need multiple hosts when you have more than 15
target USB devices, anyway.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

E:  You run this ship with Windows?!  YOU IDIOT!
L:  Give me a break, it came bundled with the computer!
					-- ESR and Lan Solaris
User Friendly, 12/8/1998

--OrT4iOlIQZp3kw4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIWrkIHL9iwnUZqnkRAlwyAJ9dfiPShOEkdDLe+BCTiDgGQR/5KgCfeNAW
dA/8Sw84JaKVMDwaSrTVMHI=
=ySY4
-----END PGP SIGNATURE-----

--OrT4iOlIQZp3kw4S--
