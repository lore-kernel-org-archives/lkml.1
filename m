Return-Path: <linux-kernel-owner+w=401wt.eu-S1760728AbYBQIZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760728AbYBQIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 03:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbYBQIVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 03:21:15 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:34088 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007AbYBQIVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 03:21:14 -0500
Date: Sun, 17 Feb 2008 10:20:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/proc/kmsg.c should #include <linux/proc_fs.h>
Message-ID: <20080217082048.GW3848@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs its global 
code (in this case for struct proc_kmsg_operations).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b6f818ea9e2dd76d3fd7dbec2382240cabe66a6b diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index ff3b90b..9fa3a3d 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/poll.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>

