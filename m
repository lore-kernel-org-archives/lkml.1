Return-Path: <linux-kernel-owner+w=401wt.eu-S933830AbZKXSVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830AbZKXSVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:21:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933773AbZKXSVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:21:54 -0500
Received: from mail.klingt.org ([86.59.21.178]:60522 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933680AbZKXSVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:21:53 -0500
Message-ID: <4B0C2445.2000008@klingt.org>
Date: Tue, 24 Nov 2009 19:21:57 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Lightning/1.0pre Shredder/3.0.1pre
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] branch hint tweaks
References: <4B0BBB83.2020604@klingt.org> <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
In-Reply-To: <73c1f2160911240950u7256feedqc475fa915dda43ca@mail.gmail.com>
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90376EF18A6C81F43926C3D9"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Tue, 24 Nov 2009 19:21:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90376EF18A6C81F43926C3D9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

> Did you run profiling tests again after making these changes to see if
> they had any effect?  likely() and unlikely() are only hints.  GCC
> doesn't have to follow them, or it could be broken in recent GCC
> versions.

i know, the compiler doesn't have to follow the hint ... but with the
likely/unlikely profiling, not the execution time is profiled, but
whether the branch hint is pointing to the right direction on my machine
=2E.. if the assembly is actually affected does probably depend on the
compiler version, instruction set, cpu tuning ...

tim

--=20
tim@klingt.org
http://tim.klingt.org

The aim of education is the knowledge, not of facts, but of values
  William S. Burroughs


--------------enig90376EF18A6C81F43926C3D9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksMJEUACgkQdL+4qsZfVsu0lgCdFIt7HZA/0jit0d5b0LBtYdsY
eNMAn3tN28GRyZZrR+uci4a7LQFCGiSh
=zSc2
-----END PGP SIGNATURE-----

--------------enig90376EF18A6C81F43926C3D9--
