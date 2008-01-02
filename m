Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYABBcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYABBcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbYABBce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:32:34 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55077 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395AbYABBce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:32:34 -0500
Date: Wed, 2 Jan 2008 03:32:18 +0200
From: Adrian Bunk <bunk@kernel.org>
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] let EXT4DEV_FS depend on BROKEN
Message-ID: <20080102013218.GO27566@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might make sense to offer ext4 in -mm and even in early -rc kernels, 
but I've already seen people using ext4 simply because a stable kernel 
offered it - and that's definitely not intended.

Anyone who _really_ wants to test ext4 should anyway be able to do the 
trivial change of removing the "depends on BROKEN" line.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f778e1d046a3554ca15b8637afd0ffbf4790801c 
diff --git a/fs/Kconfig b/fs/Kconfig
index 487236c..d850725 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -138,7 +138,7 @@ config EXT3_FS_SECURITY
 
 config EXT4DEV_FS
 	tristate "Ext4dev/ext4 extended fs support development (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	depends on BROKEN
 	select JBD2
 	select CRC16
 	help

