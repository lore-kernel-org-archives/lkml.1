Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbXEaSN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbXEaSN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760918AbXEaSNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:13:14 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:33881 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760784AbXEaSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:13:13 -0400
Date: Thu, 31 May 2007 14:04:29 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] syslet demos - add more includes
Message-ID: <20070531180429.GA9782@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a bunch of includes to sys.h and syslet.h to kill off compilation warnings.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 sys.h    |    7 +++++++
 syslet.h |    2 ++
 2 files changed, 9 insertions(+)

Index: async-test-v5/sys.h
===================================================================
--- async-test-v5.orig/sys.h	2007-02-28 14:32:16.000000000 -0500
+++ async-test-v5/sys.h	2007-05-31 13:29:57.000000000 -0400
@@ -1,5 +1,12 @@
 
 #include <assert.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/syscall.h>
+#include <sys/time.h>
+#include <sys/types.h>
+
+#include "syslet.h"
 
 #if DEBUG
 # define pr(x...) do { printf("%d: ", sys_gettid()); printf(x); fflush(stdout); } while (0)
Index: async-test-v5/syslet.h
===================================================================
--- async-test-v5.orig/syslet.h	2007-02-28 14:32:16.000000000 -0500
+++ async-test-v5/syslet.h	2007-05-30 12:32:44.000000000 -0400
@@ -10,6 +10,8 @@
  * User-space API/ABI definitions:
  */
 
+#include "common.h"
+
 #ifndef __user
 # define __user
 #endif
