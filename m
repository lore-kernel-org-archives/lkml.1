Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZG3KZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZG3KZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZG3KZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:25:33 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:37922 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbZG3KZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:25:28 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, deller@gmx.de, kyle@mcmartin.ca,
       grundler@parisc-linux.org, akpm@linux-foundation.org, achiang@hp.com,
       bunk@kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH 3/4] [parisc] fixed faulty check
Date: Thu, 30 Jul 2009 05:25:19 -0500
Message-ID: <1248949519-20858-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/parisc/lba_pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index ede6146..3aeb327 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -992,7 +992,7 @@ lba_pat_resources(struct parisc_device *pa_dev, struct lba_device *lba_dev)
 		return;
 
 	io_pdc_cell = kzalloc(sizeof(pdc_pat_cell_mod_maddr_block_t), GFP_KERNEL);
-	if (!pa_pdc_cell) {
+	if (!io_pdc_cell) {
 		kfree(pa_pdc_cell);
 		return;
 	}
-- 
1.6.3.3

