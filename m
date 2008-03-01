Return-Path: <linux-kernel-owner+w=401wt.eu-S1761300AbYCAGDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761300AbYCAGDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 01:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYCAGDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 01:03:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:58546 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYCAGDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 01:03:08 -0500
Date: Fri, 29 Feb 2008 22:02:50 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, torvalds <torvalds@linux-foundation.org>,
       jejb <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/6] docbook: fix scsi source file
Message-Id: <20080229220250.6488df42.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix docbook problem in SCSI source files.
These cause the generated docbook to be incorrect.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_scan.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- lin2625-rc3g2-kdoc.orig/drivers/scsi/scsi_scan.c
+++ lin2625-rc3g2-kdoc/drivers/scsi/scsi_scan.c
@@ -1577,8 +1577,7 @@ static void __scsi_scan_target(struct de
 }
 
 /**
- * scsi_scan_target - scan a target id, possibly including all LUNs on the
- *     target.
+ * scsi_scan_target - scan a target id, possibly including all LUNs on the target.
  * @parent:	host to scan
  * @channel:	channel to scan
  * @id:		target id to scan
