Return-Path: <linux-kernel-owner+w=401wt.eu-S1750999AbZKIFPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750999AbZKIFPC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:15:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbZKIFPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:15:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58695 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZKIFPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:15:01 -0500
Date: Mon, 9 Nov 2009 16:15:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@ozlabs.org
Subject: Re: [patch 09/16] powerpc: Replace old style lock initializer
Message-Id: <20091109161502.ab064092.sfr@canb.auug.org.au>
In-Reply-To: <1257548144.13611.267.camel@pasglop>
References: <20091106223547.784916750@linutronix.de>
	<20091106223806.762624109@linutronix.de>
	<1257548144.13611.267.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_Nov_2009_16_15_02_+1100_VXaAjp_Frxudoo9n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Nov_2009_16_15_02_+1100_VXaAjp_Frxudoo9n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Sat, 07 Nov 2009 09:55:44 +1100 Benjamin Herrenschmidt <benh@kernel.cras=
hing.org> wrote:
>
> On Fri, 2009-11-06 at 22:41 +0000, Thomas Gleixner wrote:
> > plain text document attachment
> > (power-replace-old-style-lock-init.patch)
> > SPIN_LOCK_UNLOCKED is deprecated. Init the lock array at runtime
> > instead.
> >=20
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: linuxppc-dev@ozlabs.org
> > ---
>=20
> Looks reasonable. But iseries can be a bitch, so we do need to test it
> on monday.

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_Nov_2009_16_15_02_+1100_VXaAjp_Frxudoo9n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr3pVYACgkQjjKRsyhoI8xGQwCgnRc8jgHeGJFueccVWDyc4HFd
ShUAniFJkr80jd342IXlM8QZOF+zBsdI
=QbRQ
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Nov_2009_16_15_02_+1100_VXaAjp_Frxudoo9n--
