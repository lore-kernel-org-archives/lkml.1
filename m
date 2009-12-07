Return-Path: <linux-kernel-owner+w=401wt.eu-S934784AbZLGItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784AbZLGItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934756AbZLGItc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:49:32 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:56825 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933643AbZLGItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:49:31 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 8/9] Squashfs: select DECOMPRESS_LZMA_NEEDED when including support for lzma
Message-Id: <E1NHYuo-00028p-Ik@dylan.lougher.demon.co.uk>
From: root <root@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:25:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/Kconfig b/fs/squashfs/Kconfig
index 0294aa2..7ec5d7e 100644
--- a/fs/squashfs/Kconfig
+++ b/fs/squashfs/Kconfig
@@ -30,6 +30,7 @@ config SQUASHFS_LZMA
 	bool "Include support for LZMA compressed file systems"
 	depends on SQUASHFS
 	select DECOMPRESS_LZMA
+	select DECOMPRESS_LZMA_NEEDED
 
 config SQUASHFS_EMBEDDED
 
-- 
1.6.3.3

