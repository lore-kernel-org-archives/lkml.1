Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbYDNO0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbYDNO0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761699AbYDNOVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:21:48 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41418 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761683AbYDNOVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:21:47 -0400
Date: Mon, 14 Apr 2008 17:20:42 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make parport_cs_release() static
Message-ID: <20080414142042.GX6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global parport_cs_release() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
5b7ec7ccc6ba2d62a2e68a2211049cbdfa2b5dea diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index 802a81d..00e1d96 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -235,7 +235,7 @@ failed:
     
 ======================================================================*/
 
-void parport_cs_release(struct pcmcia_device *link)
+static void parport_cs_release(struct pcmcia_device *link)
 {
 	parport_info_t *info = link->priv;
 

