Return-Path: <linux-kernel-owner+w=401wt.eu-S1759222AbZLGIhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222AbZLGIhu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759221AbZLGIhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:37:47 -0500
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:65195 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759067AbZLGIhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:37:43 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: [PATCH 8/9] Squashfs: select DECOMPRESS_LZMA_NEEDED when including support for lzma
Message-Id: <E1NHZ6L-0002A0-Dz@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 07 Dec 2009 08:37:49 +0000
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

