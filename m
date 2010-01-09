Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285Ab0AIGnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab0AIGnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 01:43:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091Ab0AIGns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 01:43:48 -0500
Received: from mail.perches.com ([173.55.12.10]:1030 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0AIGnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 01:43:47 -0500
Subject: [PATCH] arch/arm: Remove unnecessary semicolons
From: Joe Perches <joe@perches.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 22:43:45 -0800
Message-ID: <1263019425.20926.12.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/mach-at91/at91cap9_devices.c    |    2 +-
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 arch/arm/mach-at91/at91sam9rl_devices.c  |    2 +-
 arch/arm/mach-w90x900/cpu.c              |    2 +-
 arch/arm/plat-mxc/irq.c                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index d1f775e..308ce7a 100644
--- a/arch/arm/mach-at91/at91cap9_devices.c
+++ b/arch/arm/mach-at91/at91cap9_devices.c
@@ -171,7 +171,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 809114d..b27ef60 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -254,7 +254,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 {
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 53aaa94..c49262b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -145,7 +145,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 20dc0c9..4d51d5b 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -59,7 +59,7 @@ static DEFINE_CLK(emc, 7);
 static DEFINE_SUBCLK(rmii, 2);
 static DEFINE_CLK(usbd, 8);
 static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(g2d, 10);
 static DEFINE_CLK(pwm, 18);
 static DEFINE_CLK(ps2, 24);
 static DEFINE_CLK(kpi, 25);
diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index 778ddfe..e74f32a 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -53,7 +53,7 @@ int imx_irq_set_priority(unsigned char irq, unsigned char prio)
 	unsigned int mask = 0x0F << irq % 8 * 4;
 
 	if (irq >= MXC_INTERNAL_IRQS)
-		return -EINVAL;;
+		return -EINVAL;
 
 	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
 	temp &= ~mask;


