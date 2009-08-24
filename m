Return-Path: <linux-kernel-owner+w=401wt.eu-S1752025AbZHXH6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbZHXH6O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZHXH6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:58:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45647 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbZHXH5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:57:07 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, benh@kernel.crashing.org, htejun@gmail.com,
       bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 7/7] bio: convert integrity to lazy workqueues
Date: Mon, 24 Aug 2009 09:56:56 +0200
Message-Id: <1251100616-28604-8-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.4.173.g3f189
In-Reply-To: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 fs/bio-integrity.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index 49a34e7..cfd256e 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -780,7 +780,7 @@ void __init bio_integrity_init(void)
 {
 	unsigned int i;
 
-	kintegrityd_wq = create_workqueue("kintegrityd");
+	kintegrityd_wq = create_lazy_workqueue("kintegrityd");
 	if (!kintegrityd_wq)
 		panic("Failed to create kintegrityd\n");
 
-- 
1.6.4.173.g3f189

