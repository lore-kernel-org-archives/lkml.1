Return-Path: <linux-kernel-owner+w=401wt.eu-S1755656AbXFTQ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbXFTQ5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXFTQ5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:57:06 -0400
Received: from dovecot.org ([82.118.211.50]:56870 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbXFTQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:57:05 -0400
Subject: Re: SMP read() stopping at memory page boundaries
From: Timo Sirainen <tss@iki.fi>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com>
References: <1182351171.3768.65.camel@hurina>
	 <1182354493.3768.80.camel@hurina>
	 <2c0942db0706200922i15ce44b0xceaed95d002dba33@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6LSMhvEeIg5h7kAnoZj8"
Date: Wed, 20 Jun 2007 19:57:02 +0300
Message-Id: <1182358622.3768.98.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6LSMhvEeIg5h7kAnoZj8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-20 at 09:22 -0700, Ray Lee wrote:
> On 6/20/07, Timo Sirainen <tss@iki.fi> wrote:
> > On Wed, 2007-06-20 at 17:52 +0300, Timo Sirainen wrote:
> > > Sometimes read() returns only 4096 bytes. I'm locking the file, so I
> > > don't think this should ever happen, right?
>=20
> man 2 read
>=20
> read() is always allowed to return less than you asked for. You need
> to go back and ask for the rest. That's why people wrap read() and
> write() in loops, and use those wrapped versions instead.

I thought this wouldn't happen when reading from local filesystems.
Anyway, my real program was doing that, and it was still seeing partial
data. But looks like I can't reproduce it in my test program with two
pread()s, so I'll have to do some more debugging.


--=-6LSMhvEeIg5h7kAnoZj8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGeVxeyUhSUUBViskRAvX/AKCk+fxVbGmqSuQPDLhyTfXQsRPvnQCdGe6Q
DTlGA3ZOdz77PilfDDc21AY=
=1Y2r
-----END PGP SIGNATURE-----

--=-6LSMhvEeIg5h7kAnoZj8--

