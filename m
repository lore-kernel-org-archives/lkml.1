Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbXKBPop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbXKBPop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbXKBPnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:43:51 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49696 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759633AbXKBPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:43:50 -0400
Date: Fri, 2 Nov 2007 16:43:28 +0100
From: Adrian Bunk <bunk@kernel.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport access_process_vm
Message-ID: <20071102154328.GK30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used EXPORT_SYMBOL_GPL(access_process_vm).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d257d031aca70f5f7f8a72bc5331e503fde750f8 
diff --git a/mm/memory.c b/mm/memory.c
index eefd5b6..9791e47 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2748,4 +2748,3 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 
 	return buf - old_buf;
 }
-EXPORT_SYMBOL_GPL(access_process_vm);

