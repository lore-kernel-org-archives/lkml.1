Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbZI2FCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbZI2FCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZI2FBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1311 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbZI2FBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:14 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@nokia.com>, Alex Elder <aelder@sgi.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Christoph Hellwig <hch@lst.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jgarzik@redhat.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matt Mackall <mpm@selenic.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Neil Brown <neilb@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       xfs-masters@oss.sgi.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] drivers/firmware/dmi_scan.c: Use %pUX to print UUIDs
Date: Mon, 28 Sep 2009 22:01:06 -0700
Message-Id: <ace0c6b1c65b6de8c3c2c7827e290023c7a6d462.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/dmi_scan.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 938100f..c0deabb 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -169,10 +169,7 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	if (!s)
 		return;
 
-	sprintf(s,
-		"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
-		d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7],
-		d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15]);
+	sprintf(s, "%pUX", d);
 
         dmi_ident[slot] = s;
 }
-- 
1.6.3.1.10.g659a0.dirty

