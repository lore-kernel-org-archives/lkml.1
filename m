Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbXKERK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbXKERK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXKERHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:06 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59486 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757411AbXKERHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:03 -0500
Date: Mon, 5 Nov 2007 18:06:38 +0100
From: Adrian Bunk <bunk@kernel.org>
To: v4l-dvb-maintainer@linuxtv.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] dvb-core/dvb_ringbuffer.c: remove unused exports
Message-ID: <20071105170637.GC12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the following unused EXPORT_SYMBOL's:
- dvb_ringbuffer_flush
- dvb_ringbuffer_pkt_write
- dvb_ringbuffer_pkt_read
- dvb_ringbuffer_pkt_dispose
- dvb_ringbuffer_pkt_next

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/media/dvb/dvb-core/dvb_ringbuffer.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.17-rc1-mm3-full/drivers/media/dvb/dvb-core/dvb_ringbuffer.c.old	2006-04-19 21:47:58.000000000 +0200
+++ linux-2.6.17-rc1-mm3-full/drivers/media/dvb/dvb-core/dvb_ringbuffer.c	2006-04-19 21:48:57.000000000 +0200
@@ -262,11 +262,6 @@
 EXPORT_SYMBOL(dvb_ringbuffer_empty);
 EXPORT_SYMBOL(dvb_ringbuffer_free);
 EXPORT_SYMBOL(dvb_ringbuffer_avail);
-EXPORT_SYMBOL(dvb_ringbuffer_flush);
 EXPORT_SYMBOL(dvb_ringbuffer_flush_spinlock_wakeup);
 EXPORT_SYMBOL(dvb_ringbuffer_read);
 EXPORT_SYMBOL(dvb_ringbuffer_write);
-EXPORT_SYMBOL(dvb_ringbuffer_pkt_write);
-EXPORT_SYMBOL(dvb_ringbuffer_pkt_read);
-EXPORT_SYMBOL(dvb_ringbuffer_pkt_dispose);
-EXPORT_SYMBOL(dvb_ringbuffer_pkt_next);

