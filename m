Return-Path: <linux-kernel-owner+w=401wt.eu-S932644AbYETPfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644AbYETPfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbYETPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:36 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbYETPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: miklos@szeredi.hu, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [5/11] Convert fuse to unlocked_fasync
Message-Id: <20080520152846.E1A341B4205@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:46 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:46.0511 (UTC) FILETIME=[378B99F0:01C8BA8D]
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
@@ -1082,7 +1082,7 @@ const struct file_operations fuse_dev_op
 	.aio_write	= fuse_dev_write,
 	.poll		= fuse_dev_poll,
 	.release	= fuse_dev_release,
-	.fasync		= fuse_dev_fasync,
+	.unlocked_fasync = fuse_dev_fasync,
 };
 
 static struct miscdevice fuse_miscdevice = {
