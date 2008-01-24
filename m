Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYAXQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYAXQ5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755981AbYAXQxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:20 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64232 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbYAXQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:05 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/17] [MIPS] Malta: fix braces at single statement blocks
Date: Thu, 24 Jan 2008 19:52:54 +0300
Message-Id: <1201193577-4261-15-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a couple of warnings reported by checkpatch.pl.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c   |    3 ++-
 arch/mips/mips-boards/malta/malta_setup.c |    3 +--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 92e6e2d..dbe60eb 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -114,7 +114,8 @@ static void malta_hw0_irqdispatch(void)
 
 	irq = get_int();
 	if (irq < 0) {
-		return;  /* interrupt has already been cleared */
+		/* interrupt has already been cleared */
+		return;
 	}
 
 	do_IRQ(MALTA_INT_BASE + irq);
diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 8dacb6a..8d62966 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -202,9 +202,8 @@ void __init plat_mem_setup(void)
 #endif
 	}
 #ifdef CONFIG_DMA_COHERENT
-	else {
+	else
 		panic("Hardware DMA cache coherency not supported");
-	}
 #endif
 
 #ifdef CONFIG_BLK_DEV_IDE
-- 
1.5.3

