Return-Path: <linux-kernel-owner+w=401wt.eu-S1751507Ab0AQGAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab0AQGAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 01:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258Ab0AQGAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 01:00:30 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12847 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961Ab0AQGAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 01:00:30 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Brian Gerst <brgerst@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <73c1f2161001161618l7b471f48ldb4c33c88eafb7b6@mail.gmail.com>
References: <20100116170338.GA17175@elte.hu>
	 <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain>
	 <73c1f2161001161618l7b471f48ldb4c33c88eafb7b6@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7RfmYpmTDNJARNyUu1uB"
Date: Sun, 17 Jan 2010 06:00:23 +0000
Message-ID: <1263708023.14137.1213.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [GIT PULL] x86 fixes
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=Z4Rwk6OoAAAA:8 a=QaZaC8N7_lZZYo4dmtQA:9 a=lpO_0GIfENMIBLS94uCEImx0phcA:4 a=jbrJJM5MRmoA:10 a=HRkSOGoBkiB3UMvgq-cA:9 a=1v5WaysztmPuIfS4xOWUTJHwk88A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7RfmYpmTDNJARNyUu1uB
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-16 at 19:18 -0500, Brian Gerst wrote:=20
> On Sat, Jan 16, 2010 at 3:34 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> > On Sat, 16 Jan 2010, Ingo Molnar wrote:
> >>
> >> Cyrill Gorcunov (1):
> >>       x86: kernel_thread() -- initialize SS to a known state
> >
> > This looks bogus. Why does it do it only on x86-64?
> >
> > Either people care about SS or they don't (the answer, I suspect, is "t=
hey
> > don't"). But if they care, we should do it on both 32-bit _and_ 64-bit,
> > no?
>=20
> 32-bit doesn't care about ss or esp since it won't pop them from the
> stack when returning to the same privilege level.

Right! That's the bit of behaviour I wasn't thinking of.

Thanks, Ian.

--=20
Ian Campbell

Under every stone lurks a politician.
		-- Aristophanes

--=-7RfmYpmTDNJARNyUu1uB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAktSp3cACgkQM0+0qS9rzVmJkwCg0sV6XkAspmWWyozWZlyAmLHt
4V4An2wXgu3jhRvisF4hQdexokAxGghN
=Glpd
-----END PGP SIGNATURE-----

--=-7RfmYpmTDNJARNyUu1uB--

