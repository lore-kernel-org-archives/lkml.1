Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbYB1GqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbYB1GqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 01:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756486AbYB1Gpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 01:45:44 -0500
Received: from host106.paramount.wayport.net ([65.249.24.106]:52725 "EHLO
	honeydew.int.wil.cx" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751605AbYB1Gpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 01:45:43 -0500
X-Greylist: delayed 690 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2008 01:45:43 EST
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 09/12] lib: Remove unnecessary inclusions of asm/semaphore.h
Date: Thu, 28 Feb 2008 01:33:58 -0500
Message-Id: <1204180441-8540-9-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204180441-8540-8-git-send-email-matthew@wil.cx>
References: <20080227003605.GC5715@parisc-linux.org>
 <1204180441-8540-1-git-send-email-matthew@wil.cx>
 <1204180441-8540-2-git-send-email-matthew@wil.cx>
 <1204180441-8540-3-git-send-email-matthew@wil.cx>
 <1204180441-8540-4-git-send-email-matthew@wil.cx>
 <1204180441-8540-5-git-send-email-matthew@wil.cx>
 <1204180441-8540-6-git-send-email-matthew@wil.cx>
 <1204180441-8540-7-git-send-email-matthew@wil.cx>
 <1204180441-8540-8-git-send-email-matthew@wil.cx>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reed_solomon doesn't use any of the functionality promised by
asm/semaphore.h.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 lib/reed_solomon/reed_solomon.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/lib/reed_solomon/reed_solomon.c b/lib/reed_solomon/reed_solomon.c
index 3ea2db9..06d04cf 100644
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -45,7 +45,6 @@
 #include <linux/rslib.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <asm/semaphore.h>
 
 /* This list holds all currently allocated rs control structures */
 static LIST_HEAD (rslist);
-- 
1.5.4.1

