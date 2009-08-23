Return-Path: <linux-kernel-owner+w=401wt.eu-S933977AbZHWNaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933977AbZHWNaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 09:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933968AbZHWNaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 09:30:04 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:49132 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbZHWNaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 09:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=M7s4zqtQ0k9EtKe0gq5/Yu+Y550Sh5Qx5tW5vtCwWWJkpqEi0N50oeNOyDlq92d4mg
         CUHx/Ki29vSYTdL1zi49iQTUle1Q4aCZmM6jEBPLtpIH+EDh5zpYtjBda6ts94aB8SbY
         0eIIwKm+RPDcC0RLJvdtFBYqR1fBbV5QN4BhE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Date: Sun, 23 Aug 2009 15:30:30 +0200
Message-Id: <20090823133030.17784.84637.sendpatchset@localhost.localdomain>
In-Reply-To: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
References: <20090823132846.17784.13359.sendpatchset@localhost.localdomain>
Subject: [PATCH 16/33] Staging: rt28x0: fix fOP_STATUS_DOZE flag handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: fix fOP_STATUS_DOZE flag handling

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/common/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/staging/rt2860/common/mlme.c
===================================================================
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -8192,8 +8192,8 @@ VOID AsicEvaluateRxAnt(
 				fRTMP_ADAPTER_RADIO_OFF |
 				fRTMP_ADAPTER_NIC_NOT_EXIST |
 				fRTMP_ADAPTER_BSS_SCAN_IN_PROGRESS)
-#ifdef RT30xx
 				|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
+#ifdef RT30xx
 				|| (pAd->EepromAccess)
 #endif
 				)
@@ -8296,8 +8296,8 @@ VOID AsicRxAntEvalTimeout(
 							fRTMP_ADAPTER_HALT_IN_PROGRESS	|
 							fRTMP_ADAPTER_RADIO_OFF			|
 							fRTMP_ADAPTER_NIC_NOT_EXIST)
-#ifdef RT30xx
 							|| OPSTATUS_TEST_FLAG(pAd, fOP_STATUS_DOZE)
+#ifdef RT30xx
 							|| (pAd->EepromAccess)
 #endif // RT30xx //
 							)
