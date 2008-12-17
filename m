Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757551AbYLQL0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYLQL0I (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYLQLZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:25:54 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50323 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbYLQLZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:25:53 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] profile: don't include <asm/ptrace.h> twice.
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20081217202505.FF20.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Wed, 17 Dec 2008 20:25:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


==
Subject: [PATCH] profile: don't include <asm/ptrace.h> twice.

Currently, kernel/profile.c include <asm/ptrace.h> twice.
it can be removed.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/profile.c |    1 -
 1 file changed, 1 deletion(-)

Index: b/kernel/profile.c
===================================================================
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -437,7 +437,6 @@ void profile_tick(int type)
 #ifdef CONFIG_PROC_FS
 #include <linux/proc_fs.h>
 #include <asm/uaccess.h>
-#include <asm/ptrace.h>
 
 static int prof_cpu_mask_read_proc(char *page, char **start, off_t off,
 			int count, int *eof, void *data)


