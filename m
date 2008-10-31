Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYJaBsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYJaBsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYJaBsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:48:00 -0400
Received: from mga11.intel.com ([192.55.52.93]:23971 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048AbYJaBr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,519,1220252400"; 
   d="asc'?scan'208";a="398031160"
Subject: [PATCH 0/3 -v4] kexec/i386: kexec page table code clean up
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Simon Horman <horms@verge.net.au>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PqCX37kr74nBYYzpcT7D"
Date: Fri, 31 Oct 2008 09:47:57 +0800
Message-Id: <1225417677.24095.135.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PqCX37kr74nBYYzpcT7D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This patchset cleans up page table setup code of kexec on i386.

This patchset is based on v2.6.28-rc2-338-g65fc716 and has been tested
on i386.

v4:

- Re-based on mainline git tree: v2.6.28-rc2-338-g65fc716.

v3:

- Remove PAGE_SIZE alignment from relocate_kernel()

- Re-based on 2.6.28-rc2-mm1

v2:

- Rename some function names, such as alloc_page_tables ->
  machine_kexec_alloc_page_tables, etc.

- Cleanup error processing for machine_alloc_page_tables.


Best Regards,
Huang Ying

--=-PqCX37kr74nBYYzpcT7D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkKY8kACgkQKhFGF+eHlphCwACeMGdWeChge+VXg1pvIGbflZwX
b80An0ryfgz0ttXegCkgvDLvJ6tZRU/r
=Rf4V
-----END PGP SIGNATURE-----

--=-PqCX37kr74nBYYzpcT7D--

