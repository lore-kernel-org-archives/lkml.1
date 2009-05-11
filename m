Return-Path: <linux-kernel-owner+w=401wt.eu-S1757814AbZEKJIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814AbZEKJIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbZEKJIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:08:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:21343 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682AbZEKJIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:08:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,327,1239001200"; 
   d="asc'?scan'208";a="141380659"
Subject: Re: [PATCH -v3] KVM: MCE: Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Avi Kivity <avi@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <1242032701.3114.4.camel@localhost.localdomain>
References: <1242031695.8213.17.camel@yhuang-dev.sh.intel.com>
	 <1242032701.3114.4.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LIj816tuI31W8E8RV3zG"
Date: Mon, 11 May 2009 17:08:09 +0800
Message-Id: <1242032889.8213.32.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LIj816tuI31W8E8RV3zG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-11 at 17:05 +0800, Jaswinder Singh Rajput wrote:
> On Mon, 2009-05-11 at 16:48 +0800, Huang Ying wrote:
> > +int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
> > +{
> > +	u64 data;
> > +
> > +	switch (msr) {
> > +	case 0xc0010010: /* SYSCFG */
> > +	case 0xc0010015: /* HWCR */
>=20
> You can replace this with :
>=20
> +	case MSR_K8_SYSCFG:
> +	case MSR_K8_HWCR:
>=20

I do not change this actually. So I think it should be changed in
another patch.

Best Regards,
Huang Ying

--=-LIj816tuI31W8E8RV3zG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoH6vcACgkQKhFGF+eHlpj8tQCgin5h+7v63B8pRnGkiAyjU/mc
h0EAn2Zv0cP5QwuHlb/iZi+yz3JdFCz3
=tOjM
-----END PGP SIGNATURE-----

--=-LIj816tuI31W8E8RV3zG--

