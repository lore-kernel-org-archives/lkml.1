Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbYK2Vdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbYK2Vdo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 16:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbYK2Vdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 16:33:36 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:36063 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbYK2Vdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 16:33:35 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] x86: intel_cacheinfo, minor show_type cleanup
Date: Sat, 29 Nov 2008 22:33:16 +0100
Message-Id: <1227994396-20170-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 43ea612..15cf14e 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -644,20 +644,17 @@ static inline ssize_t show_shared_cpu_list(struct _cpuid4_info *leaf, char *buf)
 	return show_shared_cpu_map_func(leaf, 1, buf);
 }
 
-static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf) {
-	switch(this_leaf->eax.split.type) {
-	    case CACHE_TYPE_DATA:
+static ssize_t show_type(struct _cpuid4_info *this_leaf, char *buf)
+{
+	switch (this_leaf->eax.split.type) {
+	case CACHE_TYPE_DATA:
 		return sprintf(buf, "Data\n");
-		break;
-	    case CACHE_TYPE_INST:
+	case CACHE_TYPE_INST:
 		return sprintf(buf, "Instruction\n");
-		break;
-	    case CACHE_TYPE_UNIFIED:
+	case CACHE_TYPE_UNIFIED:
 		return sprintf(buf, "Unified\n");
-		break;
-	    default:
+	default:
 		return sprintf(buf, "Unknown\n");
-		break;
 	}
 }
 
-- 
1.6.0.4

