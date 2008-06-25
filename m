Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYFYQ3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYFYQ3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760247AbYFYQ1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:46 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:59418 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758727AbYFYQ1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:45 -0400
Date: Wed, 25 Jun 2008 19:25:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make register_page_bootmem_info_section() static
Message-ID: <20080625162540.GI10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global 
register_page_bootmem_info_section() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 5 May 2008

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

