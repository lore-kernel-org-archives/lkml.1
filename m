Return-Path: <linux-kernel-owner+w=401wt.eu-S1756018AbYDWJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018AbYDWJwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbYDWJvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:51:12 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46005 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYDWJvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:51:11 -0400
Date: Wed, 23 Apr 2008 12:50:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 hpet_unregister()
Message-ID: <20080423095031.GL28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused hpet_unregister().

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Clemens Ladisch <clemens@ladisch.de>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008
- 1 Mar 2008

 drivers/char/hpet.c |    2 ++
 1 file changed, 2 insertions(+)

addfb1ea425cb7e01ddd99fd921c6ca42cc6840b foobar
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 465ad35..98ffdcc 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -619,6 +619,7 @@ static inline int hpet_tpcheck(struct hpet_task *tp)
 	return -ENXIO;
 }
 
+#if 0
 int hpet_unregister(struct hpet_task *tp)
 {
 	struct hpet_dev *devp;
@@ -648,6 +649,7 @@ int hpet_unregister(struct hpet_task *tp)
 
 	return 0;
 }
+#endif  /*  0  */
 
 static ctl_table hpet_table[] = {
 	{


