Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbYBWR46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbYBWR46 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301AbYBWR4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:56:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:64835 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbYBWR4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:56:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:cc:message-id:from:date;
        b=PFRvKAFsWKUisyxij1m/vmrslOIGXgOlG3inv4EeWFaiwGIwYaDZuxpvLJpF5IbyYbJRSH4eAklWqkninsEWfbIPyt3Mbw2zK04NjdCrjM1zQLAWoUHuGfXvaqnwYZAjGr9Gllx/q5kTzOdshTFGKz8PzOuf8c3hS5ETG/AgZw8=
To: netdev@vger.kernel.org
Subject: [PATCH 1/2]via-rhine.c: Use-register-offset-definition-for-WOLcgClr
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1JSybz-0004BD-Tu@elite>
From: Laura Garcia <nevola@gmail.com>
Date: Sat, 23 Feb 2008 18:56:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use register offset definition for WOLcgClr. This patch does not 
change the driver behaviour.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>

	modified:   drivers/net/via-rhine.c
---
 drivers/net/via-rhine.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 7c851b1..8c9d6ae 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -1893,7 +1893,7 @@ static void rhine_shutdown (struct pci_dev *pdev)
 
 	/* Make sure we use pattern 0, 1 and not 4, 5 */
 	if (rp->quirks & rq6patterns)
-		iowrite8(0x04, ioaddr + 0xA7);
+		iowrite8(0x04, ioaddr + WOLcgClr);
 
 	if (rp->wolopts & WAKE_MAGIC) {
 		iowrite8(WOLmagic, ioaddr + WOLcrSet);
-- 
1.5.3.8

