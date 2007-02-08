Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXBHPRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXBHPRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXBHPRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:17:46 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:41848 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXBHPRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:17:45 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] export ufs_fs.h to userspace
Date: Thu, 8 Feb 2007 10:10:50 -0500
User-Agent: KMail/1.9.6
Cc: dushistov@mail.ru, linux-kernel@vger.kernel.org, sparc@gentoo.org
References: <200702080246.16996.vapier@gentoo.org> <1170930819.8675.36.camel@laptopd505.fenrus.org>
In-Reply-To: <1170930819.8675.36.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1423144.qSmadXuGKP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702081010.51790.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1423144.qSmadXuGKP
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 08 February 2007, Arjan van de Ven wrote:
> On Thu, 2007-02-08 at 02:46 -0500, Mike Frysinger wrote:
> > was ufs_fs.h purposefully not exported to userspace or did it just slip
> > through the cracks ?  assuming the latter scenario, the attached patch
> > touches up the relationship between ufs_fs.h and its sub headers (like
> > ufs_fs_sb.h) so that we can export it ... the silo bootloader takes
> > advantage of this header for example
>
> are you sure it actually uses anything from this header, and not just
> assumes the magic number to be there??
> (also.. I kind of would think it reasonable for things with their own
> UFS fs reader to have their own header)

silo utilizes the structures and the random defines so that it can query UF=
S=20
filesystems directly
=2Dmike

--nextPart1423144.qSmadXuGKP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iQIVAwUARcs9e0FjO5/oN/WBAQL2zRAA1irelO3fuSRV0GuWkQ3cadSTLrcInMDv
oQSUoYaWmjm/M7bcwP7rWgpXXwzqGwL3JL8Y4qqcv4fGaseo7ag2BKDnFjEYQlSD
53aHc8iL5U5dAsVBqWuHvWb7z+oN1CQ5in6sy0ErD91tLFz8TaRScCWBBTg7igdd
aHOzNrX0YEH7GWUA+M9RMqlc9XW7nKTi5ue/LhBhB6tKm8Xwp2M5cIGC95OK4YK0
2nP9jFJLzYgkoVQJNiDL1Uv80JZIIneBKal6EObarb2BCIWcv1z5Vpym246tUyFa
VsquAJ2fVxXqqhiO7riWVEVwWrPRIyxXHL0qy+tpAG7qDKGIZeqtg0ozdu9iRU6l
sRQkw2Ge7f9XWjDhC0ppd65kixy5dxE9b4Jw9K4OB/9QGzlslRZNgu020vHRKp0g
x5XhhgulTpnPs7l5y5XRO+eYRWm42GtdmZ0j3Fq1lA+ctuik4zKTCyHSJbZbReJT
IRS64wCdtru0qWhm22Myv96Cxj4Or//+4YGzJZqoZW09fF71HLE0oYfYA2c88Hc+
48xk+ZzBNF3z1JAwW+5a9rcYCi93m2aZNNi4hylpdP7QJsmDHFIEQtJGd256sQVv
ZgTIkPdPpz6RuuVwxMnNSmFHxoMrSghMsU9u2PTZvuup7V8RF7oIR7h6OiPDcFc2
u27LcJdOFHk=
=aLSx
-----END PGP SIGNATURE-----

--nextPart1423144.qSmadXuGKP--
