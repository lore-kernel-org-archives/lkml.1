Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYJUF73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYJUF73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 01:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbYJUF7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 01:59:20 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:49456 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbYJUF7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 01:59:19 -0400
Date: Tue, 21 Oct 2008 11:21:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nishimura@mxp.nes.nec.co.jp
Subject: memcg: Fix init/Kconfig documentation
Message-ID: <20081021055118.GA11429@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	nishimura@mxp.nes.nec.co.jp
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balbir Singh <balbir@linux.vnet.ibm.com>
Date: Tue, 21 Oct 2008 11:12:45 +0530
Subject: [PATCH] memcg: Update Kconfig to remove the struct page overhead statement.

The memory resource controller no longer has a struct page overhead
associated with it. The init/Kconfig help has been replaced with
something more suitable based on the current implementation.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---
 init/Kconfig |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 113c74c..1847f87 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -404,13 +404,10 @@ config CGROUP_MEM_RES_CTLR
 	  Provides a memory resource controller that manages both page cache and
 	  RSS memory.
 
-	  Note that setting this option increases fixed memory overhead
-	  associated with each page of memory in the system by 4/8 bytes
-	  and also increases cache misses because struct page on many 64bit
-	  systems will not fit into a single cache line anymore.
-
-	  Only enable when you're ok with these trade offs and really
-	  sure you need the memory resource controller.
+	  The config option adds a small memory overhead proportional to the
+	  size of memory. The controller can be disabled at run time by
+	  using the cgroup_disable=memory option, at which point the overhead
+	  disappears.
 
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
-- 
1.5.6.3


        Balbir
