Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbXHBBlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbXHBBlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 21:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbXHBBlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 21:41:06 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32797 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752065AbXHBBlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 21:41:05 -0400
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
From: Zan Lynx <zlynx@acm.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <29495f1d0708010852p7a53a0a8ra5e8155a3bf12965@mail.gmail.com>
References: <1185918261.6981.13.camel@localhost>
	 <20070731150245.5932b763.randy.dunlap@oracle.com>
	 <1185919297.6981.16.camel@localhost>
	 <29495f1d0708010852p7a53a0a8ra5e8155a3bf12965@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6VNyqK3M1YhSa+YoxmVo"
Date: Wed, 01 Aug 2007 19:40:59 -0600
Message-Id: <1186018859.92039.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6VNyqK3M1YhSa+YoxmVo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-01 at 08:52 -0700, Nish Aravamudan wrote:
> On 7/31/07, Zan Lynx <zlynx@acm.org> wrote:
> > On Tue, 2007-07-31 at 15:02 -0700, Randy Dunlap wrote:
> > > On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:
> > >
> > > > I was playing with huge pages and libhugetlbfs.  Small programs lik=
e
> > > > "ls" work fine.  I tried running Evolution through libhugetlbfs and=
 the
> > > > system slowly stops running.  One interesting thing is the "ps" com=
mand,
> > > > it gets stuck like this:
> > >
> > > Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?
> >
> > D'oh!  I mean 2.6.23-rc1-mm1, the 22 was a typo.  Cut & paste to be
> > sure:
> > Linux zephyr 2.6.23-rc1-mm1 #1 SMP PREEMPT Wed Jul 25 17:33:04 MDT 2007
> > x86_64 AMD Athlon(tm) 64 Processor 3400+ AuthenticAMD GNU/Linux
>=20
> Just to confirm, still happens with -mm2?

No, it does not seem to.  Evolution runs OK.  ps, top, pmap all work
fine.

However, a couple of other things happened.  Could be unrelated or only
loosely related.

Evolution launches spamd (spamassassin) to filter junk mail.  spamd died
and I have this in dmesg to show for it:

VM: killing process spamd

spamd would have inherited the libhugetlbfs.so environment variables.
There are no other clues as to why it died though.

Also, immediately after launching evolution with libhugetlbfs, I got
that USB bug where the mouse starts creating keyboard input.  I got some
of these in dmesg:
keyboard.c: can't emulate rawmode for keycode 240

That could be pure coincidence, although I had been using the system
almost all day before that, and it hadn't happened. =20
--=20
Zan Lynx <zlynx@acm.org>

--=-6VNyqK3M1YhSa+YoxmVo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQBGsTYrG8fHaOLTWwgRAryIAJ0awI9S644549oHbZOUwB8XNCWxWgCeKCmT
yMTO/DpPvS+wskRWNnGO3OU=
=1280
-----END PGP SIGNATURE-----

--=-6VNyqK3M1YhSa+YoxmVo--

