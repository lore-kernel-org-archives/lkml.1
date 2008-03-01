Return-Path: <linux-kernel-owner+w=401wt.eu-S1763897AbYCAQ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763897AbYCAQ3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763264AbYCAQYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55885 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763255AbYCAQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:48 -0500
Date: Sat, 1 Mar 2008 18:23:23 +0200
From: Adrian Bunk <bunk@kernel.org>
To: clemens@ladisch.de
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 hpet_unregister()
Message-ID: <20080301162323.GB25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused hpet_unregister().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

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

