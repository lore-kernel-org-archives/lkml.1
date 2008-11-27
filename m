Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYK1Tnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYK1Tnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 14:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbYK1Tnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 14:43:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:2969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbYK1Tnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 14:43:32 -0500
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Thu, 27 Nov 2008 23:23:38 +0100
Subject: [PATCH] alim15x3: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <493049e1.0ab6660a.0bc3.ffffaf3b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/ide/alim15x3.c:594:2: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/ide/alim15x3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/alim15x3.c b/drivers/ide/alim15x3.c
index e56c7b7..45d2356 100644
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -591,7 +591,7 @@ static int __init ali15x3_ide_init(void)
 
 static void __exit ali15x3_ide_exit(void)
 {
-	return pci_unregister_driver(&alim15x3_pci_driver);
+	pci_unregister_driver(&alim15x3_pci_driver);
 }
 
 module_init(ali15x3_ide_init);
-- 
1.5.6.3

