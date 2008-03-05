Return-Path: <linux-kernel-owner+w=401wt.eu-S932804AbYCEMEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbYCEMEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYCEMAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:00:18 -0500
Received: from sacred.ru ([62.205.161.221]:59477 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172AbYCEMAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:00:17 -0500
Message-ID: <47CE8642.7080002@openvz.org>
Date: Wed, 05 Mar 2008 14:38:42 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Memcontrol: remove a stray ` sign from comment.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 05 Mar 2008 14:38:40 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It got there accidentally :)

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 631002d..887155b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -884,7 +884,7 @@ int mem_cgroup_force_empty(struct mem_cgroup *mem)
 	css_get(&mem->css);
 	/*
 	 * page reclaim code (kswapd etc..) will move pages between
-`	 * active_list <-> inactive_list while we don't take a lock.
+	 * active_list <-> inactive_list while we don't take a lock.
 	 * So, we have to do loop here until all lists are empty.
 	 */
 	while (mem->res.usage > 0) {
