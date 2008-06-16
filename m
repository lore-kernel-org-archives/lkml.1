Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYFPNkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYFPNkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbYFPNke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:51510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbYFPNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:40:34 -0400
From: Andre Haupt <andre@bitwigglers.org>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andre Haupt <andre@bitwigglers.org>
Subject: [PATCH] hamradio: remove unused variable
Date: Mon, 16 Jun 2008 15:40:34 +0200
Message-Id: <1213623634-8120-3-git-send-email-andre@bitwigglers.org>
X-Mailer: git-send-email 1.5.5.GIT
X-Provags-ID: V01U2FsdGVkX1+oncy5aceaEwDhe6XZNGLbLXerrjWhvJ0aglN
 NbjZeW35kdLv5UY8j+Ux/ra7Uvj1bxZ8f9AC6wQHElP7q9qGYs
 7Tikcc1sL24FQP5zt4UagMSYzGAnTxQ4ooQN3H+z0M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
---
 drivers/net/hamradio/dmascc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index 0b94833..e8cfade 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -1077,8 +1077,6 @@ static inline void rx_off(struct scc_priv *priv)
 
 static void start_timer(struct scc_priv *priv, int t, int r15)
 {
-	unsigned long flags;
-
 	outb(priv->tmr_mode, priv->tmr_ctrl);
 	if (t == 0) {
 		tm_isr(priv);
-- 
1.5.5.GIT

