Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbZIGPOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbZIGPOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZIGPOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:14:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52274 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZIGPOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:14:36 -0400
Date: Mon, 7 Sep 2009 17:14:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, wanzongshun <mcuos.com@gmail.com>
Subject: Re: linux-next: manual merge of the trivial tree with the arm tree
In-Reply-To: <20090907163201.72adc3f6.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.0909071713210.23856@wotan.suse.de>
References: <20090907163201.72adc3f6.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Stephen Rothwell wrote:

> Today's linux-next merge of the trivial tree got a conflict in
> arch/arm/mach-w90x900/w90p910.c between commit
> 35c9221acb133ecc9abd701a1fb6fa909d177a77 ("ARM: 5682/1: Add cpu.c and
> dev.c and modify some files of w90p910 platform") from the arm tree and
> commit 6f8fadf4a5c43f9f10f1910c71d8d9ff0b0a26ca ("trivial: remove
> unnecessary semicolons") from the trivial tree.
> 
> The former commit moved the code changed by the latter into a different
> file (arch/arm/mach-w90x900/cpu.c - and removed the old file).  Its not
> important enough to fix it there (so I just removed this file), but maybe
> the part of the trivial commit touching this file could be sent to the
> arm maintainer.

Sure, here we go. Russel, could you please apply this on top of your 
current tree? (I have already dropped the bits touching arch/arm from 
trivial queue). Thanks.



From: Joe Perches <joe@perches.com>
Subject: trivial: remove unnecessary semicolons

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

diff --git a/arch/arm/mach-at91/at91cap9_devices.c b/arch/arm/mach-at91/at91cap9_devices.c
index 412aa49..799c11e 100644
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
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index 7281865..e87237b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -99,7 +99,7 @@ void __init at91_add_device_usba(struct usba_platform_data *data)
 	 */
 	usba_udc_data.pdata.vbus_pin = -EINVAL;
 	usba_udc_data.pdata.num_ep = ARRAY_SIZE(usba_udc_ep);
-	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));;
+	memcpy(usba_udc_data.ep, usba_udc_ep, sizeof(usba_udc_ep));
 
 	if (data && data->vbus_pin > 0) {
 		at91_set_gpio_input(data->vbus_pin, 0);
diff --git a/arch/arm/mach-w90x900/w90p910.c b/arch/arm/mach-w90x900/w90p910.c
index 1c97e49..0399a24 100644
--- a/arch/arm/mach-w90x900/w90p910.c
+++ b/arch/arm/mach-w90x900/w90p910.c
@@ -62,7 +62,7 @@ static DEFINE_CLK(atapi, 6);
 static DEFINE_CLK(emc, 7);
 static DEFINE_CLK(usbd, 8);
 static DEFINE_CLK(usbh, 9);
-static DEFINE_CLK(g2d, 10);;
+static DEFINE_CLK(g2d, 10);
 static DEFINE_CLK(pwm, 18);
 static DEFINE_CLK(ps2, 24);
 static DEFINE_CLK(kpi, 25);
diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index 8aee763..c2106d5 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -53,7 +53,7 @@ int imx_irq_set_priority(unsigned char irq, unsigned char prio)
 	unsigned int mask = 0x0F << irq % 8 * 4;
 
 	if (irq >= MXC_INTERNAL_IRQS)
-		return -EINVAL;;
+		return -EINVAL;
 
 	temp = __raw_readl(avic_base + AVIC_NIPRIORITY(irq / 8));
 	temp &= ~mask;

