Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYEZVQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYEZVQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYEZVQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:16:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:36571 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753867AbYEZVQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:16:49 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX18HAEYl6joHkIq59jmEABk6FhLF69t/hWlCKSajn0
	dGBcxXgFxK2HdY
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
From: Mirco Tischler <mt-ml@gmx.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1211752151.16921.25.camel@mtlp.tischlernetz>
References: <1211735607.14556.14.camel@mtlp.tischlernetz>
	 <20080525181118.GG1791@cs181133002.pp.htv.fi>
	 <1211742202.14556.25.camel@mtlp.tischlernetz>
	 <20080525201807.GK1791@cs181133002.pp.htv.fi>
	 <1211749036.16921.16.camel@mtlp.tischlernetz>
	 <20080525210329.GN1791@cs181133002.pp.htv.fi>
	 <1211752151.16921.25.camel@mtlp.tischlernetz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JrYWYyjHeVO6DF7H2V4E"
Date: Mon, 26 May 2008 23:16:46 +0200
Message-Id: <1211836606.10718.18.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JrYWYyjHeVO6DF7H2V4E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ok. Situation has changed. I discovered I'm still more dumb than I
thought I am;). There was that link /usr/local/bin/gcc to the gcc-4.4pre
executable that I didn't thought of. the ver_linux script didn't check
that too. So the error only occurs with gcc-4.4. But my version is some
weeks old so I'm currently compiling a fresh svn version to check if the
error still exists.

I also found the config option that causes the error: enabling
OPTIMIZE_FOR_SIZE and thus setting -Os instead of -O2 makes the error go
away, so this is pretty much a compiler problem.
I will check now if the error is still existent in the current developer
version of gcc and then maybe contact the gcc team.

Meanwhile I'm really sorry for the noise and annoyance.

Thanks
Mirco

--=-JrYWYyjHeVO6DF7H2V4E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIOyi+z+diZ7c2xfgRAlnWAJ40BDhmwQGQ3kaQ5VSgGdZ/mOup+wCeIwX2
V8NjnKx2XKgqY3Am6CIVZr0=
=hyNg
-----END PGP SIGNATURE-----

--=-JrYWYyjHeVO6DF7H2V4E--

