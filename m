Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbYA0CUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbYA0CUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbYA0CR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:28 -0500
Received: from mx1.suse.de ([195.135.220.2]:54396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620AbYA0CRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:25 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [17/18] BKL-removal: Convert fuse to unlocked_fasync
Message-Id: <20080127021724.3550D14D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:24 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: miklos@szeredi.hu

Signed-off-by: Andi Kleen <ak@suse.de>

---
 fs/fuse/dev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/fuse/dev.c
===================================================================
--- linux.orig/fs/fuse/dev.c
+++ linux/fs/fuse/dev.c
@@ -1040,7 +1040,7 @@ const struct file_operations fuse_dev_op
 	.aio_write	= fuse_dev_write,
 	.poll		= fuse_dev_poll,
 	.release	= fuse_dev_release,
-	.fasync		= fuse_dev_fasync,
+	.unlocked_fasync = fuse_dev_fasync,
 };
 
 static struct miscdevice fuse_miscdevice = {
