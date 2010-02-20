Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0BTUg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 15:36:26 -0500
Received: from 87-194-149-168.bethere.co.uk ([87.194.149.168]:64929 "EHLO
	svr2.cnick.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753268Ab0BTUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 15:36:25 -0500
From: chris.nicholson@cnick.org.uk
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: hv: fix brace coding style issue in Channel.c
Date: Sat, 20 Feb 2010 20:36:23 +0000
Message-Id: <1266698183-26781-1-git-send-email-chris.nicholson@cnick.org.uk>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 20 Feb 2010 20:35:27.0365 (UTC) FILETIME=[3C6FC350:01CAB26C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Nicholson <chris.nicholson@cnick.org.uk>

This is a patch to the Channel.c file that fixes up a brace
warning found by checkpatch.pl

Signed-off-by: Chris Nicholson <chris.nicholson@cnick.org.uk>
---
 drivers/staging/hv/Channel.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/Channel.c b/drivers/staging/hv/Channel.c
index 746370e..d46eb14 100644
--- a/drivers/staging/hv/Channel.c
+++ b/drivers/staging/hv/Channel.c
@@ -991,9 +991,8 @@ void VmbusChannelOnTimer(unsigned long data)
 {
 	struct vmbus_channel *channel = (struct vmbus_channel *)data;
 
-	if (channel->OnChannelCallback) {
+	if (channel->OnChannelCallback)
 		channel->OnChannelCallback(channel->ChannelCallbackContext);
-	}
 }
 
 /**
-- 
1.6.6

