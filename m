Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYJUVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYJUVa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYJUVaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 17:30:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbYJUVap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 17:30:45 -0400
Subject: Re: Regression in 2.6.27-git from commit 43ac2ca3840f64
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       John Linville <linville@tuxdriver.com>
In-Reply-To: <48FDFCCA.8040604@lwfinger.net> (sfid-20081021_232731_453910_0675C4D6)
References: <48FDFCCA.8040604@lwfinger.net>
	 (sfid-20081021_232731_453910_0675C4D6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FvwKm92DqCiD2epAvsvz"
Date: Tue, 21 Oct 2008 23:30:36 +0200
Message-Id: <1224624636.28639.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FvwKm92DqCiD2epAvsvz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 09:01 -0700, Larry Finger wrote:
> On my x86_64 system, the mainline 2.6.27-git kernel (v2.6.27-6030-g6da0b3=
8)
> shows the following anomaly with the 'iwlist scan' command:
>=20
>           Cell 03 - Address: 00:14:BF:85:49:FA
>                     ESSID:"lwfdjf"
>                     Mode:Master
>                     Channel:1
>                     Frequency:2.412 GHz (Channel 1)
>                     Quality=3D66/100  Signal level:-62 dBm  Noise level=
=3D-68 dBm
>                     Encryption key:on
>                     IE: Unknown: 00066C7766646A66
>                     IE: Unknown: 010882848B962430486C
>                     IE: Unknown: 030101
>                     IE: Unknown: 2A0104
>                     IE: Unknown: 2F0104
>                     IE: Unknown: 32040C121860
>                     IE: Unknown: DD09001018020014000000
>                     IE: WPA Version 1
>                         Group Cipher : TKIP
>                         Pairwise Ciphers (1) : TKIP
>                         Authentication Suites (1) : PSK
>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>                               24 Mb/s; 36 Mb/s; 54 Mb/s; 6 Mb/s; 9 Mb/s
>                               12 Mb/s; 48 Mb/s
>                     Extra:tsf=3D0000014488aeb18b
>                     Extra: Last beacon: 448ms ago
>=20
> This problem was bisected to commit 43ac2ca3840f64f699a239535c590fa7ebaaa=
c27,
> entitled "mac80211: Handle scan result IEs in one block". The same bug is
> present in the wireless-testing tree.

I'm probably too tired, what exactly is the problem?

johannes

--=-FvwKm92DqCiD2epAvsvz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/kn4AAoJEKVg1VMiehFYxcgP/0nlanrDO3PaajNsAjCEQu/6
ZkGa6k/bp3FqBOpmMYJ8V04CMcS76qAo29NfDRs2S29jXAbjmvRmnkcqKiw4Fh02
PA9brm+fKjk4a1O2vowIb2kfUEs24E4zXdNryIdPVE+scS7SDKQ3mSGXdu/lExk6
C//3W0jMZhdQbG7Ru11T73YsDMO1AIpe0kc8I6xNPl00OK36v2xifVnx2ROqmxre
7hs2o+0DrO85+DtCEugOUWLtYoyeSYpoPxQjGKXer/+pK0PRPXXcK5H3lLF1W0LZ
/Km6TnZqN/fJGc9znHdYtOJxHEoejhbfkwYqhoTbJUAQ7wUs3E6Zr4dHJXhVGJHk
N5AcJxQR2xBojAdLlrrv/BW8BN24vaXs7HhLlKIhZUmPL5UFzNQXYB/rqAg0Q+lr
5JP5bGvZVGTeUHtnkOarN+isFd6IANjRhs2pJgSOsVk8XdgoY14lIFbbIsfwkGE3
7kCns475AwIAICbjrwKEXaFHndon6HMYHz/+yqU9ArlSC/tGlZB8LsZvTNJIXL9i
0wsWFY+M5d3owhVKNWpI8QxnEiHNl8+tiD/cj9VGtBy+NRKeZJA6wf9QuaeSZrBD
lEFHu6GhBRYvV8Zf/ynvEAAKDpdWSQklrmd8nP/L/6syHplFzvFsydrtZBYOI53z
0/cuy948F8IhJi03Kvbn
=1T3d
-----END PGP SIGNATURE-----

--=-FvwKm92DqCiD2epAvsvz--

