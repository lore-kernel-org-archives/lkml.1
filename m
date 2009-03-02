Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZCJQwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZCJQwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZCJQoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:04 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34603 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <b621a1c3444b9b45c30be6c67e812814438bb474.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:40:04 +0000
Subject: [PATCH 09/31] paride: Auto-load pcd module when device opened.
To: linux-kernel@vger.kernel.org
Cc: tim@cyberelk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcd module is missing the block-major-46-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/paride/pcd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index e91d4b4..d8a31c5 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -967,5 +967,6 @@ static void __exit pcd_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_BLOCKDEV_MAJOR(PCD_MAJOR);
 module_init(pcd_init)
 module_exit(pcd_exit)
-- 
1.6.0.5

