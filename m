Return-Path: <linux-kernel-owner+w=401wt.eu-S1752135AbXBJXpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbXBJXpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:45:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXBJXpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:45:14 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:59257 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXBJXpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:45:13 -0500
X-Sasl-enc: 2QpZGeLwZBmXut2xWkVjcPZB4TSfW/xa4GUPq/9MCTM3 1171151110
Message-ID: <45CE5934.3020801@imap.cc>
Date: Sun, 11 Feb 2007 00:45:56 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net>	 <1171059433.8675.195.camel@laptopd505.fenrus.org>	 <20070210193851.GA3956@ucw.cz>  <200702102320.39531.rjw@sisk.pl> <1171147026.19894.16.camel@nigel.suspend2.net>
In-Reply-To: <1171147026.19894.16.camel@nigel.suspend2.net>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC63E2F3E9D4A90C8351F7D00"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC63E2F3E9D4A90C8351F7D00
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 10.02.2007 23:37 schrieb Nigel Cunningham:
> If your device requires power management, and you know it requires powe=
r
> management, why not just implement power management? Doing -ENOSYS
> instead is like saying -ESPAMMEBECAUSEIMLAZY.

Like it or not, power management is far from trivial, and people
writing device drivers have limited resources. Calling them lazy
does not help that in the least. If you try to put pressure on them
by refusing to merge their work as long as it doesn't provide this
or that functionality, you *may* end up with a few drivers having
that functionality which otherwise wouldn't, but you *will* also
end up with a number of drivers never making it into the kernel
because their authors just have to give up.

Also, in your argument you neglected a few cases:
- What if my device does not require power management?
- What if I don't know whether my device requires power management?
- What if I know my device would require power management, but don't
  know how to implement it?

> Let me put it another way: People keep talking about Linux being ready
> for the desktop. To me at least (but I dare say for lots of other peopl=
e
> too), being ready for the desktop means that things just work, without
> having to recompile kernels or bug driver authors or wait twelve
> months.=20

Exactly.

> And it means that doing a bare minimum isn't enough. We keep claiming
> that Open Source is better than Proprietary software. If we accept
> half-pie jobs of implementing support for anything - driver power
> management support or hibernation support or whatever - as 'good
> enough', we're undercutting that argument. Linux's power management
> support should - as far as we're able - be at least as good as that
> other operating system's and preferably way, way better.
>=20
> -ENOSYS is just not acceptable.

Your argument falls down the moment you consider the alternative:
not merging the driver means that the device won't work at all.
(Given that out-of-tree drivers are actively discouraged, to put
it mildly.) That's arguably farther from "desktop readiness" than
a device not supporting power management.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enigC63E2F3E9D4A90C8351F7D00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFzlk9MdB4Whm86/kRAuZjAKCBWfOq/NT2K2Rt2AcZxF2vJP9CSgCdEZMp
r4stqnITFoA3jAgb2/fhSM8=
=VoLM
-----END PGP SIGNATURE-----

--------------enigC63E2F3E9D4A90C8351F7D00--
