Return-Path: <linux-kernel-owner+w=401wt.eu-S1946173AbXBBXhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946173AbXBBXhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946172AbXBBXhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:37:33 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44595 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946170AbXBBXha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:37:30 -0500
Date: Fri, 2 Feb 2007 15:34:25 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@pobox.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sky2: flow control off
Message-ID: <20070202153425.2d979fd4@freekitty>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Turn flow control off for sky2. When flow control is on, the transmitter
may get randomly stuck. Perhaps there is hardware problem, but until
Marvell provides errata information for workaround, it should default to off.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
---
 drivers/net/sky2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 822dd0b..a31dea5 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -3263,7 +3263,7 @@ #endif
 
 	/* Auto speed and flow control */
 	sky2->autoneg = AUTONEG_ENABLE;
-	sky2->flow_mode = FC_BOTH;
+	sky2->flow_mode = FC_NONE;
 
 	sky2->duplex = -1;
 	sky2->speed = -1;
-- 
1.4.1

