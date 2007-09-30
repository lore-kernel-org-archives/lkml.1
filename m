Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXI3K0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXI3K0U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 06:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXI3K0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 06:26:14 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3564 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbXI3K0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 06:26:13 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel/fork.c: remove unneeded variable initialization in copy_process()
Date: Sun, 30 Sep 2007 12:26:02 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709301226.03656.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This initialization of is not needed so just remove it.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 kernel/fork.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc8-mm2-a/kernel/fork.c	2007-09-27 11:31:23.000000000 +0200
+++ linux-2.6.23-rc8-mm2-b/kernel/fork.c	2007-09-30 11:26:12.000000000 +0200
@@ -981,7 +981,7 @@ static struct task_struct *copy_process(
 					struct pid *pid)
 {
 	int retval;
-	struct task_struct *p = NULL;
+	struct task_struct *p;
 	int cgroup_callbacks_done = 0;

 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
