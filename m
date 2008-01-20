Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYATSTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYATSTQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754452AbYATSTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:19:06 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:45006 "EHLO
	mk-filter-3-a-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753677AbYATSTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:19:04 -0500
X-Trace: 672588260/mk-filter-3.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.29
X-SBRS: None
X-RemoteIP: 81.1.80.29
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAOoek0dRAVAd/2dsb2JhbACBV6lw
Subject: [PATCH] SG - fix SH Kconfig
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 20 Jan 2008 18:18:29 +0000
Message-Id: <1200853109.6331.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian McMenamin <adrian@mcmen.demon.co.uk>


Remove reference to board deleted in commit 758e06ded4c48024835ef0a14627afcde2e25929

Submitted-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
---

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 85bd9ac..e94430b 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -518,7 +518,6 @@ config SH_CAYMAN
 
 endmenu
 
-source "arch/sh/boards/renesas/hs7751rvoip/Kconfig"
 source "arch/sh/boards/renesas/rts7751r2d/Kconfig"
 source "arch/sh/boards/renesas/r7780rp/Kconfig"
 source "arch/sh/boards/magicpanelr2/Kconfig"

