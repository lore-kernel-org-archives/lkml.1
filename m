Return-Path: <linux-kernel-owner+w=401wt.eu-S1764425AbXGZOJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764425AbXGZOJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 10:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759246AbXGZOJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 10:09:44 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:60939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbXGZOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 10:09:44 -0400
Subject: Re: [RFC] fix slub krealloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707251153050.8731@schroedinger.engr.sgi.com>
References: <1184773331.4002.4.camel@johannes.berg>
	 <20070723133206.2220db7e@schroedinger.engr.sgi.com>
	 <20070723134713.2b1218bd.akpm@linux-foundation.org>
	 <20070723143724.1d0b26eb@schroedinger.engr.sgi.com>
	 <1185352857.4006.4.camel@johannes.berg>
	 <Pine.LNX.4.64.0707251153050.8731@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bGNXPE664PZ9XHZbKgzT"
Date: Thu, 26 Jul 2007 16:08:46 +0200
Message-Id: <1185458926.4006.12.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bGNXPE664PZ9XHZbKgzT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-25 at 11:53 -0700, Christoph Lameter wrote:

> It will give you a ZERO_SIZE_PTR
>=20
> void *krealloc(const void *p, size_t new_size, gfp_t flags)
> {
>         void *ret;
>         size_t ks;
>=20
>         if (unlikely(!new_size)) {
>                 kfree(p);
>                 return ZERO_SIZE_PTR;
>         }

Oh, I thought looked and it returned NULL. Did it change or did I just
look wrong? :)

johannes

--=-bGNXPE664PZ9XHZbKgzT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGqKrt/ETPhpq3jKURAn6uAKCGV23tYhuNukNm1ecz/xYqMeAcbQCgnBGh
pzLNa90QQITHoTRFBl0FZVU=
=XjQa
-----END PGP SIGNATURE-----

--=-bGNXPE664PZ9XHZbKgzT--

