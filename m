Return-Path: <linux-kernel-owner+w=401wt.eu-S1765991AbYCWIps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765991AbYCWIps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759255AbYCWILE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:04 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2319 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1759959AbYCWIKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:10:55 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 074/148] include/asm-x86/mpspec.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:49 -0700
Message-Id: <1206259443-13210-75-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/mpspec.h |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 99da0a5..eccbc58 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -55,8 +55,7 @@ extern int mp_register_gsi(u32 gsi, int edge_level, int active_high_low);
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
 
-struct physid_mask
-{
+struct physid_mask {
 	unsigned long mask[PHYSID_ARRAY_SIZE];
 };
 
@@ -65,34 +64,34 @@ typedef struct physid_mask physid_mask_t;
 #define physid_set(physid, map)			set_bit(physid, (map).mask)
 #define physid_clear(physid, map)		clear_bit(physid, (map).mask)
 #define physid_isset(physid, map)		test_bit(physid, (map).mask)
-#define physid_test_and_set(physid, map) \
+#define physid_test_and_set(physid, map)			\
 	test_and_set_bit(physid, (map).mask)
 
-#define physids_and(dst, src1, src2) \
+#define physids_and(dst, src1, src2)					\
 	bitmap_and((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
 
-#define physids_or(dst, src1, src2) \
+#define physids_or(dst, src1, src2)					\
 	bitmap_or((dst).mask, (src1).mask, (src2).mask, MAX_APICS)
 
-#define physids_clear(map) \
+#define physids_clear(map)					\
 	bitmap_zero((map).mask, MAX_APICS)
 
-#define physids_complement(dst, src) \
+#define physids_complement(dst, src)				\
 	bitmap_complement((dst).mask, (src).mask, MAX_APICS)
 
-#define physids_empty(map) \
+#define physids_empty(map)					\
 	bitmap_empty((map).mask, MAX_APICS)
 
-#define physids_equal(map1, map2) \
+#define physids_equal(map1, map2)				\
 	bitmap_equal((map1).mask, (map2).mask, MAX_APICS)
 
-#define physids_weight(map) \
+#define physids_weight(map)					\
 	bitmap_weight((map).mask, MAX_APICS)
 
-#define physids_shift_right(d, s, n) \
+#define physids_shift_right(d, s, n)				\
 	bitmap_shift_right((d).mask, (s).mask, n, MAX_APICS)
 
-#define physids_shift_left(d, s, n) \
+#define physids_shift_left(d, s, n)				\
 	bitmap_shift_left((d).mask, (s).mask, n, MAX_APICS)
 
 #define physids_coerce(map)			((map).mask[0])
-- 
1.5.4.rc2

