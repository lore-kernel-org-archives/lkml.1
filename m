Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZBRWeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZBRWeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZBRWbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:31:18 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:53056 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393AbZBRWbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:31:17 -0500
Date: Wed, 18 Feb 2009 14:31:53 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] docsrc: use config instead of menuconfig
Message-Id: <20090218143153.475f4660.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.499C8C27.0325:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

BUILD_DOCSRC should be controlled by "config" instead of "menuconfig".
I have no idea how I managed to use "menuconfig" here.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx2629-rc5-docsrc.orig/lib/Kconfig.debug
+++ lnx2629-rc5-docsrc/lib/Kconfig.debug
@@ -838,7 +838,7 @@ config FIREWIRE_OHCI_REMOTE_DMA
 
 	  If unsure, say N.
 
-menuconfig BUILD_DOCSRC
+config BUILD_DOCSRC
 	bool "Build targets in Documentation/ tree"
 	depends on HEADERS_CHECK
 	help
