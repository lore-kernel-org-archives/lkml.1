Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936267Ab0BZNje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:39:34 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51097 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936237Ab0BZNjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:39:33 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: linux-mm@kvack.org
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] memcg: fix typos in memcg_test.txt
Date: Fri, 26 Feb 2010 15:39:16 +0200
Message-Id: <1267191557-23444-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 Documentation/cgroups/memcg_test.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 4d32e0e..f7f68b2 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -337,7 +337,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	race and lock dependency with other cgroup subsystems.
 
 	example)
-	# mount -t cgroup none /cgroup -t cpuset,memory,cpu,devices
+	# mount -t cgroup none /cgroup -o cpuset,memory,cpu,devices
 
 	and do task move, mkdir, rmdir etc...under this.
 
@@ -348,7 +348,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 
 	For example, test like following is good.
 	(Shell-A)
-	# mount -t cgroup none /cgroup -t memory
+	# mount -t cgroup none /cgroup -o memory
 	# mkdir /cgroup/test
 	# echo 40M > /cgroup/test/memory.limit_in_bytes
 	# echo 0 > /cgroup/test/tasks
-- 
1.6.6.2

