Return-Path: <linux-kernel-owner+w=401wt.eu-S1752981AbYKZMF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbYKZMF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYKZMFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:05:48 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51581 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYKZMFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:05:47 -0500
Date: Wed, 26 Nov 2008 23:05:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       eranian@gmail.com
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-Id: <20081126230529.ab37fb32.sfr@canb.auug.org.au>
In-Reply-To: <20081126113309.GS6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	<20081126113309.GS6703@one.firstfloor.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_Nov_2008_23_05_29_+1100_syYqIwHEXQM9tsTG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Nov_2008_23_05_29_+1100_syYqIwHEXQM9tsTG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Wed, 26 Nov 2008 12:33:09 +0100 Andi Kleen <andi@firstfloor.org> wrote:
>
> > + * x86 does not need extra alignment requirements for the sampling buf=
fer
> > + */
> > +#define PFM_ARCH_SMPL_ALIGN_SIZE	0
> > +
> > +asmlinkage void  pmu_interrupt(void);
> > +
> > +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
>=20
> All these bitmap wrappers just seem like unnecessary obfuscation.
> Could you just drop them and call the standard functions directly?

These were added after comments from the PowerPC maintainer since how the
bitmaps are accessed needs to be arch specific.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_Nov_2008_23_05_29_+1100_syYqIwHEXQM9tsTG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkktO4kACgkQjjKRsyhoI8zG4ACgpCsNUjQYzCjC7nDcLfoXXbWM
CCAAoIowcXesYxpnJ3YQbUOPyXAjdS3m
=8EHj
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Nov_2008_23_05_29_+1100_syYqIwHEXQM9tsTG--
