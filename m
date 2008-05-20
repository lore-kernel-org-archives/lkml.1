Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbYETPeH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbYETPeH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:34:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932724AbYETPae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:34 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2881 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbYETPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:30 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/11] Convert bad_inode to unlocked_fasync
Message-Id: <20080520152847.E57F61B4203@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:47 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:45.0886 (UTC) FILETIME=[372C3BE0:01C8BA8D]
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
