Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbZAKPa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbZAKPa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbZAKPaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:30:17 -0500
Received: from xsmtp1.ethz.ch ([82.130.70.13]:12322 "EHLO xsmtp1.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZAKPaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:30:16 -0500
Message-ID: <496A107A.2090301@gmx.de>
Date: Sun, 11 Jan 2009 16:30:02 +0100
From: Dieter Ries <clip2@gmx.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>
In-Reply-To: <20090111151924.GA5722@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7BEF5A3990ABBA6BABDCBD20"
X-OriginalArrivalTime: 11 Jan 2009 15:30:14.0293 (UTC) FILETIME=[7FB1FC50:01C97401]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7BEF5A3990ABBA6BABDCBD20
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ingo Molnar schrieb:
> * Dieter Ries <clip2@gmx.de> wrote:
>=20
>> Hi,
>>
>> I just pulled 2.6.29-rc1, ran oldconfig with defaults and built it.
>> When I try to boot it, that kind of works until init should start. The=
n
>> nothing happens. I tried with init=3D/bin/bash, which sometimes works,=
 and
>> sometimes gets me a bash without the prompt flashing.
>>
>> I captured the output with netconsole, but I cannot see a problem ther=
e.
>> It is attached.
>>
>> My config is also attached.
>>
>> The machine:
>>
>> Lenovo Thinkpad T60
>> Core2Duo 2GHz
>>
>> Gentoo 64bit
>>
>> Everything worked fine with 83bc66f, which was my last pull.
>>
>> What else should I provide for debugging that?
>=20
> hm, there's no 83bc66f in Linus's tree.

Sorry, thats because I applied Timo Hoenigs patch for the fingerprint
reader. So the right commit where it worked is 6680598.

Before pulling today, I reverted that patch, to avoid conflicts, so I
guess it should not matter.

>=20
> 	Ingo
>=20


cu
Dieter

--=20
3rd Law of Computing:
        Anything that can go wr
fortune: Segmentation violation -- Core dumped


--------------enig7BEF5A3990ABBA6BABDCBD20
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklqEH4ACgkQ5YzjaZZeXo0jNgCeMHLjoN9X4UAU7kkTce8zdOjO
cVkAmQGf7AEguJZuKF/cxrdQmnFhKRMN
=Kfsf
-----END PGP SIGNATURE-----

--------------enig7BEF5A3990ABBA6BABDCBD20--
