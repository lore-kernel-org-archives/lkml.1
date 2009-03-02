Return-Path: <linux-kernel-owner+w=401wt.eu-S1758179AbZCJQwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179AbZCJQwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZCJQoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:44:01 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34604 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081AbZCJQnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:39 -0400
Message-Id: <e8e8e1b5cc5b533bc63bb9345cc6ee918d543fb2.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:40:52 +0000
Subject: [PATCH 10/31] paride: Auto-load pf module when device opened.
To: linux-kernel@vger.kernel.org
Cc: tim@cyberelk.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pf module is missing the block-major-47-* alias that would cause it
to be auto-loaded when a device of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/block/paride/pf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bef3b99..8acbc43 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -988,5 +988,6 @@ static void __exit pf_exit(void)
 }
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_BLOCKDEV_MAJOR(PF_MAJOR);
 module_init(pf_init)
 module_exit(pf_exit)
-- 
1.6.0.5

