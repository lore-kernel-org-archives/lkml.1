Return-Path: <linux-kernel-owner+w=401wt.eu-S964868AbXGSNyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964868AbXGSNyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936497AbXGSNso
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762312AbXGSNsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:43 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: abogani@texware.it, johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [13/48] x86_64: fix typo in acpi_pm.c
Message-Id: <20070719134842.661DD14E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alessio Igor Bogani <abogani@texware.it>

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/acpi_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/clocksource/acpi_pm.c
===================================================================
--- linux.orig/drivers/clocksource/acpi_pm.c
+++ linux/drivers/clocksource/acpi_pm.c
@@ -71,7 +71,7 @@ static struct clocksource clocksource_ac
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be caluclated*/
+	.mult		= 0, /*to be calculated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
