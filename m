Return-Path: <linux-kernel-owner+w=401wt.eu-S1764039AbYEESks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764039AbYEESks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbYEESaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:30:01 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33104 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761539AbYEESaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:30:00 -0400
Date: Mon, 5 May 2008 21:28:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] #if 0 hpet_unregister()
Message-ID: <20080505182853.GS17139@cs181133002.pp.htv.fi>
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
- 23 Apr 2008
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


