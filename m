Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZCJFi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZCJFi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZCJFiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:38:20 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:53750 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbZCJFiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:38:20 -0400
Date: Tue, 10 Mar 2009 06:38:12 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: Eric Anholt <eric@anholt.net>
Cc: Nico Schottelius <nico-linux-20090213@schottelius.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090310053812.GA4717@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	Eric Anholt <eric@anholt.net>, LKML <linux-kernel@vger.kernel.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org> <20090213094048.GC10175@denkbrett.schottelius.org> <1236652091.10190.23.camel@gaiman>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBBFr7Ir9EOA20Yy"
Content-Disposition: inline
In-Reply-To: <1236652091.10190.23.camel@gaiman>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc7-wl-ikn-32831-g98c5597 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gBBFr7Ir9EOA20Yy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Success! Hooray!

Eric Anholt [Mon, Mar 09, 2009 at 07:28:11PM -0700]:
> > [  129.935021] [drm] Initialized i915 1.6.0 20080730 on minor 0
> > [  129.988541] [drm:i915_initialize] *ERROR* can not ioremap virtual ad=
dress for ring buffer
>=20
> This is bad -- without the ringbuffer, initialization fails, so the DRM
> support for opregion shouldn't work.
>=20
> There have been fixes in later kernels for ioremap issues, which may or
> may not affect what you're seeing.  Also, are you using KMS or not?


I just gave the lates iwlwifi tree a try, now running
2.6.29-rc7-wl-ikn-32831-g98c5597, which has full
brightness again.

I'm quite happy that it works again, but quite unhappy
to have it solved "silently"...



--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--gBBFr7Ir9EOA20Yy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkm1/MQACgkQuL75KpiFGIyHPACggisn+Yb9cFjjiY5egFbjP4EF
WLsAoJvHmr6Pr8AXg8JZ/6eCf2GL1spt
=5nuO
-----END PGP SIGNATURE-----

--gBBFr7Ir9EOA20Yy--
