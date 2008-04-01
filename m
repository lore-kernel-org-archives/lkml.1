Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbYDAX7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbYDAX7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 19:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbYDAX6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 19:58:49 -0400
Received: from smtp03.mtu.ru ([62.5.255.50]:64030 "EHLO smtp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbYDAX6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 19:58:48 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] [MIPS] unexport copy_from_user_page()
Date: Wed,  2 Apr 2008 03:58:36 +0400
Message-Id: <1207094318-21748-4-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207094318-21748-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp03.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users for the copy_from_user_page() routine exist outside of the
core kernel code. Therefore, EXPORT_SYMBOL(copy_from_user_page) is
useless, and this patch removes it.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mm/init.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/mips/mm/init.c b/arch/mips/mm/init.c
index 6b9d54b..ff61184 100644
--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -263,9 +263,6 @@ void copy_from_user_page(struct vm_area_struct *vma,
 	}
 }
 
-EXPORT_SYMBOL(copy_from_user_page);
-
-
 #ifdef CONFIG_HIGHMEM
 unsigned long highstart_pfn, highend_pfn;
 
-- 
1.5.3

