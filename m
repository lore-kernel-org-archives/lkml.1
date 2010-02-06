Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab0BFRtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 12:49:16 -0500
Received: from cpsmtpm-eml110.kpnxchange.com ([195.121.3.14]:62987 "EHLO
	CPSMTPM-EML110.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932423Ab0BFRr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 12:47:28 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Cc: Frans Pop <elendil@planet.nl>, linux-cris-kernel@axis.com,
       Jiri Kosina <trivial@kernel.org>
Subject: [PATCH 12/16] cris/trivial: remove trailing space in message
Date: Sat,  6 Feb 2010 18:47:19 +0100
Message-Id: <1265478443-31072-12-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <201002061844.45212.elendil@planet.nl>
References: <201002061844.45212.elendil@planet.nl>
X-OriginalArrivalTime: 06 Feb 2010 17:47:26.0766 (UTC) FILETIME=[7225ECE0:01CAA754]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this case replaced with an extra period as an elipsis is usually
three periods.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: linux-cris-kernel@axis.com
Cc: Jiri Kosina <trivial@kernel.org>
---
 arch/cris/arch-v32/drivers/sync_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/sync_serial.c b/arch/cris/arch-v32/drivers/sync_serial.c
index d2a0fbf..e5634fa 100644
--- a/arch/cris/arch-v32/drivers/sync_serial.c
+++ b/arch/cris/arch-v32/drivers/sync_serial.c
@@ -448,7 +448,7 @@ static int sync_serial_open(struct inode *inode, struct file *file)
 	/* Allow open this device twice (assuming one reader and one writer) */
 	if (port->busy == 2)
 	{
-		DEBUG(printk(KERN_DEBUG "Device is busy.. \n"));
+		DEBUG(printk(KERN_DEBUG "Device is busy...\n"));
 		goto out;
 	}
 
-- 
1.6.6.1

