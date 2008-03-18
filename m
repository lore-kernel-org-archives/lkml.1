Return-Path: <linux-kernel-owner+w=401wt.eu-S939235AbYCSVza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939235AbYCSVza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbYCSUVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:21:42 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:28526 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932504AbYCSUVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:21:41 -0400
X-YMail-OSG: IdeAivwVM1nndusYa3cYcQ6zGS2c0Yoht6TNO8DMKncx0pWKTnEvB7voZlS8EGCjfqpAWG.5SA--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 18 Mar 2008 15:06:48 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Len Brown <len.brown@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Add 'short help text' to ATA_ACPI so it's [de]selectable.
Message-ID: <20080318220648.GA31208@puku.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ATA_ACPI isn't selectable right now because it lacks 'short help
text'.  This means it's always enabled and always enables ACPI_DOCK.
Add text so it's now [de]selectable.

cc: Jeff Garzik <jeff@garzik.org>
cc: Tejun Heo <htejun@gmail.com>
cc: Len Brown <len.brown@intel.com>
Signed-off-by: Chris Wedgwood <cw@f00f.org>

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 25aba69..ea665c2 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -28,7 +28,7 @@ config ATA_NONSTANDARD
        default n

 config ATA_ACPI
-	bool
+	bool "ATA ACPI Support"
 	depends on ACPI && PCI
 	select ACPI_DOCK
 	default y
