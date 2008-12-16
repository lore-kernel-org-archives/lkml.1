Return-Path: <linux-kernel-owner+w=401wt.eu-S1758240AbYLPPi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240AbYLPPi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755071AbYLPPiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:38:18 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:20130 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753613AbYLPPiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:38:17 -0500
Message-ID: <4947CB65.3070005@panasas.com>
Date: Tue, 16 Dec 2008 17:38:13 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 9/9] fs: Add exofs to Kernel build
References: <4947BFAA.4030208@panasas.com>
In-Reply-To: <4947BFAA.4030208@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 15:36:45.0936 (UTC) FILETIME=[1A647700:01C95F94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


- Add exofs to fs/Kconfig under "menu 'Miscellaneous filesystems'"
- Add exofs to fs/Makefile

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/Kconfig  |    1 +
 fs/Makefile |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..a2e6129 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1122,6 +1122,7 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
+source "fs/exofs/Kconfig"
 endmenu
 
 menuconfig NETWORK_FILESYSTEMS
diff --git a/fs/Makefile b/fs/Makefile
index d9f8afe..920250b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -122,3 +122,4 @@ obj-$(CONFIG_HPPFS)		+= hppfs/
 obj-$(CONFIG_DEBUG_FS)		+= debugfs/
 obj-$(CONFIG_OCFS2_FS)		+= ocfs2/
 obj-$(CONFIG_GFS2_FS)           += gfs2/
+obj-$(CONFIG_EXOFS_FS)          += exofs/
-- 
1.6.0.1


