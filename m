Return-Path: <linux-kernel-owner+w=401wt.eu-S1760228AbXFSRnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760228AbXFSRnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757708AbXFSRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:43:26 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50674 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbXFSRnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:43:25 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH] remove usage of memmem from scripts/kallsyms.c
Date: Tue, 19 Jun 2007 13:43:48 -0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>
References: <4678013C.5090402@grupopie.com>
In-Reply-To: <4678013C.5090402@grupopie.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1357430.r79QYMPvKu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706191343.49025.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1357430.r79QYMPvKu
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 19 June 2007, Paulo Marques wrote:
> The only in-kernel user of "memmem" is scripts/kallsyms.c and it only
> uses it to find tokens that are 2 bytes in size. It is trivial to
> replace it with a simple function that finds 2-byte tokens.
>
> This should help users from systems that don't have the memmem GNU
> extension available.
>
> Signed-off-by: Paulo Marques <pmarques@grupopie.com>

sorry for not getting back to you in the previous thread ... this is a much=
=20
nicer patch than what i proposed and works for me :)

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart1357430.r79QYMPvKu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARngV1EFjO5/oN/WBAQJXyw/8CfnG8tnmC7BSIXJBWKGHiBoS5kiXsGtY
0r71eSYv9UgNHXSJQLpWKmGTNciS/9jxoIhDhuUWaI0PmgUYYt7a6x9Ly6A9u32l
+3qljBcpEA4Ccehh5IsUYd3bjkBzGYKV2t9SisNvfSiGp/zos4qqbk52VvptUIFn
GNviTnyiyH8jASlB04Sh6C7ftU+CqDtRYYWnhikMcwU/jQYtI/0xgdhDYc4+LImk
jjo1TXvzO2JpceWLqG2M6MtBR3bkD3D/qPhlq5b939H54EUBpuVVrFZmAE90v0Rp
w6W6wB7bTkHG5fHOFIX7kPCQ2bXxYkzXQ0YolIYcyC75rTESWcJqaO7WbjhRn3Pi
bqWnFqBaZrVVIXtYGEst9jnsNZ3iNOlyiAl98Kq/aSC/nXtaG/ifjk9gRv/bCC8e
Bv5ZSz7ZDkOySPpvbDzrAd7ENm0wLY8mqKYYQzOCgy1KBn6oXE1JdJbHiC9PqbHw
x+AerQ2AmsrN7GiqKkR00w3izuu7NzCsMDH3jBnC4aOYoQglbhKXSsr+gfJHytIs
8sKibcbnnVU4YksG+/AfT/leBAEQI/P+iDTrfOQjvApebNnVgrW9QHfFtQ9VZIZP
B0m1dP6CGwiIsMn9As9/Tdkl9Gh5bTTINA66b7VR+dLtsTN8LBqrTnTYNi7MbeW1
sv8dSjg1g3M=
=dbXI
-----END PGP SIGNATURE-----

--nextPart1357430.r79QYMPvKu--
