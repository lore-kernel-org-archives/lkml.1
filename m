Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbYICS2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbYICS2z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYICS2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:28:47 -0400
Received: from quackingmoose.com ([63.73.180.143]:35918 "EHLO
	penguin.merfinllc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752353AbYICS2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:28:46 -0400
Date: Wed, 3 Sep 2008 11:28:45 -0700
From: Aaron Straus <aaron@merfinllc.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: drivers/char/random.c line 728 BUG
Message-ID: <20080903182845.GM17899@merfinllc.com>
References: <20080826225918.GC5452@merfinllc.com> <20080828225924.GD6432@merfinllc.com> <20080829124807.54293904.akpm@linux-foundation.org> <1220465901.17608.55.camel@calx>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="I4g3zIzscEHdx6fd"
Content-Disposition: inline
In-Reply-To: <1220465901.17608.55.camel@calx>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--I4g3zIzscEHdx6fd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matt,

On Sep 03 01:18 PM, Matt Mackall wrote:
> This fix is bogus - it assumes that r->entropy_count has atomic
> assignment which is not universally true (witness the existence of
> atomic_t). So we can still observe partial updates to entropy_count on
> some architectures. Now it's probably the case that we'll never see a
> partial update that actually triggers the BUG_ON, but it's still
> conceptually wrong to do things this way.

I think Andrew was just being safe by reverting to the old behavior.

Could we still apply his patch for the upcoming stable tree and fix it
the "right" way at some point in the future?

				Thanks,
				=3Da=3D

--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Aaron Straus
aaron@merfinllc.com

--I4g3zIzscEHdx6fd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFIvtddr/o4YuvB+jgRAkuCAJwIAncCsiYtMIDerwkzbxVcdtAV+QCgkRH6
dUPvsgPOv8hBsAncO8xf9iU=
=NhMo
-----END PGP SIGNATURE-----

--I4g3zIzscEHdx6fd--
