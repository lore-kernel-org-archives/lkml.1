Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbYDWSWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbYDWSWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYDWSWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:22:31 -0400
Received: from mail.vyatta.com ([216.93.170.194]:55631 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbYDWSWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:22:30 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.35
Date: Wed, 23 Apr 2008 11:22:23 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>,
       Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: pasic3 driver build error
Message-ID: <20080423112223.4df31c56@extreme>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure on other platforms because this driver includes
registers that do not exist on other platforms.

Signed-off-by: Stephen Hemminger <stephen.hemminger@vyatta.com>

--- a/drivers/mfd/Kconfig	2008-04-23 11:16:06.000000000 -0700
+++ b/drivers/mfd/Kconfig	2008-04-23 11:16:52.000000000 -0700
@@ -32,6 +32,7 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
+	depends on ARCH_PXA
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
