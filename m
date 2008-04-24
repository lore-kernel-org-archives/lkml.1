Return-Path: <linux-kernel-owner+w=401wt.eu-S1754580AbYDXDdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbYDXDdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 23:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYDXDdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 23:33:13 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48398 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYDXDdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 23:33:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] linux/atm_tcp.h: cleanup for userspace
Date: Wed, 23 Apr 2008 23:33:10 -0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1208661754-3197-1-git-send-email-vapier@gentoo.org> <200804232303.52427.vapier@gentoo.org> <20080423.201844.167236025.davem@davemloft.net>
In-Reply-To: <20080423.201844.167236025.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7020143.XhxB0PRiZs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804232333.10968.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7020143.XhxB0PRiZs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 23 April 2008, David Miller wrote:
> From: Mike Frysinger <vapier@gentoo.org>
> > On Wednesday 23 April 2008, David Miller wrote:
> > > From: Mike Frysinger <vapier@gentoo.org>
> > > > The atm_tcp.h uses types from linux/atm.h, but does not include it.=
=20
> > > > It should also use the standard __u## types from linux/types.h rath=
er
> > > > than the uint##_t types since the former can be found with the kern=
el
> > > > already.
> > >
> > > I don't think this is a sufficient patch to solve these problems.
> >
> > it is sufficient for atm_tcp.h only.  many of the network headers are
> > broken for userspace inclusion, so i've just been posting them one at a
> > time as last time i posted a large patch, no one picked it up.
>
> But you're adding an include of another file that has the problem
> you're supposedly fixing.

and i'll send out fixes for that file in time.

> If using uintN_t types is the problem, you're adding a new one for
> applications that include linux/atm_tcp.h, because now they'll
> get linux/atm.h as a side effect which does it too.

any applications that use linux/atm_tcp.h are already including linux/atm.h=
,=20
and already including stdint.h (or whatever indirectly to get uintN_t types=
). =20
nothing new is broken, but eventually things will be all fixed.
=2Dmike

--nextPart7020143.XhxB0PRiZs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUASA//dkFjO5/oN/WBAQIbbhAAhrsNKQ+ti0H56V8+zmNxDDoy/K89giYS
rBMzPERLf0v1NY2d/uU//MfasoxPOTmIFnL4pWpBzVR8KwnGuvZXickNre0Ojzox
MWDwv8EqYGNSpE+nYzRCgXcvZmbhlV3PRKkutwvGyVyx/QCaoyC9f67wwTb0mWJd
7902sGiKD1jj6r6EoEknnFeXyc5n0Fz6fygrNtw19r6FNRjxz/1Avh6pfNyB1YyJ
+KwaDENDWpdfUoC0ry+YH5UxUj2s9RD7wiJoDbThRgaSrtseb8MsXC0M0ydVBNPK
YHXJfiMOM5L8eEDE6ESpHs/jW/tvgUnHnYW0cS5IjixA3snXdVBdOkcybekaCFu7
9VtnpxvZb1zfpX9gFiWbfJ+zoY2gz6ZUg+y3WteeYQAaxYW0mMOKWWRmnffuslqO
xGF1S/14YrWMcamwct239568pJTOK6w7FW/i3n5IgCKs7Bme0H5zPv5dhC5RJrHm
rFGTnG0hh8vl7GftEC1oOdZ2mVW+eZDHhYmkgkOUM3UlIV9f92pveLo2BwBh9Ilc
3sA9ywf/qCdO5Zsp+c21FT8EgYrtN/wKQ3qBsvkr9FojKGHWCNyokAPYeGQB5/kC
SVIX2AnQD0zAZleAASWjrBb4Ww63DYq4bqfzwdU2tHK9zpNKQ9x1hIL2ArrDP7Z+
Ckgs4K1+CHE=
=kFNV
-----END PGP SIGNATURE-----

--nextPart7020143.XhxB0PRiZs--
