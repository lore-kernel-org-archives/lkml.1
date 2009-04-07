Return-Path: <linux-kernel-owner+w=401wt.eu-S1758981AbZDGQHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981AbZDGQHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 12:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZDGQHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 12:07:12 -0400
Received: from verein.lst.de ([213.95.11.210]:51249 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043AbZDGQHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 12:07:10 -0400
Date: Tue, 7 Apr 2009 18:07:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] romfs: cleanup romfs_fs.h
Message-ID: <20090407160708.GA11384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no kernel-only content in it anymore, so move it to header-y
and remove the superflous #ifdef __KERNEL__.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/include/linux/Kbuild
===================================================================
--- linux-2.6.orig/include/linux/Kbuild	2009-04-07 17:56:08.209569787 +0200
+++ linux-2.6/include/linux/Kbuild	2009-04-07 17:56:21.404447763 +0200
@@ -138,6 +138,7 @@ header-y += qnxtypes.h
 header-y += radeonfb.h
 header-y += raw.h
 header-y += resource.h
+header-y += romfs_fs.h
 header-y += rose.h
 header-y += serial_reg.h
 header-y += smbno.h
@@ -314,7 +315,6 @@ unifdef-y += irqnr.h
 unifdef-y += reboot.h
 unifdef-y += reiserfs_fs.h
 unifdef-y += reiserfs_xattr.h
-unifdef-y += romfs_fs.h
 unifdef-y += route.h
 unifdef-y += rtc.h
 unifdef-y += rtnetlink.h
Index: linux-2.6/include/linux/romfs_fs.h
===================================================================
--- linux-2.6.orig/include/linux/romfs_fs.h	2009-04-07 17:55:56.004444938 +0200
+++ linux-2.6/include/linux/romfs_fs.h	2009-04-07 17:56:01.366447535 +0200
@@ -53,9 +53,4 @@ struct romfs_inode {
 #define ROMFH_PAD (ROMFH_SIZE-1)
 #define ROMFH_MASK (~ROMFH_PAD)
 
-#ifdef __KERNEL__
-
-/* Not much now */
-
-#endif /* __KERNEL__ */
 #endif
