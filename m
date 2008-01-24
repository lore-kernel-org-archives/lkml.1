Return-Path: <linux-kernel-owner+w=401wt.eu-S1757844AbYAXQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844AbYAXQ44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbYAXQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:18 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64239 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYAXQxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:06 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/17] [MIPS] Malta: make the helper function static
Date: Thu, 24 Jan 2008 19:52:55 +0300
Message-Id: <1201193577-4261-16-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One helper function can become static. This patch adds the needed
keyword.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 8d62966..541f4e7 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -80,7 +80,7 @@ const char display_string[] = "        LINUX ON MALTA       ";
 #endif /* CONFIG_MIPS_MT_SMTC */
 
 #ifdef CONFIG_BLK_DEV_FD
-void __init fd_activate(void)
+static void __init fd_activate(void)
 {
 	/*
 	 * Activate Floppy Controller in the SMSC FDC37M817 Super I/O
-- 
1.5.3

