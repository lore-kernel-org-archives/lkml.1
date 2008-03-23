Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYCWIOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYCWIOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758914AbYCWIIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:08:10 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2243 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758891AbYCWIIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:08:07 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 030/148] include/asm-x86/e820_64.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:05 -0700
Message-Id: <1206259443-13210-31-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/e820_64.h |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/asm-x86/e820_64.h b/include/asm-x86/e820_64.h
index d57a8c8..4c6ad98 100644
--- a/include/asm-x86/e820_64.h
+++ b/include/asm-x86/e820_64.h
@@ -14,22 +14,24 @@
 #include <linux/ioport.h>
 
 #ifndef __ASSEMBLY__
-extern unsigned long find_e820_area(unsigned long start, unsigned long end, 
+extern unsigned long find_e820_area(unsigned long start, unsigned long end,
 				    unsigned long size, unsigned long align);
 extern unsigned long find_e820_area_size(unsigned long start,
 					 unsigned long *sizep,
 					 unsigned long align);
-extern void add_memory_region(unsigned long start, unsigned long size, 
+extern void add_memory_region(unsigned long start, unsigned long size,
 			      int type);
 extern void update_memory_range(u64 start, u64 size, unsigned old_type,
 				unsigned new_type);
 extern void setup_memory_region(void);
-extern void contig_e820_setup(void); 
+extern void contig_e820_setup(void);
 extern unsigned long e820_end_of_ram(void);
 extern void e820_reserve_resources(void);
 extern void e820_mark_nosave_regions(void);
-extern int e820_any_mapped(unsigned long start, unsigned long end, unsigned type);
-extern int e820_all_mapped(unsigned long start, unsigned long end, unsigned type);
+extern int e820_any_mapped(unsigned long start, unsigned long end,
+			   unsigned type);
+extern int e820_all_mapped(unsigned long start, unsigned long end,
+			   unsigned type);
 extern int e820_any_non_reserved(unsigned long start, unsigned long end);
 extern int is_memory_any_valid(unsigned long start, unsigned long end);
 extern int e820_all_non_reserved(unsigned long start, unsigned long end);
@@ -37,8 +39,8 @@ extern int is_memory_all_valid(unsigned long start, unsigned long end);
 extern unsigned long e820_hole_size(unsigned long start, unsigned long end);
 
 extern void e820_setup_gap(void);
-extern void e820_register_active_regions(int nid,
-				unsigned long start_pfn, unsigned long end_pfn);
+extern void e820_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long end_pfn);
 
 extern void finish_e820_parsing(void);
 
-- 
1.5.4.rc2

