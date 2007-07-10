Return-Path: <linux-kernel-owner+w=401wt.eu-S1762882AbXGJC25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762882AbXGJC25 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 22:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762680AbXGJC1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 22:27:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:38249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762490AbXGJC1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 22:27:53 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 12:27:49 +1000
Message-Id: <1070710022749.13539@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: J "." Bruce Fields <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 015 of 20] knfsd: nfsd4: make readonly access depend on pseudoflavor
References: <20070710121949.12548.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>

Allow readonly access to vary depending on the pseudoflavor, using the
flag passed with each pseudoflavor in the export downcall.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/nfsd/export.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/include/linux/nfsd/export.h ./include/linux/nfsd/export.h
--- .prev/include/linux/nfsd/export.h	2007-07-10 11:40:31.000000000 +1000
+++ ./include/linux/nfsd/export.h	2007-07-10 11:50:43.000000000 +1000
@@ -43,7 +43,7 @@
 #define NFSEXP_ALLFLAGS		0xFE3F
 
 /* The flags that may vary depending on security flavor: */
-#define NFSEXP_SECINFO_FLAGS	0
+#define NFSEXP_SECINFO_FLAGS	NFSEXP_READONLY
 
 #ifdef __KERNEL__
 
