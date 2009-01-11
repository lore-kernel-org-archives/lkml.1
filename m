Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbZAKTgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbZAKTgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZAKTg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:36:26 -0500
Received: from mail.suse.de ([195.135.220.2]:50644 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZAKTgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:36:25 -0500
Message-Id: <9785a8f8db3df0605fa680f44185957aff9d8776.1231695451.git.kkeil@suse.de>
In-Reply-To: <cover.1231695451.git.kkeil@suse.de>
References: <cover.1231695451.git.kkeil@suse.de>
From: Karsten Keil <kkeil@suse.de>
Date: Sun, 11 Jan 2009 17:58:13 +0100
Subject: [PATCH 2/7] Make parameter debug writable
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Karsten Keil <kkeil@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Overseen in the last patch series.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcpci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 917bf41..f0e14df 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -61,7 +61,7 @@ u32	hfc_jiffies;
 
 MODULE_AUTHOR("Karsten Keil");
 MODULE_LICENSE("GPL");
-module_param(debug, uint, 0);
+module_param(debug, uint, S_IRUGO | S_IWUSR);
 module_param(poll, uint, S_IRUGO | S_IWUSR);
 
 enum {
-- 
1.5.6.4

