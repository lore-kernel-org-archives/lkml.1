Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbYEZNJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbYEZNJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYEZNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:09:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYEZNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:09:46 -0400
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Alexandre Oliva <aoliva@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
In-Reply-To: <200805261453.01658.mb@bu3sch.de>
References: <1211550282.28967.8.camel@pmac.infradead.org>
	 <200805252049.39731.mb@bu3sch.de>
	 <or4p8lzrjl.fsf@oliva.athome.lsd.ic.unicamp.br>
	 <200805261453.01658.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yY3dO/OzeRqN+n5LXQge"
Date: Mon, 26 May 2008 15:08:32 +0200
Message-Id: <1211807312.4843.2.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yY3dO/OzeRqN+n5LXQge
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This doesn't make any sense. Either it is a filename/pathname, or it is n=
ot.

I still think that in the kernel it shouldn't be thought of as a
filename and I have not yet seen any real reason why it has to be.
Whether your userspace then uses it as a filename or not is pretty much
orthogonal, it currently does for great effect, and since the only
firmware loader currently is userspace, we tend to think of it as a
filename in the kernel too.

However, when building firmware into the kernel, this will no longer be
true, it'll be a simple key in an array.

johannes

--=-yY3dO/OzeRqN+n5LXQge
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDq2TqVg1VMiehFYAQIVzQ/+IKqG0lkrC8OmnD3aB9shpXjNSU/Qoci7
6XhJDTpIzaoXf3lmuHwHsxAp99a7PJI8bNuIkqR61pAMHqs1aZpCgokujzQ9IjTy
yrI+SN3/8P8QR1nuQh6PrqMufz3ixC6bLqw9neHDxJCtjo0udIBIcWThEKRqyslr
q23No5siTYTjyF2s5kX0RemFW991NvWZzPvoGIHeX8A4amuwMV8A+uy9GJESu2p+
H1f4anrFjU2WYR0Vkg3yXbu95XD78qZ8naC3pOSKmUs4DHbNz8ogIlOTUVWKghN2
ID8WDSSl//n35TqWUjtOhyNJQzRqB5NJKInLcTSZ7nYE3765r/tEVSDgUHiARQWB
ZPhd+2UWz/AxHTuwGjUiaOE6Z1R0OHd8PeWWYC1dc44jWnOBaGyTxyRVY4A3qvL8
sH8T6pdMMq6l6KmZMAGSr5eF05gPZL05znUNhbHTphV16/MdU5GMydHZKXCooGs+
CMdX4GH6pfrBwjDOpm72VYO3lguJamufqM9Jg9s3+xTV2J5b1q1U7yApkz0/Aszm
VdA8KkwhEXiEyx1dpllpIQGVOGw35CUiofn3uhrDnKX9IiKR4wwPyxewPUUfwi5W
taOprcaNS8mkflDPltpk6Nnw8q6rfR8uq6gF7CAnBXt5+FIzVp4N3Z+xF4NjSASh
F/II0Vku/yA=
=pkka
-----END PGP SIGNATURE-----

--=-yY3dO/OzeRqN+n5LXQge--

