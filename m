Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYCaWEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYCaWEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYCaWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:04:15 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:54620 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455AbYCaWEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:04:14 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] [MIPS] make mips_nmi_setup() static
Date: Tue,  1 Apr 2008 02:03:20 +0400
Message-Id: <1207001005-2633-2-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes the needlessly global function mips_nmi_setup() static.

Successfully build-tested using default configs for Malta, Atlas
and SEAD boards.

Runtime test successfully performed by booting the Malta 4Kc board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/generic/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/mips-boards/generic/init.c b/arch/mips/mips-boards/generic/init.c
index 1695dca..70dd9f4 100644
--- a/arch/mips/mips-boards/generic/init.c
+++ b/arch/mips/mips-boards/generic/init.c
@@ -226,7 +226,7 @@ void __init kgdb_config(void)
 }
 #endif
 
-void __init mips_nmi_setup(void)
+static void __init mips_nmi_setup(void)
 {
 	void *base;
 	extern char except_vec_nmi;
-- 
1.5.3

