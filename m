Return-Path: <linux-kernel-owner+w=401wt.eu-S935863AbYEUQwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935863AbYEUQwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYEUQwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:52:33 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1079 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755222AbYEUQwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:52:32 -0400
Message-ID: <4834533D.4030200@imap.cc>
Date: Wed, 21 May 2008 18:52:13 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Soumyadip Das Mahapatra <kernelhacker@visualserver.org>
CC: Akinobu Mita <akinobu.mita@gmail.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] bitreversal program
References: <Pine.LNX.4.64.0805191859411.18461@visualserver.org>  <1211229736.5915.86.camel@brick>  <Pine.LNX.4.64.0805201254240.18899@visualserver.org> <961aa3350805200513i4e02716eh79da76345718c3b2@mail.gmail.com> <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
In-Reply-To: <Pine.LNX.4.64.0805201716160.25111@visualserver.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig268F8677D51B5DC89FC58520"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig268F8677D51B5DC89FC58520
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 20.05.2008 17:25 schrieb Soumyadip Das Mahapatra:
> I know that my bitrev8() takes more instructions than that
> of yours. But we have to think about faster access of cpu cache over th=
at
> of memory cache(which your bit_rev_table uses).

bitrev8() is used on every transferred byte for certain types of
ISDN connections, ie. with a steady rate of 8000 bytes/sec.
Depending on the driver, it will be called for individual data
bytes or possibly a small number of bytes at a time, typically
not more than 64, and typically in interrupt context.

I'd expect the table driven version to perform better in those
circumstances.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig268F8677D51B5DC89FC58520
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFINFNGQ3+did9BuFsRAiAoAJ9fHx7+xlvs+45Ho3yyiocgNC9tYwCfau2l
I0IXQkmP/1dVEtlm/WaYIx0=
=RCgM
-----END PGP SIGNATURE-----

--------------enig268F8677D51B5DC89FC58520--
