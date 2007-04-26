Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbXDZXs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbXDZXs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755235AbXDZXry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:47:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35855 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755260AbXDZXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:47:41 -0400
Date: Fri, 27 Apr 2007 01:47:52 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make arch/i386/kernel/setup.c:remapped_pgdat_init()
	static
Message-ID: <20070426234752.GK3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global remapped_pgdat_init() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch has been sent on:
- 27 Mar 2007

--- linux-2.6.21-rc4-mm1/arch/i386/kernel/setup.c.old	2007-03-26 15:53:44.000000000 +0200
+++ linux-2.6.21-rc4-mm1/arch/i386/kernel/setup.c	2007-03-26 15:54:00.000000000 +0200
@@ -476,7 +476,7 @@
  *
  * This should all compile down to nothing when NUMA is off.
  */
-void __init remapped_pgdat_init(void)
+static void __init remapped_pgdat_init(void)
 {
 	int nid;
 

