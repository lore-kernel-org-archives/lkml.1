Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZBBWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZBBWjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 17:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZBBWjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 17:39:09 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:51891 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbZBBWjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 17:39:08 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: Give the right path in Documentation example
Date: Mon,  2 Feb 2009 20:39:36 -0200
Message-Id: <1233614376-27654-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While the Documentation example creates /cgroup/test, it removes
/test/cgroup, which is clearly not the intended path. Change that to
/cgroup/test.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/cgroups/memcg_test.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/memcg_test.txt b/Documentation/cgroups/memcg_test.txt
index 523a9c1..a926359 100644
--- a/Documentation/cgroups/memcg_test.txt
+++ b/Documentation/cgroups/memcg_test.txt
@@ -356,7 +356,7 @@ Under below explanation, we assume CONFIG_MEM_RES_CTRL_SWAP=y.
 	(Shell-B)
 	# move all tasks in /cgroup/test to /cgroup
 	# /sbin/swapoff -a
-	# rmdir /test/cgroup
+	# rmdir /cgroup/test
 	# kill malloc task.
 
 	Of course, tmpfs v.s. swapoff test should be tested, too.
-- 
1.6.0.6

