Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYGHWCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYGHWCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbYGHWCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:02:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56155 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbYGHWCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:02:11 -0400
Subject: [PATCH] kernel/printk.c: Made printk_recursion_bug_msg static.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
Content-Type: text/plain
Date: Tue, 08 Jul 2008 15:02:06 -0700
Message-Id: <1215554526.10304.10.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 8fb01c3..e2129e8 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -666,7 +666,7 @@ static int acquire_console_semaphore_for_printk(unsigned int cpu)
 	return retval;
 }
 
-const char printk_recursion_bug_msg [] =
+static const char printk_recursion_bug_msg [] =
 			KERN_CRIT "BUG: recent printk recursion!\n";
 static int printk_recursion_bug;
 
-- 
1.5.4.3

