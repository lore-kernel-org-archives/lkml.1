Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbZFODVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbZFODVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755647AbZFODRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:17:00 -0400
Received: from mail.renesas.com ([202.234.163.13]:58610 "EHLO
	mail02.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755538AbZFODQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:16:59 -0400
X-AuditID: ac140385-00000008000002de-11-4a35bd275d42
Date: Mon, 15 Jun 2009 12:16:54 +0900
From: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Subject: [PATCH] cpumask: Remove mask field from comments
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: rusty@rustcorp.com.au
Message-id: <4A35BD26.1090906@renesas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/2] cpumask: Remove mask field from comments

By 7be23e278f, mask field was deleted by irqaction. However, it was not
deleted from comment.

Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/interrupt.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 90ee0a8..80b7768 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -77,7 +77,6 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * struct irqaction - per interrupt action descriptor
  * @handler:	interrupt handler function
  * @flags:	flags (see IRQF_* above)
- * @mask:	no comment as it is useless and about to be removed
  * @name:	name of the device
  * @dev_id:	cookie to identify the device
  * @next:	pointer to the next irqaction for shared interrupts
-- 
1.6.3.1
