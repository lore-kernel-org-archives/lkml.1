Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYBQIYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYBQIYm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758383AbYBQIVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:21:06 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34082 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbYBQIVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:21:04 -0500
Date: Sun, 17 Feb 2008 10:20:38 +0200
From: Adrian Bunk <bunk@kernel.org>
To: mark.fasheh@oracle.com, kurt.hackel@oracle.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make ocfs2_downconvert_thread() static
Message-ID: <20080217082038.GU3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global ocfs2_downconvert_thread() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bdbb7c3c448132142fffd0fbb8dc71f5a9efb594 diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 351130c..841df58 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3356,7 +3356,7 @@ static int ocfs2_downconvert_thread_should_wake(struct ocfs2_super *osb)
 	return should_wake;
 }
 
-int ocfs2_downconvert_thread(void *arg)
+static int ocfs2_downconvert_thread(void *arg)
 {
 	int status = 0;
 	struct ocfs2_super *osb = arg;

