Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbYD2Dgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbYD2Dgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757554AbYD2DfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:35:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:57701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbYD2DfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:35:05 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 29 Apr 2008 13:35:20 +1000
Message-Id: <1080429033520.20373@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 006 of 9] md: Remove a stray command from a copy and paste error in resync_start_store
References: <20080429133104.20146.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dan Williams <dan.j.williams@intel.com>

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    1 -
 1 file changed, 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
+++ ./drivers/md/md.c	2008-04-29 12:27:57.000000000 +1000
@@ -2459,7 +2459,6 @@ resync_start_show(mddev_t *mddev, char *
 static ssize_t
 resync_start_store(mddev_t *mddev, const char *buf, size_t len)
 {
-	/* can only set chunk_size if array is not yet active */
 	char *e;
 	unsigned long long n = simple_strtoull(buf, &e, 10);
 
