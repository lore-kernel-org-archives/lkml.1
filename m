Return-Path: <linux-kernel-owner+w=401wt.eu-S1763167AbZDJBI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763167AbZDJBI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 21:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbZDJBIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 21:08:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:37393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbZDJBIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 21:08:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,164,1239001200"; 
   d="asc'?scan'208";a="401932328"
Subject: Re: [PATCH] rtc: add x86 support for rtc-efi
From: Huang Ying <ying.huang@intel.com>
To: Brian Maly <bmaly@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "dannf@hp.com" <dannf@hp.com>
In-Reply-To: <49DA40B9.2060804@redhat.com>
References: <49DA40B9.2060804@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UIkx++e4PBzOd+JNB2r4"
Date: Fri, 10 Apr 2009 09:08:15 +0800
Message-Id: <1239325695.6384.48.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UIkx++e4PBzOd+JNB2r4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Brian,

Sorry for late.

1. Why not put these code into arch/x86/kernel/rtc.c? I think that is
more approriate.

2. It seems that you use both CMOS RTC and EFI RTC. In code path of
read_persistent_clock() and update_persistent_clock(), CMOS RTC is used
for x86_64. I think you should change that too. I have tried to do that
in http://lkml.org/lkml/2007/8/13/602.

Best Regards,
Huang Ying

On Tue, 2009-04-07 at 01:49 +0800, Brian Maly wrote:
> This patch adds support for rtc-efi (RTC Class Driver for EFI-based=20
> systems) to x86.
>=20
> This patch is based on dann frazier patch [add rtc platform driver for=20
> EFI -> http://lkml.org/lkml/2009/1/8/434], and also depends on dann's=20
> patch. Dann's patch was in the mm tree, though I think its been merged=20
> already.
>=20
> This patch has been tested and works perfectly on every x86 EFI system I=20
> could find, though all have been EL64 systems. I would appreciate any=20
> testing feedback from EL32 systems from anyone that has one and can test.
>=20
> Signed-off-by: Brian Maly <bmaly@redhat.com>
>=20
>=20
>=20
>=20

--=-UIkx++e4PBzOd+JNB2r4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknem/wACgkQKhFGF+eHlpi/gwCfdIH3TFhph+VASUIBR/4UTlN7
5MUAoIedYHWN+iTAcfPFMA5srHEwd8bE
=eRYR
-----END PGP SIGNATURE-----

--=-UIkx++e4PBzOd+JNB2r4--

