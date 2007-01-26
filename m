Return-Path: <linux-kernel-owner+w=401wt.eu-S1030709AbXAZQrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030709AbXAZQrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:47:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030758AbXAZQrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:47:45 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:35417 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030709AbXAZQrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:47:43 -0500
Date: Fri, 26 Jan 2007 17:47:40 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] Remove pointless/unreliable kernel messages.
Message-ID: <20070126164740.GD11609@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] Remove pointless/unreliable kernel messages.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/setup.c |    3 ---
 arch/s390/mm/init.c      |    2 --
 2 files changed, 5 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/setup.c linux-2.6-patched/arch/s390/kernel/setup.c
--- linux-2.6/arch/s390/kernel/setup.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/setup.c	2007-01-26 17:27:48.000000000 +0100
@@ -492,9 +492,6 @@ static void __init setup_memory_end(void
 	}
 	if (!memory_end)
 		memory_end = memory_size;
-	if (real_size > memory_end)
-		printk("More memory detected than supported. Unused: %luk\n",
-		       (real_size - memory_end) >> 10);
 }
 
 static void __init
diff -urpN linux-2.6/arch/s390/mm/init.c linux-2.6-patched/arch/s390/mm/init.c
--- linux-2.6/arch/s390/mm/init.c	2007-01-26 17:27:47.000000000 +0100
+++ linux-2.6-patched/arch/s390/mm/init.c	2007-01-26 17:27:48.000000000 +0100
@@ -175,8 +175,6 @@ void __init mem_init(void)
 	printk("Write protected kernel read-only data: %#lx - %#lx\n",
 	       (unsigned long)&__start_rodata,
 	       PFN_ALIGN((unsigned long)&__end_rodata) - 1);
-	printk("Virtual memmap size: %ldk\n",
-	       (max_pfn * sizeof(struct page)) >> 10);
 }
 
 void free_initmem(void)
