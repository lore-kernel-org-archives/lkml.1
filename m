Return-Path: <linux-kernel-owner+w=401wt.eu-S1752810AbXHNVdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbXHNVdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbXHNVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:15 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:38427 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755214AbXHNVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:09 -0400
Date: Tue, 14 Aug 2007 23:23:00 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [-mm patch] make
	drivers/ata/libata-scsi.c:ata_scsi_link_pm_policy() static
Message-ID: <20070814212259.GI18945@stusta.de>
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.23-rc2-mm1:
>...
> +alpm-enable-link-power-management-for-ata-drivers.patch
>...
>  Updated ATA Aggressive Link Power Management patches
>...


ata_scsi_link_pm_policy() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
91a4450d6bf353600316328f0a95299e8bb17ee0 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ce631eb..1db065c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -121,7 +121,7 @@ static const struct {
 	{ MEDIUM_POWER, "medium_power" },
 };
 
-const char *ata_scsi_link_pm_policy(enum link_pm policy)
+static const char *ata_scsi_link_pm_policy(enum link_pm policy)
 {
 	int i;
 	char *name = NULL;

