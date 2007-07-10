Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXGJCXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXGJCXa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbXGJCXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:23:21 -0400
Received: from mx1.suse.de ([195.135.220.2]:38028 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268AbXGJCXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:23:20 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:23:04 +1000
Message-Id: <1070710022304.12950@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 002 of 20] knfsd: nfsd4: build rpcsec_gss whenever nfsd4 is built
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Select rpcsec_gss support whenever asked for NFSv4 support.  The rfc
actually requires gss, and gss is also the main reason to migrate to v4.
We already do this on the client side.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff .prev/fs/Kconfig ./fs/Kconfig
--- .prev/fs/Kconfig	2007-07-10 11:19:59.000000000 +1000
+++ ./fs/Kconfig	2007-07-10 11:26:04.000000000 +1000
@@ -1725,6 +1725,7 @@ config NFSD_V3_ACL
 config NFSD_V4
 	bool "Provide NFSv4 server support (EXPERIMENTAL)"
 	depends on NFSD_V3 && EXPERIMENTAL
+	select RPCSEC_GSS_KRB5
 	help
 	  If you would like to include the NFSv4 server as well as the NFSv2
 	  and NFSv3 servers, say Y here.  This feature is experimental, and
