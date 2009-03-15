Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbZCOXRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbZCOXRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 19:17:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZCOXRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 19:17:36 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:63276 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754271AbZCOXRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 19:17:35 -0400
X-Trace: 163768754/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.47.161/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.41.47.161
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al8FAA4pvUlQKS+h/2dsb2JhbACBTc4Ug38G
X-IronPort-AV: E=Sophos;i="4.38,368,1233532800"; 
   d="scan'208";a="163768754"
Subject: [PATCH] Documentation/filesystems: remove out of date reference to
 BKL being held
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
Content-Type: text/plain
Date: Sun, 15 Mar 2009 23:17:22 +0000
Message-Id: <1237159042.6636.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/filesystems/vfs.txt incorrectly states that the kernel is
locked during the call to statfs (Documentation/filesystems/Locking
correctly says it is not). This patch removes the offending sentence.

remove reference to BKL being held in statfs

Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index deeeed0..f49eecf 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -277,8 +277,7 @@ or bottom half).
   unfreeze_fs: called when VFS is unlocking a filesystem and making it writable
   	again.
 
-  statfs: called when the VFS needs to get filesystem statistics. This
-	is called with the kernel lock held
+  statfs: called when the VFS needs to get filesystem statistics.
 
   remount_fs: called when the filesystem is remounted. This is called
 	with the kernel lock held

