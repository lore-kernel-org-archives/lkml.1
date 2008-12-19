Return-Path: <linux-kernel-owner+w=401wt.eu-S1751192AbYLSTAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbYLSTAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYLSTAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:00:41 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:46774 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYLSTAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:00:40 -0500
Date: Fri, 19 Dec 2008 10:59:29 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] docs: add more early params to kernel-parameters.txt
Message-Id: <20081219105929.4608f124.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.494BEF15.0023:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add some (more) early_param boot options to kernel-parameters.txt.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-next-20081219.orig/Documentation/kernel-parameters.txt
+++ linux-next-20081219/Documentation/kernel-parameters.txt
@@ -1131,6 +1131,8 @@ and is between 256 and 4096 characters. 
 			If there are multiple matching configurations changing
 			the same attribute, the last one is used.
 
+	lmb=debug	[KNL] Enable lmb debug messages.
+
 	load_ramdisk=	[RAM] List of ramdisks to load from floppy
 			See Documentation/blockdev/ramdisk.txt.
 
@@ -1583,6 +1585,10 @@ and is between 256 and 4096 characters. 
 
 	nr_uarts=	[SERIAL] maximum number of UARTs to be registered.
 
+	ohci1394_dma=early	[HW] enable debugging via the ohci1394 driver.
+			See Documentation/debugging-via-ohci1394.txt for more
+			info.
+
 	olpc_ec_timeout= [OLPC] ms delay when issuing EC commands
 			Rather than timing out after 20 ms if an EC
 			command is not properly ACKed, override the length
