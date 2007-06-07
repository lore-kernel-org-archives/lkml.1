Return-Path: <linux-kernel-owner+w=401wt.eu-S1765260AbXFGPon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765260AbXFGPon (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764569AbXFGPoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:44:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40175 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764416AbXFGPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:44:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [patch/rfc] implement memmem() locally in kallsyms.c
Date: Thu, 7 Jun 2007 11:44:49 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200706070116.32042.vapier@gentoo.org> <9a8748490706070236ob529fedn2ea1d9797e575976@mail.gmail.com>
In-Reply-To: <9a8748490706070236ob529fedn2ea1d9797e575976@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart31105051.pjLX6Bq6xv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706071144.50242.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart31105051.pjLX6Bq6xv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 07 June 2007, Jesper Juhl wrote:
> On 07/06/07, Mike Frysinger <vapier@gentoo.org> wrote:
> > This patch basically copies the gnulib version of memmem() into
> > scripts/kallsyms.c.  While a useful function, it isn't in POSIX so some
> > systems (like Darwin) choose to omit it.  How do others feel ?
>
> Do people actually build Linux kernels on Darwin & *BSD systems? If
> they do then why?

in the embedded world,  yes ... everything is being cross-compiled and=20
deployed on different hardware anyways, so the build env shouldnt matter

> What I'm getting at is; why do we care if it will build there?

that was the [rfc] part of the e-mail ... i got enough complaints from peop=
le=20
OS X people to put together the patch
=2Dmike

--nextPart31105051.pjLX6Bq6xv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARmgn8kFjO5/oN/WBAQIdNQ/6A/aZ3MzPNmPbYBRDQMq4wSAKpcjSSNkO
unBKNT/X0XdXnAIGT546kwe1Od7NM4HARWiVhfOZ0wR8QbWKL3hh9CLYkDyOZCni
V5yOVr+6r03cBsrk6Zn3dBu1SEsdmi7AK82oO63f/Ia3CROanVlvCtPaao26EwTv
jjZfa/CJaxEHegL/opHtYXfM3nJKyk39UBHukcOsCzAzHUB4TjiHee9d1hUK2XFU
LsqjTO86/C2+ZWKe0EcvgWWqtpoYMPFENf8fib29iBtVLBfAF0nR+yArkT8/mPKH
Ts7msGj7xopB1SJR1+1UFQhC9CPiHuMB2UNi9I+s4uttSrkv7Wstlu0uuqekrCT6
4RK8sHJQ5ylkQjFrQdW1XoMnUjh//0zsO88l1lHF6GnZSZEmquII9GmPC2vrDa2p
u/WC2uJK0c/XOrWXPmu6ukkGnjmu6HcANZIiEwAbEkDz7jFzlgxjlGxmbGtBBHg5
xxJu/o9I0NxUUF225oQg8dSGs4ElCUEWFu1QOd6gWEkf547C48N+8MvtBA8gcBzI
GD+nh3I3x1oLSELqXxHtl7dkDUGl7U/x2OpB38U75DBuwpCsec4cZV1kqqgdxHMF
ScZ/f1nuj9yRws8cByZYNueKSLdn393UI80Cfmex8iBJsG7PRk+YdLx7xkvV0wB2
3gWnkjMJn+I=
=tCX1
-----END PGP SIGNATURE-----

--nextPart31105051.pjLX6Bq6xv--
