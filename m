Return-Path: <linux-kernel-owner+w=401wt.eu-S936151AbXLQTyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151AbXLQTyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbXLQTkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:55 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3178 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763967AbXLQTkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:53 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org
Subject: [PATCH] drivers/pcmcia/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:12 -0800
Message-Id: <1197920439-5455-6-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918892.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pcmcia/m32r_pcc.c    |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index c5e0d89..ec4c125 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -368,7 +368,7 @@ static irqreturn_t pcc_interrupt(int irq, void *dev)
 			handled = 1;
 			irc = pcc_get(i, PCIRC);
 			irc >>=16;
-			debug(2, "m32r-pcc:interrput: socket %d pcirc 0x%02x ", i, irc);
+			debug(2, "m32r-pcc:interrupt: socket %d pcirc 0x%02x ", i, irc);
 			if (!irc)
 				continue;
 
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index d182760..4ea426a 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -851,7 +851,7 @@ static int m8xx_set_socket(struct pcmcia_socket *sock, socket_state_t * state)
 	   I tried to control the CxOE signal with SS_OUTPUT_ENA,
 	   but the reset signal seems connected via the 541.
 	   If the CxOE is left high are some signals tristated and
-	   no pullups are present -> the cards act wierd.
+	   no pullups are present -> the cards act weird.
 	   So right now the buffers are enabled if the power is on. */
 
 	if (state->Vcc || state->Vpp)
-- 
1.5.3.7.949.g2221a6

