Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYJTMsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYJTMsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYJTMrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:47:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYJTMrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:47:43 -0400
Subject: Re: iwl3945 broken in current git
From: Johannes Berg <johannes@sipsolutions.net>
To: Dieter Ries <clip2@gmx.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <48FC7C67.3000101@gmx.de> (sfid-20081020_144142_792182_D8FF0F1C)
References: <48FC6C05.6020901@gmx.de>
	 <20081020121710.GA3607@isilmar.linta.de>
	 (sfid-20081020_141718_690091_E56EF8AB) <1224506010.27899.23.camel@johannes.berg>
	 <48FC7B1A.10307@gmx.de>
	 (sfid-20081020_143609_718157_68144039) <1224506366.27899.25.camel@johannes.berg>
	 <48FC7C67.3000101@gmx.de> (sfid-20081020_144142_792182_D8FF0F1C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nMD5bUTSq9XH0g6YRDLc"
Date: Mon, 20 Oct 2008 14:47:38 +0200
Message-Id: <1224506858.27899.27.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nMD5bUTSq9XH0g6YRDLc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 14:41 +0200, Dieter Ries wrote:
> Johannes Berg schrieb:
> > On Mon, 2008-10-20 at 14:35 +0200, Dieter Ries wrote:
> >> Johannes Berg schrieb:
> >>> On Mon, 2008-10-20 at 14:17 +0200, Dominik Brodowski wrote:
> >>>
> >>>>> iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> >>>>> iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
> >>>>> 0x4416 ser 0x0000004B
> >>>>> iwl3945: Can't stop Rx DMA.
> >>>> It needs a more recent uCode -- the driver really should scream out =
loudly
> >>>> that the old firmware no longer suffices.
> >>> You could try reverting ef224ca2ce55e81acc6c3a74c3e8c00a00941c70, tha=
t's
> >>> the only commit I can find that seems to be vaguely related to the
> >>> problem as Tomas described it. Not that it might not be hidden in som=
e
> >>> other commit...
> >> The new firmware did it. It works now, but it should really scream out
> >> loud ...
> >=20
> > Do you still have the old one? Would you try anyway?
>=20
> OK I will. give me a minute ...

Wait. That commit can't be causing it, you're talking about 3945, sorry.

johannes

--=-nMD5bUTSq9XH0g6YRDLc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/H3mAAoJEKVg1VMiehFYl4IP/3BH7JQ+xEyXj8gXhgh3rM8s
ImPObdvw2kDWVjPzoOSsXdEkHp0JUjlZGPoPf0NxhCjQNMcWipXh7E+VwiXT3IHO
bJNZQ0881Dfkcvfptcep6uiQGq/jkf7nyu0xCgZ1ozXb/ybHQRACDo8LFE8FxqhN
M0GJYNtlbvnmnrF4eZgyBI5/nWRMzhB8tCA0dIRUZGISPdkzizcD5LxcrxDnOs8f
iW1DGUAuYjF35bG+avvAUXU565CZeIni1fcw5NmvVIbh0b2gwzygCUwF3sn8HBfk
qGL2v3Irgu4mR763MkE8dFlShu4qc5BwE8EaO4wkhorQDhvSBdhWBkui8pfQ/O4d
2WpJpTC9800qWUV+ssJA+6ZnAvnw5YWXLoDh+cDpk/xv4zP10aUwg667xiLXCI1U
N8l0oYRHql2o9s9OFPFIRksWik4wdEXZsm45hdlsjNqZy0UhWXgKWNvQDJK8P9/M
pv8nf1Me6yQMUgJmhby6cMZkPZAgwNrTg3EfehGVruWk1mQL08oi+lIsGnhoysi0
Uku3h5t/KFGGyP8s62N7IJWSppAhH0OAvjBAt7zKA3LeCndRaH00LgaYAqjEYcBF
tOpb1Sj7rCE/f9OskPSf+vc+dupWB9HUOgdBiFZx38xXGxyaD1FVXSaBbFzGQlWq
gXh+VcEMiSAHmHIYu3un
=HkaS
-----END PGP SIGNATURE-----

--=-nMD5bUTSq9XH0g6YRDLc--

