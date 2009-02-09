Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZBIN0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZBIN0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:26:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbZBIN0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:26:24 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:27150 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbZBIN0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:26:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:from:to:cc:bcc:subject:date:user-agent;
        b=nnM6XKX8FXc0NzArkwBDBqOESWBPDwaWIb8cFLFTt/bHjULauPhy/nki5I9h629oYT
         1bVIZ0hZwTPmGGs5u79VGVy+FsDvVqqAr+koJ8yzhRBnIqErfXgFKNQRoyDUuWTsxAn7
         ok/WZkBFy61tuX6o7JhtLoO4/ZhqVhpc7TrN4=
Message-ID: <49902efb.0e1b6e0a.664d.ffff80b7@mx.google.com>
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH] : cleanup kernel-doc
Date: Mon, 9 Feb 2009 21:26:16 +0800
User-Agent: sniper-patch-carrier/1.06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant argument comment.

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 790f9d7..590e77f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2709,7 +2709,6 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file
  * @filp: the file structure
  * @buffer: the user buffer
  * @lenp: the size of the user buffer
- * @ppos: file position
  * @ppos: the current position in the file
  *
  * Reads/writes up to table->maxlen/sizeof(unsigned int) integer

