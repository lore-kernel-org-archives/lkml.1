Return-Path: <linux-kernel-owner+w=401wt.eu-S1761770AbYHDChg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770AbYHDChg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761200AbYHDCec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:34:32 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:44575 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761192AbYHDCeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:34:31 -0400
Message-ID: <57583.166.70.238.45.1217816049.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:14:09 -0600 (MDT)
Subject: [PATCH 2.6.26 21/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/init/main.c	2008-07-13 15:51:29.000000000 -0600
+++ linux-2.6.26-mdb/init/main.c	2008-08-03 12:49:01.000000000 -0600 @@
-652,6 +652,12 @@
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


By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey





