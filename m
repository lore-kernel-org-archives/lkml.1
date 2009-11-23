Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbZKWX5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbZKWX5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757551AbZKWX5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:57:46 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:53023 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbZKWX5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:57:43 -0500
Message-ID: <4B0B214A.5020006@oracle.com>
Date: Mon, 23 Nov 2009 15:56:58 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Greg KH <gregkh@suse.de>, kay.sievers@vrfy.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sysfs: fix SYSFS_DEPRECATED_V2 prompt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B0B216D.00B8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The SYSFS_DEPRECATED_V2 says "remove" older, deprecated features,
but it actually enables them, so correct this confusing, backwards
text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2632-rc8.orig/init/Kconfig
+++ lnx-2632-rc8/init/Kconfig
@@ -606,7 +606,7 @@ config SYSFS_DEPRECATED
 	bool
 
 config SYSFS_DEPRECATED_V2
-	bool "remove sysfs features which may confuse old userspace tools"
+	bool "enable deprecated sysfs features which may confuse old userspace tools"
 	depends on SYSFS
 	default n
 	select SYSFS_DEPRECATED
