Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYE3UDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYE3UDU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 16:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbYE3UCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 16:02:40 -0400
Received: from saeurebad.de ([85.214.36.134]:60844 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbYE3UCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 16:02:39 -0400
Message-Id: <20080530194737.546890386@saeurebad.de>
References: <20080530194220.286976884@saeurebad.de>
User-Agent: quilt/0.46-1
Date: Fri, 30 May 2008 21:42:22 +0200
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH -mm 02/14] bootmem: clean up bootmem.c file header
Content-Disposition: inline; filename=bootmem-adjust-file-header.patch
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

