Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbZF1Qbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbZF1Qbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756396AbZF1Q12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1096 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428AbZF1Q10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Digi International, Inc" <Eng.Linux@digi.com>
Subject: [PATCH 14/62] drivers/char/epca.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:19 -0700
Message-Id: <1ee6dd55768ebbbeb505c47e2944b683633be630.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/epca.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index abef1f7..3e68ce9 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2238,7 +2238,7 @@ static void do_softint(struct work_struct *work)
 	struct channel *ch = container_of(work, struct channel, tqueue);
 	/* Called in response to a modem change event */
 	if (ch && ch->magic == EPCA_MAGIC) {
-		struct tty_struct *tty = tty_port_tty_get(&ch->port);;
+		struct tty_struct *tty = tty_port_tty_get(&ch->port);
 
 		if (tty && tty->driver_data) {
 			if (test_and_clear_bit(EPCA_EVENT_HANGUP, &ch->event)) {
-- 
1.6.3.1.10.g659a0.dirty

