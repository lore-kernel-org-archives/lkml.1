Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbZLNN4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbZLNN4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbZLNNz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:55:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756589AbZLNNz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:55:58 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Ext4: Don't ask about supporting ext2/3 in ext4 if ext4 is
	not configured
To: torvalds@osdl.org, akpm@linux-foundation.org, linux-ext4@vger.kernel.org
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 14 Dec 2009 13:55:46 +0000
Message-ID: <20091214135546.10111.4495.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't offer to build ext2/3 support into ext4 if ext4 itself is not configured
on.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ext4/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
index 9acf7e8..c48a6bc 100644
--- a/fs/ext4/Kconfig
+++ b/fs/ext4/Kconfig
@@ -28,7 +28,7 @@ config EXT4_FS
 
 config EXT4_USE_FOR_EXT23
 	bool "Use ext4 for ext2/ext3 file systems"
-	depends on EXT3_FS=n || EXT2_FS=n
+	depends on EXT4_FS && (EXT3_FS=n || EXT2_FS=n)
 	default y
 	help
 	  Allow the ext4 file system driver code to be used for ext2 or

