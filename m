Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbYHHGkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbYHHGkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 02:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYHHGjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 02:39:49 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52929 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbYHHGjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 02:39:48 -0400
Message-ID: <489BEA3B.8030901@keyaccess.nl>
Date: Fri, 08 Aug 2008 08:39:55 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] PNP: resource type is now an unsigned long
Content-Type: multipart/mixed;
 boundary="------------020200050907020900090303"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020200050907020900090303
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Bjorn.

Andrew earlier commented Part 2.

Rene.

--------------020200050907020900090303
Content-Type: text/plain;
 name="0002-PNP-resource-type-is-now-an-unsigned-long.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-PNP-resource-type-is-now-an-unsigned-long.patch"

>From 6ce13e62efbe1670b204a32a2c2c3064ade2bb3f Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Sun, 20 Jul 2008 23:02:04 +0200
Subject: [PATCH] PNP: resource type is now an unsigned long

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 drivers/pnp/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pnp/quirks.c b/drivers/pnp/quirks.c
index 0bdf9b8..d15e2b7 100644
--- a/drivers/pnp/quirks.c
+++ b/drivers/pnp/quirks.c
@@ -245,7 +245,7 @@ static void quirk_system_pci_resources(struct pnp_dev *dev)
 	 */
 	for_each_pci_dev(pdev) {
 		for (i = 0; i < DEVICE_COUNT_RESOURCE; i++) {
-			unsigned int type;
+			unsigned long type;
 
 			type = pci_resource_flags(pdev, i) &
 					(IORESOURCE_IO | IORESOURCE_MEM);
-- 
1.5.5


--------------020200050907020900090303--
