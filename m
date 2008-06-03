Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbYFCB6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbYFCB6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 21:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbYFCB6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 21:58:11 -0400
Received: from saeurebad.de ([85.214.36.134]:39462 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYFCB6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 21:58:09 -0400
X-Mailbox-Line: From hannes@saeurebad.de Tue Jun  3 02:53:02 2008
Message-Id: <20080603005302.749879327@saeurebad.de>
References: <20080603005017.593345596@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jun 2008 02:50:19 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, Yasunori Goto <y-goto@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 02/14] bootmem: clean up bootmem.c file header
Content-Disposition: inline; filename=bootmem-adjust-file-header.patch
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the description, move a misplaced comment about the allocator
itself and add me to the list of copyright holders.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
CC: Ingo Molnar <mingo@elte.hu>
---

 mm/bootmem.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -1,12 +1,12 @@
 /*
- *  linux/mm/bootmem.c
+ *  bootmem - A boot-time physical memory allocator and configurator
  *
  *  Copyright (C) 1999 Ingo Molnar
- *  Discontiguous memory support, Kanoj Sarcar, SGI, Nov 1999
+ *                1999 Kanoj Sarcar, SGI
+ *                2008 Johannes Weiner
  *
- *  simple boot-time physical memory area allocator and
- *  free memory collector. It's used to deal with reserved
- *  system memory and memory holes as well.
+ * Access to this subsystem has to be serialized externally (which is true
+ * for the boot process anyway).
  */
 #include <linux/init.h>
 #include <linux/pfn.h>
@@ -19,10 +19,6 @@
 
 #include "internal.h"
 
-/*
- * Access to this subsystem has to be serialized externally. (this is
- * true for the boot process anyway)
- */
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;

-- 

