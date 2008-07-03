Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYGCVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYGCVko (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756758AbYGCVgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:36:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50779 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754840AbYGCVgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:36:37 -0400
Message-Id: <20080703213633.668997502@attica.americas.sgi.com>
References: <20080703213348.489120321@attica.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jul 2008 16:33:59 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: [patch 11/13] GRU Driver V3 -  driver makefile
Content-Disposition: inline; filename=grup_driver_makefile
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the GRU driver makefile


Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/Makefile |    3 +++
 files changed, 27 insertions(+)

Index: linux/drivers/misc/sgi-gru/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux/drivers/misc/sgi-gru/Makefile	2008-06-10 09:26:14.933653473 -0500
@@ -0,0 +1,3 @@
+obj-$(CONFIG_SGI_GRU) := gru.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o
+

-- 
