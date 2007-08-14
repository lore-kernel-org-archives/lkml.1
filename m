Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbXHNVer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbXHNVer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756667AbXHNVXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38440 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755753AbXHNVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:23:16 -0400
Date: Tue, 14 Aug 2007 23:23:07 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [-mm patch] unexport ide_acpi_set_state
Message-ID: <20070814212307.GK18945@stusta.de>
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
> +ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
>...
>  IDE tree updates
>...

This patch removes the unused EXPORT_SYMBOL_GPL(ide_acpi_set_state)

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

83b4e185ad61709d63cb44516b46a343d221d9f9 
diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
index 6bff81a..1d5f682 100644
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -649,7 +649,6 @@ void ide_acpi_set_state(ide_hwif_t *hwif, int on)
 	if (!on)
 		acpi_bus_set_power(hwif->acpidata->obj_handle, ACPI_STATE_D3);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_set_state);
 
 /**
  * ide_acpi_init - initialize the ACPI link for an IDE interface

