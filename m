Return-Path: <linux-kernel-owner+w=401wt.eu-S935292AbYEUNDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935292AbYEUNDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935169AbYEUNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:03:39 -0400
Received: from gozo.interway.ch ([194.246.118.4]:44474 "EHLO gozo.interway.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935151AbYEUNDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:03:37 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 May 2008 09:03:37 EDT
Message-ID: <48341C0B.7010003@interway.ch>
Date: Wed, 21 May 2008 14:56:43 +0200
From: Matthias Cramer <matthias.cramer@interway.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Wired behaviour with IPv6 over PPP
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCF9A8F04F7F73537C01EDB67"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF9A8F04F7F73537C01EDB67
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi All

I have a very wired behaviour when doing IPv6 over PPPoE.

The situation:

A linux box connected to a DSL Modem, on the other side is a Cisco LNS wh=
ich terminates the PPP session (actually L2TP).
I have control over both ends.

When I have net.ipv6.conf.all.forwarding set to 0 then the ppp Interface =
gets a IPv6 address from the Cisco via IP6CP.
When I have net.ipv6.conf.all.forwarding set to 1 them the ppp Interface =
does not get an address, it has only a normal link local address.

When I start the ppp session with forwarding set to 0 I can ping out and =
there exists a default route to ppp0 , then I switch forwarding to 1
the default route disappears and therefore routing does not work any long=
er.

Is this a known behaviour ?

Or am I doing something the wrong way ?

Kernel version is 2.6.25

Best regards

  Matthias

--=20
Matthias Cramer / mc322-ripe   System & Network Manager
Interway Communication GmbH    Phone +41 43 500 1111
Josefstrasse 225               Fax   +41 44 271 3535
CH-8005 Z=C3=BCrich                 http://www.interway.ch/
GnuPG 1024D/2D208250 =3D DBC6 65B6 7083 1029 781E  3959 B62F DF1C 2D20 82=
50


--------------enigCF9A8F04F7F73537C01EDB67
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFINBwRti/fHC0gglARAvbzAJ91A0C99YB0iw7aZqQR7BP/Ojdv1ACfbWQl
ePndO9qdH+ecZu8K6lE5t68=
=pLx9
-----END PGP SIGNATURE-----

--------------enigCF9A8F04F7F73537C01EDB67--
