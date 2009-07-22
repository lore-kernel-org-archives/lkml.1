Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZGVDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZGVDIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZGVDIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:08:18 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4982 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZGVDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:17 -0400
X-Greylist: delayed 320 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 23:08:17 EDT
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, starvik@axis.com,
       jesper.nilsson@axis.com, linux-cris-kernel@axis.com
Subject: [PATCH 7/7] [cris] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:33 -0500
Message-ID: <1248231753-8344-8-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248231753-8344-7-git-send-email-sgayda2@uiuc.edu>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-5-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-6-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-7-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 arch/cris/arch-v32/mach-a3/io.c |    2 +-
 arch/cris/arch-v32/mach-fs/io.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/mach-a3/io.c b/arch/cris/arch-v32/mach-a3/io.c
index c22f67e..090ceb9 100644
--- a/arch/cris/arch-v32/mach-a3/io.c
+++ b/arch/cris/arch-v32/mach-a3/io.c
@@ -36,7 +36,7 @@ struct crisv32_ioport crisv32_ioports[] = {
 	},
 };
 
-#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
+#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
 
 struct crisv32_iopin crisv32_led_net0_green;
 struct crisv32_iopin crisv32_led_net0_red;
diff --git a/arch/cris/arch-v32/mach-fs/io.c b/arch/cris/arch-v32/mach-fs/io.c
index cb6327b..a695866 100644
--- a/arch/cris/arch-v32/mach-fs/io.c
+++ b/arch/cris/arch-v32/mach-fs/io.c
@@ -52,7 +52,7 @@ struct crisv32_ioport crisv32_ioports[] = {
 	}
 };
 
-#define NBR_OF_PORTS sizeof(crisv32_ioports)/sizeof(struct crisv32_ioport)
+#define NBR_OF_PORTS ARRAY_SIZE(crisv32_ioports)
 
 struct crisv32_iopin crisv32_led_net0_green;
 struct crisv32_iopin crisv32_led_net0_red;
-- 
1.6.3.3

