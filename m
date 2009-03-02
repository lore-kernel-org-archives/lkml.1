Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZCJQvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZCJQvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755772AbZCJQn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:59 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34611 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <a4553a6f4cec3d5e844b2106484c69f66090777a.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:42:39 +0000
Subject: [PATCH 23/31] mtd: Auto-load mtdchar module when device opened.
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mtdchar module is missing the char-major-90-* alias that would cause
it to be auto-loaded when a device of that type is opened.  This patch
adds the alia..

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/mtd/mtdchar.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index e9ec59e..2c8a16f 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -825,3 +825,4 @@ module_exit(cleanup_mtdchar);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("Direct character-device access to MTD devices");
+MODULE_ALIAS_CHARDEV_MAJOR(MTD_CHAR_MAJOR);
-- 
1.6.0.5

