Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYDUI0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYDUI0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbYDUI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:26:34 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:47536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbYDUI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:26:33 -0400
Subject: Re: [RFC 0/3] Examples for the new sparse context tracking
	functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@freedesktop.org>,
       linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <20080419233338.GG20138@linux.vnet.ibm.com>
References: <20080410134810.629048000@sipsolutions.net>
	 <20080419233338.GG20138@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zXfPgHTr0bx60QQxTjW1"
Date: Mon, 21 Apr 2008 10:25:55 +0200
Message-Id: <1208766355.26186.37.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zXfPgHTr0bx60QQxTjW1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> At some point in the future, we might want to distinguish between
> the different flavors of RCU -- except that there is already common
> code that doesn't care which flavor of RCU is in use, as long as
> some sort of RCU is present.  So make that "some point in the distant
> future"...

No big deal, just declare

my_specific_rcu_get() __acquires(RCU) __acquires(specificRCU);

and then annotate whatever needs the specific RCU type with
__requires(specificRCU)

johannes

--=-zXfPgHTr0bx60QQxTjW1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxPkaVg1VMiehFYAQLCJg//XzY1TPDQloPBagkmx8DylFB7yBu4Lnlz
gNcU89xyITrDTtV0er7U+/jM56duWUEDv2wjnxBNAvHwUM2CkapRUvOzIJbAYBwR
Ds4FMfyY5KMXs2Iz5jkjnrq7UIzOCkaywmjilZIcYY5mtXqKphj0z3lmhn4PixM7
mQXxhJUgEVQcnk4dBxYOgWE6AbS/Spp8gqK6FtgLFWVpY/pu4AIucXmHWSSMYKY2
NfuqszqaU43o4gQe1t3Zb2MXJyC/3YFL9gokp8zn7rnRvzIk9imxJorLP0gC6FoH
Voy5nimZzEp2LzaIX75RJRpFQRVNLqjrpy6FJKcpWd+di9PpZSjygkzKFxM6U9IZ
hBw6CxnswdUm7ROPcQ1I1EnB+9AnRauaWmamz5k65PAxEihj18fdivSGzZ83kGp1
iOZJQel8G9hvCSvmFJDc3XMf58IAifHWI3fdtKfpZE06C1lEX3M2uqjrj0JyjBCg
HjY+AzflghF/uCD0iaqzNi3VnmSQV/dSuM0QH4aY6cayORMnL/BLP8LSpgE/E7vc
h0vhw60uyq2PYXsBDeIFjAtoK17Zqv7CJ8tnMqbMvWxY2n9rfbSvF7IGymqrQk4M
6HnycEc7zIVPFw/c6/oC532YwbWk7jH3eb5R/D2AQZ1PRDjQhNPZV0KFDWySXGeC
/zqEjyI3h2Y=
=B43P
-----END PGP SIGNATURE-----

--=-zXfPgHTr0bx60QQxTjW1--

