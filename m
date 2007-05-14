Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbXENVfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbXENVfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXENVez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:34:55 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1421 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbXENVey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:34:54 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 14 May 2007 14:34:53 -0700
Subject: [patch 1/1] export eventfd symbols ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.25077.1179178493.1>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export eventfd kernel functions to modules.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.21-git17.epmod/fs/eventfd.c
===================================================================
--- linux-2.6.21-git17.epmod.orig/fs/eventfd.c	2007-05-14 14:27:29.000000000 -0700
+++ linux-2.6.21-git17.epmod/fs/eventfd.c	2007-05-14 14:28:16.000000000 -0700
@@ -55,6 +55,7 @@
 
 	return n;
 }
+EXPORT_SYMBOL_GPL(eventfd_signal);
 
 static int eventfd_release(struct inode *inode, struct file *file)
 {
@@ -197,6 +198,7 @@
 
 	return file;
 }
+EXPORT_SYMBOL_GPL(eventfd_fget);
 
 asmlinkage long sys_eventfd(unsigned int count)
 {

