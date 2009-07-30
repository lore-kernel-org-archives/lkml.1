Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZG3WCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZG3WCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 18:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZG3WCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 18:02:12 -0400
Received: from server1.wserver.cz ([82.113.45.157]:33288 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZG3WCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 18:02:07 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] IRQ: remove irqfixup MODULE_PARM_DESC
Date: Fri, 31 Jul 2009 00:02:06 +0200
Message-Id: <1248991326-26267-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's wrong (the parm takes no arguments) and compile-time wiped
away anyway (due to !MODULE).

Impact: cleanup

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 kernel/irq/spurious.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 4d56829..114e704 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -297,7 +297,6 @@ static int __init irqfixup_setup(char *str)
 
 __setup("irqfixup", irqfixup_setup);
 module_param(irqfixup, int, 0644);
-MODULE_PARM_DESC("irqfixup", "0: No fixup, 1: irqfixup mode, 2: irqpoll mode");
 
 static int __init irqpoll_setup(char *str)
 {
-- 
1.6.3.3

