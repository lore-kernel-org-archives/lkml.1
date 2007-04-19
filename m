Return-Path: <linux-kernel-owner+w=401wt.eu-S1766785AbXDSPLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766785AbXDSPLO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766794AbXDSPLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:11:14 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:51621 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766785AbXDSPLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:11:13 -0400
Date: Thu, 19 Apr 2007 18:10:54 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] add two SCSI command opcodes
Message-ID: <20070419151053.GA10199@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Applies for 2.6.20.7 and beyond.

Signed-off-by: Dan Aloni <da-x@monatomic.org>

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c0e979..dff842a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -103,6 +103,7 @@ extern const unsigned char scsi_command_size[8];
 #define READ_12               0xa8
 #define WRITE_12              0xaa
 #define WRITE_VERIFY_12       0xae
+#define VERIFY_12             0xaf
 #define SEARCH_HIGH_12        0xb0
 #define SEARCH_EQUAL_12       0xb1
 #define SEARCH_LOW_12         0xb2
@@ -111,6 +112,7 @@ extern const unsigned char scsi_command_size[8];
 #define WRITE_LONG_2          0xea
 #define READ_16               0x88
 #define WRITE_16              0x8a
+#define WRITE_VERIFY_16       0x8e
 #define VERIFY_16	      0x8f
 #define SERVICE_ACTION_IN     0x9e
 /* values for service action in */


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
