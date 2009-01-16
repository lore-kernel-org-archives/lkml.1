Return-Path: <linux-kernel-owner+w=401wt.eu-S1764858AbZAPIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764858AbZAPIc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 03:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760577AbZAPI2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 03:28:14 -0500
Received: from smtp.nokia.com ([192.100.122.230]:29395 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762122AbZAPI2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 03:28:12 -0500
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Subject: [PATCH 10/10] omap mailbox: remove unnecessary header file inclusion
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org
Date: Fri, 16 Jan 2009 10:27:52 +0200
Message-ID: <20090116082752.17571.46074.stgit@oreo.research.nokia.com>
In-Reply-To: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
References: <20090116081919.17571.34378.stgit@oreo.research.nokia.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2009 08:27:54.0627 (UTC) FILETIME=[54248D30:01C977B4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
---

 arch/arm/plat-omap/mailbox.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index 79f5fb7..feb286c 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -21,15 +21,11 @@
  *
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
-#include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
-#include <linux/blkdev.h>
-#include <linux/err.h>
 #include <linux/delay.h>
-#include <linux/io.h>
+
 #include <mach/mailbox.h>
 
 static int enable_seq_bit;

