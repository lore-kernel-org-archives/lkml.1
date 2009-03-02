Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbZCBDGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbZCBDGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757299AbZCBDGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:06:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:18118 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbZCBDGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:06:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,286,1233561600"; 
   d="asc'?scan'208";a="435216645"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Brian Maly <bmaly@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49AB4AFC.3010503@redhat.com>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282014he17bb6an1f59872ef30db0c5@mail.gmail.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
	 <49AB4AFC.3010503@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VJk2upsFck4jsAyQNqHH"
Date: Mon, 02 Mar 2009 11:06:35 +0800
Message-Id: <1235963195.6204.202.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VJk2upsFck4jsAyQNqHH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-02 at 10:57 +0800, Brian Maly wrote:
> In looking at an older (working) kernel a bit more and it looks like=20
> efi_ioremap() is not called in efi_enter_virtual_mode() pre 2.6.27 on=20
> this hardware, so we never followed the efi_ioremap codepath up until=20
> recently. This explains the regression.

Yes. That is why the regression is triggered after 2.6.27.

Best Regards,
Huang Ying


--=-VJk2upsFck4jsAyQNqHH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmrTTcACgkQKhFGF+eHlpg0fgCglRYhZFChImUUx+WCVjf3fgWl
BjEAn18jRsGh34Uiea76QZnAofn0Z51s
=cCLp
-----END PGP SIGNATURE-----

--=-VJk2upsFck4jsAyQNqHH--

