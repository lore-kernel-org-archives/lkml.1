Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYLKWz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYLKWz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYLKWyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:54:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:41229 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823AbYLKWyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:54:39 -0500
Message-ID: <49419a2d.06a1660a.5c0a.ffff908c@mx.google.com>
To: netdev@vger.kernel.org
Cc: Karsten Keil <kkeil@suse.de>
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 11 Dec 2008 22:36:00 +0100
Subject: [PATCH 4/9][v2] mISDN: un-export symbol 'plx_lock'
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'plx_lock' is only used within hfcmulti.c.

Fix this warning:

  drivers/isdn/hardware/mISDN/hfcmulti.c:176:1: warning: symbol 'plx_lock' shadows an earlier one
  drivers/isdn/hardware/mISDN/hfcmulti.c:175:19: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Acked-by: Karsten Keil <kkeil@suse.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 599d832..970201d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -173,7 +173,6 @@ static int interrupt_registered;
 static struct hfc_multi *syncmaster;
 static int plxsd_master; /* if we have a master card (yet) */
 static spinlock_t plx_lock; /* may not acquire other lock inside */
-EXPORT_SYMBOL(plx_lock);
 
 #define	TYP_E1		1
 #define	TYP_4S		4
-- 
1.5.6.3

