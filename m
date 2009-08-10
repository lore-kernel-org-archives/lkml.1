Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZHJMjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZHJMjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZHJMjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:39:18 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:41938 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbZHJMjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:39:18 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: Scott James Remnant <scott@ubuntu.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>
In-Reply-To: <200908101505.36414.a1426z@gawab.com>
References: <20090805171513.GA10443@kroah.com>
	 <200908062318.05478.a1426z@gawab.com> <1249894896.4431.6.camel@quest>
	 <200908101505.36414.a1426z@gawab.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f9u6TiwRz+VG4BFDCv2G"
Date: Mon, 10 Aug 2009 13:39:12 +0100
Message-Id: <1249907952.4431.11.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f9u6TiwRz+VG4BFDCv2G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-10 at 15:05 +0300, Al Boldi wrote:

> Scott James Remnant wrote:
> > On Thu, 2009-08-06 at 23:18 +0300, Al Boldi wrote:
> > > Maybe they are using the same trick as Ubuntu and Debian, as they run
> > > udev in the background to hide the slowness.  Both Fedora and Mandriv=
a
> > > run udev in the foreground where the slowness is visible.
> >
> > Ubuntu does not run udev in the background.
>=20
> I put a date timestamp at the beginning and end of the start command of=20
> init.d/udev, and when you stop and then start init.d/udev it shows a ~5s=20
> delay.  At boot I don't see this delay, but instead see the initial date=20
> stamp, then a flurry of parallel activity, then the final date stamp, whi=
ch=20
> shows the ~5s delay.
>=20
That flurry of activity is the things that udev does during boot that
takes the 5s.

Right now we have to block until all udev activity is complete, to
ensure that /dev is populated.  This patch is one solution to that
problem.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-f9u6TiwRz+VG4BFDCv2G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqAFPAACgkQSnQiFMl4yK6zigCff1zaolRjWSqOy3xtCbUlLYQ7
hnQAn3usypcF6FFgz4fNfDaO7AQeDZwl
=/wot
-----END PGP SIGNATURE-----

--=-f9u6TiwRz+VG4BFDCv2G--

