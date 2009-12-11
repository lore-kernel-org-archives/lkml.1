Return-Path: <linux-kernel-owner+w=401wt.eu-S935013AbZLKXhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbZLKXhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933809AbZLKX27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:59 -0500
Received: from kroah.org ([198.145.64.141]:50424 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762805AbZLKX2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <Scott.Kilau@digi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/58] jsm: Removing unused jsm_channel->ch_wopen field
Date: Fri, 11 Dec 2009 15:27:50 -0800
Message-Id: <1260574122-10676-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently the jsm_channel->ch_wopen field is defined and never
used. So, this patch removes it.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

