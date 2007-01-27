Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbXA0IY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbXA0IY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbXA0IYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:31 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34891 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751263AbXA0IY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:26 -0500
Message-ID: <369886264.20106@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082529.796556490@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:24 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] readahead: initial method: user recommended size: rename to read_ahead_initial_kb
Content-Disposition: inline; filename=readahead-initial-method-user-recommended-size-rename-to-read_ahead_initial_kb.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the sysfs parameter initial_ra_kb to read_ahead_initial_kb,
which hopefully is a more consistent and user friendly name.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 block/ll_rw_blk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-rc4-mm1.orig/block/ll_rw_blk.c
+++ linux-2.6.20-rc4-mm1/block/ll_rw_blk.c
@@ -3992,7 +3992,7 @@ static struct queue_sysfs_entry queue_ra
 };
 
 static struct queue_sysfs_entry queue_initial_ra_entry = {
-	.attr = {.name = "initial_ra_kb", .mode = S_IRUGO | S_IWUSR },
+	.attr = {.name = "read_ahead_initial_kb", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_initial_ra_show,
 	.store = queue_initial_ra_store,
 };

--
