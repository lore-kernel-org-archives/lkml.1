Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbYAXQyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbYAXQyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:54:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYAXQxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:10 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64218 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYAXQxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:04 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 06/17] [MIPS] Malta: remove a dead function declaration
Date: Thu, 24 Jan 2008 19:52:46 +0300
Message-Id: <1201193577-4261-7-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neither is the mips_rtc_get_time() routine defined anywhere in
the MIPS architecture-specific code, nor does anyone call it any
more. This patch removes the extern declaration of this fossil.

This patch does not introduce any functional changes.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 8b391ee..480521f 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -36,7 +36,6 @@
 #endif
 
 extern void mips_reboot_setup(void);
-extern unsigned long mips_rtc_get_time(void);
 
 #ifdef CONFIG_KGDB
 extern void kgdb_config(void);
-- 
1.5.3

