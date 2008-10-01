Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbYJAIRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbYJAIRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 04:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbYJAIRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 04:17:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:19600 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYJAIRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 04:17:02 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@lxorguk.ukuu.org.uk,
       Steven Noonan <steven@uplinklabs.net>
Subject: [PATCH -tip] drivers/serial/8250.c: 'i' may be used uninitialized
Date: Wed,  1 Oct 2008 01:16:57 -0700
Message-Id: <1222849017-10896-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081001080150.GC25832@elte.hu>
References: <20081001080150.GC25832@elte.hu>
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

