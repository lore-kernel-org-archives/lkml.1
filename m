Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbXG2PIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbXG2PIg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764650AbXG2O7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:23 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47844 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764499AbXG2O7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:19 -0400
Date: Sun, 29 Jul 2007 16:58:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: [-mm patch] make scsi_host_link_pm_policy() static
Message-ID: <20070729145855.GB16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +ata-ahci-alpm-expose-power-management-policy-option-to-users.patch
>...
>  ata things
>...

scsi_host_link_pm_policy() can become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/scsi/scsi_sysfs.c.old	2007-07-26 21:31:24.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/scsi/scsi_sysfs.c	2007-07-26 21:31:57.000000000 +0200
@@ -200,7 +200,7 @@
 	{ SHOST_MEDIUM_POWER, "medium_power" },
 };
 
-const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
+static const char *scsi_host_link_pm_policy(enum scsi_host_link_pm policy)
 {
 	int i;
 	char *name = NULL;

