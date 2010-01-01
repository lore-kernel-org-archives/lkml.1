Return-Path: <linux-kernel-owner+w=401wt.eu-S1751516Ab0AAU4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab0AAU4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 15:56:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162Ab0AAU4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 15:56:43 -0500
Received: from mail.klingt.org ([86.59.21.178]:37981 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab0AAU4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 15:56:42 -0500
Message-ID: <4B3E6155.5080005@klingt.org>
Date: Fri, 01 Jan 2010 21:55:49 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091228 Shredder/3.0.1pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, x86@kernel.org
Subject: Re: 2.6.32 regression: unable to handle kernel paging request
References: <4B269765.1070703@klingt.org> <4B2A2A7D.1050506@klingt.org> <4B2A93F2.3070407@klingt.org> <4B2AFBB1.3040609@kernel.org> <4B2B4838.6080509@klingt.org> <4B2F20E0.30804@kernel.org> <4B2F40C0.5020407@klingt.org> <4B33592B.6000107@kernel.org> <4B335964.6040202@klingt.org> <4B335DE6.9030102@kernel.org> <4B336303.2090403@kernel.org> <4B372E02.9050509@klingt.org>
In-Reply-To: <4B372E02.9050509@klingt.org>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BE94553BAAAC8EE7530DCCF"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Fri, 01 Jan 2010 21:55:53 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BE94553BAAAC8EE7530DCCF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/27/2009 10:50 AM, Tim Blechmann wrote:
>> I just tried 2.20 on openSUSE.
>>
>>  $ ld --version
>>  GNU ld (GNU Binutils; devel:gcc / openSUSE_11.2) 2.20.0.20091104-13.2=

>>  Copyright 2009 Free Software Foundation, Inc.
>>  This program is free software; you may redistribute it under the term=
s of
>>  the GNU General Public License version 3 or (at your option) a later =
version.
>>  This program has absolutely no warranty.
>>
>> and it doesn't show such behavior.  Can you please report this to
>> ubuntu and let me know the bug#?
>=20
> ah, back at that workstation, i found, that i was using a build of
> binutils, installed via the ubuntu-toolchain-r ppa:
>=20
> ld -v
> GNU gold (GNU Binutils for Ubuntu 2.20) 1.9

trying to boot the current linus/master branch, i saw a similar issue as
before, but with binutils 2.20

tim

--=20
tim@klingt.org
http://tim.klingt.org

Our products just aren't engineered for security.
  Brian Valentine, Microsoft's vice president of Windows development


--------------enig5BE94553BAAAC8EE7530DCCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks+YVcACgkQg0On+TFEWzw6YACghRzqtPH8k7oukfdRljLZx0kB
ROsAnR9umYF16eBETTlj/WSJ5/RR/liM
=10qs
-----END PGP SIGNATURE-----

--------------enig5BE94553BAAAC8EE7530DCCF--
