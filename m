Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbXE3NRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbXE3NRz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXE3NRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:17:49 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:47067 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbXE3NRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:17:48 -0400
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20070530124027.GA27942@srcf.ucam.org>
References: <alpine.LFD.0.98.0705241905490.26602@woody.linux-foundation.org>
	 <1180059605.3997.100.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705241931240.26602@woody.linux-foundation.org>
	 <1180062040.3997.112.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705242021560.26602@woody.linux-foundation.org>
	 <1180067587.3997.136.camel@nigel.suspend2.net> <465C366C.2070900@rtr.ca>
	 <1180473765.20718.47.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0705291428410.26602@woody.linux-foundation.org>
	 <20070530114920.GB26326@elf.ucw.cz>  <20070530124027.GA27942@srcf.ucam.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P36f7fgwUTwmiDZOZ+Vl"
Date: Wed, 30 May 2007 23:17:47 +1000
Message-Id: <1180531067.24891.1.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-P36f7fgwUTwmiDZOZ+Vl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-05-30 at 13:40 +0100, Matthew Garrett wrote:
> On Wed, May 30, 2007 at 01:49:21PM +0200, Pavel Machek wrote:
>=20
> (Trimmed the Cc:s quite heavily - I think this has gone somewhere beyond=20
> the original point)
>=20
> > Notice that we want to be able to suspend while hibernating -- for
> > suspend to both behaviour. So drivers may _not_ rely on system being
> > runnable.
>=20
> So keep the driver layers read-only and unfreeze the processes after=20
> doing the atomic copy.

I know you probably won't care, but that's not an option for Suspend2 -
I get the possibility of a full image by overwriting LRU pages that were
saved prior to the atomic copy.

That aside, keeping the driver layers read-only sounds more complicated
than just freezing processes.

Regards,

Nigel

--=-P36f7fgwUTwmiDZOZ+Vl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGXXl7N0y+n1M3mo0RAk2CAKDHecnu0mNu8PxgPhYvRkQpMFxRnACgo34y
x7zPkvhq/A7Zi9Fkq2jGZ08=
=Cgc3
-----END PGP SIGNATURE-----

--=-P36f7fgwUTwmiDZOZ+Vl--

