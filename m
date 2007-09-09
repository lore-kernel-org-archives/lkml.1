Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbXIIU3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbXIIU3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbXIIUZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:25:39 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60744 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759513AbXIIUZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:25:37 -0400
Date: Sun, 9 Sep 2007 22:25:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [-mm patch] unexport raise_softirq_irqoff
Message-ID: <20070909202544.GV3563@stusta.de>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc3-mm1:
>...
>  git-net.patch
>...
>  git trees
>...

raise_softirq_irqoff no longer has any modular user.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
eff0407b63757cdd4164a0bdde0313e8f154b6dc 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index abae56c..ce38b56 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -335,8 +335,6 @@ inline fastcall void raise_softirq_irqoff(unsigned int nr)
 		wakeup_softirqd();
 }
 
-EXPORT_SYMBOL(raise_softirq_irqoff);
-
 void fastcall raise_softirq(unsigned int nr)
 {
 	unsigned long flags;

