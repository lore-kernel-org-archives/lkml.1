Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZAYWqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZAYWqs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 17:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbZAYWqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 17:46:39 -0500
Received: from mu-out-0910.google.com ([209.85.134.190]:33443 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZAYWqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 17:46:39 -0500
Subject: gpio: struct device - replace bus_id with dev_name(),
 dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:45:46 +0100
Message-Id: <1232923546.2924.9.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: gpio: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: Michael Buesch <mb@bu3sch.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/gpio/bt8xxgpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpio/bt8xxgpio.c
+++ b/drivers/gpio/bt8xxgpio.c
@@ -160,7 +160,7 @@ static void bt8xxgpio_gpio_setup(struct
 {
 	struct gpio_chip *c = &bg->gpio;
 
-	c->label = bg->pdev->dev.bus_id;
+	c->label = dev_name(&bg->pdev->dev);
 	c->owner = THIS_MODULE;
 	c->direction_input = bt8xxgpio_gpio_direction_input;
 	c->get = bt8xxgpio_gpio_get;


