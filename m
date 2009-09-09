Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZIIArb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZIIArb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 20:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbZIIArb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 20:47:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47082 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbZIIAra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 20:47:30 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Richard Kettlewell <rjk@terraraq.org.uk>
In-Reply-To: <4AA6F777.2080103@zytor.com>
References: <1252452228.3423.121.camel@localhost>
	 <4AA6F777.2080103@zytor.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Bsr7mifJjAgq00RBzweD"
Date: Wed, 09 Sep 2009 01:46:35 +0100
Message-Id: <1252457195.3423.124.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
X-SA-Exim-Connect-IP: 192.168.2.105
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] x86: Fix code patching for paravirt-alternatives on 486
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bsr7mifJjAgq00RBzweD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-08 at 17:31 -0700, H. Peter Anvin wrote:
[...]
> I'm wondering if it wouldn't be cleaner to fold the jump into
> sync_core() and moving the sync_core() up before local_irq_restore().

Exactly as I suggested below the dashes. :-)

The only reason I didn't do that initially was that I don't know whether
or not there's a good reason for the current placement of sync_core()
after local_irq_restore().

Ben.

--=20
Ben Hutchings
Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp

--=-Bsr7mifJjAgq00RBzweD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUASqb64Oe/yOyVhhEJAQJiXBAAmNy9TK3LzciGN49OM/aaoYLr9iPilIrA
mQUfaXFHZdplL5OmXMUWsuNYOKkShx+zD5Zz4b5YcbTOhQDbRsVZD54MMoCdpzRX
XixErUlCi/bhcKqsJrY+7gaVLQd63vvOO2MZMA359GD7CTLkygMbveTppAMf27Om
+hrgRHv1y77jmPlGkkYTwCrvZ7C0lhZi3KfxhRT6Yhw7BCu7xlLnVAVVNQqjx1ZB
lKO8LSgL7Xr4QYxFw7+JTs1nLSj1LLdDCf9nXElAl/tDZsXRDdPWAJq2mafMggNh
5jibQ291NBloUAh2w2zpuYzwXCYcsGBbsXfZFsBjj/sHf4vSjEY/jAZFWrTdZiln
1r1sQ0XBZ0L4qsbmv+pLS88tet42bcODSOgxlub6wjcWlRNzm3Cd0F3ZN5aI54/v
SR+XdoXulKDjKOjyMBUCYKRxizmRQgfxPnw9FnMduwcfEZ69gslTRlKRqIdk+TNd
7Szn8omWZUbINDsAfttkk3qMhE6hCVR2q0yN3KhT/ILYtW6I/KCcK3u4rAFgFwLK
OVrya9bTC9xLbrVP4OQFalAd23iRAfTYULV1dYOilKzBudI7IK1pPjGP8sme3JMi
fAuPefIJcqVWKQpyCzIuwt6SEsBtwT5oAPQFm80OO1583HHs79Lz9EA/oVfIdSHk
95fpiD3KZUo=
=TK1T
-----END PGP SIGNATURE-----

--=-Bsr7mifJjAgq00RBzweD--
