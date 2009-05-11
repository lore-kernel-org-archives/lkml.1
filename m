Return-Path: <linux-kernel-owner+w=401wt.eu-S1760337AbZEKWkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760337AbZEKWkd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758166AbZEKWkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:40:22 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58487 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971AbZEKWkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:40:21 -0400
Message-Id: <200905112240.20171.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 22:40:20 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: [PATCH] scsi: libsas depends on HAS_DMA
Content-Disposition: inline
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+4WlK1BkTITTzFHierYxu1/PhaEyJ3JorHHWs
 Llgq93fjcNxYk2OAbHlrH9UdN+RA9a4LUJm+ddVOKAx6XYyBnT
 KUKVw32x6kvP1FMolWNkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libsas uses the DMA mapping API, so it cannot be
built on architectures that don't support DMA.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/libsas/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 18f33cd..59e00fa 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -24,7 +24,7 @@
 
 config SCSI_SAS_LIBSAS
 	tristate "SAS Domain Transport Attributes"
-	depends on SCSI
+	depends on SCSI && HAS_DMA
 	select SCSI_SAS_ATTRS
 	help
 	  This provides transport specific helpers for SAS drivers which
-- 
1.6.0.4

-- 


