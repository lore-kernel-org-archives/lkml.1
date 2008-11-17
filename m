Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYKQEkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYKQEkm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 23:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755988AbYKQEkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 23:40:33 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45728 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755878AbYKQEkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 23:40:32 -0500
Date: Mon, 17 Nov 2008 10:10:08 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Fix typo in swap cgroup message
Message-ID: <20081117044008.GA25269@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Pavel Emelyanov <xemul@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is a typo in the spelling of buffers (buffres) and the message is
not very clear either. Fix the message and typo (hopefully not introducing
any new ones ;) )

Cc: Hugh Dickins <hugh@veritas.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/page_cgroup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_cgroup.c~fix-typo-swap-cgroup mm/page_cgroup.c
--- linux-2.6.28-rc4/mm/page_cgroup.c~fix-typo-swap-cgroup	2008-11-16 20:03:28.000000000 +0530
+++ linux-2.6.28-rc4-balbir/mm/page_cgroup.c	2008-11-17 09:59:43.000000000 +0530
@@ -423,7 +423,8 @@ int swap_cgroup_swapon(int type, unsigne
 	mutex_unlock(&swap_cgroup_mutex);
 
 	printk(KERN_INFO
-		"swap_cgroup: uses %ld bytes vmalloc and %ld bytes buffres\n",
+		"swap_cgroup: uses %ld bytes of vmalloc for pointer array space"
+		" and %ld bytes to hold mem_cgroup pointers on swap\n",
 		array_size, length * PAGE_SIZE);
 	printk(KERN_INFO
 	"swap_cgroup can be disabled by noswapaccount boot option.\n");
_

-- 
	Balbir
