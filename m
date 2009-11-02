Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbZKBKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbZKBKJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZKBKJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:09:34 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:41480 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754399AbZKBKJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:09:32 -0500
X-Sasl-enc: Gn4D8az9gA6b78YfbHuqfMFfDEXXB7emdtXmncZwiOFi 1257156575
Message-ID: <4AEEAFD1.5070703@imap.cc>
Date: Mon, 02 Nov 2009 11:09:21 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Nigel Cunningham <ncunningham@crca.org.au>,
       =?ISO-8859-1?Q?Andr=E9_?= =?ISO-8859-1?Q?Goddard_Rosa?= 
	<andre.goddard@gmail.com>,
       trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Kernel cleanup Wiki (was: [PATCH 03/16] trivial: fix assorted "through"
 typos)
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>	<4AEC0EBE.2040308@crca.org.au>	<4AEC2971.8050105@imap.cc> <20091101095208.10d57e8f.rdunlap@xenotime.net>
In-Reply-To: <20091101095208.10d57e8f.rdunlap@xenotime.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4099070810D89DEA574EC440"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4099070810D89DEA574EC440
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.11.2009 18:52 schrieb Randy Dunlap:
> On Sat, 31 Oct 2009 13:11:29 +0100 Tilman Schmidt wrote:
>=20
>> Am 31.10.2009 11:17 schrieb Nigel Cunningham:
>>> I've only looked at this one, but something caught my eye...
>>>
>>> Andr=E9 Goddard Rosa wrote:
>>>> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>>>> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>>>> index f7b9cdc..b52c1f8 100644
>>>> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>>>> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>>>> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int =
cpu)
>>>>
>>>>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>>>>  	d_cache =3D CPLB_L1_CHBL;
>>>> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
>>>> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
>>>>  	d_cache |=3D CPLB_L1_AOW | CPLB_WT;
>>>>  #endif
>>>>  #endif
>>> "Surely that can't be the only time?", I thought. But it is - all of =
the
>>> other #ifdefs are spelled correctly, so you're probably fixing a
>>> hard-to-find bug here! Good catch!
>>>
>>> Makes me wonder if anyone's written a tool to find things like this -=

>>> #ifdefs that will never be defined...
>> I seem to remember someone (Joe Perches?) did, and regularly posted
>> results to LKML in the past, but at some point switched to publishing
>> them on a web page instead.
>=20
> It was Robert PJ Day.

Indeed it was, and kudos to him for doing it.
Please forgive my middle-aged brain for the misattribution.

> See http://www.crashcourse.ca/wiki/index.php/Kernel_cleanup

And sure enough, CONFIG_BFIN_EXTMEM_WRITETROUGH is listed there on the
"Badref CONFIG variables" page.

It seems that page would merit a bit of advertising. :-)

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4099070810D89DEA574EC440
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK7q/cQ3+did9BuFsRAlITAJ0TrweoVe9CX+cK2Afo+f1Ie7GFlwCfb9w2
+4f3+sfwbYF//kM8VDyDXXc=
=Ix7N
-----END PGP SIGNATURE-----

--------------enig4099070810D89DEA574EC440--
