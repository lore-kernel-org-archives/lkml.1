Return-Path: <linux-kernel-owner+w=401wt.eu-S1756213AbYAXQz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213AbYAXQz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYAXQxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:53:14 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:64229 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbYAXQxF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:53:05 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/17] [MIPS] Malta: Use C89 style for comments
Date: Thu, 24 Jan 2008 19:52:52 +0300
Message-Id: <1201193577-4261-13-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201193577-4261-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove comments in C99 style and make checkpatch.pl happy.

No functional changes introduced.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_int.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_int.c b/arch/mips/mips-boards/malta/malta_int.c
index 2473a77..92e6e2d 100644
--- a/arch/mips/mips-boards/malta/malta_int.c
+++ b/arch/mips/mips-boards/malta/malta_int.c
@@ -214,9 +214,9 @@ static inline unsigned int irq_ffs(unsigned int pending)
 
 	t0 = pending & 0x8000;
 	t0 = t0 < 1;
-	//t0 = t0 << 2;
+	/* t0 = t0 << 2; */
 	a0 = a0 - t0;
-	//pending = pending << t0;
+	/* pending = pending << t0; */
 
 	return a0;
 #endif
-- 
1.5.3

