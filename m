Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYKYECV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYKYECV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 23:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYKYECN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 23:02:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:23685 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbYKYECM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 23:02:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,661,1220252400"; 
   d="scan'208";a="407690342"
From: Sheng Yang <sheng@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH] 8250: Eliminate compile warning of 8250.c
Date: Tue, 25 Nov 2008 11:58:23 +0800
Message-Id: <1227585503-3833-1-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1227585320-3711-1-git-send-email-sheng@linux.intel.com>
References: <1227585320-3711-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Something wrong with encoding of the first mail...)

The patch based on linux-2.6 upstream and elimiate this compile warning
info:

drivers/serial/8250.c: In function 'serial8250_shutdown':
drivers/serial/8250.c:1612: warning: 'i' may be used uninitialized in this
function

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 303272a..c78eee6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1609,7 +1609,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *i = NULL;
 	struct hlist_node *n;
 	struct hlist_head *h;
 
-- 
1.5.4.5

