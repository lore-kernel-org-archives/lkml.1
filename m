Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYBEQds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYBEQds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:33:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYBEQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:33:40 -0500
Received: from liberdade.minaslivre.org ([72.232.18.203]:43749 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYBEQdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:33:39 -0500
X-Greylist: delayed 1198 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 11:33:39 EST
Date: Tue, 5 Feb 2008 14:13:36 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] power_supply: Remove capacity_level from list of sysfs
	attributes
Message-ID: <20080205161327.GA8628@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/power/power_supply_sysfs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index d482484..13399d1 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -106,7 +106,6 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(energy_now),
 	POWER_SUPPLY_ATTR(energy_avg),
 	POWER_SUPPLY_ATTR(capacity),
-	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
 	POWER_SUPPLY_ATTR(temp_ambient),
 	POWER_SUPPLY_ATTR(time_to_empty_now),
-- 
1.5.4
