Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbYJ1H3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbYJ1H3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752299AbYJ1H33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:29:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:50792 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJ1H32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:29:28 -0400
Subject: Re: [PATCH] wireless: fix regression caused by regulatory config
	option
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@suse.cz>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, rodriguez@atheros.com
In-Reply-To: <20081027204249.GA1620@ucw.cz>
References: <20081026103024.2712ddc9@infradead.org>
	 <20081026200939.GC12648@tuxdriver.com>
	 <20081026131818.7517c103@infradead.org>
	 <1225052537.3746.5.camel@johannes.berg>  <20081027204249.GA1620@ucw.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-htKgMXw7WhGNXENI90Xk"
Date: Tue, 28 Oct 2008 08:29:15 +0100
Message-Id: <1225178955.3796.60.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-htKgMXw7WhGNXENI90Xk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 21:42 +0100, Pavel Machek wrote:

> > > it's not always nice, especially if you're trying to get rid of some
> > > nasty stuff, but think of it this way: you should be able to use a
> > > new kernel on an existing distro, at least for a reasonable type of
> > > distro (eg something shipped in, say, the last 2 years). In this case=
:
> > > even Fedora 10 is not likely to work!
> >=20
> > Well, actually, it _ought_ to work fine, with a smaller set of channels=
,
>=20
> Really? It will still break if your AP uses one of those channels, right?

Well yes, but the driver itself shouldn't simply fail as it did in
Arjan's case, it should just not find the AP rather than saying "sorry,
found error and can't continue" or something like that.

johannes

--=-htKgMXw7WhGNXENI90Xk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBr9IAAoJEKVg1VMiehFYakoP/0y7pjK40J6PJR9E189K05g4
w0eGMSsEgJoT5uzmV9nKmOTuGkw5fEGbkmuJLDPesWMr+As+CGIJsMiUJlMxOYL5
LiIL0PATw+Rdy6hYBv4RBCaPWmKSG+XjI4Jir4yROAzln5ON1pgCKaU+a3St7SNH
ZWKSkyuOIydo481v2KBNDbTiPTGpeUlnjPSPlIHAtk/crCn5XP+nsk7HIvr3gzVc
bcT9g5jTNZDaC2R1DMWVKf5Bja/gNhiSEkRytitCm5CcTJCEjBRoris7GyNW4cRT
UGtQXaD8FwJVxoIoiPvmXCyF+/kozwRq9Y+8LM0Q6YDkvjG/LO3vWVRS8f+rTH+J
zaIGd0x+Nc/IBLJC+akpr0SqEi95OXpQjMO728DjqYIEu+Pc9Fh01MuPI0EQSj8/
6JAqMJLIMvpGHI3GBuO8QOPRscZpsIWhtVNeCBPDhvd22R6U/O0sfMWATeNp7CVe
zrGrVN95FJz+6aKvou6DfQ8Q3fmIIJYzPA8iemcoUiUqXxpw6RKqq+bWKTzFiDyW
ezOZtTZ2eQTEJeciZ/qVRiC8hkFke4FStZiIx/u1fOk96RvmWKRkhmycU3fo8t/C
DGwIEoQp6hf3FoG83Hg6885RTLPy4lptTmAEOA74jZfho790RykMN4sSzCrhEEMk
HPiTId4CCPneV+b9vyYz
=IrC1
-----END PGP SIGNATURE-----

--=-htKgMXw7WhGNXENI90Xk--

