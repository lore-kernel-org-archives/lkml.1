Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbXEPCqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbXEPCqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752625AbXEPCqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 22:46:06 -0400
Received: from nabe-new.tequila.jp ([211.14.136.194]:36569 "EHLO
	nabe-new.tequila.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbXEPCqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 22:46:05 -0400
Message-ID: <464A7068.3080107@tequila.co.jp>
Date: Wed, 16 May 2007 11:46:00 +0900
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
 boundary="------------enigCC94B8206F9B1D4871AD3403"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCC94B8206F9B1D4871AD3403
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 05/16/2007 10:53 AM, Andrew Morton wrote:

> How frequently do you see these failures?  If it's repeatable with any =
reliability
> then it'd be great if you could test a patchset for us.  It's at:
>=20
> http://userweb.kernel.org/~akpm/cs.gz
>=20
> that's a single patch against 2.6.21-rc1, containing the following patc=
hes, which=20
> are from the forthcoming 2.6.21-rc1-mm1 lineup:

(and those above are 2.6.22-rc1 of course)

well, I tried to apply those patches and when I compile I get this error:=


  CC      net/ipv6/exthdrs.o
net/ipv6/exthdrs.c: In function =E2=80=98ipv6_rthdr_rcv=E2=80=99:
net/ipv6/exthdrs.c:390: error: =E2=80=98struct sk_buff=E2=80=99 has no me=
mber named =E2=80=98h=E2=80=99
net/ipv6/exthdrs.c:391: error: =E2=80=98struct sk_buff=E2=80=99 has no me=
mber named =E2=80=98h=E2=80=99
net/ipv6/exthdrs.c:391: error: =E2=80=98struct sk_buff=E2=80=99 has no me=
mber named =E2=80=98h=E2=80=99
net/ipv6/exthdrs.c:398: error: =E2=80=98struct sk_buff=E2=80=99 has no me=
mber named =E2=80=98h=E2=80=99
make[2]: *** [net/ipv6/exthdrs.o] Error 1
make[1]: *** [net/ipv6] Error 2
make: *** [net] Error 2

It's probably totally unrelated but sadly a showstopper for testing the
new sysfs patches,

--=20
[ Clemens Schwaighofer                      -----=3D=3D=3D=3D=3D:::::~ ]
[ TEQUILA\ Japan IT Group                                    ]
[                6-17-2 Ginza Chuo-ku, Tokyo 104-8167, JAPAN ]
[ Tel: +81-(0)3-3545-7703            Fax: +81-(0)3-3545-7343 ]
[ http://www.tequila.co.jp                                   ]


--------------enigCC94B8206F9B1D4871AD3403
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSnBqjBz/yQjBxz8RAviCAJ9HEl6J8GMvXkZag5660Ha1DolIxACfYxx7
tT0jxTdJlwPUzG3+aV2k5Ss=
=X8LF
-----END PGP SIGNATURE-----

--------------enigCC94B8206F9B1D4871AD3403--
