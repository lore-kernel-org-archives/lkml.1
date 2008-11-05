Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYKETPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYKETPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbYKETPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:15:23 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:39186 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbYKETPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:15:22 -0500
Date: Wed, 5 Nov 2008 18:31:32 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3(-next20081103) suspend issues on Lenovo X200
Message-ID: <20081105173132.GA4289@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20081103153945.GA20618@denkbrett.schottelius.org> <200811040155.59933.rjw@sisk.pl> <200811031704.25717.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <200811031704.25717.jbarnes@virtuousgeek.org>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc3-next-20081105-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Jesse Barnes [Mon, Nov 03, 2008 at 05:04:25PM -0800]:
> On Monday, November 3, 2008 4:55 pm Rafael J. Wysocki wrote:
> >
> > Jesse, any ideas?  Can that be related to the DRM problem with radeon?
>=20
> On many machines, we've found that re-POSTing the video device is incompa=
tible=20
> with the i915 driver's suspend/resume functionality.  So things like s3_b=
ios=20
> and vbetool shouldn't be used if the i915 driver works by itself.

I removed the s3_bios option; not the console keeps on being black,
but the system wakes up (tested with next-20081105).

When running xorg the system freezes on wakeup and hard reboots after
20 seconds (again: looks like some kind of watchdog, though I am not
aware of anything like that in the X200).

Sincerly,

Nico (again: looks like some kind of watchdog, though I am not
aware of anything like that in the X200).

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--wRRV7LY7NUeQGEoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkR2HQACgkQuL75KpiFGIwNLgCgmmgFnVHP0eLnfWABIYW03nth
bqMAoJLb0Yc52PduXBM7zOV3vXsZZ7VU
=/T5b
-----END PGP SIGNATURE-----

--wRRV7LY7NUeQGEoC--
