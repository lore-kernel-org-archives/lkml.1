Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYAPXU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYAPXU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755251AbYAPXPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:10411 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbYAPXPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=WqEKdeiCsca3z7wfrkuWU92a1eBJWx2Crjt7tHi5/zyuS3rYa6CPB05qKWHQEb3EDMoOh9XQSPyNKbXEPAqJswTn+/mHD/zuYeUU0btYgKV3AUtGKIlgeW43smw/fgciRS/wfTvt0bQSJ+inDTacc/++ZJT1oz+75iu9T6EHJ08=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:28:11 +0100
Message-Id: <20080116232811.9166.38451.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/22] ide-acpi: remove needless exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-acpi.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/ide/ide-acpi.c
===================================================================
--- a/drivers/ide/ide-acpi.c
+++ b/drivers/ide/ide-acpi.c
@@ -494,7 +494,6 @@ int ide_acpi_exec_tfs(ide_drive_t *drive
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(ide_acpi_exec_tfs);
 
 /**
  * ide_acpi_get_timing - get the channel (controller) timings
@@ -580,7 +579,6 @@ void ide_acpi_get_timing(ide_hwif_t *hwi
 
 	kfree(output.pointer);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_get_timing);
 
 /**
  * ide_acpi_push_timing - set the channel (controller) timings
@@ -634,7 +632,6 @@ void ide_acpi_push_timing(ide_hwif_t *hw
 	}
 	DEBPRINT("_STM status: %d\n", status);
 }
-EXPORT_SYMBOL_GPL(ide_acpi_push_timing);
 
 /**
  * ide_acpi_set_state - set the channel power state
@@ -762,4 +759,3 @@ void ide_acpi_init(ide_hwif_t *hwif)
 		}
 	}
 }
-EXPORT_SYMBOL_GPL(ide_acpi_init);
