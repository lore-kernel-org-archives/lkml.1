Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbZEBI1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbZEBI1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 04:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZEBI1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 04:27:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60388 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZEBI1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 04:27:09 -0400
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Johannes Berg <johannes@sipsolutions.net>
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
In-Reply-To: <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
	 <f7848160905011328o68010ba0rf8e18fa7ce88c7b5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cI8+puQ4D4u3cQTnqcw5"
Date: Sat, 02 May 2009 10:27:05 +0200
Message-Id: <1241252825.13562.20.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cI8+puQ4D4u3cQTnqcw5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Parag,

> Just got around to downloading today's compat-wireless and it doesn't
> work for me - frequent disconnects this time with response timeouts -
>=20
>  9731.902114] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
> (capab=3D0x411 status=3D0 aid=3D1)
> [ 9731.902117] wlan1: associated
> [ 9886.744022] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
> disassociating
> [ 9887.594299] wlan1: authenticate with AP 00:1e:e5:6a:2c:c2
> [ 9887.596953] wlan1: authenticated
> [ 9887.596958] wlan1: associate with AP 00:1e:e5:6a:2c:c2
> [ 9887.600997] wlan1: RX ReassocResp from 00:1e:e5:6a:2c:c2
> (capab=3D0x411 status=3D0 aid=3D1)
> [ 9887.601000] wlan1: associated
> [ 9930.640019] wlan1: no probe response from AP 00:1e:e5:6a:2c:c2 -
> disassociating

This looks like something entirely different.

> Of course mainline continues to work fine after reverting
> 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8.

Can you make sure the txpower is set correctly, on your compat? Just say
"iwconfig wlan0" or whatever _while_ associated -- and check that it
reports 15dBm or so.

johannes

--=-cI8+puQ4D4u3cQTnqcw5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/APWAAoJEKVg1VMiehFYOjQP/jcAhxAmJCZAuT/ln7zXKCQO
VDpX16jT0BPsZTFbdSLHpIucQOzaleD2TaJZ5iTAMqyDTNwmFQr+YmXgdC0rT9pm
zQo0DXXGv83U+T/dj2IMwCS1BFdyvo0wJ1KLPpSsu7eKYjo8m143uM+d8KcwmCCZ
RwwlZ9SnOCK7SeJ/KpSmbqlspOzqSK0FzrhZbjCMiN/kIYkkpUNP5Ccf+No7MqJR
Z+kVOZvkZ0cl2tJ4Ysi8Y3zIjm8WIQJfnPgZe+fJ3tYuXmRO0jDS9dhva4gSYoYZ
RJX18iX9hqR75m3ASp0QXh5dt7NBgSkzbNN327D/HSnhpVnwRGzgjq8787NH1mhI
rm0V6TVI6zrbu+kBK40CVkQwhQc/ky86CsWh5qnHYM9Nof//UcJkikQ65zn5v11t
zGmMkROa2ptslr6EqFEtcwy9TloiUfpNtd4JvtKvUKfn09ns5CMvQE64Au4yO3Bv
RLSonwa1np1kVonff+9b3J7AdoFurDQjFKwPgfuNTxUEn9snsGAR4kdjer4TR0N6
OF1P9Aw8wcO7yBrkkGLGTehCBplpgruiZXTTAj8CQTWfoBTUPfuhMqlqgJVScvWg
rAb+TdKjuNAm01IhA7OcSE8QSTmn+ifB0yqXvGKAZymnfp4Kge/8WGEj/8ZviQuh
08n0nsgOPgjwOjdM2S5b
=elRj
-----END PGP SIGNATURE-----

--=-cI8+puQ4D4u3cQTnqcw5--

