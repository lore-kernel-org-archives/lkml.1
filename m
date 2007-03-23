Return-Path: <linux-kernel-owner+w=401wt.eu-S933926AbXCWTkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933926AbXCWTkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 15:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbXCWTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 15:40:42 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:41928 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933926AbXCWTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 15:40:41 -0400
Subject: Re: 2.6.21-rc4-mm1
From: Zan Lynx <zlynx@acm.org>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, bluez-devel@lists.sourceforge.net,
       reiserfs-dev@namesys.com
In-Reply-To: <46015990.0@lwfinger.net>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <1174433034.62033.16.camel@localhost>
	 <20070320223643.d8cbc3f6.akpm@linux-foundation.org>
	 <46015990.0@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-T9xAHRaGXU5aa4okKXwV"
Date: Fri, 23 Mar 2007 13:40:32 -0600
Message-Id: <1174678832.289400.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-T9xAHRaGXU5aa4okKXwV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-21 at 11:13 -0500, Larry Finger wrote:
> Andrew Morton wrote:
> > On Tue, 20 Mar 2007 17:23:54 -0600 Zan Lynx <zlynx@acm.org> wrote:
> >> First impressions:
> >> Several of the same bugs as rc3-mm*:
> >>       * Freezes immediately if I touch the wlan0 device after loading
> >>         the new Broadcom wireless driver.
>=20
> --snip--
>=20
> >> 02:02.0 Network controller: Broadcom Corporation BCM4303 802.11b Wirel=
ess LAN Controller (rev 02)
>=20
> I'm a little confused. The bcm43xx-mac80211 driver does not handle 802.11=
b devices, and the
> bcm43xx-softmac driver should not freeze. Which one was configured here?

It may have partly been a problem of having half of softmac and half
devicescape.  I'm not entirely sure what udev did.

I tried a patch for the Sonic Silicon that was posted and I turned off
all the configuration for the softmac driver.

It isn't crashing right now but 802.11 isn't working either.  I may get
a chance this weekend to try some things with it, and some different
firmware sets.

If the new bcm43xx drivers do not support 802.11b at all and never will,
I missed the documentation.  Someone should add that to Kconfig.
--=20
Zan Lynx <zlynx@acm.org>

--=-T9xAHRaGXU5aa4okKXwV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGBC0wG8fHaOLTWwgRAjx2AKCV/CK0iBVpck/IjTXzpqEuxdykUwCeNS6N
r3/AJOR7cLYuU2WHk6F+ZSU=
=dMzn
-----END PGP SIGNATURE-----

--=-T9xAHRaGXU5aa4okKXwV--

