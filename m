Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXE1QLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXE1QLc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbXE1QKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:10:42 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:10108 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761971AbXE1QKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=AHIPammgwqYPe7dsP435e2cKP7IUF44fg8wp4HXKwG/9zsn0eDYkZsRvta44KCPeB2usJ8+5Ul33QxFaet9WLE/PhA/0twCpb1/ZM7wyxkSaACgnJ2I6/pAQ9VWztx6rpl6Mbdt0mSweCRbIcBSustSe6TE1GzqlEPiJLMQQeCQ=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 1/5] sysfs: make sysfs_alloc_ino() static
In-Reply-To: <1180368625600-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:10:25 +0900
Message-Id: <1180368625750-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_alloc_ino() isn't used out side of fs/sysfs/dir.c.  Make it
static.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index bc11a26..a63d12e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -20,7 +20,7 @@ spinlock_t kobj_sysfs_assoc_lock = SPIN_
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
 static DEFINE_IDA(sysfs_ino_ida);
 
-int sysfs_alloc_ino(ino_t *pino)
+static int sysfs_alloc_ino(ino_t *pino)
 {
 	int ino, rc;
 
-- 
1.4.3.4


