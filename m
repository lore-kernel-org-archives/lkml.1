Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXCEBx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXCEBx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXCEBtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:49:50 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49935 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbXCEBt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:49:26 -0500
Date: Mon, 5 Mar 2007 02:49:27 +0100
From: Adrian Bunk <bunk@stusta.de>
To: linux-driver@qlogic.com, Ron Mercer <ron.mercer@qlogic.com>
Cc: netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/net/qla3xxx.c: make 2 functions static
Message-ID: <20070305014927.GY3441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc2-mm1/drivers/net/qla3xxx.c.old	2007-03-04 21:41:27.000000000 +0100
+++ linux-2.6.21-rc2-mm1/drivers/net/qla3xxx.c	2007-03-04 21:41:39.000000000 +0100
@@ -1797,14 +1797,14 @@
 	atomic_inc(&qdev->tx_count);
 }
 
-void ql_get_sbuf(struct ql3_adapter *qdev)
+static void ql_get_sbuf(struct ql3_adapter *qdev)
 {
 	if (++qdev->small_buf_index == NUM_SMALL_BUFFERS)
 		qdev->small_buf_index = 0;
 	qdev->small_buf_release_cnt++;
 }
 
-struct ql_rcv_buf_cb *ql_get_lbuf(struct ql3_adapter *qdev)
+static struct ql_rcv_buf_cb *ql_get_lbuf(struct ql3_adapter *qdev)
 {
 	struct ql_rcv_buf_cb *lrg_buf_cb = NULL;
 	lrg_buf_cb = &qdev->lrg_buf[qdev->lrg_buf_index];

