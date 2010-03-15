Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935595Ab0CODTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:19:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53428 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759597Ab0CODTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:19:24 -0400
Message-ID: <4B9DA778.7080305@cn.fujitsu.com>
Date: Mon, 15 Mar 2010 11:20:24 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: [PATCH] cgroups: remove duplicate include
References: <4B9DA6E4.4020501@cn.fujitsu.com>
In-Reply-To: <4B9DA6E4.4020501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e6a1105b ("cgroups: subsystem module loading interface")
and commit c50cc752 ("sched, cgroups: Fix module export")
result in duplicate including of module.h

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

Fix changelog...

---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ef909a3..e2769e1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/cgroup.h>
-#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-- 
1.6.3
