Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZL1NKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZL1NKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 08:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZL1NKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 08:10:36 -0500
Received: from mail.klingt.org ([86.59.21.178]:35355 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZL1NKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 08:10:35 -0500
Message-ID: <4B38AE1D.8060703@klingt.org>
Date: Mon, 28 Dec 2009 14:09:49 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: perf: counter and event question
References: <4B389391.8050303@klingt.org> <1261999573.7135.83.camel@laptop>	 <4B38A707.4060904@klingt.org> <1262005413.7135.98.camel@laptop>
In-Reply-To: <1262005413.7135.98.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2C53DA6030BFBAE4717C266F"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 28 Dec 2009 14:09:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C53DA6030BFBAE4717C266F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>>>> like it is impossible to sample instructions with a period of 1?=20
>>>
>>> Pretty much, imagine the cpu getting a trap every cycle.
>>
>> is this a hardware restriction? a slowdown is acceptable for me, as lo=
ng
>> as i am able to collect a huge number of samples accurately ...
>=20
> Large number of samples and sample interval are only related through th=
e
> runtime of your application.
>=20
> Use a sensible period (~10k ins) and run a 'little' longer.

well, for my application, i am not interested in statistical data, but
in the order of the events ...
(i am not doing profiling, but trying to gather a sequence of
machine-structured data for an artistic project)

tim

--=20
tim@klingt.org
http://tim.klingt.org

It is better to make a piece of music than to perform one, better to
perform one than to listen to one, better to listen to one than to
misuse it as a means of distraction, entertainment, or acquisition of
'culture'.
  John Cage


--------------enig2C53DA6030BFBAE4717C266F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks4rh0ACgkQdL+4qsZfVsv3fwCfe28KlRCUffRuYZR4vvblFoYY
TMUAoKI7e8x/Mj+OylDaLmRb69EP5BQ+
=+uNk
-----END PGP SIGNATURE-----

--------------enig2C53DA6030BFBAE4717C266F--
