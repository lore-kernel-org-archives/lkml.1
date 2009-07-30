Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbZG3KZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbZG3KZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZG3KZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:25:04 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:37889 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZG3KZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:25:03 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, chas@cmf.nrl.navy.mil,
       David.Woodhouse@intel.com, nathan@traverse.com.au,
       netdev@vger.kernel.org
Subject: [PATCH 1/4] [atm] fixed faulty check
Date: Thu, 30 Jul 2009 05:24:51 -0500
Message-ID: <1248949491-20796-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/atm/solos-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 9359613..307321b 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -372,7 +372,7 @@ static int process_status(struct solos_card *card, int port, struct sk_buff *skb
 	}
 
 	snr = next_string(skb);
-	if (!str)
+	if (!snr)
 		return -EIO;
 	attn = next_string(skb);
 	if (!attn)
-- 
1.6.3.3

