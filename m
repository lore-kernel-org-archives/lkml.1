Return-Path: <linux-kernel-owner+w=401wt.eu-S933307AbYBMVht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307AbYBMVht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759768AbYBMVaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:24 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47489 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbYBMVaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:18 -0500
Date: Wed, 13 Feb 2008 23:30:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: "Ed L. Cashin" <ecashin@coraid.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 aoedev_isbusy()
Message-ID: <20080213213002.GT3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the no longer used aoedev_isbusy().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/block/aoe/aoe.h    |    1 -
 drivers/block/aoe/aoedev.c |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

3a516f0cdfe99486288c8379714dc17aa2c0d4b4 diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 280e71e..5b4c6e6 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -195,7 +195,6 @@ void aoedev_exit(void);
 struct aoedev *aoedev_by_aoeaddr(int maj, int min);
 struct aoedev *aoedev_by_sysminor_m(ulong sysminor);
 void aoedev_downdev(struct aoedev *d);
-int aoedev_isbusy(struct aoedev *d);
 int aoedev_flush(const char __user *str, size_t size);
 
 int aoenet_init(void);
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index f9a1cd9..2f481d9 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -18,6 +18,7 @@ static void skbpoolfree(struct aoedev *d);
 static struct aoedev *devlist;
 static DEFINE_SPINLOCK(devlist_lock);
 
+#if 0
 int
 aoedev_isbusy(struct aoedev *d)
 {
@@ -35,6 +36,7 @@ aoedev_isbusy(struct aoedev *d)
 	}
 	return 0;
 }
+#endif  /*  0  */
 
 struct aoedev *
 aoedev_by_aoeaddr(int maj, int min)

