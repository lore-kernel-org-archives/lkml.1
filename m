Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYJVRvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYJVRvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758593AbYJVRqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:46:45 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759799AbYJVRqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:46:44 -0400
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Jouni Malinen <j@w1.fi>,
       Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
In-Reply-To: <20081022173721.GA5786@bougret.hpl.hp.com>
References: <48FDFCCA.8040604@lwfinger.net>
	 <20081022072840.GD16005@jm.kir.nu> <48FF5933.3080501@lwfinger.net>
	 <1224695189.30459.6.camel@johannes.berg>
	 <20081022173721.GA5786@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sSRdTBaFhg2j8CwjAiw8"
Date: Wed, 22 Oct 2008 19:46:27 +0200
Message-Id: <1224697587.30459.37.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sSRdTBaFhg2j8CwjAiw8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 10:37 -0700, Jean Tourrilhes wrote:

> 	If you want me to understand what it's about, you may want to
> give me a bit more context.

Sorry. Basically, Larry is saying that due to a kernel change, iwlist
will print out things like
                    IE: Unknown: 0017465249545A21426F7820466F6E20574C414E20=
37313133
                    IE: Unknown: 010482848B96
                    IE: Unknown: 030106
                    IE: Unknown: 2A0106
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                    IE: Unknown: 32080C1218243048606C
                    IE: WPA Version 1
                        Group Cipher : TKIP
                        Pairwise Ciphers (1) : TKIP
                        Authentication Suites (1) : PSK
                    IE: Unknown: DD0A0800280101000200FF0F
                    IE: Unknown: DD180050F2020101800003A4000027A4000042435E=
0062322F00


where all the IE: Unknown lines are unexpected.

> 	Alternatively, just send me a patch for Wireless Tools, and
> I'll put it in the next release. Wireless Tools is still maintained
> and I still do releases, even if I don't put much cycles into it.

The problem is that we don't quite know what to do about them :)

johannes

--=-sSRdTBaFhg2j8CwjAiw8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/2bvAAoJEKVg1VMiehFYrIYP/0ybXX5gOhzVJZT9WRau0ND6
Yck6NYVJ54/pBzaGv2Sr4XEOMU4TGnxSu8XO//dsAUxqYppc9slh4fqP1S1a2NiB
RwkfhXnmtxRgTEgaBHPc1uKMTOk1mULcYI5AkGaRdYpxiJucx3WC9XhNUzstLgBF
12du7CNHf3Ph8y1FCp7pQJvuV2+Hu6R0sChVLnAdGZl8QbJU8pRXzeXqqdsqVMyg
GFmCWJvUrLrCCSD8O4YmYjC46FvF6zYR/ptubeWsdgEr5a2bv4RShx3P0o7EoyUg
paZEqLJAGg2mbXDgYFbq8mhph2LDKCxpjsgAa34Ja3MX+Y3LgEe0L0DjVFYiJGGh
Bbl+LoQqZVuQN8wUdZQuRSUfa06tlSHoSsx2e6yJWjVwuZy9IMyNMAibXy8VPUhG
j5XDZXlfJB7F7SOA0MfD+955Z1WrbYrBi7TFDKA+EiBENJ7uOwQcrYy6doxbXDBI
0/2pr2VAMie6HNbVnTprELRLa4vZf1s5uOsbXRSoZGpUWnJwkl3XhHqvRwx0bl4b
FRQhSi3xV7hED68ydy00Qmr9j5ho9u4SgZWT4HWX7uIhbXmLzkhBHdX5U4jQ3W+7
dLWJO1Mx48Y6gVG/h1Q+NVkH9Yg2Q9WyrKU7unBEuHDuU0z6vIFR07M9xtKG6of6
O9UiLSYpnZZI6GIepsYm
=jRPW
-----END PGP SIGNATURE-----

--=-sSRdTBaFhg2j8CwjAiw8--

