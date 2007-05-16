Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbXEPCCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbXEPCCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXEPCCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:02:34 -0400
Received: from nabe-new.tequila.jp ([211.14.136.194]:55087 "EHLO
	nabe-new.tequila.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbXEPCCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:02:33 -0400
Message-ID: <464A662C.1090006@tequila.co.jp>
Date: Wed, 16 May 2007 11:02:20 +0900
From: Clemens Schwaighofer <cs@tequila.co.jp>
Organization: TEQUILA\Japan
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Tejun Heo <htejun@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org>
In-Reply-To: <20070515185350.2e77bf21.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D4E9B7DC853DBE3FDD8D690"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D4E9B7DC853DBE3FDD8D690
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/16/2007 10:53 AM, Andrew Morton wrote:
>
>> I think it started with 2.6.19.2, I cannot remember I had any of those=

>> problems before. The box can work fine for about a week or more, or it=

>> looks up several times a day. I run a memtest for 10 h, but I had no e=
rrors.
>=20
> shrink_dcache_memory->...sysfs_d_iput->BUG
>=20
>                 BUG_ON(sd->s_dentry !=3D dentry);
>=20
> a number of people have hit that, on and off.
>=20
> We were close to having a fix, I think, but then we decided that great
> chunks of sysfs needed rewriting and I believe that we believe that thi=
s
> great rewrite will fix this bug.
>=20
> But alas, it's all too late for 2.6.22.

Well, there is always hope for 2.6.23 :)

> How frequently do you see these failures?  If it's repeatable with any =
reliability
> then it'd be great if you could test a patchset for us.  It's at:
>=20
> http://userweb.kernel.org/~akpm/cs.gz
>=20
> that's a single patch against 2.6.21-rc1, containing the following patc=
hes, which=20
> are from the forthcoming 2.6.21-rc1-mm1 lineup:

I get this very frequently recently. I just got hit by another PANIC
which was probably the same issue. I will get this patch and try it out
and see if it helps for me.

--=20
[ Clemens Schwaighofer                      -----=3D=3D=3D=3D=3D:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]


--------------enig7D4E9B7DC853DBE3FDD8D690
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSmYujBz/yQjBxz8RAht3AJ9gA1ugAFJ/EeoWFDTMEY3RcHdL2QCeMIra
QTGCmTB0ihGyri/9vVDJ0q8=
=MQUh
-----END PGP SIGNATURE-----

--------------enig7D4E9B7DC853DBE3FDD8D690--
