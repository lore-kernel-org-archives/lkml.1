Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZAAHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZAAHl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 02:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZAAHlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 02:41:19 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39441 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773AbZAAHlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 02:41:18 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: add support for the Maple mouse on the SEGA Dreamcast
Date: Thu, 1 Jan 2009 02:41:14 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>
References: <1230578246.6496.25.camel@localhost.localdomain> <200812300017.45336.dmitry.torokhov@gmail.com> <1230668825.6489.1.camel@localhost.localdomain>
In-Reply-To: <1230668825.6489.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart32419704.AYxseJ8L90";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901010241.16185.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart32419704.AYxseJ8L90
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 30 December 2008 15:27:05 Adrian McMenamin wrote:
> Adding maple mouse with proper __devexit_p() handling

this kind of patch revision info typically goes below the --- marker and  t=
he=20
patch itself gets "v2", "v3", etc... header markers

otherwise, driver looks OK to me.  thanks for your dreamcast work.
Acked-by: Mike Frysinger <vapier@gentoo.org>

> +	mse =3D kzalloc(sizeof(struct dc_mouse), GFP_KERNEL);

personally i find this style less likely to rot:
mse =3D kzalloc(sizeof(*mse), GFP_KERNEL);
=2Dmike

--nextPart32419704.AYxseJ8L90
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXHOcAAoJEEFjO5/oN/WBlqwQAMKseiErdo+hELWlxq9bXqSt
Xu6D18iVDLTsph930I1U2hKZbKi/DWZXcc602kg7CNOzfqtlRepXpn5WWDP0GWoN
fCb3IRjSJ4YcgJjJkvEhpytvd43K1n6GOmZtNXzPU4wF0U/6/33bYJiRaWdjVSEQ
SFw20Zb8mdcuhMTRohJ7CkW34LB7Wq2tnccKw1u1t03F0tT4qRJaFoq1hxCTJjFf
g2+AJYx8QtdfC0H+qBM6RHavs/SDOFvDQpom8nCyNaBeP69WD3oGag+oW/FUKBAy
N9wn6J2V/9Cjpxjme14bEVUG+lbaN8y4qvcrbPq1bDR64FrpfMOGuTo2hTwT8Vkk
fSltj4BdbhxmzYAqv9xIkF/u6VmbULlyUTPxHqNBUVO05+9u2WDqtIwlEi9kz86J
mr7CMVyMbmbNq8mTYErqfOckob8DG01nkIbqdF9jm+xmH9dDl+OdyC8dhbx6OoGX
PKPF1l8eIhgKuLewKxqukKnLr4NPS9Icg/4E0WQvdfpWiMA3qqpbD++1/RFet2Qh
vkkwGJyTh3ozdO2k5GPQn560r0KXRLNsW/qsgkzUlfqhz2m771FgAY/BUHouP8BZ
/o3X/llKDHZzIp2ifibQ04V5tCAUBHFxZntr8ctU/0cAi86bpU7Y7nE1j8zfCQ+p
ErHfH5XfHIBmWkCifiey
=o85d
-----END PGP SIGNATURE-----

--nextPart32419704.AYxseJ8L90--
