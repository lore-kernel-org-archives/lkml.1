Return-Path: <linux-kernel-owner+w=401wt.eu-S1760804AbZFLXHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760804AbZFLXHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 19:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZFLXHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 19:07:40 -0400
Received: from ganymede.vroon.org ([195.66.242.11]:53064 "EHLO
	ganymede.vroon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZFLXHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 19:07:39 -0400
Subject: Re: WARNING: at kernel/smp.c:369
 smp_call_function_many+0x52/0x1b3() [2.6.30-01557-gb640f04]
From: Tony Vroon <tony@vroon.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090612153906.GI12431@alberich.amd.com>
References: <1244753567.3768.2.camel@localhost>
	 <20090612153906.GI12431@alberich.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w5JPFhgWNg/tA/G14uZY"
Date: Sat, 13 Jun 2009 00:07:37 +0100
Message-Id: <1244848057.4174.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w5JPFhgWNg/tA/G14uZY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-06-12 at 17:39 +0200, Andreas Herrmann wrote:
> On Thu, Jun 11, 2009 at 09:52:47PM +0100, Tony Vroon wrote:
> > This one is new to me:
>    ...
> > ------------[ cut here ]------------
> > WARNING: at kernel/smp.c:369 smp_call_function_many+0x52/0x1b3()
>    ...
> > ---[ end trace 4eaa2a86a8e2da22 ]---
> > start_kernel(): bug: interrupts were enabled *very* early, fixing it
>=20
> Same here with v2.6.30-2327-g8ebf975, e.g.
>=20
> Jun 16 04:07:35 polonium ------------[ cut here ]------------
> Jun 16 04:07:35 polonium WARNING: at kernel/smp.c:369 smp_call_function_m=
any+0x\
> 52/0x1b3()

Fixed by commit 8429db5c6336083594036c30f49401405d536911, thank you
Pekka :)

Regards,
Tony V.


--=-w5JPFhgWNg/tA/G14uZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkoy37kACgkQp5vW4rUFj5rR9ACdHe9moqm7nqShubo+yf+GytSm
whoAoJ8XpTkV05XM88zdfz7qEKLSN+KT
=Qs63
-----END PGP SIGNATURE-----

--=-w5JPFhgWNg/tA/G14uZY--

