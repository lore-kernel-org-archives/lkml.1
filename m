Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbYC0Dxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbYC0Dxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 23:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYC0Dxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 23:53:38 -0400
Received: from ozlabs.org ([203.10.76.45]:33484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYC0Dxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 23:53:38 -0400
To: <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
From: Benjamin Herrenschmidt <benh@ozlabs.org>
Date: Thu, 27 Mar 2008 14:52:15 +1100
Subject: [PATCH] Give futex init a proper name
Message-Id: <20080327035249.6F774DDF4D@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The futex init function is called init(). This is a pain in the neck
when debugging when you code dies in ... init :-)

This renames it to futex_init().

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 kernel/futex.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-work.orig/kernel/futex.c	2008-03-27 14:50:11.000000000 +1100
+++ linux-work/kernel/futex.c	2008-03-27 14:50:20.000000000 +1100
@@ -2158,7 +2158,7 @@ static struct file_system_type futex_fs_
 	.kill_sb	= kill_anon_super,
 };
 
-static int __init init(void)
+static int __init futex_init(void)
 {
 	u32 curval;
 	int i;
@@ -2194,4 +2194,4 @@ static int __init init(void)
 
 	return 0;
 }
-__initcall(init);
+__initcall(futex_init);
