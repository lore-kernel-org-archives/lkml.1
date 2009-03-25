Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbZCYAhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbZCYAhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754808AbZCYA35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:57 -0400
Received: from kroah.org ([198.145.64.141]:54093 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbZCYA3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:54 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Michael Buesch <mb@bu3sch.de>
Subject: [PATCH 22/61] gpio: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:26 -0700
Message-Id: <1237940825-22904-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: Michael Buesch <mb@bu3sch.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/gpio/bt8xxgpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
index 7a11682..984b587 100644
--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -160,7 +160,7 @@ static void bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
 {
 	struct gpio_chip *c = &bg->gpio;
 
-	c->label = bg->pdev->dev.bus_id;
+	c->label = dev_name(&bg->pdev->dev);
 	c->owner = THIS_MODULE;
 	c->direction_input = bt8xxgpio_gpio_direction_input;
 	c->get = bt8xxgpio_gpio_get;
-- 
1.6.2

