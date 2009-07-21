Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbZGUMx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbZGUMx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 08:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZGUMwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 08:52:47 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:40909 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbZGUMwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 08:52:46 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Felipe Balbi <me@felipebalbi.com>
Subject: [PATCH 2/4] staging: cpc-usb: convert comment style in cpc_int.h
Date: Tue, 21 Jul 2009 15:52:24 +0300
Message-Id: <1248180746-18140-3-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1248180746-18140-2-git-send-email-me@felipebalbi.com>
References: <1248180746-18140-1-git-send-email-me@felipebalbi.com>
 <1248180746-18140-2-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/staging/cpc-usb/cpc_int.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/cpc-usb/cpc_int.h b/drivers/staging/cpc-usb/cpc_int.h
index a0d60c0..38674e9 100644
--- a/drivers/staging/cpc-usb/cpc_int.h
+++ b/drivers/staging/cpc-usb/cpc_int.h
@@ -39,10 +39,10 @@ typedef void (*chan_write_byte_t) (void *chan, unsigned int reg,
 typedef unsigned char (*chan_read_byte_t) (void *chan, unsigned int reg);
 
 typedef struct CPC_CHAN {
-	void __iomem * canBase;	// base address of SJA1000
-	chan_read_byte_t read_byte;	// CAN controller read access routine
-	chan_write_byte_t write_byte;	// CAN controller write access routine
-	CPC_MSG_T *buf;		// buffer for CPC msg
+	void __iomem * canBase;	/* base address of SJA1000 */
+	chan_read_byte_t read_byte;	/* CAN controller read access routine */
+	chan_write_byte_t write_byte;	/* CAN controller write access routine */
+	CPC_MSG_T *buf;		/* buffer for CPC msg */
 	unsigned int iidx;
 	unsigned int oidx;
 	unsigned int WnR;
-- 
1.6.4.rc1

