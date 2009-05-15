Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZEOIRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZEOIRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 04:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbZEOIRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 04:17:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50813 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbZEOIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 04:17:05 -0400
Message-ID: <4A0D2438.7020509@cn.fujitsu.com>
Date: Fri, 15 May 2009 16:13:44 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] devpts: change the default value of devpts mode to 0620
References: <4A0CFB90.3060109@cn.fujitsu.com> <4A0CFCD0.70605@cn.fujitsu.com>
In-Reply-To: <4A0CFCD0.70605@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The value of devpts mode is usually set to 620 in file
/etc/fstab like this:

$grep devpts /etc/fstab
devpts /dev/pts devpts gid=5,mode=620 0 0

But the default mode value of devpts is 0600. Why not
set it to 0620? This patch change it 0620.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
fs/devpts/inode.c | 2 +-
1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index 13392b5..33430b9 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -26,7 +26,7 @@

#define DEVPTS_SUPER_MAGIC 0x1cd1

-#define DEVPTS_DEFAULT_MODE 0600
+#define DEVPTS_DEFAULT_MODE 0620
/*
* ptmx is a new node in /dev/pts and will be unused in legacy (single-
* instance) mode. To prevent surprises in user space, set permissions of
-- 
1.5.3.8

