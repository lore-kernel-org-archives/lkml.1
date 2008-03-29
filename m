Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYC2SoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYC2SoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 14:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbYC2Snz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 14:43:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:41931 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbYC2Sny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 14:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=KfmXEnAvbhqZ2ClYqqJ8zH7LD/MKSTV/2l+KQsPvkHAHaOVQnjcAWujnrJYhDefWGuqOVA3xnFuNaXcZt0EgBJaMpNt7lVFdjutDatitIZGQdDmASrNPBMvTaOb+yuiVvcvukQgVzwOomlG6WFr4/Le+Djkqty972VoyyCiF7kQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: fix defining SUPPORT_VLB_SYNC
Date: Sat, 29 Mar 2008 19:58:21 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803291958.22010.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to check for CONFIG_{CRIS,FRV} not {CRIS,FRV}.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -26,7 +26,7 @@
 #include <asm/semaphore.h>
 #include <asm/mutex.h>
 
-#if defined(CRIS) || defined(FRV)
+#if defined(CONFIG_CRIS) || defined(CONFIG_FRV)
 # define SUPPORT_VLB_SYNC 0
 #else
 # define SUPPORT_VLB_SYNC 1
