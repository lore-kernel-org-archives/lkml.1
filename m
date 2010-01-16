Return-Path: <linux-kernel-owner+w=401wt.eu-S1752459Ab0APVRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab0APVRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 16:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351Ab0APVRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 16:17:08 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:32248 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752300Ab0APVRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 16:17:07 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20100116205342.GA5725@lenovo>
References: <20100116170338.GA17175@elte.hu>
	 <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
	 <20100116205342.GA5725@lenovo>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7eYI+5YA3V/gt3LAqat4"
Date: Sat, 16 Jan 2010 21:16:56 +0000
Message-ID: <1263676617.14137.679.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [GIT PULL] x86 fixes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=8ziy0oyqnkb-PaDWx-0A:9 a=qDr7NdOQ5pABuPcq5GAYlO5p6sQA:4 a=_bSm0qT3ojXZ2BuNWS8A:9 a=Vo2M_VN8Rbru4kfxd0AQUr6BE0gA:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7eYI+5YA3V/gt3LAqat4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-16 at 23:53 +0300, Cyrill Gorcunov wrote:=20
> On Sat, Jan 16, 2010 at 12:34:42PM -0800, Linus Torvalds wrote:
> >=20
> >=20
> > On Sat, 16 Jan 2010, Ingo Molnar wrote:
> > >=20
> > > Cyrill Gorcunov (1):
> > >       x86: kernel_thread() -- initialize SS to a known state
> >=20
> > This looks bogus. Why does it do it only on x86-64?
> >=20
> > Either people care about SS or they don't (the answer, I suspect, is "t=
hey=20
> > don't"). But if they care, we should do it on both 32-bit _and_ 64-bit,=
=20
> > no?
> >=20
> > 		Linus
>=20
> Linus, this is Xen specific. There was a Xen related series sent by Ian,
> and seems we still need this patch together with get_kernel_rpl() (as I u=
nderstand,
> I'm not familiar with Xen code, that was a suspicious about SS as it's sa=
id
> in commit message). So Ian mentioned
>=20
> |
> | > Yeah, I didn't found any explicit %ss reloading for this _particular_
> | > case (as I marked in patch changelog). So the only suspicious is Xen
> | > itself. So as only Christian get ability to test -- we will see the
> | > results.
> |
> | The difference with Xen is that it must squash the RPL of SS (to 3 for
> | 64 bit and 1 for 32 bit, 32 bit doesn't matter here though). Perhaps a
> | NULL selector can only have RPL=3D=3D0? (I'm away from my architecture =
docs
> | so I can't check). In any case specifying a non-NULL SS selector allows
> | the squashing to occur correctly.
> |
>=20
> In turn reported said that only _this_ patch alone doesn't help him and
> Ian replied we need both patches.
>=20
> Ian CC'ed if details needed.

Thanks, I think you've covered or quoted everything.

Although I think Linus' basic point is still valid -- why isn't a valid
SS needed for 32 bit? The selectors have real meaning there even for
native, don't they?

(I'm travelling all tomorrow and unlikely to be getting mail).

Ian.


--=20
Ian Campbell

It is always the best policy to tell the truth, unless, of course,
you are an exceptionally good liar.
		-- Jerome K. Jerome

--=-7eYI+5YA3V/gt3LAqat4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAktSLMgACgkQM0+0qS9rzVlcWgCggo2MmnOkYdmpYmftMUmCDRTk
S2AAmQHAu7LuKzSW8dxhPjWX1Osgv8GB
=JRWl
-----END PGP SIGNATURE-----

--=-7eYI+5YA3V/gt3LAqat4--

