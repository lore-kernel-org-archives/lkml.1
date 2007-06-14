Return-Path: <linux-kernel-owner+w=401wt.eu-S1751414AbXFNQd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbXFNQd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbXFNQdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:33:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:47555 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751159AbXFNQdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:33:03 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX18b6sp1FhEb1mqYszjo8llZSoiMcCqWOZzA1gp5rw
	XjprLesjtUqjfK
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 18:32:57 +0200
User-Agent: KMail/1.9.5
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706141023.21624.bernd.paysan@gmx.de> <20070614153935.GO21478@ftp.linux.org.uk>
In-Reply-To: <20070614153935.GO21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2633525.vgYnn5R5af";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706141832.58526.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2633525.vgYnn5R5af
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 14 June 2007 17:39, Al Viro wrote:
> On Thu, Jun 14, 2007 at 10:23:20AM +0200, Bernd Paysan wrote:
> > A number of kernel hacker deliberately want their work under GPLv2 only
> > (like Al Viro), and they are fully entitled to do that - but they must
> > announce it in a propper place (not lkml or lwn.org)
>
> A court deposition if somebody tries to do relicensing.  At that point
> I believe that I made myself sufficiently clear, so I really doubt that
> "all files without explicit license get the license defendant would like
> and not the one located in the tree" would fly.  But you are welcome to
> test that, of course - will make for nice punitive damages.

If I test it, it would be in Germany, and I really doubt that relicensing=20
one copyleft to another can ever cause puntative damages here. You are only=
=20
entitled to collect damages here when you have actual losses (that's why=20
Harald Welte never gets a dime except for his defense expenses and=20
voluntary donations to the FSF), but you can demand compliance. That would=
=20
basically mean that the hypothetical linux-something.subversion-bp with=20
GPLv3 parts in it can't be shipped further, because I can't fulfill all my=
=20
obligations.

It's probably completely hypothetical, but if I really liked to be nasty, I=
=20
could release the blackfin sound driver I've written for our digital=20
amplifyer under GPLv3 or later. The code I've modified is explicitely under=
=20
GPLv2 or later.

> Just make=20
> sure to test it yourself - giving somebody else an advice that will land
> them in trouble is not nice...

As a non-lawyer, I can't give anybody legal advice in Germany, and I'd like=
=20
to extend that to the rest of the world. This is my opinion, my=20
interpretation of the GPLv2 and what's my logical reasoning what these=20
three lines on top of /usr/src/linux/COPYING really mean. And there are=20
only two possibilities:

* Either it means what it says, then it's quite likely a copyright=20
infingement done by Linus to all those authors of linux-2.4.0-test8 and=20
before, and you all may need to stop distributing Linux*, since you can't=20
meet your obligations (and restart from linux-2.4.0-test8, which is the=20
last legal version), or

* it does not exactly mean what it says, then you still can distribute=20
Linux, but you can't really stop anyone who's updating it to GPLv3 - except=
=20
for those few files that have explicit version numbers assigned.

BTW: If I grep through Linux, I find two files where you have noted your=20
copyright and the release conditions (GPL v2), and I think last time I did=
=20
the same thing, I found two GPLv2-files, as well - all other files with "Al=
=20
Viro" in it apparently have multiple authors. These two files may be the=20
same ones, or maybe there are two other files, making it four in total (or=
=20
some further I missed, the text of v2 only is not as normed as the text=20
for "v2 or later", but in general it's rare). These files clearly have to=20
be rewritten or premission has to be asked when updating COPYING to GPLv3.=
=20
But that's not a show-stopper.

Example, to test the legal issue:

/usr/src/linux/drivers/net/bmac.c

is Copyright (C) 1998 Randy Gobbel, and was modified by you in 1999, and ha=
s=20
no specific GPL license. That's both before 2.4.0-test9, so without the=20
implied "v2 only" of the "tree root". If I take this file up to GPLv3, what=
=20
can you do against it? Nothing. What can Randy Gobbel do about it? Nothing,=
=20
either. If you claim, it's "v2 only", Randy Gobbel could do something (e.g.=
=20
asking puntative damages from you in the US, or denying you the right to=20
redistribute Linux further, because you don't fulfill your obligations).

*) e.g. Microsoft lawyers will hunt down all pre-2.4.0-test9 copyright=20
holders and pay the one who's willing to stop Linux a billion.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart2633525.vgYnn5R5af
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGcW26i4ILt2cAfDARAruBAKClc9xmvCUNQCDyj1EYcZc1xE2BbACgvc0B
cZoxQpizEhNxTBlPGue7gtU=
=ggOs
-----END PGP SIGNATURE-----

--nextPart2633525.vgYnn5R5af--
