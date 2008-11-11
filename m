Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYKKK3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYKKK3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 05:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbYKKK3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 05:29:07 -0500
Received: from mailgate6.9netweb.it ([66.71.190.69]:44883 "EHLO
	mailgate6.9netweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYKKK3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 05:29:06 -0500
X-Greylist: delayed 1541 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Nov 2008 05:29:06 EST
Message-ID: <37718.89.97.65.173.1226397803.webmail@mail.evidence.eu.com>
Date: Tue, 11 Nov 2008 11:03:23 +0100 (CET)
Subject: [PATCH] Unused variable 'reg' removed
From: "Claudio Scordino" <claudio@evidence.eu.com>
To: kernel@pengutronix.de
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
User-Agent: WebMail/1.4.1
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20081111110323_45690"
X-Priority: 3
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20081111110323_45690
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Just a very trivial patch to remove one unused variable from the i.MX code.

Regards,

            Claudio
------=_20081111110323_45690
Content-Type: text/x-diff; name="0001-Unused-variable-reg-removed.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
      filename="0001-Unused-variable-reg-removed.patch"

>From 88d1d8f62ed1dd584c13c328b52bfbbac816dcc3 Mon Sep 17 00:00:00 2001
From: Claudio Scordino <claudio@evidence.eu.com>
Date: Tue, 11 Nov 2008 10:56:36 +0100
Subject: [PATCH 1/1] Unused variable 'reg' removed.


Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 arch/arm/plat-mxc/irq.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-mxc/irq.c b/arch/arm/plat-mxc/irq.c
index d862c9e..0cb3841 100644
--- a/arch/arm/plat-mxc/irq.c
+++ b/arch/arm/plat-mxc/irq.c
@@ -91,7 +91,6 @@ static struct irq_chip mxc_avic_chip = {
 void __init mxc_init_irq(void)
 {
 	int i;
-	u32 reg;
 
 	/* put the AVIC into the reset value with
 	 * all interrupts disabled
-- 
1.5.4.3

------=_20081111110323_45690--

