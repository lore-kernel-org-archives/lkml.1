Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYEKReV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYEKReV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbYEKReK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:34:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:32972 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbYEKReI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:34:08 -0400
Date: Sun, 11 May 2008 18:33:57 +0100
From: Ricardo Martins <ricardo@scarybox.net>
To: kernel-janitors@vger.kernel.org
Cc: julia@diku.dk, perex@perex.cz, linux-kernel@vger.kernel.org
Subject: [ricardo@scarybox.net: Re: [PATCH 1/4] sound/isa: use unsigned for
	loop index]
Message-ID: <20080511173357.GA5422@macbookpro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
X-PGP-Key-URL: http://scarybox.net/zomg/ricardo.asc
X-OS: Linux 2.6.24-ARCH x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Sorry, I forgot to CC the list.

----- Forwarded message from Ricardo Martins <ricardo@scarybox.net> -----

Date: Sun, 11 May 2008 18:16:52 +0100
=46rom: Ricardo Martins <ricardo@scarybox.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/4] sound/isa: use unsigned for loop index
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, 11 May 2008 21:22, Alexey Dobriyan wrote:
> On Sun, May 11, 2008 at 05:08:32PM +0100, Ricardo Martins wrote:
> > On Sun, 11 May 2008 20:43, Alexey Dobriyan wrote:
> > > On Sun, May 11, 2008 at 02:50:33PM +0200, Julia Lawall wrote:
> > > > A few more cases in the spirit of the patch "Trivial: Replacement o=
f always
> > > > >0 ints with unsigned ints" submitted by Ricardo Martins <ricardo@s=
carybox.net>
> > >=20
> > > And rationale for those would be ...?
> >=20
> > Acccording to the kernel-janitors TODO [1], Jeff Garzik suggested the f=
ollowing:
> >=20
> >   2) "unsigned int" is preferred to "int", it generates better asm code
> >   on all platforms except sh5. This replacement needs to be done manual=
ly,
> >   because often 'int' is required due to negative values -Exxx commonly
> >   passed as error values.
> >=20
> > Since (most) loop counters such as "int i" are always either zero or a =
positive
> > number, they are perfect candidates for using unsigned int instead, imh=
o.
> > It goes without saying, that each case must be considered separately in
> > case a negative value is indeed needed.
> >=20
> > [1] http://kernelnewbies.org/KernelJanitors/Todo
>=20
> So you've checked disassembly in both cases and saw it's better?

The generated assembly code in a very simple test case (two 'for' loops,
one using an int and another using an unsigned int as the counter
variable) is exactly the same in both cases.

However, since this was a very very simple test case, I supposed that Jeff
Garzik's claim would hold true in more complex cases.

Comparing the output of "objdump -M intel -d drivers/video/nvidia/nvidia.o"
before and after my patch, I reach the same conclusion: at least in my
arch (x86_64), both versions are approximately the same. If anyone is
interested, I can email or upload those dumps somewhere.

Now I feel like a fool. That teaches me to always doubt each and every claim
I am exposed to.

Regards,
--=20
 Ricardo Martins  *  scarybox.net  *  GPG key: 0x1308F1B4

----- End forwarded message -----

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkgnLgUACgkQkH81LRMI8bRh8gCdGG1mUCTMEFZk2SZkrCwMXfTV
xbQAni1Ix3NREcFlTGiXUhT0tCrSJngZ
=sjCg
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
