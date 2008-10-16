Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYJPQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYJPQF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbYJPQFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:05:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:11448 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYJPQFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:05:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=SIEckjLrzII5iuzlePSOSoy3dYH0vvlr4gX80wNNvcJnSnMMnMnCchMXE3yhwV8/ya
         NGPVyCUXWyeveQsSsLJyAmlD3dQNnl3YS78ms998auCHRkFRiqxL3AxxAkLfPGMHariX
         LxCPm6LX//GE04j+jUGWlPqVedZcuvt1PyDEc=
Date: Thu, 16 Oct 2008 17:04:54 +0100
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] kernel/configs.c: remove useless comments
Message-ID: <20081016160454.GG13374@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These comments are useless, remove them.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>

---
diff --git a/kernel/configs.c b/kernel/configs.c
index 4c34521..abaee68 100644
--- a/kernel/configs.c
+++ b/kernel/configs.c
@@ -54,9 +54,6 @@
 
 #ifdef CONFIG_IKCONFIG_PROC
 
-/**************************************************/
-/* globals and useful constants                   */
-
 static ssize_t
 ikconfig_read_current(struct file *file, char __user *buf,
 		      size_t len, loff_t * offset)
@@ -71,9 +68,6 @@ static const struct file_operations ikconfig_file_ops = {
 	.read = ikconfig_read_current,
 };
 
-/***************************************************/
-/* ikconfig_init: start up everything we need to */
-
 static int __init ikconfig_init(void)
 {
 	struct proc_dir_entry *entry;
@@ -89,9 +83,6 @@ static int __init ikconfig_init(void)
 	return 0;
 }
 
-/***************************************************/
-/* ikconfig_cleanup: clean up our mess           */
-
 static void __exit ikconfig_cleanup(void)
 {
 	remove_proc_entry("config.gz", NULL);


