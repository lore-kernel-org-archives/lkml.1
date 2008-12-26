Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbYLZCj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbYLZCj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 21:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYLZCjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 21:39:49 -0500
Received: from Powered.by.Root24.eu ([81.169.180.23]:37025 "EHLO Root24.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbYLZCjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 21:39:48 -0500
Message-ID: <495443E6.404@ionic.de>
Date: Fri, 26 Dec 2008 03:39:34 +0100
From: Mihai Moldovan <ionic@ionic.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20081005)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Zhu Yi <yi.zhu@intel.com>, James Ketrenos <jketreno@linux.intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       linux-wireless@vger.kernel.org
Subject: Firmware errors with ipw2200 when connected to an WPA-enabled AP
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig41CFF7FA9F2BB5ECFD87B1E3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig41CFF7FA9F2BB5ECFD87B1E3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

I am seeing some really weird behavior with my IPW2200 card.

I am connected to an AP (multiple Atheros cards with hostapd) and
WPA-PSK with CCMP encryption.

When the connection is fully idle, I do see those messages coming up
pretty randomly:

[41715.420882] ipw2200: Firmware error detected.  Restarting.

The card is then resetting itself, the connection is dropped for some
milliseconds, but all in all no harm is done.

Another situation happens when the card is on full load:

[38659.056980] __ratelimit: 21 callbacks suppressed
[38659.056985] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.057638] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.058005] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.058356] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.059127] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.059637] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.060123] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.060671] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.061046] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e
[38659.061641] CCMP: decrypt failed: STA=3D00:22:b0:bc:1e:2e

Those messages are repeated from time to time. The connection itself is
not being dropped, and netcat itself doesn't stop either, but for some
seconds, no packets are going through the WiFi link.

So, I am really curious about this, although not being fatal in itself,
the errors are pretty annoying.

I've added the respective Devs to the CC list, I hope this is OK.

One more sidenote though: I've been running IPW2200 for several years
with WEP and haven't experienced those errors yet, at least not in this
quantity. The card used to reset sometimes due to "firmware errors", but
please read "sometimes" as  "every two weeks once."

Another little question: will the card be supported by the new
iwlwifi/iwlcore/iwlagn drivers anytime soon, or will the "old" ipw2200
driver be the only one for this card? Someone really should update the
documentation, at least in the kernel build system regarding this,
currently "There is no help available." :)

Please let me know if you need any more information, I will hand it to
you ASAP.

Best regards,


Mihai Moldovan


--------------enig41CFF7FA9F2BB5ECFD87B1E3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBCgAGBQJJVEPsAAoJEB/WLtluJTqHPUYP/28cTv4yp74g0fsv8bJdzLBz
iP8M5zJ6aXzx+o00J6g+WQMnatY59a+MW2fbB3neSA/CZ5/Ga4lECOX9u55/0XD7
TtWORGABb7+mVh9qpHWrdUTrSmONjNt/+m59Ec3Q4p5CfAWP8oKZMmVKmno+HRAo
yFIXWdbrTV0tz/cNjB5vyT53nozSzPWBv+17/ZdpmASnU+wQZ/ezFZ7y9XdUarAb
thprig40uP0bodgMIA63EAxOibwmEE88jPXWHlASeJ30XNEZX8WZkc1erT4r/eC3
DHJfou9IBUktChx3H+2n7kb+xeajBlMLvkp2woS+isE53CbQZt0Lc2WPkq1b+9VV
VYQcMRBRBQq+vo4gp2JuhSQ/dcKJLMWjmL3mWrGfySRg0u6GXAD+Q5aT66aGxAv1
U8zro8+CSo/e9skrNbY0dyybgRdTBcw26xw5LwoFunCZAYcUgRWJvjdD1R1fFMYD
r/LJRPvMFOCAkdZ0kWa3syv+aNaTKYnzQtCdZ6AhjxApbW7WBQsATRW9FqeonGRg
eTJWgXtHfFYmvgFTfxp/DnimAEIPOLe7m9+crsrU7l7nQP3AEwAkQQcS3EBNB5Pf
9kFVubcHDDJBqgt4TfyLAvMSZRYIDoxzyuHRKW4G14RjSGxeqrWRBC/sT77gySrl
l1+At2+XTA0oSIEIoWoQ
=fSiI
-----END PGP SIGNATURE-----

--------------enig41CFF7FA9F2BB5ECFD87B1E3--
