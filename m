Return-Path: <linux-kernel-owner+w=401wt.eu-S1762226AbYHDHBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762226AbYHDHBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 03:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759161AbYHDHBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 03:01:12 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:50390 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759130AbYHDHBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 03:01:11 -0400
Message-ID: <45476.166.70.238.45.1217832046.squirrel@webmail.wolfmountaingroup.com>
Date: Mon, 4 Aug 2008 00:40:46 -0600 (MDT)
Subject: [PATCH 2.6.27-rc1 21/25] mdb:  Merkey's Kernel Debugger 2.6.27-rc1
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware style debugger for Linux written by Jeffrey Vernon Merkey

--- a/init/main.c	2008-08-03 16:10:19.000000000 -0600
+++ b/init/main.c	2008-08-03 16:15:00.000000000 -0600
@@ -659,6 +659,12 @@
 	pgtable_cache_init();
 	prio_tree_init();
 	anon_vma_init();
+#ifdef CONFIG_MDB
+        {
+           extern int mdb_init(void);
+	   mdb_init();
+        }
+#endif
 #ifdef CONFIG_X86
 	if (efi_enabled)
 		efi_enter_virtual_mode();


By making a contribution to this project, I certify that
the contribution was created in whole or in part by me and I
have the right to submit it under the open source license
indicated in the file.

Jeffrey Vernon Merkey



