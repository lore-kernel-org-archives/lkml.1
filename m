Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZJGEq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZJGEq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 00:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZJGEqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 00:46:24 -0400
Received: from mail.perches.com ([173.55.12.10]:1956 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZJGEqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 00:46:21 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/8] drivers/firmware/dmi_scan.c: Use %pUB to print UUIDs
Date: Tue,  6 Oct 2009 21:45:36 -0700
Message-Id: <8c5d259bb30f4704b5373a73524ffcf6ab4f648d.1254884776.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc2.17.gdbc1b.dirty
In-Reply-To: <1254890742-28245-1-git-send-email-joe@perches.com>
References: <1254890742-28245-1-git-send-email-joe@perches.com>
In-Reply-To: <cover.1254884776.git.joe@perches.com>
References: <cover.1254884776.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/dmi_scan.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 938100f..c8b2609 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -169,10 +169,7 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
 	if (!s)
 		return;
 
-	sprintf(s,
-		"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
-		d[0], d[1], d[2], d[3], d[4], d[5], d[6], d[7],
-		d[8], d[9], d[10], d[11], d[12], d[13], d[14], d[15]);
+	sprintf(s, "%pUB", d);
 
         dmi_ident[slot] = s;
 }
-- 
1.6.3.1.10.g659a0.dirty

