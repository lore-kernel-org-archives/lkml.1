Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYJ3IRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYJ3IRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYJ3IRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:17:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:47146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019AbYJ3IRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:17:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,513,1220252400"; 
   d="asc'?scan'208";a="633281545"
Subject: [PATCH -mm 0/3 -v3] kexec/i386: kexec page table code clean up
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ick+T9bVPBXxleYsQMCU"
Date: Thu, 30 Oct 2008 16:16:55 +0800
Message-Id: <1225354615.24095.110.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ick+T9bVPBXxleYsQMCU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patchset cleans up page table setup code of kexec on i386.

This patchset is based on 2.6.28-rc2-mm1 and has been tested on i386.

v3:

- Remove PAGE_SIZE alignment from relocate_kernel()

- Re-based on 2.6.28-rc2-mm1

v2:

- Rename some function names, such as alloc_page_tables ->
  machine_kexec_alloc_page_tables, etc.

- Cleanup error processing for machine_alloc_page_tables.


Best Regards,
Huang Ying



--=-ick+T9bVPBXxleYsQMCU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJbXMACgkQKhFGF+eHlphAMQCfUXDQPugXGV4PNfYzHO7P1iZy
WDIAoJaWRtuD86fJmzVDOXl0a55PIl7x
=if1F
-----END PGP SIGNATURE-----

--=-ick+T9bVPBXxleYsQMCU--

