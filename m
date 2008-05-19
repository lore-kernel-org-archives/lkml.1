Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYESMdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYESMdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757479AbYESMbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:50 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58576 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775AbYESMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: miklos@szeredi.hu, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/11] Convert fuse to unlocked_fasync
Message-Id: <20080519123114.A66D71B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:14 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:12.0656 (UTC) FILETIME=[3EF09700:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: miklos@szeredi.hu

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

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
