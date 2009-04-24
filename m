Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZDXGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZDXGHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 02:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755853AbZDXGGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 02:06:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:19857 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399AbZDXGGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 02:06:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,240,1239001200"; 
   d="asc'?scan'208";a="509526267"
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <20090422101600.GL3226@erda.amd.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
	 <20090422092259.GC18226@elte.hu>  <20090422101600.GL3226@erda.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SMJQwRiDDQFfEnVmveYi"
Date: Fri, 24 Apr 2009 14:06:50 +0800
Message-Id: <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SMJQwRiDDQFfEnVmveYi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 18:16 +0800, Robert Richter wrote:
> On 22.04.09 11:22:59, Ingo Molnar wrote:
> >=20
> > * Huang Ying <ying.huang@intel.com> wrote:
> >=20
> > > Re-implement MCE log ring buffer as per-CPU ring buffer for better=20
> > > scalability. Basic design is as follow:
> >=20
> > Before changing anything substantial in the MCE code it would be=20
> > necessary to clean up and then unify the 32-bit and 64-bit side of=20
> > the MCE code first. (Which essentially means extending the=20
> > 64-bit-only code to 32-bit)
>=20
> You may also want to consider to use the in-kernel ring_buffer api
> (include/linux/ring_buffer.h).

It seems that ring_buffer is not NMI-safe, while mcelog buffer will be
used in NMI context and interrupt context. When will ring_buffer to be
NMI-safe?

Best Regards,
Huang Ying

--=-SMJQwRiDDQFfEnVmveYi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxVvgACgkQKhFGF+eHlpgUYACeI1mRVFfvqTvegWPiYoCpdEWR
pQcAniR7oksfLBubg+bDFXEgG7/X/IUe
=uvPE
-----END PGP SIGNATURE-----

--=-SMJQwRiDDQFfEnVmveYi--

