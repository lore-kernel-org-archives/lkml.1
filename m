Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXFFRYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXFFRYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbXFFRXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:23:55 -0400
Received: from mta-ps-be-01.sunrise.ch ([194.158.229.24]:44287 "EHLO
	mail-ps.sunrise.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbXFFRXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:23:55 -0400
Message-Id: <200706061901.12421.robin.farine@terminus.org>
In-Reply-To: <200706061857.50961.robin.farine@terminus.org>
References: <200706061857.50961.robin.farine@terminus.org>
From: Robin Farine <robin.farine@terminus.org>
Date: Wed, 6 Jun 2007 19:01:12 +0200
Subject: [PATCH 1/2] LEDS: make default_trigger a const char *
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Farine <robin.farine@terminus.org>

Relax the restriction on what can be assigned to the 'default_trigger'
field.

Signed-off-by: Robin Farine <robin.farine@terminus.org>
---
 include/linux/leds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 88afcef..958a14d 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -40,7 +40,7 @@ struct led_classdev {
 
 	struct class_device	*class_dev;
 	struct list_head	 node;			/* LED Device list */
-	char			*default_trigger;	/* Trigger to use */
+	const char		*default_trigger;	/* Trigger to use */
 
 #ifdef CONFIG_LEDS_TRIGGERS
 	/* Protects the trigger data below */
-- 
1.5.2.1

