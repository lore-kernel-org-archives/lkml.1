Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbZCJQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbZCJQuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZCJQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:57 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34617 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <8bc58f8647ad3792e5f4c912fb741b19cc4d6ee7.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:45:14 +0000
Subject: [PATCH 25/31] paride: Auto-load pg module when device opened.
To: linux-kernel@vger.kernel.org
Cc: tim@cyberelk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pg module is missing the char-major-97-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/paride/pg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index c397b3d..442853f 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -718,5 +718,6 @@ static void __exit pg_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(PG_MAJOR);
 module_init(pg_init)
 module_exit(pg_exit)
-- 
1.6.0.5

