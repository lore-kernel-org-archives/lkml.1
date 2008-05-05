Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbYEES06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbYEES06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbYEESYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:24:55 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54859 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760167AbYEESYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:24:54 -0400
Date: Mon, 5 May 2008 21:23:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make register_page_bootmem_info_section() static
Message-ID: <20080505182347.GJ17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global 
register_page_bootmem_info_section() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
070dc3db481a222a79755b6a06fb300f022ff56e diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b3fd604..6a9a28a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -86,7 +86,7 @@ void put_page_bootmem(struct page *page)
 
 }
 
-void register_page_bootmem_info_section(unsigned long start_pfn)
+static void register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long *usemap, mapsize, section_nr, i;
 	struct mem_section *ms;

