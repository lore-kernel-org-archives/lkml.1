Return-Path: <linux-kernel-owner+w=401wt.eu-S1760567AbZBLUaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760567AbZBLUaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 15:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760539AbZBLU24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 15:28:56 -0500
Received: from kroah.org ([198.145.64.141]:58983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760523AbZBLU2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 15:28:55 -0500
Subject: patch staging-rt2860-fix-printk-format-warnings.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org
From: <gregkh@suse.de>
Date: Thu, 12 Feb 2009 12:25:21 -0800
In-Reply-To: <20090211131822.4ba1a6bc.randy.dunlap@oracle.com>
Message-ID: <12344703212048@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: rt2860: fix printk format warnings

to my gregkh-2.6 tree.  Its filename is

    staging-rt2860-fix-printk-format-warnings.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Thu Feb 12 11:53:04 2009
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 11 Feb 2009 13:18:22 -0800
Subject: Staging: rt2860: fix printk format warnings
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de
Message-ID: <20090211131822.4ba1a6bc.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix staging/rt28x0 printk format warnings:

linux-next-20090209/drivers/staging/rt2860/common/spectrum.c:1599: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
linux-next-20090209/drivers/staging/rt2860/rt_linux.c:857: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

linux-next-20090209/drivers/staging/rt2870/common/spectrum.c:1598: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'
linux-next-20090209/drivers/staging/rt2870/rt_linux.c:898: warning: format '%d' expects type 'int', but argument 3 has type 'long unsigned int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/common/spectrum.c |    2 +-
 drivers/staging/rt2860/rt_linux.c        |    2 +-
 drivers/staging/rt2870/common/spectrum.c |    2 +-
 drivers/staging/rt2870/rt_linux.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1596,7 +1596,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%zu).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -854,7 +854,7 @@ void send_monitor_packets(
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%zu)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 
--- a/drivers/staging/rt2870/common/spectrum.c
+++ b/drivers/staging/rt2870/common/spectrum.c
@@ -1595,7 +1595,7 @@ static VOID PeerMeasureReportAction(
 
 	if ((pMeasureReportInfo = kmalloc(sizeof(MEASURE_RPI_REPORT), GFP_ATOMIC)) == NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%d).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
+		DBGPRINT(RT_DEBUG_ERROR, ("%s unable to alloc memory for measure report buffer (size=%zu).\n", __func__, sizeof(MEASURE_RPI_REPORT)));
 		return;
 	}
 
--- a/drivers/staging/rt2870/rt_linux.c
+++ b/drivers/staging/rt2870/rt_linux.c
@@ -895,7 +895,7 @@ void send_monitor_packets(
 
     if (pRxBlk->DataSize + sizeof(wlan_ng_prism2_header) > RX_BUFFER_AGGRESIZE)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%d)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
+        DBGPRINT(RT_DEBUG_ERROR, ("%s : Size is too large! (%zu)\n", __func__, pRxBlk->DataSize + sizeof(wlan_ng_prism2_header)));
 		goto err_free_sk_buff;
     }
 


Patches currently in gregkh-2.6 which might be from randy.dunlap@oracle.com are

pending/firmware-add-kconfig-and-makefile-to-build-the-firmware-samples.patch
staging/staging-dst-kconfig-update.patch
staging/staging-dst-fix-build-dependancy.patch
staging/staging-rt2860-fix-printk-format-warnings.patch
staging/staging-rtl8187se-fix-kconfig-dependencies.patch
staging/staging-rtl8187se-fix-printk-format-warnings.patch
staging/staging-stlc45xx-fix-printk-format-warnings.patch
staging/staging-otus-fix-mixed-declarations.patch
staging/staging-android-ram_console-fix-printk-format-warning.patch
staging/staging-android-binder-fix-printk-format-warnings.patch
staging/staging-altera-fix-printk-format-warnings.patch
