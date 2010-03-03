Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0CCTQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:16:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:55401 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab0CCTQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:16:13 -0500
Message-ID: <4B8EB545.8060806@oracle.com>
Date: Wed, 03 Mar 2010 11:15:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, Alex Elder <aelder@sgi.com>,
       xfs-masters@oss.sgi.com
Subject: [PATCH mmotm] xfs: needs LIST_SORT
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
In-Reply-To: <201003030305.o2335F1F015917@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B8EB55E.01C6:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

xfs uses list_sort (library function), so it needs to select it.
Fixes these build errors:
fs/xfs/linux-2.6/xfs_buf.c:1918: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1996: undefined reference to `list_sort'
fs/xfs/linux-2.6/xfs_buf.c:1950: undefined reference to `list_sort'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/xfs/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- mmotm-2010-0302-1838.orig/fs/xfs/Kconfig
+++ mmotm-2010-0302-1838/fs/xfs/Kconfig
@@ -2,6 +2,7 @@ config XFS_FS
 	tristate "XFS filesystem support"
 	depends on BLOCK
 	select EXPORTFS
+	select LIST_SORT
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can

