Return-Path: <linux-kernel-owner+w=401wt.eu-S932343AbZHGSRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbZHGSRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932292AbZHGSRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:17:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:26426 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbZHGSRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:17:46 -0400
Date: Fri, 7 Aug 2009 11:17:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       akpm <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] staging/hv: blk dev depends on SCSI
Message-Id: <20090807111704.b7b79983.randy.dunlap@oracle.com>
In-Reply-To: <20090807183118.e71b4db2.sfr@canb.auug.org.au>
References: <20090807183118.e71b4db2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010201.4A7C6FB8.00A3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

hv block driver uses scsi_*() interfaces so it should depend on SCSI.

ERROR: "scsi_normalize_sense" [drivers/staging/hv/hv_blkvsc.ko] undefined!
ERROR: "scsi_print_sense_hdr" [drivers/staging/hv/hv_blkvsc.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/staging/hv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090807.orig/drivers/staging/hv/Kconfig
+++ linux-next-20090807/drivers/staging/hv/Kconfig
@@ -15,7 +15,7 @@ config HYPERV_STORAGE
 
 config HYPERV_BLOCK
 	tristate "Microsoft Hyper-V virtual block driver"
-	depends on BLOCK && m
+	depends on BLOCK && SCSI && m
 	default n
 	help
 	  Select this option to enable the Hyper-V virtual block driver.


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
