Return-Path: <linux-kernel-owner+w=401wt.eu-S1758692AbXFLHCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692AbXFLHCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 03:02:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbXFLHAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 03:00:35 -0400
Received: from brick.kernel.dk ([80.160.20.94]:13569 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbXFLHAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 03:00:31 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 6/18] splice: add void cookie to the actor data
Date: Tue, 12 Jun 2007 08:58:02 +0200
Message-Id: <11816314952967-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.1.174.gcd03
In-Reply-To: <11816314942627-git-send-email-jens.axboe@oracle.com>
References: <11816314942627-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need that for passing driver private info.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 include/linux/pipe_fs_i.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index c2bda03..1789ec7 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -94,6 +94,7 @@ struct splice_desc {
 	union {
 		void __user *userptr;	/* memory to write to */
 		struct file *file;	/* file to read/write */
+		void *data;		/* cookie */
 	};
 	loff_t pos;			/* file position */
 };
-- 
1.5.2.1.174.gcd03

