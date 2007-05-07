Return-Path: <linux-kernel-owner+w=401wt.eu-S966554AbXEGUZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966554AbXEGUZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966540AbXEGUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:25:33 -0400
Received: from [198.99.130.12] ([198.99.130.12]:60204 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXEGUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:25:30 -0400
Date: Mon, 7 May 2007 16:20:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/5] UML - Fix build breakage
Message-ID: <20070507202017.GA8506@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UML now needs required-features.h to build - an empty one suffices.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/asm-um/required-features.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.21-mm/include/asm-um/required-features.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-mm/include/asm-um/required-features.h	2007-05-07 15:01:39.000000000 -0400
@@ -0,0 +1,9 @@
+#ifndef __UM_REQUIRED_FEATURES_H
+#define __UM_REQUIRED_FEATURES_H
+
+/*
+ * Nothing to see, just need something for the i386 and x86_64 asm
+ * headers to include.
+ */
+
+#endif
