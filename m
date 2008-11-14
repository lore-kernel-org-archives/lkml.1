Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYKNUgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYKNUgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 15:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbYKNUgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 15:36:33 -0500
Received: from relay1.sgi.com ([192.48.179.29]:41203 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751399AbYKNUgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 15:36:32 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2008 15:36:32 EST
Date: Fri, 14 Nov 2008 14:27:57 -0600
From: Jack Steiner <steiner@sgi.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - GRU fix for debug option
Message-ID: <20081114202757.GA22353@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable -D DEBUG in the GRU Makefile if CONFIG_SGI_GRU_DEBUG is selected.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/drivers/misc/sgi-gru/Makefile
===================================================================
--- linux.orig/drivers/misc/sgi-gru/Makefile	2008-11-11 08:31:24.000000000 -0600
+++ linux/drivers/misc/sgi-gru/Makefile	2008-11-12 10:58:53.000000000 -0600
@@ -1,3 +1,7 @@
+ifdef CONFIG_SGI_GRU_DEBUG
+  EXTRA_CFLAGS	+= -DDEBUG
+endif
+
 obj-$(CONFIG_SGI_GRU) := gru.o
 gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
 
