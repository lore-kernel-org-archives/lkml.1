Return-Path: <linux-kernel-owner+w=401wt.eu-S1765932AbYD1GBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765932AbYD1GBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764962AbYD1F76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:59:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43532 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbYD1F75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:59:57 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] typo in sata_fsl
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1JqMP5-0004nc-Vz@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 28 Apr 2008 06:59:55 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it's ata_link, not ata_linke

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ata/sata_fsl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index fddd346..853559e 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -678,7 +678,7 @@ static unsigned int sata_fsl_dev_classify(struct ata_port *ap)
 	return ata_dev_classify(&tf);
 }
 
-static int sata_fsl_prereset(struct ata_linke *link, unsigned long deadline)
+static int sata_fsl_prereset(struct ata_link *link, unsigned long deadline)
 {
 	/* FIXME: Never skip softreset, sata_fsl_softreset() is
 	 * combination of soft and hard resets.  sata_fsl_softreset()
-- 
1.5.3.GIT


