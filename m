Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZFWDrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZFWDrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbZFWDqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:46:33 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53179 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbZFWDqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:46:32 -0400
Date: Mon, 22 Jun 2009 23:46:26 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 5/5] Revert "power_supply: remove capacity_level from list
 of sysfs attributes"
Message-ID: <20090622234626.677cdab3@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 4cbc76eadf56399cd11fb736b33c53aec9caab8c.

This is part of the CAPACITY_LEVEL re-add.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/power_supply_sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index fef37b2..d22d9c9 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -116,6 +116,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(energy_now),
 	POWER_SUPPLY_ATTR(energy_avg),
 	POWER_SUPPLY_ATTR(capacity),
+	POWER_SUPPLY_ATTR(capacity_level),
 	POWER_SUPPLY_ATTR(temp),
 	POWER_SUPPLY_ATTR(temp_ambient),
 	POWER_SUPPLY_ATTR(time_to_empty_now),
-- 
1.5.6.5

