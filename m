Return-Path: <linux-kernel-owner+w=401wt.eu-S1752340AbZI2FBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbZI2FBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 01:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbZI2FBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 01:01:15 -0400
Received: from mail.perches.com ([173.55.12.10]:1275 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbZI2FBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 01:01:11 -0400
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
       xfs-masters@oss.sgi.com, Russ Anderson <rja@sgi.com>
Subject: [PATCH 2/9] efi.h: Use %pUr to print UUIDs
Date: Mon, 28 Sep 2009 22:01:04 -0700
Message-Id: <81950aa34830352db279ca779140011194461367.1254193019.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254193019.git.joe@perches.com>
References: <cover.1254193019.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/efi.h |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index ce4581f..dd85b39 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -280,11 +280,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t right)
 static inline char *
 efi_guid_unparse(efi_guid_t *guid, char *out)
 {
-	sprintf(out, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
-		guid->b[3], guid->b[2], guid->b[1], guid->b[0],
-		guid->b[5], guid->b[4], guid->b[7], guid->b[6],
-		guid->b[8], guid->b[9], guid->b[10], guid->b[11],
-		guid->b[12], guid->b[13], guid->b[14], guid->b[15]);
+	sprintf(out, "%pUr", guid->b);
         return out;
 }
 
-- 
1.6.3.1.10.g659a0.dirty

