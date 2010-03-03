Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab0CCJ7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 04:59:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34876
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750800Ab0CCJ7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 04:59:12 -0500
Date: Wed, 03 Mar 2010 01:59:29 -0800 (PST)
Message-Id: <20100303.015929.79253256.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: richard.rojfors@mocean-labs.com, akpm@linux-foundation.org
Subject: [PATCH] timbgpio: Fix build.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use of get_irq_chip_data() et al. requires including
linux/irq.h

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
index a4d344b..d941f45 100644
--- a/drivers/gpio/timbgpio.c
+++ b/drivers/gpio/timbgpio.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
+#include <linux/irq.h>
 #include <linux/io.h>
 #include <linux/timb_gpio.h>
 #include <linux/interrupt.h>
