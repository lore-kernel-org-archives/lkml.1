Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab0BYTJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:09:05 -0500
Received: from mail.ipom.com ([74.207.225.167]:48114 "EHLO mail.ipom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab0BYTJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:09:00 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2010 14:09:00 EST
Message-ID: <4B86C96B.7060508@ipom.com>
Date: Thu, 25 Feb 2010 20:03:07 +0100
From: Phil Dibowitz <phil@ipom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [resend] unusual_devs.h: Fix capacity for SL11R-IDE 2.6c
References: <201002241141.10103.linux@rainbow-software.org>
In-Reply-To: <201002241141.10103.linux@rainbow-software.org>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDA9EC9A728076E808FCB0E6D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDA9EC9A728076E808FCB0E6D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/24/2010 11:41 AM, Ondrej Zary wrote:
> SL11R-IDE 2.6c (at least) reports wrong capacity (one sector more).
> Reading that last sector causes the device not to work anymore (and loo=
ks
> like HAL or something does that automatically after plugging in):
> sd 5:0:0:0: [sdc] Device not ready
> sd 5:0:0:0: [sdc] Result: hostbyte=3D0x00 driverbyte=3D0x08
> sd 5:0:0:0: [sdc] Sense Key : 0x2 [current]
> sd 5:0:0:0: [sdc] ASC=3D0x0 ASCQ=3D0x0
> sd 5:0:0:0: [sdc] CDB: cdb[0]=3D0x28: 28 00 04 a8 b5 70 00 00 01 00

Ondrej,

I got both of your emails, but I was in LA for the SCALE conference. Give=
 me
a day or two to catch up.

--=20
Phil Dibowitz                             phil@ipom.com
Open Source software and tech docs        Insanity Palace of Metallica
http://www.phildev.net/                   http://www.ipom.com/

"Be who you are and say what you feel, because those who mind don't matte=
r
 and those who matter don't mind."
 - Dr. Seuss



--------------enigDA9EC9A728076E808FCB0E6D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkuGyWsACgkQN5XoxaHnMrsUmgCeOs0Rmqnp8axBZv7VL/lSGg1V
bZ4An2/2JiLK1rSakBwQeI62TPoJspKx
=gFzQ
-----END PGP SIGNATURE-----

--------------enigDA9EC9A728076E808FCB0E6D--
