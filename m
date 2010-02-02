Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab0BBG65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 01:58:57 -0500
Received: from tango.tkos.co.il ([62.219.50.35]:44353 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab0BBG6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 01:58:55 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] devres: typo fix s/dev/devm/
Date: Tue,  2 Feb 2010 08:54:51 +0200
Message-Id: <cf1ec3a8fa3eb545752984b03cd21abda3997758.1265093593.git.baruch@tkos.co.il>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 kernel/irq/devres.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index d06df9c..30d56ba 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -81,7 +81,7 @@ EXPORT_SYMBOL(devm_request_threaded_irq);
  *	Except for the extra @dev argument, this function takes the
  *	same arguments and performs the same function as free_irq().
  *	This function instead of free_irq() should be used to manually
- *	free IRQs allocated with dev_request_irq().
+ *	free IRQs allocated with devm_request_irq().
  */
 void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
 {
-- 
1.6.5

