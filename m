Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYKUJWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYKUJWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYKUJVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:21:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:38461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYKUJVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:21:46 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH] Documentation: remove reference to ll_rw_blk.c and moved drivers/block/elevator.c
Date: Fri, 21 Nov 2008 14:53:29 +0530
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811211453.29936.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers/block/ll_rw_block.c has been split and organized in the block/ 
directory, and also drivers/block/elevator.c has been moved to the block/ 
directory. Update Documentation/block/biodoc.txt accordingly

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 4dbb8be..3c5434c 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -914,7 +914,7 @@ I/O scheduler, a.k.a. elevator, is implemented in two 
layers.  Generic dispatch
 queue and specific I/O schedulers.  Unless stated otherwise, elevator is used
 to refer to both parts and I/O scheduler to specific I/O schedulers.
 
-Block layer implements generic dispatch queue in ll_rw_blk.c and elevator.c.
+Block layer implements generic dispatch queue in block/*.c.
 The generic dispatch queue is responsible for properly ordering barrier
 requests, requeueing, handling non-fs requests and all other subtleties.
 
@@ -926,8 +926,8 @@ be built inside the kernel.  Each queue can choose 
different one and can also
 change to another one dynamically.
 
 A block layer call to the i/o scheduler follows the convention elv_xxx(). 
This
-calls elevator_xxx_fn in the elevator switch (drivers/block/elevator.c). Oh,
-xxx and xxx might not match exactly, but use your imagination. If an elevator
+calls elevator_xxx_fn in the elevator switch (block/elevator.c). Oh, xxx
+and xxx might not match exactly, but use your imagination. If an elevator
 doesn't implement a function, the switch does nothing or some minimal house
 keeping work.
 

