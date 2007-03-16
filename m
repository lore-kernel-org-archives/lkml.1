Return-Path: <linux-kernel-owner+w=401wt.eu-S965900AbXCPU2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965900AbXCPU2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:28:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965895AbXCPU2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:28:10 -0400
Received: from gw.goop.org ([64.81.55.164]:56999 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965900AbXCPU2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:28:08 -0400
Message-ID: <45FAFDD3.6080400@goop.org>
Date: Fri, 16 Mar 2007 13:28:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: [PATCH] Fix typo in sync_constant_test_bit()'s name.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in sync_constant_test_bit()'s name, so sync_bitops.h is consistent with bitops.h

[ Linus, please apply.  Thanks -J ]

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Ingo Molnar <mingo@elte.hu>

---
 include/asm-i386/sync_bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/include/asm-i386/sync_bitops.h
+++ b/include/asm-i386/sync_bitops.h
@@ -130,7 +130,7 @@ static inline int sync_test_and_change_b
 	return oldbit;
 }
 
-static __always_inline int sync_const_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int sync_constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr & 31)) &
 		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;


