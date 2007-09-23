Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbXIWGNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbXIWGNj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 02:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752970AbXIWGNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 02:13:32 -0400
Received: from [85.8.24.16] ([85.8.24.16]:58054 "EHLO smtp.drzeus.cx"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXIWGNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 02:13:31 -0400
Date: Sun, 23 Sep 2007 08:14:08 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: rpurdie@rpsys.net, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: add missing header
Message-ID: <20070923081408.312e02c3@poseidon.drzeus.cx>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rwlocks are used in the structures so make sure the right header
is included.

Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/include/linux/leds.h b/include/linux/leds.h
index 4211750..6518c32 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -13,6 +13,7 @@
 #define __LINUX_LEDS_H_INCLUDED
 
 #include <linux/list.h>
+#include <linux/rwsem.h>
 
 struct device;
 /*


-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
