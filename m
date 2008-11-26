Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbYKZMtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbYKZMtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 07:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKZMs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 07:48:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36878 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYKZMs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 07:48:56 -0500
Date: Wed, 26 Nov 2008 23:48:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       eranian@gmail.com, paulus@samba.org
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-Id: <20081126234838.f13ff744.sfr@canb.auug.org.au>
In-Reply-To: <20081126122217.GW6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	<20081126113309.GS6703@one.firstfloor.org>
	<20081126230529.ab37fb32.sfr@canb.auug.org.au>
	<20081126122217.GW6703@one.firstfloor.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__26_Nov_2008_23_48_38_+1100_Kv+Qdjc/WJu=2fnJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Nov_2008_23_48_38_+1100_Kv+Qdjc/WJu=2fnJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

On Wed, 26 Nov 2008 13:22:17 +0100 Andi Kleen <andi@firstfloor.org> wrote:
>
> On Wed, Nov 26, 2008 at 11:05:29PM +1100, Stephen Rothwell wrote:
> >=20
> > On Wed, 26 Nov 2008 12:33:09 +0100 Andi Kleen <andi@firstfloor.org> wro=
te:
> > >
> > > > + * x86 does not need extra alignment requirements for the sampling=
 buffer
> > > > + */
> > > > +#define PFM_ARCH_SMPL_ALIGN_SIZE	0
> > > > +
> > > > +asmlinkage void  pmu_interrupt(void);
> > > > +
> > > > +static inline void pfm_arch_bv_copy(u64 *a, u64 *b, int nbits)
> > >=20
> > > All these bitmap wrappers just seem like unnecessary obfuscation.
> > > Could you just drop them and call the standard functions directly?
> >=20
> > These were added after comments from the PowerPC maintainer since how t=
he
> > bitmaps are accessed needs to be arch specific.
>=20
> Why? They should not be exported outside, so endian shouldn't matter, sho=
uld
> it?

See http://lkml.org/lkml/2008/11/9/281 and the followups.  Otherwise this
should be answered by Paul and Stephane.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__26_Nov_2008_23_48_38_+1100_Kv+Qdjc/WJu=2fnJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkktRaYACgkQjjKRsyhoI8yxKQCgjDPs58DxtRMEm1kHKQ8sNl60
r5UAoKio8liFaA700LGiCkCgQrMl377e
=32pE
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Nov_2008_23_48_38_+1100_Kv+Qdjc/WJu=2fnJ--
