Return-Path: <linux-kernel-owner+w=401wt.eu-S1758529AbYA0CVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbYA0CVK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbYA0CRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:17:35 -0500
Received: from mail.suse.de ([195.135.220.2]:54400 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbYA0CR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:17:27 -0500
From: Andi Kleen <ak@suse.de>
References: <20080127317.043953000@suse.de>
In-Reply-To: <20080127317.043953000@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] [18/18] BKL-removal: Convert bad_inode to unlocked_fasync
Message-Id: <20080127021725.4675114D2E@wotan.suse.de>
Date: Sun, 27 Jan 2008 03:17:25 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Not that it matters much, but it was easy.

Signed-off-by: Andi Kleen <ak@suse.de>

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
