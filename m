Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbZCBBIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbZCBBIA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 20:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZCBBHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 20:07:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:52196 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781AbZCBBHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 20:07:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,286,1233561600"; 
   d="asc'?scan'208";a="669460603"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Brian Maly <bmaly@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49AAEC79.3000808@redhat.com>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1btKzHHGCrrIAc+m0qU3"
Date: Mon, 02 Mar 2009 09:07:48 +0800
Message-Id: <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1btKzHHGCrrIAc+m0qU3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Brian,

On Mon, 2009-03-02 at 04:13 +0800, Brian Maly wrote:
> I was able verify the kernel that does not boot on the MacBook (vanilla=20
> 2.6.29-rc4) does call efi_ioremap() which bails out early returning=20
> NULL. So no remapping happens in this case.  I have no idea if=20
> efi_ioremap ever does succeed in mapping any ranges though being I have=20
> no video or console this early in the boot and have to rely on triple=20
> faulting as a means of debugging.

Please attach your dmesg of successful boot, so we can take a look at
the EFI memory map.

Best Regards,
Huang Ying

--=-1btKzHHGCrrIAc+m0qU3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmrMWEACgkQKhFGF+eHlpi9qQCgiCH1EiWfN2pTO/xLvRYbYPOA
32UAn2Cd/WB3+ESTDiy2t0OHhNiGQlJN
=LvC8
-----END PGP SIGNATURE-----

--=-1btKzHHGCrrIAc+m0qU3--

