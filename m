Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbYEYU5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbYEYU5k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYEYU5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:57:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:39749 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750777AbYEYU5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:57:31 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18EeQM92A0EkVXK1Geb4nS8Ma9SL7gBMVLggznPoC
	1utqZShRsHfI2D
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
From: Mirco Tischler <mt-ml@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20080525201807.GK1791@cs181133002.pp.htv.fi>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
	 <20080525181118.GG1791@cs181133002.pp.htv.fi>
	 <1211742202.14556.25.camel@mtlp.tischlernetz>
	 <20080525201807.GK1791@cs181133002.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6QffdzJHXfrCsRgOduNq"
Date: Sun, 25 May 2008 22:57:16 +0200
Message-Id: <1211749036.16921.16.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6QffdzJHXfrCsRgOduNq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On So, 2008-05-25 at 23:18 +0300, Adrian Bunk wrote:
> > Gnu C                  4.3.0-4ubuntu1)
> >...
>=20
> I'd have said your gcc has a bug regarding __builtin_constant_p(),
> but I can't reproduce it on i386 with the compiler you are using.

> You are using exactly this compiler for compiling your kernel?
I tried several versions now (4.1, 4.3. 4.4pre) and all showed the
error. I'm using ccache, maybe this has something to do with it? (Though
I doubt it)
Btw: you noticed that this is x86_64 and not i386?
>=20
> If yes I'm unfortunately out of ideas...  :-(
I have another config that builds properly. Actually I just changed some
options to the config posted before. If nobody shouts "trivial" I could
try to filter out the guilty option if there is any. But I possibly
won't find the time before mid of the week.
> cu
> Adrian
>=20
Thanks
Mirco

--=-6QffdzJHXfrCsRgOduNq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIOdKsz+diZ7c2xfgRAgGmAJ4oFUc1tPVjax1SH52h9ZdmiON7QgCdG6WU
fp+Ecu8idm/xP4SqLu+C+8A=
=b5pX
-----END PGP SIGNATURE-----

--=-6QffdzJHXfrCsRgOduNq--

