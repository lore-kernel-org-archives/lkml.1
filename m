Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbXFULxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbXFULxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 07:53:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXFULw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 07:52:59 -0400
Received: from hermes.xcon.it ([62.48.35.101]:58248 "EHLO hermes.xcon.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbXFULw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 07:52:58 -0400
X-Greylist: delayed 1271 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 07:52:58 EDT
Subject: [PATCH] fix typo in acpi_pm.c
From: Alessio Igor Bogani <abogani@texware.it>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 13:31:44 +0200
Message-Id: <1182425504.20716.4.camel@godzilla.tecnorama.it>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/clocksource/acpi_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/clocksource/acpi_pm.c
b/drivers/clocksource/acpi_pm.c
index 5cfcff5..7d25010 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -71,7 +71,7 @@ static struct clocksource clocksource_acpi_pm = {
 	.rating		= 200,
 	.read		= acpi_pm_read,
 	.mask		= (cycle_t)ACPI_PM_MASK,
-	.mult		= 0, /*to be caluclated*/
+	.mult		= 0, /*to be calculated*/
 	.shift		= 22,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
 
-- 
1.4.4.2


