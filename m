Return-Path: <linux-kernel-owner+w=401wt.eu-S1756497AbZGCJIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497AbZGCJIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZGCJIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:08:02 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:56686 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829AbZGCJIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:08:01 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org, yinghai@kernel.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 2/2] IRQ: remove irqfixup MODULE_PARM_DESC
Date: Fri,  3 Jul 2009 11:01:49 +0200
Message-Id: <1246611709-9919-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
References: <1246611709-9919-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong and compiled-time wiped away anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/irq/spurious.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index c0463b9..0162ebf 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -305,7 +305,6 @@ static int __init irqfixup_setup(char *str)
 
 __setup("irqfixup", irqfixup_setup);
 module_param(irqfixup, int, 0644);
-MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode, 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
-- 
1.6.3.2

