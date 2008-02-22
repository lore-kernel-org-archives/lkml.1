Return-Path: <linux-kernel-owner+w=401wt.eu-S1764418AbYBVWqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764418AbYBVWqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbYBVWpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:45:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:48211 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758078AbYBVWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:45:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Qua0iiMLLu/3IvTbpM7XCdk5nSe0c7LXC5+SnAw/G2RUrPAf2cwXEvOX53uBIO79TOypcTDLF3dLREh/u9TTX6REZQtSsh0OjZZv6yaNFBG4fJl/LDk3fPXOKVGQaPVXWJFLC4tsuOS5ziR37VcQZQEygJT2HmEtl884EwyO2kc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: remove redundant comment from ide_unregister()
Date: Fri, 22 Feb 2008 23:57:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222357.07781.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Identical comment is present in ide_hwif_release_regions() documentation.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
goes after "hpt366: fix section mismatch warnings" patch in IDE quilt tree

 drivers/ide/ide.c |    5 -----
 1 file changed, 5 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -590,11 +590,6 @@ void ide_unregister(unsigned int index, 
 		hwif->extra_ports = 0;
 	}
 
-	/*
-	 * Note that we only release the standard ports,
-	 * and do not even try to handle any extra ports
-	 * allocated for weird IDE interface chipsets.
-	 */
 	ide_hwif_release_regions(hwif);
 
 	/* copy original settings */
