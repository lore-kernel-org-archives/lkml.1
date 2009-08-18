Return-Path: <linux-kernel-owner+w=401wt.eu-S1758061AbZHRJyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758061AbZHRJyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbZHRJyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:54:07 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46101 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049AbZHRJyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:54:06 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 05:54:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cOrSqDoY1P2nya1DjGgK2uXXoZBLxO06tmMvL2eZjGC+1sRdpY/kSerw/ESrQlRQ4G
         Yf1peOoTdxjCOgVN7ySc1Eff+NP+iEWyJGaB3QOzLN7MpSHM+mEJPAP/ta6eqjgEBY3n
         OocroM0pEi4Qz1XiA6cNLmpSiPO2ZBLcW8yKg=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/2] Staging: sep: should depend on PCI
Date: Tue, 18 Aug 2009 13:48:51 +0400
Message-Id: <1250588932-7595-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error when CONFIG_PCI is not set
drivers/staging/sep/sep_driver.c:2548: error: implicit declaration of function 'pci_dev_get'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/staging/sep/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/Kconfig b/drivers/staging/sep/Kconfig
index 6ef59f8..2045809 100644
--- a/drivers/staging/sep/Kconfig
+++ b/drivers/staging/sep/Kconfig
@@ -2,6 +2,7 @@ config DX_SEP
 	tristate "Discretix SEP driver"
 #	depends on MRST
 	depends on RAR_REGISTER
+	depends on PCI
 	default y
 	help
 	  Discretix SEP driver
-- 
1.6.4

