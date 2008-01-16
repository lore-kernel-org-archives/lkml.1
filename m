Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYAPA3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYAPA3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbYAPA3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:29:38 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:25126 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751379AbYAPA3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:29:37 -0500
Date: Tue, 15 Jan 2008 17:30:18 -0700
From: dougthompson@xmission.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] drivers edac i3000 document type promotion
Message-ID: <478d501a.Y76I0VJGkMZyz9aA%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Uhlenkott <juhlenko@akamai.com>

Applied to 2.6.24-rc6-mm1

By popular request, add a comment documenting the implicit type
promotion here.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com?
---
 i3000_edac.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/drivers/edac/i3000_edac.c
===================================================================
--- linux.orig/drivers/edac/i3000_edac.c	2008-01-14 15:16:11.137167678 -0800
+++ linux/drivers/edac/i3000_edac.c	2008-01-14 15:16:13.387855416 -0800
@@ -44,6 +44,13 @@
 				 */
 #define I3000_DEAP_GRAIN 		(1 << 7)
 
+/*
+ * Helper functions to decode the DEAP/EDEAP hardware registers.
+ *
+ * The type promotion here is deliberate; we're deriving an
+ * unsigned long pfn and offset from hardware regs which are u8/u32.
+ */
+
 static inline unsigned long deap_pfn(u8 edeap, u32 deap)
 {
 	deap >>= PAGE_SHIFT;

