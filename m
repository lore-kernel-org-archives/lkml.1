Return-Path: <linux-kernel-owner+w=401wt.eu-S1752016AbXCEWum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbXCEWum (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbXCEWum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:50:42 -0500
Received: from [198.99.130.12] ([198.99.130.12]:49604 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbXCEWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:50:40 -0500
Message-Id: <200703052241.l25MfKju008425@ccure.user-mode-linux.org>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.0.4
To: akpm@osdl.org
cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH 1/4] linux/audit.h needs linux/types.h
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 05 Mar 2007 17:41:20 -0500
From: Jeff Dike <jdike@addtoit.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/types.h here because we need a definition of __u32.  This file
appears not be exported verbatim by libc, so I think this doesn't have any
userspace consequences.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 include/linux/audit.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.18-mm/include/linux/audit.h
===================================================================
--- linux-2.6.18-mm.orig/include/linux/audit.h	2007-02-20 16:16:03.000000000 -0500
+++ linux-2.6.18-mm/include/linux/audit.h	2007-02-20 16:16:25.000000000 -0500
@@ -24,6 +24,7 @@
 #ifndef _LINUX_AUDIT_H_
 #define _LINUX_AUDIT_H_
 
+#include <linux/types.h>
 #include <linux/elf-em.h>
 
 /* The netlink messages for the audit system is divided into blocks:

