Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbXGTSkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbXGTSkG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbXGTSj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:39:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50859 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbXGTSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:39:55 -0400
Subject: [PATCH] i386: include asm/bugs.h in bugs.c for check_bugs prototype
From: Josh Triplett <josh@kernel.org>
Reply-To: josh@kernel.org, josht@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:39:34 -0700
Message-Id: <1184956774.2630.7.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

C files should include the header files that prototype their functions.

Eliminates a sparse warning:
warning: symbol 'check_bugs' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 arch/i386/kernel/cpu/bugs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/cpu/bugs.c b/arch/i386/kernel/cpu/bugs.c
index 54428a2..59266f0 100644
--- a/arch/i386/kernel/cpu/bugs.c
+++ b/arch/i386/kernel/cpu/bugs.c
@@ -11,6 +11,7 @@
  */
 #include <linux/init.h>
 #include <linux/utsname.h>
+#include <asm/bugs.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/msr.h>
-- 
1.5.2.1


