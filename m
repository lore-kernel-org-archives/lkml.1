Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbZDOHZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbZDOHZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZDOHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:25:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:38275 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbZDOHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:25:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,191,1239001200"; 
   d="asc'?scan'208";a="403271820"
Subject: Re: [PATCH] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49E4693B.4080707@redhat.com>
References: <1239155601.6384.3.camel@yhuang-dev.sh.intel.com>
	 <49DE195D.1020303@redhat.com>
	 <1239332455.6384.108.camel@yhuang-dev.sh.intel.com>
	 <49E08762.1010206@redhat.com>
	 <1239590499.6384.4016.camel@yhuang-dev.sh.intel.com>
	 <49E337D7.5050502@redhat.com>
	 <1239674697.20762.34.camel@yhuang-dev.sh.intel.com>
	 <49E4693B.4080707@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XaFlvijvjdA18oQStiMt"
Date: Wed, 15 Apr 2009 15:24:57 +0800
Message-Id: <1239780297.20762.105.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XaFlvijvjdA18oQStiMt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-14 at 18:45 +0800, Avi Kivity wrote:
> Huang Ying wrote:
> >> I'm okay with an ioctl to setup MCE, but just make sure userspace has=20
> >> all the information to know what the kernel can do rather than the=20
> >> try-and-see-if-it-works approach.  We can publish this information via=
=20
> >> KVM_CAP things, or via another ioctl (see KVM_GET_SUPPORTED_CPUID2 for=
=20
> >> an example).
> >>    =20
> >
> > Yes. MCE support should be published by KVM_CAP_MCE and other features
> > can be published via reading the default value of MSR_IA32_MCG_CAP.
> >  =20
>=20
> A problem with this is that you can only read an MSR after a vcpu has=20
> been created.  But if you're writing a program to detect what features=20
> are available (for example, when checking features common to a migration=20
> pool), you don't want to create a vpcu (you could, but it's hacky).

Yes. You are right. I will change this as you said, something like
KVM_GET_SUPPORTED_CPUID2.

Best Regards,
Huang Ying


--=-XaFlvijvjdA18oQStiMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknli8cACgkQKhFGF+eHlpggdACfWLS/d5jrzZZmH9Lx5trQ8ii+
PmgAn0W4EVg0ABXZSYpv9IJI5jpT5PbW
=lxnK
-----END PGP SIGNATURE-----

--=-XaFlvijvjdA18oQStiMt--

