Return-Path: <linux-kernel-owner+w=401wt.eu-S1762562AbXEUKRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762562AbXEUKRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757220AbXEUKJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:43 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33581 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761449AbXEUKJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:20 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510289:sNHT22655052"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 06/32] Blackfin arch: mark a bunch of local functions as static
Date: Mon, 21 May 2007 18:09:14 +0800
Message-Id: <11797421832656-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |    2 +-
 arch/blackfin/kernel/bfin_gpio.c    |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 8ea079e..1431424 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -119,7 +119,7 @@ static void clear_dma_buffer(unsigned int channel)
 	SSYNC();
 }
 
-int __init blackfin_dma_init(void)
+static int __init blackfin_dma_init(void)
 {
 	int i;
 
diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index e9f24a9..bc16252 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -144,7 +144,7 @@ inline int check_gpio(unsigned short gpio)
 }
 
 #ifdef BF537_FAMILY
-void port_setup(unsigned short gpio, unsigned short usage)
+static void port_setup(unsigned short gpio, unsigned short usage)
 {
 	if (usage == GPIO_USAGE) {
 		if (*port_fer[gpio_bank(gpio)] & gpio_bit(gpio))
@@ -160,7 +160,7 @@ void port_setup(unsigned short gpio, unsigned short usage)
 #endif
 
 
-void default_gpio(unsigned short gpio)
+static void default_gpio(unsigned short gpio)
 {
 	unsigned short bank,bitmask;
 
@@ -177,8 +177,7 @@ void default_gpio(unsigned short gpio)
 	gpio_bankb[bank]->edge &= ~bitmask;
 }
 
-
-int __init bfin_gpio_init(void)
+static int __init bfin_gpio_init(void)
 {
 	int i;
 
-- 
1.5.1.2
