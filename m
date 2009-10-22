Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZJVOHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZJVOHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 10:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZJVOHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 10:07:18 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:30718 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753334AbZJVOHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 10:07:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0EAOMD4ErCTtAn/2dsb2JhbACBUtl0hD8E
Date: Thu, 22 Oct 2009 16:07:17 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cleanup remove obsolete comment about map_chunk
Message-ID: <20091022140717.GB27903@frolo.macqel>
References: <20091022135454.GA27903@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022135454.GA27903@frolo.macqel>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Remove the comments referring to a function map_chunk that no longer exists.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff --git a/arch/h8300/mm/memory.c b/arch/h8300/mm/memory.c
--- a/arch/h8300/mm/memory.c
+++ b/arch/h8300/mm/memory.c
@@ -44,8 +44,8 @@ void cache_push_v (unsigned long vaddr, 
 {
 }
 
-/* Map some physical address range into the kernel address space. The
- * code is copied and adapted from map_chunk().
+/*
+ * Map some physical address range into the kernel address space.
  */
 
 unsigned long kernel_map(unsigned long paddr, unsigned long size,
diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -99,8 +99,7 @@ static inline void free_io_area(void *ad
 #endif
 
 /*
- * Map some physical address range into the kernel address space. The
- * code is copied and adapted from map_chunk().
+ * Map some physical address range into the kernel address space.
  */
 /* Rewritten by Andreas Schwab to remove all races. */
 
diff --git a/arch/m68knommu/mm/memory.c b/arch/m68knommu/mm/memory.c
--- a/arch/m68knommu/mm/memory.c
+++ b/arch/m68knommu/mm/memory.c
@@ -24,7 +24,6 @@
 
 /*
  * Map some physical address range into the kernel address space.
- * The code is copied and adapted from map_chunk().
  */
 
 unsigned long kernel_map(unsigned long paddr, unsigned long size,
