Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZI2SRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZI2SRE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZI2SRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:17:04 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:42146 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZI2SQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:16:59 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com
Subject: [PATCH 4/5] jsm: Removing unused jsm_channel->ch_wopen field
Date: Tue, 29 Sep 2009 15:16:58 -0300
Message-Id: <552b20c8a33e0c85a9f1b188d23ce7afd2d3b21e.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the jsm_channel->ch_wopen field is defined and never
used. So, this patch removes it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index 8c14351..484c927 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -213,8 +213,6 @@ struct jsm_channel {
 	u8		ch_stopc;	/* Stop character		*/
 	u8		ch_startc;	/* Start character		*/
 
-	u32		ch_wopen;	/* Waiting for open process cnt */
-
 	u8		ch_mostat;	/* FEP output modem status	*/
 	u8		ch_mistat;	/* FEP input modem status	*/
 
-- 
1.6.0.4

