Return-Path: <linux-kernel-owner+w=401wt.eu-S1752215AbYLYLRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215AbYLYLRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 06:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYLYLRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 06:17:00 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:40451 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbYLYLQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 06:16:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OmbvG7KtTLvo+rclzNrvgYOFktxe4DI+kW3XuU8lhJNrscyqUcIEH3rwJJVtJupLzy
         jJGyrr55BLkmL/q0ttv91/rJ+CX/ypSlNFtwWNIvl71+4QX1PtcMGMPcoUma/tNvHFkk
         JELnw2QKz3cddo4J0LrI4kjsdZJGjw5tzK/MU=
Date: Thu, 25 Dec 2008 19:15:31 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] fs/proc/base.c: remove a useless local variable
Message-ID: <20081225191531.GB3130@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Remove a useless variable 'inode' in proc_pident_lookup().

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>


---
diff --git a/fs/proc/base.c b/fs/proc/base.c
index d467760..966603e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1960,13 +1960,11 @@ static struct dentry *proc_pident_lookup(struct inode *dir,
 					 const struct pid_entry *ents,
 					 unsigned int nents)
 {
-	struct inode *inode;
 	struct dentry *error;
 	struct task_struct *task = get_proc_task(dir);
 	const struct pid_entry *p, *last;
 
 	error = ERR_PTR(-ENOENT);
-	inode = NULL;
 
 	if (!task)
 		goto out_no_task;

