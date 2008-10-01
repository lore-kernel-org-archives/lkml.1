Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYJAH6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYJAH6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYJAH5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:57:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:62119 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586AbYJAH5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:57:45 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip] drivers/serial/8250.c: 'i' may be used uninitialized
Date: Wed,  1 Oct 2008 00:57:27 -0700
Message-Id: <1222847847-7127-3-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1222847847-7127-2-git-send-email-steven@uplinklabs.net>
References: <1222847847-7127-1-git-send-email-steven@uplinklabs.net>
 <1222847847-7127-2-git-send-email-steven@uplinklabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 drivers/serial/8250.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 356c2a2..b51e91e 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1599,7 +1599,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 
 static void serial_unlink_irq_chain(struct uart_8250_port *up)
 {
-	struct irq_info *i;
+	struct irq_info *uninitialized_var(i);
 	struct hlist_node *n;
 	struct hlist_head *h;
 
-- 
1.6.0.2

