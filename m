Return-Path: <linux-kernel-owner+w=401wt.eu-S1765251AbYDNSPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765251AbYDNSPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764956AbYDNSOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:14:36 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49287 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764954AbYDNSOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:14:35 -0400
Date: Mon, 14 Apr 2008 21:13:29 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/proc/kmsg.c should #include <linux/proc_fs.h>
Message-ID: <20080414181329.GD6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs its global 
code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 17 Feb 2008

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

