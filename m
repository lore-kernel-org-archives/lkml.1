Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbYJ3BDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbYJ3BDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYJ3BD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:03:28 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:26169 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbYJ3BD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:03:27 -0400
Message-ID: <490907DE.2030502@ct.jp.nec.com>
Date: Wed, 29 Oct 2008 18:03:26 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] add include list.h in binfmts.h
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

linux_binfmt uses list_head, so list.h is needed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/linux/binfmts.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 7394b5b..06c1123 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_BINFMTS_H
 #define _LINUX_BINFMTS_H
 
+#include <linux/list.h>
 #include <linux/capability.h>
 
 struct pt_regs;
-- 
1.5.6

