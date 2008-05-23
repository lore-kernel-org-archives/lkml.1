Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbYEWEBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbYEWEBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 00:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750737AbYEWEBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 00:01:07 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57312 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYEWEBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 00:01:06 -0400
Message-Id: <200805230400.m4N40f6W010852@www262.sakura.ne.jp>
Subject: Re: [git patch] vfs: permission API cleanup (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, trond.myklebust@fys.uio.no,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 May 2008 13:00:41 +0900
References: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
In-Reply-To: <E1JzDzC-0008MT-Hb@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: Add EXPORT_SYMBOL(check_execute).

NFS needs check_execute().

  Kernel: arch/x86/boot/bzImage is ready  (#1)
    Building modules, stage 2.
  ERROR: "check_execute" [fs/nfs/nfs.ko] undefined!
  make[1]: *** [__modpost] Error 1
  make: *** [modules] Error 2

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- vfs.orig/fs/namei.c
+++ vfs/fs/namei.c
@@ -246,6 +246,7 @@ int check_execute(struct inode *inode, i
 
 	return 0;
 }
+EXPORT_SYMBOL(check_execute);
 
 static int dentry_permission(struct dentry *dentry, int mask)
 {
