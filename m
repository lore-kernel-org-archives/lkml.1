Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbYFIW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbYFIW04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760639AbYFIWYC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:24:02 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:40985 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760625AbYFIWYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:24:00 -0400
Date: Tue, 10 Jun 2008 01:23:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make q40kbd_lock static
Message-ID: <20080609222306.GL1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global q40kbd_lock static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
1bf64b91d180438d8810ea49a02687657d3a488e diff --git a/drivers/input/serio/q40kbd.c b/drivers/input/serio/q40kbd.c
index d962a8d..52a531b 100644
--- a/drivers/input/serio/q40kbd.c
+++ b/drivers/input/serio/q40kbd.c
@@ -49,7 +49,7 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
 MODULE_DESCRIPTION("Q40 PS/2 keyboard controller driver");
 MODULE_LICENSE("GPL");
 
-DEFINE_SPINLOCK(q40kbd_lock);
+static DEFINE_SPINLOCK(q40kbd_lock);
 static struct serio *q40kbd_port;
 static struct platform_device *q40kbd_device;
 

