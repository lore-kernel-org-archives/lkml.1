Return-Path: <linux-kernel-owner+w=401wt.eu-S1030777AbXCNJSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030777AbXCNJSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:18:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030726AbXCNJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:18:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60474 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030740AbXCNJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:18:10 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 2/17] fastcall still doesn't make sense in paravirt
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HRPcX-0003Ni-WD@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:18:09 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andi had removed a bunch of those, but one more had creeped in...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/asm-i386/paravirt.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index f8319ca..46dc34c 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -130,7 +130,7 @@ struct paravirt_ops
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(u32 addr);
 
-	void (fastcall *map_pt_hook)(int type, pte_t *va, u32 pfn);
+	void (*map_pt_hook)(int type, pte_t *va, u32 pfn);
 
 	void (*alloc_pt)(u32 pfn);
 	void (*alloc_pd)(u32 pfn);
-- 
1.5.0-rc2.GIT


