Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbYC2DJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbYC2DJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759129AbYC2DIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:08:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49898 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056AbYC2DIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:08:49 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] drivers/char/n_tty.c misannotated prototype
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Message-Id: <E1JfRR2-0002il-Jg@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:08:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/char/n_tty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 46b2a1c..0c09409 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1183,7 +1183,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	return retval;
 }
 
-extern ssize_t redirected_tty_write(struct file *, const char *,
+extern ssize_t redirected_tty_write(struct file *, const char __user *,
 							size_t, loff_t *);
 
 /**
-- 
1.5.3.GIT


