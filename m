Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200Ab0ATXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab0ATXvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754240Ab0ATXuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:55 -0500
Received: from kroah.org ([198.145.64.141]:33644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754066Ab0ATXuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:50:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Ping Cheng <pingc@wacom.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/8] serial: 8250_pnp: use wildcard for serial Wacom tablets
Date: Wed, 20 Jan 2010 15:49:58 -0800
Message-Id: <1264031403-32239-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100120234759.GC32068@kroah.com>
References: <20100120234759.GC32068@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

Wacom claims that the WACF namespace will always be devoted to serial
Wacom tablets.  Remove the existing entries and add a wildcard to avoid
having to update the kernel every time they add a new device.

Signed-off-by: Ping Cheng <pingc@wacom.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Tested-by: Ping Cheng <pingc@wacom.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/8250_pnp.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/serial/8250_pnp.c b/drivers/serial/8250_pnp.c
index b5496a1..24485cc 100644
--- a/drivers/serial/8250_pnp.c
+++ b/drivers/serial/8250_pnp.c
@@ -328,15 +328,7 @@ static const struct pnp_device_id pnp_dev_table[] = {
 	/* U.S. Robotics 56K Voice INT PnP*/
 	{	"USR9190",		0	},
 	/* Wacom tablets */
-	{	"WACF004",		0	},
-	{	"WACF005",		0	},
-	{       "WACF006",              0       },
-	{       "WACF007",              0       },
-	{       "WACF008",              0       },
-	{       "WACF009",              0       },
-	{       "WACF00A",              0       },
-	{       "WACF00B",              0       },
-	{       "WACF00C",              0       },
+	{	"WACFXXX",		0	},
 	/* Compaq touchscreen */
 	{       "FPI2002",              0 },
 	/* Fujitsu Stylistic touchscreens */
-- 
1.6.5.7

