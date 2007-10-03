Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbXJCNWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbXJCNWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXJCNWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:22:31 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:55772 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbXJCNWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:22:30 -0400
X-Originating-Ip: 99.236.101.138
Date: Wed, 3 Oct 2007 09:18:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, trivial@kernel.org
Subject: [PATCH] DOC:  Correct explanations of "find_next" bit routines.
Message-ID: <Pine.LNX.4.64.0710030916410.27061@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Correct the obvious "copy and paste" errors explaining some of the
"find_next" routines.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

 arch/i386/lib/bitops.c    |    2 +-
 arch/x86_64/lib/bitops.c  |    2 +-
 include/asm-i386/bitops.h |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/i386/lib/bitops.c b/arch/i386/lib/bitops.c
index afd0045..b654404 100644
--- a/arch/i386/lib/bitops.c
+++ b/arch/i386/lib/bitops.c
@@ -2,7 +2,7 @@
 #include <linux/module.h>

 /**
- * find_next_bit - find the first set bit in a memory region
+ * find_next_bit - find the next set bit in a memory region
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
diff --git a/arch/x86_64/lib/bitops.c b/arch/x86_64/lib/bitops.c
index 95b6d96..0e8f491 100644
--- a/arch/x86_64/lib/bitops.c
+++ b/arch/x86_64/lib/bitops.c
@@ -58,7 +58,7 @@ long find_first_zero_bit(const unsigned long * addr, unsigned long size)
 }

 /**
- * find_next_zero_bit - find the first zero bit in a memory region
+ * find_next_zero_bit - find the next zero bit in a memory region
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
index a20fe98..700b1a2 100644
--- a/include/asm-i386/bitops.h
+++ b/include/asm-i386/bitops.h
@@ -1,4 +1,3 @@
-#ifndef _I386_BITOPS_H
 #define _I386_BITOPS_H

 /*
@@ -297,7 +296,7 @@ static inline int find_first_zero_bit(const unsigned long *addr, unsigned size)
 }

 /**
- * find_next_zero_bit - find the first zero bit in a memory region
+ * find_next_zero_bit - find the next zero bit in a memory region
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
@@ -340,7 +339,7 @@ static inline unsigned find_first_bit(const unsigned long *addr, unsigned size)
 }

 /**
- * find_next_bit - find the first set bit in a memory region
+ * find_next_bit - find the next set bit in a memory region
  * @addr: The address to base the search on
  * @offset: The bitnumber to start searching at
  * @size: The maximum size to search
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
