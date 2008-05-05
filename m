Return-Path: <linux-kernel-owner+w=401wt.eu-S1760306AbYEESca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306AbYEESca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760715AbYEES1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:27:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:55010 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760712AbYEES1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:27:15 -0400
Date: Mon, 5 May 2008 21:26:07 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] make parport_cs_release() static
Message-ID: <20080505182607.GX17139@cs181133002.pp.htv.fi>
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

This patch has been sent on:
- 22 Apr 2008
- 14 Apr 2008

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
 

