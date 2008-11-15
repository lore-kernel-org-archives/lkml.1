Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbYKOEST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbYKOEST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 23:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYKOESL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 23:18:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49585 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYKOESK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 23:18:10 -0500
Date: Sat, 15 Nov 2008 13:17:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: mmotm 2008-11-14-17-14 uploaded
Message-Id: <20081115131728.3582dadc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081115131143.9af8e8aa.kamezawa.hiroyu@jp.fujitsu.com>
References: <200811150115.mAF1FDpD010853@imap1.linux-foundation.org>
	<20081115131143.9af8e8aa.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, again.
a fix for memcg-add-mem_cgroup_disabled-fix.patch
please ignore previous mail...

==

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: mmotm-2.6.28-Nov14/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Nov14.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Nov14/include/linux/memcontrol.h
@@ -19,7 +19,7 @@
 
 #ifndef _LINUX_MEMCONTROL_H
 #define _LINUX_MEMCONTROL_H
-
+#include <linux/cgroup.h>
 struct mem_cgroup;
 struct page_cgroup;
 struct page;
Index: mmotm-2.6.28-Nov14/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov14.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov14/mm/memcontrol.c
@@ -301,7 +301,7 @@ void mem_cgroup_rotate_lru_list(struct p
 	struct mem_cgroup_per_zone *mz;
 	struct page_cgroup *pc;
 
-	if (mem_cgroup_diabled())
+	if (mem_cgroup_disabled())
 		return;
 
 	pc = lookup_page_cgroup(page);

