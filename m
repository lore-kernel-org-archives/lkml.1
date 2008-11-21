Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbYKUEAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbYKUEAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 23:00:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbYKUD7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 22:59:23 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49467 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756495AbYKUD7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 22:59:22 -0500
Message-ID: <49263218.1090305@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:59:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] memcg: fix a typo in Kconfig
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/contoller/controller

Signed-of-by: Li Zefan <lizf@cn.fujitsu.com>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index f763762..8767393 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -414,7 +414,7 @@ config CGROUP_MEM_RES_CTLR
 	  sure you need the memory resource controller. Even when you enable
 	  this, you can set "cgroup_disable=memory" at your boot option to
 	  disable memory resource controller and you can avoid overheads.
-	  (and lose benefits of memory resource contoller)
+	  (and lose benefits of memory resource controller)
 
 	  This config option also selects MM_OWNER config option, which
 	  could in turn add some fork/exit overhead.
-- 
1.5.4.rc3

