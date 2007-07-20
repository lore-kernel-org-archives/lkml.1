Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbXGTMN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbXGTMN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 08:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXGTMNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 08:13:18 -0400
Received: from ozlabs.org ([203.10.76.45]:49184 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbXGTMNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 08:13:14 -0400
Subject: [PATCH 2/3] lguest: trivial: We now have asm/processor-flags.h, so
	use it.
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <1184933473.10380.296.camel@localhost.localdomain>
References: <1184933473.10380.296.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 20 Jul 2007 22:12:56 +1000
Message-Id: <1184933576.10380.299.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f41cd1b8d7ef drivers/lguest/lguest_asm.S
--- a/drivers/lguest/lguest_asm.S	Fri Jul 20 13:46:40 2007 +1000
+++ b/drivers/lguest/lguest_asm.S	Fri Jul 20 14:17:04 2007 +1000
@@ -2,9 +2,7 @@
 #include <linux/lguest.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
-
-/* FIXME: Once asm/processor-flags.h goes in, include that */
-#define X86_EFLAGS_IF 0x00000200
+#include <asm/processor-flags.h>
 
 /*
  * This is where we begin: we have a magic signature which the launcher looks


