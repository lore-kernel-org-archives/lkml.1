Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbYIXDJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbYIXDJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYIXDJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:09:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:16609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYIXDJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:09:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,297,1220252400"; 
   d="asc'?scan'208";a="50536772"
Subject: Re: [PATCH 0/4] x86: UV runtime bios calls
From: Huang Ying <ying.huang@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080922210644.GC222374@sgi.com>
References: <20080922210644.GC222374@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-L89Juf8XdXTgSYAVDcNP"
Date: Wed, 24 Sep 2008 11:09:07 +0800
Message-Id: <1222225747.23099.104.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L89Juf8XdXTgSYAVDcNP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Russ,

On Mon, 2008-09-22 at 16:06 -0500, Russ Anderson wrote:
> 	This patch uses sal_systab.  sal_systab is used on ia64, but was
> 	not used on x86.  An alternative would be to create a new
> 	EFI entry type (uv_systab), though that would require adding=20
> 	to struct efi.

I don't think it is a good idea to use sal_systab, if it is not a real
sal_systab. It's better to add new field such as uv_systab to struct
efi, which is not defined by UEFI standard, so can be changed.

Best Regards,
Huang Ying


--=-L89Juf8XdXTgSYAVDcNP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjZr1AACgkQKhFGF+eHlpi7iwCgogO3zW+MOO8X++OCKHWG3N55
fuYAnisP7AxcHj5tA5qBW47maRNAUwX/
=pzOl
-----END PGP SIGNATURE-----

--=-L89Juf8XdXTgSYAVDcNP--

