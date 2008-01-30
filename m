Return-Path: <linux-kernel-owner+w=401wt.eu-S1765270AbYA3UG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765270AbYA3UG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbYA3UBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:01:54 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40686 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbYA3UBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:01:53 -0500
Date: Wed, 30 Jan 2008 22:02:27 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jens Axboe <jens.axboe@oracle.com>, mpm@selenic.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport add_disk_randomness
Message-ID: <20080130200227.GS29368@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used EXPORT_SYMBOL(add_disk_randomness).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f1a195a30248eae541ba006633aa70385d1eb785 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5fee056..c511a83 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -667,8 +667,6 @@ void add_disk_randomness(struct gendisk *disk)
 	add_timer_randomness(disk->random,
 			     0x100 + MKDEV(disk->major, disk->first_minor));
 }
-
-EXPORT_SYMBOL(add_disk_randomness);
 #endif
 
 #define EXTRACT_SIZE 10

