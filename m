Return-Path: <linux-kernel-owner+w=401wt.eu-S1763719AbYCAQ2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763719AbYCAQ2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 11:28:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762880AbYCAQYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 11:24:40 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55880 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762477AbYCAQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 11:24:39 -0500
Date: Sat, 1 Mar 2008 18:23:13 +0200
From: Adrian Bunk <bunk@kernel.org>
To: chas@cmf.nrl.navy.mil, jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] atm/idt77252.c: make 2 functions static
Message-ID: <20080301162313.GZ25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the following needlessly global functions static:
- idt77252_send()
- idt77252_dev_close()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/atm/idt77252.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

36dff5da01d6548a345e7d9a115ee3121df95591 foobar
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index eee54c0..9e94b64 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2016,8 +2016,7 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 	return 0;
 }
 
-int
-idt77252_send(struct atm_vcc *vcc, struct sk_buff *skb)
+static int idt77252_send(struct atm_vcc *vcc, struct sk_buff *skb)
 {
 	return idt77252_send_skb(vcc, skb, 0);
 }
@@ -3072,8 +3071,7 @@ idt77252_dev_open(struct idt77252_dev *card)
 	return 0;
 }
 
-void
-idt77252_dev_close(struct atm_dev *dev)
+static void idt77252_dev_close(struct atm_dev *dev)
 {
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;

