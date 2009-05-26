Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZEZRex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZEZRex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZEZReo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:34:44 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:37697
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054AbZEZReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:34:44 -0400
Date: Tue, 26 May 2009 10:34:32 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@users.sf.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: Question on the removable flag of USB devices
Message-ID: <20090526173432.GU28077@one-eyed-alien.net>
Mail-Followup-To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
	=?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@users.sf.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <20090525164553.GA5572@ime.usp.br> <20090525184831.GT28077@one-eyed-alien.net> <4A1C1A79.2020500@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FWibJpkbnkY6rrXF"
Content-Disposition: inline
In-Reply-To: <4A1C1A79.2020500@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 26 May 2009 10:34:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FWibJpkbnkY6rrXF
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2009 at 06:36:09PM +0200, Stefan Richter wrote:
> Matthew Dharm wrote:
> > On Mon, May 25, 2009 at 01:45:54PM -0300, Rog=E9rio Brito wrote:
> >> The question is: how are devices determined to be removable or not?
> >> Sorry if this question is too naive.
> >=20
> > It's a bit that the device reports.  The usb-storage driver passes this=
 bit
> > to the SCSI layer.
>=20
> Wasn't this bit actually about removable _media_ rather than
> hotpluggable transports?  (I.e. hardware where you can pull the medium
> out of the drive mechanism.)  So in this sense, an USB attached HDD
> should actually not present itself as "removable" unless it's a SyQuest
> or Zip or something like that.

In fact, yes, that's the meaning of that bit.  The device indicates if the
storage media may be removed from the device.

That said, a great many devices simply lie about this.  Probably developers
doing a cut-and-paste from templates which have the bit set one way or the
other.  The "popular" OSes don't seem to really care much about this bit...

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

C:  Like the Furby?
DP: He gives me the creeps.  Think the SPCA will take him?
					-- Cobb and Dust Puppy
User Friendly, 1/2/1999

--FWibJpkbnkY6rrXF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFKHCgoHL9iwnUZqnkRAoHWAJ9RtZTPfNrJejbpxakt/T4rYt5x4wCglANz
DoBtlDZK1wR/sIuS6AjnhiE=
=Tzs1
-----END PGP SIGNATURE-----

--FWibJpkbnkY6rrXF--
