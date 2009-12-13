Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZLMX5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZLMX5l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754848AbZLMX5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:57:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34675 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZLMX5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:36 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, jens.axboe@oracle.com,
       torvalds@linux-foundation.org, philipp.reisner@linbit.com
Subject: [PATCH 1/3] Constify struct block_device_operations for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:20 +0100
Message-Id: <cd6ad05207a2c539266329444e8db829d143f451.1260662995.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/block/drbd/drbd_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 157d1e4..af30ca9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -151,7 +151,7 @@ wait_queue_head_t drbd_pp_wait;
 
 DEFINE_RATELIMIT_STATE(drbd_ratelimit_state, 5 * HZ, 5);
 
-static struct block_device_operations drbd_ops = {
+static const struct block_device_operations drbd_ops = {
 	.owner =   THIS_MODULE,
 	.open =    drbd_open,
 	.release = drbd_release,
-- 
1.6.5.3

