Return-Path: <linux-kernel-owner+w=401wt.eu-S934109AbXCFNKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109AbXCFNKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934106AbXCFNKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:10:40 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:59781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104AbXCFNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:10:38 -0500
Subject: Re: [1/6] 2.6.21-rc2: known regressions
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Pavel Machek <pavel@ucw.cz>,
       Marcel Holtmann <marcel@holtmann.org>, linux-pm@lists.osdl.org,
       maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       Mark Lord <lkml@rtr.ca>, Matt Mackall <mpm@selenic.com>,
       Albert Hopkins <kernel@marduk.letterboxes.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       netdev@vger.kernel.org
In-Reply-To: <20070305033533.GA28319@kroah.com>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
	 <20070305015031.GF3441@stusta.de>  <20070305033533.GA28319@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i3jBLRY+r3mxA0BLoyxz"
Date: Tue, 06 Mar 2007 01:55:46 +0100
Message-Id: <1173142546.15891.63.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i3jBLRY+r3mxA0BLoyxz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-03-04 at 19:35 -0800, Greg KH wrote:

> > Subject    : wireless breakage (ipw2200, iwconfig, NetworkManager)
> > References : http://lkml.org/lkml/2007/3/4/135
> > Submitter  : Matt Mackall <mpm@selenic.com>
> > Caused-By  : Greg Kroah-Hartman <gregkh@suse.de> (?)
> >              commit 43cb76d91ee85f579a69d42bc8efc08bac560278 (?)
> > Handled-By : Johannes Berg <johannes@sipsolutions.net>
> > Status     : unknown
>=20
> I really think this is a CONFIG_SYSFS_DEPRECATED issue (not being set),
> but want to get Matt confirm either way before saying this is a real
> issue or not.

I just tested on my quad powermac that also runs a stock Debian/unstable
and changing that option makes all the difference. Nevermind that it
defaults to yes and one needs to turn it off explicitly...

johannes

--=-i3jBLRY+r3mxA0BLoyxz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7LwS/ETPhpq3jKURAuGuAJ90d8Ucs+DvKGONqv3pqz5OhbORZACgqE1G
9nOJkgdgY15qW65IIDjPV60=
=8EIz
-----END PGP SIGNATURE-----

--=-i3jBLRY+r3mxA0BLoyxz--

