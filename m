Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZGXRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZGXRuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZGXRt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 13:49:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42927 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZGXRt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 13:49:59 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: ltp-list@lists.sourceforge.net
Subject: Re: [LTP] Char Limit issue on 2.6.29 kernels
Date: Fri, 24 Jul 2009 13:49:56 -0400
User-Agent: KMail/1.11.4 (Linux/2.6.30; KDE/4.2.4; x86_64; ; )
Cc: naresh kamboju <naresh.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       maxin john <maxinbjohn@gmail.com>, brinda_mn@yahoo.co.in,
       Oleg Nesterov <oleg@redhat.com>, tim.bird@am.sony.com,
       rohit.170309@gmail.com
References: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
In-Reply-To: <f5a7b3810907240831t75a058a2m96abdc28a28c4365@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1585721.GUq8EBI8DJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907241349.58754.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1585721.GUq8EBI8DJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 24 July 2009 11:31:59 naresh kamboju wrote:
> I have come across with char Limit issue on 2.6.29 kernels.
>
>
> SIGFAULT:
>
> #define SIZE            8053759
> char buf1[SIZE] ;
>
> NO SIGFAULT:
>
> #define SIZE            8053758
> char buf1[SIZE] ;
>
> This SIGFAULT not observed on 2.6.23 kernels.

=2DENOINFO

post some actual code rather than saying "i declared a large buffer and thi=
ngs=20
crashed".  is there a reason you cc-ed LTP ?  is this a crash i a LTP test ?

> What could be the changes that effecting from 2.6.23 to 2.6.29 kernels.
> Please share me the information.

git log v2.6.23..v2.6.29
=2Dmike

--nextPart1585721.GUq8EBI8DJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iQIcBAABAgAGBQJKafRGAAoJEEFjO5/oN/WBSf4P/3Vxc4bpI8ZyX28k8KmIBthC
18d1yJETty3qlAcrGpMf9iK2sKY2CHOMOGn0gu0TabTjZhN+e98v7n9rxYN9vard
JHT3iUtrbHVgNUhnwkxdrG58jZM62csDCr3JyB8fTxqKb4uheX7vDRuO4LVjjT5y
nw/kA0tyWklFRTQQyJvBnZgDUsvJNPkxCnJ6NOijHv/Fl1Z2+D1sO1HKRrkzNVn9
T/n+IlYV2wmKROJnci5LGCxKjYBpvhWVUdDJHF1oqNaIp2oRi3r2EUrmNuaEleQY
/icjvTqhghPZ6oCiqHPUpApD5qKO5qVYipRG8TklnCSNcL6l/hEOmNjzkYYtbRQU
vJGTIMkhBf5XxX8GTpT26NuDOjqat1UDRzPvVd9lOJC5mUE3+OxuegefvcRN0qdZ
uZFTLM40XrnmkjECulFz9Yj2eGSJcVif2H50UYpoDguuOmCC6zY1lkknkY+vI2/Y
UKLNBo7Anid+uFIJ5vpxPNVwmnZ3f+Lud6/8C55oWOiyL1NjTC5G/3Tx0aj2+fMh
ZzqOQiLcnnE0JzJfSRIaVLHwCY2P16REG8NuGz2EFdgU+rsMYVLtFHdR5b2Ih5EX
CEHJr35omKfjMajy7tLyGfnZ477CGHyd8VfW4leavHf18XzgJyIGgThxMVPgRIuV
GmZQz9hJB3Z9UKwmiNwh
=Z5Lj
-----END PGP SIGNATURE-----

--nextPart1585721.GUq8EBI8DJ--
