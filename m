Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYBMVcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYBMVcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762850AbYBMV35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:29:57 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47459 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYBMV34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:29:56 -0500
Date: Wed, 13 Feb 2008 23:29:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
       coreteam@netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make secmark_tg_destroy() static
Message-ID: <20080213212940.GH3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global secmark_tg_destroy() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
df66d8d74309b41298ae011532fd284aad3ed2ba 
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 7708e20..c028485 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -111,7 +111,7 @@ secmark_tg_check(const char *tablename, const void *entry,
 	return true;
 }
 
-void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
+static void secmark_tg_destroy(const struct xt_target *target, void *targinfo)
 {
 	switch (mode) {
 	case SECMARK_MODE_SEL:

