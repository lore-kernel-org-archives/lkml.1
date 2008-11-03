Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbYKCLY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbYKCLY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142AbYKCLYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:24:20 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:42211 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755076AbYKCLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:24:19 -0500
Subject: [PATCH 7/8] hfa384x_usbin_callback: check for hardware removed
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: gregkh <gregkh@suse.de>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1225710353.3113.5.camel@castor.localdomain>
References: <1225710353.3113.5.camel@castor.localdomain>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:22:43 +0000
Message-Id: <1225711363.3113.30.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hfa384x_usbin_callback: check for hardware removed

copied from latest wlan-ng-devel version

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 4b1d24e..9184e27 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3788,7 +3788,7 @@ static void hfa384x_usbin_callback(struct urb *urb, struct pt_regs *regs)
 
 	if ( !wlandev ||
 	     !wlandev->netdev ||
-	     !netif_device_present(wlandev->netdev) )
+	     wlandev->hwremoved )
 		goto exit;
 
 	hw = wlandev->priv;
-- 
1.5.6.5



