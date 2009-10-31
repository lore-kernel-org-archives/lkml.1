Return-Path: <linux-kernel-owner+w=401wt.eu-S932602AbZJaMLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602AbZJaMLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 08:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757691AbZJaMLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 08:11:30 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37111 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757678AbZJaMLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 08:11:30 -0400
X-Sasl-enc: CRQF7CxrP/bavJtvZyLmG9RZ92LSzJ6P92oDKXabmfdN 1256991094
Message-ID: <4AEC2971.8050105@imap.cc>
Date: Sat, 31 Oct 2009 13:11:29 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Nigel Cunningham <ncunningham@crca.org.au>
CC: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
       trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/16] trivial: fix assorted "through" typos
References: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com> <4AEC0EBE.2040308@crca.org.au>
In-Reply-To: <4AEC0EBE.2040308@crca.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7FA32ED3347CE590E4A70F75"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7FA32ED3347CE590E4A70F75
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 31.10.2009 11:17 schrieb Nigel Cunningham:
> I've only looked at this one, but something caught my eye...
>=20
> Andr=E9 Goddard Rosa wrote:
>> diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> index f7b9cdc..b52c1f8 100644
>> --- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> +++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
>> @@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cp=
u)
>>
>>  #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
>>  	d_cache =3D CPLB_L1_CHBL;
>> -#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
>> +#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
>>  	d_cache |=3D CPLB_L1_AOW | CPLB_WT;
>>  #endif
>>  #endif
>=20
> "Surely that can't be the only time?", I thought. But it is - all of th=
e
> other #ifdefs are spelled correctly, so you're probably fixing a
> hard-to-find bug here! Good catch!
>=20
> Makes me wonder if anyone's written a tool to find things like this -
> #ifdefs that will never be defined...

I seem to remember someone (Joe Perches?) did, and regularly posted
results to LKML in the past, but at some point switched to publishing
them on a web page instead.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig7FA32ED3347CE590E4A70F75
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFK7ClxQ3+did9BuFsRAl4PAKCa1buhT5R7YufueLTYCdcDaRALRgCeOUSy
IZ3UuQmpIsoJq/W+FhudGcA=
=y5Fi
-----END PGP SIGNATURE-----

--------------enig7FA32ED3347CE590E4A70F75--
