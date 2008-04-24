Return-Path: <linux-kernel-owner+w=401wt.eu-S1753718AbYDXDEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbYDXDEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYDXDDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:03:54 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34122 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbYDXDDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:03:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] linux/atm_tcp.h: cleanup for userspace
Date: Wed, 23 Apr 2008 23:03:51 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1208661754-3197-1-git-send-email-vapier@gentoo.org> <20080423.192418.188020745.davem@davemloft.net>
In-Reply-To: <20080423.192418.188020745.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1308327.FcIj7ikYFY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804232303.52427.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1308327.FcIj7ikYFY
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 23 April 2008, David Miller wrote:
> From: Mike Frysinger <vapier@gentoo.org>
> > The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
> > should also use the standard __u## types from linux/types.h rather than
> > the uint##_t types since the former can be found with the kernel alread=
y.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> I don't think this is a sufficient patch to solve these problems.

it is sufficient for atm_tcp.h only.  many of the network headers are broke=
n=20
for userspace inclusion, so i've just been posting them one at a time as la=
st=20
time i posted a large patch, no one picked it up.
=2Dmike

--nextPart1308327.FcIj7ikYFY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUASA/4mEFjO5/oN/WBAQIJFg/+KYm02pULE/cGRtVOF/J6mxSiKRiTvFyG
g9r7hrX6OKbIYBRL4yxjWoNG5PhXsktBF2Am3jmllU0hgSv6jZeZyG4bg0VtpRVQ
cA82Fa38Yuqw79KQBY07w9tVeWomku5KmLQr2QeNXJb/vYxqFM6eUs0mzr+1lMbd
nLpf6AUxUULifyl8AUw2zIxkaNpkzRIKKj1UcNRXKyRCJXURAu8ch+dYlXvGHpcx
lnYxxdBxyHU5g7c0oBdor+0SjLtxCdRW3yxFm4uHIWYWFNK3UM7Q2znWpoKq+Mqm
WeIoX1fTxR1MaOlbllo3y+l7y7DUiMKxKvz9GIeAj50kJ1fdYW/rMSvYEC6QM+f5
c9g9gGv0g6VVa51ToWdZi1lnssuF7EjESgIHc43M12CgGEyJUjiVq5pHx5JIP6xE
BrsAjq4LFfESGVfKRNA5nXvdHDj5L3TACpksbCXPVKrbiNbqKVearQSLOlvP+fsb
eO3gdfhCuYdx+f90dEAZWrWPf1tfsCsva+yi8XcS+5wdJxjnqv/NUL8g5nuSVAKG
5qtogKOd89WfXbAC/K+PiEjia9yqYPRoY9m3/4JHbbCAH0Ia1wHAxsDfqwakI7LR
aK6yYRpvPMmeEn/gkCvhCDJx8suthJH31Dpn4G+5GjOApBifkzwckSH9Haau/5gB
p93PhB+bzkY=
=DJwq
-----END PGP SIGNATURE-----

--nextPart1308327.FcIj7ikYFY--
