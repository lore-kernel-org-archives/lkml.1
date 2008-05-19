Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbYESMd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbYESMd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758814AbYESMbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:51 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:58576 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbYESMbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:48 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/11] Convert bad_inode to unlocked_fasync
Message-Id: <20080519123115.AC72E1B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:15 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:13.0547 (UTC) FILETIME=[3F788BB0:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not that it matters much, but it was easy.

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/bad_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/fs/bad_inode.c
===================================================================
--- linux.orig/fs/bad_inode.c
+++ linux/fs/bad_inode.c
@@ -174,7 +174,7 @@ static const struct file_operations bad_
 	.release	= bad_file_release,
 	.fsync		= bad_file_fsync,
 	.aio_fsync	= bad_file_aio_fsync,
-	.fasync		= bad_file_fasync,
+	.unlocked_fasync = bad_file_fasync,
 	.lock		= bad_file_lock,
 	.sendpage	= bad_file_sendpage,
 	.get_unmapped_area = bad_file_get_unmapped_area,
