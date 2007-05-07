Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbXEGAgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbXEGAgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXEGAgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:36:39 -0400
Received: from mx1.suse.de ([195.135.220.2]:43442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXEGAgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:36:14 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:51 +1000
Message-Id: <1070507003551.24173@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 006 of 8] knfsd: Trivial makefile cleanup
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Christoph Hellwig <hch@lst.de>

kbuild directly interprets <modulename>-y as objects to build into
a module, no need to assign it to the old foo-objs variable.


Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff .prev/fs/nfsd/Makefile ./fs/nfsd/Makefile
--- .prev/fs/nfsd/Makefile	2007-05-07 10:30:15.000000000 +1000
+++ ./fs/nfsd/Makefile	2007-05-07 10:31:05.000000000 +1000
@@ -11,4 +11,3 @@ nfsd-$(CONFIG_NFSD_V3)	+= nfs3proc.o nfs
 nfsd-$(CONFIG_NFSD_V3_ACL) += nfs3acl.o
 nfsd-$(CONFIG_NFSD_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4idmap.o \
 			   nfs4acl.o nfs4callback.o nfs4recover.o
-nfsd-objs		:= $(nfsd-y)
