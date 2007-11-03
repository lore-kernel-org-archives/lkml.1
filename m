Return-Path: <linux-kernel-owner+w=401wt.eu-S1764370AbXKCAT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764370AbXKCAT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 20:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932079AbXKCAEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 20:04:44 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57897 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932081AbXKCAEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 20:04:43 -0400
Date: Sat, 3 Nov 2007 01:04:19 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] fs/utimes.c should #include <linux/syscalls.h>
Message-ID: <20071103000419.GD4594@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
feb4aef9f140af882175ca5fddee3fb1058105f9 
diff --git a/fs/utimes.c b/fs/utimes.c
index b9912ec..e5588cd 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -6,6 +6,7 @@
 #include <linux/sched.h>
 #include <linux/stat.h>
 #include <linux/utime.h>
+#include <linux/syscalls.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 

