Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbZCJQuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbZCJQuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZCJQn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:58 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34613 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267AbZCJQnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:40 -0400
Message-Id: <e9ed6af99548c6ee3c60e9fa1bea27ce9dd8aae3.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 18:43:26 +0000
Subject: [PATCH 24/31] paride: Auto-load pt module when device opened.
To: linux-kernel@vger.kernel.org
Cc: tim@cyberelk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pt module is missing the char-major-96-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/paride/pt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 1e4006e..e298e75 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -1008,5 +1008,6 @@ static void __exit pt_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(PT_MAJOR);
 module_init(pt_init)
 module_exit(pt_exit)
-- 
1.6.0.5

