Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbZKTNmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbZKTNmm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZKTNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:42:42 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:28527 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZKTNml convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;3:1>);
	Fri, 20 Nov 2009 08:42:41 -0500
Message-Id: <4B06AAE802000078000211CC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 20 Nov 2009 13:42:48 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <linux-mm@kvack.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] properly __init-annotate bootmem helper functions
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 mm/bootmem.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.32-rc8/mm/bootmem.c	2009-11-20 14:11:50.000000000 +0100
+++ 2.6.32-rc8-bootmem-align-functions/mm/bootmem.c	2009-11-20 11:23:52.000000000 +0100
@@ -408,8 +408,8 @@ int __init reserve_bootmem(unsigned long
 	return mark_bootmem(start, end, 1, flags);
 }
 
-static unsigned long align_idx(struct bootmem_data *bdata, unsigned long idx,
-			unsigned long step)
+static unsigned long __init align_idx(struct bootmem_data *bdata,
+				      unsigned long idx, unsigned long step)
 {
 	unsigned long base = bdata->node_min_pfn;
 
@@ -421,8 +421,8 @@ static unsigned long align_idx(struct bo
 	return ALIGN(base + idx, step) - base;
 }
 
-static unsigned long align_off(struct bootmem_data *bdata, unsigned long off,
-			unsigned long align)
+static unsigned long __init align_off(struct bootmem_data *bdata,
+				      unsigned long off, unsigned long align)
 {
 	unsigned long base = PFN_PHYS(bdata->node_min_pfn);
 



