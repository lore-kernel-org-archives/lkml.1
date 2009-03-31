Return-Path: <linux-kernel-owner+w=401wt.eu-S1753095AbZCaJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbZCaJ4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 05:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbZCaJ4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 05:56:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62927 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbZCaJ4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 05:56:03 -0400
From: Li Xiaodong <lixd@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Li Xiaodong <lixd@cn.fujitsu.com>
Subject: [PATCH] Update Documentation: unix_dgram_qlen@proc.txt 
Date: Tue, 31 Mar 2009 17:55:59 +0800
Message-Id: <1238493359-22157-1-git-send-email-lixd@cn.fujitsu.com>
X-Mailer: git-send-email 1.5.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update of Documentation: proc.txt

Previous description about system parameter in /proc/sys/net/unix/ is wrong (or missed).
Simply add a new description about unix_dgram_qlen according to latest kernel.

signed-off-by: Li Xiaodong <lixd@cn.fujitsu.com>

---
 Documentation/filesystems/proc.txt |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 830bad7..cb3f459 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1501,8 +1501,9 @@ of struct cmsghdr structures with appended data.
 /proc/sys/net/unix - Parameters for Unix domain sockets
 -------------------------------------------------------
 
-There are  only  two  files  in this subdirectory. They control the delays for
-deleting and destroying socket descriptors.
+There is only one file in this directory.
+unix_dgram_qlen limits the max number of datagrams queued in Unix domain
+socket's buffer. It will not take effect unless PF_UNIX flag is spicified.
 
 2.8 /proc/sys/net/ipv4 - IPV4 settings
 --------------------------------------
-- 
1.5.3.5

