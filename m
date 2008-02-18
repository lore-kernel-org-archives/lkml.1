Return-Path: <linux-kernel-owner+w=401wt.eu-S1759651AbYBRLkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651AbYBRLkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756982AbYBRLkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:40:31 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:4863 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759406AbYBRLkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:40:31 -0500
Message-ID: <47B96E94.7000109@imap.cc>
Date: Mon, 18 Feb 2008 12:40:04 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: bunk@kernel.org, elendil@planet.nl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Unable to continue testing of 2.6.25
References: <200802171025.30590.elendil@planet.nl>	<20080217131611.GA1403@cs181133002.pp.htv.fi>	<47B88A08.2070902@imap.cc> <20080217.183330.34203930.davem@davemloft.net>
In-Reply-To: <20080217.183330.34203930.davem@davemloft.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4ABA91C56C61B263D89206F2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4ABA91C56C61B263D89206F2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

David Miller schrieb:
> From: Tilman Schmidt <tilman@imap.cc>
> Date: Sun, 17 Feb 2008 20:24:56 +0100
>=20
>> No, that's not the real problem. Even if the kernel didn't lack
>> any required functionality and it could all be done today without
>> VirtualBox, pulling the rug from underneath it like that leaves
>> all those who are currently relying on it without the ability to
>> continue testing newer kernels until they find the time to redesign
>> their working environment.
>=20
> No, it is VirtualBox's problem.

Why's that beeping noise coming from my SEP field detector? :-)

>  Nobody outside of the kernel
> should be using that symbol, it can only be used for totally
> unsupportable things as far as upstream is concerned.

Then why was it exported in the first place?

Still, we are talking about two completely different types of
problem here: (a) the technical problem of why something stopped
working and how it should be fixed and (b) the practical problem
of users left standing in the rain while such fixing is taking
place. While (a) might look like the only real problem to kernel
developers, (b) often feels much more real to users.
Unfortunately, discussing alternative solutions to (a) does
little to solve (b).

The conventional way of addressing (b) is to avoid it altogether
by giving sufficient advance warning before removing a feature,
and sticking to the feature removal schedule. If (as apparently
in this case) that isn't possible, then other ways to mitigate
the problem need to be found. That may require switching off
some SEP field generators, though. :-)

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4ABA91C56C61B263D89206F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHuW6VQ3+did9BuFsRAlBlAJ9Kllx0G7bvH43PxlIdK54LKPGuJACglRPd
J1RkTNz/MWZCdPUTYX/cwgg=
=NAsq
-----END PGP SIGNATURE-----

--------------enig4ABA91C56C61B263D89206F2--
